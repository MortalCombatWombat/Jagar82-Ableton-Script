;INSTALLATION STEPS

;1. Download and install Autohotkey v2: https://www.autohotkey.com/
;2. Download and install Sharpkeys: https://github.com/randyrants/sharpkeys - https://apps.microsoft.com/store/detail/XPFFCG7M673D4F?ocid=pdpshare. Remap Right Control and Right Alt to any key you wish . I did it with Caps Lock (RCtrl) and < (RAlt).
;3. Activate "Use Tab Key to Move Focus" (pretty much all of the shortcuts won't work or will go crazy if you don't) - Settings / Use Tab Key to Navigate & Wrap Tab Navigation / ON.
;4. Feel the power ᕙ(⇀‸↼‶)ᕗ  (Don't forget that you can modify all of this to your taste and even upload it; just remember to link this repo and credit it. MIT License B) ).

;NOTE: Quick Inserts can't sort out your favorite devices in the Ableton browser. To use it more accurately, activate the "Rank" filter in the browser so it sorts by your most used FX/Devices.

;If you know Max For Live or Live's API and want to collaborate with this project, please hit me up at jagarj82@gmail.com. Thank you in advance.

;(Hope you enjoy :D)

;TO-DO

; Optional: Show a notification when done
;I hate that in the device and midi clip panels you can't just scroll with the scroll wheel on your mouse. You have to go all the way to the bottom right and drag the stupid scroll thingy.
;Try to find a better way to make chords than LES
;Ctrl CLick in the GUI to just search the plugin but not insert it
;Alt + click or arrow to create a new return and insert it.
;ENCONTRAR COMO CARAJOS LES USA LA TECLA TILDE. SI se pudiese definir como funcion para invocar RCtrl internamente del script (Lo que es dificil, ya que esta asignacion es de bajo nivel, y para hacerla funcion como modificadora internamente seria un gallo para leer)
;TO-DO: Ventana de ayuda para cada GUI
;TO-DO: Guis with variable auto color
;BackColor
;Retrieves or sets the background color of the window.
;CurrentColor := MyGui.BackColor
;MyGui.BackColor := NewColor
;https://www.autohotkey.com/docs/v2/lib/Gui.htm#Appear
;TO-DO: FALTA PODER CERRARL TODAS LAS GUIS CON ESCAPE O CTRL W

;----------------------------------------------------------- GLOBAL ------------------------------------------------------------------------;

#Persistent
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
#InstallKeybdHook
#UseHook
#MaxHotkeysPerInterval 369

;----------------------------------------------------------- REMAP KEYS ------------------------------------------------------------------------;

;vke2::RAlt

;------------------------------------------------------------------------------------------------------------------------------------------;

; TO DO: DESTROY ANY PREVIOUS GUI
;PENDING STATUS INDICATOR    vStatusIcon cGreen, ON 

SetTitleMatchMode, Fast
SetTitleMatchMode, 2  ; Allows partial matches

Numpad2::
WinGetActiveTitle, OutputVar
    If InStr(OutputVar, "Ableton Live 12") 
    
{
    Gui, Destroy
    Gosub, CreateGUI
}
Else
{
    Reload  ; Reloads the script
    Gosub, CreateGUI
    
}
Return

0::

;Prevents overlapping windows while not affecting the global control GUI itself
Gui, Destroy
CreateGUI:

Gui, Font, s15 cWhite
Gui, Add, Text, x30 y25, Script Options  ; THis is part of what will be the GUIS common style
Gui, Color, 8c8c8c
Gui, Font,  Segoe UI, S10 4b4b4e
Gui, +ToolWindow -MinimizeBox SysMenu  ;Add a variable to customize this

heightScriptOptions := 29
widthScriptOptions := 185
buttonSeparationScriptOptions := 13


; TO DO Find a way to make it a single button for all GUIS: Dynamic description
Gui, Add, Button, x+40 y25 w25 h25 gShowGlobalHelp, ?


Gui, Add, Button, x31 y+25 w%widthScriptOptions% h%heightScriptOptions% gReload, &Reload
Gui, Add, Button, y+%buttonSeparationScriptOptions% w%widthScriptOptions% h%heightScriptOptions% gPauseScript, &Suspend And Pause
Gui, Add, Button, y+%buttonSeparationScriptOptions% w%widthScriptOptions% h%heightScriptOptions% gEditScript, &Edit in Text Editor
Gui, Add, Button, y+%buttonSeparationScriptOptions% w%widthScriptOptions% h%heightScriptOptions% gExitScript, E&xit Script
;Gui, Add, Button, y+%buttonSeparationScriptOptions% w%widthScriptOptions% h%heightScriptOptions% gExitScript, E&xit Script

Gui, Show, w245 h260 Center, Script Options 

global PauseToggle := false

Return

#IfWinActive, Script Options

;Keyboard shortcuts 

R::Reload
   
P::
    GoSub, PauseScript
    Return

S::
    GoSub, PauseScript
    Return    

E::
    GoSub, EditScript
    Return
    
X::
    GoSub, ExitScript
    Return

#IfWinActive  ; End the active window condition

;INSTEAD OF A TOOLTIP ADD A DYNAMIC SUBTITLE THAT MOVES BUTTONS DOWN

PauseScript:
    PauseToggle := !PauseToggle

    if (PauseToggle) 
    {
        Suspend, On
        Pause, On
        ToolTip, Script Pausado
    } 
    else 
    {
        Suspend, Off
        Pause, Off
        ToolTip, Script Activado
        SetTimer, RemoveToolTip, -2000
    }
    Return  

RemoveToolTip:
    ToolTip
    Return    
    
Reload:
    Reload
    Return

EditScript:
    Edit
    Return    

ExitScript:
    ExitApp
    Return

KeyHistory:  ; KEY HISTORY
    KeyHistory
    Return

ShowGlobalHelp:
    Gui, 2:New
    Gui, 2:Font, s10
    Gui, 2:Add, Text, w260, This tool lets you reload, suspend and pause, edit in your chosen text editor or terminate the script.
    Gui, 2:Show,, Script Options Help
return    

; OJO, aca el IfWinActive de la GUI NO ESTA, ver si esto repercute.

;-------------------------------- MEDIA PAUSE --------------------------------;

;(RAlt + Space: Sends Play/Pause to Live) 

RAlt & Space::
SetTitleMatchMode, 2
ControlSend, , {Space}, Ableton Live 
Return

 ;-------------------------------- GROUP EDIT --------------------------------;

#IfWinActive ahk_exe Ableton Live 12 Suite.exe

;-------------------------------- KEEP TAB AS SESSION / ARRANGEMENT VIEW SWITCH --------------------------------;

;(Tab: Switch between Arrangement and Session view)

toggle := true
Tab::
    WinGetActiveTitle, OutputVar
    If InStr(OutputVar, "Ableton Live 12") 
    
        {    
            toggle := !toggle
            
            if (!toggle) 
            
                {Send, !{1}
                
            } else {
                Send, !{2}
            }
            Return      
        }
    Else
        { 
            Send {tab}
        }
    Return  

;(Bypass:: Send Tab to navigate with Tab + 1)

Tab & 1::Send {tab}

!Tab::Send !{tab}

;-------------------------------- KEEP SHIFT + TAB AS CLIP / DEVICE VIEW SWITCH --------------------------------;

;(Shift + Tab: Switch between Clip and Device View)

toggle := true
+Tab::
    WinGetActiveTitle, OutputVar
    If InStr(OutputVar, "Ableton Live 12") 
    
        {       
            Send {f12}
        }
    Else
        {
            Send {tab}
        }
    Return  

;(Bypass:: Send Shift + Tab to navigate with Tab + 2)

Tab & 2::Send +{tab}

;-------------------------------- KEEP CTRL + TAB AS EDITOR VIEW MODES SWITCH --------------------------------;

;(Ctrl + Tab:: Switch Editor View modes (Forward) )

; TO DO? DO I FOCUS THE CLIP AUTOMATICALLY OR NOT?

^Tab::Send ^{tab}

;(Ctrl + Tab:: Switch Editor View modes (Backwards) )

^+Tab::Send ^+{tab}

;-------------------------------- FOCUS VIEWS / MENU --------------------------------;

;These hotkeys are designed to access different views more intuitively pressing Tab + Initial letter

;(Tab + Initial: Focus view / menu {Clip, Device, File Manager})

Tab & K::Send !{0} ;Control Bar

Tab & S::Send !{1} ;Session View

Tab & A::Send !{2} ;Arrangement View

Tab & C::Send !{3} ;Clip View

Tab & E::Send !{3} ;Clip View

Tab & D::Send !{4} ;Device View

Tab & B::Send !{5} ;Browser

Tab & G::Send !{6} ;Groove Pool

Tab & H::Send !{7} ;Help View

Tab & I::Send {?} ;Info View

Tab & M::Send ^!{m} ;Mixer

Tab & O::Send ^!{o} ;Overview

Tab & T:: ;Tuning
Send !{n}
Send {t}
return

;--------------------------- TOGGLE TRACK OPTIONS ---------------------------;

;TO-DO: Make a GUI for this instead

;(Ctrl + Win + T: Toggle Arrangement Track Options)

^#o:: 
Send !{v}
Send {a 4}
Send {enter}
Send {t}
return

;(Ctrl + Win + Shift + T: Toggle Mixer Track Options)

^+#o:: 
Send !{v}
Send {m 3}
Send {enter}
Send {t}
return

;-------------------------------- SHOW / HIDE  DEVICES ON SLOTS --------------------------------;

;(Warning: The Options.txt file must contain -ShowDeviceSlots)

;TO DO Maybe retrieve info from Live Version, then modify the TXT.

;C:\Users\?\AppData\Roaming\Ableton\Live 12.?\Preferences)

