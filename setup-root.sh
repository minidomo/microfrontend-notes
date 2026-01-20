#!/bin/sh

target_dir="$(pwd)"

if [ -n "$1" ]; then
    target_dir="$(cd "$1" 2>/dev/null && pwd)"
fi

(
    cd "$target_dir"

    if [ ! -f "package.json" ]; then
        echo "No package.json found"
        exit 1
    fi

    if ! grep -q "single-spa" package.json; then
        echo "single-spa not found"
        exit 1
    fi

    rm -rf .husky .git
    sed -i '/husky/d' package.json
    sed -i '/pretty-quick/d' package.json

    if ! grep -q "outputSystemJS" webpack.config.js; then
        # specify systemjs output
        sed -i '/disableHtmlGeneration/a\
outputSystemJS: true,
' webpack.config.js
    fi

    if ! grep -q "dotenv" webpack.config.js; then
        # use .env file based on mode
        sed -i '/return merge/i\
if (defaultConfig.mode === "production") {\
    require("dotenv").config({ path: ".env.production" });\
} else {\
    require("dotenv").config();\
}
' webpack.config.js
    fi

    root_config_file=$(find src -type f -name "*root-config*" -print -quit)

    # ensure we use systemjs import
    sed -i '/return import/c\
return System.import(name);
' "$root_config_file"

    # the update the ejs template
    ejs_file=$(find src -type f -name "*.ejs" -print -quit)

    sed -i '/"importmap-type" use-injector/c\
<meta name="importmap-type" content="systemjs-importmap" />
' "$ejs_file"

    if grep -q "isLocal" "$ejs_file"; then
        # remove default isLocal check
        sed -i '/<%/d' "$ejs_file"
    fi

    sed -i '/import-map-injector.js/d' "$ejs_file"
    sed -i '/rel="preload"/d' "$ejs_file"
    sed -i '/single-spa-welcome/d' "$ejs_file"
    sed -i 's/injector-importmap/systemjs-importmap/g' "$ejs_file"
    sed -i 's|esm/single-spa.min.js|system/single-spa.min.js|g' "$ejs_file"

    if ! grep -q "cdn.jsdelivr.net/npm/systemjs" "$ejs_file"; then
        # add systemjs dependencies
        sed -i '/Shared dependencies go into this import map/a\
<script src="https://cdn.jsdelivr.net/npm/systemjs@6.15.1/dist/system.min.js"></script>\
<script src="https://cdn.jsdelivr.net/npm/systemjs@6.15.1/dist/extras/amd.min.js"></script>
' "$ejs_file"
    fi

    if ! grep -q "ROOT_CONFIG_URL" "$ejs_file"; then
        # create env files with url
        original_url=$(awk -F\" '/root-config"/ { print $(NF-1) }' "$ejs_file")
        echo "ROOT_CONFIG_URL=http:$original_url" > .env
        echo "ROOT_CONFIG_URL=http:$original_url" > .env.example
        echo "ROOT_CONFIG_URL=\$PROJECT123_ROOT_CONFIG_URL" > .env.production

        # add root config url variable to template parameters
        awk '
/orgName,/ { last = NR }
{ lines[NR] = $0 }
END {
    for (i = 1; i <= NR; i++) {
        print lines[i]
        if (i == last)
            print "ROOT_CONFIG_URL: process.env.ROOT_CONFIG_URL,"
    }
}
' webpack.config.js | tee webpack.config.js

        # insert root config url variable in ejs file
        sed -i 's|\(root-config": "\)[^"]*",|\1<%= ROOT_CONFIG_URL %>"|' "$ejs_file"
    fi

    if grep -q "window.importMapInjector.initPromise" "$ejs_file"; then
        # use system.import
        name=$(awk -F\" '/"name"/ { print $4 }' package.json)
        sed -i "/window\.importMapInjector\.initPromise/i\
System.import('$name');
" "$ejs_file"
        sed -i '/window\.importMapInjector\.initPromise/,+2d' "$ejs_file"
    fi

    html_file=$(find src -type f -name "*.html" -print -quit)

    # update html file without default single spa welcome
    sed -i '\|single-spa/welcome|c\
This is working with SystemJS!
' "$html_file"

    types_file=$(find src -type f -name "*.d.ts" -print -quit)

    # fix export method
    sed -i 's/export = rawHtmlFile/export default rawHtmlFile/' "$types_file"

    npm update --save
    npm i single-spa@latest single-spa-layout@latest
    npm i @types/node@22 dotenv -D
    npm run format
)

echo "Finished setting up root-config"
