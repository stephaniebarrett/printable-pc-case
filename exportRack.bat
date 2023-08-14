@echo off
SETLOCAL EnableDelayedExpansion

IF NOT exist "export\" mkdir export

FOR /l %%I IN (1,1,2) DO (
	IF NOT exist "export\config%%I\" mkdir export\config%%I
	FOR /l %%G IN (1,1,6) DO (
		set filename=export\config%%I\rack%%G.stl
		echo. && echo !filename!
		call openscad -o !filename! -D DRAW_RACK=%%G -D CASE_CONFIGURATION=%%I main.scad
	)
)

echo "Rack Complete"