;(Shift + M: Show / Hide Devices Slots) 

^#d::
Send !{v}
Send {m 3}
Send {enter}
Send {d}
return

;-------------------------------- TAB NAVIGATION FUNCTION --------------------------------;

;TO DO OR TO KILL

TabNavNext(TabNavNext)
{
BlockInput On
Send {Alt}
Send {Right 5}
Send {n}
BlockInput Off
}
Return

TabNavPrev(TabNavPrev)
{
BlockInput On
Send {Alt}
Send {Right 5}
Send {Enter}
Send {p}
BlockInput Off
}
Return

;-------------------------------- SHOW EXPANDED VIEW / OPEN PLUGIN WINDOW --------------------------------;

;(Ctrl + Alt + W): Show Expanded View / Open focused VST  

^!w::
    ;WinGetTitle, OutputVar, 
    ;If InStr(OutputVar, "Ableton Live 12") 
    {
Sleep, 50
        Send {Esc} ;Unfocuses currently selected item / view
        Sleep, 10
        Send {Esc}
        Sleep, 10
        Send {Esc}
        Send !{4}    
        Send {Esc 2} ;Unfocuses currently selected device / parameter
        Send {+}
        Sleep, 10
        Send {tab 2}
        Send {down}
        Send {up}
        Send {tab}
        Send {down}
        Send {up}
        Send {Esc}
    }
