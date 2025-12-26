#!/usr/bin/env sh

source "$HOME/.config/sketchybar/variables.sh"

# Refresh the volume widget whenever the system volume changes or when forced
# via `sketchybar --update`.
COLOR_ACCENT="$CYAN"
COLOR_WARNING="$YELLOW"
COLOR_ALERT="$RED"
TEXT_COLOR="$LABEL_COLOR"

VOLUME="$INFO"
if [ -z "$VOLUME" ]; then
  VOLUME="$(osascript -e 'output volume of (get volume settings)')"
fi

MUTED="$(osascript -e 'output muted of (get volume settings)')"

ICON="󰕾"
ICON_COLOR="$COLOR_ACCENT"
LABEL="${VOLUME}%"
LABEL_COLOR="$TEXT_COLOR"

if [ "$MUTED" = "true" ]; then
  ICON="󰝟"
  ICON_COLOR="$COLOR_ALERT"
  LABEL="Muted"
  LABEL_COLOR="$COLOR_ALERT"
else
  case "$VOLUME" in
    9[0-9]|100)
      ICON="󰕾"
      ICON_COLOR="$COLOR_ACCENT"
      ;;
    [6-8][0-9])
      ICON="󰖀"
      ICON_COLOR="$COLOR_ACCENT"
      ;;
    [3-5][0-9])
      ICON="󰕿"
      ICON_COLOR="$COLOR_WARNING"
      ;;
    [1-2][0-9]|[1-9])
      ICON="󰖁"
      ICON_COLOR="$COLOR_WARNING"
      ;;
    0)
      ICON="󰖁"
      ICON_COLOR="$COLOR_WARNING"
      LABEL="Silent"
      ;;
  esac
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$ICON_COLOR" \
  label="$LABEL" \
  label.color="$LABEL_COLOR"
