#!/bin/zsh

echo "${(q)@}"
echo "test ${(q)@}"
foo="test ${(q)@}"
echo $foo