Return

;-------------------------------- HIDE EXPANDED VIEW / CLOSE WINDOWS --------------------------------;

;(Ctrl + W) Hide Expanded View / Close focused window

~^w::
KeyWait, w
KeyWait, w, D T0.3  ; Wait for second press within 300ms
if ErrorLevel  ; Timeout (single-press)
{

    Sleep, 50
    WinGetActiveTitle, OutputVar  ; Differs from WinGetTitle
    If InStr(OutputVar, "Ableton Live 12")
    {
        Send {Esc 2} ;Unfocuses currently selected item / view
        Send !{4}    
        Send {Esc 2} ;Unfocuses currently selected device / parameter
        Send {+}
        Sleep, 10
        Send {tab 2}
        Send {down}
        Send {tab}
        Send {down}
        Send {Esc}
    }
    else
    {
        Send !{F4}
        Sleep, 10
        Send {Esc 2}  ; Added double Escape after closing plugin
    }
}
else 

;Hidden Feature: Show Expanded View / Open focused VST double pressing Ctrl + W

{
    WinGetActiveTitle, OutputVar  ; Get ACTIVE window title - was missing 'Active'
    If InStr(OutputVar, "Ableton Live 12") 
    {
        Sleep, 50
        Send {Esc} ;Unfocuses currently selected item / view
        Sleep, 10
        Send {Esc}
        Sleep, 10
        Send {Esc}
        Send !{4}    
        Send {Esc 2} ;Unfocuses currently selected device / parameter
        Send {+}
        Sleep, 10
        Send {tab 2}
        Send {down}
        Send {up}
        Send {tab}
        Send {down}
        Send {up}
        Send {Esc}
    }
    else
    {
        Send ^{w}
        Send !{F4}
        Sleep, 10
        Send {Esc 2}  ; Added double Escape after closing plugin
    }
}
return

;-------------------------------- CLOSE ALL WINDOWS WITHIN LIVE --------------------------------;

;TO DOs

;(Ctrl + Alt + +Shift + W / Ctrl + Alt + P): Close all windows within Live

^!p:: 
^p::
^!+w::
    IfWinActive, Ableton Live
    {
        ; Store the Ableton window ID
        WinGet, mainAbletonID, ID, A
        
        ; Close all windows except the main Ableton window
        WinGet, openWindows, List, ahk_exe Ableton Live.exe
        Loop, %openWindows%
        {
            winID := openWindows%A_Index%
            
            ; Don't close the main Ableton window
            if (winID != mainAbletonID)
            {
                WinClose, ahk_id %winID%
            }
        }
        ; Clean up interface
        Sleep, 100
        Send, {Esc 2}
    }
Return

;----------------------------------------------- SEARCH -----------------------------------------------;

;-------------------------------- SEARCH TRACKS & CLIPS --------------------------------;

;(Ctrl+Shift+F: Search in selected folder (This could be replaced for a M4L Search Device, for example) )

;-------------------------------- OPEN FILE LOCATION / REVEAL IN EXPLORER --------------------------------;

;Ctrl + Menu / Enter: Open file location in Browser

^AppsKey::
BlockInput On ;Blocks user input 
Send +{F10}
SendRaw r ;Focuses Rename, so it doesn't do any crazy stuff if you use the hotkey with other UI items 
Sleep, 550 ;Gives enough time to send the text
;550
SendRaw Show in 
;Places, Browser
Send {Enter} ;Enter. If Rename was focused, does nothing. In Tracks it shows Take Lanes so, no problemo?
BlockInput Off
return

