@echo off
setlocal enabledelayedexpansion

if not "%~1"=="" goto :switches

:usage
echo.
echo Usage: %~nx0 [options] input.scad
echo Allowed options:
echo  -t arg		Specifies the type of file to export: stl, png (may be used multiple times)
echo  -m arg		Specifies the type of model to export: cage, joinery, rack (may be used multiple times)
echo  -h			Specifies the use of honeycomb fill for the fan grills (default is 0)
echo.
goto :EOF

:switches
rem make sure variables are undefined
for %%I in (png stl cage joinery rack input switch valid options hexfill) do set "%%I="

set "hexfill=0"

rem loop through all arguments
for %%I in (%*) do (
	rem if this iteration is a value for the preceding switch
	if defined switch (
		rem if that switch was -L or /L (case-insensitive)
		if /i "!switch:~1!"=="T" (
			 if /i "%%~I"=="png" set png=true
			 if /i "%%~I"=="stl" set stl=true
		) else if /i "!switch:~1!"=="M" (
			if /i "%%~I"=="cage" set cage=true
			if /i "%%~I"=="joinery" set joinery=true
			if /i "%%~I"=="rack" set rack=true
		) else if /i "!switch:~1!"=="H"  (
			set hexfill=%%I
		)

		rem clear switch variable
		set "switch="
	) else (
		rem if this iteration is a switch
		echo(%%~I | >NUL findstr "^[-/]" && (

			set "switch=%%~I"

			rem if this is a valid switch
            for %%x in (T M H) do (
                if /i "!switch:~1!"=="%%x" set "valid=true"
            )

            if not defined valid (
                echo Unrecognized switch: %%~I
                goto usage
            )

            set "valid="
        ) || (
	        rem // not a switch. Must be an input file
	        set "input=%%~I"
    	)
	)
)

if not defined input goto usage

if not exist "export\" mkdir export

set pngPath=export\png
if defined png if not exist %pngPath% mkdir %pngPath%

set stlPath=export\stl
if defined stl if not exist %stlPath% mkdir %stlPath%

set "options="
if defined cage (
	FOR /l %%G IN (1,1,5) DO (
		if defined png set options=-o %pngPath%\hddcage%%G.png
		if defined stl set options=!options! -o %stlPath%\hddcage%%G.stl
		call openscad !options! -D DRAW_HDD_CAGE=%%G %input%
	)
)

set "options="
if defined joinery (
	FOR /l %%G IN (1,1,3) DO (
		if defined png set options=-o %pngPath%\joinery%%G.png
		if defined stl set options=!options! -o %stlPath%\joinery%%G.stl
		call openscad !options! -D DRAW_JOINERY=%%G %input%
	)
)

set "options="
if defined rack (
	FOR /l %%I IN (1,1,2) DO (
		if not exist %pngPath%\config%%I mkdir %pngPath%\config%%I
		if not exist %stlPath%\config%%I mkdir %stlPath%\config%%I
		FOR /l %%G IN (1,1,6) DO (
			if defined png set options=-o %pngPath%\config%%I\rack%%G.png
			if defined stl set options=!options! -o %stlPath%\config%%I\rack%%G.stl
			call openscad !options! -D DRAW_RACK=%%G -D CASE_CONFIGURATION=%%I -D USE_HEX_FILL=!hexfill! %input%
		)
	)
)
