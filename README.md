# Conversion from GFM markdown to PDF, for ISC labs
This toolchain uses [pandoc](https://pandoc.org/) for writing labs in Markdown (in its gfm flavour) for the [ISC curricula](https://isc.hevs.ch). 

The heavy lifting for converting `markdown` to `pdf` is made using `pandoc` with a LaTex template based [on the Wandmalfarbe](https://github.com/Wandmalfarbe/pandoc-latex-template) solution. 

The conversion is rather fast and can be made in batch. The advantage of this solution resides in 
- writing Markdown is much faster and easier than plain Tex
- its speed for converting `md` to `pdf`
- the fact that variables can be defined at the beginning of the `md` module file using YAML. The variables are then passed to Latex and can be used in the template for further processing.
- the output is PDF, with the (not yet implemented) possibility to create the corresponding HTML output.

## Repository content
This repository contains a set of script files (in `build_tool`), the corresponding LaTex template for the lab as well as some examples (in the `samples` directory).

## Installing
The toolchain has been tested on Debian based distros (Ubuntu on WSL2, native Debian) and on MacOS. It has some dependencies on native tools as explained below.

### General Linux dependencies (for Debian based distros)
Quick install (but not minimal):
```
apt install parallel rename libsrvg2-bin
apt install texlive-full
```

### Installing Pandoc 
Please install `pandoc` latest version from here `https://github.com/jgm/pandoc/releases/tag/3.1.2` or newer, following the instructions. Please do not use `apt` for installing `pandoc` as the packages are largely outdated (at least for older Ubuntu distributions).

## Compiling a lab with the toolchain
Clone this repository somewhere in your filesystem. Let's consider that the toolchain is installed in `~/build_tool/`. 

In order to build the PDF from the `lab01.md` file, run from the location the `md` you want to compile is located :

```bash
~/build_tool/build_pandoc.sh -n lab-expressions.md
```

If no file is specified, the first `md` file is compiled 

```
~/build_tool/build_pandoc.sh
```

### Continuous compilation
It is also possible to run compilation every time the source file is changed by using the `build_continuous.sh` script.

# Questions and help
If you need any help for installing or running this tool, do not hesitate to get in touch with its maintainer. You can of course also propose changes using PR or raise issues if something is not clear. Have fun teaching !