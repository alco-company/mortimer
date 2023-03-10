# docker.alco.company - installation

user: root
pw: D0ck3rDOT41c0

user: dokku
pw: d0kkuDOT41c0

## Setting hostname

```
root@srv005415:/etc# hostname
docker.alco.company
root@srv005415:/etc# cd
```

## Installing Dokku

```
root@srv005415:~# wget https://raw.githubusercontent.com/dokku/dokku/v0.27.0/bootstrap.sh;
--2022-04-20 11:52:33--  https://raw.githubusercontent.com/dokku/dokku/v0.27.0/bootstrap.sh
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.108.133, 185.199.109.133, 185.199.111.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.108.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 9562 (9.3K) [text/plain]
Saving to: ‘bootstrap.sh’

bootstrap.sh                           100%[============================================================================>]   9.34K  --.-KB/s    in 0s      

2022-04-20 11:52:33 (97.0 MB/s) - ‘bootstrap.sh’ saved [9562/9562]

root@srv005415:~# DOKKU_TAG=v0.27.0 bash bootstrap.sh
Preparing to install v0.27.0 from https://github.com/dokku/dokku.git...
--> Ensuring we have the proper dependencies
--> Note: Installing dokku for the first time will result in removal of
    files in the nginx 'sites-enabled' directory. Please manually
    restore any files that may be removed after the installation and
    web setup is complete.

    Installation will continue in 10 seconds.
--> Initial apt-get update
--> Installing docker
2022-04-20 11:53:47 URL:https://get.docker.com/ [18617/18617] -> "-" [1]
# Executing docker install script, commit: 93d2499759296ac1f9c510605fef85052a2c32be
+ sh -c apt-get update -qq >/dev/null
+ sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq apt-transport-https ca-certificates curl >/dev/null
+ sh -c curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg
+ sh -c echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" > /etc/apt/sources.list.d/docker.list
+ sh -c apt-get update -qq >/dev/null
+ sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends  docker-ce-cli docker-scan-plugin docker-ce >/dev/null
+ version_gte 20.10
+ [ -z  ]
+ return 0
+ sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq docker-ce-rootless-extras >/dev/null
+ sh -c docker version
Client: Docker Engine - Community
 Version:           20.10.14
 API version:       1.41
 Go version:        go1.16.15
 Git commit:        a224086
 Built:             Thu Mar 24 01:48:02 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.14
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.16.15
  Git commit:       87a90dc
  Built:            Thu Mar 24 01:45:53 2022
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.5.11
  GitCommit:        3df54a852345ae127d1fa3092b95168e4a88e2f8
 runc:
  Version:          1.0.3
  GitCommit:        v1.0.3-0-gf46b6ba
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

================================================================================

To run Docker as a non-privileged user, consider setting up the
Docker daemon in rootless mode for your user:

    dockerd-rootless-setuptool.sh install

Visit https://docs.docker.com/go/rootless/ to learn about rootless mode.


To run the Docker daemon as a fully privileged service, but granting non-root
users access, refer to https://docs.docker.com/go/daemon-access/

WARNING: Access to the remote API on a privileged Docker daemon is equivalent
         to root access on the host. Refer to the 'Docker daemon attack surface'
         documentation for details: https://docs.docker.com/go/attack-surface/

================================================================================

--> Installing dokku
2022-04-20 11:54:09 URL:https://d28dx6y1hfq314.cloudfront.net/505/623/gpg/dokku-dokku-FB2B6AA421CD193F.pub.gpg?t=1650455949_7bffada63ec5e3339eb71623edce9451c929bb2d [3937/3937] -> "-" [1]
OK
deb https://packagecloud.io/dokku/dokku/ubuntu/ focal main
Extracting templates from packages: 100%
Preconfiguring packages ...
Selecting previously unselected package gliderlabs-sigil.
(Reading database ... 153394 files and directories currently installed.)
Preparing to unpack .../00-gliderlabs-sigil_0.8.1_amd64.deb ...
Unpacking gliderlabs-sigil (0.8.1) ...
Selecting previously unselected package nginx-common.
Preparing to unpack .../01-nginx-common_1.18.0-0ubuntu1.3_all.deb ...
Unpacking nginx-common (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package fonts-dejavu-core.
Preparing to unpack .../02-fonts-dejavu-core_2.37-1_all.deb ...
Unpacking fonts-dejavu-core (2.37-1) ...
Selecting previously unselected package fontconfig-config.
Preparing to unpack .../03-fontconfig-config_2.13.1-2ubuntu3_all.deb ...
Unpacking fontconfig-config (2.13.1-2ubuntu3) ...
Selecting previously unselected package libfontconfig1:amd64.
Preparing to unpack .../04-libfontconfig1_2.13.1-2ubuntu3_amd64.deb ...
Unpacking libfontconfig1:amd64 (2.13.1-2ubuntu3) ...
Selecting previously unselected package libjpeg-turbo8:amd64.
Preparing to unpack .../05-libjpeg-turbo8_2.0.3-0ubuntu1.20.04.1_amd64.deb ...
Unpacking libjpeg-turbo8:amd64 (2.0.3-0ubuntu1.20.04.1) ...
Selecting previously unselected package libjpeg8:amd64.
Preparing to unpack .../06-libjpeg8_8c-2ubuntu8_amd64.deb ...
Unpacking libjpeg8:amd64 (8c-2ubuntu8) ...
Selecting previously unselected package libjbig0:amd64.
Preparing to unpack .../07-libjbig0_2.1-3.1build1_amd64.deb ...
Unpacking libjbig0:amd64 (2.1-3.1build1) ...
Selecting previously unselected package libwebp6:amd64.
Preparing to unpack .../08-libwebp6_0.6.1-2ubuntu0.20.04.1_amd64.deb ...
Unpacking libwebp6:amd64 (0.6.1-2ubuntu0.20.04.1) ...
Selecting previously unselected package libtiff5:amd64.
Preparing to unpack .../09-libtiff5_4.1.0+git191117-2ubuntu0.20.04.2_amd64.deb ...
Unpacking libtiff5:amd64 (4.1.0+git191117-2ubuntu0.20.04.2) ...
Selecting previously unselected package libxpm4:amd64.
Preparing to unpack .../10-libxpm4_1%3a3.5.12-1_amd64.deb ...
Unpacking libxpm4:amd64 (1:3.5.12-1) ...
Selecting previously unselected package libgd3:amd64.
Preparing to unpack .../11-libgd3_2.2.5-5.2ubuntu2.1_amd64.deb ...
Unpacking libgd3:amd64 (2.2.5-5.2ubuntu2.1) ...
Selecting previously unselected package libnginx-mod-http-image-filter.
Preparing to unpack .../12-libnginx-mod-http-image-filter_1.18.0-0ubuntu1.3_amd64.deb ...
Unpacking libnginx-mod-http-image-filter (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package libxslt1.1:amd64.
Preparing to unpack .../13-libxslt1.1_1.1.34-4_amd64.deb ...
Unpacking libxslt1.1:amd64 (1.1.34-4) ...
Selecting previously unselected package libnginx-mod-http-xslt-filter.
Preparing to unpack .../14-libnginx-mod-http-xslt-filter_1.18.0-0ubuntu1.3_amd64.deb ...
Unpacking libnginx-mod-http-xslt-filter (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package libnginx-mod-mail.
Preparing to unpack .../15-libnginx-mod-mail_1.18.0-0ubuntu1.3_amd64.deb ...
Unpacking libnginx-mod-mail (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package libnginx-mod-stream.
Preparing to unpack .../16-libnginx-mod-stream_1.18.0-0ubuntu1.3_amd64.deb ...
Unpacking libnginx-mod-stream (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package nginx-core.
Preparing to unpack .../17-nginx-core_1.18.0-0ubuntu1.3_amd64.deb ...
Unpacking nginx-core (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package nginx.
Preparing to unpack .../18-nginx_1.18.0-0ubuntu1.3_all.deb ...
Unpacking nginx (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package cgroupfs-mount.
Preparing to unpack .../19-cgroupfs-mount_1.4_all.deb ...
Unpacking cgroupfs-mount (1.4) ...
Selecting previously unselected package plugn.
Preparing to unpack .../20-plugn_0.8.2_amd64.deb ...
Unpacking plugn (0.8.2) ...
Selecting previously unselected package sshcommand.
Preparing to unpack .../21-sshcommand_0.15.0_all.deb ...
Unpacking sshcommand (0.15.0) ...
Selecting previously unselected package docker-image-labeler.
Preparing to unpack .../22-docker-image-labeler_0.4.1_amd64.deb ...
Unpacking docker-image-labeler (0.4.1) ...
Selecting previously unselected package netrc.
Preparing to unpack .../23-netrc_0.5.1_amd64.deb ...
Unpacking netrc (0.5.1) ...
Selecting previously unselected package libsensors-config.
Preparing to unpack .../24-libsensors-config_1%3a3.6.0-2ubuntu1_all.deb ...
Unpacking libsensors-config (1:3.6.0-2ubuntu1) ...
Selecting previously unselected package libsensors5:amd64.
Preparing to unpack .../25-libsensors5_1%3a3.6.0-2ubuntu1_amd64.deb ...
Unpacking libsensors5:amd64 (1:3.6.0-2ubuntu1) ...
Selecting previously unselected package sysstat.
Preparing to unpack .../26-sysstat_12.2.0-2ubuntu0.1_amd64.deb ...
Unpacking sysstat (12.2.0-2ubuntu0.1) ...
Selecting previously unselected package parallel.
Preparing to unpack .../27-parallel_20161222-1.1_all.deb ...
Adding 'diversion of /usr/bin/parallel to /usr/bin/parallel.moreutils by parallel'
Adding 'diversion of /usr/share/man/man1/parallel.1.gz to /usr/share/man/man1/parallel.moreutils.1.gz by parallel'
Unpacking parallel (20161222-1.1) ...
Selecting previously unselected package procfile-util.
Preparing to unpack .../28-procfile-util_0.14.1_amd64.deb ...
Unpacking procfile-util (0.14.1) ...
Selecting previously unselected package dos2unix.
Preparing to unpack .../29-dos2unix_7.4.0-2_amd64.deb ...
Unpacking dos2unix (7.4.0-2) ...
Selecting previously unselected package libonig5:amd64.
Preparing to unpack .../30-libonig5_6.9.4-1_amd64.deb ...
Unpacking libonig5:amd64 (6.9.4-1) ...
Selecting previously unselected package libjq1:amd64.
Preparing to unpack .../31-libjq1_1.6-1ubuntu0.20.04.1_amd64.deb ...
Unpacking libjq1:amd64 (1.6-1ubuntu0.20.04.1) ...
Selecting previously unselected package jq.
Preparing to unpack .../32-jq_1.6-1ubuntu0.20.04.1_amd64.deb ...
Unpacking jq (1.6-1ubuntu0.20.04.1) ...
Setting up gliderlabs-sigil (0.8.1) ...
Setting up nginx-common (1.18.0-0ubuntu1.3) ...
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /lib/systemd/system/nginx.service.
Setting up fonts-dejavu-core (2.37-1) ...
Setting up fontconfig-config (2.13.1-2ubuntu3) ...
Setting up libfontconfig1:amd64 (2.13.1-2ubuntu3) ...
Setting up libjpeg-turbo8:amd64 (2.0.3-0ubuntu1.20.04.1) ...
Setting up libjpeg8:amd64 (8c-2ubuntu8) ...
Setting up libjbig0:amd64 (2.1-3.1build1) ...
Setting up libwebp6:amd64 (0.6.1-2ubuntu0.20.04.1) ...
Setting up libtiff5:amd64 (4.1.0+git191117-2ubuntu0.20.04.2) ...
Setting up libxpm4:amd64 (1:3.5.12-1) ...
Setting up libgd3:amd64 (2.2.5-5.2ubuntu2.1) ...
Setting up libnginx-mod-http-image-filter (1.18.0-0ubuntu1.3) ...
Setting up libxslt1.1:amd64 (1.1.34-4) ...
Setting up libnginx-mod-http-xslt-filter (1.18.0-0ubuntu1.3) ...
Setting up libnginx-mod-mail (1.18.0-0ubuntu1.3) ...
Setting up libnginx-mod-stream (1.18.0-0ubuntu1.3) ...
Setting up nginx-core (1.18.0-0ubuntu1.3) ...
Setting up nginx (1.18.0-0ubuntu1.3) ...
Setting up cgroupfs-mount (1.4) ...
Setting up plugn (0.8.2) ...
Selecting previously unselected package dokku.
(Reading database ... 153891 files and directories currently installed.)
Preparing to unpack .../dokku_0.27.0_amd64.deb ...
Error: keyfile '/root/.ssh/id_rsa.pub' not found.
       To deploy, you will need to generate a keypair and add with 'dokku ssh-keys:add'.
Unpacking dokku (0.27.0) ...
Selecting previously unselected package herokuish.
Preparing to unpack .../herokuish_0.5.34_amd64.deb ...
Unpacking herokuish (0.5.34) ...
Selecting previously unselected package dokku-event-listener.
Preparing to unpack .../dokku-event-listener_0.12.0_amd64.deb ...
Unpacking dokku-event-listener (0.12.0) ...
Selecting previously unselected package dokku-update.
Preparing to unpack .../dokku-update_0.5.0_all.deb ...
Unpacking dokku-update (0.5.0) ...
Setting up sshcommand (0.15.0) ...
Setting up docker-image-labeler (0.4.1) ...
Setting up libsensors-config (1:3.6.0-2ubuntu1) ...
Setting up netrc (0.5.1) ...
Setting up libsensors5:amd64 (1:3.6.0-2ubuntu1) ...
Setting up herokuish (0.5.34) ...
Starting docker
Pruning dangling images
Error response from daemon: invalid reference format: repository name must be lowercase
Pruning unused gliderlabs/herokuish images
"docker rmi" requires at least 1 argument.
See 'docker rmi --help'.

Usage:  docker rmi [OPTIONS] IMAGE [IMAGE...]

Remove one or more images
Importing herokuish into docker (around 5 minutes)
v0.5.34-18: Pulling from gliderlabs/herokuish
2f94e549220a: Pull complete 
eabe6feda7f7: Pull complete 
0d142d7d5ee9: Pull complete 
ccdabbf80b0d: Pull complete 
6988c797bfdb: Pull complete 
82c61e6e7d0a: Pull complete 
9a9aa6bb555b: Pull complete 
1942a5e5b16f: Pull complete 
4bc30f2f71ad: Pull complete 
86dc24da19d9: Pull complete 
Digest: sha256:5862aa1f2749de323d849f6f0b45cd24a4c84b82d5c346a24e08dc04d0bd4fff
Status: Downloaded newer image for gliderlabs/herokuish:v0.5.34-18
docker.io/gliderlabs/herokuish:v0.5.34-18
v0.5.34-20: Pulling from gliderlabs/herokuish
ea362f368469: Pull complete 
168a66961029: Pull complete 
9ea92fa6563e: Pull complete 
8a055472aece: Pull complete 
d59f4bd48b62: Pull complete 
8159f0dea9a0: Pull complete 
32fcff4ba673: Pull complete 
79709ffbc565: Pull complete 
797ef20da82f: Pull complete 
ed23aa403f7f: Pull complete 
Digest: sha256:ba97d7949a8fa35fa114422b0bfd749cffe848c77cdc1934e6b3687a0f0fb4f5
Status: Downloaded newer image for gliderlabs/herokuish:v0.5.34-20
docker.io/gliderlabs/herokuish:v0.5.34-20
Setting up dos2unix (7.4.0-2) ...
Setting up dokku-update (0.5.0) ...
Setting up sysstat (12.2.0-2ubuntu0.1) ...

Creating config file /etc/default/sysstat with new version
update-alternatives: using /usr/bin/sar.sysstat to provide /usr/bin/sar (sar) in auto mode
Created symlink /etc/systemd/system/multi-user.target.wants/sysstat.service → /lib/systemd/system/sysstat.service.
Setting up procfile-util (0.14.1) ...
Setting up libonig5:amd64 (6.9.4-1) ...
Setting up dokku-event-listener (0.12.0) ...
Created symlink /etc/systemd/system/multi-user.target.wants/dokku-event-listener.target → /etc/systemd/system/dokku-event-listener.target.
Setting up libjq1:amd64 (1.6-1ubuntu0.20.04.1) ...
Setting up parallel (20161222-1.1) ...
Setting up jq (1.6-1ubuntu0.20.04.1) ...
Setting up dokku (0.27.0) ...
Purging old database entries in /usr/share/man...
Processing manual pages under /usr/share/man...
Updating index cache for path `/usr/share/man/man5'. Wait...done.
Checking for stray cats under /usr/share/man...
Checking for stray cats under /var/cache/man...
Purging old database entries in /usr/share/man/ko...
Processing manual pages under /usr/share/man/ko...
Purging old database entries in /usr/share/man/pt_BR...
Processing manual pages under /usr/share/man/pt_BR...
Updating index cache for path `/usr/share/man/pt_BR/man1'. Wait...done.
Checking for stray cats under /usr/share/man/pt_BR...
Checking for stray cats under /var/cache/man/pt_BR...
Purging old database entries in /usr/share/man/cs...
Processing manual pages under /usr/share/man/cs...
Purging old database entries in /usr/share/man/hu...
Processing manual pages under /usr/share/man/hu...
Purging old database entries in /usr/share/man/ja...
Processing manual pages under /usr/share/man/ja...
Purging old database entries in /usr/share/man/sr...
Processing manual pages under /usr/share/man/sr...
Purging old database entries in /usr/share/man/nl...
Processing manual pages under /usr/share/man/nl...
Updating index cache for path `/usr/share/man/nl/man1'. Wait...done.
Checking for stray cats under /usr/share/man/nl...
Checking for stray cats under /var/cache/man/nl...
Purging old database entries in /usr/share/man/fr...
Processing manual pages under /usr/share/man/fr...
Updating index cache for path `/usr/share/man/fr/man1'. Wait...done.
Checking for stray cats under /usr/share/man/fr...
Checking for stray cats under /var/cache/man/fr...
Purging old database entries in /usr/share/man/it...
Processing manual pages under /usr/share/man/it...
Purging old database entries in /usr/share/man/zh_CN...
Processing manual pages under /usr/share/man/zh_CN...
Updating index cache for path `/usr/share/man/zh_CN/man1'. Wait...done.
Checking for stray cats under /usr/share/man/zh_CN...
Checking for stray cats under /var/cache/man/zh_CN...
Purging old database entries in /usr/share/man/es...
Processing manual pages under /usr/share/man/es...
Updating index cache for path `/usr/share/man/es/man1'. Wait...done.
Checking for stray cats under /usr/share/man/es...
Checking for stray cats under /var/cache/man/es...
Purging old database entries in /usr/share/man/tr...
Processing manual pages under /usr/share/man/tr...
Purging old database entries in /usr/share/man/zh_TW...
Processing manual pages under /usr/share/man/zh_TW...
Purging old database entries in /usr/share/man/ru...
Processing manual pages under /usr/share/man/ru...
Purging old database entries in /usr/share/man/fi...
Processing manual pages under /usr/share/man/fi...
Purging old database entries in /usr/share/man/sv...
Processing manual pages under /usr/share/man/sv...
Updating index cache for path `/usr/share/man/sv/man1'. Wait...done.
Checking for stray cats under /usr/share/man/sv...
Checking for stray cats under /var/cache/man/sv...
Purging old database entries in /usr/share/man/pl...
Processing manual pages under /usr/share/man/pl...
Updating index cache for path `/usr/share/man/pl/man1'. Wait...done.
Checking for stray cats under /usr/share/man/pl...
Checking for stray cats under /var/cache/man/pl...
Purging old database entries in /usr/share/man/de...
Processing manual pages under /usr/share/man/de...
Updating index cache for path `/usr/share/man/de/man1'. Wait...done.
Checking for stray cats under /usr/share/man/de...
Checking for stray cats under /var/cache/man/de...
Purging old database entries in /usr/share/man/id...
Processing manual pages under /usr/share/man/id...
Purging old database entries in /usr/share/man/pt...
Processing manual pages under /usr/share/man/pt...
Purging old database entries in /usr/share/man/sl...
Processing manual pages under /usr/share/man/sl...
Processing manual pages under /usr/share/man/uk...
Updating index cache for path `/usr/share/man/uk/man1'. Wait...done.
Checking for stray cats under /usr/share/man/uk...
Checking for stray cats under /var/cache/man/uk...
Purging old database entries in /usr/share/man/da...
Processing manual pages under /usr/share/man/da...
Processing manual pages under /usr/local/man...
12 man subdirectories contained newer manual pages.
94 manual pages were added.
0 stray cats were added.
0 old database entries were purged.
Setting up dokku user
Adding user `dokku' ...
Adding new group `dokku' (1001) ...
Adding new user `dokku' (1001) with group `dokku' ...
Creating home directory `/home/dokku' ...
Copying files from `/etc/skel' ...
docker:x:998:
Setting up storage directories
Deleting invalid plugins
Setting up plugin directories
Migrating old plugins
Enabling all core plugins
Install all core plugins
 !     You haven't deployed any applications yet
 !     You haven't deployed any applications yet
 !     You haven't deployed any applications yet
 !     You haven't deployed any applications yet
