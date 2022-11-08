#!/bin/sh

source $HOME/functions.sh

COMMAND=$1

declare -A OUTPUTS=(
  [eDP-1]=amdgpu_bl0
  [DP-1]=ddcci6
)

#FOCUSED_OUTPUT=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
DEVICE=${OUTPUTS[$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')]}

brightness () {
  brightnessctl --device $DEVICE "$@"
}

show_notification () {
  max=$(brightness max)
  value=$(brightness get)
  #percentage=$((value * 100 / max))
  percentage=$(printf %.0f $(echo "($value * 100 / $max)" | bc -l))

  progress=$(progress_bar \
    value=$percentage \
    steps=5 \
    symbol_full=" " \
    symbol_empty=" " \
    format="<span font='7' font_family='Font Awesome 5 Pro'><b>"`
      `"<span foreground='#e5e9f0'>%{full}</span>"`
      `"<span foreground='#3b4252'>%{empty}</span>"`
    `"</b></span>")

  notify-send.sh \
    -R /tmp/system-notification \
    -c "desktop.adjust" \
    -t 2000 \
    -i brightness-adjust-2 \
    "Brightness ${percentage}%" \
    "${progress}"
}

case $COMMAND in

  "up")
    brightness set +5% > /dev/null 2>&1
    show_notification
    ;;

  "down")
    brightness set 5%- > /dev/null 2>&1
    show_notification
    ;;

  "set")
    brightness set $2 > /dev/null 2>&1
    show_notification
    ;;

  *)
    brightness get
    ;;

esac
