#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <WinAPI.au3>

;Sleeps are in milliseconds
$StandardSleep = 1500

;LogInToSkype()
;LogInToWDE()
;SetAtDeskWDE()

If $CmdLine[0] = 0 Then

	ConsoleWrite(@CRLF & "No function was supplied in arguments!" & @CRLF)
    Exit

EndIf

If $CmdLine[1] Then

	ConsoleWrite("GOT: " & $CmdLine[1] & @CRLF)

	;Dim $UserPass[2]

	$UserPass = ReadCredentials()
	$WDEUserName = $UserPass[0]
	$WDEPassword = $UserPass[1]

	ConsoleWrite("User: " & $WDEUserName & " Pass: " & $WDEPassword & @CRLF)

	If $CmdLine[1] == "LogInToSkype" Then
		ConsoleWrite("Got LogInToSkype" & @CRLF)
		LogInToSkype()
		Exit(0)
	EndIf
	If $CmdLine[1] == "LogInToWDE" Then
		ConsoleWrite("Got LogInToWDE" & @CRLF)
		LogInToWDE()
		Exit(0)
	EndIf
	If $CmdLine[1] == "SetAtDeskWDE" Then
		ConsoleWrite("Got SetAtDeskWDE" & @CRLF)
		SetAtDeskWDE()
		Exit(0)
	EndIf
EndIf

Func ReadCredentials()

	; Reads credentials from /tmp/creds.txt
   Local $FullPath  = _PathFull("..\tmp", @ScriptDir)
   Local $sFileName = $FullPath & "\creds.txt"
   Local $sRes[2]

   Local $UserName = IniRead($sFileName, "Credentials", "User", "nologin")
   Local $Pasword  = IniRead($sFileName, "Credentials", "Pass", "nopass")

   $sRes[0] = $UserName
   $sRes[1] = $Pasword

   return $sRes

EndFunc

Func ClickButtonAtMainWindow($ButtonName)

	; Click button
	; Button can be: "WDE", "Chrome", "Skype"
	; Working with Support Services window

	ConsoleWrite("ClickButtonAtMainWindow start " & @CRLF)
	$MainWindowTitle = "Support Services - \\Remote"
	$MainWindowHandle = FindAWindow($MainWindowTitle, 1)
	Sleep($StandardSleep)
	WinActivate($MainWindowHandle)
	Sleep($StandardSleep)
	ConsoleWrite("Title: " & $MainWindowTitle & " HANDLE: " & $MainWindowHandle & @CRLF)
	$MainWindowPos = GetWindowPos($MainWindowHandle,1)
	Sleep($StandardSleep)

   If $ButtonName == "WDE" Then
	   ClickMouse( ($MainWindowPos[0] + 71), ($MainWindowPos[1] + 91))
   EndIf

   If $ButtonName == "Chrome" Then
	   ClickMouse( ($MainWindowPos[0] + 71), ($MainWindowPos[1] + 117) )
   EndIf

   If $ButtonName == "Skype" Then
	   ClickMouse( ($MainWindowPos[0] + 71), ($MainWindowPos[1] + 147) )
   EndIf

   ConsoleWrite("ClickButtonAtMainWindow end " & @CRLF)

   EndFunc

Func LogInToSkype()

; Buttons are: "WDE", "Chrome", "Skype"
; Opening Skype first
ClickButtonAtMainWindow("Skype")
Sleep($StandardSleep * 5)

; Handling Skype update window here
$SkypeUpdateWindowTitle   = 'First things first.  - \\Remote'
ConsoleWrite("BEFORE : " & @CRLF)
$SkypeUpdateWindowHandle = 555
$SkypeUpdateWindowHandle = FindAWindow($SkypeUpdateWindowTitle, 0)
ConsoleWrite("HANDLE : " & $SkypeUpdateWindowHandle & @CRLF)

; If Window is found - handle is NOT 555
; If Window is not found - handle == 555

