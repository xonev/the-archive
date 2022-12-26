#!/bin/bash

function test_no_return() {
    rm nofile
}

test_no_return
echo $?

touch nofile
test_no_return
echo $?


function test_return() {
    rm nofile
    return
}

test_return
echo $?

touch nofile
test_return

echo $?

