---
author: "Bengt Grønås"
title: "Maximize Efficiency: Power-Saving Techniques in vSphere + Operations Dashboards"

date: 2023-11-21T14:24:39+02:00 # Date of post creation.

description: "Join Bengt Grønås in an insightful exploration of server power-saving techniques within a vSphere environment, with a special focus on Dell servers. This detailed guide covers effective strategies from BIOS settings to iDRAC configurations, and dives into the utilization of Aria Operations vROps dashboards for enhanced energy efficiency. Discover how to harmonize performance and sustainability in your IT infrastructure, leveraging Dell's BIOS, iDRAC, and vSphere's power management suite. Perfect for tech enthusiasts and professionals seeking to optimize their server performance while embracing sustainability."

keywords: "vSphere, Power Saving, Dell Servers, iDRAC, Aria Operations, vROps Dashboard, Energy Efficiency, Server Management, IT Infrastructure, Virtualization, BIOS Settings"

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
  - Sustainability
tags:
  - vSphere
  - Sustainability
  - Dell Servers
  - iDRAC
  - Aria Operations
  - vROps Dashboard

comment: false # Disable comment if false.
---
# Better & faster vs. Save power!
<img src="./assets/1578728-200.png" align=right style="zoom:80%;" />The technological wonders we've created have undoubtedly made our lives more connected, better and faster. Our dependency on IT infrastructures has grown, and so has also the ***demand for power***.  But with a  passion for sustainability, let’s talk about the server power-saving techniques, particularly in a vSphere environment. 

