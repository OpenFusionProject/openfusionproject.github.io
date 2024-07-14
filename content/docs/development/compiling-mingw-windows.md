---
title: "Compilation on Windows (MSYS2 MinGW)"
description: ""
summary: ""
date: 2024-07-14T18:30:41-05:00
lastmod: 2024-07-14T18:30:41-05:00
draft: false
weight: 900
toc: true
seo:
  title: "" # custom title (optional)
  description: "" # custom description (recommended)
  canonical: "" # custom canonical URL (optional)
  noindex: false # false (default) or true
---

## The basic thing

OpenFusion includes a Makefile for easy compilation. On most Linux distributions and other Unix/Unix-like operating systems, the system will either include the `make` command or make it easy to install build tools which include the `make` command. As Windows doesn't come with these tools, we'll be using MSYS2 to build.

Here's what you should do if you don't know how to get everything working yourself. Please make sure you read the entire guide.

1. Grab the latest version of MSYS2 available on the [MSYS2 website](https://www.msys2.org/#installation). The installation will take a while - just let it do its work.
2. **Open up a MSYS2 shell using the "MSYS2 MinGW 64-bit" shortcut.**
3. Update MSYS2 using the command `pacman -Syu`. Type `y` and press enter to confirm the installation.
It'll probably ask you to close the shell. If your shell closes, reopen it using the same shortcut.
4. Now that your install of MSYS2 is up to date, you can install `mingw-w64` and its distribution of GCC.
Run the command `pacman -S base-devel mingw-w64-x86_64-gcc mingw-w64-x86_64-sqlite3`. 
The defaults are somewhat heavy, but the safest bet. Press enter to accept the all of the packages  `pacman` has found.
After that, you'll be asked to confirm the installation. Again, type `y` and press enter. The installation will take a while.
5. `cd` to your OpenFusion source folder.
**Note:** To access your Windows drive, `cd` to `/(drive letter name)`. For example, my drive is at `C:\` and the source files are on my desktop, so I'll do `cd /c/Users/Raymonf/Desktop/OpenFusion`. Notice that the paths follow Unix naming conventions, so a forward slash is used instead of a backwards slash.
6. Create a folder called `bin` for your binaries: the command `mkdir bin` should do. If you miss this step, you'll have a linker error.
7. Run the command `make windows` to build the `windows` target.
8. If there are no errors (warnings are fine), your compiled binary should be in the `bin` folder you made.

## Doing Git the right way

As OpenFusion is hosted on Github, it uses Git as its version control system. The above guide somewhat assumes that you have already cloned the Git repository using the `git clone` command, or have downloaded an archive (zip file) of the source.

If you used `git clone`, the following guide is not for you. You're all set to go in that case. Otherwise, we might as well install `git` within MSYS2.

You can use Git for Windows if you'd like. Simply skip to step 3 on a "Git Bash" shell.

1. In your MSYS2 shell, run `pacman -S git`. It'll ask you to confirm the installation by typing `y` and hitting enter.
2. After Git is done installing, you should be able to run the command `git` and have it give you a long list of commands you can run. Confirm that it works.
3. `cd` to the folder you want to clone the project to. Git will clone the repository to a new folder, so just `cd` to where you want that folder to be made.
For example, if I'm at my desktop, a new folder called `OpenFusion` will be created with the source files in it.
4. Clone the repository. Use the command `git clone --recurse-submodules https://github.com/OpenFusionProject/OpenFusion.git` to clone the upstream OpenFusion repository - or, if you have a personal fork, you can clone that using the full URL.
5. `cd` to the `OpenFusion` folder: `cd OpenFusion`.

At this point, you should have a properly initialized Git repository. You can run `git pull` to grab any of the latest changes and then compile the latest changes using `make windows` at any time.

## Protocol Version Selection

OpenFusion supports multiple packet versions (`20100104`, `20100728`, and `20111013` at the time of writing). To build with these versions, you can define `PROTOCOL_VERSION`. For example:

```
make windows PROTOCOL_VERSION=728
```

Notice that the protocol versions are month and day, without the leading zero. Therefore, `20100104` would be `104`.
