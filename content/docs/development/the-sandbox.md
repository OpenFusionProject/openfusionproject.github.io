---
title: "The Sandbox"
description: ""
summary: ""
date: 2024-07-14T18:32:06-05:00
lastmod: 2024-07-14T18:32:06-05:00
draft: false
weight: 999
toc: true
seo:
  title: "" # custom title (optional)
  description: "" # custom description (recommended)
  canonical: "" # custom canonical URL (optional)
  noindex: false # false (default) or true
---

Recent versions of the OpenFusion server contain two built-in process sandboxes; one for Linux and one for OpenBSD. These do not normally affect the behavior of the server, but they fortify it so that any attempts to exploit any security issues in the server's packet handlers will simply crash the server process instead of potentially allowing the attacker to take control of the machine the server process is being hosted on.

### OpenBSD

While we doubt there will ever be many people hosting OpenFusion on OpenBSD, the sandbox for that system, based on the `pledge()` and `unveil()` system calls, was trivial to develop, and is entirely complete and future-proof. There should never be a reason to disable it on that system.

### Linux

The Linux sandbox is a bit more complex however. It's built with `seccomp`, and due to the design of that operating system feature, unfortunately isn't as future-proof. It's on by default, but might cause the server to crash on startup or at other times if running on a system with newer versions of glibc or libsqlite, if those newer versions have changed the set of syscalls they call during normal operation. The same can happen if those libraries have been built with vastly different settings than we've tested. You can tell it's the sandbox if the server gets killed by the `SIGSYS` signal, and prints `Bad system call (core dumped)`. In those cases, you can simply disable the sandbox by setting the `sandbox` config option to `false` in the server's `config.ini`, and send us a bug report with a backtrace and your OS, libc, libsqlite and OpenFusion versions.

The other flaw with the Linux sandbox is that `seccomp` cannot limit file access to only the server folder. We might enhance this in the future using Landlock, but for now, security-minded system administrators can enhance the sandboxing by enclosing the process with an AppArmor profile or a Bubblewrap script.

This sandbox functionality is mostly relevant to people hosting public servers for others to play on. If you're hosting a local server or a friends only server on a private network, you're not going to be hacking into your own machine, and neither will your friends probably.
