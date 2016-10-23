@echo off
@color 0A
TITLE Simple PCIDSS Information and Configuration Extractor (SPICE) v0.1

REM -- Prepare the Command Processor
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
cls

REM Simple PCIDSS Information and Configuration Extractor (SPICE) v0.1
REM Author: David Acosta (admin[at]pcihispano.com) from PCI Hispano www.pcihispano.com
REM
REM                                            License
REM  SPICE is free software: you can redistribute it and/or modify
REM  it under the terms of the GNU General Public License as published by
REM  the Free Software Foundation, either version 3 of the License, or
REM  any later version.
REM 
REM  This program is distributed in the hope that it will be useful,
REM  but WITHOUT ANY WARRANTY; without even the implied warranty of
REM  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM  GNU General Public License for more details.
REM
REM  You should have received a copy of the GNU General Public License
REM  along with this program.  If not, see <http://www.gnu.org/licenses/>.

REM VERSION 0.1:
REM - Upgrade to PCI DSS v3.0
REM Last Revision: 02/03/2014

REM ---- DO NOT MODIFY ANYTHING BELOW THIS LINE! ----

REM This Variable will store the hostname to rename final report file 
set pc=%computername%

REM Program version 
set version=0.1

REM Some variables to perform query operations
set result=
set one=
set two=
set three=

echo.
echo ^|=---=[Simple PCIDSS Information and Configuration Extractor (SPICE) v%version%]=--=^| 

