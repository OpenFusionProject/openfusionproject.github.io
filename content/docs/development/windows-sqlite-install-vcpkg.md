---
title: "Installing SQLite on Windows using vcpkg"
description: ""
summary: ""
date: 2024-07-14T18:31:53-05:00
lastmod: 2024-07-14T18:31:53-05:00
draft: false
weight: 990
toc: true
seo:
  title: "" # custom title (optional)
  description: "" # custom description (recommended)
  canonical: "" # custom canonical URL (optional)
  noindex: false # false (default) or true
---

To compile OpenFusion on Windows using Visual Studio, you first need to grab SQLite. One of the easier ways to do this is using [vcpkg](https://github.com/microsoft/vcpkg). This guide will detail how to install vcpkg, then use it to install SQLite, and finally integrate everything into VS.

## Getting vcpkg
1. First, make sure git is installed - you can download it [here](https://git-scm.com/download/win).
2. Now open a command prompt where you want to download vcpkg to.
3. Run ``git clone https://github.com/microsoft/vcpkg`` - this should clone vcpkg to a new folder.
4. Change directory into the vcpkg folder, then run ``bootstrap-vcpkg.bat`` to compile vcpkg.

## Getting SQLite
1. Now that you have vcpkg installed, run ``vcpkg install sqlite3:x64-windows`` to download and install SQLite.
2. Once the above command finishes, run ``vcpkg integrate install`` to integrate everything into Visual Studio.
3. You should now be able to compile! Happy coding!
