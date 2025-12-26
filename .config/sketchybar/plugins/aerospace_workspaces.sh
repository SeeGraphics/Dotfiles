#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"

MAX_WS=10

if ! command -v aerospace >/dev/null 2>&1; then
	# Show a single slot with error text
	sketchybar --set aero_ws.1 drawing=on label="AeroSpace CLI missing" label.color="$RED"
	for i in $(seq 2 $MAX_WS); do sketchybar --set aero_ws.$i drawing=off; done
	exit 0
fi

ALL_JSON="$(aerospace list-workspaces --all --json 2>/dev/null)"
FOCUSED_JSON="$(aerospace list-workspaces --focused --json 2>/dev/null)"

if [ -z "$ALL_JSON" ] || printf '%s' "$ALL_JSON" | grep -qi "can't connect"; then
	sketchybar --set aero_ws.1 drawing=on label="AeroSpace not running" label.color="$RED"
	for i in $(seq 2 $MAX_WS); do sketchybar --set aero_ws.$i drawing=off; done
	exit 0
fi

mapfile -t ALL_WS < <(printf '%s' "$ALL_JSON" | jq -r '.[] | (.name // .workspace // .id // empty)')
FOCUSED_WS="$(printf '%s' "$FOCUSED_JSON" | jq -r 'if type=="array" then (.[0] // {}) else . end | (.name // .workspace // .id // empty)')"

if [ ${#ALL_WS[@]} -eq 0 ]; then
	ALL_WS=("No workspaces")
fi

count=${#ALL_WS[@]}
if [ $count -gt $MAX_WS ]; then
	count=$MAX_WS
fi

# Ensure deterministic padding to avoid jitter while hiding unused slots.
for i in $(seq 1 $MAX_WS); do
	if [ $i -le $count ]; then
		ws="${ALL_WS[$((i - 1))]}"
		color="$WHITE"
		if [ "$ws" = "$FOCUSED_WS" ]; then
			color="$RED"
		fi

		pad_left=4
		pad_right=4
		if [ $i -eq 1 ]; then pad_left=8; fi
		if [ $i -eq $count ]; then pad_right=8; fi

		sketchybar --set aero_ws.$i drawing=on label="$ws" label.color="$color" label.padding_left=$pad_left label.padding_right=$pad_right label.align=center label.width=22
	else
		sketchybar --set aero_ws.$i drawing=off
	fi
done
