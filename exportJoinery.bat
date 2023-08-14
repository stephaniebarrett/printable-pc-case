@echo off
SETLOCAL EnableDelayedExpansion

IF NOT exist "export\" mkdir export

FOR /l %%G IN (1,1,3) DO (
	set filename=export\joinery%%G.stl
	echo. && echo !filename!
	call openscad -o !filename! -D DRAW_JOINERY=%%G main.scad
)

echo "Joinery Complete"