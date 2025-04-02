@echo off
setlocal enabledelayedexpansion

:: GET textconv.exe
set "texconv=%~dp0texconv.exe"

::Inputfolder
set "inpFolder=%~dp0PUT_IMAGES_IN_THIS_FOLDER"
set "outputFolder=%~dp0CONVERTED_DDS_FILES"
::%~dp0 - the path of the batch file

if not exist "%outputFolder%" (
	md "%outputFolder%"
)
if not exist "%inpFolder%" (
	md "%inpFolder%"
)

::format C = Color N = Normal M = Materials
set "FORMAT_C=BC7_UNORM_SRGB"
set "FORMAT_N=BC5_UNORM"
set "FORMAT_M=BC7_UNORM"

set "currentFileFormat=%FORMAT_M%"

set /a count=0

for %%f in ("%inpFolder%\*.png") do (

    set "fileName=%%~nf"
    set "fileExt=%%~xf"

    if "!fileExt!"==".png" (
        echo !fileName! | findstr /i "_c" >nul
		::if !errorlevel = 0 the string from findstr exists in the filename variable
        if !errorlevel! == 0 (
            set "currentFileFormat=%FORMAT_C%"
        ) else (
            echo !fileName! | findstr /i "_n" >nul
            if !errorlevel! == 0 (
                set "currentFileFormat=%FORMAT_N%"
            ) else (
				echo !fileName! | findstr /i "_m" >nul
				if !errorlevel! == 0 (
					set "currentFileFormat=%FORMAT_M%"
				) else (
					set "currentFileFormat=%FORMAT_C%"
				)
        )
	)
	)
        set /a count+=1
        "%texconv%" -pow2 -y -f !currentFileFormat! -o "%outputFolder%" "%%f" -pmalpha
    )
)

::y = overwrite pow2 ---- = force power of 2

echo ------------------------------
echo converted %count% files to DDS
echo ------------------------------
endlocal
pause