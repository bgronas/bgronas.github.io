---
author: "Bengt Grønås"
title: "VSAN Stretched Cluster and Aria Operations" # Title of the blog post.
date: 2022-10-05T09:34:10+02:00 # Date of post creation.
description: "Aria Operations and VSAN Stretched Cluster" # Description used for search engine.
featured: false # Sets if post is a featured post, making appear on the home page side bar.
draft: true # Sets whether to render this page. Draft of true will not be rendered.
toc: false # Controls if a table of contents should be generated for first-level links automatically.

# menu: main
usePageBundles: true 

# Set to true to group assets like images in the same folder as this post.
# featureImage: "thumbnail.png" # Sets featured image on blog post.
featureImage: "line.jpg" # Sets featured image on blog post.
# featureImageAlt: 'Description of image' # Alternative text for featured image.
# featureImageCap: 'This is the featured image.' # Caption (optional).

thumbnail: "thumbnail.jpg" # Sets thumbnail image appearing inside card on homepage.
shareImage: "logo.png" # Designate a separate image for social media sharing.
codeMaxLines: 10 # Override global value for how many lines within a code block before auto-collapsing.
codeLineNumbers: false # Override global value for showing of line numbers within code block.
figurePositionShow: false # Override global value for showing the figure label.
categories:
  - Technology
tags:
  - Aria
  - Operations
  - VSAN

comment: true # Disable comment if false.
---

## introduction

The goal and purpose of this article is to show how Aria Operations (8). Formerly known as vRealize Operations) is used to take care of capacity planning and utilization of stretched VSAN clusters. So the Topic today is to walk you through how does this save time and remove the hassle by investing little time in creating yourself a nice dashboard to combine many small admin tasks into one. 

### TOPICS: 
- How can I improve and organize my ....
- Where can I find ...
- Where can I start .... How can I start ....
- How do I set up a reliable, long-term.....
- What’s the best way to ....

### Capacity

First of all, some facts about capacity. 

Capacity projections are based on the usable capacity of a datastore. The capacity projection is aware of the slack space requirements.  

Usage is based on the amount of physical disk space used by the VM, which includes overhead for FTT, etc.  

This means that when you look at projections like *time remaining*, *capacity remaining*, *VMs remaining*, etc. those are based on the effect of the VSAN storage policies.

What-if analysis to convert the projected capacity remaining to projected capacity remaining per VSAN storage policy is not currently available.  

You have to set the "buffers" in the vROps policy to ensure vROps reserves the amount of resources that the customer desires. You could also utilize the *admission control* on the cluster in vCenter as well.  



### What are we looking for?

- Total VSAN capacity
- Total disk usage for replicated VMs *2
- Total non-replicated disk usage on both sides *1
- capacity remaining





# `VSAN Stretch clusters`
`i samme vCenter (DC1, DC2, Witness)`

`1-15 hosts on each DC1/2`
`All 15 hosts = one fault domain, Fault domain 1 and 2`
`Fault Domain 3 == witness`
`RTT==5ms between the two DCs`
`Witness= RTT <200ms`

`Typisk Conf.`  

- `Primary Failure to tolerate`
  `FTT = 1, Raid1`
  `dvs. Skriv på DC1 og DC2`
  `ACK ved skriv på DC2, means RPO=0`



- `Secondary Failure to tolerate`
- `Lokalt for DC2`
  `FTT = 1, Raid 1`
  `FTT = 1, Erasure Coding (5/6)`
  `eller` 
  `FTT = 2, Raid 1`
  `FTT = 2, Erasure Coding (5/6)`


`Du har vSPhere HA mellom DC's`

-----------------------------------------------------



All vSAN objects and their corresponding policies? 

Maybe with PowerCLI or vROPs? 

HCI Mesh

- Hi all , there is any way for monitor (maybe with vrops) the vSAN LLOG consumption, PLOG consumption,Total log consumption ?

- Customer feels that the latency can be improved or the amount of IOPS?
- Customer is experiencing high latency on all applications or only some of them?
- Does our metrics on vCenter or vROPs shows that the vSAN latency is high or VMs disk latency is high?
- What's the vSAN's version on customer today? We generally implement performance improvement on most recent versions.
- How is the vSAN Health (or Skyline Health). Drivers, Firmware-s are on the recommended version?
- Is vSAN Health showing any alert Yellow or Red?
- Are the vSphere + vSAN network configured according with the best practices (vmkernel, shares, etc)?
- Any signal of problemes on the Network? High number of collisions or tranmission errors?
- It's an Hybrid or Flash Environment?
- Disk Groups and Cache are correctly sized and according with the best practices?
- There is sufficient resources (memory and CPU) available on the environment?
- There is sufficient free space on the vSAN Datastore?
- What are the policies applied?
- You should only look at Host -> Monitor -> vSAN -> Performance

