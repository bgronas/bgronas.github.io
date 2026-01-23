---
author: Bengt Grønås
title: 'New Year, New Blog, Learning HUGO [19.01.2022]'
date: '2022-01-19T15:55:16.459Z'
description: I just changed from Wordpress to HUGO static Website.
featured: false
toc: false
usePageBundles: true
featureImage: hugo-logo.png
thumbnail: hugo-logo-small.png
shareImage: logo.png
codeMaxLines: 10
codeLineNumbers: false
figurePositionShow: false
categories:
  - Personal stuff
tags:
  - HUGO
comment: false
draft: false
slug: 'year-blog-learning-hugo-[19-01-2022]'
keywords:
  - Hugo
  - Blog
  - Personal
---

# WOW, I just moved to HUGO. 

###### Wordpress
I was previously using Wordpress with my public web  provider. proISP. I have loved ProISP, they are providing me with domains, e-mail, web hosting, MySQL databases and everything. 

Hosting a Wordpress site with them and paying almost nothing for it was very cool, and I have loved wordpress for the simplicity and for the easiness of changing the looks by using simple CSS, Templates, and publishing, It's just been a walk in the park. :-) 

With my public self-hosted Wordpress installation I was trying to keep the security clean and tidy, but that was a challenge. During the years I have been attacked in so many ways, I can't count them.  I did implement certain wordpress security products to make sure I wasn't attacked so much, Some of these were...

###### IP2Location Country Blocker: 
Blocked the access from multiple countries, and group them using EU, APAC, and so on. Block the access from anonymous proxies, block the access by IP ranges. and I had an email notification if someone tried to access my admin area.

###### All In One WP Security & Firewall: 
reduced security risk by checking for vulnerabilities, and by implementing and enforcing the latest recommended WordPress security practices and techniques. Generally non-invasive and will not break any functionality. Provided me with security applied to my site.

###### Wordfence 
An endpoint firewall and malware scanner. A comprehensive security option. A better protection than cloud alternatives. Cloud firewalls can be bypassed and have historically suffered from data leaks. Wordfence firewall leverages user identity information in over 85% of our firewall rules, and doesn’t need to break end-to-end encryption..

###### It wasn't enough!
So, I thought I was fairly safe, but then the breach mails kept coming in, and the attacks were never ending. 
I finally decided to do the same as many of my work-peers have already done, I took the leap to HUGO

###### HUGO is Cool
Hugo says they're _"the world’s fastest framework for building websites, and the most popular open-source static site generator."_ Not that I knew of any other generator when I started, but I'd say that's pretty much correct. I now know 4 people using hugo, and they all seem fine with it.  

[GOHUGO](https://gohugo.io/) says _"With its amazing speed and flexibility, Hugo makes building websites fun again."_
I will admit that it's challenging, but fun. If you're not a technical guy, I'd say you'd be using some time to get up to speed, at least if you want to modify themes, templates, css, and such. It's not as easy and userfriendly as wordpress. Some people, including me, might argue that that is also the strength. Well. at least the security is restored 100%. 

Publishing to github from my local PC, then utilizing NETLIFY: https://www.netlify.com/ to publish automatically from github is just extremely nice and veru automatic and user friendly. 

###### Local Scripts
I just had to have a couple of local CMD scripts. One that generates blogs, and one that publishes the blogs to Github. I'm just hosting the local stuff in dropbox, so I can access everything directly from my PC without cloning the github stuff all the time. So just a one-way push there :-) 
I can see that Markdown is something I need to get better at. I'll probably do it all in Visual Studio Code. I think it'll be easy. Easier than notepad.exe  that this is written in... LOL :-) :-) :-) 

**blog_post.cmd**
```
for /F "tokens=6" %%d in ('net time \\%COMPUTERNAME%^|findstr /I /C:"%COMPUTERNAME%"') do set today=%%d<br>
if (%today:~1,1%)==(/) set today=0%today%<br>
if (%today:~4,1%)==(/) set today=%today:~0,3%0%today:~3,6%<br>
set day=%today:~0,2%<br>
set month=%today:~3,2%<br>
set year=%today:~8,2%<br>
set /p input=Enter a short Title of your New Blog post: <br>
set Input=%Input% [%today%].md<br>
hugo new "post\20%year%-%month%-%day%\%input%"<br>
xcopy "..\..\IMAGES\*.png" "content\post\20%year%-%month%-%day%" /S /C /D /-Y <br>
MOVE ".\content\post\20%year%-%month%-%day%\%input%" ".\content\post\20%year%-%month%-%day%\index.md"<br>
"C:\Program Files\Notepad++\notepad++.exe" ".\content\post\20%year%-%month%-%day%\index.md"<br>
```
**git_me_up.cmd**
```
git add *<br>
RMDIR /S /Q public<br>
MKDIR public<br>
hugo <br>
del /F /S /Q ".git\worktrees\public"<br>
echo %DATE% %TIME% > date-time_last_updated.txt<br>
cd public<br>
git add --all <br>
git add *<br>
git commit -m "Blog Update publish: %DATE% %TIME% - bgronas" <br>
git push --all<br>
```

Until Next time....

>B