Generating DH parameters, 2048 bit long safe prime, generator 2
This is going to take a long time
....................................+................................................................................................................................................................................................................................................................................................................................................+........+....................................................................+...............................+........................................................................+..................................................+...+......................................+..............+.............................................................................................+..........................................................................................+................+.........................................+.....................................................................................+....................................................................................................................................+.....................................+..............................................+........................................+...+................................................+.......................................................+.........................................................................+.....................................................................................+......................................................................................................................+................................................................................................................+.................................................................................................................................+....................................................................................................................................................+.......................................................................................................................................+......................................................................................................+..........................................+............................+...............................................................................................................+......+.............................+..........................................+..................................................................................+........+.....................................................................................................................................................+...............................................................................+.................................................................................................+...................................................................................................+............+............................................+..........................................................................................................................................................................................................................................................+..........+..................................................................................................................................................+..........+..........+......................................................................+.................................................................................................+.................................................+....................+...................................................................+.............................................................................................+..+.....................................................................................+............+..................................................................+....................+.+................................................................................................................................................+..........................................................+..................................................................................+.............................+.............................................................................................................................................................................................................................................+..................................................................+...........................................+..+...........................................................................................................................................................................................................................................................................................+............++*++*++*++*
Adding user dokku to group adm
 !     You haven't deployed any applications yet
