---
title: "Compilation with CMake or Visual Studio"
description: ""
summary: ""
date: 2024-07-14T18:31:29-05:00
lastmod: 2024-07-14T18:31:29-05:00
draft: false
weight: 901
toc: true
seo:
  title: "" # custom title (optional)
  description: "" # custom description (recommended)
  canonical: "" # custom canonical URL (optional)
  noindex: false # false (default) or true
---

## Introduction

OpenFusion comes with a regular Makefile and also a CMakeLists file. This allows the user to choose what they want to use to compile. In general, the Makefile will always work out of the box, whereas the CMakeLists file may not work for a few commits if a large change is made to the codebase's file structure.

The advantage of using CMake is that CMake will create customized build files for whatever build environment you'd like to make. Depending on the context, it may be easier to set up than using the regular Makefile.

## All Environments

Assuming you have a working build environment for C++ set up and `cmake` installed, you can simply generate the project files into another directory. The `.gitignore` file ignores a directory named `build`, so it is recommended to generate the build files there:

```bash
cmake -B build    # Assuming you are in the OpenFusion source directory
```

Please note that the OpenFusion CMakeLists prevents you from creating an in-source build as it pollutes the source directory and makes things annoying for everyone. You can put your build files anywhere, obviously.

## Visual Studio

If you are a Visual Studio user, you should probably use CMake to build OpenFusion. There exist [forks](https://github.com/josephl70/OpenFusion_VS) of OpenFusion maintained by other people that may not necessarily always be up-to-date, if you'd like to go that route instead. Otherwise, continue on if you'd like to use CMake.

### Install the CMake tools

To begin, make sure you have Visual Studio with the CMake tools installed. If you don't have Visual Studio, you can grab it from Microsoft's website. The "Community" version will do just fine for OpenFusion. Simply install "C++ CMake tools for Windows".

If you already have Visual Studio installed, you can make sure you have CMake tools installed (or install them) by clicking "Modify" on your installation of Visual Studio, and checking for "C++ CMake tools for Windows" under the "Individual Components" tab.

### Start the Visual Studio Developer Command Prompt

In your start menu, search for "Developer Command Prompt for VS 2019" (or the version of VS you're using). After that, simply `cd` to your source directory as you'd normally do in a command prompt window. Finally, generate the build files as detailed in the "All Environments" section:

```
cmake -B build
```

You'll find `OpenFusion.sln` inside the build directory, all ready to go. From there, you should be able to use the Visual Studio solution as if it were a regular C++ project in Visual Studio, more or less.

Additionally, you can compile the project straight from the command line using cmake's `--build` flag, eg:

```
cmake --build build
```

You'll find the output binary in the `bin` directory. Run it like so:

```
.\bin\winfusion.exe
```
> For unix environments (non-windows), the binary will be named `fusion`

## Protocol Version Selection

OpenFusion supports multiple packet versions (`20100104` and `20100728` at the time of writing). To build with these versions, you can define `PROTOCOL_VERSION`. For example:

```
cmake -B build -DPROTOCOL_VERSION=728
```

Notice that the protocol versions are month and day, without the leading zero. Therefore, `20100104` would be `104`.