REM Check if user has administrative privileges
echo --^[ INFO: Administrative permissions required. Detecting permissions...
net session >nul 2>&1
    if %errorLevel% == 0 (
        echo --^[ INFO: Success!
    ) else (
        echo --^[ WARN: The current user has insufficient permissions
		echo --^[ WARN: Exiting...
		pause
		Exit 0
    )
echo --^[ INFO: Retrieving configuration. This may take a while, be patient...
echo --^[ 0%% completed                                                           ]--^|

echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|=---=[Simple PCIDSS Information and Configuration Extractor (SPICE) v%version%]=--=^| >> ~SPICELOG.TMP 2> nul
echo ^|=------------=[Author: David Acosta dacosta.at.computer.org]=---------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|=-------------------=[PCI Hispano www.pcihispano.com ]=---------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
REM PCI DSS Version
echo --^[ INFO: PCI DSS v3.0 checked >> ~SPICELOG.TMP 2> nul
REM export the current date and time
echo --^[ INFO: Report start time: >> ~SPICELOG.TMP 2> nul
date /t >> ~SPICELOG.TMP 2> nul
time /t >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul
echo ^|=--------------------------=[SYSTEM INFORMATION]=---------------------------=^| >> ~SPICELOG.TMP 2> nul
systeminfo >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=----------------------=[ACTIVE DIRECTORY STATUS]=--------------------------=^| >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul
FOR /F "tokens=1* delims=REG_SZ " %%A IN ('REG QUERY HKLM\System\CurrentControlSet\Services\Tcpip\Parameters /v Domain') DO (
SET Domain=%%B
)

IF "%Domain%"=="" (
ECHO --^[ INFO: Computer is standalone or in a workgroup >> ~SPICELOG.TMP 2> nul
	secedit /export /cfg ~SPICE0A.TMP /quiet
	type ~SPICE0A.TMP > ~SPICE1A.TMP
	del /q ~SPICE0A.TMP 2> nul

) ELSE  (
ECHO --^[ INFO: Computer belongs to %Domain% domain >> ~SPICELOG.TMP 2> nul
	secedit /export /mergedpolicy /cfg ~SPICE0A.TMP /quiet
	type ~SPICE0A.TMP > ~SPICE1A.TMP
	del /q ~SPICE0A.TMP 2> nul
)
echo. >> ~SPICELOG.TMP 2> nul
  
echo ^|=----------------=[PERSONAL FIREWALL - SERVICE STATUS]=---------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 1.4                                                 =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
sc query sharedaccess >> ~SPICELOG.TMP 2> nul
sc query mpssvc >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=------------------=[PERSONAL FIREWALL CONFIGURATION]=----------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 1.4                                                 =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo --^[ Profiles >> ~SPICELOG.TMP 2> nul
echo ------------- >> ~SPICELOG.TMP 2> nul
netsh advfirewall show allprofiles >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul
echo --^[ Detailed rules >> ~SPICELOG.TMP 2> nul
echo ------------------- >> ~SPICELOG.TMP 2> nul
netsh advfirewall firewall show rule name=all >> ~SPICELOG.TMP 2> nul

echo ^|=-------------------------=[INSTALLED SOFTWARE]=----------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 2.2.2                                               =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul
WMIC product get name,version >> ~SPICEAPPLIST.TMP 2> nul
type ~SPICEAPPLIST.TMP >> ~SPICELOG.TMP 2> nul 
echo. >> ~SPICELOG.TMP 2> nul 

echo ^|=------------------------=[SERVICES RUNNING]=-------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 2.2.2                                               =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
net start >> ~SPICELOG.TMP 2> nul

echo ^|=------------------------=[PROCESSES RUNNING]=------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 2.2.2                                               =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
tasklist >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=-----------------------=[NETWORK CONNECTIONS]=-----------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 2.2.2                                               =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
netstat -na >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=---------------------------=[IPv6 SUPPORT]=--------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 2.2.2                                               =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
PING ::1 | FINDSTR /R /C:"::1:[ˆ$]" >NUL 2>&1
IF ERRORLEVEL 1 (
	ECHO INFO: IPv6 NOT supported >> ~SPICELOG.TMP 2> nul
) ELSE (
	ECHO INFO: IPv6 supported >> ~SPICELOG.TMP 2> nul
)
echo. >> ~SPICELOG.TMP 2> nul

echo --^[ ==============^| 25%% completed                                          ]--^|

echo ^|=------------------=[MISCELLANEOUS SECURITY SETTINGS]=----------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 2.2.4                                               =^| >> ~SPICELOG.TMP 2> nul
echo ^|= Please compare current values with your Security Configuration Standard   =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo --^[ Accounts: Administrator account status >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "EnableAdminAccount" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "EnableAdminAccount" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Accounts: Guest account status >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "EnableGuestAccount" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "EnableGuestAccount" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Accounts: Rename Administrator account >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "NewAdministratorName" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "NewAdministratorName" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Accounts: Rename Guest account >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "NewGuestName" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "NewGuestName" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Accounts: Limit local account use of blank passwords to console logon only >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LimitBlankPasswordUse" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "LimitBlankPasswordUse" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Devices: Allowed to format and eject removable media >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "AllocateDASD" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "AllocateDASD" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Devices: Prevent users from installing printer drivers >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "AddPrinterDrivers" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "AddPrinterDrivers" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Devices: Restrict CD-ROM access to locally logged-on user only >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "AllocateCDRoms" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "AllocateCDRoms" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Devices: Restrict floppy access to locally logged-on user only >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "AllocateFloppies" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "AllocateFloppies" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Domain member: Digitally encrypt or sign secure channel data (always) >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "requiresignorseal" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "RequireSignOrSeal" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Domain member: Digitally encrypt secure channel data (when possible) >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "sealsecurechannel" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SealSecureChannel" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Domain member: Digitally sign secure channel data (when possible) >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "signsecurechannel" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SignSecureChannel" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Domain member: Disable machine account password changes >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "disablepasswordchange" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "DisablePasswordChange" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Domain member: Maximum machine account password age >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "Parameters\maximumpasswordage" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "MaximumPasswordAge" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Domain member: Require strong (Windows 2000 or later) session key >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "requirestrongkey" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "RequireStrongKey" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Interactive logon: Do not display last user name >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "DontDisplayLastUserName" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "DontDisplayLastUserName" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Interactive logon: Number of previous logons to cache (in case domain controller is not available) >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "cachedlogonscount" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "CachedLogonsCount" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Interactive logon: Prompt user to change password before expiration >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "passwordexpirywarning" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "PasswordExpiryWarning" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Interactive logon: Require Domain Controller authentication to unlock workstation >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "ForceUnlockLogon" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "ForceUnlockLogon" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Interactive logon: Message title for users attempting to log on >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LegalNoticeCaption" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "LegalNoticeCaption" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Interactive logon: Message text for users attempting to log on >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LegalNoticeText" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "LegalNoticeText" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Microsoft network client: Digitally sign communications (always) >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LanmanWorkstation\Parameters\RequireSecuritySignature" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "RequireSecuritySignature" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Microsoft network client: Digitally sign communications (if server agrees) >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LanmanWorkstation\Parameters\EnableSecuritySignature" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "EnableSecuritySignature" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Microsoft network client: Send unencrypted password to third-party SMB servers >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LanmanWorkstation\Parameters\EnablePlainTextPassword" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "EnablePlainTextPassword" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Microsoft network server: Amount of idle time required before suspending session >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LanManServer\Parameters\autodisconnect" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "Autodisconnect" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Microsoft network server: Digitally sign communications (always) >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LanManServer\Parameters\requiresecuritysignature" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "RequireSecuritySignature" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Microsoft network server: Digitally sign communications (if client agrees) >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LanManServer\Parameters\enablesecuritysignature" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "EnableSecuritySignature" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Microsoft network server: Disconnect clients when logon hours expire >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LanManServer\Parameters\enableforcedlogoff" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "EnableForcedLogoff" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network Access: Allow Anonymous SID\Name Translation >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LSAAnonymousNameLookup" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "LSAAnonymousNameLookup" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network Access: Do not allow Anonymous Enumeration of SAM Accounts >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "RestrictAnonymousSAM" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "RestrictAnonymousSAM" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network Access: Do not allow Anonymous Enumeration of SAM Accounts and shares >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "RestrictAnonymous" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "RestrictAnonymous" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network access: Let Everyone permissions apply to anonymous users >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "EveryoneIncludesAnonymous" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "EveryoneIncludesAnonymous" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network access: Named Pipes that can be accessed anonymously >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "NullSessionPipes" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "NullSessionPipes" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network access: Remotely accessible registry paths >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "AllowedExactPaths" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "AllowedExactPaths" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network access: Restrict anonymous access to Named Pipes and Shares >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "restrictnullsessaccess" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "RestrictNullSessAccess" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network access: Shares that can be accessed anonymously >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "NullSessionShares" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "NullSessionShares" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network security: Do not store LAN Manager hash value on next password change >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "NoLMHash" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "NoLMHash" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network security: LAN Manager authentication level >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LmCompatibilityLevel" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "LmCompatibilityLevel" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network security: LDAP client signing requirements >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "LDAPClientIntegrity" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "LDAPClientIntegrity" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Network security: Minimum session security for NTLM SSP based (including secure RPC) clients >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "NTLMMinClientSec" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "NTLMMinClientSec" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Recovery console: Allow automatic administrative logon >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "securitylevel" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SecurityLevel" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Recovery console: Allow floppy copy and access to all drives and all folders >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "setcommand" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SetCommand" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Shutdown: Allow system to be shut down without having to log on >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "ShutdownWithoutLogon" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "ShutdownWithoutLogon" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ System cryptography: Use FIPS compliant algorithms for encryption, hashing, and signing >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "FIPSAlgorithmPolicy" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "FIPSAlgorithmPolicy" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ System cryptography: Force strong key protection for user keys stored on the computer >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "ForceKeyProtection" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "ForceKeyProtection" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Interactive logon: Do not require CTRL+ALT+DEL >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "DisableCAD" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "DisableCAD" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=----------------------------=[LOCAL DRIVES]=-------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 2.2.5                                               =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
wmic logicaldisk get caption,providername,drivetype,volumename >> ~SPICEDSK.TMP 2> nul
type ~SPICEDSK.TMP >> ~SPICELOG.TMP 2> nul 
echo. >> ~SPICELOG.TMP 2> nul 

echo ^|=--------------------------=[SHARED FOLDERS]=-------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 2.2.5                                               =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
net share >> ~SPICELOG.TMP 2> nul

echo ^|=------------------------------=[OS VERSION]=--------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 6.2                                                  =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
ver | find /i " 6.3." > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows 8.1
ver | find /i " 6.2." > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows 8
ver | find /i " 6.1." > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows 7
ver | find /i " 6.0." > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows Vista
ver | find /i " 5.1." > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows XP
ver | find /i " 5.2." > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows 2003
ver | find /i "Windows 2000" > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows 2000
ver | find /i "Windows NT" > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows NT
ver | find /i ">Windows ME" > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows ME
ver | find /i "Windows 98" > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows 98
ver | find /i "Windows 95" > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows 95

REM Identify architecture
IF NOT EXIST "%SYSTEMDRIVE%\Program Files (x86)" set $VERSIONBIT=32 bit
IF EXIST "%SYSTEMDRIVE%\Program Files (x86)" set $VERSIONBIT=64 bit

REM Display result
echo --^[ INFO: OS detected %$VERSIONWINDOWS% %$VERSIONBIT% >> ~SPICELOG.TMP 2> nul

if "%$VERSIONWINDOWS%" == "Windows 95" goto warn_eol
if "%$VERSIONWINDOWS%" == "Windows 98" goto warn_eol
if "%$VERSIONWINDOWS%" == "Windows ME" goto warn_eol
if "%$VERSIONWINDOWS%" == "Windows NT" goto warn_eol
if "%$VERSIONWINDOWS%" == "Windows 2000" goto warn_eol
if "%$VERSIONWINDOWS%" == "Windows 2003" goto warn_eol
if "%$VERSIONWINDOWS%" == "Windows XP" goto warn_eol
if "%$VERSIONWINDOWS%" == "Windows Vista" goto warn
goto end 

:warn_eol
echo --^[ WARN: Your system is currently not supported (Req. 6.1) >> ~SPICELOG.TMP 2>&1
goto end

:warn
echo --^[ WARN: Your system may not be supported (Req. 6.1) >> ~SPICELOG.TMP 2>&1
goto end

:end
echo. >> ~SPICELOG.TMP 2> nul

echo --^[ =============================^| 50%% completed                           ]--^|

echo ^|=----------------------=[OS UPDATES - SERVICE STATUS]=-----------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 6.2                                                 =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
sc query wuauserv >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=--------------------------=[OS UPDATES - SOURCES]=--------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 6.2                                                  =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
reg query HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU /v UseWUServer >nul 2>&1
if ERRORLEVEL 1 (
	echo WARN: No Windows Update server configured >> ~SPICELOG.TMP 2> nul
) ELSE (
	regedit /e A21kjl!3.tmp "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" 2> nul
	type A21kjl!3.tmp >> ~SPICELOG.TMP 2> nul
	del /q A21kjl!3.tmp 2> nul
)
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=----------------------=[OS UPDATES - PATCH STATUS]=-------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 6.2                                                  =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
WMIC qfe list > ~SPICEPat.TMP 2> nul
type ~SPICEPat.TMP >> ~SPICELOG.TMP 2> nul
del /q ~SPICEPat.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=------------------------=[LAST SUCCESSFUL UPDATE]=--------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 6.2                                                  =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
SET RegKey=
SET RegKey=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion
SET RegKey=%RegKey%\WindowsUpdate\Auto Update\Results\Install
reg query "%RegKey%" /v LastSuccessTime >nul 2>&1
if ERRORLEVEL 1 (
	echo WARN: There is no data about last successful Windows Update >> ~SPICELOG.TMP 2> nul
) ELSE (
	echo --[ Last successful Windows Update: >> ~SPICELOG.TMP 2> nul
	regedit /e winupd.tmp "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\Results\Install" 2> nul
	type winupd.tmp > update.log 
	type update.log | findstr /I "LastSuccessTime" >> ~SPICELOG.TMP 2> nul
	del winupd.tmp 2> nul
	del update.log 2> nul
)
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=---------------------=[CURRENT USER PRIVILEGE RIGHTS]=---------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 7.1 - 7.2                                           =^| >> ~SPICELOG.TMP 2> nul
echo ^|= Please compare current values with your Security Configuration Standard   =^| >> ~SPICELOG.TMP 2> nul
echo ^|= Further information:                                                      =^| >> ~SPICELOG.TMP 2> nul
echo ^|=     http://msdn.microsoft.com/en-us/library/aa375728.aspx                 =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
whoami /all /fo list >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=-------------------------=[SECURITY IDENTIFIERS]=--------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 7.1 - 7.2                                           =^| >> ~SPICELOG.TMP 2> nul
echo ^|= Please compare these values with GLOBAL PRIVILEGE RIGHTS section below    =^| >> ~SPICELOG.TMP 2> nul
echo ^|= Further information:                                                      =^| >> ~SPICELOG.TMP 2> nul
echo ^|=    http://technet.microsoft.com/en-us/library/cc778824%28WS.10%29.aspx    =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul
wmic useraccount get name,sid >> ~SPICESID.TMP 2> nul
type ~SPICESID.TMP >> ~SPICELOG.TMP 2> nul
del /q ~SPICESID.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=------------------------=[GLOBAL PRIVILEGE RIGHTS]=------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 7.1 - 7.2                                           =^| >> ~SPICELOG.TMP 2> nul
echo ^|= Please compare current values with your Security Configuration Standard   =^| >> ~SPICELOG.TMP 2> nul
echo ^|= Further information:                                                      =^| >> ~SPICELOG.TMP 2> nul
echo ^|=     http://msdn.microsoft.com/en-us/library/aa375728.aspx                 =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Account Rights Constants >> ~SPICELOG.TMP 2> nul
echo --------------------------- >> ~SPICELOG.TMP 2> nul
echo --^[ Required for an account to log on using the batch logon type >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "sebatchlogonright" ~SPICE1A.TMP') do set result=%%a
if "!result!"=="" ( 
	echo WARN: Variable "SeBatchLogonRight" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Explicitly denies an account the right to log on using the batch logon type >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "sedenybatchlogonright" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeDenyBatchLogonRight" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Explicitly denies an account the right to log on using the interactive logon type >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeDenyInteractiveLogonRight" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeDenyInteractiveLogonRight" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Explicitly denies an account the right to log on using the network logon type >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "sedenynetworklogonright" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeDenyNetworkLogonRight" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Explicitly denies an account the right to log on remotely using the interactive logon type >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "sedenyremoteinteractivelogonright" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeDenyRemoteInteractiveLogonRight" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Explicitly denies an account the right to log on using the service logon type >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeDenyServiceLogonRight" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeDenyServiceLogonRight" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Required for an account to log on using the interactive logon type >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seinteractivelogonright" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeInteractiveLogonRight" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Required for an account to log on using the network logon type >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "senetworklogonright" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeNetworkLogonRight" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Required for an account to log on remotely using the interactive logon type >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seremoteinteractivelogonright" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeRemoteInteractiveLogonRight" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Required for an account to log on using the service logon type >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeServiceLogonRight" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeServiceLogonRight" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo. >> ~SPICELOG.TMP 2> nul
echo ---------------------- >> ~SPICELOG.TMP 2> nul
echo ^|= Privilege Constants >> ~SPICELOG.TMP 2> nul
echo ---------------------- >> ~SPICELOG.TMP 2> nul
echo --^[ Replace a process-level token >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seassignprimarytokenprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeAssignPrimaryTokenPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Generate security audits >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seauditprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeAuditPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Back up files and directories >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeBackupPrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeBackupPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Bypass traverse checking >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeChangeNotifyPrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeChangeNotifyPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Create global objects >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeCreateGlobalPrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeCreateGlobalPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Create a pagefile >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeCreatePagefilePrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeCreatePagefilePrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Create permanent shared objects >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeCreatePermanentPrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeCreatePermanentPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Create symbolic links >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeCreateSymbolicLinkPrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeCreateSymbolicLinkPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Create a token object >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeCreateTokenPrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeCreateTokenPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Debug programs >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "sedebugprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeDebugPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Enable computer and user accounts to be trusted for delegation >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seenabledelegationprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeEnableDelegationPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Impersonate a client after authentication >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seimpersonateprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeImpersonatePrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Increase scheduling priority >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seincreasebasepriorityprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeIncreaseBasePriorityPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Adjust memory quotas for a process >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seincreasequotaprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeIncreaseQuotaPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Increase a process working set >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeIncreaseWorkingSetPrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeIncreaseWorkingSetPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Load and unload device drivers >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seloaddriverprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeLoadDriverPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Lock pages in memory >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "selockmemoryprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeLockMemoryPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Add workstations to domain >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "semachineaccountprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeMachineAccountPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Manage the files on a volume >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "semanagevolumeprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeManageVolumePrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Profile single process >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seprofilesingleprocessprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeProfileSingleProcessPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Modify an object label >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeRelabelPrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeRelabelPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Force shutdown from a remote system >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seremoteshutdownprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeRemoteShutdownPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Restore files and directories >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "serestoreprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeRestorePrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Manage auditing and security log >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "sesecurityprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeSecurityPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Shut down the system >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seshutdownprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeShutdownPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Synchronize directory service data >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "sesyncagentprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeSyncAgentPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Modify firmware environment values >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "sesystemenvironmentprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeSystemEnvironmentPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Profile system performance >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "sesystemprofileprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeSystemProfilePrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Change the system time >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "sesystemtimeprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeSystemTimePrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Take ownership of files or other objects >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "setakeownershipprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeTakeOwnershipPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Act as part of the operating system >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "setcbprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeTcbPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Change the time zone >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeTimeZonePrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeTimeZonePrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Access Credential Manager as a trusted caller >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeTrustedCredManAccessPrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeTrustedCredManAccessPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Remove computer from docking station >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "seundockprivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeUndockPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo --^[ Required to read unsolicited input from a terminal device >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=* delims= " %%a in ('findstr /I "SeUnsolicitedInputPrivilege" ~SPICE1A.TMP') do (
set result=%%a
)
if "!result!"=="" ( 
	echo WARN: Variable "SeUnsolicitedInputPrivilege" is not set >> ~SPICELOG.TMP
) else (
	echo INFO: !result! >> ~SPICELOG.TMP
)
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=-----------------------=[ENABLED LOCAL ACCOUNTS]=---------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.1.4                                                =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
wmic USERACCOUNT WHERE "Disabled=0 AND LocalAccount=1" GET Name >> ~SPICEAcc.TMP 2> nul
type ~SPICEAcc.TMP >> ~SPICELOG.TMP 2> nul
del /q ~SPICEAcc.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=-----------------------=[DISABLED LOCAL ACCOUNTS]=--------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.1.4                                                =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
wmic USERACCOUNT WHERE "Disabled=1 AND LocalAccount=1" GET Name >> ~SPICEAcc.TMP 2> nul
type ~SPICEAcc.TMP >> ~SPICELOG.TMP 2> nul
del /q ~SPICEAcc.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=---------------------------=[ACCOUNT LOCKOUT]=------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.1.6                                                =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "LockoutBadCount" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if !three! EQU 0 (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	echo WARN: Value "LockoutBadCount" is zero and does not block accounts - infinite attempts >> ~SPICELOG.TMP 2> nul
	goto CERO
)
if "!one!"=="" ( 
	echo WARN: Variable "LockoutBadCount" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! LEQ 6 (
		echo INFO: Value "LockoutBadCount" complies with PCI DSS Req. 8.1.6 >> ~SPICELOG.TMP 2> nul
	) else (
		echo WARN: Value "LockoutBadCount" does not meet with Req. 8.1.6 >> ~SPICELOG.TMP 2> nul
))

:CERO
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=----------------------=[ACCOUNT LOCKOUT DURATION]=--------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.1.7                                                =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "LockoutDuration" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "LockoutDuration" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! LSS 30 (
		echo WARN: Value "LockoutDuration" does not meet with Req. 8.1.7 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Value "LockoutDuration" complies with PCI DSS Req. 8.1.7 >> ~SPICELOG.TMP 2> nul
))
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=----------------------------=[SESSION TIMEOUT]=-----------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.1.8                                                =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo --^[ ScreenSaver active >> ~SPICELOG.TMP 2> nul
set three=
REG Query "HKCU\Control Panel\Desktop" /v ScreenSaveActive >NUL 2>&1
IF ERRORLEVEL 1 (
	echo WARN: Variable "ScreenSaveActive" is not set >> ~SPICELOG.TMP 2> nul
) ELSE (
	for /F "tokens=2,*" %%a in ('REG Query "HKCU\Control Panel\Desktop" /S^| find "ScreenSaveActive"') do set three=%%b
)

if !three! NEQ 1 (
	echo ScreenSaveActive=!three! >> ~SPICELOG.TMP 2> nul
	echo WARN: Variable "ScreenSaveActive" does not meet with Req. 8.1.8 >> ~SPICELOG.TMP 2> nul
) else (
	echo ScreenSaveActive=!three! >> ~SPICELOG.TMP 2> nul
	echo INFO: Variable "ScreenSaveActive" complies with PCI DSS Req. 8.1.8 >> ~SPICELOG.TMP 2> nul
)

echo --^[ ScreenSaver timeout >> ~SPICELOG.TMP 2> nul
set three=
REG Query "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut >nul 2>&1
IF ERRORLEVEL 1 (
	echo WARN: Variable "ScreenSaveTimeOut" is not set >> ~SPICELOG.TMP 2> nul
) ELSE (
for /F "tokens=2,*" %%a in ('REG Query "HKCU\Control Panel\Desktop" /S^|find "ScreenSaveTimeOut"') do set three=%%b
)

		if !three! NEQ 1 (
		echo ScreenSaveTimeOut=!three! >> ~SPICELOG.TMP 2> nul
		echo WARN: Variable "ScreenSaveTimeOut" does not meet with Req. 8.1.8 >> ~SPICELOG.TMP 2> nul
		) else (
		echo ScreenSaveActive=!three! >> ~SPICELOG.TMP 2> nul
		echo INFO: Variable "ScreenSaveTimeOut" complies with PCI DSS Req. 8.1.8 >> ~SPICELOG.TMP 2> nul
	)

echo --^[ ScreenSaver with password >> ~SPICELOG.TMP 2> nul
set three=
REG Query "HKCU\Control Panel\Desktop" /v ScreenSaverIsSecure >nul 2>&1
IF ERRORLEVEL 1 (
	echo WARN: Variable "ScreenSaverIsSecure" is not set >> ~SPICELOG.TMP 2> nul
) ELSE (
for /F "tokens=2,*" %%a in ('REG Query "HKCU\Control Panel\Desktop" /S^|find "ScreenSaverIsSecure"') do set three=%%b
)

if !three! NEQ 1 (
	echo ScreenSaverIsSecure=!three! >> ~SPICELOG.TMP 2> nul
	echo WARN: Variable "ScreenSaverIsSecure" does not meet with Req. 8.1.8 >> ~SPICELOG.TMP 2> nul
) else (
	echo ScreenSaverIsSecure=!three! >> ~SPICELOG.TMP 2> nul
	echo INFO: Variable "ScreenSaverIsSecure" complies with PCI DSS Req. 8.1.8 >> ~SPICELOG.TMP 2> nul
)

	echo. >> ~SPICELOG.TMP 2> nul

echo ^|=---------------------=[PASSWORD STORE CONFIGURATION]=----------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.2.1                                               =^| >> ~SPICELOG.TMP 2> nul
echo ^|=---------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "ClearTextPassword" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "ClearTextPassword" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! NEQ 0 (
		echo WARN: Value "ClearTextPassword" does not meet with Req. 8.2.1 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Value "ClearTextPassword" complies with PCI DSS Req. 8.2.1 >> ~SPICELOG.TMP 2> nul
))
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=--------------------------=[PASSWORD LENGHT]=-------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.2.3                                                =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "MinimumPasswordLength" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "MinimumPasswordLength" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! LSS 7 (
		echo WARN: Value "MinimumPasswordLength" does not meet with Req. 8.2.3 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Value "MinimumPasswordLength" complies with PCI DSS Req. 8.2.3 >> ~SPICELOG.TMP 2> nul
))
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=------------------------=[PASSWORD COMPLEXITY]=-----------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.2.3                                                =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "PasswordComplexity" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "PasswordComplexity" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! NEQ 1 (
		echo WARN: Value "PasswordComplexity" does not meet with Req. 8.5.11 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Value "PasswordComplexity" complies with PCI DSS Req. 8.5.11 >> ~SPICELOG.TMP 2> nul
))
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=----------------------=[PASSWORD CHANGE THRESHOLD]=-------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.2.4                                                =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I /B "MaximumPasswordAge" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "MaximumPasswordAge" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! GTR 90 (
		echo WARN: Value "MaximumPasswordAge" does not meet with Req. 8.2.4 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Value "MaximumPasswordAge" complies with PCI DSS Req. 8.2.4 >> ~SPICELOG.TMP 2> nul
))
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=--------------------------=[PASSWORD HISTORY]=------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.2.5                                                =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "PasswordHistorySize" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "PasswordHistorySize" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! GEQ 4 (
		echo INFO: Value "PasswordHistorySize" complies with PCI DSS Req. 8.2.5 >> ~SPICELOG.TMP 2> nul
	) else (
		echo WARN: Value "PasswordHistorySize" does not meet with Req. 8.2.5 >> ~SPICELOG.TMP 2> nul
))
echo. >> ~SPICELOG.TMP 2> nul

echo --^[ ============================================^| 75%% completed            ]--^|

echo ^|=-----------------------------=[LOCAL ACCOUNTS]=-----------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.5                                                  =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
net user >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=-------------------------=[LOCAL ADMINISTRATORS]=---------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.5                                                  =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
net localgroup "Administrators" >> ~SPICELOG.TMP 2> nul
net localgroup "Administradores" >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=-----------------------=[LOCAL ADMINISTRATOR STATUS]=-----------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.5                                                  =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
set result=
for /F "tokens=3 delims= " %%a in ('findstr /I "NewAdministratorName" ~SPICE1A.TMP') do set result=%%a
if "!result!"=="" ( 
 	net user administrator >> ~SPICELOG.TMP 2> nul
	net user administrador >> ~SPICELOG.TMP 2> nul
) else (
	net user %result% >> ~SPICELOG.TMP 2> nul
)
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=-----------------------------=[LOCAL GROUPS]=-------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 8.5                                                  =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
net localgroup >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=-----------------------=[EVENTLOG - SERVICE STATUS]=------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 10.2 - 10.3                                          =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
sc query eventlog >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=---------------------------=[LOG CONFIGURATION]=----------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 10.2 - 10.3                                          =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "AuditSystemEvents" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "AuditSystemEvents" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! NEQ 3 (
		echo WARN: Variable "AuditSystemEvents" does not meet with Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Variable "AuditSystemEvents" complies with PCI DSS Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
))
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "AuditLogonEvents" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "AuditLogonEvents" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! NEQ 3 (
		echo WARN: Variable "AuditLogonEvents" does not meet with Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Variable "AuditLogonEvents" complies with PCI DSS Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
))
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "AuditObjectAccess" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "AuditObjectAccess" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! NEQ 3 (
		echo WARN: Variable "AuditObjectAccess" does not meet with Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Variable "AuditObjectAccess" complies with PCI DSS Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
))
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "AuditPrivilegeUse" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "AuditPrivilegeUse" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! NEQ 3 (
		echo WARN: Variable "AuditPrivilegeUse" does not meet with Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Variable "AuditPrivilegeUse" complies with PCI DSS Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
))
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "AuditPolicyChange" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "AuditPolicyChange" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! NEQ 3 (
		echo WARN: Variable "AuditPolicyChange" does not meet with Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Variable "AuditPolicyChange" complies with PCI DSS Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
))
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "AuditAccountManage" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "AuditAccountManage" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! NEQ 3 (
		echo WARN: Variable "AuditAccountManage" does not meet with Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Variable "AuditAccountManage" complies with PCI DSS Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
))
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "AuditProcessTracking" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "AuditProcessTracking" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! NEQ 3 (
		echo WARN: Variable "AuditProcessTracking" does not meet with Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Variable "AuditProcessTracking" complies with PCI DSS Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
))
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "AuditDSAccess" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "AuditDSAccess" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! NEQ 3 (
		echo WARN: Variable "AuditDSAccess" does not meet with Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Variable "AuditDSAccess" complies with PCI DSS Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
))
set one=
set two=
set three=
for /F "tokens=1,2,3 delims= " %%a in ('findstr /I "AuditAccountLogon" ~SPICE1A.TMP') do (
set one=%%a
set two=%%b
set three=%%c
)
if "!one!"=="" ( 
	echo WARN: Variable "AuditAccountLogon" is not set >> ~SPICELOG.TMP 2> nul
) else (
	echo !one!!two!!three! >> ~SPICELOG.TMP 2> nul
	if !three! NEQ 3 (
		echo WARN: Variable "AuditAccountLogon" does not meet with Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
	) else (
		echo INFO: Variable "AuditAccountLogon" complies with PCI DSS Req. 10.2 - 10.3 >> ~SPICELOG.TMP 2> nul
))
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=------------------------------=[LOG POLICIES]=------------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 10.2 - 10.3                                          =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
auditpol /get /category:* >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=-------------------------=[NTP - SERVICE STATUS]=---------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 10.4                                                 =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
sc query w32time >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=---------------------------=[NTP CONFIGURATION]=----------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 10.4.3                                               =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
sc query w32time | find "RUNNING" >nul 2>&1
IF ERRORLEVEL 1 (
	echo WARN: Service w32time is stopped >> ~SPICELOG.TMP 2> nul
) ELSE (
	w32tm /query /status >> ~time1.log 
	w32tm /query /configuration >> ~time2.log 
	type ~time1.log >> ~SPICELOG.TMP 2> nul
	type ~time2.log >> ~SPICELOG.TMP 2> nul
	del /q ~time1.log 2> nul
	del /q ~time2.log 2> nul
)
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=-------------------------=[LOG DACL PERMISSIONS]=---------------------------=^| >> ~SPICELOG.TMP 2> nul
echo ^|= Related requirements: 10.5.1 - 10.5.2                                      =^| >> ~SPICELOG.TMP 2> nul
echo ^|=----------------------------------------------------------------------------=^| >> ~SPICELOG.TMP 2> nul
REM Windows Vista/7/Server2008 %SystemRoot%\system32\winevt\logs
REM Windows 2003/XP %SystemRoot%\System32\Config 
echo --^[ Application Event Log DACL: >> ~SPICELOG.TMP 2> nul
cacls %SystemRoot%\System32\Config\AppEvent.Evt /C >> ~SPICELOG.TMP 2> nul
cacls %SystemRoot%\system32\winevt\logs\Application.evtx /C >> ~SPICELOG.TMP 2> nul
echo --^[ Security Event Log DACL: >> ~SPICELOG.TMP 2> nul
cacls %SystemRoot%\System32\Config\SecEvent.Evt /C >> ~SPICELOG.TMP 2> nul
cacls %SystemRoot%\system32\winevt\logs\Security.evtx /C >> ~SPICELOG.TMP 2> nul
echo --^[ System Event Log DACL: >> ~SPICELOG.TMP 2> nul
cacls %SystemRoot%\System32\Config\SysEvent.Evt /C >> ~SPICELOG.TMP 2> nul
cacls %SystemRoot%\system32\winevt\logs\System.evtx /C >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

echo ^|=----------------------------------=[EOF]=-----------------------------------=^| >> ~SPICELOG.TMP 2> nul

echo --^[ INFO: Report end time: >> ~SPICELOG.TMP 2> nul
date /t >> ~SPICELOG.TMP 2> nul
time /t >> ~SPICELOG.TMP 2> nul
echo. >> ~SPICELOG.TMP 2> nul

REM Log final depuration
IF EXIST %computername%.log del /q %computername%.log 2> nul
type ~SPICELOG.TMP | findstr /v "The command completed successfully." | findstr /B /L /v "Name" > ~SPICELOGF.TMP 2> nul
type ~SPICELOGF.TMP | findstr /B /L /v "Se ha completado el comando correctamente." | findstr /B /L /v "Windows Registry Editor Version" > %computername%.log 2> nul

REM Deleting temporal files...
del /q ~SPICE1A.TMP 2> nul
del /q ~SPICEDSK.TMP 2> nul
del /q ~SPICELOG.TMP 2> nul
del /q ~SPICELOGF.TMP 2> nul
del /q ~SPICEAPPLIST.TMP 2> nul

echo --^[ ===============================================================^| Done^^! ]--^|
echo --^[ INFO: Process finished. 
echo --^[ INFO: Check your %computername%.log file
echo --^[ INFO: Exiting...
pause
ENDLOCAL
exit 0