Starting nginx (via systemctl): nginx.service.
-----> Priming bash-completion cache
Ensure proper sshcommand path
Processing triggers for libc-bin (2.31-0ubuntu9.7) ...
Processing triggers for ufw (0.36-6ubuntu1) ...
Processing triggers for systemd (245.4-4ubuntu3.16) ...
Processing triggers for man-db (2.9.1-1) ...
--> Running post-install dependency installation

 ! Setup a user's ssh key for deployment by passing in the public ssh key as shown:

     echo 'CONTENTS_OF_ID_RSA_PUB_FILE' | dokku ssh-keys:add admin

```

## Setting global domain

```
root@srv005415:~# dokku domains:set-global docker.alco.company
-----> Set docker.alco.company
```

## Installing Dokku-Pro

```
root@srv005415:~# vi /etc/default/dokku-pro
root@srv005415:~# more product.key
key/ZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmxlSEFpT2pFMk9ERTVNREF4TXprc0luUjVjR1VpT2lKdmJteHBibVVpZlEuaHBoYU9vSldtMzF0dzJGdlhKVl9NZ3JPZTRBdlAw
aTFIS0hPQWZJLV9Uaw==.XNBlcS3jdgRIFj1Qd2_4bfh1_LithUyRJQ6Zw7FzOgLn864RmoeFzwJOzjXAGFZ_RhxPzsQhYO61R48sZVtV1FK5PStYehyV1K6yBPIlIOvJycVN8i0Zbkue-HirEXEDH1jHSls
sjDxqP-nkCf2plqUHY0pQefu0SevJQtewqoq51j_uoMigoKxT4frcaFex9PsrphmDZdOw0QWmloyZPeESXr8sra0s_KCA86Li9gMgNZVafkG9c12IlIP20Tl3R6q7Ix6hop24JGD_khPKSWUJaVFkVnLHcUg
PdsWSZTDYV0iOZsjGblhWz4mqHy70mMMmbKdwaPI-bGh_MmJmxw==
root@srv005415:~# mkdir /etc/dokku-pro
root@srv005415:~# mv product.key /etc/dokku-pro/license.key
root@srv005415:~# dpkg -i ~/dokku-pro_1.1.2_amd64.deb 
Selecting previously unselected package dokku-pro.
(Reading database ... 154738 files and directories currently installed.)
Preparing to unpack .../root/dokku-pro_1.1.2_amd64.deb ...
Unpacking dokku-pro (1.1.2) ...
Setting up dokku-pro (1.1.2) ...
```

## Starting Dokku-Pro

```
root@srv005415:~# systemctl daemon-reload
root@srv005415:~# systemctl start dokku-pro.target
root@srv005415:~# systemctl start dokku-pro.service
```

## Setting timezone

```
root@srv005415:~# timedatectl set-timezone Europe/Copenhagen
```

## Installing plugins

### Redis 

```
root@docker:~# dokku plugin:install https://github.com/dokku/dokku-redis.git redis
-----> Cloning plugin repo https://github.com/dokku/dokku-redis.git to /var/lib/dokku/plugins/available/redis
Cloning into 'redis'...
remote: Enumerating objects: 2350, done.
remote: Counting objects: 100% (568/568), done.
remote: Compressing objects: 100% (370/370), done.
remote: Total 2350 (delta 330), reused 381 (delta 164), pack-reused 1782
Receiving objects: 100% (2350/2350), 463.94 KiB | 27.29 MiB/s, done.
Resolving deltas: 100% (1547/1547), done.
-----> Plugin redis enabled
Adding user dokku to group adm
Starting nginx (via systemctl): nginx.service.
6.2.6: Pulling from library/redis
1fe172e4850f: Pull complete 
6fbcd347bf99: Pull complete 
993114c67627: Pull complete 
2a560260ca39: Pull complete 
b7179886a292: Pull complete 
8901ffe2be84: Pull complete 
Digest: sha256:8594f777672febfd15b351f9a3fe942e07ff9a085ea70de8d3f49fd7f6ba67c6
Status: Downloaded newer image for redis:6.2.6
docker.io/library/redis:6.2.6
1.31.1-uclibc: Pulling from library/busybox
76df9210b28c: Pull complete 
Digest: sha256:cd421f41ebaab52ae1ac91a8391ddbd094595264c6e689954b79b3d24ea52f88
Status: Downloaded newer image for busybox:1.31.1-uclibc
docker.io/library/busybox:1.31.1-uclibc
0.3.3: Pulling from dokku/ambassador
aad63a933944: Pull complete 
2888dfab2eb5: Pull complete 
51ccf60e0642: Pull complete 
Digest: sha256:87c0214e190e7f6975953027157a8933701596b4b864ff66dd3cc3f6ead5c38d
Status: Downloaded newer image for dokku/ambassador:0.3.3
docker.io/dokku/ambassador:0.3.3
0.10.3: Pulling from dokku/s3backup
aad63a933944: Already exists 
6654c5b7b2dc: Pull complete 
26abcd9faf98: Pull complete 
d1a36cd3ba61: Pull complete 
9517d44e685b: Pull complete 
32e8b2c4797f: Pull complete 
Digest: sha256:3651f8ef12000206df55fec8ad4860d6f26b2b5af1308c0e2358253641626024
Status: Downloaded newer image for dokku/s3backup:0.10.3
docker.io/dokku/s3backup:0.10.3
0.4.3: Pulling from dokku/wait
aad63a933944: Already exists 
3409ea528c35: Pull complete 
88e35d065209: Pull complete 
Digest: sha256:5eb9da766abdd5e8cedbde9870acd4b54c1c7e63e72c99e338b009d06f808f04
Status: Downloaded newer image for dokku/wait:0.4.3
docker.io/dokku/wait:0.4.3
-----> Priming bash-completion cache
root@docker:~# dokku redis:create speicher
       Waiting for container to be ready
