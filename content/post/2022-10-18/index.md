---
author: "Bengt Grønås"
title: "Install Python 3.10.8 on RaspBerry PI [18.10.2022]" # Title of the blog post.
date: 2022-10-18T15:49:42+02:00 # Date of post creation.
description: "Article description." # Description used for search engine.
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
  - Raspberry PI
  - Python

comment: false # Disable comment if false.
---

## How-to set up Python on Pi
The goal of this little article is to show how I installed Python on raspberry PI.  There are lot's of articles out there on the subject, but since I am a beginner, I am running through everything I find useful for  my self and as a later notice to myself. This saves med the time and hassle to find the recipe or how-to next time. Plus, I know what worked for me. 

 ### Where can I find Python? 
https://www.python.org/ is a good place to start. The Python versions can be found here:  https://www.python.org/downloads.  The one I've found and selected for Linux (Raspberry Pi) is : https://www.python.org/ftp/python/3.10.8/Python-3.10.8.tgz take with you this one to the next steps. 

After you've logged in to your Raspberry Pi thing...
### How do I check my Python version?
`python --version` 
`python3 --version`

### How do I set up a python on RPi?
* `cd /tmp`
* `wget https://www.python.org/ftp/python/3.10.8/Python-3.10.8.tgz`
<img src="image-20221018160821649-1666102104790-1.png" alt="image-20221018160821649" style="zoom:33%;" />
* `tar -zxvf Python-3.10.8.tgz`
* `cd Python-3.10.8`
* `./configure --enable-optimizations (Takes approx. 2+ minutes)`
* `sudo apt update`
* `sudo apt install -y build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev`
* `sudo make altinstall (easily took 25+ minutes)`
<img src="image-20221018160914957-1666102158034-3.png" alt="image-20221018160914957" style="zoom:33%;" />

### How do I link?
`cd /usr/bin`
`sudo rm python3`
`sudo ln -s /usr/local/bin/python3.10 python3`

`cd /usr/bin`
`sudo rm python`
`sudo ln -s /usr/local/bin/python3.10 python`

### How do I upgrade python later?
easy..

`sudo apt update`
`sudo apt upgrade`
#### Visual Studio Code (vscode)
Now that you've installed Python it's time to link Visual Studio Code to your freshly installed Raspberry Pi, so you can noodle around with python on your little python based server.

* `Start` vscode and search for ssh in the extensions marketplace
<img src="image-20221018161544402-1666102548329-5-1666102552737-7.png" alt="" style="zoom:50%;" />

* In the left side of vscode click the SSH icon:
![](image-20221018161757847-1666102683058-9.png)

* Click the + icon, and enter "ssh logon@serverIP and press enter":
![](image-20221018162209824-1666102932702-14.png)

* Select your config file c:\users\admin\.ssh\config:
![](image-20221018162322457-1666103005915-16.png)

* The host will be added:
!<img src="image-20221018162404385-1666103046802-18.png" alt="" style="zoom:80%;" />

* Click connect and Enter your password:
  <img src="image-20221018162507193-1666103110065-20.png" alt="" style="zoom:80%;" />

* Now you have a connection to your Raspberry PI:
  <img src="image-20221018162702706-1666103225437-22.png" alt="" style="zoom:50%;" />

* Click Open Folder to start editing files on your PI :
  <img src="image-20221018162954384-1666103396972-24.png" alt="" style="zoom:50%;" />

### Why not a virtual machine with some Linux distro on
Now you can go and have a blast with your python projects on your local PI. You may argue I should have had the free VMware ESXi server, the VMware Workstation or ProxMox server to host a virtual machine on, but as of now I had an extra Raspberry PI lying around, and I wanted to make use of it for some python noodling and see what it was good for without having a larger machine running.  Another way is of course to install the windows version on your local Windows (or mac) to run all projects locally, but then again, to keep a clean slate, I did it *myyyyyyy waaaayyy.* 

  
