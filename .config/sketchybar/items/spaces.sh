#!/usr/bin/env bash

# Clean up any old Mission Control space items from prior configs
for i in {1..15}; do
	sketchybar --remove "space.$i" >/dev/null 2>&1
done
sketchybar --remove spaces >/dev/null 2>&1
sketchybar --remove separator >/dev/null 2>&1
sketchybar --remove spacer.1 >/dev/null 2>&1
sketchybar --remove spacer.2 >/dev/null 2>&1
sketchybar --remove aero_spaces >/dev/null 2>&1
for i in {1..10}; do
	sketchybar --remove "aero_ws.$i" >/dev/null 2>&1
done
sketchybar --remove aero_ws_bracket >/dev/null 2>&1

# Controller item (hidden) to drive workspace updates
sketchybar --add item aero_spaces left \
	--set aero_spaces \
	update_freq=1 \
	script="$PLUGIN_DIR/aerospace_workspaces.sh" \
	drawing=off \
	updates=on \
	--subscribe aero_spaces aerospace_workspace_changed

# Individual workspace slots (colored per focused workspace)
for i in {1..10}; do
	sketchybar --add item "aero_ws.$i" left \
		--set "aero_ws.$i" \
		icon.drawing=off \
		label.color="$WHITE" \
		label.padding_left=4 \
		label.padding_right=4 \
		background.drawing=off \
		drawing=off
done

# Bracket to provide bordered background behind the workspace items
sketchybar --add bracket aero_ws_bracket '/^aero_ws\..*/' \
	--set aero_ws_bracket \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$RED" \
	background.corner_radius="$CORNER_RADIUS" \
	background.color="$BAR_COLOR" \
	background.height=26 \
	background.drawing=on \
	associated_display=active

# Reintroduce separator arrow after workspaces
sketchybar --add item aero_ws_separator left \
	--set aero_ws_separator icon= \
	icon.font="$FONT:Regular:15.0" \
	background.padding_left=8 \
	background.padding_right=8 \
	label.drawing=off \
	icon.color="$YELLOW" \
	associated_display=active

# Run once immediately so the bar is populated without waiting for the first tick.
"$PLUGIN_DIR/aerospace_workspaces.sh" >/dev/null 2>&1
