@REM Make sure the latest version of shared is used
call install-shared.bat

@REM Current path is now in world-settings or server-settings.
cd ../world-settings
call ng build

cd ../server-settings
call ng build

cd ../../../..
7z a -tzip ServerSettings/ServerSettings.zip ServerSettings -x!ServerSettings/frontend -x!ServerSettings/.git -x!ServerSettings/forum_info.txt -x!ServerSettings/ServerSettings.zip