If $SkypeUpdateWindowHandle <> 555 Then

	ConsoleWrite("Skype update window present")
	$SkypeUpdateWindowPos = GetWindowPos($SkypeUpdateWindowHandle, 1)

	ClickMouse( ($SkypeUpdateWindowPos[0] * 1.05), ($SkypeUpdateWindowPos[1] * 1.05) )
	Sleep($StandardSleep)

	ClickMouse( ($SkypeUpdateWindowPos[0] + 38), ($SkypeUpdateWindowPos[1] + 178))
	Sleep($StandardSleep)

	ClickMouse( ($SkypeUpdateWindowPos[0] + 430), ($SkypeUpdateWindowPos[1] + 328))
	Sleep($StandardSleep * 3)

EndIf

; Working with Skype window here
$SkypeWindowTitle = 'Skype for Business  - \\Remote'
$SkypeWindowHandle = FindAWindow($SkypeWindowTitle, 0)
Sleep($StandardSleep)

; X: 208 Y: 34
$SkypeWindowPos = GetWindowPos($SkypeWindowHandle, 1)
Sleep($StandardSleep)
WinActivate($SkypeWindowHandle)

;_ArrayDisplay($SkypeWindowPos,"$SkypeWindowPos")
; Click on Skype window area
ClickMouse( ($SkypeWindowPos[0] * 1.05), ($SkypeWindowPos[1] * 1.05) )
Sleep($StandardSleep)

;Options button
; X = 999 Y = 210
ClickMouse( ($SkypeWindowPos[0] + 370), ($SkypeWindowPos[1] + 146))
Sleep($StandardSleep)

;Status in options
ClickMouse( ($SkypeWindowPos[0] + 54),($SkypeWindowPos[1] + 132) )
Sleep($StandardSleep)

;First Time Field
ClickMouse( ($SkypeWindowPos[0] + 674),($SkypeWindowPos[1] + 102))
Sleep($StandardSleep)
;1 Key press = 61 milliseconds 300 * 61 = 18300
HoldAKey( "{UP}", 18300)

;Second Time Field
ClickMouse( ($SkypeWindowPos[0] + 674),($SkypeWindowPos[1] + 133))
Sleep($StandardSleep)
HoldAKey( "{UP}", 18300)

; OK button
ClickMouse( ($SkypeWindowPos[0] + 528),($SkypeWindowPos[1] + 585))
Sleep($StandardSleep)

WinSetState($SkypeWindowHandle, "",  @SW_MINIMIZE)
Sleep($StandardSleep)

EndFunc

Func SetAtDeskWDE()

	;  Call once WDE Logged in
	;  Title: "Workspace - \\Remote"
	;  Set "At Desk" and Turn off Chat

	$WDELoggedInWindowTitle = 'Workspace - \\Remote'
	Sleep($StandardSleep)

	$WDELoggedInHandle = FindAWindow($WDELoggedInWindowTitle, 0)
	ConsoleWrite("hi3")
	Sleep($StandardSleep)

	$WDELoggedInPos = GetWindowPos($WDELoggedInHandle, 1)
	Sleep($StandardSleep)
	WinActivate($WDELoggedInHandle)

	; Click at the name
	ClickMouse( ($WDELoggedInPos[0] + 768),($WDELoggedInPos[1] + 22))
	Sleep($StandardSleep)

	; Change status to "At Desk"
	ClickMouse( ($WDELoggedInPos[0] + 787),($WDELoggedInPos[1] + 105))
	Sleep($StandardSleep)

	; Right click at Chat
	ClickMouse( ($WDELoggedInPos[0] + 82),($WDELoggedInPos[1] + 245), "right")
	Sleep($StandardSleep)

	; Left click at Log Off
	ClickMouse( ($WDELoggedInPos[0] + 90),($WDELoggedInPos[1] + 464) )
	Sleep($StandardSleep)

	;WinSetState($WDELoggedInHandle, "",  @SW_MINIMIZE)
	;Sleep($StandardSleep)
EndFunc

