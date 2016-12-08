@echo off

:: track valid IPs
set /a valid=0

:: track total IPs
set /a count=0

:: track if we found inverse in subfunc
set inhypernet=no
set insupernet=no

:: loop over every line in file
for /F "tokens=*" %%A in (input.txt) do (
	CALL :isvalid %%A
)

:: print final valid
echo %valid%

timeout /t 5
EXIT /B 0

::helper function for finding ABA pattern
:isvalid
SET brace=off
SET mystr=%*-----
:: reset finder flags
SET insupernet=no
SET inhypernet=no
:loop:
:: first three chars in string
SET char1=%mystr:~0,1%
SET char2=%mystr:~1,1%
SET char3=%mystr:~2,1%
:: create a BAB version of these chars
SET bab=%char2%%char1%%char2%

:: are we entering a hypernet
if %char1% == [ set brace=on
if %char1% == [ GOTO short

:: are we leaving a hypernet
if %char1% == ] set brace=off
if %char1% == ] GOTO short

:: if char1 and char3 match, and we're in hypernet, look for ABA in supernet
IF %brace% == on IF %char1% == %char3% CALL :insuper %mystr% %bab%

:: if char1 and char3 match, and we're in supernet, look for ABA in hypernet
IF %brace% == off IF %char1% == %char3% CALL :inhyper %mystr% %bab%

:: if one of those calls above set these vars, we found a SSL IPs
IF %inhypernet% == yes GOTO finish
IF %insupernet% == yes GOTO finish

:short:
:: remove the first char of the string, we are done with it
SET mystr=%mystr:~1%

:: if the string hasn't reached out delimiter we added, then loop back up and look more
IF NOT %mystr% == ----- GOTO loop
:finish:
:: set appropriate vars
IF %inhypernet% == yes set /a valid+=1
IF %insupernet% == yes set /a valid+=1

:: output IP for reference
IF %inhypernet% == yes echo %*
IF %insupernet% == yes echo %*

:: increase total count and display
set /a count+=1
echo %count%--%valid%
EXIT /B 0

:inhyper
:: this gets called from super, so hyper is off
SET hyper=off

:: save off string
SET str=%~1
:hyperloop:

:: are we entering a hypernet
if %str:~0,1% == [ set hyper=on
if %str:~0,1% == [ GOTO continue

:: are we entering a supernet
if %str:~0,1% == ] set hyper=off
if %str:~0,1% == ] GOTO continue

:: if we are in a hypernet and the BAB passed in matches, we're good
IF %hyper% == on IF %~2 == %str:~0,3% SET inhypernet=yes
IF %inhypernet% == yes GOTO complete
:continue:
:: remove the first char of the string, we are done with it
SET str=%str:~1%

:: if the string hasn't reached out delimiter we added, then loop back up and look more
IF NOT %str% == ----- GOTO hyperloop
:complete:
EXIT /B 0

:insuper
:: this gets called from hyper, so super is off
SET super=off

:: save off string
SET astr=%~1
:superloop:

:: are we entering a hypernet
if %astr:~0,1% == [ set super=off
if %astr:~0,1% == [ GOTO reloop

:: are we entering a supernet
if %astr:~0,1% == ] set super=on
if %astr:~0,1% == ] GOTO reloop

:: if we are in a supernet and the BAB passed in matches, we're good
IF %super% == on IF %~2 == %astr:~0,3% SET insupernet=yes
IF %insupernet% == yes GOTO isdone
:reloop:
:: remove the first char of the string, we are done with it
SET astr=%astr:~1%

:: if the string hasn't reached out delimiter we added, then loop back up and look more
IF NOT %astr% == ----- GOTO superloop
:isdone:
EXIT /B 0
