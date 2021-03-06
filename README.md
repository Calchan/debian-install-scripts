> […] playing jedi: fallen order (or whatever the name is)
>
> And man, without cmd line args the game runs at 15-30 fps, really unstable
>
> But `run-game %command%` brings it to stable 30 medium settings with less power than the first test

_A happy GPD Win 3 user_

(`run-game` is what enables the automatic game optimizations and optional frame rate capping to save
power, read all about it below)


# Debian install scripts

These scripts help you automatically set up a lean but full-featured Linux install that's easy to
manage and maintain. They're split in multiple parts so you can pick and choose what you install.
Just so you know, I use this on my work laptop and gaming desktop. It works.

One of the optional scripts is to prepare your machine for gaming to a point it makes owning a
Windows install useless. I have thousands of Windows games and, although I haven't tried them all,
all those I've tried worked without exception. Not only that but they typically work as fast or
faster than on Windows. How about ~25fps in GTA5 at 720p on a dumb old Skylake laptop with
integrated graphics?

None of this is rocket science. Just a collection of settings and tricks, with a goal of simplicity
and reproducibility. Some fixes also, like for example with GameMode. I don't know how people use it
but some of it, the most important in my opinion, is broken out of the box. There are some
convenience scripts too, read all about them below.

Finally, these scripts work well but they don't look as nice or clean as I would want it. They grew
organically over the years and it shows. Patches welcome.


## Preparations

1. Read these instructions entirely and carefully.

2. Download the non-edu ISO image from
[this directory](https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current/amd64/iso-cd/)
and `dd` or `cp` it to a USB stick at least 1GB in size.

3. Download the scripts in this repository and copy them to a FAT32-formatted USB stick. The Debian
   image is read-only so you can't put the scripts on your first stick. However, once you're done
   with the first part (see below) and rebooted, you can reformat it to FAT32 and copy the scripts
   to it using another machine. Alternatively, once rebooted after the first part you can do this
   instead:
   ```
   cd /tmp
   apt install git
   git clone https://github.com/Calchan/debian-install-scripts
   ```

4. Wired networking is recommended, at least for the second part. Either ethernet, or a
   USB-to-ethernet adapter. I always use a USB-tethered cell-phone out of habit. Make sure it's on
   WiFi because there's going to be a lot to download. In case you really want to use your
   computer's WiFi for the second part of the installation process instead of wired networking, you
   must do the first part (the actual Debian install) using the same interface so that the
   installation software detects and installs all that's needed. Then, once rebooted for the second
   part, locate your WiFi interface using `ip a` (it's the one or one of those starting with `wl`).
   Finally, run:
   ```
   wpa_passphrase '<your WiFi SSID> '<your WiFi passphrase>' > /tmp/wpa
   wpa_supplicant -c /tmp/wpa -i <your WiFi interface> &
   dhclient
   ```
   It's not unlikely your connection will drop multiple times (some scripts require _a lot of_
   downloads). Watch the output of the scripts and if any error occurs just restart the script until
   it no longer shows any error before you move to the next one. All scripts are written so that
   they will renegotiate with your WiFi AP when necessary, although that too is not completely
   fail-proof.
   If it doesn't work then RTFM or just use wired networking like recommended above. Once the
   installation is complete you'll be able to use WiFi just fine, obviously.


## Debian installation (a.k.a. first part)

Boot the Debian ISO image and do your thing.

You can install this along a Windows system, just make sure you have enough space available.

If you use UEFI and don't reuse an already existing EFI System Partition, e.g., you're not
installing alongside Windows, a 50MB ESP is way enough. Seriously. And before you say it, no, your
kernels are not stored there.

Do yourself a favor and create a swap partition the size of your RAM. This way hibernate and hybrid
suspend will work out of the box. A swap file will work too but that's a pain to setup so why
bother. If installing on a desktop you're not intending to ever hibernate then not having a swap
partition is OK. Make sure you do create a swap file though since you most likely want at least a
small one.