;----------------------------------------------------------- TRACKS AND EFFECTS ------------------------------------------------------------------------;

;-------------------------------- QUICK EFFECTS --------------------------------;


;----------------------------------------------------------- TRACKS AND EFFECTS ------------------------------------------------------------------------;

;---------------------------------------------------------------- EDITING -------------------------------------------------------------------;

;-------------------------------- CONSOLIDATE / INSERT MIDI TRACKS WITH CTRL + J --------------------------------;

;TO DO: make it optional
;(Ctrl + J: Insert MIDI clip / Consolidate)

^j::
Send ^+{m}
Send ^{j}
Return

;-------------------------------- DISABLE LOOP WHEN CREATING CLIPS WITH CTRL+M --------------------------------;

^+m::
Send ^+{m}
Send ^{j}
Return

;--------- QUANTIZE --------;

;(Ctrl + Q: Quick Quantize)

^q::Send ^{u}

;(Ctrl + Q or Ctrl + Alt + Q: Adjust Quantize)

^+q::Send ^+{u}

^!q::Send ^+{u}

;TO DO: make it optional

;---------------------------------------------------------------- DUPLICATE OVERWRITING CLIPS --------------------------------------------------------------------;

^!d::
Send ^{c}
Send ^{d}
Send {Backspace}
Send ^{v}
return

;---------------------------------------------------------------- PASTE OVERWRITING CLIPS --------------------------------------------------------------------;

^!v::
Send {Backspace}
Send ^{v}
return

;---------------------------------------------------------------- MULTIPLY X TIMES --------------------------------------------------------------------; 

;(Ctrl + Alt + Shift + D): Multiply entire sections;

^+!d::

    ; Create GUI
    Gui, Destroy ; Clear any previous GUI
    ;Gui, +AlwaysOnTop -MinimizeBox 
    Gui, +AlwaysOnTop +ToolWindow -MinimizeBox Caption
 ;Add a variable to customize this

    
    Gui, Color, 8c8c8c

    ; Title
    Gui, Font, s15 CWhite
    Gui, Add, Text, x20 y22, Multiply Section
    Gui, Font, s15 CWhite
    Gui, Font,  Segoe UI, S10 4b4b4e

    
    ; Input field with default value of 4 
    Gui, Font, s10 cBlack
    Gui, Add, Edit, x20 y+15 w200 h25 vDuplicateTimes Number, 4
    
    ; Options
    Gui, Font, s15 CWhite
    Gui, Font,  Segoe UI, S10 4b4b4e
    Gui, Add, Radio, x20 y+20 vDuplicateType Checked, Overwriting Clips ( Ctrl+D )
    Gui, Add, Radio, x20 y+5, Shifting Clips ( Ctrl+Shift+D )
    
    ; Buttons
    Gui, Font, s10 cBlack
    Gui, Add, Button, x20 y170 w100 Default gPerformDuplicate, Duplicate
    Gui, Add, Button, x+10 y170 w90 gCancelDuplicate, Cancel
    
    ; Show GUI
    Gui, Show, w240 h230, Multiply Section
Return

; Handle duplication
PerformDuplicate:
    ; Get values from GUI
    Gui, Submit
    
    ; Subtract 1 from the input value
    ActualDuplicates := DuplicateTimes - 1
    
    ; Safety check - ensure we have a valid number
    if (ActualDuplicates < 0) {
        ActualDuplicates := 0
    }
    
    ; Select entire section
    Send ^{l}
    Send ^+{l}
    
    ; Perform duplication based on selected type
    if (DuplicateType = 1) {
        ; Normal duplication
        Loop, %ActualDuplicates% {
            Send ^d
        }
    } else {
        ; Shifting duplication
        Loop, %ActualDuplicates% {
            Send ^+d
        }
    }
    
    ; Deselect section
    Send ^{l}
Return

; Cancel button
CancelDuplicate:
    Gui, Destroy
Return

; Close GUI with Escape key
GuiEscape:
    Gui, Destroy
Return

;---------------------------------------------------------------- REDO  REMAP --------------------------------------------------------------------;

;(Ctrl + Shift+ Z: Redo) 

^+z::Send ^{y}

;-------------------------------- INSERT MIDI CLIP/NOTE --------------------------------;

;(RCtrl + Left Click: Places a MIDI note or clip)

RCtrl & LButton::
BlockInput, On
Send ^+{m}
Send ^{j}
Send {LButton Down}
Send {LButton Down}
BlockInput, Off
Return

RCtrl & LButton Up::
BlockInput, On
Send {LButton Up}
Send {LButton Up}
BlockInput, Off
Return

;-------------------------------- QUICK CUT --------------------------------;

