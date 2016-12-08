@echo off

:: track valid IPs
set /a valid=0

:: track total IPs
set /a count=0

:: loop over every line in file
for /F "tokens=*" %%A in (input.txt) do (
	CALL :isvalid %%A
)

:: print final valid
echo %valid%

timeout /t 5
EXIT /B 0

::helper function for finding ABBA pattern
:isvalid
:: tells is if we found ABBA in our out of braces
SET foundout=no
SET foundin=no

:: keep track if we are in braces
SET brace=off

:: lop on a delimiter we can use to determine if we are done
SET mystr=%*-----

:loop:
:: grab the next for chars
SET char1=%mystr:~0,1%
SET char2=%mystr:~1,1%
SET char3=%mystr:~2,1%
SET char4=%mystr:~3,1%

:: are we entering a brace
if %char1% == [ set brace=on
if %char1% == [ GOTO continue

:: are we leaving a brace
if %char1% == ] set brace=off
if %char1% == ] GOTO continue

:: if we have a ABBA pattern, and we are in a brace, set appropriate flag
IF %brace% == on IF %char1% == %char4% IF %char2% == %char3% if NOT %char1% == %char2% set foundin=yes

:: if we have a ABBA pattern, and we are out of a brace, set appropriate flag
IF %brace% == off IF %char1% == %char4% IF %char2% == %char3% if NOT %char1% == %char2% set foundout=yes

:: if we found ABBA in a brace, we reset the fact we found it out and finish up, not a valid IP
IF %foundin% == yes set foundout=no
IF %foundin% == yes GOTO finish

:continue
:: remove the first char of the string, we are done with it
SET mystr=%mystr:~1%

:: if the string hasn't reached out delimiter we added, then loop back up and look more
IF NOT %mystr% == ----- GOTO loop
:finish:

:: if foundout is still set, we found a valid IP
IF %foundout% == yes set /a valid+=1
IF %foundout% == yes echo %*
set /a count+=1
echo %count%--%valid%
EXIT /B 0