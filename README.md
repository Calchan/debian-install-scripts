# Debian install scripts

These scripts help you setup a lean but full-featured Debian install that's easy to manage and
maintain. They're split in multiple parts so you can pick and choose what you install. Just so you
know, I use this on my work machines. It works.

One of the optional scripts is to prepare your machine for gaming to a point it makes owning a
Windows install useless. I have thousands of Windows games and, although I haven't tried them all,
all those I've tried worked without exception. Not only that but they typically work as fast or
faster than on Windows. How about ~25fps in GTA5 at 720p on a dumb old Skylake laptop with
integrated graphics?

None of this is rocket science. Just a collection of settings, tricks and the result of using Linux
exclusively for 25 years. Some fixes also, like for example for GameMode. I don't know how people
use it but some of it is broken out of the box. There are some convenience scripts too, read about
them below.

Finally, these scripts work well but they don't look as nice or clean as I would want it. They grew
organically over the years and it shows. Patches welcome.


## Preparations

1. Read these instructions entirely and carefully.

2. Download
[this ISO image](https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/11.0.0+nonfree/amd64/iso-cd/firmware-11.0.0-amd64-netinst.iso)
and `dd` or `cp` it to a USB stick at least 1GB in size.

3. Download the scripts in this repository and copy them to a FAT32-formatted USB stick. The Debian
   image is read-only so you can't put the scripts on your first stick, but you can wipe it after
   you've rebooted for the first time, reformat it to FAT32 and copy the scripts on it.

4. Have some form or wired networking. Either ethernet, or a USB-to-ethernet adpater. I always use a
   USB-tethered cell-phone out of habit. Make sure it's on WiFi because there's going to be a lot to
   download. You could, under certain circumstances, be able to bring up WiFi for the second part of
   the installation process but it's not guarantied and a pain. Save yourself some time and trouble,
   just use wired networking. Once the installation is completed you'll be able to use WiFi just
   fine, obviously.


## Debian installation

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


## Using the scripts

Once you reboot, use the root account and password to login. Insert the second USB stick with the
scripts and locate it using `fdisk -l`, then mount it wherever you want.

The scripts are split in multiple parts so you can decide what you install. The only exception is
`1-initial-cleanup.sh` and `2-base.sh` which could have been one and the same if, on rare occasions,
some manual adjustment wasn't needed after the first one.

It's hard to imagine a use case for using `1-initial-cleanup.sh` alone though. And know that if you
stop after `2-base.sh` you'll have to figure out networking on your own, but it's a viable final
destination for a server.

Note that your APT sources will be switched to unstable in the process. Stop complaining, it works,
and you'll be amazed at how stable this is. You did read the part about me using this on my work
machines, right?


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

WARNING. At the time of this writing the Gnome script is unfinished and still a work in progress.

You should be able to safely reboot and have network after this stage. A double check you have the
appropriate drivers and firmware won't hurt though.


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


#### `4-productivity.sh`

Just LibreOffice and Gimp with a few packages useful with them. Because I'm lazy.


### `5-gaming-prep.sh`

This will put your Windows partition to shame. You will quickly build the habit of using the Windows
version of your games even when a Linux version exists. Bad Linux ports are bad.

- Apply the usual amount of sane minimal defaults.

- Install the i386 architecture, still needed for a lot of games and store launchers.

- Install the Steam client. Even if you don't use it for games (really?) you should use its Proton
  packages as your favorite Wine implementations. Proton Experimental should be your default. Go
  back in major versions one at a time if Experimental doesn't work but it will be rare.

- Install good old Wine, both `wine` and `wine-development`, for those old games which won't work
  with Proton. DXVK is also installed but will only work with `wine-development` at this time. MS
  core fonts and `winbind` are also installed since they're often needed. Remember to use
  `winetricks` and `dxvk-setup` as needed.

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

- MangoHud is installed with a suitable configuration. There's also a permission fix similar to the
  one above. It's pre-configured to allow you to cap the frame rate just like the Steam Deck will
  supposedly do. Use Shift_R+F12 to toggle the HUD and Shift_L+F1 to cycle the FPS cap (unlimited by
  default, then 60fps, then 30fps).

- Install the Heroic games launcher. This is an alternative to the bloated Epic launcher. It works
  great and is full of useful conveniences. If you've been obediently redeeming these free Epic
  games every week you should have a fair number of them by now, some of them very good. Make sure
  you use Steam's Proton packages as your Wine implementation. None of the Epic games are old enough
  to require vanilla Wine.

- Install the Xanmod kernel. It's more recent than what's packaged (usually necessary for Intel and
  AMD graphics), and contains a few interesting patches for gaming such as interactivity and
  governor improvements, FSYNC for Wine and Proton, etc…


## Experimental stuff

Some of these scripts require adding the experimental repository to your APT sources. If you don't
know how to do this you should not play with this. And even if you know you most likely don't want
to either.


### `6-gaming-experimental.sh`

Switches some if not most of the graphics plumbing to using experimental packages. WARNING: this is
hard to revert, actually most people think it's impossible. They're wrong, but it doesn't make it
any easier.


### `6-possibly-experimental.sh`

List packages already installed on your system which could be upgraded to experimental. See warning
above.


### `6-reduce-manual-installed.sh`

Reduce the list of manually installed packages to only what is absolutely necessary thanks to
dependencies. `1-initial-cleanup.sh` does that at the very beginning of the install process, but
doing it any later than that is of dubious use and surely a bad idea.


## Convenience scripts

They're all installed in `/usr/local/bin` so they're all available in your PATH and out of the way
of the package manager.


### `intel-rapl-perms`

This is part of the fixes for GameMode and MangoHud. It's automatically started by a systemd
service. You will never have to use this manually or even update it.


### `update-heroic`

The Heroic games launcher for Epic games is not packaged in Debian. This is used to initially
install and update Heroic. By default, when you start the client, it will warn you if an update is
available. Just run `update-heroic` as root when that happens.


### `winetricks`

As explained above we don't use the packaged version of winetricks. Run `winetricks --self-update`
as root to update it when a package fails to install because of an outdated checksum.


### `run-game`

It sets a bunch of variables and starts GameMode and MangoHud automatically.

They don't include the Wine executable though, so you can choose which one you want or use it with a
native game. Example:

```
run-game wine hl3.exe
```

In Steam you can set your game's launch options (in the Properties… → GENERAL menu) to:

```run-game %command%```


## Miscellaneous

### Steam

In Settings → Library, check "Low Bandwidth Mode" and "Low Performance Mode" (this is for the client,
not for your games).

In Settings → Steam Play, check "Enable Steam Play for all other titles" and select Proton
Experimental in the list just below.

Download the Proton Experimental package by searching for it in your library. You'll need it it
below.


### Heroic games launcher

Set the global settings which can later be changed independently for each game.

In Settings → Wine, choose Proton Experimental in the Wine Version dropdown list.

In Settings → Other, enable GameMode, Audio Fix, MangoHud and Run Game Offline (disable this last
one individually for games which need it).

Set the content of "Advanced Options (Environment
Variables)" to:

```WINEESYNC=1 WINEFSYNC=1```

You should use a different Wine prefix for each game. I create a `.wine` directory at the top of
each game directory.
