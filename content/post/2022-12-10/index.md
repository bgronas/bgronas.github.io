---
author: "Bengt Grønås"
title: "Bypass Windows 11 Install Problems" # Title of the blog post.
date: 2022-12-10T15:22:01+01:00 # Date of post creation.
description: "This PC can’t run Windows 11" # Description used for search engine.
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
  - windows

comment: false # Disable comment if false.
---

# The problem

The goal and purpose was that I needed to bypass the "**This PC can’t run Windows 11**" problem during an installation of a Windows 11 Virtual Machine (VM) in my test environment.  This DIY recipe will save us the hassle of googling it once again and sorting out the correct article to try out.

### This PC can’t run Windows 11

This happens during an install:

<img src="./aria-automation/index/ErrorCropped-1670682926123-3.png" alt="Windows 11 Fresh Install - This PC can't run Windows 11" style="zoom:80%;" />



# The Solution

1. Go back one step by clicking **top-left blue arrow** 
2. press '**Shift+F10**'
3. in the CMD box, type '**regedit**' and press **enter**
4. in the registry editor Navigate to “HKEY_LOCAL_MACHINE\SYSTEM\Setup”
5. Right click Setup, Choose New Key, and Name it "**LabConfig**"
6. Under LabConfig, add all these values as **DWORD (32-bit) Values** and set the data to **1**

- `BypassCPUCheck`
- `BypassRAMCheck`
- `BypassSecureBootCheck`
- `BypassStorageCheck`
- `BypassTPMCheck`

After all these manual inserrtions are done, you are ready to continue the fight of installing Windows 11. 

1. **Close** regedit
2. **Exit** the DOS command prompt 
3. **Continue** your installation!



remember to smile <img src="./aria-automation/index/smiley-1635449_1280-1670684743695-7.png" alt="Smiley Emoticon Happy - Free vector graphic on Pixabay" style="zoom:5%;" />
