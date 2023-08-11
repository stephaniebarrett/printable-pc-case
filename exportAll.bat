@echo off
cls
SETLOCAL EnableDelayedExpansion
FOR /l %%G IN (1,1,6) DO (
	set filename=rack%%G.stl
	start /B openscad -o !filename! -D DRAW_RACK=%%G main.scad
)
FOR /l %%G IN (1,1,3) DO (
	set filename=joinery%%G.stl
	start /B openscad -o !filename! -D DRAW_JOINERY=%%G main.scad
)
FOR /l %%G IN (1,1,4) DO (
	set filename=hddcage%%G.stl
	start /B openscad -o !filename! -D DRAW_HDD_CAGE=%%G main.scad
)
