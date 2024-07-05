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
echo STEP3. Setup Git
: CREATE_SSH_KEY
wsl -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%04_setup_git_create_ssh_key.sh
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
set /P CONFIRMATION_INPUT=[input]
if NOT %CONFIRMATION_INPUT% == %INPUT_YES% (
    goto GIT_ACCOUNT_CONFIRMATION
)
wsl -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%05_setup_git_create_git_config.sh %GITHUB_USER_EMAIL% %GITHUB_USER_NAME%
wsl -t %ROCKY_ENV_NAME%

: GIT_SETUP_WORKSPACE
wsl -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%06_setup_git_setup_workspace.sh
wsl -t %ROCKY_ENV_NAME%

echo **************************************************
echo STEP4. Setup Ansible
: SETUP_ANSIBLE
set IS_OLD_ROCKY=
echo Is this Rocky environment older than 9?（%INPUT_YES% / %INPUT_NO%）
set /P IS_OLD_ROCKY=[input]
if %CONFIRMATION_INPUT% == %INPUT_YES% (
    set PIP_URL=https://bootstrap.pypa.io/pip/3.6/get-pip.py
) else (
    set PIP_URL=https://bootstrap.pypa.io/get-pip.py
)

wsl -d %ROCKY_ENV_NAME% %ROCKY_SETUP_SCRIPT_UNIX_DIR%07_setup_ansible.sh %PIP_URL%
wsl -t %ROCKY_ENV_NAME%

echo **************************************************
echo Finish:
echo Setup finished.
echo Run "wsl -d %ROCKY_ENV_NAME%" to login.
echo **************************************************

endlocal
pause
exit
