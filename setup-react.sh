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
    npm run format
)

echo "Finished setting up react"
