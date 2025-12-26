#!/usr/bin/env bash

COLOR="$GREEN"

sketchybar --add item spotify center \
	--set spotify \
	update_freq=5 \
	scroll_texts=on \
	icon=󰎆 \
	icon.color="$COLOR" \
	icon.padding_left=8 \
	background.color="$BAR_COLOR" \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$COLOR" \
	background.padding_left=-2 \
	background.padding_right=-5 \
	background.drawing=on \
	label.padding_right=10 \
	label.max_chars=23 \
	associated_display=active \
	updates=on \
	script="$PLUGIN_DIR/spotify.sh" \
	--subscribe spotify media_change
