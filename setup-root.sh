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
        sed -i '/disableHtmlGeneration/a\
outputSystemJS: true,
' webpack.config.js
    fi

    if ! grep -q "dotenv" webpack.config.js; then

        sed -i '/return merge/i\
if (defaultConfig.mode === "production") {\
    require('dotenv').config({ path: ".env.production" });\
} else {\
    require('dotenv').config();\
}
' webpack.config.js
    fi
)
