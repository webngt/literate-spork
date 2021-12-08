#!/bin/bash

mod_path="/root"

modules=$(find $mod_path -type d -name go -prune -o -name go.mod -print)
res=$?

# unexpected error while finding modules
[ $res -eq 1 ] && jq --null-input --arg error "$modules" '{"error": $error }' && exit 1

# no module found
[ "$modules" = "" ] && \
jq --null-input --arg error "no module found in path $mod_path" '{"error": $error }' && exit 1


for module in $modules
do  
    mod_dir=$(dirname $module)  
    cd $mod_dir

    # run linter
    linter_out=$(golangci-lint run ./...)

    # run unit tests
    unit_test_fail=""
    unit_test_ok=""
    unit_test_out=$(go test .)
    res=$?

    [ $res -eq 1 ] && unit_test_fail=$unit_test_out || unit_test_ok=$unit_test_out

    jq --null-input \
    --arg linter_out "$linter_out" \
    --arg unit_test_fail "$unit_test_fail" \
    --arg unit_test_ok "$unit_test_ok" \
    --arg mod_dir "$mod_dir" \
    '{"linter_out": $linter_out, "unit_test_fail": $unit_test_fail, "unit_test_ok": $unit_test_ok, "mod_dir": $mod_dir }'
done | jq -n '.results |= [inputs]'