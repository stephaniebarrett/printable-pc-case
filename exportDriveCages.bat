@echo off
SETLOCAL EnableDelayedExpansion

FOR /l %%G IN (1,1,4) DO (
	set filename=hddcage%%G.stl
	start /B openscad -o !filename! -D DRAW_HDD_CAGE=%%G main.scad
)
