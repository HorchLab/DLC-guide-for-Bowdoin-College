---
layout: default
title: "A hopefully comprehensive guide to DeepLabCut"
nav_order: 1
has_children: true
---

# DeepLabCut Guides

Hi guys, this is a collection of guides to help you use DeepLabCut effectively. I'll walk through what each guides is about, and how it can help you.

- [Getting Started 2024](Getting-started-2024.md): This guide is designed for new users of DeepLabCut. I recommend you start here: this guide covers the basics of setting up DeepLabCut.
- [Getting Started DLC](Getting-started-DLC.md): This guide is based on Ean's old guide, and it is a step-by-step guide to using DeepLabCut for a project. It covers the entire process from creating a project to analyzing videos in details. I recommend following this guide when you're starting a new project. Note that you should always have DeepLabCut's offical documentation open in another tab, as it is the most up-to-date and comprehensive resource.
- [R-pipeline](R-pipeline.md): This guide is made for the old R pipeline that Ean used (and I used during summer 2023). I don't imagine this will be useful for most people, but it is here for reference.
- [Troubleshooting](Troubleshooting.md): This guide is (aimed to be) a collection of common issues and their solutions. If you run into problems, try add them here so that future users can find the solutions easily.
- [Use-DLC-2024](Use-DLC-2024.md): This guide is a half finished attempt from me to recreate the step by step guide. The differences between this one and [Getting Started DLC](Getting-started-DLC.md) is that this one is more focused on the tips and tricks that I learned while using DeepLabCut rather than what you need to do. If I were to summarize the differences, this guide is more about "What you should do" and the other one is more about "How to do it". I recommend you read both guides, as they complement each other well. (Hopefully one of you would finish this guide)

## Some interesting papers to look at if you want to do more on the analysis part

- The original DLC paper: [Mathis et al. 2018](https://www.nature.com/articles/s41593-018-0209-y)
- The 3D DLC paper, very interesting if you want to add a second camera: [Mathis et al. 2019](https://www.nature.com/articles/s41596-019-0176-0)
- SLEAP is an alternative to DLC, and (they claim) that it performs better on arthropods compares to DLC: [Pereira et al. 2022](hhttps://www.nature.com/articles/s41592-022-01426-1)[^1]
- KeyPoint-MoSeq is a method proposed by the DLC team and a bunch of other teams about unsupervised behavior classification. This is basically a (more) successful attempt of what I was trying to do with autoencoder+unsupervised clustering. [Weinreb et al. 2024](https://www.nature.com/articles/s41592-024-02318-2)

## People to seek help from

Trust me, you will run into problems and you will need to cry for help.

- Hadley, of course.
- Jack for everything analysis related.
- Dj Merrill for everything related to running jobs on HPC.
- Professor Jeova Farias from CS if you want to know more about how DeepLabCut works under the hood.
- If the lab computer/the recording computer run into issues with installing software, call IT but specifically look for Sam Tarr. He is in charge of classroom computers which our lab uses.
- If you're looking to make new changes to the hardware, academic technology is the place to go. Specifically David Israel (at Maker Space) if you want to make new stuff, or Colin Kelley if you want to add a camera or AV related hardware.
- Me (Tom) I guess... If it does not fall into any of the above categories, you can ask me. I might not know the answer, but I can point you to the right direction.

Tom Han 2025.5.30

[^1]: The most obvious difference is that SLEAP default to something called U-Net instead of ResNet, which is the default for DLC. U-Net is faster.
