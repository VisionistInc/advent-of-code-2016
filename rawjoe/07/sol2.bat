@echo off

:: track valid IPs
set /a valid=0

:: track total IPs
set /a count=0

:: track if we found inverse in subfunc
set foundBAB=no

:: loop over every line in file
for /F "tokens=*" %%A in (input.txt) do (
	CALL :isvalid %%A
)

:: print final valid
echo %valid%

timeout /t 3000
EXIT /B 0

::helper function for finding ABA pattern
:isvalid
SET brace=off
SET mystr=%*-----
:: reset finder flag
SET foundBAB=no

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
IF %brace% == on IF %char1% == %char3% CALL :findBAB %mystr% %bab% ] [

:: if char1 and char3 match, and we're in supernet, look for ABA in hypernet
IF %brace% == off IF %char1% == %char3% CALL :findBAB %mystr% %bab% [ ]

:: if one of those calls above sets this var, we found a SSL IPs
IF %foundBAB% == yes GOTO finish

:short:
:: remove the first char of the string, we are done with it
SET mystr=%mystr:~1%

:: if the string hasn't reached out delimiter we added, then loop back up and look more
IF NOT %mystr% == ----- GOTO loop
:finish:
:: set appropriate vars
IF %foundBAB% == yes set /a valid+=1

:: output IP for reference
IF %foundBAB% == yes echo %*

:: increase total count and display
set /a count+=1
echo %count%--%valid%
EXIT /B 0

:: Helper function for finding BAB in a string
:: %~1 is string to search, start at the ABA position
::     we know ABA is in the wrong "part" of the string, so we
::     can pre-set validpart to no
:: %~2 is the BAB string to search for
:: %~3 is the delimiter that tells us we are entering a valid part of the string
:: %~4 is the delimiter that tells us we are leaving a valid part of the string
:findBAB
:: this gets called when aba is found, so we aren't in a valid part
SET validpart=no

:: save off string
SET astr=%~1
:searchloop:

:: are we entering a valid part
if %astr:~0,1% == %~3 set validpart=yes
if %astr:~0,1% == %~3 GOTO reloop

:: are we leaving a validpart
if %astr:~0,1% == %~4 set validpart=no
if %astr:~0,1% == %~4 GOTO reloop

:: if we are in a valid part and the BAB passed in matches, we're good
IF %validpart% == yes IF %~2 == %astr:~0,3% SET foundBAB=yes
IF %foundBAB% == yes GOTO complete
:reloop:
:: remove the first char of the string, we are done with it
SET astr=%astr:~1%

:: if the string hasn't reached out delimiter we added, then loop back up and look more
IF NOT %astr% == ----- GOTO searchloop
:complete:
EXIT /B 0