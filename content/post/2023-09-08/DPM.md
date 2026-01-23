---
author: "Bengt Grønås"
title: "Sustainability Action for Datacenters: DPM" # A succinct title grabs attention.

date: 2023-09-08T10:19:28+02:00 # The date seems fine.

# A more concise description that still conveys the core message.
description: "Optimize datacenters for sustainability: Using "

featured: false # If the post is vital, consider making it featured.
draft: false # If you're ready for publication, keep this as 'false'.
toc: false # If your post is long and covers many topics, consider enabling the TOC for better navigation.

usePageBundles: true # This helps group assets with your post.
featureImage: "line.jpg" # Ensure the image is relevant and of high resolution.
thumbnail: "thumbnail.jpg" # Make sure it represents the blog's essence.

shareImage: "logo.png" # An image that's appealing for social media shares can increase visibility.

codeMaxLines: 10 # Adjust based on the average length of your code snippets.
codeLineNumbers: false # If your code snippets benefit from line numbers, enable this.
figurePositionShow: false # If you have figures, consider enabling for clarity.

categories:
  - Technology # Keep categories broad but relevant.
tags:
  - Aria
  - Automation
  - Orchestrator
  - Sustainability # Tags should be relevant keywords related to the post.

comment: false # If you wish to engage with your readers, consider enabling comments.
---

# vSphere Distributed Power Management 

The vSphere Distributed Power Management (DPM) feature optimizes power usage in virtualized data centers by dynamically adjusting server power states based on workload demand, saving energy and costs while maintaining high availability.  <img src="./assets/image-20230927223512345.png" alt="Power Policy Settings" style="float:right;margin:1px 2px;border:1px solid black"/>Its excellence lies in its ability to optimize power consumption and dynamically adjusts the power state of servers based on workload demand. Unused servers are powered off or placed in a low-power state.  This reduces energy costs, and contributes to environmental sustainability. So, have you tried to give DPM a second chance?  If not, please consider it, I mean for every kilowatt consumed by servers you would need cooling!



**Servers**, even when idle, consume power, which is a significant cost factor in data centers. By powering off servers