Func LogInToWDE()
	; Clicking WDE button
	ClickButtonAtMainWindow("WDE")
	Sleep($StandardSleep * 4)

	$WDELoginWindowTitle = 'Workspace - Log In - \\Remote'
	$WDELoginWindowHandle = FindAWindow($WDELoginWindowTitle, 0)
	$WDELoginWindowPos = GetWindowPos($WDELoginWindowHandle, 1)
	WinActivate($WDELoginWindowHandle)
	Sleep($StandardSleep * 2)

	; WDE Login field
	ClickMouse( ($WDELoginWindowPos[0] + 180),($WDELoginWindowPos[1] + 137))
	Sleep($StandardSleep)

	; Cleanup
	HoldAKey( "{BACKSPACE}", 600)
	Sleep($StandardSleep)

	; Enter login
	Send($WDEUserName)
	Sleep($StandardSleep)

	; WDE Password field
	ClickMouse(($WDELoginWindowPos[0] + 180),($WDELoginWindowPos[1] + 177))
	Sleep($StandardSleep)

	; Cleanup
	HoldAKey("{BACKSPACE}", 600)
	Sleep($StandardSleep)

	; Enter password
	Send($WDEPassword)
	Sleep($StandardSleep)

	; WDE Log in button
	ClickMouse( ($WDELoginWindowPos[0] + 100),($WDELoginWindowPos[1] + 269))
	Sleep($StandardSleep * 3)

	; "Workspace - Channel Information - \\Remote" ;
	; "+19097932853;ext=1020_Place" - OK button
	ClickMouse( ($WDELoginWindowPos[0] + 100),($WDELoginWindowPos[1] + 300))
	Sleep($StandardSleep * 3)

EndFunc

Func FindAWindow($WindowTitle, $MessageNeeded, $CallingAttempt=1)

	; Retrieve a list of window handles.
	Local $aList = WinList()
	Local $aWindowHandle = 555
	Local $MaxAttempts = 4
	Local $WindowFound = 0

	ConsoleWrite(@CRLF & "FindAWindow start, attempt "& $CallingAttempt & " of " & $MaxAttempts & @CRLF)
	ConsoleWrite("Target: " & $WindowTitle & @CRLF)
	Sleep(500)

	If $CallingAttempt <= $MaxAttempts Then
		; Loop through the array displaying only visible windows with a title.
		For $i = 1 To $aList[0][0]
			If $aList[$i][0] <> "" And BitAND(WinGetState($aList[$i][1]), 2) And $aList[$i][0] == $WindowTitle Then
				If $MessageNeeded == 1 Then
					ConsoleWrite( "Title: " & $aList[$i][0] & @CRLF & "Handle: " & $aList[$i][1] & @CRLF)
				EndIf
				$aWindowHandle = $aList[$i][1]
				ConsoleWrite("Found a window: " & $aWindowHandle & @CRLF)
				$WindowFound = 1
				ExitLoop
			EndIf
			Sleep(10)
		Next
	EndIf

	If ($WindowFound == 0 and $CallingAttempt < $MaxAttempts) Then

		ConsoleWrite("Could not find a window: " & $WindowTitle & @CRLF)
		ConsoleWrite("Current handle: " & $aWindowHandle & @CRLF)
		ConsoleWrite("Retrying ..." & @CRLF)
		Sleep(5000)
		FindAWindow($WindowTitle, 1, $CallingAttempt + 1)

	EndIf

	If ($WindowFound == 0 and $CallingAttempt == $MaxAttempts) Then
		ConsoleWrite("FindAWindow(): reached MaxAttemps: " & $MaxAttempts & " not found " & @CRLF)
		$aWindowHandle = 555
		ConsoleWrite("Current handle: " & $aWindowHandle & @CRLF)
		Return $aWindowHandle
	EndIf

	If $WindowFound == 1 Then
		ConsoleWrite("FindAWindow(): found " & @CRLF)
		ConsoleWrite("Current handle: " & $aWindowHandle & @CRLF)
		Return $aWindowHandle
	EndIf

	; IF NOT THIS LINE - 0 IS RETURNED IN CASE WINDOW IS NOT FOUND
	; REASON IS UNKNOWN - Return on 319 should work but not...
	Return $aWindowHandle

 EndFunc   ;==>Example