;(RCtrl + Right Click: Cut)

RCtrl & RButton::Send ^{x}

;-------------------------------- CLEAR TRACK CONTENT --------------------------------;

;(Ctrl + Alt + Shift + X: Clear track content)

;(Shift + Delete: Clear track content)

^!+x::
BlockInput On ;Blocks user input 
Send {RButton}
Send {r} ;Focuses rename, so it doesn't do any crazy stuff if you select other UI items 
Sleep, 570 ;Gives enough time to send the text
Send Select Track Content
Send {Enter}
Send {Backspace}
BlockInput Off
return

;---------------------------------------------------------------- CHORD BUILDER --------------------------------------------------------------------;

;(F1: Mayor Chord)    
;(F2: Minor Chord)
;(F3: Augmented Chord)
;(F4: Diminished Chord)

; Press 1 time for a Triad, 2 times for 7th, 3 times for 9th. This applies to all chords.

;#IfWinActive

    ;--------- MAJOR ---------;
    
    f1::   

    if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorChordM2, 400 
    
    return
    
    KeyPressMonitorChordM2:
    if (KeyPressCount = 1) 
    {
    
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    }
    else if (KeyPressCount = 2)
    {
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;7th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    }
    else if (KeyPressCount= 3)	
    {	
    
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;7th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;9th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    }
    KeyPressCount := 0 
    SetTimer, KeyPressMonitorChordM2, Off 
    return
    
    ;--------- MINOR ---------;
    
    f2::   

    if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorChordN2, 400 
    
    return
    
    KeyPressMonitorChordN2:
    if (KeyPressCount = 1) 
    {
    
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    }
    else if (KeyPressCount = 2)
    {
    
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;7th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    }
    else if (KeyPressCount= 3)	
    {	
    
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;7th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;9th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    }
    KeyPressCount := 0 
    SetTimer, KeyPressMonitorChordN2, Off 
    return
    
    ;--------- AUGMENTED ---------;

    f3::   

    if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorChordA2, 400 
    
    return
    
    KeyPressMonitorChordA2:
    if (KeyPressCount = 1) 
    {
    
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    }
    else if (KeyPressCount = 2)
    {
    
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;7th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    }
    else if (KeyPressCount= 3)	
    {	
    
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;7th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;9th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    }
    KeyPressCount := 0 
    SetTimer, KeyPressMonitorChordA2, Off 
    return
    
    ;--------- DIMINISHED ---------;
    
    f4::   
    
    if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorChordD2, 400 
    
    return
    
    KeyPressMonitorChordD2:
    if (KeyPressCount = 1) 
    {
    
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    }
    else if (KeyPressCount = 2)
    {
    
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;7th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    }
    else if (KeyPressCount= 3)	
    {	
    
    ;3rd
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;5th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    ;7th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    Send {up}
    
    ;9th
    Send ^{c}
    Send ^{v}
    Send {up}
    Send {up}
    Send {up}
    
    }
    KeyPressCount := 0 
    SetTimer, KeyPressMonitorChordD2, Off 
    return    

;-------------------------------- TOGGLE TRACKS ON / OFF --------------------------------;

; TO DO

;ESTO TAMBIEN SE VA

;Shift+Function (1 to 9): Bypass and toggle tracks as usual

+f1::Send {f1}
+f2::Send {f2}
+f3::Send {f3}
+f4::Send {f4}
+f5::Send {f5}
+f6::Send {f6}
+f7::Send {f7}
+f8::Send {f8}
+f9::Send {f9}

;-------------------------------- SLICE NOTES --------------------------------;

;--------- SLICE ON CURSOR POSITION ---------;

;(Shift + 1: Slice over cursor position)

RCtrl & 1::
send, +{e  down}
Send, {LButton}
sleep 10
send, +{e up}
Return

;---------FAST SLICE (SHIFT+NUM) (2-9)---------;

;(RCtrl + 2 to 9: Slice in X) 

Slices(slices)
{
BlockInput On
Send {Blind}{Ctrl down}
Send {e}
Send {Up %slices%}
Send {Ctrl up}
BlockInput Off
}
Return

RCtrl & 2::Slices(1) ;Number of Slices -1
RCtrl & 3::Slices(2)
RCtrl & 4::Slices(3)
RCtrl & 5::Slices(4)
RCtrl & 6::Slices(5)
RCtrl & 7::Slices(6)
RCtrl & 8::Slices(7)
RCtrl & 9::Slices(8)

;-------------------------------- PITCH AND TIME UTILITIES --------------------------------;

;TOCA EXPLICARLOS BIEN

;These hotkeys are designed to edit MIDI Clips exclusively. Using them to edit Audio clips will result in bizarre behavior.