=====> Redis container created: speicher
=====> speicher redis service information
       Config dir:          /var/lib/dokku/services/redis/speicher/config
       Config options:                               
       Data dir:            /var/lib/dokku/services/redis/speicher/data
       Dsn:                 redis://:b8ee85b232eb6caba777ec227c745dceeed1c9d0a9a2177fafd1c21afa0084f4@dokku-redis-speicher:6379
       Exposed ports:       -                        
       Id:                  3ac803143730500e104601105610b93a01ab7f538f7c59802328f00538721fc5
       Internal ip:         172.17.0.3               
       Links:               -                        
       Service root:        /var/lib/dokku/services/redis/speicher
       Status:              running                  
       Version:             redis:6.2.6              
root@docker:~# dokku redis:link speicher staging.greybox.speicher.ltd
-----> Setting config vars
       REDIS_URL:  redis://:b8ee85b232eb6caba777ec227c745dceeed1c9d0a9a2177fafd1c21afa0084f4@dokku-redis-speicher:6379
-----> Restarting app staging.greybox.speicher.ltd
 !     App image (dokku/staging.greybox.speicher.ltd:latest) not found


```

### PostgreSQL

  239  dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
  243  dokku postgres:create greybox
  244  dokku postgres:link greybox staging.greybox.speicher.ltd


### Letsencrypt

```
root@docker:~# dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git letsencrypt
-----> Cloning plugin repo https://github.com/dokku/dokku-letsencrypt.git to /var/lib/dokku/plugins/available/letsencrypt
Cloning into 'letsencrypt'...
remote: Enumerating objects: 796, done.
remote: Counting objects: 100% (258/258), done.
remote: Compressing objects: 100% (174/174), done.
remote: Total 796 (delta 162), reused 155 (delta 83), pack-reused 538
Receiving objects: 100% (796/796), 163.42 KiB | 14.86 MiB/s, done.
Resolving deltas: 100% (489/489), done.
-----> Plugin letsencrypt enabled
v4.3.1: Pulling from goacme/lego
8464c5956bbe: Pull complete 
57b6439b4724: Pull complete 
7f7f62561bed: Pull complete 
c824ba218e5a: Pull complete 
Digest: sha256:ddb06ca69e4790c345495926ac5ff5f29bc52985e2df6a7d0026e18dc689e37e
Status: Downloaded newer image for goacme/lego:v4.3.1
docker.io/goacme/lego:v4.3.1
Adding user dokku to group adm
Starting nginx (via systemctl): nginx.service.
-----> Priming bash-completion cache
root@docker:~# 
```


## Setting up Dokku environment

### Setup staging environment (first) - use greybox repo on gitserver.alco.company

```
√ src % git commit -m 'setup for staging'
[main ac37472] setup for staging
 1 file changed, 8 insertions(+), 1 deletion(-)
