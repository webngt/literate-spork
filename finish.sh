#!/bin/bash

mod_path="/root"

modules=$(find $mod_path -type d -name go -prune -o -name go.mod -print)
res=$?

# unexpected error while finding modules
[ $res -eq 1 ] && jq --null-input --arg error "$modules" '{"error": $error, "result": "" }' && exit 1

# no module found
[ "$modules" = "" ] && jq --null-input --arg error "no module found in path $mod_path" '{"error": $error, "result": "" }' && exit 1


errors=""
result=""


for module in $modules
do
    echo $(dirname $module)
    
    cd $(dirname $module)

    # run linter
    l=$(golangci-lint run ./...)
    res=$?

    [ $res -eq 1 ] && errors="$errors$l" || result="$result$l"

    # run unit tests
    t=$(go test ./...)
    res=$?

    [ $res -eq 1 ] && errors="$errors$t" || result="$result$t"


done

jq --null-input --arg error "$errors" --arg result "$result" '{"error": $error, "result": $result }'