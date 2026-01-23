---
author: "Bengt Grønås"
title: "Root Password Expiration on VRealize Appliances" # Title of the blog post.
date: 2022-06-23T11:03:00+02:00 # Date of post creation.
description: "How to handle root password expiration on vRealize appliances such as Vrealize Log Insight (VRLI), Lifecycle manager(VRCLM), Automation(VRA), Operations(vROps), Identity manager(VIDM) " # Description used for search engine.
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
  - Aria
  - Appliances

comment: false # Disable comment if false.
---

# **What's the problem?**

Normally a Virtual appliance (VA) in the vRealize Suite (VRS), aka Aria, will expire the root password you set under the installation within a year. Well, nothing dramatic about that. But, will you remember to change it next year? Maybe, if something told you in a GUI, mail or monitoring system that the password were going to expire. 

#### A monitoring dilemma

When the VA root password is expired it will prompt you to change it when you SSH into it. **Fine**. But how would you know if the password expires? AFAIK. There is currently no check for this in vRealize Operations manager, aka Aria Operations, or any of the other vRealize products. There might be a future health check for this, but as for now (june 2022) there was none. 

#### Changing passwords from Life Cycle Manager

You can request a change the VA root password in vRealize Lifecycle Manager (*vRLCM*) for the different products, let's say vRealize Automation.  vRLCM will then set up a SSH session and try to use the 'passwd' command. That would fail in the case the password has expired, because you would automatically be prompted to update the password.  On the other hand, if you were somehow informed some time before the passwords did expire. Changing passwords from LCM would be a walk in the park. 

####  inventory sync in LCM and other LCM tasks

If you do an inventory sync in vRealize Lifecycle manager, and your password has expired, there will be a very generic error message. This message is not very helpful to make you realize that the VA password needs changing. Other LCM tasks I've been checking is for example to update a license. that also fails until the password has changed

# **Solution?**

1. Set the root password expiration for all Virtual Appliances to *Never*.  
2. Change root passwords directly out of vRSLCM with just one request.

Both of these options are still to come, and they’re not an implemented solution in vRLCM v8.8.x

## What you need to do:

1. log in to one of the virtual appliances with putty or any other SSH client as root
2. use the command `chage -l root` to see how long it is until the password expires
   ![](image-20220623114513599-16559775205061.png)
3. As you can see, a disaster is about to hit me. I want to set this password to **never expire** . use this command to do that: `chage -I -1 -m 0 -M 99999 -E -1 root`  then run the `chage -l root`  to see the results :
   ![](image-20220623114830537-16559777129163.png)

#### Pr./Virtual Appliance and Upgrades

Now comes the fun. You have to do this to every single product individually, so repeat the task above for all you vRealize products virtual appliances, VRA, VROPS (all nodes, including Master, replicas, cloud proxies etc.), VRLI, VIDM, VRLCM, etc. #Note:  If you upgrade the virtual appliance, the change we made will be reset or tampered with and we have to do it all over again

# **Passwords remembered**

If you want to avoid the passwords that are remembered because you want your regular LAB password, then have a look through these files 

**/etc/pam.d/system-auth**
**/etc/pam.d/system-password**

```Linux script
password    requisite   pam_cracklib.so     minlen=8 minclass=4 difok=4 maxsequence=0 retry=3 enforce_for_root
password    requisite   pam_pwhistory.so    retry=3 remember=5 enforce_for_root
```

Edit any **remember** option on any lines and set it to **0**. Remove '**enforce_for_root**' from the lines. A value of 0 disables passphrase support.: passphrase=3, set it to 0.

**/etc/security/opasswd**

The opasswd still keep the user's info, the user is not removed from opasswd

```Linux script
cat /dev/null > /etc/security/opasswd
touch /etc/security/opasswd
chown root:root /etc/security/opasswd
chmod 0600 /etc/security/opasswd
```

**/etc/shadow** 

copy your shadow file and delete the line containing ‘root’
```Linux script
cp -p /etc/shadow /etc/shadow.backup
vi /etc/shadow

```
### Set your desired LAB password

use the #passwd root

```Linux script
passwd root
New password:
Retype new password:
passwd: password updated successfully
```
Check again and possibly revisit the  magic above
```Linux script
chage -l root 
chage -I -1 -m 0 -M 99999 -E -1 root
```