√ src % git push
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 8 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 471 bytes | 471.00 KiB/s, done.
Total 4 (delta 3), reused 0 (delta 0), pack-reused 0
To gitserver.alco.dk:walther/elmelund.git
   ea018ef..ac37472  main -> main

√ src % git remote add greybox git@gitserver.alco.dk:speicher/greybox.git
√ src % git checkout -B staging
M       REFERENCES.md
Switched to a new branch 'staging'
√ src % git status
On branch staging
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   REFERENCES.md

no changes added to commit (use "git add" and/or "git commit -a")
√ src % git push -u greybox staging
Enumerating objects: 3973, done.
Counting objects: 100% (3973/3973), done.
Delta compression using up to 8 threads
Compressing objects: 100% (3901/3901), done.
Writing objects: 100% (3973/3973), 3.56 MiB | 3.10 MiB/s, done.
Total 3973 (delta 2759), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2759/2759), done.
To gitserver.alco.dk:speicher/greybox.git
 * [new branch]      staging -> staging
Branch 'staging' set up to track remote branch 'staging' from 'greybox'.
√ src % git remote add staging dokku@docker.alco.company:staging.greybox.speicher.ltd
√ src % git push staging
```
## Setup access to Postgres DB from outside the container

[access Postgres from outside](https://stackoverflow.com/questions/34851335/accessing-postgres-database-inside-dokku-container-from-outside)

```
root@srv005415:~# dokku postgres:expose greybox 10.85.130.8:5432
-----> Service greybox exposed on port(s) [container->host]: 5432->10.85.130.8:5432
```

## Access Rails, and NgINX logfiles 

The overall logfile is 'watchable' using `ssh docker4 logs -t staging.greybox.speicher.ltd` whereas the NgINX logfiles are best viewed with 
`ssh docker4 nginx:access-logs staging.greybox.speicher.ltd` and `ssh docker4 nginx:error-logs staging.greybox.speicher.ltd`

Besides that all logging is directed towards journald and accessible via `journalctl`

## Defining volumes (for cross-version file storage and more)

Each app may require somewhere to persist files - say uploaded documents/images/more. To that end 

```
# dokku ps:stop staging.greybox.speicher.ltd
# dokku docker-options:add staging.greybox.speicher.ltd deploy,run -v /var/lib/dokku/data/storage/staging.greybox.speicher.ltd:/app/storage
# dokku ps:start staging.greybox.speicher.ltd
# ls -la /var/lib/dokku/data/storage/staging.greybox.speicher.ltd

```


