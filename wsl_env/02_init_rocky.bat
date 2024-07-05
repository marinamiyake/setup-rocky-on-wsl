chcp 65001
@echo off
setlocal

@REM ----- constants -----
set WSL_SETUP_TOOL_NAME=wsl_env
set WORKDIR=%USERPROFILE%\%WSL_SETUP_TOOL_NAME%\

set VM_DIR=%WORKDIR%vm\
set SRC_DIR_NAME=src
set SRC_DIR=%WORKDIR%%SRC_DIR_NAME%\
set ROCKY_SETUP_SCRIPT_UNIX_DIR=./%SRC_DIR_NAME%/script/

set INPUT_YES=Y
set INPUT_NO=N
@REM --------------------

@REM **************************************************
@REM STEP0. Select Rocky environment to setup
: SET_ROCKY_ENV_NAME
echo Choose target rocky environment name in the list: 
echo ================================================================================
wsl -l -v
echo ================================================================================
set ROCKY_ENV_NAME=
set /P ROCKY_ENV_NAME=[input]

echo **************************************************
echo STEP2_1. Update Rocky packages (Setup by root user)
: UPDATE_ROCKY_PACKAGE
wsl -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%01_update_package.sh
wsl -t %ROCKY_ENV_NAME%
wsl --shutdown

echo **************************************************
echo STEP2_2. Add default user and WSL config file (Setup by root user)
: ADD_USER_AND_WSL_CONFIG
wsl -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%02_add_user_and_wsl_config.sh %ROCKY_USER_NAME%
wsl -t %ROCKY_ENV_NAME%
wsl --shutdown

echo **************************************************
echo STEP2_3. Add proxy to user config file
: ADD_PROXY_TO_USER_CONFIG
wsl -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%03_add_proxy_to_user_config.sh %ROCKY_USER_NAME%
wsl -t %ROCKY_ENV_NAME%

echo **************************************************
echo Finish:
echo Rocky init finished.
echo Run ./03_setup_rocky_workspace.bat next.
echo **************************************************

endlocal
pause
exit
