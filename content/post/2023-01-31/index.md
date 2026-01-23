---
author: "Bengt Grønås"
title: "VROPS Out of Disk Space" # Title of the blog post.
date: 2023-01-31T12:53:31+01:00 # Date of post creation.
description: "Unable to bring the cluster online because one or more nodes are out of disk space" # Description used for search engine.
featured: false # Sets if post is a featured post, making appear on the home page side bar.
draft: false # Sets whether to render this page. Draft of true will not be rendered.
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
  - vRealize
  - Operations

comment: false # Disable comment if false.
---

**What if you are Unable to bring your vRealize (Aria) Operations cluster online because one or more nodes are out of disk space. Let's see if the log disk is the problem and try to fix it**

The goal is to find out if the Log disk is full and how to clean it and hopefully you save some time with this mini-Recipe that will show you how to investigate the "Unable to bring the cluster online because one or more nodes are out of disk space." error in the Admin console of vRealize Operations and what to check.

## The Admin Console

<img src="./aria-automation/index/image-20230131130004842-1675166417559-1.png" alt="image-20230131130004842" style="zoom:80%;" />

From the admin-gui `https://<vropsFQDN>/admin`, my cluster is not running, it is out of disk space, I am running vrops v8.10, and SSH is enabled. If SSH is not enabled, do it now. We also see the same above from the *cluster status* "Unable to bring the cluster online because one or more nodes are out of disk space".  Note: If you should force it online now, nothing would happen and the status would end up exactly the same.

## SSH to vROps, check space

You can use putty or a windows command line to SSH into the vrops virtual appliance instance. After you've logged on, go ahead and issue a `df`, or `df -hk` command to check the disk space:

![image-20230131131026114](./aria-automation/index/image-20230131131026114-1675167027725-5.png)

As you can see the `Use%` for one of the file systems are sky high, in fact 100% filled. Let's see if we can do some remedy on `/storage/log`, before we go through the trouble of adding or increasing any disk space. 

## Shave the logs

1. `service syslog stop`
2. `rm -f /var/log/warn* /var/log/auth.log* /var/log/messages*`
3. `service syslog start`
4. `find /storage/log/ -mount -type f -mtime +1 -exec echo {} \; -exec truncate -cs 0 {} \; 2>&1 | tee /tmp/files_truncated.txt`

## what now?

Check if it worked by issuing a new `df -h` command like above. If the file systems are OK, go ahead and start the cluster from the admin console. <u>Note; You should actually bring it down again and up again to see if the cluster is OK.</u>

## Articles

[Troubleshooting Storage Issues in vRealize Operations (83239)](https://kb.vmware.com/s/article/83239)

[How to safely clean /storage/log in vRealize Operations (2145578)](https://kb.vmware.com/s/article/2145578)



