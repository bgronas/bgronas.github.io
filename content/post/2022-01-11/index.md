---
title: "Mixing VRealize Operations Licenses" # Title of the blog post.
date: 2022-01-11T01:29:03+01:00 # Date of post creation.
description: "Mixing VRealize Operations License" # Description used for search engine.
featured: false # Sets if post is a featured post, making appear on the home page side bar.
toc: false # Controls if a table of contents should be generated for first-level links automatically.
# menu: main
usePageBundles: true
featureImage: "vrops.jpg" # Sets featured image on blog post.
# featureImageAlt: 'just me' # Alternative text for featured image.
# featureImageCap: 'This is the featured image.' # Caption (optional).
thumbnail: "vRealize-Operations-Logo-1024x618.png" # Sets thumbnail image appearing inside card on homepage.
shareImage: "icon.png" # Designate a separate image for social media sharing.
codeMaxLines: 10 # Override global value for how many lines within a code block before auto-collapsing.
codeLineNumbers: false # Override global value for showing of line numbers within code block.
figurePositionShow: true # Override global value for showing the figure label.
categories:
  - Work
tags:
  - vRealize 
  - vROps
comment: false # Disable comment if false.
---

# Mixing vRealize Operations Licenses isn't easy. Let's try to define what's possible. 

# Mixing vRealize Suite / vRealize Operations Licenses.

  * The vRealize Suite STD will give you vROps ADV
  * With both suites (adv/std) you will end up with vROps Adv. 
  * You can mix vROps ADV and vROps ENT editions/licenses. 
  * You can't mix vROps STD with vROps ADV or vROps Ent.
  * vRealize Suite Per-CPU and per OSI can be mixed
  * vRealize Operations ADV + vRealize Suite STD - This allowed but ONLY as separate license groups. *It doesn't work when you mix the keys in one group*
  * vRealize Suite ADV + vRealize Suite STD - will work too, 	as both with both suites you will end up with vROps Adv. *Separate license types into License Groups*

 Don't forget you have vRA in vRealize Suite ADV too, and mixing editions at vRA might not be permitted

Do you have questions about License groups – head over to my colleague *Brock Peterson *https://www.brockpeterson.com/post/vrops-license-groups

# Tip:
**If you change from single  product licensing to suite licensing, 
I’d suggest a little license cleanup job if  you f.ex. upgrade from ops adv to vrs std and such. 
You might want to consider is keeping the suite consistent (edition wise instead of mixing) 
especially for vRA level. vROps shouldn't be a problem
**

What is vRealize Suite? https://www.vmware.com/no/products/vrealize-suite-vcloud-suite.html