In my previous article I talked about the vSphere feature **DPM**, or Distributed Power Management, to power off hosts dynamically when the demand is low. [Go and have a look.](https://bengt.no/post/2023-09-08/)   This article complements the VMware Explore session where my buddy [Valentin Bondzio](<vbondzio@vmware.com> ) explained his "no Risk HPM" methodology. Note: It starts at 27:52 in the session [Orange journey to reduce their carbon emissions & Focus on HPM](https://www.vmware.com/explore/video-library/video-landing.html?sessionid=1683885521040001LU2d&videoId=6340794321112) - Head over to his Blog [No Risk Host Power Management](https://valentin.bondz.io/no-risk-host-power-management/). 

In this article we’ll try to deep dive a bit into Efficiency. From Dell's BIOS up to vSphere’s cluster settings, every tweak plays a part. Let’s have a look at the BIOS settings, iDRAC, and a little quick trip to vSphere's power management suite. 

**Unlocking Power Savings: ** Since my tiny home lab consists of 2x Dell PowerEdge R720 with Integrated Dell Remote Access Controller (iDRAC) to enable advanced remote management capabilities using vSphere, that’s what I will be covering here. 



# Dell BIOS

<img src="./assets/image-20231003155443475.png" style="float:left;margin:1px 25px 1px 1px;border:2px solid black"  />

The nerve center of your server, where energy efficiency begins. When the Server boots up, use the F2/DEL trick and enter the Dell BIOS and change the System Profile settings from what’s default, to either Custom or Performance-per-watt (OS), otherwise known as “OS Control”.<p><p><p><p><p><p><p><p><p><p> 
## System performance profiles
![](./assets/image-20231003150810563.png) Here is an overview of the available performance profiles that are available for us to select and enable in the BIOS. 

## Selected System Profile
We’ve selected **Custom** just to make sure we have unlocked any sustainability possibility, but I’m quite sure the OS Control/OS DBPM is more than sufficeint. *Note:* this option by itself has no defaults for the options. The default state of all of the options is based on the last System Profile selected. So, First select the “*Performance-per-watt (OS)*”, and then go for *Custom*… *or not..*

## Power Management BIOS Settings  {#bios}
![](./assets/image-20231003145349458.png) In order to allow ESXi to control CPU power-saving features, set power management in the BIOS to “**OS Controlled Mode**” or equivalent. Even if you don’t intend to use these power-saving features.  In this configuration, Turn ON Turbo Boost too (not shown). The Memory Frequency could also be left as-is, but we’ve also changed that.

**C-states:** In order to get the best performance per watt, you should activate all C-states in BIOS. This gives
you the flexibility to use vSphere host power management to control their use. C-states can reduce performance. In these cases you might obtain better performance by disabling them in the BIOS.

**C1E** is a hardware-managed state; when ESXi puts the CPU into the C1 state, the CPU hardware can determine, based on its own criteria, to deepen the state to C1E. Availability of the C1E halt state typically provides a reduction in power consumption with little or no impact on performance.

> **Storage Latency Sensitive Workloads.** For a very few multithreaded workloads that are highly sensitive to I/O latency, such as financial platforms or media and entertainment, C-states (including C1E) can reduce performance. In these cases you might obtain better performance by deactivating them in the BIOS. Deactivate C1E and other C-states ==  increase power consumption.

## Recommended BIOS settings
![](./assets/image-20231003150624862.png)
I was about to change the Memory Frequency, but didn’t, in hope to maximize Power Savings and most performance pr. Watt. 

## DELL iDRAC Essentials
`Access and Log in to the iDRAC Web Interface, Navigate to the IPMI Settings, Enable IPMI Over LAN, Apply/Save Changes.` 
![](./assets/image-20231003145545024.png)Distributed Power Management (DPM) typically use IPMI for out-of-band management. This allows VMware DPM to power on or off the server when necessary to save power. 

## iDRAC Network IP and MAC ADDRESS  {#idrac}
You will need this when you are later going to configure the vSphere IPMI/iLO Settings for Power Management, meaning the actual handshake between Hardware and Software. Make a note of both the MAC and IP [for later use](#ip_mac). 

<img src="./assets/image-20231003150108264.png" style="border:1px solid black"/>   <img src="./assets/image-20231003150202705.png" style="border:1px solid black" /> 

<img src="./assets/image-20231003160839843.png" align="right" style="zoom:25%;" />Now that we’ve done the BIOS and iDRAC (ILO) settings, it’s about time to enter vCenter and do the rest of the configuration in vSphere.  Follow **Dell** *BIOS Performance and Power Tuning Guidelines* for Dell PowerEdge 12th Generation Servers for *Configuring the servers BIOS for optimal performance and power efficiency*. 

## vSphere Power Management Essentials

We can focus on energy efficiency by prioritizing power conservation while maintaining performance with certain vSphere settings:

| **Feature**                   | **Role in Power Saving**                                     |
| ----------------------------- | ------------------------------------------------------------ |
| **System Profile Settings**   | Harmonizes performance and energy efficiency.                |
| **IPMI/iLO Power Management** | Vital for integrating hardware and software power settings.  |
| **Configuration**             | Navigate to 'Host Options' for tailored power management strategies. |
| **vSphere Cluster Dynamics**  | Adjust 'DRS Automation' levels from 'Conservative' to 'Aggressive' for optimal power use. |
| **Balance vs. Conservation**  | Choose between 'Balanced' and 'Low Power' modes in 'Host Power Management' to prioritize energy saving. |

## IPMI (Intelligent Platform Management Interface) or iLO (Integrated Lights-Out) 
IPMI/iLO is a feature of the server hardware. After configuring IPMI/iLO in the BIOS/firmware, we leverage these settings in vSphere for remote server management tasks, including power management. In vSphere we use features like Power Management policies that can interact with IPMI/iLO. To access the IPMI/iLO Settings for Power Management settings in in vSphere click the `host>configure>system>Power Management.` 

![](./assets/image-20231120180554119-1700499958766-5.png)

Click **Edit** to set the connection details for our Dell server. 

## IPMI/ILO Settings for power management{#ip_mac} 

![](./assets/image-20231120180802926-1700500089163-7.png) 
Put in the iDRAC IP and MAC [from above](#idrac) and click OK. 

## Host Power Management Policies in ESXi
| **ESXi Host Power Management Policies** | **Description**                                  |
| :-------------------------------------- | ------------------------------------------------ |
| Static / High Performance               | Maximizes performance, minimal energy savings.   |
| Dynamic / Balanced                      | Balances performance and power consumption.      |
| Low Power                               | Prioritizes energy savings, reduces performance. |
| Custom                                  | User-defined settings for specific needs.        |

Availability of these policies depends on host hardware support for power management as mentioned and described above.  ESXi aims to minimize energy consumption with minimal performance impact. 

Click `Configure>Hardware>Overview and scroll to the bottom`: 
![](./assets/image-20231120181500005.png)

Notice, we have got a “Low Power” setting here. Let’s change it to “Balanced”,  Click **EDIT POWER POLICY**

![](./assets/image-20231120181545799.png) 
Set our power policy settings according to everything else we’ve [set in the BIOS above](#bios). 


# Aria Operations 
### Host Monitoring. Operations Dashboard {#dash}

We'll use an Operations tool for efficient monitoring of key host parameters, avoiding extensive checks in vCenter/vSphere Client. Essential parameters include:

> BIOS version and date, BIOS power-saving settings, P and C states. vSphere power policy. ESXi version. Serial number, and hyperthreading.
>

Creating this dashboard is easy and straightforward. We'll build a view with all necessary data. But very first, let’s review our policies to ensure we're capturing all essential host metrics, such as power, BIOS version, etc.

### Metrics and Properties collection

In Aria Operations, Let’s go to `Configure>Policies>Policy Definition` and *edit* our policy.

![](./assets/image-20231121102655159.png) 

Object type is ‘**Host System**’ and we’ll filter on ‘**bios**’. As we can see the *“BIOS Release date”* is inherited and Deactivated. Let’s **activate** it from the Drop Down menu, and click **Save**. 

### View

Let’s go to `Visualize>Views>Manage`, and search for “Properties”, find the view called “**Host Key Properties**”. that looks pretty similar to what we want.  Tip: Learn from the content.

![](./assets/image-20231121153024950.png) 

- Let’s just create a new one from scratch, go back to *Manage* and Click **Add**, then select **List** 


![](./assets/image-20231121204823954-1700596106222-11.png) 

- Click **Next** (not shown)


![](./assets/image-20231121212423767.png) 

In the next tab we will just add everything we’ve listed [above](#dash)

- Start by Add Subject: **Host System**
- In the search field, type **bios**, **release**, **power**, **hyperthread** etc. and add everything we need, make it look closely to the image above. 
- Next **rename** the columns, make sense with our naming;

![](./assets/image-20231121213130395.png) 

#### View result {#view} 

- Click **CREATE**. The end result should look something like this: 


<img src="./assets/image-20231121213321916.png" style="border:1px solid black" /> 

### Dashboard

- Go to `Visualize>Dashboards>Manage` and click **Add**


<img src="./assets/image-20231121213732929.png" style="border:1px solid black" />

<img src="./assets/image-20231121214631215.png" style="border:1px solid black" /> 

- Name your dashboard, for example: “*ESXi Servers and properties”*
- You will be a **self provider** = on

<img src="./assets/image-20231121214803884.png" style="border:1px solid black" /> 

- All objects and Object = **vSphere World**

<img src="./assets/image-20231121213926147.png" style="border:1px solid black" />

- Expand Output data, and select the previous created [view](#view) and click **SAVE**

<img src="./assets/image-20231121215252874.png" style="border:1px solid black"/> 

- Add a Pie widget and edit it


<img src="./assets/image-20231121215706048.png" style="border:1px solid black"/>   

- Name it
- Select **Inventory | VM Power State**
- Click **Save**
- Click **Show Interactions**

<img src="./assets/image-20231121220055356.png" style="border:1px solid black"/> 

- Add the interaction 
- Click **SAVE**

### The End result

![](./assets/image-20231121220904974.png) 





### LINKS

- [Host Power Management Policies in ESXi](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-resource-management/GUID-4D1A6F4A-8C99-47C1-A8E6-EF3865603F5B.html)
- [Managing Power Resources](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-resource-management/GUID-5E5E349A-4644-4C9C-B434-1C0243EBDC80.html)
- "[No Risk Host Power Management](https://via.vmw.com/no-risk-hpm)"
  

until next time..
