#!/bin/sh

screens=$(wlr-randr --json | jq '.[].name' | sed 's/\"//g')
count=$(printf "%s\n" "$screens" | wc -l)

if [ $count -gt 1 ]; then
	printf "%s" "$screens" | tofi
else
	printf "%s\n" "$screens"
fi
