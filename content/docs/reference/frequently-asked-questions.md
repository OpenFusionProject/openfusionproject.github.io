---
title: "Frequently Asked Questions"
description: ""
summary: ""
date: 2024-02-27T09:30:56+01:00
lastmod: 2024-02-27T09:30:56+01:00
draft: false
weight: 800
toc: true
seo:
  title: "" # custom title (optional)
  description: "" # custom description (recommended)
  canonical: "" # custom canonical URL (optional)
  noindex: false # false (default) or true
---

## Logging in

### The Remember Me button isnt working, leaving me frozen in the login screen or simply not saving my login information. Is there a fix? {#remember-me}

The Remember Me button doesn't currently do anything. As a result, you need to remember your username and password correctly to login, as while we can recover usernames, we cannot recover passwords if you happen to forget it. 

### Can I use the same login information on every OpenFusion or OF adjacent server? {#same-login}

No, you cannot. Our databases are separated between versions and the characters you create on one server cannot transfer onto another server. However, you are free to create those same characters (name included) on another server.

### Will my old account from FusionFall or FusionFall Retro work in OpenFusion? {#old-accounts}

No, it will not. Our database is not shared with the original game or with Retro's original database and we do not have access to them in any way. This also means our databases are separated between versions of OpenFusion, so you can't carry one character from one server to another. However, you're free to reuse the information you've used before and recreate the characters you had in the original game in OpenFusion, if you so desire.

## Gameplay

### Is this a single player game? I can't seem to find anyone in-game. {#singleplayer-game}

No, if you're playing on our public servers (one of the two default entries in the launcher), the game isn't single player. It's just that there arent many players playing at a given time usually. You can usually find more people playing during the afternoon or on weekends, or if there is an event going on at the moment. 

If you want the game to be single player, you can always set up a local server by following the instructions on https://github.com/OpenFusionProject/OpenFusion?tab=readme-ov-file#hosting-a-server

### Are there any banks or places to store my items in? {#banks}

Yes, in various major hubs in the game. You can find them in Peach Creek Commons, Townville Center, Mount Blackhead and Forsaken Valley. In the Original game, there are no banks in the Future, so you must get to the Past before you can store items in that version. All banks are synced with each other, so you can access banks in any area that has a banker NPC in it.

### Will updates be made for the game, like adding content from FusionFall Retro or making brand new levels or nanos? {#new-content}

No. OpenFusion's current goal is to keep the original version of the game intact without changes to game content or additions, with the only real changes being quality of life bug fixes or re-adding content that was in the original game. However, if you want to play a version of the game that is updated with new content or game changes, you can try out other servers such as [Retrobution](https://discord.gg/3qhqe2yv2f).

### Can I change my in-game character's appearance after making it in the tutorial? Such as changing their hair style, hair color, or skin tone? {#change-character-appearance}

No, there's no in-game feature that lets you change your character's base appearance after character creation. If you're playing on a local server, you could edit the database directly if you really want to. Just use a program like *DB Browser for SQLite* on your server's `database.db` and change the values in the Appearances table. For convenience, you could create a new character and copy the values from that one into your old one

### What is the difference between the Original and Academy servers? {#original-academy-differences}

The Original server, as the name implies, is the first server hosted by the OpenFusion staff. It currently has commands enabled, if you wish to experiment with them.

It uses the earliest publicly available game build, which contains the Future area and its associated missions. Leveling is based on obtaining Nanos, meaning you cannot level up unless you complete a Nano mission - there are 36 Nanos in total to collect.

The Academy server was launched later with the release of OpenFusion 1.3. Commands are disabled on this server, making for a much more level playing field.

It uses the last version of FusionFall, which gives you access to much more content from newer shows. In addition, it sports an entirely new tutorial section (the Academy) as well as a new leveling system independent of Nanos. This means you can level up without the need to complete a Nano mission - of which there are now 57 total. However, keep in mind that this build of the game is more unstable, and crashes are common for most players.

### I can't get the Van Kleiss nano in the Academy server. Is there a way to get him? {#van-kleiss-nano}

No. If you want the Van Kleiss nano, you're going to have to get the Unstable Nano, available from Level 4 at DexLabs. The Van Kleiss nano as a fully finished nano was never released due to the game shutting down, so now there's just a silhouette stuck in your nanobook where he would have went in.

## Commands

### How can I give myself items in-game? {#item-spawning}

In the Original game, you can give yourself items thru commands. To do this, type in the following command: `/itemN ( item type ) ( item ID ) ( item quantity )` (WITHOUT THE PARENTHESES)

An an example: Using this command to give myself the Ben 10 Jacket would look something like this: `/itemN 1 38 1`, with 1 being the item type *(shirts)*, 38 being the item ID *(the ID of the Ben 10 Jacket)* and 1 being the quantity of item (keep this at one unless you are spawning gumballs or other stackable items).

