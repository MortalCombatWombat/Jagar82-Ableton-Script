; Show Selected plugin right under the title
; Show selected plugin in buttons
; Make the UI Pretty (Colors, font, rounded edges)
; Add a GUI Object to add or remove items using a texbox, separated by commas
; Add gifs to indicate the type of tab (An LFO, an Instrument, some MIDI notes, some FX icon)
; Add an option to set a default page
; Expand view by dragging the bottom of the window which deploys all of the plugins in one huge interface
; Automatically re open the GUI after completing the "Add Effect" operation
; Add a rickroll button or something similar lol
; Add an option to toggle plugin auto insert

;JUEPUTA; no esta insertando si no es dos veces, careverga ableton

; ERDA, me acabo de dar cuenta de que en el otro quick fx, el del script final, las tabs son navegables con flechitas. 

;ERDA; en vez de hacer una sola GUI, ya que asi se confunde el script de insert, hacer una title bar ''dummy'' so la gente pueda ver todas las tabs, toca crearla justo encima

#Persistent
#SingleInstance, Force
SetWorkingDir %A_ScriptDir%

; === EFFECT LISTS ===
global InstrumentsTab := ["Cardinal", "Vital", "DoomVST", "Granulator III", "Wavetable", "Operator", "Octave MortalCombat"]
global FXTab := ["EQ Eight", "Compressor","Reverb", "Saturator","Delay",, "Vocoder", "Shifter", "Amp", "OTT", "Utility", "Tuner"]
global MIDIFXTab := ["Pitch", "Arpeggiator", "MIDI Echo", "MIDI Monitor F", "Scale", "Signalizer"]
global Modulators := ["Shaper", "Shaper MIDI", "LFO", "Borrasca Envelope Follower Live 12"]

; === STATE TRACKING VARIABLES ===
global CurrentWindow := 1
global lastKey := ""
global matchIndex := 1
global matches := []
global selectedEffect := ""
global lastHighlightedButton := 0
global Buttons := []
global SCRIPT_PATH := A_ScriptFullPath

Numpad1::   

CreateGUIs:
iconsize := 32
commonStyle := "w230 525256"

CreateCategoryGUI(1, "Instruments", InstrumentsTab)
CreateCategoryGUI(2, "FX", FXTab)
CreateCategoryGUI(3, "MIDI FX", MIDIFXTab)
CreateCategoryGUI(4, "Modulators", Modulators)

ShowWindow(1)
Return

CreateCategoryGUI(num, title, effectsList) {
    Gui, %num%:Default
    Gui, Color, 8c8c8c
    
    ; Add title at the top
    Gui, Font, s15 CWhite
    Gui, Add, Text, x30 y25, %title%
    
    ; Add navigation buttons
    Gui, Font, S10 4c4c4c
    ;Gui, Add, Button, x50 y50, Theme
    Gui, Add, Button, x200 y30 gAddNewEffect, +
    
    ; Add effect buttons
    y := 70
    For index, effect in effectsList {
        Gui, Add, Button, x30 y%y% w230 525256 gButtonClick hwnd_button, %effect%
        Buttons[num].Push(_button)
        y += 33
    }
    
    ; Add navigation text
    Gui, Font, S10 cWhite
    Gui, Add, Text, x30 y+30, Tab to switch categories
}

; ?????

ShowWindow(num) {
    global CurrentWindow, lastHighlightedButton
    
    if (lastHighlightedButton)
        GuiControl, % CurrentWindow ":+Background525256", % lastHighlightedButton
    
    lastHighlightedButton := 0
    
    Loop, 4 {
        Gui, %A_Index%:Hide
    }
    
    Gui, %num%:Show, , Quick Inserts - %num%
    CurrentWindow := num
    SetTimer, CheckKeyPress, 10
}

;?????

;---------------------- Window Navigation ----------------------
#If WinActive("Quick Inserts")
Tab::
    global CurrentWindow
    CurrentWindow := CurrentWindow = 4 ? 1 : CurrentWindow + 1
    ShowWindow(CurrentWindow)
Return

+Tab::
    global CurrentWindow
    CurrentWindow := CurrentWindow = 1 ? 4 : CurrentWindow - 1
    ShowWindow(CurrentWindow)
Return

#If WinActive("Quick Inserts")
1::
2::
3::
4::
    ShowWindow(A_ThisHotkey)
Return


;????? creo que esto es innecesario, o no? podria romper el funcionamiento de las iniciales independientes por ventana

