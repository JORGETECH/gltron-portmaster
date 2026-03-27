#!/bin/bash

# PortMaster preamble
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi
source $controlfolder/control.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

# Adjust these to your paths
GAMEDIR=/$directory/ports/gltron-sdl2
game_executable="gltron"
gptk_filename="gltron.gptk"
game_libs=$GAMEDIR/libs.${DEVICE_ARCH}/:$LD_LIBRARY_PATH
x11sdl_path="$GAMEDIR/x11sdllib/"
# Logging
> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

# Detect if we are running in ROCKNIX, since the game breaks
if [[ "$CFW_NAME" == "ROCKNIX" ]]; then
  export rocknix_mode=1
fi

# Mount Weston runtime, except if using ROCKNIX
weston_dir=/tmp/weston
$ESUDO mkdir -p "${weston_dir}"
weston_runtime="weston_pkg_0.2"
if [ ! -f "$controlfolder/libs/${weston_runtime}.squashfs" ]; then
  if [ ! -f "$controlfolder/harbourmaster" ]; then
    pm_message "This port requires the latest PortMaster to run, please go to https://portmaster.games/ for more info."
    sleep 5
    exit 1
  fi
  $ESUDO $controlfolder/harbourmaster --quiet --no-check runtime_check "${weston_runtime}.squashfs"
fi
if [[ "$PM_CAN_MOUNT" != "N" ]]; then
    $ESUDO umount "${weston_dir}"
fi
$ESUDO mount "$controlfolder/libs/${weston_runtime}.squashfs" "${weston_dir}"

cd $GAMEDIR
$GPTOKEYB "$game_executable" -c "$GAMEDIR/$gptk_filename" &

# Detect presence of existing .gltronrc confifuration file and copy default config from port folder if it doesn't exist
if test -e "$HOME/.gltronrc"; then
  echo "Config file exists, leaving it alone"
else
  echo "Config file not present, copying default config file"
  \cp -f "$GAMEDIR/.gltronrc" "$HOME/.gltronrc"
fi

# Start Westonpack, except if running ROCKNIX in which case we run the executable directly (Westonpack in ROCKNIX crashes with this game)
# Put CRUSTY_SHOW_CURSOR=1 after "env" if you need a mouse cursor
if [[ "$rocknix_mode" == 1 ]]; then
  LD_LIBRARY_PATH=$GAMEDIR/gl4es/:$game_libs ./gltron
else
  $ESUDO env WRAPPED_LIBRARY_PATH_MALI="$x11sdl_path" WRAPPED_PRELOAD_MALI="$x11sdl_path/libSDL2-2.0.so.0" \
  WRAPPED_LIBRARY_PATH=$game_libs \
  $weston_dir/westonwrap.sh headless noop kiosk crusty_glx_gl4es \
  WAYLAND_DISPLAY= XDG_DATA_HOME=$CONFDIR $GAMEDIR/$game_executable
fi

#Clean up after ourselves
$ESUDO $weston_dir/westonwrap.sh cleanup
if [[ "$PM_CAN_MOUNT" != "N" ]]; then
    $ESUDO umount "${weston_dir}"
fi
pm_finish
