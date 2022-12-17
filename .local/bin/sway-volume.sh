#!/bin/sh

source $HOME/functions.sh

DEVICE=$1
COMMAND=$2

function mixer () {
  args=()
  [[ "$DEVICE" == "source" ]] && args+=(--default-source)
  pamixer "${args[@]}" "$@"
}

show_notification () {
  muted=$(mixer --get-mute)
  icon="volume-$DEVICE"

  [[ "$muted" = "true" ]] && volume=0 || volume=$(mixer --get-volume)
  [[ "$muted" = "true" ]] && icon+="-muted"
  [[ "$muted" = "true" ]] && micmute_led_state=1 || micmute_led_state=0
  [[ $DEVICE = "source" ]] && brightnessctl -d "platform::micmute" s $micmute_led_state

  progress=$(progress_bar \
    value=$volume \
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
    -i $icon \
    "Volume ${volume}%" \
    "${progress}"

}

case $COMMAND in

  "up")
    mixer --unmute --increase 5
    show_notification
    ;;

  "down")
    mixer --unmute --decrease 5
    show_notification
    ;;

  "toggle")
    mixer --toggle-mute
    show_notification
    ;;

  *)
    mixer --get-volume-human
    ;;

  esac
