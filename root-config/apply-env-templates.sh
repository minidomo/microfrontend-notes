#!/bin/sh

prefix="${CONFIG_ENV_PREFIX}"
file_regex="${CONFIG_FILE_REGEX}"
root_dir="${CONFIG_ROOT_DIR}"

# obtains only the environment variables that start with a given prefix and formats it
# to string matching: "$PREFIX_<name1>,$PREFIX_<name2>,..."
target_env_vars=$(printenv | awk -F= '{print $1}' | grep "^$prefix" | sed 's/^/\$/g' | paste -sd,)

if [ -n "$target_env_vars" ]; then
    (
        cd "${root_dir}"

        echo "Available files in ${root_dir}:"
        find . -type f
        
        files=$(find . -type f -regex "${file_regex}")

        if [ -z "$files" ]; then
            echo "Did not find any files with the regex: ${file_regex}"
            exit 0
        fi

        for file in $files; do
            echo "Matched ${file}"

            tmp=$(mktemp)
            chmod "$(stat -c "%a" $file)" $tmp
            envsubst $target_env_vars < "$file" > "$tmp"
            mv "$tmp" "$file"
        done
    )
fi
