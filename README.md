<!--
SPDX-FileCopyrightText: 2022 Joel Rangsmo <joel@rangsmo.se>
SPDX-License-Identifier: GPL-2.0-or-later
-->

# scenskrack

## Introduction
TL;DR: Toolbox for creating version controlled presentations.  
  
In the past, I've used tools such as [LibreOffice Impress](https://asciinema.org/),
[reveal.js](https://revealjs.com/) and [asciinema](https://asciinema.org/) to create presentations
for courses and conferences. These pieces of software are great, but don't really fit my
development flow.  
  
The scenskrack toolbox enables users (see "myself") to:
* Create and collaborate on presentations using plain text files and a VCS
* Draw and version control diagrams/graphics
* Perform presentations without relying on an Internet connection/conference WiFi
* Bundle arbitrary files such as lab exercises and export presentation as PDF
* Generate QR codes and other neat things that adds sparkles to presentations
  
It can't be considered mature in any sort of way, but it serves my personal needs at the moment.


## Components  
scenscrack currently consists of a bash script that wraps the following hodgepodge of FOSS:
* **[marp-cli](https://marp.app):** Generates/exports presentations from Markdown to HTML and PDF  
* **[drawio-desktop](https://github.com/jgraph/drawio-desktop):** Offline version of draw.io
* **[qrencode](https://github.com/jgraph/drawio-desktop):** Utility to generate QR codes
* **[poppler](https://github.com/jgraph/drawio-desktop):** Tool to merge and attach files to PDFs


## Usage
For some ideas how to wield the toolbox, see the repository
["doctor-love/public_presentations"](https://github.com/doctor-love/public_presentations).  
  
For general advice regarding creation and styling of Marp presentations, currently the
[Marpit Markdown documentation](https://marpit.marp.app/markdown) seems to be the best place.
