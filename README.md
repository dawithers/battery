## Note
This is a fork of [battery](https://github.com/actuallymentor/battery) by actuallymentor. This fork uses [bclm](https://github.com/zackelia/bclm) instead of smc to enable battery maintenance via Apple's firmware instead of via a software daemon. This simplifies the implementation and supports battery maintenance during sleep, but removes the ability to choose arbitrary maintenance values. This implementation only supports a maintenance value of 80%. This is a limitation in Apple's firmware. It requires firmware >= 13.0.

# Battery charge limiter for Apple Silicon Macbook devices

<img width="300px" align="right" src="./screenshots/tray.png"/>This tool makes it possible to keep a chronically plugged in Apple Silicon Macbook at `80%` battery, since that will prolong the longevity of the battery. It is free and open-source and will remain that way.

> Want to know if this tool does anything or is just a placebo? Read [this excellent article](https://batteryuniversity.com/article/bu-808-how-to-prolong-lithium-based-batteries). TL;DR: keep your battery cool, keep it at 80% when plugged in, and discharge it as shallowly as feasible.

### Requirements

This is an app for Apple Silicon Macs with firmware 13.0 or greater. It will not work on Intel macs. Do you have an older Mac? Consider the free version of the [Al Dente](https://apphousekitchen.com/) software package. It is a good alternative and has a premium version with many more features. Alternatively, [bclm](https://github.com/zackelia/bclm), which this tool uses under the hood, is a free tool that supports both Intel and Apple Silicon Macs.

### Installation

- Option 1: Download non-notraized GUI from Releases, remove quarantine, run (CLI will be installed automatically on first run)  
  Example of removing quarantine:  
  `/usr/bin/xattr -drs com.apple.quarantine battery-2.0.0-mac-arm64.zip`  
- Option 2: command-line only installation (see section below)

As I am not an Apple developer I do not have a notarized version of the gui to offer for download.

The first time you open the app, it will ask for your administator password so it can install the needed components. Please note that the app:

- Discharges your battery until it reaches 80%, **even when plugged in**
- Disables charging when your battery is above 80% charged
- Enabled charging when your battery is under 80% charged
- Keeps the limit engaged even after rebooting
- Keeps the limit engaged even after closing the tray app
- Also automatically installs the `battery` command line tool. If you want a custom charging percentage, the CLI is the only way to do that.

---

## 🖥 Command-line version

> If you don't know what a "command line" is, ignore this section. You don't need it.

The GUI app uses a command line tool under the hood. Installing the GUI automatically installs the CLI as well. You can also separately install the CLI.

The CLI is used for managing the battery charging status for Apple Silicon Macbooks. Can be used to enable/disable the Macbook from charging the battery when plugged into power.

### Installation

One-line installation:

```bash
curl -s https://raw.githubusercontent.com/dawithers/battery/main/setup.sh | bash
```

This will:

1. Download the precompiled `smc` tool in this repo (built from the [hholtmann/smcFanControl](https://github.com/hholtmann/smcFanControl.git) repository)
2. Download the precompiled `bclm` tool in this repo (built from the [zackelia/bclm](https://github.com/zackelia/bclm.git) repository)
3. Install `smc` to `/usr/local/bin`
4. Install `battery` to `/usr/local/bin`
5. Install `bclm` to `/usr/local/bin`

### Usage

Example usage:

```shell
# This will enable charging when your battery dips under 80, and disable it when it exceeds 80
battery maintain start
```

After running a command like `battery charging off` you can verify the change visually by looking at the battery icon:

![Battery not charging](./screenshots/not-charging-screenshot.png)

After running `battery charging on` you will see it change to this:

![Battery charging](./screenshots/charging-screenshot.png)

For help, run `battery` without parameters:

```
Battery CLI utility v2.0.0

Usage:

  battery status
    output battery SMC status, % and time remaining

  battery logs LINES[integer, optional]
    output logs of the battery CLI and GUI
    eg: battery logs 100

  battery maintain LEVEL[start,stop]
    reboot-persistent battery level maintenance: turn off charging above, and on below 80%
    eg: battery maintain start
    eg: battery maintain stop

  battery charging SETTING[on/off]
    manually set the battery to (not) charge
    eg: battery charging on

  battery adapter SETTING[on/off]
    manually set the adapter to (not) charge even when plugged in
    eg: battery adapter off

  battery charge LEVEL[1-100]
    charge the battery to a certain percentage, and disable charging when that percentage is reached
    eg: battery charge 90

  battery discharge LEVEL[1-100]
    block power input from the adapter until battery falls to this level
    eg: battery discharge 75

  battery visudo
    ensure you don't need to call battery with sudo
    this is already used in the setup script, so you should't need it.

  battery update
    update the battery utility to the latest version

  battery reinstall
    reinstall the battery utility to the latest version (reruns the installation script)

  battery uninstall
    enable charging, remove the smc tool, the bclm tool, and the battery script
```