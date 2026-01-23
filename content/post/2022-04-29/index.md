---
author: "Bengt Grønås"
title: "vRealize Operations 8.6.3. [29.04.2022]" # Title of the blog post.
date: 2022-04-29T14:54:50+02:00 # Date of post creation.
description: "VMware vRealize Operations 8.6.3 - April 2022" # Description used for search engine.
featured: false # Sets if post is a featured post, making appear on the home page side bar.
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
codeMaxLines: 6 # Override global value for how many lines within a code block before auto-collapsing.
codeLineNumbers: false # Override global value for showing of line numbers within code block.
figurePositionShow: false # Override global value for showing the figure label.
categories:
  - VMware
tags:
  - vRealize
  - Operations
comment: false # Disable comment if false.
draft: false   # Sets whether to render this page. Draft of true will not be rendered.
---

**Recently, VMware released new and improved vRealize versions. Let's have a look on vRealize Operations and the new v8.6.3 of the product**. 

This release from 8.6.2 to 8.6.3. is a is a **maintenance release** which resolves a few important security and functionality issues identified in the product For more details, see [KB 88081](https://kb.vmware.com/s/article/88081). There are *154 CVE's* (Common Vulnerabilities and Exposures) solved and fixed. I'd say it's quite a large update even if it feels minor. The following issues have been resolved as of vRealize Operations 8.6.3:

| upgrading is easy with Life Cycle Manager                    | Issues solved in vROps 8.6.3     |
| ------------------------------------------------------------ | :------------------------------- |
| <img src="image-20220502131339684.png" alt="" style="zoom:50%;" /> | ![](image-20220502131635803.png) |

Let's highlight a few..

#### METRICS ####

There are some **new Metrics** added in this release. Some of these are related to the Energy, Emission, power usage, and waste, which implies that most of these new metrics surrounds the **sustainability dashboards**. Have a look at [Metrics added in vRealize Operations 8.6](https://kb.vmware.com/s/article/85834) where you can download an [Excel Spreadsheet](https://kb.vmware.com/sfc/servlet.shepherd/version/download/0685G00000Z5xqgQAB) with all the added metrics. <img src="image-20220502132914598.png" alt="Excel Spreadsheet" style="zoom:80%;" />

#### INSTANCED METRICS

If you're using the *Breakdown by* and *Add instance breakdown column* you have probably used what we call **instanced metrics** under the *Group By* Tab when you have created a View (*Data*). These are now disabled by default, but can easily be re-enabled again. go to [KB 81119](https://kb.vmware.com/s/article/81119).

![instanced metrics](image-20220502103005832.png)

#### BASIC AUTH

Basic authentication using the REST API is deprecated and disabled in vRealize Operations 8.6.3 (thanks for that). If you still need to enable basic authentication, see [KB 77271](https://kb.vmware.com/s/article/77271).

![](image-20220502133138518.png)

#### AGENT MANAGEMENT PROBLEMS ####

That infamous Cloud proxy thingie:  After you upgrade vRealize Operations from 8.4 to a *anything*, content upgrade + agent management will fail - Yikes... I have had a personal problem with this, where I was unable to install Telegraf agents onto any Operative System, including all Ubuntu versions, CentOS, Windows 2019&2022 and more.  This is the Important Workaround:

1. SSH to the Cloud Proxy (or all your cloud proxies).
2. Run : *`/rpm-content/ucp/subsequentboot.sh`*



> Just do it even if you don't need to, trust me!  

#### LINKS

- [ ] Release Notes:  https://docs.vmware.com/en/vRealize-Operations/8.6.3/rn/vrealize-operations-863-release-notes/index.html
- [ ] vRealize Operations 8.6.3 Download Landing Page: https://customerconnect.vmware.com/downloads/info/slug/infrastructure_operations_management/vmware_vrealize_operations/8_6





... until next .. 



