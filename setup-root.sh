#!/bin/sh

target_dir="$(pwd)"

if [ -n "$1" ]; then
    target_dir="$(cd "$1" 2>/dev/null && pwd)"
fi

rm -rf "$target_dir/.husky" "$target_dir/.git"
sed -i '/husky/d' "$target_dir/package.json"
sed -i '/pretty-quick/d' "$target_dir/package.json"
