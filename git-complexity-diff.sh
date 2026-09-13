working_diff() {
    git diff "$@"
    git ls-files --others --exclude-standard -z |
        xargs -0 -r -I '{}' git diff --no-index "$@" \
            -- /dev/null '{}'
}

print_number() {
    if [ "$1" -gt 0 ]; then
        printf '+'
    fi
    printf '%s\n' "$1"
}

echo -n 'Chars: '
added=$(working_diff | grep '^+' | grep -v '^+++' |
    cut -c2- | tr -d '\n' | wc -m)
removed=$(working_diff | grep '^-' | grep -v '^---' |
    cut -c2- | tr -d '\n' | wc -m)
print_number $((added - removed))

echo -n 'Lines: '
added_lines=$(working_diff --numstat |
    awk '{ added += $1 } END { print added+0 }')
removed_lines=$(working_diff --numstat |
    awk '{ removed += $2 } END { print removed+0 }')
print_number $((added_lines - removed_lines))

echo -n 'Long lines: '
added_long=$(working_diff --unified=0 |
    grep '^+' | grep -v '^+++' | cut -c2- |
    awk 'length > 60 { count++ }
        END { print count+0 }')
removed_long=$(working_diff --unified=0 |
    grep '^-' | grep -v '^---' | cut -c2- |
    awk 'length > 60 { count++ }
        END { print count+0 }')
print_number $((added_long - removed_long))