CheckKeyPress:
global lastKey, matchIndex, matches, selectedEffect, lastHighlightedButton
If WinActive("Quick Inserts")
{
    currentEffects := []
    if (CurrentWindow = 1)
        currentEffects := InstrumentsTab
    else if (CurrentWindow = 2)
        currentEffects := FXTab
    else if (CurrentWindow = 3)
        currentEffects := MIDIFXTab
    else
        currentEffects := Modulators
    
    Loop, 26
    {
        key := Chr(A_Index + 64)
        if (GetKeyState(key, "P"))
        {
            if (key != lastKey) {
                matches := []
                for _, effect in currentEffects
                {
                    If (SubStr(effect, 1, 1) = key)
                        matches.Push(effect)
                }
                matchIndex := 1
                lastKey := key
            }
            else {
                matchIndex := matchIndex >= matches.Length() ? 1 : matchIndex + 1
            }
            
            if (matches.Length() > 0) {
                selectedEffect := matches[matchIndex]
                
                if (lastHighlightedButton)
                    GuiControl, % CurrentWindow ":+Background525256", % lastHighlightedButton
                
                Loop, % currentEffects.Length() {
                    if (currentEffects[A_Index] = selectedEffect) {
                        lastHighlightedButton := "Btn" . A_Index
                        GuiControl, % CurrentWindow ":+Background3399FF", % lastHighlightedButton
                        break
                    }
                }
                
                if (matches.Length() > 1) {
                    MouseGetPos, , , , control
                    CoordMode, ToolTip, Screen
                    WinGetPos, WinX, WinY, , , Quick Inserts
                    ToolTip, % selectedEffect " (Press Enter to confirm)", WinX + 30, WinY + 35
                }


                Gui, Font, s15 CWhite
                Gui, Add, Text, x30 y25, %title%
                
                if (matches.Length() = 1) {
                    ToolTip
                    InsertEffect(selectedEffect)
                }
                else if (GetKeyState("Enter", "P")) {
                    ToolTip
                    InsertEffect(selectedEffect)
                }
            }
            
            KeyWait, %key%
            Return
        }
    }
    
    if (GetKeyState("Enter", "P") && selectedEffect) {
        ToolTip
        InsertEffect(selectedEffect)
        selectedEffect := ""
        lastKey := ""
    }
}
Return

;?????

ButtonClick:
    GuiControlGet, effectName,, % A_GuiControl
    InsertEffect(effectName)
Return

AddNewEffect:
    Gui, NewEffect:New
    Gui, Color, 4c4c4c
    Gui, Font, S10 cBlack
    Gui, Add, Text,, Enter new effect name:
    Gui, Add, Edit, vNewEffectName w200
    Gui, Add, Button, Default gSaveNewEffect, Save  ; Added Default option
    Gui, Add, Button, gCancelNewEffect, Cancel
    Gui, Show,, Add New Effect
Return

;????? Reestructurar para hacer el textbox

SaveNewEffect:
    Gui, Submit
    if (NewEffectName = "") {
        MsgBox, Please enter an effect name.
        Return
    }
    
    ; Use CurrentWindow to determine which array to modify
    arrayName := ""
    if (CurrentWindow = 1)
        arrayName := "InstrumentsTab"
    else if (CurrentWindow = 2)
        arrayName := "FXTab"
    else if (CurrentWindow = 3)
        arrayName := "MIDIFXTab"
    else if (CurrentWindow = 4)
        arrayName := "Modulators"
    
    UpdateScriptFile(arrayName, NewEffectName)
    
    Gui, NewEffect:Destroy
    Reload
Return

CancelNewEffect:
    Gui, NewEffect:Destroy
Return

;????? WTF?

UpdateScriptFile(arrayName, newEffect) {
    FileRead, scriptContent, %SCRIPT_PATH%
    
    needle := "global " . arrayName . " := ["
    pos := InStr(scriptContent, needle)
    if (!pos)
        Return
    
    endPos := InStr(scriptContent, "]", false, pos)
    if (!endPos)
        Return
    
    startContent := SubStr(scriptContent, 1, pos - 1)
    arrayContent := SubStr(scriptContent, pos + StrLen(needle), endPos - pos - StrLen(needle))
    endContent := SubStr(scriptContent, endPos + 1)
    
    if (arrayContent = "") {
        newArrayContent := """" . newEffect . """"
    } else {
        newArrayContent := arrayContent . ", """ . newEffect . """"
    }
    
    newContent := startContent . needle . newArrayContent . "]" . endContent
    
    FileDelete, %SCRIPT_PATH%
    FileAppend, %newContent%, %SCRIPT_PATH%
}

InsertEffect(effectName) {
    SetTimer, CheckKeyPress, Off
    Loop, 4 {
        Gui, %A_Index%:Destroy
    }
    
    WinActivate, ahk_class Ableton Live Window Class
    Send ^{f}
    ;SendRaw #Default
    ;Send {Enter}
    Sleep, 20
    Send %effectName%
    Sleep, 400
    Send {enter} 
    Sleep, 300
    Send {enter} 
    Sleep, 100
    Send ^!{b}
    
    Reload
}

GuiClose:
GuiEscapeQuickInserts:
    SetTimer, CheckKeyPress, Off
    Loop, 4 {
        Gui, %A_Index%:Destroy
    }
Return

#If WinActive("Quick Inserts")
Esc::Gosub, GuiClose