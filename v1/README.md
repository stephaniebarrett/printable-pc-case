# 3D Printable Rackmount PC/Server Case using [OpenSCAD](https://openscad.org/).
## WIP
The goal of this project originally was to create OpenSCAD modules of PC components to facilitate the design of a modular rack-mountable computer chassis. But once that was complete, I began designing a chassis and somewhere to store it; so for now, here we are. 2.5 versions in and I still feel like this is very much a work in progress. As I complete test prints, and have new ideas, I will continue to iterate on the case design.

## Notes
### V1
While doing a full test print/fit, there were several issues with warping (especially the corner pieces) and cracking when transitioning from printing floor + walls to just the walls. However, they didn't seem to affect the build at all. The rear wall was the most fragile with fan/io/psu cutouts and some chunkier pieces to bolt sections together; I had one of those chunky pieces break off, and some issues with support material not cooperating while printing. The honeycomb fill needs some work, while nocking out its support material, most of the honeycomb broke off on 2 of the 3 fan openings.  The 3U test case is currently mounted in my rack with x4 Rack Studs in the center of the first and third 'U's. It has been extremely stable, however I still have concerns about the PSU somewhat unsupported at the rear of the case.

#### Exporting (batch file)
```
export.bat [options] main.scad
Allowed options:
	-t arg		Specifies the type of file to export: stl, png (may be used multiple times)
	-m arg		Specifies the type of model to export: cage, joinery, rack (may be used multiple times)
	-h arg		0 will remove the honeycomb fill, 1 will keep it.
```

![Chassis Test Fit](testfit.jpg "V1 Test Fit")
