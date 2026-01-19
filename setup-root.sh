#!/bin/sh

target_dir="$(pwd)"

if [ -n "$1" ]; then
    target_dir="$(cd "$1" 2>/dev/null && pwd)"
fi

(
    cd "$target_dir"
    rm -rf .husky .git
    sed -i '/husky/d' package.json
    sed -i '/pretty-quick/d' package.json

    npm update --save
    npm i single-spa@latest single-spa-layout@latest
    npm i @types/node@22 dotenv -D

    touch .env .env.example .env.production

    sed -i '/disableHtmlGeneration/a\
outputSystemJS: true,
' webpack.config.js

    set -i '//i\
    
' webpack.config.js
)
