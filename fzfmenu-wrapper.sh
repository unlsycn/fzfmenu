#!/bin/env bash

pipe_input=$1
pipe_output=$2
shift 2
cat ${pipe_input} | fzf "$@" >${pipe_output}
