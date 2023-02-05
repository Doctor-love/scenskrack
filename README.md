<!--
SPDX-FileCopyrightText: 2023 Joel Rangsmo <joel@rangsmo.se>
SPDX-License-Identifier: CC0-1.0
-->

# scenskrack

## Introduction
**TL;DR: Toolbox for creating version controlled presentations.**  
  
In the past, I've used tools such as [LibreOffice](https://www.libreoffice.org/discover/impress/),
[reveal.js](https://revealjs.com/) and [asciinema](https://asciinema.org/) to create presentations
for courses and conferences. These pieces of software are great, but neither fully fit my
development and presentation process.  
  
The scenskrack toolbox enables users (see "myself") to:
* Create and collaborate on presentations using plain text files and a VCS
* Draw and version control diagrams/graphics
* Perform presentations without relying on an Internet connection/conference WiFi
* Bundle arbitrary files, such as lab exercises or example code, as attachments in PDF file
* Generate QR codes and other neat things that adds sparkles to presentations
  
It can't be considered mature in any sort of way, but it serves my personal needs at the moment.  
  
If you're curious to check out a rendered version of an example presentation, take a look at
["The little init system that could"](https://talks.radartatska.se/tlistc).


## Components  
scenscrack currently consists of a bash script that wraps the following hodgepodge of FOSS:
* **[marp-cli](https://marp.app):** Generates/exports presentations from Markdown to HTML and PDF  
* **[drawio-desktop](https://github.com/jgraph/drawio-desktop):** Offline version of diagrams.net
* **[qrencode](https://fukuchi.org/works/qrencode/):** Utility to generate QR codes
* **[poppler](https://poppler.freedesktop.org/):** Tool to merge and attach files to PDFs


## Installation and setup
As scenskrack requires quite a bit of somewhat messy dependencies, I run the toolbox in a
Docker/OCI container. As no images are yet published, you need to build it yourself:

```
$ docker build -t scenskrack:latest .
```

In order to save your fingers and brain from unnecessary typing, add the "scenskrack" alias to your
shell configuration file:

```
$ cat docker_alias.sh >> ~/.bashrc
```
  
In order to ensure that everything has been setup correctly, you can try rendering one of the
example presentations included in this repository:

```
$ cd example_presentations/full && scenskrack
2023-02-05T21:44:26+00:00: INFO: Substituting variables specified in file "/input/variables"
2023-02-05T21:44:26+00:00: INFO: Generating QR codes from "/tmp/tmp.DLF2jzmNi9_scenskrack/qr_codes"
[...]
2023-02-05T21:44:32+00:00: INFO: Successfully completed rendering/packaging after 6 seconds

$ ls output/
01-first.html  02-second.html  diagrams  index.html  presentation.zip  resources
01-first.pdf   02-second.pdf   images    index.pdf   qr_codes          resources.zip
```
  
**If you for whatever reason don't want to run scenskrack in a container, checkout the "Dockerfile"
in this repository for required packages/inspiration.**


## Usage
If you just want to get an idea how to wield the toolbox, see the "example\_presentations"
directory in this repository. You can also check out
["doctor-love/public\_presentations"](https://github.com/doctor-love/public_presentations) and
["menacit/virt\_base\_course"](https://github.com/menacit/virt_base_course) for some real usage.  

  
### Directory structure
The beautiful tree graph below shows an overview of an example source directory for scenskrack:

```
|-- "01-first.md"
|-- "02-second.md"
|-- "diagrams"
|   `-- "example_diagram.drawio"
|-- "_excluded"
|   `-- "example.txt"
|-- "_excluded.md"
|-- "images"
|   `-- "example_image.jpg"
|-- "qr_codes"
|   `-- "presentation_website.link"
|-- "README.md
|-- "resources
|   `-- "example_code.py"
`-- "variables"
```

The following sections describes these files and directories.


#### Markdown files
All files with ".md" as their suffix (except the excluded ones listed below) are treated as 
(Marp]((https://marp.app) slide decks. If no file called "index.md" exist in the source directory,
scenskrack will merge slide decks (in alphanumeric order) into "index.html" and "index.pdf". If you
only want to use one slide deck for your presentation, name the source file "index.md".


#### Diagrams directory
Project files for diagrams/illustrations created with the tool [diagrams.net](https://diagrams.net)
("\*.drawio") stored in this directory gets rendered as SVGs. If diagrams are used in slide decks,
make sure to add the ".svg" suffix to the file name.


#### Excluded files
Not all files/directories stored in the source directory are included in the resulting output:
- The common file \"README.md\"
- Hidden files with the period prefix
- Files with the underscore prefix
- The "output" directory, if a child of the source directory


#### QR codes
scenskrack uses the "qrencode" utility to convert text files containing URLs/URIs in the
"qr\_codes" directory to SVGs. If generated QR codes are used in slide decks, make sure to add the
".svg" suffix to the file name.


#### Resource directory
Files stored in the "resources" source directory are bundled in an output ZIP archive that is also
injected into "index.pdf" as a PDF attachment. Useful for thing such as lab exercises and example
source code related to the presentation(s).


#### Variable file
The "variables" file is a newline separated key-value list for string substitution in source files.
A row containing "WEBSITE=example.com" will result in all occurrences of "%WEBSITE%" being replaced
with "example.com"


### Presentation formatting
Slide decks are created using Markdown files that are processed and rendered by Marp.  
  
For general advice regarding creation and styling of Marp presentations, currently the
[Marpit Markdown documentation](https://marpit.marp.app/markdown) seems to be the best place.
