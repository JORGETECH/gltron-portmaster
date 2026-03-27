# GLtron for PortMaster devices

This is a version of the open source videogame called GLtron, inspired by the lighcycle game of the famous movie Tron. This version was started as a fork from the SDL2/Etnaviv port made by @laanwj, which is in turn based on the original codebase by Andreas Umbach.

More modifications (or hacks, really) have been made on top of laanwj's code in order to modernize it and make it work better in modern devices and compilation environments. For example, the joystick initialization code has been disabled since it conflicts with button remapping in devices targeted by PortMaster (double key presses), instead we want to remap to keyboard keys with the gptokeyb software. An additional option has been added to the autotools configure script for fixing modern GCC compilation errors (-fpermissive). Sound support has been restored. Also, some more sane defaults for handheld devices have been set in the default game configuration scripts (mainly, setting the screen resolution to 640x480).

The compilation of the project has been tested in a Debian Bookworm aarch64 build environment but it should compile just fine in any other modern environment with the use of the already mentioned configure option.

# Basic compilation instructions

Set up your preferred build environment, the next packages should be installed:

- smpeg
- ogg
- vorbis
- vorbisfile
- mikmod
- SDL2
- SDL_sound (version compatible with SDL2)

For example, in Debian based distros, this command should install all the dependencies (may change if using a cross-compiling environment):

```
sudo apt install git build-essential libsmpeg-dev libogg-dev libvorbis-dev libmikmod-dev libsdl2-dev libsdl-sound1.2-dev
```

It is also recommended to manually get and compile SDL_sound directly from the official icculus source, most Linux distros ship a version that is meant to be used with SDL 1.2 based software, however, this codebase needs a version that is compatible with SDL2, you can get the correct version by running the next command:

```
git clone --branch stable-2.0 https://github.com/icculus/SDL_sound
```

And compile it with the next commands:

```
cd SDL_sound
mkdir build && cd build
cmake ..
make
```

You should also copy the SDL_sound headers from icculus to the GLtron source tree so it overrides the ones bundled by your distro:

```
cp ../src/SDL_sound.h ../../gltron-portmaster/nebu/include/audio
cp ../src/SDL_sound.h ../../gltron-portmaster/src/audio
```

For compiling GLtron enter in it's source tree and execute the next commands:

```
./autogen.sh
./configure --enable-localdata --enable-optimize=2
make
make DESTDIR=$PWD/dist install
```

The "--enable-localdata" option is stronly recommended so the game files are portable between environments, otherwise the game will try to look for them in /usr/local. The example "make install" command puts the files inside an "usr" folder in the "dist" folder, where the rest of the PortMaster specific files are present, after installation the game files should be reorganized so the binary and game data is inside the "dist" folder, then you can delete the "usr" folder.

# Special thanks to...

@binarycounter for creating Westonpack and giving me a lot of advice on how to use it properly.

@Cebion for giving me advice on disabling the joystick code for fixing input with gptokeyb.

@Dia2809 for reviewing my game init scripts which had a lot of mistakes :) .

All the PortMaster and gptokeyb devs for making porting Linux games easier to Linux handheld consoles.

Andreas Umbach for creating the original GLtron, and of course, also thanks to all it's contributors.

Peter Hajba (Skaven) for creating the amazing soundtrack for the game.
