---
author: Bengt Grønås
title: Frigate - I've neither seen the boat nor the bird
date: 2022-03-07T20:31:51.000Z
description: 'Equipment, Installation'
featured: false
draft: false
toc: false
usePageBundles: true
featureImage: K8s.png
thumbnail: frigate_bird.png
shareImage: logo.png
codeMaxLines: 10
codeLineNumbers: false
figurePositionShow: false
categories:
  - Home Automation
tags:
  - Frigate
  - Home Assistant
  - NVR
comment: false
lastmod: '2022-03-08T11:25:38.883Z'
---
#  Frigate 
Frigate - I've neither seen the boat nor the bird but my Frigate can actually dock or nest?! :-) 
Frigate is an open source NVR, a **N**etwork **V**ideo **R**ecorder which is run as a Docker container on a Docker host. My preferred choice was to run it on Ubuntu 21.04 and install all the docker components directly on ubuntu on hardware. This is the recommended install method.

I hope that, by exposing my own configuration here, people might install and configure frigate faster than I did. 

##### **Why Frigate?**
In my case I wanted basically ANY CAM in one place. AND I wanted to recognise cars, people, bicycles, motorcycles, cats, and dogs from ANY of those cams. Now I've been a huge fan of Hikvision cams, but I also have other cams that do not have the same possibilities, qualities, properties, and performance as the Hikvison cameras.  So to give equal opportunities to any camera with an IP supporting RTSP, IMHO Frigate is the best tool out there. 

