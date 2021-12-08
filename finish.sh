#!/bin/bash

mod_path="/root"

modules=$(find $mod_path -type d -name go -prune -o -name go.mod -print)

# unexpected error while finding modules
[ "$?" = "1" ] && jq --null-input --arg error "$modules" '{"error": $error, "result": "" }' && exit 1

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

    echo "lintextit=$?"

    [ "$?" = "1" ] && errors="$errors$l"
    [ "$?" = "0" ] && result="$result$l"

    # run unit tests
    t=$(go test ./...)

    echo "testexit=$?"


    [ "$?" = "1" ] && errors="$errors$t"
    [ "$?" = "0" ] && result="$result$t"


done

#echo -n "$error"
echo -n "$result"

#jq --null-input --arg error "$errors" --arg result="$result" '{"error": $errors, "result": $result }'