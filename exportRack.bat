@echo off
SETLOCAL EnableDelayedExpansion

FOR /l %%G IN (1,1,6) DO (
	set filename=rack%%G.stl
	start /B openscad -o !filename! -D DRAW_RACK=%%G main.scad
)