Let's have a look at the hardware I've used and the configuration files I've managed to assemble using friends and google.
##### **My NUC**
|<!----> |<!---->| 
|:--|:--|
| I bought a fairly cheap Intel Nuc 11th gen. Pro I7/i7-1165G7 Tall Barebone Tiger Canyon [NUC11TNHI7](https://www.intel.com/content/www/us/en/products/sku/205605/intel-nuc-11-pro-kit-nuc11tnhi7/specifications.html), and filled it with 32GB (2x16GB) [KINGSTON FURY ](https://www.kingston.com/en/memory/gaming/kingston-fury-impact-ddr4-memory)Impact DDR4-2666 CL15 RAM, and a [WD Black SN750 SSD M.2](https://www.westerndigital.com/products/internal-drives/wd-black-sn750-nvme-ssd#WDS200T3X0C) 2TB NVMe PCIe disk | ![](nuc1.png) { width=50% } |

##### **Formfactor E-key**
The reason to buy this NUC was because some of these NUCS had 3 different M.2 ports, 	2280 NVMe (M); 2242 SATA (B), and lastly the 	2230 (E-key) (E) which I needed for my Coral M.2 card. M.2 cards have a rectangular shape. The size of an M.2 module is marked by its form factor. The form factor defines the width by length in millimeters. 
<img src="formfaktorer.jpg" style="zoom: 80%;" />



##### **Google Coral hardware**
|                                                              |                     |
| ------------------------------------------------------------ | ------------------- |
| I bought a too expensive [Coral M.2 board](https://coral.ai/products/m2-accelerator-dual-edgetpu/) on eBay (M.2 E key), meaning i ripped out the excellent Intel Wi-Fi 6 AX201 WIFi card and replaced it with a Google Coral Accelerator Dual Edge TPU. | ![](coralboard.png) |

**Google Coral?**

> Google Coral is an edge AI hardware and software platform for intelligent edge devices with fast neural network inferencing. Coral is Google's initiative for pushing into Edge AI, with machine learning devices that run without a connection to the cloud
##### **Ubuntu installation** 
I use Rufus for almost anything IMAGING onto USB Sticks. this time to install Ubuntu on hardware. LMGTFY: "How to Make Ubuntu 21.04 Bootable USB Drive using Rufus". I picked up an **Ubuntu** ISO image from http://www.releases.ubuntu.com/21.04/ and **Rufus** from https://rufus.ie/en/.  When the push comes to shove, just install a server, don't bother with any GUI or other fetures. Easy-peasy, just follow the prompts and "Bob's your uncle!"
**Other things you'll need** (just google it) 
* Set an **IP** (not DHCP) for your system using `/etc/netplan/`
* Set a hostname using` hostnamectl`
* Make sure you can use Putty or any other **SSH** client to access your server. I'm always logging in as root via putty to avoid all that sudo stuff no one needs. I know - NO SECURITY for the convenience. But I don't give a damn. This server is not available on the internet. 
* Make sure **NTP** is working. I most often configure the _no.pool.ntp.org_ servers as my defaults 

##### **The MQTT**
I just installed MQTT Server (The Broker) on Home Assistant using the "Mosquitto broker". I use it for the Home Assistant add-on 'Zigbee2mqtt' (because zha is just shit) and for Tasmota devices, such as Sonoff Basic, and more. Well. Comfigure it with a admin, password, and default port, and youl'll be fine. Go here: https://github.com/home-assistant/addons/blob/master/mosquitto/DOCS.md 

Here's my own Home assistant MQTT configuration. You can find it here:  `"Configuration>Add-ons, Backups & Supervisor>Mosquitto broker>Configuration>"Mosquitto broker Optons"`  
```
certfile: fullchain.pem
customize:
  active: false
  folder: mosquitto
keyfile: privkey.pem
logins:
  - username: mqtt 
    password: yourPassword
require_certificate: false
```
##### **Create these directories**
Putty yourself onto your frigate server and mkdir these: 
* /frigate
* /frigate/media
* /frigate/config
* /frigate/coral
##### **Docker Installation**
Docker on ubuntu is fairly easy. You have got to end up with docker compose and docker. These commands will make the shit happen to be able to install frigate. #LMGTFY. 
##### **Coral Setup**
https://coral.ai/docs/m2/get-started/ #LMGTFY. 
##### **Frigate Installation**
Just go to this page, You'll need the information on that page https://docs.frigate.video/installation/

##### **docker compose**
Running docker compose with the following Docker compose file, is what stands up a container, and an app, and that app is based on an docker image you specify in the docker compose file. In the volumes: section you can see real life ubuntu paths mapped the paths that will surface magically within the docker conatiner. this means the file `/frigate/config/config.yml ` maps to the frigate app as `/config/config.yml `and it will be read-only. 

Run `docker-compose up` and `docker-compose down `in your `/frigate/config` folder while you keep editing and troubleshooting your `/frigate/config/config.yml` file
When you're done, take it down, and then use the -d switch to run it as a daemon:
```
docker-compose up -d
```
##### **My Docker Compose file**
I'll admit it, I'm not even a rookie when it comes to docker containers. I'd say I'm a total illiterate and a dumb fuck. Even so, with a little explanations and a **lot** of help from my friends I managed to get my very first Docker Compose file up and running. This file was `/frigate/docker-compose.yml`

Not very far from the practical example mentioned on the Frigate installation page. Here's what I ended up with:  
```
version: "3.9"
services:
  frigate:
    container_name: frigate
    image: blakeblackshear/frigate:stable-amd64
    restart: always
    devices:
      - /dev/apex_0:/dev/apex_0
    volumes:
      - /frigate/config/config.yml:/config/config.yml:ro
      - /frigate/media:/media/frigate
      - type: tmpfs # Optional: 1GB of memory, reduces SSD/SD Card wear
        target: /tmp/cache
        tmpfs:
          size: 1000000000
    ports:
      - 5000:5000
      - 1935:1935
    environment:
      FRIGATE_RTSP_PASSWORD: "yourPassword"
```
What made Coral tick? this entry: 
```
    devices:
      - /dev/apex_0:/dev/apex_0
```
##### **My initial Frigate Config file**
When I first started to test, I created the simplest file not far from the original shown in the installation document https://docs.frigate.video/installation/ . This file went into `/frigate/config/config.yml` 
```
mqtt:
  host: 192.168.1.4
  user: mqtt
  password: yourPassword!

cameras:
  back1:
    ffmpeg:
      inputs:
        - path: rtsp://youradmin:yourPassword!@192.168.1.93/Streaming/Channels/101
          roles:
            - rtmp
```
> Note: This config does NOT engage Coral, so the CPU does the detection stuff. 
> 
##### **My current Frigate Config file**
I have listed the config as an example on two different Hikvision cameras, and one Ubiquiti Unifi Protect camera. 
For the full config file options, go here: https://docs.frigate.video/configuration/index/

```
mqtt:
  host: 10.10.1.4
  user: mqtt
  password: yourPassword

detectors:
  coral:
    type: edgetpu
    device: pci:0

birdseye:
  enabled: True
  width: 1280
  height: 720
  quality: 3
  mode: continuous

timestamp_style:
  position: "br"
  format: "%d.%m.%Y %H:%M:%S"
  color:
    red: 255
    green: 255
    blue: 255
  thickness: 2
  effect: shadow

objects:
  track:
    - person
    - bicycle
    - car
    - motorcycle
    - bird
    - cat
    - dog

cameras:
# This is a hikvison 
  westcam:
    ffmpeg:
      inputs:
        - path: rtsp://youradmin:yourPassword!@10.10.1.64:554/Streaming/Channels/102
          roles:
            - detect
            - record
            - rtmp
    detect:
      enabled: True
    record: # <----- Enable recording
      enabled: True
    snapshots: # <----- Enable snapshots
      enabled: True
# This is a hikvison 
  backeast:
    ffmpeg:
      inputs:
        - path: rtsp://youradmin:yourPassword!@10.10.1.66/Streaming/Channels/101
          roles:
            - detect
            - rtmp
            - record
    detect:
      enabled: True
    record: # <----- Enable recording
      enabled: True
    snapshots: # <----- Enable snapshots
      enabled: True
# This is a Ubiquiti Unifi Protect cam  
  trampoline:
    ffmpeg:
      inputs:
        - path: rtsps://10.10.0.1:7441/UnKVB41oCrvK4xLm?enableSrtp
          roles:
            - detect
            - record
            - rtmp
    detect:
      enabled: True
    record: # <----- Enable recording
      enabled: True
    snapshots: # <----- Enable snapshots
      enabled: True

```
**What made Coral tick?** This entry:
```
detectors:
  coral:
    type: edgetpu
    device: pci:0
```
##### **Home Assistant integration** 
The Home Assistant Addon is not the same thing as the integration. Go here for a fine install doc: https://github.com/blakeblackshear/frigate-hass-integration
and Frigate's own: https://docs.frigate.video/integrations/home-assistant/

1. **Integration:** Home Assistant > HACS > Explore & Add Repositories > Frigate
2. Restart HA
3. **Add-on:** Home Assistant > Configuration > Integrations (add frigate)
4. **Lovelace Card:** Home Assistant > HACS > Frontend > "Explore & Add Integrations" > Frigate Card
5. Add this to Home Assistant `configuration.yaml`:
```
# Example configuration.yaml entry
media_source:
```


_I hope this makes your installation and config easy_