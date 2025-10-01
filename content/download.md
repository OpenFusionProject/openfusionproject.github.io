---
title: "Download"
description: ""
summary: ""
date: 2024-06-24T17:19:07+02:00
lastmod: .Lastmod
draft: false
type: "legal"
seo:
  title: "Download OpenFusion" # custom title (optional)
  description: "" # custom description (recommended)
  canonical: "" # custom canonical URL (optional)
  noindex: false # false (default) or true
---

{{< callout context="note" title="Note" icon="outline/info-circle" >}}
Downloads provided below are not signed. Doing so would be cost prohibitive and has other logistical issues.

As a result, you may receive a warning from Windows stating that it is unable to run the app. To bypass this click "More info", then "Run anyway".

<!--On MacOS, ensure you have non App Store apps enabled, then hold the Options key when clicking the .app file, finally select "Open".-->
{{< /callout >}}


## Download Launcher

The latest stable launcher is version **2.0.2**.

The launcher is what you use to connect to FusionFall servers and play the game - it can be downloaded below.

{{< tabs "download-launcher-platforms" >}}

{{< tab "Windows" >}}

{{< card-grid >}}

{{< link-card title="Windows Installer"  description=".exe file (Recommended)" href="https://github.com/OpenFusionProject/OpenFusionLauncher/releases/latest/download/OpenFusionLauncher-Windows-Installer.exe" >}}
{{< link-card title="Windows Portable" description=".zip file" href="https://github.com/OpenFusionProject/OpenFusionLauncher/releases/latest/download/OpenFusionLauncher-Windows-Portable.zip" >}}
{{< /card-grid >}}

{{< /tab >}}

{{< tab "macOS" >}}
<mark>**macOS BUILDS ARE EXPERIMENTAL, AND WILL RUN SLOWLY**</mark>

You will need to install a compatibility layer such as Wine or Crossover, then manually configure it in the launch options. On Apple Silicon Macs **it will likely run at less than 15FPS**.

For this reason **we still recommend using the Windows version through virtualization software** such as VMWare Fusion or Parallels. It requires less configuration overall and has significantly better performance.

Currently, the macOS version of the launcher is provided in order to collect early feedback and hopefully drive more development in the future.

{{< card-grid >}}
{{< link-card title="macOS Universal"  description=".dmg file" href="https://github.com/OpenFusionProject/OpenFusionLauncher/releases/latest/download/OpenFusionLauncher-MacOS-Universal.dmg" >}}
{{< /card-grid >}}

{{< /tab >}}

{{< tab "Linux" >}}

**If you are using NVIDIA proprietary drivers, there is currently a bug that will cause the launcher to crash on startup.**

As a workaround, you can set this environment variable to resolve the issue:
```sh
WEBKIT_DISABLE_DMABUF_RENDERER=1
```

{{< card-grid >}}
<!--{{< link-card title="Linux AppImage"  description=".zip file (Recommended)" href="https://github.com/OpenFusionProject/OpenFusionLauncher/releases/latest/download/OpenFusionLauncher-Linux-AppImage.zip" >}}-->
{{< link-card title="Linux Binary" description=".zip file" href="https://github.com/OpenFusionProject/OpenFusionLauncher/releases/latest/download/OpenFusionLauncher-Linux.zip" >}}
{{< /card-grid >}}

{{< /tab >}}

{{< /tabs >}}

{{< details "Development Builds" >}}
Artifacts for the latest development builds of the launcher can be downloaded from [GitHub](https://github.com/OpenFusionProject/OpenFusionLauncher/actions) (requires sign-in).
{{< /details >}}

{{< details "Source Code" >}}
You can clone the latest source like so:
```bash
git clone https://github.com/OpenFusionProject/OpenFusionLauncher.git --recurse-submodules
```
You can also browse the files [here](https://github.com/OpenFusionProject/OpenFusionLauncher).
{{< /details >}}

## Download Server

The latest stable server is version **2.0**.

The server is what facilitates the multiplayer session and stores player information - it can be downloaded below.

{{< tabs "download-server-platforms" >}}

{{< tab "Windows" >}}

{{< card-grid >}}
{{< link-card title="Windows" description="\"Original\" Protocol (beta-20100104)" href="https://github.com/OpenFusionProject/OpenFusion/releases/latest/download/OpenFusionServer-Windows-Original.zip" >}}
{{< link-card title="Windows" description="\"Academy\" Protocol (beta-20111013)" href="https://github.com/OpenFusionProject/OpenFusion/releases/latest/download/OpenFusionServer-Windows-Academy.zip" >}}
{{< /card-grid >}}

{{< /tab >}}

{{< tab "macOS" >}}
> Server builds for macOS coming soon.
{{< /tab >}}

{{< tab "Linux" >}}

{{< card-grid >}}
{{< link-card title="Linux" description="\"Original\" Protocol (beta-20100104)" href="https://github.com/OpenFusionProject/OpenFusion/releases/latest/download/OpenFusionServer-Linux-Original.zip" >}}
{{< link-card title="Linux" description="\"Academy\" Protocol (beta-20111013)" href="https://github.com/OpenFusionProject/OpenFusion/releases/latest/download/OpenFusionServer-Linux-Academy.zip" >}}
{{< /card-grid >}}

{{< /tab >}}

{{< /tabs >}}

{{< details "Development Builds" >}}
Development builds of the server for Windows and Linux can be found [here](https://cdn.dexlabs.systems/of-builds/).
{{< /details >}}

{{< details "Source Code" >}}
You can clone the latest source like so:
```bash
git clone https://github.com/OpenFusionProject/OpenFusion.git --recurse-submodules
```
You can also browse the files [here](https://github.com/OpenFusionProject/OpenFusion).
{{< /details >}}

<br/>
