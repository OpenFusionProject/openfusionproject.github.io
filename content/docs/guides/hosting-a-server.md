---
title: "Hosting a Server"
description: ""
summary: ""
date: 2024-07-14T17:57:37-05:00
lastmod: 2024-10-10T17:19:07+02:00
draft: false
weight: 720
toc: true
seo:
  title: "" # custom title (optional)
  description: "" # custom description (recommended)
  canonical: "" # custom canonical URL (optional)
  noindex: false # false (default) or true
---

There are essentially 2 ways you can host your own OpenFusion server, the first is if you just want to play by yourself on your computer,
in which case you'll run both the server and the launcher in the same machine. The other is to host the server in a separate machine, available
via the network, in which you'll just run the launcher on your computer and connect to the server running on another machine. This second option
allows for other users to connect to your server and play with you. In this guide we'll cover both scenarios in depth.

# Getting started

Start by downloading the latest version of the Server [here](https://github.com/OpenFusionProject/OpenFusion/releases). Note that there are 2 versions for each platform, Original and Academy.
Download the version you want, or both, we'll get into how to host both server versions in the same machine here.
Make sure to download the files for the platform you'll host the server in, either Windows or Linux.

Extract all the `.zip` files and you're good to go!

One thing to notice here is that the files you downloaded are only the code of the server, the game assets are not included here, so you'll still need an internet connection to play the game, as the launcher will download the assets from an OpenFusion server on startup.

# Hosting a local server

If all you want is to play the game by yourself you're pretty much good to go. All you have to do is start the server by running the server program, `winfusion.exe` if you're on Windows or `fusion` if you're on Linux.

Once you open the Launcher you'll see the server selection screen. Note that it comes with the `OpenFusion Original` and `OpenFusion Academy` servers pre-configured for you.

{{< figure
  src="images/2.0-launcher-fresh-start.png"
  alt="Launcher on a fresh installation"
>}}

To add your local server to the list click on the `+` icon on the left bottom corner of the server selection list. It will open a pop-up for you to type your server information. If you're just playing locally you can leave it as is, if you're hosting your server on another machine we'll explain how to set it up later.

The important thing to notice in this screen is the version selector. If you're running the `Original` server, you have to select version `beta-20100104`, if you're running the `Academy` server, you have to select `beta-20111013`.

{{< figure
  src="images/2.0-launcher-adding-simple-server.png"
  alt="Adding a simple server"
>}}

# Hosting a remote server

The setup for a remote server is not so different from a local server, the key changes are in the configuration files and in the setup for making it available to other users.
For the sake of completion this guide describes how to configure a server that is accessible from the internet, as the setup is the same for making a local network server, with some more configuration required.

## Important notes

+ The OpenFusion server *does not* run on the HTTP protocol. That means that you can not put it behind a HTTP proxy, like Nginx.
+ From this point on this guide will get more technical, however, it won't go in depth on the technicalities. There will be references and suggestions on tools to use and where to find tutorials for those tools. Nothing here is too complicated and there are many good tutorials today on these topics.
+ The exact steps that you need to take for each part of the setup will vary depending on the architecture you're using here. For example, a homelab is different than using a VPS. This guide will describe what needs to be setup and how, but you will have to look into how exactly to set it up for your case.

## Configuring the server

The first thing you want to do is download the Server files as described in the beginning of this guide. Once you have the server files you'll want to edit the `config.ini` file to setup your server. This guide won't go in depth of every possible server setting, check the [OpenFusion GitHub Readme](https://github.com/OpenFusionProject/OpenFusion?tab=readme-ov-file#configuration) for more details on the server configuration.

The first section you might need to change is `login`. Note that by default the Login Server runs on port `23000`. If you plan on hosting both versions of the game, `academy` and `original` in the same machine, you have to use different ports for each of them. Make you sure pick ports that do not clash with other applications running on the same machine.
For example, you could have an `original` server running the Login Server on port `23000` and an `academy` server running on port `24000`. If you're planning to have just one version on the server, you can keep the default port.

The next section you need to change is `shard`. Note that the Shard Server uses the next port in the sequence, `23001`, if you're running 2 different versions of the server change this port so it's different from the other version. For example, `original` could run the Shard Server on port `23001` and `academy` on `24001`. Again, make sure the port you set here is not used by any other applications in the same machine.
The next important setting in this section is the `ip` setting. By default it's set to `127.0.0.1` which is the address of the localhost, that means, the machine that is running the server. To make this server available on the network, be it local or not, you have to set it to the ip address of this machine in your network. For that you have to check you DHCP settings and find out what is the ip assigned to the machine you're running the server on, for example `192.168.18.115`.

Optionally you could also configure the `monitor` section if you need it to run on another port. Note that the `listenip` here is `127.0.0.1` and you should keep it, as the monitor server will look for the server in this same machine, so this is the correct address.

After configuring the ports and ip address, you're good to move on to the next phase. If you want to further customize your settings this is a good time to do it.

## Server service configuration

If you're running the server on a Linux machine it's highly recommended to have a systemd service to manage the server process.
If you're on windows skip this step.
To do this, create a file in `/etc/systemd/system/` to configure the service.

```
sudo touch /etc/systemd/system/openfusion-<SERVER_VERSION>.service
```

Change `<SERVER_VERSION>` to `original` or `academy`, so you know exactly what service is for what server. Then edit the file with the following lines:

```
[Unit]
Description=Open Fusion Server - <SERVER_VERSION>
After=network-online.target
Wants=network-online.target

[Service]
WorkingDirectory=<PATH/TO/OPENFUSION/SERVER/FILES>
ExecStart=<PATH/TO/OPENFUSION/SERVER/FILES>/fusion
Restart=on-failure
RestartSec=10
User=root
Group=root
Type=simple
TimeoutStartSec=300
TimeoutStopSec=120

[Install]
WantedBy=multi-user.target
```

Make sure to change the `<PATH/TO/OPENFUSION/SERVER/FILES>` to the path of your server files. To get this path you can open a terminal in the folder that contains the `config.ini` file and run the `pwd` command.

Note that the `ExecStart` line must end with `/fusion`, as this is the program that runs the OpenFusion server.

To start the server you can now run:

```
sudo systemctl daemon reload
sudo systemctl enable openfusion-<SERVER_VERSION>.service
sydo systemctl start openfusion-<SERVER_VERSION>.service
```

## Making the server available to the internet

## Local network only

If you wish for this server to be available only in your local network, you are good to go. All you need to do now is to open the OpenFusion launcher and add a new server, as described in the [Hosting a local server](#Hosting a local server) section. The key difference here is that you'll configure the `Server Host` field with the IP address you set in the `shard` section of the `config.ini` file, and use the port you set in the `login` section of the `config.ini` file.

## Opening the server to the internet

To make the server available for people all over the world to play it there are requirements you must meet first.
 1. Having a way to access this machine from any network. Be it via a static IP address or dynamic DNS.
 2. Setting up port Forwarding for the machine

### Accessing the machine from any network

If you're setting the server on a machine in your house chances are you do not have a static IP address. In that case you can either use a dynamic DNS service like No-IP, DuckDNS or Cloudflare API or contact your ISP for a static IP address. It is highly recommended that you create a DNS record for this IP address so it's easy to remember and share.

For example, say you're running the server on a Linux machine in your house, and you have a static IP. You can create a DNS record like `openfusion.myhouse.com` to point to your local IP and access the server via that domain. Note that for this you need to acquire a domain.

Once you have a way to talk to this machine from any network, you need to make sure that the ports you setup for the `login` and `shard` servers are open in this machine, and in your router if that's the case. Setting up port forwarding is different depending on your router model, whether you're using a VPS, etc, so make sure to look for a guide for your specific case here. The goal is to have the `login` and `shard` ports (`23000` and `23001` in this example) open.

### Login into your own server

Once you have the server running on a machine that you can access from any network, either with a DNS record or directly with the IP address, and the ports are open, you can already connect to your own OpenFusion server. Open the launcher in any computer connected to the internet, add a new server as described in the [Hosting a local server](#Hosting a local server) section, but this time use the IP address or your domain for it, and use the `login` port.
For example: If your domain is `openfusion.myhouse.com` and your `login` server is running on port `23000`, set the `Server Host` field to `openfusion.myhouse.com:23000`.



TODO:
+ Server versions
	- Original
	- Academy
	- Version Numbers
+ Making an endpoint server
+ Custom assets for your server
+ Running a fully standalone server (no fetching assets from the internet)
