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
set ROCKY_SETUP_SCRIPT_UNIX_DIR=./%SRC_DIR_NAME%/script/

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

@REM **************************************************
echo STEP1. Set new Rocky environment name
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
echo STEP2. Set Rocky image file for new Rocky environment
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
echo STEP3. Set username for new Rocky environment.
: SET_ROCKY_USER_NAME
set ROCKY_USER_NAME=
echo Type username（default regular user's name）for new Rocky environment.
set /P ROCKY_USER_NAME=[input] 

echo **************************************************
echo STEP4. Import Rocky to WSL
: SET_ROCKY_IMG_FILE
set CONFIRMATION_INPUT=
echo Import Rocky to WSL. To continue, type %INPUT_YES%.
echo   Environment name: %ROCKY_ENV_NAME%
echo   Machine path: %ROCKY_MACHINE_PATH%
echo   Rocky image file path: %ROCKY_IMG_PATH%
echo   Username: %ROCKY_USER_NAME%
set /P CONFIRMATION_INPUT=[input]

if NOT %CONFIRMATION_INPUT% == %INPUT_YES% (
    echo Exit setup.
    pause
    exit
)
wsl --import %ROCKY_ENV_NAME% %ROCKY_MACHINE_PATH% %ROCKY_IMG_PATH% --version 2

echo **************************************************
echo STEP5. Update Rocky packages (Setup by root user)
: UPDATE_ROCKY_PACKAGE
wsl -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%01_update_package.sh
wsl -t %ROCKY_ENV_NAME%
wsl --shutdown

echo **************************************************
echo STEP6. Add default user and WSL config file (Setup by root user)
: ADD_USER_AND_WSL_CONFIG
wsl -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%02_add_user_and_wsl_config.sh %ROCKY_USER_NAME%
wsl -t %ROCKY_ENV_NAME%
wsl --shutdown

echo **************************************************
echo STEP7. Add proxy to user config file
: ADD_PROXY_TO_USER_CONFIG
wsl ~ d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%03_add_proxy_to_user_config.sh
wsl -t %ROCKY_ENV_NAME%

echo **************************************************
echo STEP8. Setup Git
: CREATE_SSH_KEY
wsl ~ -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%04_setup_git_create_ssh_key.sh
wsl -t %ROCKY_ENV_NAME%

: SSHKEY_CONFIRMATION
set CONFIRMATION_INPUT=
echo Did you add SSH public key to GitHub?（%INPUT_YES% / %INPUT_NO%）
set /P CONFIRMATION_INPUT=[input]
if NOT %CONFIRMATION_INPUT% == %INPUT_YES% (
    goto SSHKEY_CONFIRMATION
)

: GIT_ACCOUNT_CONFIRMATION
set GITHUB_USER_EMAIL=
echo Type email for GitHub.
set /P GITHUB_USER_EMAIL=[input]
set GITHUB_USER_NAME=
echo Type username for GitHub.
set /P GITHUB_USER_NAME=[input]
set CONFIRMATION_INPUT=
echo Is your GitHub account information correct?（%INPUT_YES% / %INPUT_NO%）
echo   Email: %GITHUB_USER_EMAIL%
echo   Username: %GITHUB_USER_NAME%
if NOT %CONFIRMATION_INPUT% == %INPUT_YES% (
    goto GIT_ACCOUNT_CONFIRMATION
)
wsl ~ -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%05_setup_git_create_git_config.sh %GITHUB_USER_EMAIL% %GITHUB_USER_NAME%

: GIT_SETUP_WORKSPACE
wsl ~ -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%06_setup_git_setup_workspace.sh

echo **************************************************
echo STEP9. Setup Ansible
: SETUP_ANSIBLE
set IS_OLD_ROCKY=
echo Is this Rocky environment older than 9?（%INPUT_YES% / %INPUT_NO%）
set /P GITHUB_USER_EMAIL=[input]
if %CONFIRMATION_INPUT% == %INPUT_YES% (
    set PIP_URL=https://bootstrap.pypa.io/pip/3.6/get-pip.py
) else (
    set PIP_URL=https://bootstrap.pypa.io/get-pip.py
)

wsl ~ -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%07_setup_ansible.sh %PIP_URL%
wsl -t %ROCKY_ENV_NAME%

echo **************************************************
echo Finish:
echo Setup finished.
echo Run "wsl ~ -d %ROCKY_ENV_NAME%" to login.
echo **************************************************

endlocal
pause
exit

