## Notes

Port by JORGETECH, based on [GLtron SDL2 port for Etnaviv drivers by laanwj](https://github.com/laanwj/gltron).

Modified port source [here](https://github.com/JORGETECH/gltron-portmaster).

Compiled for OpenGL devices (running on top of GL4ES).

**Special thanks to:**
* Andreas Umbach and all of the GLtron contributors, for creating the original codebase.
* The [Debian Games Team](https://qa.debian.org/developer.php?login=pkg-games-devel%40lists.alioth.debian.org), for providing some patches that fix issues on modern systems.
* [@binarycounter](https://github.com/binarycounter) for creating Westonpack and giving me a lot of advice on how to use it properly.
* [@Cebion](https://github.com/Cebion) for giving me advice on disabling the joystick code for fixing input with gptokeyb.
* [@Dia2809](https://github.com/Dia2809) for reviewing my game init scripts which had a lot of mistakes :) .
* Peter Hajba (Skaven) for creating the amazing soundtrack for the game.

## Controls

| Button | Action |
|--|--| 
|Up|Move up in menu|
|Down|Move down in menu|
|Left|Turn lightcycle left, move left in menu|
|Right|Turn lightcycle right, move right in menu|
|A|Booster|
|B|Wall buster|
|X|Booster|
|Y|Wall buster|
|Start|Select option in menu|
|Select|Go back in menu, pause game|
|L1|Glance left|
|L2|Left mouse click, zoom out camera|
|L3|Left mouse click, zoom out camera|
|R1|Glance right|
|R2|Right mouse click, zoom in camera|
|R3|Right mouse click, zoom in camera|
|Left analog stick|Same as dpad|
|Right analog stick|Move mouse, move camera|


## Compile

```shell
Set up your preferred build environment, the next packages should be installed:

- smpeg
- ogg
- vorbis
- vorbisfile
- mikmod
- SDL2
- SDL_sound (version compatible with SDL2)

For example, in Debian based distros, this command should install all the dependencies (may change if using a cross-compiling environment):

sudo apt install git build-essential libsmpeg-dev libogg-dev libvorbis-dev libmikmod-dev libsdl2-dev libsdl-sound1.2-dev

It is also recommended to manually get and compile SDL_sound directly from the official icculus source, most Linux distros ship a version that is meant to be used with SDL 1.2 based software, however, this codebase needs a version that is compatible with SDL2, you can get the correct version by running the next command:

git clone --branch stable-2.0 https://github.com/icculus/SDL_sound

And compile it with the next commands:

cd SDL_sound
mkdir build && cd build
cmake ..
make

You should also copy the SDL_sound headers from icculus to the GLtron source tree so it overrides the ones bundled by your distro:

cp ../src/SDL_sound.h ../../gltron-portmaster/nebu/include/audio
cp ../src/SDL_sound.h ../../gltron-portmaster/src/audio

For compiling GLtron enter in it's source tree and execute the next commands:

./autogen.sh
./configure --enable-localdata --enable-optimize=2
make
make DESTDIR=$PWD/dist install

The "--enable-localdata" option is stronly recommended so the game files are portable between environments, otherwise the game will try to look for them in /usr/local. The example "make install" command puts the files inside an "usr" folder in the "dist" folder, where the rest of the PortMaster specific files are present, after installation the game files should be reorganized so the binary and game data is inside the "dist" folder, then you can delete the "usr" folder.
```
