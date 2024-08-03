cd projects\shared
call ng build

cd ..\..\dist/shared
cd dist\shared
call npm pack
copy shared-0.0.1.tgz ..\..\projects\world-settings\shared.tgz
copy shared-0.0.1.tgz ..\..\projects\server-settings\shared.tgz

cd ..\..\projects\world-settings
call npm i shared.tgz

cd ../server-settings
call npm i shared.tgz
