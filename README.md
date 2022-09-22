# Debian install scripts

TL;DR
- Lean and fast, no useless cruft
- Very up-to-date, not your grandma's Debian
- Rolling, no upgrades every 6 months which may or may not work and always leave a mess
- Auto-updating, new packages are downloaded in the background and installed at shutdown/reboot time
- Options for Chrome/Firefox, Office tools, Japanese input, etc…
- Optional gaming setup for Steam, Epic and GOG with performance optimizations, most Windows games
  work and are fast (Note: Nvidia drivers need to be installed manually, I'm looking for hardware to
  test it)

None of this is rocket science. Just a collection of settings and tricks, with a goal of simplicity
and reproducibility.


## Preparations

1. Read these entire instructions carefully.

2. Download the non-edu ISO image from
[this directory](https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current/amd64/iso-cd/)
and `dd` or `cp` it to a USB stick at least 1GB in size.


## Debian installation (a.k.a. first part)

Boot the Debian ISO image and do your thing. Some recommendations follow but you don't really have
to follow them except for the last paragraph.

You can install this alongside a Windows system, just make sure you have enough space available.

If you use UEFI and don't reuse an already existing EFI System Partition (ESP), i.e., you're not
installing alongside Windows or another Linux distribution, you will need to create an ESP and 100MB
is way enough.

Do yourself a favor and create a swap partition the size of your RAM. This way hibernate and hybrid
suspend will work out of the box. A swap file will work too but that's a pain to setup so why
bother. If installing on a desktop where you're not intending to ever hibernate then not having a
swap partition is OK. In this case, and depending on your needs, you may or may not want to create a
small swap file for performance reasons.

After that, a single partition is enough. If you like your life complicated and want more partitions
that's fine too. I tend to use btrfs everywhere but ext4 is probably a better choice here. Don't
forget to set the `discard` (if using an SSD) and `noatime` mount options.

**And now, the only requirement: when you get to the software selection part, make sure to deselect
everything.** Yes, even the standard system utilities at the bottom of the list. We'll do better
with the scripts.


## Using the scripts (a.k.a. second part)

Once you reboot, **use the root account and password to login**. This is the first and last time
you'll use it since root login will be disabled later.


### Networking

Wired networking is strongly recommended, at least for this part. Either ethernet, or a
USB-to-ethernet adapter will work. I always use a USB-tethered cell-phone out of habit. Make sure
it's on WiFi because there's going to be a lot to download.

Although it's technically doable, you shouldn't use your computer's WiFi because it doesn't work
well at all. I have plans to fix this in the future. However, whatever you do, WiFi will be normally
usable after the installation is complete.


### Getting the scripts

The easiest way is to get them straight from GitHub:

```
cd /tmp
apt install git
git clone https://github.com/calchan/debian-install-scripts
```


### `1-base.sh`

The scripts are split in multiple parts so you can decide what to install. If you stop after
`1-base.sh` you'll have to figure out networking on your own, but it's a viable final destination
for a server. If you di this, don't reboot until you have installed the packages you'll need for
networking and made sure it will be working.

The root password will be deleted and root login disabled for security reasons. Instead, the user
whose ID is 1000 (i.e., the one you created when installing from the USB stick in the first part)
will be able to sudo root. Add more sudo users manually as needed.


### Desktop environment

Here you get a choice of XFCE and Gnome, so run either `2-xfce.sh` or `2-gnome.sh` respectively, not
both. In case you're hesitating, XFCE is the easy recommendation for a lot of reasons.


### Optional stuff

#### `3-chrome.sh`

Install Google Chrome stable and its repository. If you prefer Firefox, run `apt install
firefox-esr` instead.


#### `3-docker.sh`

Install the Docker repository and the required packages. You should never use the Docker packages
from your distribution.


#### `3-gaming.sh`

Install Steam, Heroic (for Epic and GOG games), some useful tools and customizations, and all the
required 32-bit dependencies. System performance is optimized for gaming at the expense of some more
lenient security (CPU mitigations are disabled, `energy_uj` in Intel RAPL interfaces is readable to
members of the `games` group).  You should still be fine unless you do very silly things on the
internet.

When starting Heroic, it will show if a new version is available at the bottom left. Run `sudo
update-heroic` in a terminal to update it.

The default MangoHud keybindings are `LeftShift =` to toggle the HUD (default off), and `LeftShift
-` to cycle through the fps limits (default unlimited). Heroic has an option to enable MangoHud. For
Steam games, you'll have to add `mangohud %command%` in the game's launch options, or `mangohud
--dlsym %command%` for some OpenGL games.


#### `3-intel-drivers.sh`

If you use an Intel CPU. This will install the non-free versions of the Intel drivers and firmware
in place of the free ones.


#### `3-japanese-input.sh`

You probably don't need Japanese input. I do.

The default binding to switch keyboards is `Win+Space`.


#### `3-kubernetes.sh`

Install a repository with some Kubernetes tools, including all versions of `kubectl`. Debian has a
package for it but for only one, and rather old, version. Often you need a specific version of it,
to match what your clusters run.

Another repository is added for Helm. The script then installs the latest versions of `kubctl`,
`kubctx` and `helm`.


#### `3-office.sh`

LibreOffice and Gimp with a few packages useful with them.


### Finalize

Make sure to run the `4-finalize.sh` script at the end, unless you've done a server install and
stopped after `1-base.sh`.
