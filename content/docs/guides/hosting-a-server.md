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
  title: "How to host an OpenFusion server"
  description: "This guide describes in depth how to setup your own OpenFusion server"
  canonical: ""
  noindex: false
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

The first thing you want to do is download the Server files as described in the beginning of this guide. Once you have the server files you'll want to edit the `config.ini` file to setup your server. This guide won't go in depth of every possible server setting, check the [OpenFusion GitHub Readme](https://github.com/OpenFusionProject/OpenFusion?tab=readme-ov-file#configuration) for more details on server configuration.

The first section you might need to change is `login`. Note that by default the Login Server runs on port `23000`. If you plan on hosting both versions of the game, `academy` and `original` in the same machine, you have to use different ports for each of them. Make you sure pick ports that do not clash with other applications running on the same machine.
For example, you could have an `original` server running the Login Server on port `23000` and an `academy` server running on port `24000`. If you're planning to have just one version on the server, you can keep the default port.

The next section you need to change is `shard`. Note that the Shard Server uses the next port in the sequence, `23001`, if you're running 2 different versions of the server change this port so it's different from the other version. For example, `original` could run the Shard Server on port `23001` and `academy` on `24001`. Again, make sure the port you set here is not used by any other applications in the same machine.
The next important setting in this section is the `ip` setting. By default it's set to `127.0.0.1` which is the address of the localhost, that means, the machine that is running the server. To make this server available on the network, be it local or not, you have to set it to the IP address of this machine in your network. For that you have to check you DHCP settings and find out what is the IP assigned to the machine you're running the server on, for example `192.168.18.115`.

Optionally you could also configure the `monitor` section if you need it to run on another port. Note that the `listenip` here is `127.0.0.1` and you should keep it, as the monitor server will look for the server in this same machine, so this is the correct address.

After configuring the ports and IP address, you're good to move on to the next phase. If you want to further customize your settings this is a good time to do it.

### Quick tip on hosting both versions

If you plan on hosting both versions in the same machine, keep all their files organized so it's easy to tell the configuration files apart. A good directory structure to follow looks something like this (note that API files are present here, but are completely optional, we go into more detail about it in [Making an endpoint server](#Making an endpoint server)):
```
.
|-- academy
|   |-- OpenFusionServer-Linux-Academy (server files)
|   |   `-- ...
|   |-- ofapi (api files)
|   |   `-- ...
|   |-- openfusion-academy.service (systemd service for server)
|   `-- openfusionapi-academy.service (systemd service for api)
`-- original
    |-- OpenFusionServer-Linux-Original
    |   `-- ...
    |-- ofapi
    |   `-- ...
    |-- openfusionapi-original.service
    `-- openfusion-original.service
```

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
 3. Update `config.ini` with your static IP address or dynamic DNS.

### Accessing the machine from any network

If you're setting the server on a machine in your house chances are you do not have a static IP address. In that case you can either use a dynamic DNS service like No-IP, DuckDNS or Cloudflare API or contact your ISP for a static IP address. It is highly recommended that you create a DNS record for this IP address so it's easy to remember and share.

For example, say you're running the server on a Linux machine in your house, and you have a static IP. You can create a DNS record like `openfusion.myhouse.com` to point to your local IP and access the server via that domain. Note that for this you need to acquire a domain.

Once you have a way to talk to this machine from any network, you need to make sure that the ports you setup for the `login` and `shard` servers are open in this machine, and in your router if that's the case. Setting up port forwarding is different depending on your router model, whether you're using a VPS, etc, so make sure to look for a guide for your specific case here. The goal is to have the `login` and `shard` ports (`23000` and `23001` in this example) open.

After setting up port forwarding for the login and shard servers, make sure that the shard server IP address is set to your public external IP address, or your DNS domain that points to it. If you have set it to your internal IP address, like you're setting up a local server, people from outside your network won't be able to play. This setup, however, can have it's issues, see [Tricky detail](#Tricky detail) section bellow.

### Login into your own server

Once you have the server running on a machine that you can access from any network, either with a DNS record or directly with the IP address, and the ports are open, you can already connect to your own OpenFusion server. Open the launcher in any computer connected to the internet, add a new server as described in the [Hosting a local server](#Hosting a local server) section, but this time use the IP address or your domain for it, and use the `login` port.
For example: If your domain is `openfusion.myhouse.com` and your `login` server is running on port `23000`, set the `Server Host` field to `openfusion.myhouse.com:23000`.

#### Tricky detail

You might not be able to access your own server if you are in the same network as it by using it's external IP address. This will be an issue if you setup a server in your home network for example, people from outside your home network will be able to access it just fine but you, from inside your home network, won't.
For you to be able to access it from inside your home network you'll have to setup the shard server IP address with your internal IP address, but people from outside this network won't be able to access it.
To fully solve this issue you'll have to configure [NAT loopback (also called NAT Hairpinning)](https://en.wikipedia.org/wiki/Network_address_translation#NAT_hairpinning) in your router. This guide will not go into details on how to do this as it depends on your router and networking setup, but it's easy to find guides for this online.

## Server Versions

OpenFusion supports 2 versions of the game, Original and Academy. The setup process is the same for both versions, the only difference is the server files that you'll download. Both can be found in the linked pages on the top of this doc.
To run both versions in the same machine, you'll have to download both versions and follow this guide for both versions. That means downloading both versions, configuring the `config.ini` file for each of them, making sure to use different port numbers, as mentioned before, and setting up 2 different systemd services if you want that. Make sure to also setup 2 different domains for this, pointing to the same IP address, and your proxy will have to handle both domains.

### Version numbers

There are many different versions supported by OpenFusion, the 2 main ones are:
+ Academy: `beta-20111013`
+ Original: `beta-20100104`

These are the versions you'll be using to run classic OpenFusion, with the correct assets for Academy and Original.
For more information on the different versions, check the [OpenFusion Discord Server](https://discord.gg/DYavckB).

### Making an endpoint server

At this point you have a fully working OpenFusion simple server, which you can access via the launcher using the IP address or domain for you server, and you'll have to login every time after connecting to the server.

There's an improvement you can make to this setup so that you can have extra features, such as login memory, account management, monitoring and more. To do this, you'll need to add [OpenFusion API](https://github.com/OpenFusionProject/ofapi) to the server. This is an API (Application Programming Interface) that will communicate with the OpenFusion server to extended it's management features.

*IMPORTANT*: To set OpenFusion API (OF API from now on) it is mandatory that you setup TLS for it, and it becomes a real risk if you don't have it secured with TLS.

#### Getting started with OF API

The first thing is to read the README of the project, [here](https://github.com/OpenFusionProject/ofapi), then download the code for OF API from the GitHub repository [here](https://github.com/OpenFusionProject/ofapi/tags). Download the latest version, extract it, and build the API executable with `cargo build --release`, this command will generate a binary in `./target/release/ofapi`.

Once you have the program built, you'll want to change the `config.toml` file to configure it according to your server setup.
You must enable (uncomment) the `core` and `game` sections, and those must be configured properly. It is also recommended that you enable and configure the `monitor` section, so the launcher can report how many players are online to the users.

Keep in mind that if you have OF API setup you won't need a domain that points directly to your OpenFusion server, as OF API will handle it for you, so your domain should point to OF API instead. You'll still need the OpenFusion server ports open.

#### Configuring OF API

This is pretty straight forward, in `core` section, set `server_name` to whatever you'd like to name your server, `public_url` to your server's domain (the one you setup with the DNS records), you could configure it with the IP directly too. For `db_path` use the path to the `database.db` in the server folder, if you followed the recommended directory structure this will be `../OpenFusionServer-Linux-Academy/database.db`, `templates_dir` set to `./templates`, `port` to whatever port you like, just make sure to use a port that doesn't clash with any other application in your system.

For `bind_ip` you'll use `0.0.0.0` if your proxy is running in another machine, or `127.0.0.1` if you proxy is running in the same machine as OF API. We'll talk more about proxy configuration in a moment.

Now moving to `tls` section, this must be enabled if you plan on exposing the server to the public, however, you can handle TLS through your proxy. This tutorial will describe how to handle TLS via a proxy, like Nginx or caddy, if you wish to handle TLS through OF API, the `README` has more details about it.
For the TLS section, if you're using TLS through OF API, set `cert_path` and `key_path` to the path to your TLS certificates, if you're using TLS through a proxy you can set these values to whatever, for example, `cert.pem`.

The important setting here is the port, which again, has to be set to a port that is not used anywhere else. For keeping things easy to remember it's recommended to set this port to `4433`, as port `443` is the default TLS port, but in practice you can set it to whatever port you want.

In the `game` section you have to set the versions list with the UUID for the versions that your server supports. For just running a basic Academy server you'll have this set to `["6543a2bb-d154-4087-b9ee-3c8aa778580a"]`, which is the UUID corresponding to version `beta-20111013`, for a basic Original server you'll set it to  `["ec8063b2-54d4-4ee1-8d9e-381f5babd420"]`, which corresponds to the UUID for the `beta-20100104` version. If you wish to support other versions you'll have to check for their UUID in the Launcher files, to find it go to the folder where you downloaded and extracted the launcher, and go to `defaults/versions/`. In this folder you'll find a json file describing each of the versions, and inside there's an UUID field, which is the value you're looking for here.

For `login_address` you'll set your server's IP address or it's domain, and the port that you configured in the server for the login address, in this example `23000` for Original and `24000` for Academy. So it should look like this: `my.openfusion.original.server.com:23000`. If you want to have a custom loading screen you also have to set `custom_loading_screen` to `true` and put it's files in `static/launcher/loading`.

In the `monitor` section keep `route = "/status"` and make sure that `monitor_ip` is set to the IP and port of the machine that is running the server. In this example it's the same machine, so use `127.0.0.1`, and the port is the value you set in the server's `config.ini` for the monitor service. For example `monitor_ip = "127.0.0.1:8003"`.

In the `account` section you'll configure how to manage accounts, so if the user needs to verify their email, if an email is required, etc. This will depend on how you want to manage your server, so feel free to set it up however you like. The subroutes settings can be left as the defaults, no need to change those. Pay special attention to the `account_level` settings, as that will determine the permission level for the accounts created in your server, take a look at the description bellow for the account level descriptions.
```
# account permission level that will be set upon character creation
1 = default, will allow *all* commands
30 = allow some more "abusable" commands such as /summon
50 = only allow cheat commands, like /itemN and /speed
99 = standard user account, no cheats allowed
any number higher than 50 will disable commands
```

In the `auth` section you can leave the settings as is, except for `secret_path`, which is recommended to use a random string of numbers and letters to keep your server secure. You can generate a random string in linux with the following command: `echo $(date +%s | sha256sum | base64 | head -c 32)`.

Here's an example `config.toml` file for OF API:
```
[core]
server_name = "My OpenFusion Server"
public_url = "api.myserver.xyz"
db_path = "../OpenFusionServer-Linux-Academy/database.db"
template_dir = "./templates"
bind_ip="0.0.0.0"
port = 8888

[tls]
cert_path = "cert.pem" # app-level TLS only
key_path = "key.pem" # app-level TLS only
port = 4433

[game]
versions = ["6543a2bb-d154-4087-b9ee-3c8aa778580a"]
login_address = "openfusion.myserver.xyz:24000"
custom_loading_screen = false

[monitor]
route = "/status"
monitor_ip = "127.0.0.1:8003"

[moderation]
namereq_route = "/namereq"

[rankinfo]
route = "/getranks"
placeholders = true

[account]
route = "/account"

register_subroute = "/register"
account_level = 99
require_email = false
require_email_verification = false

email_verification_subroute = "/verify"
email_verification_valid_secs = 3_600 # one hour

update_email_subroute = "/update/email"
update_password_subroute = "/update/password"

temporary_password_subroute = "/otp"
temporary_password_valid_secs = 3_600 # one hour

[auth]
route = "/auth"
refresh_subroute = "/session"
secret_path = "ZWQzYjFiYzZjM2YyZThhYjRmMjM0Y2M1"
valid_secs_refresh = 604_800 # one week
valid_secs_session = 900 # 15 minutes

[cookie]
route = "/cookie"
valid_secs = 60

[legacy]
index_route = "/index.html"
assetinfo_route = "/assetInfo.php"
logininfo_route = "/loginInfo.php"
```

With the configuration set you can now start the OF API server, if you are on Linux it's recommended to create a systemd service for it, as described in [Server service configuration](#Server service configuration). The difference is that this service will execute OF API instead of the OpenFusion server. You can use this as a template, remember to change the placeholders as described previously:

```
[Unit]
Description=Open Fusion API - <SERVER_VERSION>
After=network-online.target
Wants=network-online.target

[Service]
WorkingDirectory=<PATH/TO/OFAPI/DIRECTORY>
ExecStart=<PATH/TO/OFAPI/DIRECTORY>/target/release/ofapi
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

#### Configuring a Proxy for OF API

Now that you have OF API up and running, you need to setup a reverse proxy to route the traffic to it. If you already have a reverse proxy running in another machine in your network you'll just point it to the machine running OF API, and make sure to configure OF API to bind on IP address `0.0.0.0`. The other option is running the reverse proxy in the same machine as OF API and the OpenFusion servers, in which case OF API must bind to IP address `127.0.0.1`.

The configuration for the reverse proxy is pretty simple, basically you just have to configure it for the domain you have pointed to OF API, which is the `public_url` setting in `config.toml`, and point it to the IP address of the machine running OF API, or `127.0.0.1` if it's running in the same machine as the proxy.

That's the general idea, which you can apply for every reverse proxy. This guide will only describe how to set it up with nginx, and also provide an example with caddy. Nginx is a very popular tool and you can easily find tutorials on how to configure it in detail, this guide will focus on the top level steps on setting it up, it is up to you to choose the best option for your scenario.

##### Setting up Nginx

1. Install Nginx
2. Create `/etc/nginx/sites-available/openfusionapi-<SERVER_VERSION>.conf` nginx config following the template bellow
3. Enable the nginx configuration with this command: `ln -s /etc/nginx/sites-available/openfusionapi-<SERVER_VERSION>.conf /etc/nginx/sites-enabled/`
4. Acquire a SSL certificate. You can do this via a Cloudflare DNS Challenge or [Let's Encrypt](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-20-04) for example

After completing these steps you'll be good to go

Nginx example configuration, remember to change the placeholders.
```nginx
# /etc/nginx/sites-available/openfusionapi-<SERVER_VERSION>.conf

# This server block handles traffic for your domain on port 8888
server {
    listen 8888 ssl;
    listen [::]:8888 ssl;

    server_name <YOUR_DOMAIN>; # Domain you pointed to OF API, should be the same as `public_url` in of api's config

    # --- SSL Configuration ---
    # These paths point to the certificates that will be generated by Certbot.
    ssl_certificate /etc/letsencrypt/live/<YOUR_DOMAIN>/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<YOUR_DOMAIN>/privkey.pem;

    location / {
        # Forward the request to the of api
        proxy_pass http://<OF_API_IP>:8888; # OF API ip address, 127.0.0.1 if running on same machine, other machine's internal IP if not

        # --- Standard Proxy Headers ---
        # These headers pass along useful information to the backend server.
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # --- WebSocket Support ---
        # Essential for many real-time applications like game servers.
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

# This server block handles traffic for your domain on port 4433
server {
    listen 4433 ssl http2;
    listen [::]:4433 ssl http2;

    server_name <YOUR_DOMAIN>; # same as above

    # --- SSL Configuration ---
    # We use the same certificate for both ports.
    ssl_certificate /etc/letsencrypt/live/<YOUR_DOMAIN>/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<YOUR_DOMAIN>/privkey.pem;

    location / {
        # Forward the request to the second local game server process
        proxy_pass http://<OF_API_IP>:4433; # same as above

        # --- Standard Proxy Headers ---
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # --- WebSocket Support ---
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

Here's an example for another popular tool, Caddy, using Cloudflare's DNS challenge for SSL:
```caddy
# HTTP traffic on port 80 proxies to port 8888
http://openfusion-api.mydomain.xyz {
        log
        reverse_proxy <OF_API_IP>:8888
}

# HTTPS traffic on port 443 proxies to port 4433
openfusion-api.mydomain.xyz {
        log
        tls {
                dns cloudflare <cloudflare dns challenge token here>
        }
        reverse_proxy <OF_API_IP>:4433
}
```

With OF API and it's OpenFusion server up and running you can now open the launcher and connect to your endpoint server using the `public_url` you configured in `config.toml`.
{{< figure
  src="images/2.0-launcher-adding-endpoint.png"
  alt="Adding a simple server"
>}}

TODO
+ Custom assets for your server
+ Running a fully standalone server (no fetching assets from the internet)