After that, a single partition is enough. If you like your life complicated and want more partitions
that's fine too. I tend to use btrfs everywhere but ext4 is probably a better choice here. Don't
forget to set the `discard` (you're using an SSD, right?) and `noatime` mount options.

When you get to the software selection part make sure to unselect everything. Yes, even the standard
system utilities or whatever it's called at the bottom of the list. EVERYTHING. We'll do better with
the scripts.

That's it.


## Using the scripts (a.k.a. second part)

Once you reboot, use the root account and password to login. Insert the second USB stick with the
scripts and locate it using `fdisk -l`, then mount it wherever you want.

The scripts are split in multiple parts so you can decide what you install. The only exception is
`1-initial-cleanup.sh` and `2-base.sh` which could have been one and the same if, on rare occasions,
some manual adjustment wasn't needed after the first one.

It's hard to imagine a use case for using `1-initial-cleanup.sh` alone though. And know that if you
stop after `2-base.sh` you'll have to figure out networking on your own, but it's a viable final
destination for a server.


### `1-initial-cleanup.sh`

This will clean your system and APT configuration to prepare it to install what you need later.
Because a bare Debian install isn't clean enough.

In very rare occasions there can be some manual package marking required. You will see the following
warning, so read it and if necessary do as it says:

> If the next step asks if it's OK to remove some packages then answer no, use `apt-mark` to mark
  whichever you want to keep as manually installed, then run `apt-autoremove` again.
>
> If multiple packages are listed then it's likely that one is the top of a dependency hierarchy, so
  try to identify which one it is with `apt show` and `apt rdepends`, then marking this one manual
  should be enough.


### `2-base.sh`

The base install script is suitable for a server or as the intermediate layer for a graphical setup
where you'll run the next scripts. Note that if you stop after this you'll be responsible for doing
at least the network setup and anything else which could be missing. So don't reboot until you're
sure network will be working.

Some packages will be installed which may already be installed as part of the initial Debian
install. This is so that they show as manually installed and make it explicit they are needed. Some
sensible and minimal settings will also be applied here.

The root password will be deleted and root login disabled for security reasons. Instead, the user
whose ID is 1000 will be able to sudo root. Add more sudo users manually as needed.


### Desktop environment

Here you get a choice of XFCE and Gnome, so run either `3-xfce.sh` or `3-gnome.sh` respectively, not
both.

You should be able to safely reboot and have network after this stage. A double check you have the
appropriate drivers and firmware won't hurt though.

Note that sometimes the NetworkManager icon will not show up in your taskbar for unknown reasons. In
this case, just run `nmtui` in a terminal and activate your connection. This only happens on your
first connection, so you should never have to do that again.


### Optional stuff

This are all the scripts whose name start with `4-`. Just use however many you need or want.


#### `4-docker.sh`

Install the Docker repository and the required packages. You should never use the Docker packages
from your distribution. I did say I use this for work.


#### `4-intel-drivers.sh`

If you use an Intel CPU. This will install the non-free versions of the Intel drivers and firmware
in place of the free ones. Free as in speech, of course.


#### `4-japanese-input.sh`

You probably don't need Japanese input. I do.

The default binding to switch keyboards is `Win+Space`.


#### `4-kubernetes.sh`

Work stuff again, don't mind me.

Install a repository with some Kubernetes tools, including all versions of `kubectl`. Debian has a
package for it but for only one, and rather old, version. Often you need a specific version of it,
to match what your clusters run.

Another repository is added for Helm. The script then installs the latest versions of `kubctl`,
`kubctx` and `helm`.


#### `4-productivity.sh`

Just LibreOffice and Gimp with a few packages useful with them. Because I'm lazy.


### `5-gaming-prep.sh`

You will quickly make the habit of using the Windows version of your games even when a Linux build
exists. It pains me to admit it, but bad Linux ports are bad. There are exceptions, obviously.

- Apply the usual amount of sane minimal defaults.

- APT sources are switched to `sid` to get the latest graphics stack. It's fine, don't worry.

- Add the i386 architecture, still needed for a lot of games and store launchers.

- Install the Steam client. Even if you don't use it for its games (really?) you should use its
  Proton packages as your favorite Wine implementations. Proton Experimental should be your default.
  Go back in major versions one at a time if Experimental doesn't work but it will be rare.

- Install the Heroic games launcher. This is an alternative to the bloated Epic launcher. It works
  great and is full of useful conveniences. If you've been obediently redeeming these free Epic
  games every week you should have a fair number of them by now, some of them very good. Make sure
  you use Steam's Proton packages as your Wine implementation. None of the Epic games are old enough
  to require vanilla Wine.

- Install Lutris for GOG and third-party games.

- Install RetroArch straight from retroarch.com so you always have the latest version.

- Install good old Wine for those old games which won't work with Proton. If you really need DXVK in
  vanilla Wine then you will have to install it along with `wine-development`.

- Upstream `winetricks` is installed. Versions from your distribution, whichever it is, can't keep
  up with the update pace. And out-of-date versions of `winetricks` will be unable to install a lot
  of packages because Microsoft has the bad habit of juggling checksums just to play with your
  nerves.

- GameMode is installed and fixed in a couple places. First, users in the `games` group are allowed
  to renice with negative values down to -10. All known regular users at the time you run this
  script are automatically added to the `games` group. Second, GameMode contains a very neat feature
  called iGPU governor which is unfortunately and irremediably broken. I call this *poor man's
  SmartShift for Intel*. It balances the power between the CPU and GPU depending on needs. I have
  filed [a ticket](https://github.com/FeralInteractive/gamemode/issues/337) with a partial
  workaround and suggestions for other solutions, but no reaction so far. A complete fix is
  automatically applied with this script.

- Add a script to install gamescope. Note that it's not installed by default since it's only useful
  with Wayland. Gamescope also enables the use of AMD's FSR in all games. See the gaming utilities
  section below for more information.

- MangoHud is installed with a suitable configuration to monitor frame rate, CPU/GPU load, etc…, and
  control frame rate. There's also a permission fix similar to the one above. It's pre-configured to
  allow you to cap the frame rate just like the Steam Deck will supposedly do. Use Shift_R+F12 to
  toggle the HUD on and Shift_L+F1 to cycle the FPS cap (unlimited by default, then 60fps, then
  30fps). Use Shift_L+F2 to toggle logging on and off. Note that sometimes, on 32-bit games, not all
  stats will show, and the next time they will. MangoHud is somewhat erratic in 32-bit.

- Install the Xanmod kernel. It's more recent than what's packaged (usually necessary for Intel and
  AMD graphics), and contains a few interesting patches for gaming such as interactivity and
  governor improvements, FSYNC for Wine and Proton, etc…


## Supplemental scripts for exotic hardware

### `6-gpd-win-1.sh`

WARNING. This is a work in progress. Sound will not work when using Proton, but will work outside of
that.

This additional script fixes a lot of issues when installing Linux to the original GPD Win.
Including:

- Display rotated in hardware, due to it being from a tablet

- Rotated touchscreen (same as above)

Because of the compact keyboard and proximity of the Shift and Fn keys, the MangoHud keybinds are
changed to:
```
toggle_hud=Shift_L+F12
toggle_fps_limit=Shift_L+F11
toggle_logging=Shift_L+F9
reload_cfg=Shift_L+F10
upload_log=Shift_L+F8
```

XFCE is the recommended DE to install because Gnome eats way too many CPU cycles for such a small
device. XFCE settings have been adapted to make it easier to read on this small display and use the
touchscreen.

Using WiFi like described above for both parts of the install process is not a bad idea due to the
low amount of ports. It's still recommended to use wired networking (with a USB hub for example).

When booting the Debian install ISO, scroll to your preferred entry in the GRUB menu (graphical,
text-mode, etc…), press E to edit the GRUB configuration for that entry, and add the following to
the kernel command-line parameters:
```
video=DSI-1:panel_orientation=right_side_up
```

Triple-check it to make sure you typed it right, especially on this keyboard. The first parameter is
to rotate the screen for the second part of the install process. The first part will still happen
sideways. The last two parameters are to fix the SD card interface. Even if you don't use it, it
will throw errors which may end up causing random reboots during the installation.

The recommended list of scripts to use is:

- `1-initial-cleanup.sh`

- `2-base.sh`

- `3-xfce.sh`

- `4-intel-drivers.sh`

- `5-gaming-prep.sh`

- `6-gpd-win-1.sh`

Once you reboot after the second part of the install process, all hardware should be functional and
configured properly.


### `6-gpd-win-2.sh`

This additional script fixes a lot of issues when installing Linux to the GPD Win 2. Including:

- Display rotated in hardware, due to it being from a tablet

- Rotated touchscreen (same as above)

- Flaky SD card interface

- Not-quite compatible Xbox controller

Because of the compact keyboard, the MangoHud keybinds are changed to:
```
toggle_hud=Shift_R+F1
toggle_fps_limit=Shift_R+F2
toggle_logging=Shift_R+F5
reload_cfg=Shift_R+F4
upload_log=Shift_R+F6
```

XFCE is the recommended DE to install because Gnome eats way too many CPU cycles for such a small
device. XFCE settings have been adapted to make it easier to read on this small display and use the
touchscreen.

Using WiFi like described above for both parts of the install process is not a bad idea due to the
low amount of ports. It's still recommended to use wired networking (with a USB hub for example)
because the Win 2 is notoriously bad at WiFi. Move close to your AP and put your Win 2 down on a
table instead of holding it in your hands, since the antennae are where you hold it. You can use the
SD card reader to clone this repository to, but as far as I know you can't boot from it.

When booting the Debian install ISO, scroll to your preferred entry in the GRUB menu (graphical,
text-mode, etc…), press E to edit the GRUB configuration for that entry, and add the following to
the kernel command-line parameters:
```
video=eDP-1:panel_orientation=right_side_up sdhci.debug_quirks=0x40 sdhci.debug_quirks2=0x04
```

Triple-check it to make sure you typed it right, especially on this keyboard. The first parameter is
to rotate the screen for the second part of the install process. The first part will still happen
sideways. The last two parameters are to fix the SD card interface. Even if you don't use it, it
will throw errors which may end up causing random reboots during the installation.

The recommended list of scripts to use is:

- `1-initial-cleanup.sh`

- `2-base.sh`

- `3-xfce.sh`

- `4-intel-drivers.sh`

- `5-gaming-prep.sh`

- `6-gpd-win-2.sh`

Once you reboot after the second part of the install process, all hardware should be functional and
configured properly.


### `6-gpd-win-3.sh`

This additional script fixes a lot of issues when installing Linux to the GPD Win 3. Including:
The only things which need fixing are:

- Display rotated in hardware, due to it being from a tablet

- Rotated touchscreen (same as above)

- Sound

Because of the sub-optimal keyboard, the MangoHud keybinds are changed to:
```
toggle_hud=Shift_L+0
toggle_fps_limit=Shift_L+9
toggle_logging=Shift_L+7
reload_cfg=Shift_L+8
upload_log=Shift_L+6
```

Frame rate is capped at 30fps by default. Press `Shift_L+9` to cycle to 60fps or unlimited, and
`Shift_L+0` to toggle the HUD on and off.

When booting the Debian install ISO, scroll to your preferred entry in the GRUB menu (graphical,
text-mode, etc…), press E to edit the GRUB configuration for that entry, and add the following to
the kernel command-line parameters:
```
video=DSI-1:panel_orientation=right_side_up
```

The recommended list of scripts to use is:

- `1-initial-cleanup.sh`

- `2-base.sh`

- `3-gnome.sh`

- `4-intel-drivers.sh`

- `4-docker.sh` (for `gamescope`, don't forget to run `update-gamescope` as root to install it the
  first time)

- `5-gaming-prep.sh`

- `6-gpd-win-3.sh`


## Experimental stuff

Some of these scripts require adding the experimental repository to your APT sources. If you don't
know how to do it you should not play with this. And even if you know you most likely don't want to
either.


### `6-gaming-experimental.sh`

Switch some if not most of the graphics plumbing to using experimental packages. WARNING: this is
hard to revert. Actually most people think it's impossible. They're wrong, but it doesn't make it
any easier.


### `6-possibly-experimental.sh`

List packages already installed on your system which could be upgraded to experimental. See warning
above.


### `6-reduce-manual-installed.sh`

Reduce the list of manually installed packages to only what is absolutely necessary thanks to
dependencies. `1-initial-cleanup.sh` does that at the very beginning of the install process, but
doing it any later than that is of dubious use and surely a bad idea.


## Gaming utilities

They're all installed in `/usr/local/bin` so they're all available in your PATH and out of the way
of the package manager.


### `intel-rapl-perms`

This is part of the fixes for GameMode and MangoHud. It's automatically started by a systemd
service. You will never have to use this manually or even update it.


### `update-gamescope`

This builds Valve's `gamescope` straight from their git repository. This script uses Docker to avoid
a hell of build dependencies sticking around on your system, so make sure you run the `4-docker.sh`
script during installation (or later, that's fine too). Due to this, and that only Wayland users
really need it, `gamescope` is not installed by default, so just run this script as root when you
need to install or update it.

You can use gamescope in Steam by adding something like this on your launch options:
```gamescope -f -w 1024 -h 576 run-game %command%```
Or, if you want to add FSR to the mix:
```WINE_FULLSCREEN_FSR=1 gamescope -f -w 896 -h 504 run-game %command%```
(make sure to change the `-w` and `-h` values to the width and height of your desired resolution)

Note that `gamescope` only really makes sense with Wayland, meaning when installing `3-gnome.sh`
instead of `3-xfce.sh`.


### `update-heroic`

The Heroic games launcher for Epic games is not packaged in Debian. This is used to initially
install and update Heroic. By default, when you start the client, it will warn you if an update is
available. Just run `update-heroic` as root when that happens.


### `update-retroarch`

Download the latest RetroArch from retroarch.com and update default configs and assets for all
users. THis is all done using harlinks so it doesn't encumber your drive.


### `winetricks`

As explained above we don't use the packaged version of winetricks. Run `winetricks --self-update`
as root to update it when a package fails to install because of an outdated checksum.


### `run-game`

It sets a bunch of variables and starts GameMode and MangoHud automatically.

It doesn't include the Wine executable though, so you can choose which one you want or use it with a
native game. Example:
```
run-game wine hl3.exe
```

In Steam you can set your game's launch options (in the Properties… → GENERAL menu) to:
```
run-game %command%
```

You can also switch resolutions when you want to use borderless windows (often recommended on Intel
GPUs) at less than native resolution but still want it full screen.

On Xorg (if you're using XFCE) you need to use `xrandr`. This is for example how I start Skyrim SE
on my GPD Win 2 in Steam's launch options:
```
xrandr -s 504x896; run-game %command%; xrandr -s 720x1280
```

It sets the resolution to 896x504 (x and y are inverted with `xrandr` due to the rotated display,
see above) then resets it to native resolution when the game exits. Note that in this particular
case you also need to manually set the resolution in the game's config file to 896x504 (not
inverted) because the UI won't list this specific resolution.

If using Gnome then you're on Wayland. In this case you need `gamescope` to resize your screen.
Make sure you run `4-docker.sh` at install time then run `update-gamescope` as root to install it
initially or whenever you want to update it. This is how I start the same Skyrim SE in Steam:
```
gamescope -w 896 -h 504 -f -- run-game %command%
```


## Miscellaneous

### Steam

In Settings → Library, check "Low Bandwidth Mode" and "Low Performance Mode" (this is for the client,
not for your games).

In Settings → Steam Play, check "Enable Steam Play for all other titles" and select Proton
Experimental in the list just below.

Download the Proton Experimental package by searching for it in your library. You'll need it below.


### Heroic games launcher

Set the global settings which can later be changed independently for each game.

In Settings → Wine, choose Proton Experimental in the Wine Version dropdown list.

In Settings → Other, enable GameMode, Audio Fix, MangoHud and Run Game Offline (disable this last
one individually for games which need it).

Set the content of "Advanced Options (Environment
Variables)" to:
```WINEFSYNC=1```

You should use a different Wine prefix for each game. I create a `.wine` directory at the top of
each game directory.