PitchTimeUtility(tab, truefalse) ;Focus the Pitch and Time Utility acording to the %tab% variable
{
BlockInput On
Send !{v}
Send {a 2} ; Arrange Clip View Panels Horizontally
Send {enter}
Send !{3}
Send !+{p}
Send {Esc}
Send {right 4}
Send {left 4}
Send {right 2}
Send {tab %tab%}
BlockInput Off
Send {enter %truefalse%} 
if (truefalse = 1) { ;Check if enter is pressed. If True (1), focuses the MIDI Editor again. If False (0), waits for enter to focus the Editor.
    Send !{3}
   ; else
   ; {
        ;Wait for enter
   ; }
}
}
return

;(RShift + R: Reverse) 
RCtrl & r::PitchTimeUtility("13","1")

;(RShift + L: Legato)
RCtrl & l::PitchTimeUtility("14","1")

;(RShift + I: Invert)
RCtrl & i::PitchTimeUtility("3","1")

;(RShift + Z: Stretch)
RCtrl & z::PitchTimeUtility("6","0")

;(RShift + T: Add Interval)
RCtrl & t::PitchTimeUtility("4","0")

;(RShift + K: Fit To Scale) 
RCtrl & k::PitchTimeUtility("2","1")

;(RShift + H: Humanize)
RCtrl & h::PitchTimeUtility("11","0")

;( / - *: Stretch by 2)
; Live can't receive this (As Key) for some reason, or maybe its ahk lol

;*::
;Audio:
;Go to seven (BPM), retrieve value, multiply by 2 and enter. In MIDI Clips

PitchTimeUtility("7","1")
return

RCtrl & /::
PitchTimeUtility("8","1")
return

;-------------------------------- SWITCH AUDIO DRIVER --------------------------------;

;-In Development ;Gui to Type the drivers you wanna alternate between, then it works with the shortcut,

;Usar el submit de Quick Effects 2

; es mejor dejar este shorcut para la configuracion del script
; ctrl shift , 

; TO DO

toggle := true
;^.::
WinActivate, ahk_class Ableton Live Window Class

BlockInput On
Send {Escape 2}
Send !{1} 
Sleep, 300
Send !{2} 
Sleep, 300 
Send ^{t}
Send ^{r}
 Sleep, 300  
Send +{u}
Send {tab 7}
Sleep, 300  
Send {enter}
Sleep, 300
SendRaw Configure ; Doesn't work for MIDI clips
Sleep, 300
Send {enter}
Send {tab 2}
Send {enter}
        {    
            toggle := !toggle
            
            if (!toggle) 
            
                {
                    SendRaw FL Studio ASIO
                    Send {enter}
                
            } else {

                SendRaw Studio USB ASIO Driver
                Send {enter}
            }
            Return      
        }  

;Sleep, 300
SendInput {Escape 2}

Sleep, 200
Send !{2}
Send ^{w}
Send ^{w}
Send {Del}
    
BlockInput Off
Return 


;Chord Script RECUPERADO

;GetClientPos: Retrieves the position and size of the window's client area.
;GetPos: Retrieves the position and size of the window.
;OnEvent: Registers a function or method to be called when the given event is raised.
;FocusedCtrl: Retrieves the GuiControl object of the window's focused control.
;Title: Retrieves or sets the window's title.
;ListBox:

;-------------------------------------------------------------------------------------------------------------------------

;revisar el sync DONE
;Funcion de borrado completo del acorde
;Poner titulo  DONE
;Poner botones de ayuda y tooltips DONE

;DELETE WHEN THIS IS SET IN THE MAIN SCRIPT


; Shift+ arrow selects a grid block of the grid
; if you press control e after selecting the time, the chop tool is gonna act only there
; ctrl + arrows let you move in the clip by jumping to the location of the next note
; and by pressing ctrl up you select the lowest note

;--------------------------------------- GLOBAL ---------------------------------------

;SE VA 



;XXXXXXXXXXXX

SetTitleMatchMode, Fast
SetTitleMatchMode, 2  ; Allows partial matches

Numpad2::
WinGetActiveTitle, OutputVar
    If InStr(OutputVar, "Ableton Live 12") 
    
{
    Gui, Destroy
    Gosub, CreateChordsGUI
}
Else
{
    Reload  ; Reloads the script
    Gosub, CreateChordsGUI
    
}
Return

CreateChordsGUI:
Gui, Font, s15 CWhite
Gui, Add, Text, x30 y20, Chord Progression Generator
Gui, Font,  Segoe UI, S10 4b4b4e
Gui, Add, Button, x+30 w23 h23 gShowHelp, ?

Gui, Color, 8c8c8c
Gui, +AlwaysOnTop -MinimizeBox 

Gui, Show, w385 h160 Center y100, Chord Progression Generator   ; hscroll horizontal scroll

SyncHeight:= 22
SyncWidth:= 55
EverythingX:= 30

