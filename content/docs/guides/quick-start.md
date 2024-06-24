---
title: "Quick Start"
description: "Guides lead a user through a specific task they want to accomplish, often with a sequence of steps."
summary: ""
date: 2023-09-07T16:04:48+02:00
lastmod: 2023-09-07T16:04:48+02:00
draft: false
weight: 810
toc: true
seo:
  title: "" # custom title (optional)
  description: "" # custom description (recommended)
  canonical: "" # custom canonical URL (optional)
  noindex: false # false (default) or true
---

### Getting in the game

#### Method A: Installer (Easiest)
1. Download the client installer by clicking [here](https://github.com/OpenFusionProject/OpenFusion/releases/download/1.5/OpenFusionClient-1.5-Installer.exe) - choose to run the file.
2. After a few moments, the client should open: you will be given a choice between two public servers by default. Select the one you wish to play and click connect.
3. To create an account, simply enter the details you wish to use at the login screen then click Log In. Do *not* click register, as this will just lead to a blank screen.
4. Make a new character, and enjoy the game! Your progress will be saved automatically, and you can resume playing by entering the login details you used in step 3.

#### Method B: Standalone .zip file
1. Download the client from [here](https://github.com/OpenFusionProject/OpenFusion/releases/download/1.5/OpenFusionClient-1.5.zip).
2. Extract it to a folder of your choice. Note: if you are upgrading from an older version, it is preferable to start with a fresh folder rather than overwriting a previous install.
3. Run OpenFusionClient.exe - you will be given a choice between two public servers by default. Select the one you wish to play and click connect.
4. To create an account, simply enter the details you wish to use at the login screen then click Log In. Do *not* click register, as this will just lead to a blank screen.
5. Make a new character, and enjoy the game! Your progress will be saved automatically, and you can resume playing by entering the login details you used in step 4.

Instructions for getting the client to run on Linux through Wine can be found [here](https://github.com/OpenFusionProject/OpenFusion/wiki/Running-the-game-client-on-Linux).

### Hosting a server
1. Grab `OpenFusionServer-1.5-Original.zip` or `OpenFusionServer-1.5-Academy.zip` from [here](https://github.com/OpenFusionProject/OpenFusion/releases/tag/1.5).
2. Extract it to a folder of your choice, then run `winfusion.exe` (Windows) or `fusion` (Linux) to start the server.
3. Add a new server to the client's list:
    1. For Description, enter anything you want. This is what will show up in the server list.
    2. For Server IP, enter the IP address and port of the login server. If you're hosting and playing on the same PC, this would be `127.0.0.1:23000`.
    3. Lastly Game Version - select `beta-20100104` if you downloaded the original zip, or `beta-20111013` if you downloaded the academy zip.
5. Once you've added the server to the list, connect to it and log in. If you're having trouble with this, refer to steps 4 and 5 from the previous section.