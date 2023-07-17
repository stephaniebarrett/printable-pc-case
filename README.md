# 3D Printable Rackmount PC/Server Case using OpenScad.
## WIP
Currently, creating various [OpenScad](https://openscad.org/) modules to facilitate the design of a modular rackmountable chassis.

Inspired by https://www.printables.com/model/485778-mini-itx-server-rackmount-2u

Requires the following OpenScad libraries, already included:
- [Alpha](https://github.com/thestumbler/alpha) for text rendering.
- [Honeycomb](https://www.printables.com/model/263718-honeycomb-library-openscad) for generating honeycombs.
- [nutsnbolts](https://github.com/JohK/nutsnbolts) for fasteners.

## Modules
Most of these modules approximate the physical dimensions of various PC components. These are used to estimate positions and clearances of all the parts.
### mainboard.scad
- ATX and Micro ATX
### psu.scad
- ATX
### hdd.scad
- 3.5"
### fan.scad
- 80mm and 120mm
### rack.scad
- 19"
