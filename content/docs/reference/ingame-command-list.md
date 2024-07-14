---
title: "Ingame Command list"
description: "Reference pages are ideal for outlining how things work in terse and clear terms."
summary: ""
date: 2023-09-07T16:13:18+02:00
lastmod: 2023-09-07T16:13:18+02:00
draft: false
weight: 920
toc: true
seo:
  title: "" # custom title (optional)
  description: "" # custom description (recommended)
  canonical: "" # custom canonical URL (optional)
  noindex: false # false (default) or true
---

## Custom Commands
Custom commands are parsed and handled by the OpenFusion server. When a chat message is received that starts with the command prefix (default: `/`), instead of sending that chat to other players the server intercepts the message. Account levels are separate from the normal player level, and determine which commands they have access to - a lower number being more permissive.

| Command | Description | Required Acclevel |
| --- | --- | --- |
| /help | List all unlocked server-side commands. | 100 |
| /access | Print your access level. | 100 |
| /hide | Hide yourself from the global player map. | 100 |
| /unhide | Un-hide yourself from the global player map. | 100 |
| /population | Check how many players are online. | 100 |
| /redeem | Redeem a code item. A list is available on the [FusionFall Wiki](https://fusionfall.fandom.com/wiki/Code). | 100 |
| /refresh | Teleport yourself to your current location. | 100 |
| /unwarpable | Prevent buddies from warping to you. | 100 |
| /warpable | Re-allow buddies to warp to you. | 100 |
| /buff | Give yourself a buff effect. | 50 |
| /lair | Get the required mission for the nearest fusion lair. | 50 |
| /level | Change your character's level. | 50 |
| /levelx | Change your character's level (academy build). | 50 |
| /registerall | Register all SCAMPER and MSS destinations. | 50 |
| /unregisterall | Clear all SCAMPER and MSS destinations. | 50 |
| /whois | Describe nearest NPC. | 50 |
| /instance | Print or change your current instance. | 30 |
| /mss | Edit Monkey Skyway routes. | 30 |
| /npcr | Rotate the nearest NPC to face you. | 30 |
| /npci | Move the nearest NPC across instances. | 30 |
| /summonW | Permanently summon NPCs. | 30 |
| /unsummonW | Delete permanently summoned NPCs. | 30 |
| /toggleai | Enable/disable mob AI. | 30 |
| /flush | Write all gruntwork to file. | 30 |
| /minfo | Show details of the current mission and task. | 30 |
| /egg | Permanently summon a coco egg. | 30 |
| /tasks | List all active missions and their respective task ids. | 30 |
| /notify | Toggle receiving a message whenever a player joins the server. | 30 |
| /players | Output all players on the server to the chat. | 30 |
| /summonGroup | Summon group NPCs. | 30 |
| /summonGroupW | Permanently summon group NPCs. | 30 |

## Built-in Commands
These commands are parsed clientside, then put into a packet before being sent to the server. For example, `/speed` sends a `P_CL2FE_GM_REQ_PC_SET_VALUE` packet with `iSetValueType` equal to 6. Some of these built-in commands do not interact with the server at all, such as `/viewcol`, `/hideui` and `/viewloc`. Also note that ID and UID are one in the same in OpenFusion.

| Command | Description | Implemented? |
| --- | --- | --- |
| /qinven | Prints quest item list to debug logfile (clientside). | :heavy_check_mark: |
| /emote | Removed in newer client versions. | :x: |
| /dance | Removed in newer client versions. | :x: |
| /motd | Sets the message of the day while the server is running. | :x: |
| /announce, /bcast | Sends a message window to players, which players are selected depends on the announce type. | :heavy_check_mark: |
| /nano_equip | Equip a nano in slot 0, 1, or 2. | :heavy_check_mark: |
| /nano_unequip | Unequip a nano in slot 0, 1, or 2. | :heavy_check_mark: |
| /nano_active | Essentially the same as pressing 1, 2, or 3 on your keyboard to summon a nano. | :heavy_check_mark: |
| /speed | Sets movement speed to the specified value. A speed of around 2400 or 3000 is nice. | :heavy_check_mark: |
| /jump | Sets jump height to the specified value. A height of about 50 will send you soaring. | :heavy_check_mark: |
| /warp | Warps to the center of the specified map square. [This map](https://github.com/OpenFusionProject/OpenFusion/blob/master/res/dong_number_map.png) (credit to Danny O) is useful for finding the coordinates. | :heavy_check_mark: |
| /goto | Teleport to more exact coordinates. Useful for getting in IZs or fusion lairs. | :heavy_check_mark: |
| /warptopc | Warp to a player by ID. | :heavy_check_mark: |
| /itemN | Give yourself an item. Refer to [this spreadsheet](https://docs.google.com/spreadsheets/d/1mpoJ9iTHl_xLI4wQ_9UvIDYNcsDYscdkyaGizs43TCg/) for the IDs. | :heavy_check_mark: |
| /itemQ | Give yourself a quest item. | :x: |
| /mapwarp | Removed in newer client versions. | :x: |
| /nano | Creates the specified nano number (ex. 2 for Numbuh 2). | :heavy_check_mark: |
| /nanoArr | Obtains all nanos within a range. | :heavy_check_mark: |
| /summon | Summons a mob or NPC temporarily. | :heavy_check_mark: |
| /groupsummon | Summons a group by ID. | :x: |
| /summonshiny | Summons a coco egg by ID. Location is offset randomly. | :x: |
| /unsummon | Unsummons the nearest NPC or mob. | :heavy_check_mark: |
| /nanoskill | Change the skill set on a specific nano. | :heavy_check_mark: |
| /mission | Obtain a specific mission by ID. | :x: |
| /task | Obtain a specific task by ID. | :x: |
| /unstick_i | "Unsticks" a player by ID. (teleports them slightly offset from where they were) | :heavy_check_mark: |
| /unstick_ui | "Unsticks" a player by UID. | :heavy_check_mark: |
| /unstick_n | "Unsticks" a player by first and last name. | :heavy_check_mark: |
| /locate_i | Locates a player by ID. | :heavy_check_mark: |
| /locate_ui | Locates a player by UID. | :heavy_check_mark: |
| /locate_n | Locates a player by first and last name. | :heavy_check_mark: |
| /teleport2me_n | Teleports a player with the specified first and last name to you. | :heavy_check_mark: |
| /teleport2me_i | Teleports a player with the specified ID to you. | :heavy_check_mark: |
| /teleport2me_ui | Teleports a player with the specified UID to you. | :heavy_check_mark: |
| /teleportXYZ_i | Teleports a player with the specified ID to the specified coordinates. | :heavy_check_mark: |
| /teleportXYZ_ui | Teleports a player with the specified UID to the specified coordinates. | :heavy_check_mark: |
| /teleportXYZ_n | Teleports a player with the specified first and last name to the specified coordinates. | :heavy_check_mark: |
| /teleportMapXYZ_i | Teleports a player with the specified ID to the specified coordinates and instance. | :heavy_check_mark: |
| /teleportMapXYZ_ui | Teleports a player with the specified UID to the specified coordinates and instance. | :heavy_check_mark: |
| /teleportMapXYZ_n | Teleports a player with the specified first/last name to the specified coordinates and instance. | :heavy_check_mark: |
| /teleport_i_i | Teleports a player with a specified ID to another with a specified ID. | :heavy_check_mark: |
| /teleport_ui_ui | Teleports a player with a specified UID to another with a specified UID. | :heavy_check_mark: |
| /teleport_i_n | Teleports a player with a specified ID to another with a first and last name. | :heavy_check_mark: |
| /teleport_n_n | Teleports a player with a specified first/last name to another with a specified first/last name. | :heavy_check_mark: |
| /kick_i | Kick a player by ID. | :heavy_check_mark: |
| /kick_ui | Kick a player by UID. | :heavy_check_mark: |
| /kick_n | Kick a player by first and last name. | :heavy_check_mark: |
| /invisible | Makes your player character invisible and disables mob aggro. Note: can be buggy. | :heavy_check_mark: |
| /invulnerable | Makes players unable to interact with you, and disables mob aggro. | :heavy_check_mark: |
| /health | Sets your health to the amount specified. Max health does not change. | :heavy_check_mark: |
| /batteryW | Modifies the amount of Weapon Boosts that you have. | :heavy_check_mark: |
| /batteryN | Modifies the amount of Nano Potions that you have. | :heavy_check_mark: |
| /fusionmatter | Modifies the amount of Fusion Matter that you have. | :heavy_check_mark: |
| /taros | Modifies the amount of Taros that you have. | :heavy_check_mark: |
| /gmmarker | Toggles the display of a GM particle above your character's head, and enables PVP. | :heavy_check_mark: |
| /equipitem | Equips the item in the specified inventory slot to the specified equip slot. | :heavy_check_mark: |
| /viewloc | Toggles display of coordinates and other attributes (clientside). | :heavy_check_mark: |
| /mute_i_on | Mute a player by ID. | :heavy_check_mark: |
| /mute_i_off | Unmute a player by ID. | :heavy_check_mark: |
| /mute_ui_on | Mute a player by UID. | :heavy_check_mark: |
| /mute_ui_off | Unmute a player by UID. | :heavy_check_mark: |
| /mute_n_on | Mute a player by first and last name. | :heavy_check_mark: |
| /mute_n_off | Unmute a player by first and last name. | :heavy_check_mark: |
| /hideui | Hides all UI elements (clientside). | :heavy_check_mark: |
| /viewcol | Highlight all collision hulls (clientside). | :heavy_check_mark: |
| /chwarp | Manipulates channels. Not applicable to OpenFusion. | :x: |
| /chnum | Manipulates channels. Not applicable to OpenFusion. | :x: |
| /chinfo | Manipulates channels. Not applicable to OpenFusion. | :x: |
| /shwarp | Manipulates shards. Not applicable to OpenFusion. | :x: |
| /viewid | Toggle display of NPC and mob IDs (clientside). | :heavy_check_mark: |
| /rateF | Adjusts rate at which you receive Fusion Matter. | :x: |
| /rateT | Adjusts rate at which you receive Taros. | :x: |
| /tasklog | Prints all active tasks to debug logfile (clientside). | :heavy_check_mark: |
| /cashmall | Opens an unfinished microtransaction store interface (clientside). | :x: |
| /Store | Opens an unfinished auction house/player shop interface (clientside). | :x: |
