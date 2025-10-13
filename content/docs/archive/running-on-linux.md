---
aliases: ['/docs/guides/running-on-linux/']
title: "Running on Linux (Legacy Client)"
slug: "running-on-linux"
description: ""
summary: ""
date: 2024-07-14T18:32:54-05:00
lastmod: 2024-07-14T18:32:54-05:00
draft: false
weight: 1020
toc: true
seo:
  title: "" # custom title (optional)
  description: "" # custom description (recommended)
  canonical: "" # custom canonical URL (optional)
  noindex: false # false (default) or true
---

{{< callout context="caution" title="Caution" icon="outline/alert-triangle" >}}
This is a guide for the legacy software, OpenFusionClient.

For instructions regarding the modern launcher, see [Quick Start](/docs/guides/quick-start).
{{< /callout >}}

While the OpenFusion server supports both Windows and Linux (and other Unix-like systems), the game client natively supports only Windows because of the NPAPI Unity Web Player plugin needed to run the game.
Nevertheless, the client runs very well in Wine if configured properly.

Due to the plethora of Wine prefix managers that people use (in addition to the option of just configuring your Wine prefix by hand), there's a number of ways you could set the game up.
Regardless of which you prefer, for OpenFusion there's a handful of dependencies you need to satisfy, which are common to all of them:

* Electron (`OpenFusionClient.exe`) needs `allfonts` to run
* It also needs to be run with the following arguments: `--no-sandbox --disable-gpu`
* Using DXVK instead of `wined3d` is highly recommended to avoid graphical glitches like mission indicator rings not rendering

Here's a few possible ways to install OpenFusion through Wine:

## Bottles

This is the preferred and most user friendly way to set up OpenFusionClient on Linux.

Bottles is meant to be installed through Flatpak. Follow the [instructions](https://flatpak.org/setup/) to set Flatpak up, and then install [Bottles](https://flathub.org/apps/details/com.usebottles.bottles) from Flathub.

If you get stuck at any part, the [official Bottles documentation](https://docs.usebottles.com/) might be useful.

TIP: You can show hidden folders like `.var` by hitting Ctrl-H in your file manager.

Once you have Bottles installed, you can proceed with setting up a bottle for OpenFusion:

1. Hit the + button to create a new bottle. Name it OpenFusion and make it a Gaming environment.
2. Open the bottle, click on Dependencies and click on `allfonts` to install that dependency.
3. In that bottle's Details view (its primary view), click on the three dots button on the top right and click Browse Files. This will open the bottle's Wine prefix in your desktop environment's file manager. The path will be something like `~/.var/app/com.usebottles.bottles/data/bottles/bottles/OpenFusion/drive_c/`
4. Download and extract [the latest zip of the client](https://github.com/OpenFusionProject/OpenFusion/releases/latest) into `users/$USER/` in the bottle.
5. At this point, if Bottles hasn't already detected the `OpenFusionClient.exe` you've extracted into the bottle, you can manually add it by clicking the Add Shortcuts... button in the Programs section of the Details view.
6. There should now be an OpenFusionClient entry. Click on the three dots on the right side of the entry, click Change Launch Options, copy `--no-sandbox --disable-gpu` into Command Arguments and hit Save.
7. You should now be able to run that entry and the game should work without issue.

DXVK is already set up in Bottles by default, so you don't have to worry about that.

### Alternate runners

Optionally, if your in-game mouse sensitivity is too high:

1. Go back into the top-level view in Bottles, click on the Hamburger menu in the top right, an select Preferences.
2. In the Runners tab, install the latest version of GE Wine.
3. Go back into your OpenFusion bottle, and in Settings, under Components, change your Runner to your version of `wine-ge`.

Wine-ge supports raw input, which should prevent unwanted mouse acceleration.

### Application menu shortcut

If you want to be able to run the game from your application menu without opening Bottles, follow [these](https://docs.usebottles.com/bottles/programs#add-programs-to-your-desktop) instructions.
You might want to rename the OpenFusionClient entry to just "OpenFusion" or "FusionFall" before making the desktop entry.
If you want to manually rename or delete an existing desktop entry, you can find it in `~/.local/share/applications`.

### Gamescope

If you have a 1440p or even higher resolution monitor, the game will bug out in fullscreen because it just wasn't meant to be run at resolutions that high.
This happens on Windows as well, but on Linux we can work around the problem using Gamescope.

1. Install the Flatpak version of Gamescope with:

```sh
sudo flatpak install com.valvesoftware.Steam.Utility.gamescope
```

2. Restart Bottles
3. In your bottle's Settings, under Display, enable Gamescope and configure it to upscale a Game Resolution of 1920x1080 to a Window Resolution of 2560x1440 or whichever resolution you want.
4. Now the game will always start in fullscreen.
5. The only awkward part is that you will now always have to press the in-game fullscreen button to get it to upscale from 1080p instead of from the default Window size of 720p.
6. You can disable this at any time by disabling Gamescope for your bottle.

### Mangohud

If you want to monitor your FPS while playing, you can enable Mangohud:

1. Install the Flatpak version of Mangohud with:

```sh
sudo flatpak install org.freedesktop.Platform.VulkanLayer.MangoHud
```

2. Restart Bottles
3. In your bottle's Settings, in the Performance section, enable Monitor Performance.
4. You can disable this at any point and re-launch the game.

On most Windows systems the game runs poorly, usually below 60 FPS, but we've observed it running really well on some high-end Linux systems.
Let us know if the game runs really well for you in this configuration, as we need more data points to be sure there's a connection.

## Lutris

Lutris is another prefix manager you could use if you prefer it.

TODO: Detailed instructions

Quick notes:

* Much of the installation is similar to Bottles, but a bit lower-level.
* The default Wine version doesn't seem to work well, but `lutris-GE-Proton` should.
* There isn't a user-friendly wrapper around Winetricks, so you'll have to run it directly from Lutris to install `allfonts`, and it *doesn't show any window or progress bar while installing them, nor does it indicate when it's done*(!). You might want to track its progress through a process manager like `htop`.
* A Lutris install script could be written in the future to automate all this.

## Plain Wine prefix

This is for advanced users who know what they're doing and prefer to manage their prefixes by hand.

I'll assume that if you're doing it this way you already understand most of this already, so these commands are approximate and not meant to be copy-pasted.
In short:

1. Install `wine` and `winetricks` through your distribution's package manager.
1. The default Wine prefix is located in `~/.wine`. This can be controlled by setting the `WINEPREFIX` environment variable for each command.
2. You can easily install DXVK using Winetricks

```sh
WINEPREFIX=/path/to/pfx winetricks dxvk
```

3. The same goes for `allfonts`

```sh
WINEPREFIX=/path/to/pfx winetricks allfonts
```

4. Run the client

```sh
WINEPREFIX=/path/to/pfx wine OpenFusionClient.exe --no-sandbox --disable-gpu
```
