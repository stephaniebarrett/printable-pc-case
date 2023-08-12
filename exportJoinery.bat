@echo off
SETLOCAL EnableDelayedExpansion

FOR /l %%G IN (1,1,3) DO (
	set filename=joinery%%G.stl
	start /B openscad -o !filename! -D DRAW_JOINERY=%%G main.scad
)