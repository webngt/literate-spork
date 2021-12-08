#!/bin/sh

mod_path="/root"

modules=$(find $mod_path -type d -name go -prune -o -name go.mod -print)

# unexpected error while finding modules
[ "$?" = "1" ] && jq --null-input --arg error "$modules" '{"error": $msg, "result": "" }' && exit 1

# no module found
[ "$modules" = "" ] && jq --null-input --arg error "no module found in path $mod_path" '{"error": $msg, , "result": "" }' && exit 1


errors=""
result=""

for module in $modules
do
    d=$(dirname $module)

    # run linter
    l = $(golangci-lint run $d)

    [ "$?" = "1" ] && errors="$errors$l"
    [ "$?" = "0" ] && result="$result$l"

    # run unit tests
    t = $(go test $d)

    [ "$?" = "1" ] && errors="$errors$t"
    [ "$?" = "0" ] && result="$result$t"


done

jq --null-input --arg error "$errors" --arg result="$result" '{"error": $errors, , "result": $result }'
