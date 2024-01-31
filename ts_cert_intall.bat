@echo off

set ROOTCA_CERT="./cert/OISTE WISeKey Global Root GB CA.pem"

set ROOTCA_ALIAS1=oiste_wisekey_global_root_gb_ca
set ROOTCA_ALIAS2=oistewisekeyglobalrootgbca
set CACERTS_PASSWORD=changeit

set RETURN_VALUE=
set TEMP_FILE=temp_output.txt

cd %~dp0 

CALL :IsExistRootCA %ROOTCA_ALIAS1%
IF ["%RETURN_VALUE%"]==[""] (
    CALL :IsExistRootCA  %ROOTCA_ALIAS2%
)

IF ["%RETURN_VALUE%"]==[""] (
    echo Import %ROOTCA_ALIAS1%
    keytool -import -cacerts -noprompt -file %ROOTCA_CERT% -alias %ROOTCA_ALIAS1% -storepass %CACERTS_PASSWORD%
) else (
    echo Already Included RootCA : %RETURN_VALUE%
)

pause

:: Check Root Certificate
:IsExistRootCA
keytool -list -cacerts -storepass %CACERTS_PASSWORD% > %TEMP_FILE%
if %ERRORLEVEL% neq 0 (
    echo Error: Not found keytool.
    del %TEMP_FILE%
    pause
    exit
)

findstr /i /c:"%~1" %TEMP_FILE%
if %ERRORLEVEL% equ 0 (
    set RETURN_VALUE=%~1
)

del %TEMP_FILE%
EXIT /B 0