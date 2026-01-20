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

    npm update --save
    npm i single-spa@latest single-spa-layout@latest
    npm i @types/node@22 dotenv -D

    touch .env .env.example .env.production

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
    require('dotenv').config({ path: ".env.production" });\
} else {\
    require('dotenv').config();\
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

    sed -i '/<%/d' "$ejs_file"
    sed -i '/import-map-injector.js/d' "$ejs_file"
    sed -i '/single-spa-welcome/d' "$ejs_file"
    sed -i '/rel="preload"/d' "$ejs_file"
    sed -i 's/injector-importmap/systemjs-importmap/g' "$ejs_file"
    sed -i 's|esm/single-spa.min.js|system/single-spa.min.js|g' "$ejs_file"
    sed -i '/Shared dependencies go into this import map/a\
<script src="https://cdn.jsdelivr.net/npm/systemjs@6.15.1/dist/system.min.js"></script>\
<script src="https://cdn.jsdelivr.net/npm/systemjs@6.15.1/dist/extras/amd.min.js"></script>
' "$ejs_file"


    npm run format
)

echo "Finished setting up root-config"
