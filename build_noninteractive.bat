@echo off
set COMPILEDIR=%CD%

echo Deleting old mod.ff...
if exist mod.ff del mod.ff

echo Copying rawfiles...
xcopy shock ..\..\raw\shock /SYI > NUL
xcopy images ..\..\raw\images /SYI > NUL
xcopy materials ..\..\raw\materials /SYI > NUL
xcopy material_properties ..\..\raw\material_properties /SYI > NUL
xcopy sound ..\..\raw\sound /SYI > NUL
xcopy soundaliases ..\..\raw\soundaliases /SYI > NUL
xcopy fx ..\..\raw\fx /SYI > NUL
xcopy mp ..\..\raw\mp /SYI > NUL
xcopy mp ..\..\zone_source\mp /SYI > NUL
xcopy weapons\mp ..\..\raw\weapons\mp /SYI > NUL
xcopy xanim ..\..\raw\xanim /SYI > NUL
xcopy xmodel ..\..\raw\xmodel /SYI > NUL
xcopy xmodelparts ..\..\raw\xmodelparts /SYI > NUL
xcopy xmodelsurfs ..\..\raw\xmodelsurfs /SYI > NUL
xcopy ui ..\..\raw\ui /SYI > NUL
xcopy ui_mp ..\..\raw\ui_mp /SYI > NUL
xcopy english ..\..\raw\english /SYI > NUL
xcopy vision ..\..\raw\vision /SYI > NUL
xcopy rumble ..\..\raw\rumble /SYI > NUL
xcopy animtrees ..\..\raw\animtrees /SYI > NUL

echo Copying source code...
xcopy maps ..\..\raw\maps /SYI > NUL
xcopy promod ..\..\raw\promod /SYI > NUL
xcopy scripts ..\..\raw\scripts /SYI > NUL


echo Copying MOD.CSV...
xcopy mod.csv ..\..\zone_source\ /S /Y /I > NUL

echo Compiling mod...
cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd %COMPILEDIR%

if exist ..\..\zone\english\mod.ff (
    copy ..\..\zone\english\mod.ff .
    echo mod.ff built and copied successfully!
) else (
    echo Error: mod.ff was not created by the linker.
)

echo Building TRG.iwd...
python build_iwds.py

echo Build complete!
