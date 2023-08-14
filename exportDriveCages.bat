@echo off
SETLOCAL EnableDelayedExpansion

IF NOT exist "export\" mkdir export

FOR /l %%G IN (1,1,5) DO (
	set filename=export\hddcage%%G.stl
	echo. && echo !filename!
	call openscad -o !filename! -D DRAW_HDD_CAGE=%%G main.scad
)

echo "Drive Cages Complete"
