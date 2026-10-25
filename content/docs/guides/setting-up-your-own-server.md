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

Start by downloading the latest version of the Server [here](https://github.com/OpenFusionProject/OpenFusion/releases). There are versions for both Windows and Linux, make sure to download the correct one for the platform you'll be hosting the server on.

Extract all the `.zip` files and you're good to go!

One thing to notice here is that the files you downloaded are only the code of the server, the game assets are not included here, so you'll still need an internet connection to play the game, as the launcher will download the assets from an OpenFusion server on startup.

# Understanding Server Versions

OpenFusion supports two main versions of the game:

*   **Original:** The original version of the game, with the Future.
*   **Academy:** Relaunch of the game where Cartoon Network removed the Future and added more content.

When you download the server files, you'll choose which version you want to host. It's also possible to run both versions on the same machine, but they will require separate configurations, which we'll cover in this guide.

Through out this guide versions are mentioned a lot, so use this section as reference for all the version information.

## Launcher Configuration

When adding a server to the OpenFusion Launcher, you must select the correct version for the server you are connecting to. These are the main versions to play:

*   **Original:** `beta-20100104`
*   **Academy:** `beta-20111013`

## API (Endpoint Server) Configuration

If you decide to set up an endpoint server with OpenFusion API, you will need to use an UUID for each version instead of their names, more on that in the [Making an endpoint server](#making-an-endpoint-server) section.

*   **Original:** `ec8063b2-54d4-4ee1-8d9e-381f5babd420`
*   **Academy:** `6543a2bb-d154-4087-b9ee-3c8aa778580a`

# Part 1: Hosting a Server for Solo Play

If all you want is to play the game by yourself on your own computer, the setup is very straight forward. All you have to do is start the server by running its executable file, `winfusion.exe` if you're on Windows or `fusion` if you're on Linux.

Once the server is running, open the Launcher. Note it comes with the `OpenFusion Original` and `OpenFusion Academy` servers pre-configured for you.

{{< figure
  src="images/2.0-launcher-fresh-start.png"
  alt="Launcher on a fresh installation"
>}}

To add your local server to the list, click on the `+` icon on the bottom left corner of the server list. This will open a pop-up for you to enter your server's information. Since you are playing locally, you can leave the default settings as they are.

The most important thing on this screen is the version selector. Make sure it matches the server version you are running.

{{< figure
  src="images/2.0-launcher-adding-simple-server.png"
  alt="Adding a simple server"
>}}

# Part 2: Hosting a Server for Multiplayer

The setup for a multiplayer server is not so different from a solo server, but it requires more configuration to make it available to other players, either on your local network or over the internet.

## Important notes

+ The OpenFusion server *does not* run on the HTTP protocol. That means that you can not put it behind a HTTP proxy, like Nginx.
+ From this point on this guide will get more technical, however, it won't go in depth on the technicalities. There will be references and suggestions on tools to use and where to find tutorials for those tools. Nothing here is too complicated and there are many good tutorials today on these topics.
+ The exact steps that you need to take for each part of the setup will vary depending on the architecture you're using here. For example, a homelab is different than using a VPS. This guide will describe what needs to be setup and how, but you will have to look into how exactly to set it up for your case.

## Automated Server Setup (Linux Only)

If you're running the server on linux there's an automated bootstrapping script that will set up a basic OpenFusion Server for you.

Run the commands bellow directly in a terminal to download and run the bootstrapping script.

```bash
# Download the script
wget https://openfusionproject.github.io/openfusion-server-bootstrapper.sh

# Make it executable
chmod +x openfusion-server-bootstrapper.sh

# Run the script as root
sudo ./openfusion-server-bootstrapper.sh
```

The script will guide you through the setup process with interactive prompts. For help and additional options, run:

```bash
./openfusion-server-bootstrapper.sh --help
```

**Note:** The bootstrapper automates most of the steps described in the manual sections below. If you prefer to understand each step or need to customize your setup beyond what the script offers, continue with the manual configuration sections.

## Manual Configuration

If you're not using the automated bootstrapper, or if you're on Windows, follow the manual setup instructions below.

### Configuring the server

The first thing you want to do is download the Server files as described in the beginning of this guide. Once you have the server files you'll want to edit the `config.ini` file to setup your server. This guide won't go in depth of every possible server setting, check the [OpenFusion GitHub Readme](https://github.com/OpenFusionProject/OpenFusion?tab=readme-ov-file#configuration) for more details on server configuration.

The first section you might need to change is `login`. Note that by default the Login Server runs on port `23000`. If you plan on hosting both versions of the game, `academy` and `original` in the same machine, you have to use different ports for each of them. Make you sure pick ports that do not clash with other applications running on the same machine.
For example, you could have an `original` server running the Login Server on port `23000` and an `academy` server running on port `24000`. If you're planning to have just one version on the server, you can keep the default port.

The next section you need to change is `shard`. The Shard Server uses the next port in the sequence, `23001` by default. If you're running two different versions of the server, you must also change this port to be unique for each. For example, `original` could run the Shard Server on port `23001` and `academy` on `24001`.

The next important setting is `ip` in the `[shard]` section. This setting tells the launcher where to connect to your server after login.
+ **For a Local Network (LAN) Server:** Set this to the internal IP address of the server machine (e.g., `192.168.1.10`).
+ **For an Internet Server:** Set this to your public IP address or a domain name that points to it (e.g., `openfusion.mydomain.xyz`).

Optionally you could also configure the `monitor` section if you need it to run on another port. Note that the `listenip` here is `127.0.0.1` and you should keep it, as the monitor server will look for the server in this same machine, so this is the correct address.

After configuring the ports and IP address, you're good to move on to the next phase. If you want to further customize your settings this is a good time to do it.

### Quick tip on hosting both versions

If you plan on hosting both versions in the same machine, keep all their files organized so it's easy to tell the configuration files apart. A good directory structure to follow, especially when using a dedicated user, is to place all server-related files in `/opt/openfusion`.

```
/opt/openfusion/
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

## Creating a dedicated user for the server

If you're running the server on a Linux machine, it is highly recommended to run it under a dedicated, unprivileged user account.

For this, create a new system group and user named `fusion`:
```bash
sudo groupadd --system fusion
sudo useradd --system -g fusion -d /opt/openfusion -s /bin/false fusion
```
These commands create a `fusion` group and a `fusion` user. This user can't log in to a shell (`/bin/false`) and its home directory is set to `/opt/openfusion`.

Next, create the directory structure and give the `fusion` user ownership of it:
```bash
sudo mkdir -p /opt/openfusion
sudo chown -R fusion:fusion /opt/openfusion
```
Now you can move your server and API files into the appropriate directories inside `/opt/openfusion`, as shown in the structure above. For example, you would move your extracted `OpenFusionServer-Linux-Original` files into `/opt/openfusion/original/server/`. Remember to run `chown` again if you add new files as root.

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
WorkingDirectory=/opt/openfusion/<SERVER_VERSION>/server
ExecStart=/opt/openfusion/<SERVER_VERSION>/server/fusion
Restart=on-failure
RestartSec=10
User=fusion
Group=fusion
Type=simple
TimeoutStartSec=300
TimeoutStopSec=120

[Install]
WantedBy=multi-user.target
```

Make sure to replace `<SERVER_VERSION>` with `original` or `academy`. The paths for `WorkingDirectory` and `ExecStart` now point to the standardized location we created.

Note that the `ExecStart` line must end with `/fusion`, as this is the program that runs the OpenFusion server.

To start the server you can now run:

```
sudo systemctl daemon reload
sudo systemctl enable openfusion-<SERVER_VERSION>.service
sudo systemctl start openfusion-<SERVER_VERSION>.service
```

## Hosting on a Local Network (LAN)

If you wish for this server to be available only to players on your local network, you are good to go. All you need to do now is open the OpenFusion launcher on another computer on the same network and add a new server.

The key difference from the solo launcher setup is that you'll configure the `Server Host` field with the internal IP address you set in the `shard` section of the `config.ini` file, and use the port you set in the `login` section.

## Hosting on the Internet

To make the server available for people all over the world to play it there are requirements you must meet first.
 1. Having a way to access this machine from any network. Be it via a static IP address or dynamic DNS.
 2. Setting up Port Forwarding for the machine
 3. Update `config.ini` with your public IP address or dynamic DNS as described previously.

### Accessing the machine from any network

If you're setting the server on a machine in your house chances are you do not have a static IP address. In that case you can either use a dynamic DNS service like No-IP, DuckDNS or Cloudflare API or contact your ISP for a static IP address. It is highly recommended that you create a DNS record for this IP address so it's easy to remember and share.

For example, say you're running the server on a Linux machine in your house, and you have a static IP. You can create a DNS record like `openfusion.mydomain.xyz` to point to your public IP and access the server via that domain. Note that for this you need to acquire a domain.

Once you have a way to talk to this machine from any network, you need to make sure that the ports you setup for the `login` and `shard` servers are open in this machine, and in your router if that's the case. Setting up port forwarding is different depending on your router model, whether you're using a VPS, etc, so make sure to look for a guide for your specific case here. The goal is to have the `login` and `shard` ports (`23000` and `23001` in this example) open.

### Connecting to Your Server

Once the server is running, you have a public domain or IP, and the ports are forwarded, you can connect to it from any computer on the internet. Open the launcher, add a new server, and use your public IP or domain for the `Server Host`, along with the `login` port.
For example: If your domain is `openfusion.mydomain.xyz` and your `login` server is running on port `23000`, set the `Server Host` field to `openfusion.mydomain.xyz:23000`.

### Connecting from the Same Network (NAT Loopback)

A common issue when hosting a server at home is that you might not be able to connect to it from a computer on the *same* network using its *public* IP address. Players from outside your network can connect just fine, but you can't.

This happens because your router doesn't know how to route the traffic back into your own network. The solution is a feature called [NAT loopback (or NAT Hairpinning)](https://en.wikipedia.org/wiki/Network_address_translation#NAT_hairpinning).

This guide will not go into details on how to configure this as it depends on your router and network setup, but searching for "how to enable NAT loopback on [your router model]" should give you the instructions you need.

### Running Both Server Versions

As mentioned in the [Understanding Server Versions](#understanding-server-versions) section, you can run both Original and Academy servers on the same machine.

To do this, you'll need to follow the setup process twice: one for each version. This means you will have two separate sets of server files, two `config.ini` files (with different ports), and two systemd services.

### Making an endpoint server

At this point you have a fully working OpenFusion simple server, which you can access via the launcher using the IP address or domain for you server, and you'll have to login every time after connecting to the server.

There's an improvement you can make to this setup so that you can have extra features, such as login memory, account management, monitoring and more. To do this, you'll need to add [OpenFusion API](https://github.com/OpenFusionProject/ofapi) to the server. This is an API (Application Programming Interface) that will communicate with the OpenFusion server to extended it's management features.

*IMPORTANT*: To set OpenFusion API (OF API from now on) it is mandatory that you setup TLS for it, and it becomes a real risk if you don't have it secured with TLS.

#### Getting started with OF API

The first thing is to read the README of the project, [here](https://github.com/OpenFusionProject/ofapi), then download the code for OF API from the GitHub repository [here](https://github.com/OpenFusionProject/ofapi/tags). Download the latest version, extract it, and build the API executable with `cargo build --release`, this command will generate a binary in `./target/release/ofapi`. You'll also need to install a reverse proxy, like Nginx or Caddy, you can do this in the same machine or in another one.

Once you have the program built, you'll want to change the `config.toml` file to configure it according to your server setup.
You must enable (uncomment) the `core` and `game` sections, and those must be configured properly. It is also recommended that you enable and configure the `monitor` section, so the launcher can report how many players are online to the users.

Keep in mind that if you have OF API setup you won't need a domain that points directly to your OpenFusion server, as OF API will handle it for you, so your domain should point to OF API instead. You'll still need the OpenFusion server ports open.

#### Configuring OF API

This is pretty straight forward, in the `config.toml` file, you'll need to adjust several sections.

##### [core]

Set `server_name` to whatever you'd like to name your server, and `public_url` to your server's domain (the one you set up with DNS records). For `db_path`, use the path to the `database.db` file in your OpenFusion server folder. If you followed the recommended directory structure, this will be something like `../OpenFusionServer-Linux-Academy/database.db`. Set `templates_dir` to `./templates`.

The `port` setting determines which port OF API will listen on for unencrypted HTTP traffic. You can set this to any port that doesn't clash with other applications, for example `8888`.

For `bind_ip`, you'll use `0.0.0.0` if your proxy is running in another machine, or `127.0.0.1` if your proxy is running in the same machine as OF API. We'll talk more about proxy configuration in a moment.

##### [tls]

This section is for handling encrypted HTTPS traffic. It must be enabled if you plan on exposing the server to the public, and you can handle TLS through a proxy or through OF API itselft. This guide will describe how to handle TLS via a proxy, like Nginx or Caddy.

The important setting here is the `port`, which must be set to a port that is not used by any other application. To keep things easy to remember, it's recommended to set this to `4433`, as the default SSL port is `443`, but you can use any port you like.

If you're using a proxy to handle TLS, you can leave `cert_path` and `key_path` with placeholder values like `cert.pem`.

##### [game]

In the `game` section you have to set the `versions` list with the UUID for the versions that your server supports. You can find the correct UUIDs in the [Understanding Server Versions](#understanding-server-versions) section near the top of this guide.

For `login_address` you'll set your server's domain and the port that you configured for the login server, for example `openfusion.mydomain.xyz:23000`.

##### [monitor]

In the `monitor` section, keep `route = "/status"` and make sure that `monitor_ip` is set to the IP and port of the machine running the OpenFusion server. Since it's the same machine, use `127.0.0.1` and the port you set in the server's `config.ini` for the monitor service. For example `monitor_ip = "127.0.0.1:8003"`.

##### [account]

In the `account` section you'll configure how to manage accounts, such as if email verification is required. This will depend on how you want to manage your server, so feel free to set it up however you like. Pay special attention to the `account_level` setting, as that will determine the permission level for new accounts.

```
# account permission level that will be set upon character creation
1 = default, will allow *all* commands
30 = allow some more "abusable" commands such as /summon
50 = only allow cheat commands, like /itemN and /speed
99 = standard user account, no cheats allowed
any number higher than 50 will disable commands
```

##### [auth]

In the `auth` section you can leave the settings as is, except for `secret_path`. It's recommended to use a random string of numbers and letters to keep your server secure. You can generate a random string in Linux with the following command: `echo $(date +%s | sha256sum | base64 | head -c 32)`.

Here's an example `config.toml` file for OF API:
```
[core]
server_name = "My OpenFusion Server"
public_url = "openfusion.myserver.xyz"
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

With the configuration set you can now start the OF API server, if you are on Linux it's recommended to create a systemd service for it, as described in [Server service configuration](#Server-service-configuration). The difference is that this service will execute OF API instead of the OpenFusion server. You can use this as a template, remember to change the placeholders as described previously:

```
[Unit]
Description=Open Fusion API - <SERVER_VERSION>
After=network-online.target
Wants=network-online.target

[Service]
WorkingDirectory=/opt/openfusion/<SERVER_VERSION>/ofapi
ExecStart=/opt/openfusion/<SERVER_VERSION>/ofapi/target/release/ofapi
Restart=on-failure
RestartSec=10
User=fusion
Group=fusion
Type=simple
TimeoutStartSec=300
TimeoutStopSec=120

[Install]
WantedBy=multi-user.target
```

#### Configuring a Proxy for OF API

Now that you have OF API up and running, you need to setup a reverse proxy to route traffic to it. A reverse proxy acts as a gateway between the internet and your OF API service. It can handle incoming web traffic and forward it to the correct application port on your server. This is where TLS will be handled for OF API.

Your proxy will listen on the standard web ports (80 for HTTP and 443 for HTTPS) and forward that traffic to the ports you configured in OF API's `config.toml` file (e.g., 8888 for HTTP and 4433 for HTTPS).

*IMPORTANT* If your proxy is running on a different machine, make sure you set `bind_ip="0.0.0.0"` in OF API's config. If the proxy is on the same machine, use `bind_ip="127.0.0.1"`.

The configuration for the reverse proxy is pretty simple. You'll set it up for the domain you've pointed to OF API (the `public_url` in `config.toml`) and have it forward requests to the machine running OF API.

*IMPORTANT:* If you're running both OpenFusion versions in the same machine, you'll have to do this twice, once for each OF API instance. This means you'll need two different domains (e.g., `academy.mydomain.xyz` and `original.mydomain.xyz`) and two proxy configurations, each pointing to the correct ports for its corresponding OF API instance.

##### Setting up Nginx

1. Install Nginx
2. Create `/etc/nginx/sites-available/openfusionapi-<SERVER_VERSION>.conf` nginx config following the template bellow
3. Enable the nginx configuration with this command: `ln -s /etc/nginx/sites-available/openfusionapi-<SERVER_VERSION>.conf /etc/nginx/sites-enabled/`
4. Acquire a SSL certificate. You can do this via a Cloudflare DNS Challenge or [Let's Encrypt](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-20-04) for example

Nginx example configuration, remember to change the placeholders. *Note:* If you plan on using Let's Encrypt for your certificate, you might want to use the `default.conf` template in `/etc/nginx/sites-available` for this, because when you run `certbot` to get the certificates it will automatically update your Nginx configuration files.
```nginx
# /etc/nginx/sites-available/openfusionapi-<SERVER_VERSION>.conf

# This server block listens for standard HTTP traffic on port 80
# and forwards it to the port you configured for OF API's HTTP interface.
server {
    listen 80;
    listen [::]:80;

    server_name <YOUR_DOMAIN>; # Domain you pointed to OF API, should be the same as `public_url` in of api's config

    location / {
        # Forward the request to the of api
        proxy_pass http://<OF_API_IP>:8888; # OF API ip address and the HTTP port from config.toml

        # --- Standard Proxy Headers ---
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# This server block listens for standard HTTPS traffic on port 443
# and forwards it to the port you configured for OF API's TLS interface.
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name <YOUR_DOMAIN>; # same as above

    # --- SSL Configuration ---
    # These paths point to the certificates you acquired.
    ssl_certificate /etc/letsencrypt/live/<YOUR_DOMAIN>/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<YOUR_DOMAIN>/privkey.pem;

    location / {
        # Forward the request to the of api's TLS port
        proxy_pass http://<OF_API_IP>:4433; # OF API ip address and the TLS port from config.toml

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
