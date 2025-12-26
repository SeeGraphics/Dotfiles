#!/usr/bin/env bash

# Poll Spotify directly so the widget stays visible even if media_change events misbehave.
STATE_RAW="$(osascript <<'EOF'
tell application "System Events"
	set isRunning to (exists process "Spotify")
end tell
if isRunning then
	tell application "Spotify"
		set playerState to player state as text
		if playerState is "playing" then
			set trackName to name of current track
			set artistName to artist of current track
			return "playing|" & trackName & " - " & artistName
		else if playerState is "paused" then
			return "paused|Paused"
		else
			return "stopped|Not Playing"
		end if
	end tell
else
	return "stopped|Spotify not running"
end if
EOF
)"

STATUS="${STATE_RAW%%|*}"
LABEL="${STATE_RAW#*|}"

if [ "$STATUS" = "playing" ]; then
	sketchybar --set "$NAME" drawing=on label="$LABEL"
else
	sketchybar --set "$NAME" drawing=off label="$LABEL"
fi
