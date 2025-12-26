#!/usr/bin/env sh

source "$HOME/.config/sketchybar/variables.sh"

BATTERY_DATA="$(pmset -g batt)"
PERCENTAGE="$(printf '%s' "$BATTERY_DATA" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
CHARGING="$(printf '%s' "$BATTERY_DATA" | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

TEXT_COLOR="$LABEL_COLOR"
ACCENT_COLOR="$BLUE"
SUCCESS_COLOR="$GREEN"
WARNING_COLOR="$YELLOW"
ALERT_COLOR="$RED"

ICON=""
ICON_COLOR="$SUCCESS_COLOR"
LABEL_COLOR="$TEXT_COLOR"

if [ -n "$CHARGING" ]; then
  ICON=""
  ICON_COLOR="$ACCENT_COLOR"
else
  case "$PERCENTAGE" in
    9[0-9]|100)
      ICON=""
      ICON_COLOR="$SUCCESS_COLOR"
      ;;
    [6-8][0-9])
      ICON=""
      ICON_COLOR="$SUCCESS_COLOR"
      ;;
    [3-5][0-9])
      ICON=""
      ICON_COLOR="$WARNING_COLOR"
      ;;
    [2][0-9]|1[5-9])
      ICON=""
      ICON_COLOR="$WARNING_COLOR"
      ;;
    *)
      ICON=""
      ICON_COLOR="$ALERT_COLOR"
      LABEL_COLOR="$ALERT_COLOR"
      ;;
  esac
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$ICON_COLOR" \
  label="${PERCENTAGE}%" \
  label.color="$LABEL_COLOR"