Gui, Add, DropDownList, x%EverythingX% y60 w60 vRootSelect, C|C#/Db|D|D#/Eb|E|F|F#/Gb|G|G#/Ab|A|A#/Bb|B|
Gui, Add, Button, x+15 w%SyncWidth% h%SyncHeight% gRootSync, Sync

;!Error: The same variable cannot be used for more than one control

Gui, Add, DropDownList, x+15 w100 vModeSelect, Major|Minor|Dorian|Mixolydian|Lydian|Phrygian|Locrian|Whole Tone|Half whole Dim.|Whole half Dim.|Minor Blues|Minor Pentatonic|Major Pentatonic|Harmonic Minor|Harmonic Major|Dorian #4|Phrygian Dominant|Melodic Minor|Lydian Augmented|Lydian Dominant|Super Locrian|8-Tone Spanish|Bhairav|Hungarian Minor|Hirajoshi|In-Sen|Iwato|Kumoi|Pelog Selisir|Pelog Tembug|Messiaen 3|Messiaen 4|Messiaen 5|Messiaen 6|Messiaen 7|
Gui, Add, Button, x+15 w%SyncWidth% h%SyncHeight% gModeSync, Sync

; This is a way to simplify GUI objects creating and positioning them Automatically

xPos := 30
yPos := 105
DegreesWidth := 30
DegreesHeight := 25
Spacing := 12

Loop, 7 {
    gLabel := A_Index . "degree"
    Gui, Add, Button, x%xPos% y%yPos% w%DegreesWidth% h%DegreesHeight% g%gLabel%, %A_Index%
    xPos += DegreesWidth + Spacing
}
Return

;----------------------------------------------------------- DEGREES LABELS ------------------------------------------------------------------------;

;Interesting: the delete root note sequence is only triggering via keyboard shortcuts but not by clicking the number

;Variables explanation: 
;1 Distance in scale degrees from root; the second one corresponds to the n
;2 Number of notes of the chord - 1(the root is already there) and the third 
;3 Allows a modifier used because the third degree works weird

#IfWinActive ahk_exe AutoHotkeyU64.exe

1degree:
*1::
Gosub, FirstDegree
Return

2degree:
*2::
AnyOtherDegree(1,2)
Return

3degree:
*3::
Gosub, ThirdDegree
Return

4degree:
*4::
AnyOtherDegree(3,2)
Return

5degree:
*5::
AnyOtherDegree(4,2)
Return

6degree:
*6::
AnyOtherDegree(5,2)
Return

7degree:
*7::
AnyOtherDegree(6,2)
Return

;----------------------------------------------------------- ROOT LABELS ------------------------------------------------------------------------;

RootSync:
Gui, Submit
AutoSetRoot(RootSelect)
Return

ModeSync:
Gui,Submit
AutoSetMode(ModeSelect)
Return

ChordsHelp:
Gui, Show, MsgBox, This is penis
Return

#IfWinActive

;----------------------------------------------------------- DEGREES FUNCTIONS  ------------------------------------------------------------------------;

FirstDegree:
BlockInput, On
WinActivate, ahk_class Ableton Live Window Class
Send !{3}
Send ^{d}
Send ^{left}
Send !{3}
PitchTimeUtility("4","0")
Send {2}
Send {enter 3}
Send !{3}
Send ^{up}
WinActivate, ahk_exe AutoHotkeyU64.exe
BlockInput, Off
Return

ThirdDegree:
BlockInput, On
WinActivate, ahk_class Ableton Live Window Class
Send !{3}
Send ^{d}
Send ^{left}
Send !{3}
PitchTimeUtility("4","0")
Send {1}
Send ^{enter}
Send {2}
Send {enter 3}
Send !{3}
Send ^{down 3}
Send {Delete}
Send ^{up 4}
WinActivate, ahk_exe AutoHotkeyU64.exe
BlockInput, Off
Return

AnyOtherDegree(DegreesFromRootNote, ChordNotesNumber)
{
    BlockInput, On
    WinActivate, ahk_class Ableton Live Window Class
    Send !{3}
    Send ^{d}
    Send ^{left}
    Send !{3}

    ;SendRaw 66
    PitchTimeUtility("4","0")
    Send {%DegreesFromRootNote%}
    Send {enter}
    ;Send !{3}
    ;SendRaw 120
    Send ^{enter}
    SendRaw 2
    Send {enter %ChordNotesNumber%}
    ; Cannot contain functions within functions neither call gotos outside of the function
    ; so we'll handle the delete right here
    {
        Send !{3}
        downCount := ChordNotesNumber + 1 
        Loop, %downCount% 
        {
            Send ^{down}
            ;Sleep, 20
        }
        Send {Delete}
        Send !{3}

        Loop, %downCount% 
            {
                Send ^{up}
                ;Sleep, 20
            }
        Send ^{up}
        WinActivate, ahk_exe AutoHotkeyU64.exe 
    }
BlockInput, Off
}
Return


