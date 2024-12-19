#!/usr/bin/env bash

name=${1:-fzfmenu}
shift 1

genRandomFifo() { echo "/tmp/fzfmenu-$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)"; }
pipe_input=$(genRandomFifo)
pipe_output=$(genRandomFifo)
mkfifo ${pipe_input} ${pipe_output}

cat >>${pipe_input} <&0 &
{
    hyprctl clients | rg "title: ${name}$" || alacritty -T ${name} -o 'font.size=18' -e bash fzfmenu-wrapper ${pipe_input} ${pipe_output} "$@"
    hyprctl dispatch focuswindow "title:${name}$"
} &>/dev/null &
cat ${pipe_output}

rm ${pipe_input} ${pipe_output}
