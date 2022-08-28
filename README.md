# Debian install scripts

These scripts help you automatically set up a lean but full-featured Linux install that's easy to
manage and maintain. It's based on Debian testing which is rolling, meaning you don't have to
upgrade on a periodic basis, and uses up-to-date yet reliable packages (despite the name). They're
split in multiple parts so you can pick and choose what you install. Just so you know, I use this on
all my machines, including my work laptop and gaming desktop. It works.

None of this is rocket science. Just a collection of settings and tricks, with a goal of simplicity
and reproducibility.

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
installing alongside Windows, a 100MB ESP is way enough.

Do yourself a favor and create a swap partition the size of your RAM. This way hibernate and hybrid
suspend will work out of the box. A swap file will work too but that's a pain to setup so why
bother. If installing on a desktop where you're not intending to ever hibernate then not having a
swap partition is OK. In this case, and depending on your needs, you may or may not want to create a
small swap file for performance reasons.

After that, a single partition is enough. If you like your life complicated and want more partitions
that's fine too. I tend to use btrfs everywhere but ext4 is probably a better choice here. Don't
forget to set the `discard` (you're using an SSD, right?) and `noatime` mount options.

When you get to the software selection part make sure to deselect everything. Yes, even the standard
system utilities or whatever it's called at the bottom of the list. EVERYTHING. We'll do better with
the scripts.

That's it.


## Using the scripts (a.k.a. second part)

Once you reboot, _use the root account and password to login_. Insert the second USB stick with the
scripts and locate it using `fdisk -l`, then mount it wherever you want. Or install `git` and clone
the scripts repository as explained above.

The scripts are split in multiple parts so you can decide what you install. If you stop after
`1-base.sh` you'll have to figure out networking on your own, but it's a viable final destination
for a server.


### `1-base.sh`

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

The base install script is suitable for a server or as the intermediate layer for a graphical setup
where you'll run the next scripts. Note that if you stop after this you'll be responsible for doing
at least the network setup and anything else which could be missing. So don't reboot until you have
installed the packages you'll need for networking and made sure it will be working.

The root password will be deleted and root login disabled for security reasons. Instead, the user
whose ID is 1000 will be able to sudo root. Add more sudo users manually as needed.


### Desktop environment

Here you get a choice of XFCE and Gnome, so run either `2-xfce.sh` or `2-gnome.sh` respectively, not
both.

You should be able to safely reboot and have network after this stage. A double check you have the
appropriate drivers and firmware won't hurt though.

Note that sometimes the NetworkManager icon will not show up in your taskbar for unknown reasons. In
this case, just run `nmtui` in a terminal and activate your connection. This only happens on your
first connection, so you should never have to do that again.


### Optional stuff

This are all the scripts whose name start with `3-`. Just use however many you need or want.


#### `3-docker.sh`

Install the Docker repository and the required packages. You should never use the Docker packages
from your distribution.


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

Just LibreOffice and Gimp with a few packages useful with them.