;----------------------------------------------------------- FUNCTIONS AND LABELS ------------------------------------------------------------------------;

AutoSetRoot(RootSelect)
{
WinActivate, ahk_class Ableton Live Window Class
BlockInput On
Send !{v}
Send {a 2} ; Arrange Clip View Panels Horizontally
Send {enter}
Send !{3}
Send !+{p}
Send {Esc}
Send {left 4}
Send {tab 24} ;This focuses the Scale Mode for clips
Send {Up}
Send {tab}
Send {Enter} ; Opens the Live Root Note Dropdown

    Send %RootSelect% ; This is a scale variable retrieved via GUI
    Sleep, 50
    Send {Enter}
 
Return
BlockInput Off
}


AutoSetMode(ModeSelect)
{
WinActivate, ahk_class Ableton Live Window Class
BlockInput On
Send !{v}
Send {a 2} ; Arrange Clip View Panels Horizontally
Send {enter}
Send !{3}
Send !+{p}
Send {Esc}
Send {left 4}
Send {tab 24} ;This focuses the Scale Mode for clips
Send {Up}
Send {tab 2}
Send {Enter}

    Send %ModeSelect%
    Sleep, 50
    Send {Enter}

Return 
BlockInput Off
}

HuntRoot()
{
BlockInput On
Send !{v}
Send {a 2} ; Arrange Clip View Panels Horizontally
Send {enter}
Send !{3}
Send !+{p}
Send {Esc}
Send {left 4}
Send {right 2}
Send {tab 15} ;This focuses the Scale Mode for clips
Send {Enter} 
SendRaw V
Send {Enter} 
Send {tab}
SendRaw 66 Sends the unique value which will be deleted 
Send {Enter} 
SendRaw 66   
Send {Enter}  
Send {tab 2}
Send {Enter}
Send {Delete}
}
Return

DeleteChord:
Send +{Up}
Send ^{X}
Return

;DOS METODOS

;0::   ; El canal debe estar armado y el midi input con teclado activo
Send !{3}
Sleep, 500
Send {h}  ; A is the root
Sleep, 500
Send {right}
Send +{down 6}
Send +{up 5} ; Now C is the root note
Return

;+0::
Send !{3}
Send {z 10} ; -2 Octave
Send {x 5} ; Third Octave
Send {AppsKey}
Sleep, 50
Send {1}
Sleep, 50
Send {Enter}
Send {h down}  ; A is the root
Sleep, 500  
Send {right}
Send {h up}


Return

;!0::

BlockInput On
Send !{v}
Send {a 2} ; Arrange Clip View Panels Horizontally
Send {enter}
Send !{3}
Send !+{p}
Send {Esc}
Send {left 4}
Send {right 4}
Send {tab 2}
Send {up 15}
Send {down 2}
Send {tab 2}
Sleep, 200
Send %RootSelect% 
Sleep, 200
Send {enter}
Send {tab}
Send %RootSelect%
Sleep, 200
Send {enter}
Send {tab 3}
SendRaw {0}
Send {enter}
Send ^{enter}
Return



;Send {up 0}  ; C
;Send {up 1}   ; C#
;Send {up 2} ; D
;Send {up 3} ; D#
;Send {up 4} ; E
;Send {up 5} ; F
;Send {up 6} ; F#
;Send {up 7} ; G
;Send {up 8} ; G#
;Send {up 9} ; A
;Send {up 10} ; A#
;Send {up 11} ; B
;Send {up 12}  ; C


;!1::
;ssSend 

    StepsFromC := { "C":0
                 , "C#/Db":1
                 , "D":2
                 , "D#/Eb":3
                 , "E":4
                 , "F":5
                 , "F#/Gb":6
                 , "G":7
                 , "G#/Ab":8
                 , "A":9
                 , "A#/Bb":10
                 , "B":11} 
                  

    steps := noteSteps[RootSelect]
    Send, {Up %steps%}
Return

ShowHelp:
    Gui, 2:New
    Gui, 2:Font, s10
    Gui, 2:Add, Text, w260, This tool helps you generate chord progressions quickly using scale degrees.
    Gui, 2:Add, Text, w260, 1. Select your key and scale (In Ableton or via Sync Buttons)
    Gui, 2:Add, Text, w260, 2. Draw your root note with your preferred chord lenght.
    Gui, 2:Add, Text, w260, 3. Press  numbers 1 to 7. Delete chords from the last to the first one using the X or BackSpace key.
    Gui, 2:Show,, Chord Progression Generator Help
Return

; i actually dont have to unfocus the selected note to trigger the autosetscale sequence; it keeps selected until the piano roll is clicked: Sending the whole sequence doesnt unfocus it



; CTRL SHIFT SELECCIONA VARIAS NOTASs

;Chord Types Generator (Major, Minor, Aug, Dim, Sus)

;TO-DO: Slash Chords



#IfWinActive