Func GetWindowPos($WindowHandle, $MessageNeeded)

   ; Retrieve the position as well as height and width of the active window.
   ConsoleWrite(@CRLF & "GetWindowPos start" & @CRLF)
   ConsoleWrite("Target: " & $WindowHandle & @CRLF)

   Local $aPos = WinGetPos($WindowHandle)

   For $RetryCount = 0 TO 5

   If $aPos[0] = -32000 Or $aPos[1] = -32000 Then
	   ConsoleWrite("Pos failed: " & @CRLF & "X: " & $aPos[0] & @CRLF & "Y: " & $aPos[1] & @CRLF )
	   ConsoleWrite("Retrying..." & @CRLF)
	   Sleep(2000)

	   If Not WinActive($WindowHandle) Then
		   WinActivate($WindowHandle)
		   Sleep(1000)
		   WinWaitActive($WindowHandle)
		EndIf

	   ;WinActivate($WindowHandle)
	   $aPos = WinGetPos($WindowHandle)
	   ConsoleWrite("NewPos: " & @CRLF & "X: " & $aPos[0] & @CRLF & "Y: " & $aPos[1] & @CRLF)
   EndIf
   Next

   If $MessageNeeded == 1 Then
		ConsoleWrite( "X-Pos: " & $aPos[0] & @CRLF & _
         "Y-Pos: " & $aPos[1] & @CRLF & _
         "Width: " & $aPos[2] & @CRLF & _
         "Height: " & $aPos[3] & @CRLF)
   EndIf
   Return $aPos

   ConsoleWrite("GetWindowPos end" & @CRLF)

EndFunc

Func ClickMouse($X, $Y, $type="left")
	;$type = "left" or "right"

	ConsoleWrite(@CRLF & "Click " & $type & @CRLF & "X: " & $X & @CRLF & "Y: " & $Y & @CRLF)
	MouseClick($type, $X, $Y, 1, 4)
	Sleep(1000)
EndFunc

Func HoldAKey($Key, $Time)

   Local $begin = TimerInit()
   Local $i = 0
   Local $TimeToHold = $Time

   Local $CurrentDiff = Round(TimerDiff($begin),2)
   Local $PreviousDiff = 0

   While $CurrentDiff <= $TimeToHold
	  ; 1 Iteration is done in ~ 61 milliseconds
	  $PreviousDiff = $CurrentDiff
	  Send($Key)
	  Sleep(70)
	  $i = $i +1
	  $CurrentDiff = Round(TimerDiff($begin),2)

	  ConsoleWrite("Press: " & $Key & " " & "(" & $i & ")" & "time: " & Round(($CurrentDiff - $PreviousDiff), 1) & "ms" & @CRLF )
   WEnd

EndFunc

Func WinGetControls($Title, $Text="")
Local $WndControls, $aControls, $sLast="", $n=1
$WndControls = WinGetClassList($Title, $Text)
$aControls = StringSplit($WndControls, @CRLF)
Dim $aResult[$aControls[0]+1][2]
For $i = 1 To $aControls[0]
    If $aControls[$i] <> "" Then
        If $sLast = $aControls[$i] Then
            $n+=1
        Else
            $n=1
        EndIf
        $aControls[$i] &= $n
        $sLast = StringTrimRight($aControls[$i],1)
    EndIf
    If $i < $aControls[0] Then
        $aResult[$i][0] = $aControls[$i]
    Else ; last item in array
        $aResult[$i][0] = WinGetTitle($Title) ; return WinTitle
    EndIf
    $aResult[$i][1] = ControlGetHandle($Title, $Text, $aControls[$i])
Next
$aResult[0][0] = "ClassnameNN"
$aResult[0][1] = "Handle"
Return $aResult
EndFunc