# Debian install scripts

These scripts are for my own usage, but if you like them feel free to use them. And send patches,
obviously.

Warning. The optional gaming setup automatically disables CPU and GPU mitigations. I'm comfortable
with that, but if you aren't you can always revert it.

TL;DR
- Lean and fast, no useless cruft, and yet full-featured
- Choice of minimal server, Gnome or XFCE, with defaults that streamline your workflow
- Very up-to-date, not your grandma's Debian
- Rolling, no upgrades every 6 months which may or may not work but always leave a mess
- Auto-updating, new packages are downloaded in the background and installed at shutdown/reboot time
- Options for Chrome/Firefox, Office tools, Japanese input, etc…
- Optional gaming setup for Steam, Epic and GOG with performance optimizations, most Windows games
  work and are fast

None of this is rocket science. Just a collection of settings and tricks, with a goal of simplicity
and reproducibility.


# Installation

Note. These are minimal instructions until I have time to write something better.

1. Download the non-edu ISO image from
[this directory](https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current/amd64/iso-cd/)
and `dd` or `cp` it to a USB stick at least 1GB in size.

2. Boot the ISO
    - If using BIOS, select `Help`, then type `install url=calchan.github.io/debian` at the prompt.
    - If using UEFI, highlight `Install`, hit the E key, add `url=calchan.github.io/debian` at the
      end of the Linux command line (the one which starts with `linux`), then hit F10 or CTRL-X.

3. Install as you would normally do.

4. When you get to the `Installation complete` page, hit ALT+F2, then Enter, and type `finish` at
   the prompt. Follow the instructions.
