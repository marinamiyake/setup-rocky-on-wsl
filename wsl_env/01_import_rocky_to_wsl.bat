chcp 65001
@echo off
setlocal

@REM ----- For your info -----
@REM About header:
@REM "echo off" is a setting to mute logs.
@REM "chcp 65001" is a setting to set Encode=UTF-8.
@REM "setlocal" is a setting to discard environment variables in this bat file after exit.

@REM bat writing rules:
@REM You cannot use round blackets in "if" blocks.
@REM Add a whitespace after non ASCII character at the end of line. Process might not work otherwise. 
@REM -------------------------

@REM ----- constants -----
set CURRENT_DIR=%~dp0
set WSL_SETUP_TOOL_NAME=wsl_env
set WORKDIR=%USERPROFILE%\%WSL_SETUP_TOOL_NAME%\

set VM_DIR=%WORKDIR%vm\
set SRC_DIR_NAME=src
set SRC_DIR=%WORKDIR%%SRC_DIR_NAME%\
set ROCKY_IMG_DIR=%SRC_DIR%rocky_image\

set INPUT_YES=Y
set INPUT_NO=N
@REM --------------------

@REM **************************************************
@REM STEP0. Check WSL setup directory
: CHECK_WSL_SETUP_DIR
if NOT %CURRENT_DIR% == %WORKDIR% (
    echo +----------------------------------------------------------------------------------------------------+
    echo [ERROR] Invalid work directory
    echo +----------------------------------------------------------------------------------------------------+
    echo Move WSL setup tool（%WSL_SETUP_TOOL_NAME%）to your home directory.
    echo   Wrong directory（current）: %CURRENT_DIR%
    echo   Correct directory（destination）: %WORKDIR%
    pause
    exit
)

echo **************************************************
echo STEP1_1. Set new Rocky environment name
: SET_ROCKY_ENV_NAME
echo Current environment list（You cannot use the same name）:
echo ================================================================================
wsl -l -v
echo ================================================================================

set ROCKY_ENV_NAME=
echo Type name for new Rocky environment.
echo Machine will be created to %VM_DIR%{rocky environment name}.
set /P ROCKY_ENV_NAME=[input] 

set ROCKY_MACHINE_PATH=%VM_DIR%%ROCKY_ENV_NAME%
if exist %ROCKY_MACHINE_PATH% (
    echo +----------------------------------------------------------------------------------------------------+
    echo [ERROR] Environment already exists
    echo +----------------------------------------------------------------------------------------------------+
    echo %ROCKY_MACHINE_PATH% already exists. Clean up old data first.
    goto SET_ROCKY_ENV_NAME
)

echo **************************************************
echo STEP1_2. Set Rocky image file for new Rocky environment
: SET_ROCKY_IMG_FILE
set ROCKY_IMG_NAME=
echo Choose rocky image name in the list for new Rocky environment. 
echo Rocky image files you can use:
echo ================================================================================
for /f %%f in ('dir "%ROCKY_IMG_DIR%\*.x86_64.tar.xz" /b') do (
  echo %%f
)
echo ================================================================================
set /P ROCKY_IMG_NAME=[input] 
set ROCKY_IMG_PATH=%ROCKY_IMG_DIR%%ROCKY_IMG_NAME%
if NOT exist %ROCKY_IMG_PATH% (
    echo +----------------------------------------------------------------------------------------------------+
    echo [ERROR] File not found
    echo +----------------------------------------------------------------------------------------------------+
    echo Could not access to "%ROCKY_IMG_PATH%" . 
    echo Download rocky image file from website and move the file to %ROCKY_IMG_DIR% before running this tool.
    goto SET_ROCKY_IMG_FILE
)

echo **************************************************
echo STEP1_3. Set username for new Rocky environment.
: SET_ROCKY_USER_NAME
set ROCKY_USER_NAME=
echo Type username（default regular user's name）for new Rocky environment.
set /P ROCKY_USER_NAME=[input] 

echo **************************************************
echo STEP1_4. Import Rocky to WSL
: SET_ROCKY_IMG_FILE
set CONFIRMATION_INPUT=
echo Import Rocky to WSL. To continue, type %INPUT_YES%.
echo   Environment name: %ROCKY_ENV_NAME%
echo   Machine path: %ROCKY_MACHINE_PATH%
echo   Rocky image file path: %ROCKY_IMG_PATH%
echo   Username: %ROCKY_USER_NAME%
set /P CONFIRMATION_INPUT=[input]

if NOT %CONFIRMATION_INPUT% == %INPUT_YES% (
    echo Cencel setup.
    pause
    exit
)
wsl --import %ROCKY_ENV_NAME% %ROCKY_MACHINE_PATH% %ROCKY_IMG_PATH% --version 2

echo **************************************************
echo Finish:
echo Rocky import finished. 
echo Run ./02_init_rocky.bat next.
echo **************************************************

endlocal
pause
exit