If you wish to find all the item IDs in the game, refer to [this spreadsheet](https://docs.google.com/spreadsheets/d/1mpoJ9iTHl_xLI4wQ_9UvIDYNcsDYscdkyaGizs43TCg/edit#gid=0).

You cannot do this in the Academy server unless you make a private server for yourself.

### I have an item code, how do I redeem it? {#redeem-codeitem}
When in game, press enter to open the menu, then type the following in chat:
`/redeem codehere`

Replace "codehere" with the code you would like to redeem. For example:
`/redeem ffcknishmaszooms`

You will get a message confirming that you've redeemed a code item if done correctly.

### How can I use the warp command? {#warp-command}

You can use this command in the original server to warp around the map at your leisure. To use it, use `/warp (X) (Y)` (WITHOUT THE PARENTHESIS)

To make this easier, refer to [this map](https://raw.githubusercontent.com/OpenFusionProject/OpenFusion/master/res/dong_number_map.png) reference with all the X and Y coordinates.

### Where do I find the codes that I can use on the Academy server? {#codeitem-list}
The FusionFall wiki maintains an [accurate list of code items](https://fusionfall.fandom.com/wiki/Codes).

### I can't equip items that I redeemed in the Academy server! They have a red border. Why is this? {#red-item-border}

The Academy set a limit to all Code items to Level 4, meaning you must complete the Academy tutorial before you can equip your redeemed items or open nano capsules.

## Social

### Can I make video content for or stream the game? {#content-creation}

Absolutely! You're free to make playthroughs of the game, or stream it live. Feel free to post what you create in the #media channel of our Discord. We'd love to see it!

### Will there be new events? Like Valentines, Knishmas or Halloween? {#holiday-events}

If you mean new events with brand new content, then no, there wont be new events. However, we do usually turn on Pumpkin C.R.A.T.E.S and Knishmas C.R.A.T.E.S during Halloween and Christmas respectively, so you can collect cool holidays items!

Also, our community sometimes holds community events, such as contests, dance parties, and just general group meetups from time to time, so you can attend those if they seem interesting to you.

## Bugs

### I can't progress in the Swampfire Nano mission, being stuck in a step. How can I fix this? {#swampfire-nanomission-bug}

You're going to have to ping one of our developers in the Discord with your issue so that we can fix it internally. This is due to a server side bug, and the only way to fix it is for us to go into the server and fix the issue for you. Sorry!

### The Academy server always crashes on me, or freezes, or is generally laggy. Can it be fixed? {#academy-buginess}

While we have made various quality of life improvements and stability changes to the Academy version of the game in OpenFusion, it is still inherently buggy and unstable due to all the content that was implemented by Cartoon network being poorly optimized. Constant crashing and freezing is inevitable while playing this version, unfortunately. Make sure you're using the latest version of OpenFusion, as some of these issues are less likely to be a problem than on older versions. It can also be circumvented by lowering graphics settings, View Distance in particular, but you will always have a chance of crashing or freezing suddenly. Sorry for the inconvenience!

### My camera spins around uncontrollably once I get ingame. {#camera-spinning}

* Try unplugging any controllers that you may have connected: while Fusionfall does have support for them, it is limited and can be glitchy depending on the type of controller. **This includes virtual controllers such as Steam, DS4Windows, Xpadder, etc.**

* Disable DPI scaling: Right click your desktop and choose "Display Settings", in the window that opens, scroll down to "Scale and layout" and make sure that "Change the size of text, apps, and other items" is set to 100% before launching the game.

### I am stuck in a wall or area! How can I get unstuck? {#stuck-warpaway}

Press Enter, then press the red "Warp Away" button on the left side of the UI. After 20 seconds, you will be teleported to the nearest Resurrect Em' in the area.

## Technical

### My UI is incredibly small when I go into Full Screen mode. Is there a way to fix this? {#small-gui}

Unfortunately No. The game UI was never adapted to fit into higher resolutions such as 4K. Our best advice would be to play the game in windowed mode or adjust the fullscreen resolution to the size you best see fit for the game via the in-game settings.

### Help! I accidentally deleted the public server from my launcher! {#deleted-default-servers}

You can restore the default servers by clicking the version number in the lower right corner, then in the window that pops up, click "Reset to Default Servers".

### I'm getting a LOGIN UNIMPLM or SHARD UNIMPLM error in the server log. How do I fix this? {#unimplm-packet}

* If it's a shard error and the number ends in 9889: You mixed up the login and shard ports. 
When adding a new server to the client's list, *always use the login port* (default 23000).

* If it's a login error the number starts with 3187: You likely changed the login and shard to be the same port. 
Revert your config.ini to the default of 23000 for login, and 23001 for shard. (they need separate ports in order to work)

* Any other combination: Check that the version you selected in the client matches the server you're connecting to. 
For an original server, select beta-20100104, and for an academy server select beta-20111013.

### Can I play the game on Android devices? Is it possible that a mobile port of the game will come out in the future? {#android-port}

No, it is not possible to play OpenFusion or its derivatives on an Android device. This is due to how unity handles the game making it impossible to port, and FusionFall's own outdated Unity engine not being compatible with Android. Do not expect an Android port of FusionFall.

If you do want a portable FusionFall, you can try installing it on a Steam Deck, which can run FusionFall.
