

;Autohotkey script by Jagar82 (Based on Oversampled's Ahk Script - https://oversampled.us/products/abletonahk - and Live Enhancement Suite - https://github.com/LiveEnhancementSuite/LESforWindows)  

;STEPS

;1. Download and install Autohotkey v2: https://www.autohotkey.com/
;2. Download and save these Scripts to your lib (C:\Users\Username\Documents\AutoHotkey\lib) as HideSystemCursor and FindText, correspondingly. Credits to Feiyue and Mikeyww. ; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=17834 - https://www.autohotkey.com/boards/viewtopic.php?t=102022
;3. Download and install Powertoys: https://github.com/microsoft/PowerToys/releases/tag/v0.81. (Or any software that allows you to remap keys. Running it at startup is recommended).
;4. Remap Right Shift and Right Alt to any key you wish . I did it with Caps Lock (RShift) and < (RAlt) (Spanish Layout).
;5. Making racks or presets (.adg, .adv) for your most used effects and instruments is recommended, so Ableton avoids choosing the wrong effect. Then search “Effect Picker” in this script and rename the effects, and customize the hotkeys.
;6. Some hotkeys use a kind of imagesearch (Record with Double R, Find in selected folder). Set Windows to 1920 x 1080 and 150% zoom for an optimal experience.
;7. Feel the power ᕙ(⇀‸↼‶)ᕗ  (Don't forget that you can modify all of this to your taste and even upload it; just remember to link this repo and credit Oversampled and LES Scripts. MIT License B) ).

;If you know Max For Live and want to collaborate with this script, please hit me up at jagarj82@gmail.com. Thank you in advance.
;(Hope you enjoy :D)

;>----------------------------------------------------------- SCRIPT SHORTCUTS ------------------------------------------------------------------------<

;>-------------------------------- PAUSE & SUSPEND SCRIPT --------------------------------<

;(Page Up: Suspend and Pause)

~PgUp:: 
Suspend
Pause,,1
return

;>-------------------------------- RELOAD SCRIPT --------------------------------<

;(Page Down: Reload)

PgDn::   
Reload
Return

;>-------------------------------- TOGGLE CAPSLOCK  --------------------------------<

;(Doble Capslock: Toggle Capslock as RShift / Caps)

!Capslock::
If GetKeyState("CapsLock", "T")
	SetCapsLockState, Off
Else
	SetCapsLockState, On
Return

;>----------------------------------------------------------- GENERAL PARAMETERS ------------------------------------------------------------------------< 

#Include <HideSystemCursor>
#Include <FindText>
#SingleInstance Force

#IfWinActive, ahk_class Ableton Live Window Class

;>-------------------------------- AUTOSAVE EVERY 10 MINUTES --------------------------------<

;-In Development

;>----------------------------------------------------------- VIEW ------------------------------------------------------------------------<

;>-------------------------------- KEEP TAB AS SESSION / ARRANGEMENT VIEW SWITCH --------------------------------<

;(Tab: Switch between Arrangement and Session view)

toggle := true
Tab::
    WinGetTitle, OutputVar, A
    If InStr(OutputVar, "Preferences") 
    
        {          
            Send {tab}
        }
    Else
        { 
            toggle := !toggle
            
            if (!toggle) 
            
                {Send, !{1}
                
            } else {
                Send, !{2}
            }
            Return
        }
    Return  

;(Bypass:: Send Tab to navigate with RShift + Tab)

RShift & Tab::Send {tab}

;>-------------------------------- KEEP SHIFT + TAB AS CLIP / DEVICE VIEW SWITCH --------------------------------<

;(Shift + Tab: Switch between Clip and Device View)

toggle := true
+Tab::
    WinGetTitle, OutputVar, A
    If InStr(OutputVar, "Preferences") 
    
        {          
            Send {tab}
        }
    Else
        { 
            toggle := !toggle
            
            if (!toggle) 
            
                {Send, !{3}
    
            } else {
                Send, !{4}
            }
            Return
        }
    Return  

;(Bypass:: Send Shift + Tab to navigate with Ctrl + Tab)

Ctrl & Tab::Send +{tab}

;>-------------------------------- TOGGLE FULLSCREEN --------------------------------<

;(Double Escape: Toggle Fullscreen)

~Esc::
if (A_PriorHotkey <> "~Esc" or A_TimeSincePriorHotkey > 300)
{
    KeyWait, Esc
    return
}
Send {f11}
return

;>-------------------------------- FOCUS VIEWS --------------------------------< 

#+k::
Send !{0}
return

#+s::
Send !{1}
return

#+a::
Send !{2}
return

#+c::
Send !{3}
return

#+d::
Send !{4}
return

#+b::
Send !{5}
return

#+g::
Send !{6}
return

#+h::
Send !{7}
return

#+t::
Send !{n}
Send {t}
return

;>-------------------------------- ZOOM IN / OUT --------------------------------<

^XButton2::
Send {+}
Return

;(Upper Side Mouse Button: Zoom In |Z|)

XButton2::
Send {z}
Return

;(Ctrl + Lower Side Button: Zoom Out)

^XButton1::
Send {-}
Return

;(Lower Side Mouse Button: Zoom Out |x|)

XButton1::
Send {x}
Return

;>-------------------------------- CLOSE WINDOWS --------------------------------<

;(Ctrl + W: Close windows)

#IfWinActive, ahk_exe Ableton Live 12 Suite.exe

^w::   
Send !{f4}
return
#IfWinActive

;>-------------------------------- OPEN PLUGIN WINDOW --------------------------------<

#IfWinActive, ahk_class Ableton Live Window Class ;(Continue Script)

;(Ctrl + P: Open Plugin Window) 

^p::
CoordMode, Mouse, Screen
MouseGetPos, OrigX, OrigY
SystemCursor(False)
Send !{4}
SystemCursor(False)
Send {left 30}
SystemCursor(False)

t1:=A_TickCount, Text:=X:=Y:=""

Text:="|<Plugin Screw - M.DARK>**70$19.0T00xs1k71UylUtAkMykAzs6NMC1g60q63nC31a30u30p30Pz0My0MC0M3ls0Dk8"

if (ok:=FindText(X, Y, 0, 661, 798, 778, 0, 0, Text))
{
        SystemCursor(False)
        FindText().Click(X, Y, "L")
}
else
    {
        t1:=A_TickCount, Text:=X:=Y:=""

        Text:="|<Plugin Screw - LIGHT>**50$20.0T00Tw0S1kC0670slUSAk7Bg1rO0TmURscDkC3s2ng1gy0Pj0CNU3301UQ1k3zs0Ds2"
        
        if (ok:=FindText(X, Y, 0, 648, 804, 775, 0, 0, Text))
        {
            SystemCursor(False)
            FindText().Click(X, Y, "L")
        }

    }
SystemCursor(False)
MouseMove, OrigX, OrigY
SystemCursor(True)
return

;>-------------------------------- SHOW / HIDE  DEVICES ON SLOTS --------------------------------<

;-In Development

^!d::
hwnd := WinExist("A")  ; Change "A" as needed.
if !hwnd
    MsgBox Window not found.
else if DllCall("GetMenu", "ptr", hwnd, "ptr")
    MsgBox This window has a standard menu bar.
else
    MsgBox This window does not (currently) have a standard menu bar.

;WinMenuSelectItem ahk_exe Ableton Live 12 Suite.exe,, 2&, , Paste

Return

;>-------------------------------- SHOW / HIDE DEVICE AND CLIP VIEW --------------------------------<

;-In Development

toggle := true
^!l::

toggle := !toggle
If (!toggle) {
    Send, !{3}
} else {
    Send, L
}
Return

;>----------------------------------------------- SEARCH -----------------------------------------------<

;>-------------------------------- SEARCH IN SELECTED FOLDER --------------------------------< 

;Ctrl+Shift+F: Search in selected folder;

^+f::

t1:=A_TickCount, Text:=X:=Y:=""

Text:="|<BrowserActive - DARK>*113$26.0C0003U000s000C0003U000s000C0003U000s000C0003U000s000C0003U000s000C0003U000s000C0003U02"

if (ok:=FindText(X, Y, 0, 0, 836, 235, 0, 0, Text))

{
  FindText().Click(X+100, Y+50, "L")
}
else

    {
    MouseGetPos, OrigX, OrigY
    Send ^!{b}
    SystemCursor(False)
    FindText().Click(X+100, Y+50, "L")
    SystemCursor(False)
    MouseMove, OrigX, OrigY
    SystemCursor(True)
    }

Return

;>----------------------------------------------------------- TRACKS AND EFFECTS ------------------------------------------------------------------------<

;>-------------------------------- RECORD WITH DOUBLE R --------------------------------<

;(Double R: Record) - Advice: Do not keymap C or Shift+ C

~r::
if (A_PriorHotkey <> "~r" or A_TimeSincePriorHotkey > 300)
{
    KeyWait, r
    return
}

t1:=A_TickCount, Text:=X:=Y:=""

Text:="|<TrackArmed - GLOBAL>*64$29.00000000000000003k000TE001wk003tk00DnU00Tb000wC000kM001Vk001z00000000000000008"

if (ok:=FindText(X, Y, 1137, 194, 1898, 907, 0, 0, Text))
{

}
else
    {
        Send +{c}

        t1:=A_TickCount, Text:=X:=Y:=""
        
        Text:="|<TrackArmed - GLOBAL>*64$29.00000000000000003k000TE001wk003tk00DnU00Tb000wC000kM001Vk001z00000000000000008"
        
        if (ok:=FindText(X, Y, 1137, 194, 1898, 907, 0, 0, Text))
        {
            ;Skip
        }
        else
            {
                Send {c}
            }    
        
    }
Send {f9}
return

;>-------------------------------- INSERT SELECTED ITEM INTO A NEW MIDI TRACK --------------------------------<

;(Ctrl / Shift + Enter: Insert selected Browser item on new MIDI Track)

^Enter:: 
Send, ^+t
Send, {Enter}
Return

+Enter:: 
Send, ^+t
Send, {Enter}
Return

;>-------------------------------- EFFECT PICKER --------------------------------<

;(Alt + Initial letter of the effect or developer: Sends an effect or instrument)

;Blank Space: Send % Chr(160)

effect(item)
{

BlockInput, SendAndMouse
BlockInput, On

Send ^{f}

Send % Chr(160)
Send %item%

Sleep, 300
Send {enter} 
Sleep, 100
Send {enter} 
Send ^!{b}


BlockInput, Off

}

;>---------------------------------------------------------------- EFFECTS SHORTCUTS --------------------------------------------------------------------<

;>------------------------------ AUDIO EFFECTS ------------------------------< 

;>--------------------------- Vocoder, Vital ---------------------------< 

RAlt & v:: 

if (KeyPressCount > 0) 
{
	KeyPressCount += 1 
} else {
	KeyPressCount := 1 
}

SetTimer, KeyPressMonitorV, 600 

return

KeyPressMonitorV:
if (KeyPressCount = 1) 
{
    effect("Vocoder")
}
else if (KeyPressCount = 2)
{
	msgbox Not Assigned
}
else if (KeyPressCount > 2)	
{
    effect("Vital")
}
KeyPressCount := 0 
SetTimer, KeyPressMonitorV, Off 
Return

;>--------------------------- Eq Eight ---------------------------< 

RAlt & e:: 

if (KeyPressCount > 0) 
{
	KeyPressCount += 1 
} else {
	KeyPressCount := 1 
}

SetTimer, KeyPressMonitorE, 600 

return

KeyPressMonitorE:
if (KeyPressCount = 1) 
{
	effect("EQ Eight")
}
else if (KeyPressCount = 2)
{
	msgbox Not Assigned
}
else if (KeyPressCount > 2)	
{
	msgbox Not Assigned
}
KeyPressCount := 0 
SetTimer, KeyPressMonitorE, Off 
Return

;>--------------------------- Multiband Dynamics, MIDI Monitor ---------------------------< 

RAlt & m:: 

if (KeyPressCount > 0) 
{
	KeyPressCount += 1 
} else {
	KeyPressCount := 1 
}

SetTimer, KeyPressMonitorM, 600 

return

KeyPressMonitorM:
if (KeyPressCount = 1) 
{
	effect("Multiband Compression")
}
else if (KeyPressCount = 2)
{
	effect("MIDI Monitor F")
}
else if (KeyPressCount > 2)	
{
	msgbox Not Assigned
}
KeyPressCount := 0 
SetTimer, KeyPressMonitorM, Off 
Return

;>--------------------------- Shifter, Simpler ---------------------------< 

RAlt & s:: 

if (KeyPressCount > 0) 
{
	KeyPressCount += 1 
} else {
	KeyPressCount := 1 
}

SetTimer, KeyPressMonitorS, 600

return

KeyPressMonitorS:
if (KeyPressCount = 1) 
{
	effect("Shifter")
}
else if (KeyPressCount = 2)
{
    msgbox Not Assigned
}
else if (KeyPressCount > 2)	
{
	effect("Simpler")
}
KeyPressCount := 0 
SetTimer, KeyPressMonitorS, Off 
Return

;>--------------------------- OTT, Operator ---------------------------< 

RAlt & o::

if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorO, 600
    
    return
    
    KeyPressMonitorO:
    if (KeyPressCount = 1) 
    {
        effect("OTT")
    }
    else if (KeyPressCount = 2)
    {
        msgbox Not Assigned
    }
    else if (KeyPressCount > 2)	
    {
        effect("Operator")
    }
    KeyPressCount := 0 
    SetTimer, KeyPressMonitorO, Off 
    Return

 ;>--------------------------- Compressor, Chord ---------------------------< 

 RAlt & c::

if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorC, 600
    
    return
    
    KeyPressMonitorC:
    if (KeyPressCount = 1) 
    {
        effect("Compressor")
    }
    else if (KeyPressCount = 2)
    {
    effect("Chord")
    }
    else if (KeyPressCount > 2)	
    {
        msgbox Not Assigned
    }
    KeyPressCount := 0 
    SetTimer, KeyPressMonitorC, Off 
    Return
   
 ;>--------------------------- Pro-Q, Quanta ---------------------------< 

 RAlt & q::

if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorQ, 600
    
    return
    
    KeyPressMonitorQ:
    if (KeyPressCount = 1) 
    {
        effect("Pro-Q 3")
    }
    else if (KeyPressCount = 2)
    {
    msgbox Not Assigned
    }
    else if (KeyPressCount > 2)	
    {
        effect("Quanta")
    }
    KeyPressCount := 0 
    SetTimer, KeyPressMonitorQ, Off 
    Return

 ;>--------------------------- Reverb ---------------------------< 
    
 RAlt & r::

if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorR, 600
    
    return
    
    KeyPressMonitorR:
    if (KeyPressCount = 1) 
    {
        Sleep 100
        effect("Reverb")
    }
    else if (KeyPressCount = 2)
    {
        msgbox Not Assigned
    }
    else if (KeyPressCount > 2)	
    {
        msgbox Not Assigned
    }
    KeyPressCount := 0 
    SetTimer, KeyPressMonitorR, Off 
    Return

 ;>--------------------------- Delay, Drum Rack, Polyrandom 32 ---------------------------< 

 RAlt & d::

 if (KeyPressCount > 0) 
     {
         KeyPressCount += 1 
     } else {
         KeyPressCount := 1 
     }
     
     SetTimer, KeyPressMonitorD, 600
     
     return
     
     KeyPressMonitorD:
     if (KeyPressCount = 1) 
     {
         effect("Delay")
     }
     else if (KeyPressCount = 2)
     {
        effect("Drum Rack")
     }
     else if (KeyPressCount > 2)	
     {
        effect("Polyrandom 32")
     }
     KeyPressCount := 0 
     SetTimer, KeyPressMonitorD, Off 
     Return

 ;>--------------------------- Utility, U-Hee Diva ---------------------------< 
    
 RAlt & u::

 if (KeyPressCount > 0) 
     {
         KeyPressCount += 1 
     } else {
         KeyPressCount := 1 
     }
     
     SetTimer, KeyPressMonitorU, 600
     
     return
     
     KeyPressMonitorU:
     if (KeyPressCount = 1) 
     {
        effect("Utility")
     }
     else if (KeyPressCount = 2)
     {
        effect("Utility")
     }
     else if (KeyPressCount > 2)	
     {
        effect("Diva")
     }
     KeyPressCount := 0 
     SetTimer, KeyPressMonitorU, Off 
     Return

 ;>--------------------------- EQ Three, Tuner ---------------------------< 
    
 RAlt & t::

 if (KeyPressCount > 0) 
     {
         KeyPressCount += 1 
     } else {
         KeyPressCount := 1 
     }
     
     SetTimer, KeyPressMonitorT, 600
     
     return
     
     KeyPressMonitorT:
     if (KeyPressCount = 1) 
     {
        effect("EQ Three")
     }
     else if (KeyPressCount = 2)
     {
        effect("Tuner")
     }
     else if (KeyPressCount > 2)	
     {
        msgbox Not Assigned
     }
     KeyPressCount := 0 
     SetTimer, KeyPressMonitorT, Off 
     Return

 ;>--------------------------- Hybrid Reverb ---------------------------< 
    
 RAlt & h::

 if (KeyPressCount > 0) 
     {
         KeyPressCount += 1 
     } else {
         KeyPressCount := 1 
     }
     
     SetTimer, KeyPressMonitorH, 600
     
     return
     
     KeyPressMonitorH:
     if (KeyPressCount = 1) 
     {
        effect("Hybrid Reverb")
     }
     else if (KeyPressCount = 2)
     {
        msgbox Not Assigned
     }
     else if (KeyPressCount > 2)	
     {
        msgbox Not Assigned
     }
     KeyPressCount := 0 
     SetTimer, KeyPressMonitorH, Off 
     Return

 ;>--------------------------- Glue Compressor, Granulator III ---------------------------< 
    
 RAlt & g::

 if (KeyPressCount > 0) 
     {
         KeyPressCount += 1 
     } else {
         KeyPressCount := 1 
     }
     
     SetTimer, KeyPressMonitorG, 600
     
     return
     
     KeyPressMonitorG:
     if (KeyPressCount = 1) 
     {
        effect("Glue Compressor")
     }
     else if (KeyPressCount = 2)
     {
        msgbox Not Assigned
     }
     else if (KeyPressCount > 2)	
     {
        effect("Granulator II")
     }
     KeyPressCount := 0 
     SetTimer, KeyPressMonitorG, Off 
     Return    

 ;>--------------------------- Limiter, LFO ---------------------------< 
    
 RAlt & l::

 if (KeyPressCount > 0) 
     {
         KeyPressCount += 1 
     } else {
         KeyPressCount := 1 
     }
     
     SetTimer, KeyPressMonitorL, 600
     
     return
     
     KeyPressMonitorL:
     if (KeyPressCount = 1) 
     {
        effect("Limiter")
     }
     else if (KeyPressCount = 2)
     {
        effect("LFO")
     }
     else if (KeyPressCount > 2)	
     {
        msgbox Not Assigned
     }
     KeyPressCount := 0 
     SetTimer, KeyPressMonitorL, Off 
     Return    

 ;>--------------------------- Auto Filter ---------------------------< 

 RAlt & f::

 if (KeyPressCount > 0) 
     {
         KeyPressCount += 1 
     } else {
         KeyPressCount := 1 
     }
     
     SetTimer, KeyPressMonitorF, 600
     
     return
     
     KeyPressMonitorF:
     if (KeyPressCount = 1) 
     {
        effect("Auto Filter")
     }
     else if (KeyPressCount = 2)
     {
        msgbox Not Assigned
     }
     else if (KeyPressCount > 2)	
     {
        msgbox Not Assigned
     }
     KeyPressCount := 0 
     SetTimer, KeyPressMonitorF, Off 
     Return    

 ;>--------------------------- Amp, Arpeggiator, Analog ---------------------------< 

 RAlt & a::

 if (KeyPressCount > 0) 
     {
         KeyPressCount += 1 
     } else {
         KeyPressCount := 1 
     }
     
     SetTimer, KeyPressMonitorA, 600
     
     return
     
     KeyPressMonitorA:
     if (KeyPressCount = 1) 
     {
        effect("Amp")
     }
     else if (KeyPressCount = 2)
     {
        effect("Arpeggiator")
     }
     else if (KeyPressCount > 2)	
     {
        effect("Analog")
     }
     KeyPressCount := 0 
     SetTimer, KeyPressMonitorA, Off 
     Return    

 ;>--------------------------- Wavetable ---------------------------< 
    
 RAlt & w::

 if (KeyPressCount > 0) 
     {
         KeyPressCount += 1 
     } else {
         KeyPressCount := 1 
     }
     
     SetTimer, KeyPressMonitorW, 600
     
     return
     
     KeyPressMonitorW:
     if (KeyPressCount = 1) 
     {
        msgbox Not Assigned
     }
     else if (KeyPressCount = 2)
     {
        msgbox Not Assigned
     }
     else if (KeyPressCount > 2)	
     {
        effect("Wavetable")
     }
     KeyPressCount := 0 
     SetTimer, KeyPressMonitorW, Off 
     Return    

  ;>--------------------------- Xfer Serum ---------------------------< 
    
  RAlt & x::

  if (KeyPressCount > 0) 
      {
          KeyPressCount += 1 
      } else {
          KeyPressCount := 1 
      }
      
      SetTimer, KeyPressMonitorX, 600
      
      return
      
      KeyPressMonitorX:
      if (KeyPressCount = 1) 
      {
         msgbox Not Assigned
      }
      else if (KeyPressCount = 2)
      {
         msgbox Not Assigned
      }
      else if (KeyPressCount > 2)	
      {
        effect("Serum")
      }
      KeyPressCount := 0 
      SetTimer, KeyPressMonitorX, Off 
      Return    
     
  ;>--------------------------- Keyscape ---------------------------<  

  RAlt & k::

  if (KeyPressCount > 0) 
      {
          KeyPressCount += 1 
      } else {
          KeyPressCount := 1 
      }
      
      SetTimer, KeyPressMonitorK, 600
      
      return
      
      KeyPressMonitorK:
      if (KeyPressCount = 1) 
      {
         msgbox Not Assigned
      }
      else if (KeyPressCount = 2)
      {
         msgbox Not Assigned
      }
      else if (KeyPressCount > 2)	
      {
        effect("Keyscape")
      }
      KeyPressCount := 0 
      SetTimer, KeyPressMonitorK, Off 
      Return    
     
  ;>--------------------------- Pitch, Phaseplant ---------------------------< 

  RAlt & p::

  if (KeyPressCount > 0) 
      {
          KeyPressCount += 1 
      } else {
          KeyPressCount := 1 
      }
      
      SetTimer, KeyPressMonitorP, 600
      
      return
      
      KeyPressMonitorP:
      if (KeyPressCount = 1) 
      {
         msgbox Not Assigned
      }
      else if (KeyPressCount = 2)
      {
        effect("Pitch")
      }
      else if (KeyPressCount > 2)	
      {
        effect("Phase Plant")
      }
      KeyPressCount := 0 
      SetTimer, KeyPressMonitorP, Off 
      Return    
     
  ;>--------------------------- MXL Monitor ---------------------------< 

  RAlt & n::

  if (KeyPressCount > 0) 
      {
          KeyPressCount += 1 
      } else {
          KeyPressCount := 1 
      }
      
      SetTimer, KeyPressMonitorN, 600
      
      return
      
      KeyPressMonitorN:
      if (KeyPressCount = 1) 
      {
         msgbox Not Assigned
      }
      else if (KeyPressCount = 2)
      {
        effect("MXL Monitor")
      }
      else if (KeyPressCount > 2)	
      {
        msgbox Not Assigned
      }
      KeyPressCount := 0 
      SetTimer, KeyPressMonitorN, Off 
      Return    

;(Bypass:: LAlt + Initial letter of the menu)


;>---------------------------------------------------------------- EDITING -------------------------------------------------------------------<

;>-------------------------------- CONSOLIDATE / INSERT MIDI TRACKS WITH CTRL + J --------------------------------<

;(Ctrl + J: Insert MIDI Track / Consolidate)

^j::
Send ^+{m}
Send ^{j}
Return

;>--------- QUANTIZE --------< 

;(Ctrl + Q: Quantize)

^q::
Send ^{u}
return

^+q::
Send ^+{u}
return

;>----------------------------------------------------------------X4 BUPLICATE--------------------------------------------------------------------< 

;(Ctrl + B: Duplicate a selected region 4 times);

^b::
Send ^{d 3} 
return

;>---------------------------------------------------------------- ALTERNATE REDO --------------------------------------------------------------------<

;(Ctrl+Shift+Z: Redo) ;

^+z::
Send ^{y}
return

;>-------------------------------- INSERT MIDI CLIP/NOTE --------------------------------< 

;(Shift + Left Click: Places a MIDI note or clip)

RShift & LButton::
Send ^+{m}
Send ^{j}
Send {LButton Down}
Send {LButton Down}
Return

RShift & LButton Up::
Send {LButton Up}
Send {LButton Up}
Return


;(Middle Mouse Button: Places a MIDI note or clip)

MButton:: 
Send ^+{m}
Send ^{j}
Send {LButton Down}
Send {LButton Down}
Return

MButton Up::
Send {LButton Up}
Send {LButton Up}
return

;>-------------------------------- DISABLE LOOP WHEN CREATING CLIPS WITH CTRL+M --------------------------------< 

^+m::
Send ^+{m}
Send ^{j}
Return

;>-------------------------------- QUICKER CUT --------------------------------<

;(< + Right Click: Cut)
;(< + Double Right Click: Delete)

RShift & RButton:: 

    if (KeyPressCount > 0) 
        {
            KeyPressCount += 1 
        } else {
            KeyPressCount := 1 
        }
        
        SetTimer, KeyPressMonitor+RButton, 200    
        return
        
        KeyPressMonitor+RButton:
        if (KeyPressCount = 1) 
        {
            Send ^{x}
        }
        else if (KeyPressCount = 2)
        {
            Send {Backspace}
        }
        else if (KeyPressCount > 2)	
        {

        }
        KeyPressCount := 0 
        SetTimer, KeyPressMonitor+RButton, Off 
        Return 


;>-------------------------------- ALT CUT, COPY, PASTE, DUPLICATE --------------------------------< 

;(< + C: Copy) 

RShift & c::
Send ^{c}
Return

;(< + V: Paste) 

RShift & v::
Send ^{v}
Return

;(< + X: Cut) ;(< + Double X: Delete)    

RShift & X:: 

    if (KeyPressCount > 0) 
        {
            KeyPressCount += 1 
        } else {
            KeyPressCount := 1 
        }
        
        SetTimer, KeyPressMonitor+X, 200    
        return
        
        KeyPressMonitor+X:
        if (KeyPressCount = 1) 
        {
            Send ^{x}
        }
        else if (KeyPressCount = 2)
        {
            Send {Backspace}
        }
        else if (KeyPressCount > 2)	
        {

        }
        KeyPressCount := 0 
        SetTimer, KeyPressMonitor+X, Off 
        Return 

;(Alt + Initial letter of the effect or developer: Sends an effect or instrument)


;>-------------------------------- ALT DELETE --------------------------------<

;(Ctrl + Alt + X / Ctrl + Shift + X: Delete)

^!x::
Send {Backspace}
return

^+x::
Send {Backspace}
return

;>-------------------------------- MOVE NOTES/CLIPS (WASD) --------------------------------<

;(Rshift + A / D: Moves notex left / right) 

RShift & a::
send {left}
Return

RShift & d::
send {right}
Return


;(Rshift + W / S: Moves notes up / down)

RShift & w::
send {up}
return

RShift & s::
send {down}
Return

;>-------------------------------- NOTE LENGTH (A / D) --------------------------------< 

;(Alt + D / A: Makes a note longer or shorter)

!d::
send +{right}
Return

!a::
send +{left}
Return

;>-------------------------------- TRANSPOSE NOTES BY SEMITONES (SCROLL WHEEL) --------------------------------<

;(Rshift + MouseWheelUp / Down: Transpose a note by semitones)

RShift & WheelUp::
Send {up}
Return

RShift & WheelDown::
Send {down}
Return

;>-------------------------------- MOVE NOTES/CLIPS (SCROLL WHEEL) --------------------------------<

;-In Development

;(Ctrl + Shift + MouseWheelUp / Down: Move a clip or note note left / right);

;>-------------------------------- MOVE NOTES/CLIPS (TRACKPAD) --------------------------------<

;(Rshift + WheelRight / WheelLeft: Move a clip or note horizontally)

RShift & WheelRight::
Send {left}
Return

RShift & WheelLeft::
Send {right}
return

;>-------------------------------- NOTE LENGTH (SCROLL WHEEL) --------------------------------<s

;-In Development

;(Shift + Alt + MouseWheelUp / Down: Lengthen or shorten the note)

;>---------------------------------------------------------------- CHORD BUILDER --------------------------------------------------------------------<

;(F1: Mayor Chord)    
;(F2: Minor Chord)
;(F3: Augmented Chord)
;(F4: Diminished Chord)

; Press 1 time for a Triad, 2 times for 7th, 3 times for 9th. This applies to all chords.

    ;>---------MAJOR CHORD BUILDER---------<
    
    f1::   

    if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorShiftM2, 400 
    
    return
    
    KeyPressMonitorShiftM2:
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
    SetTimer, KeyPressMonitorShiftM2, Off 
    return
  
    
    ;>---------MINOR CHORD BUILDER---------<
    
    f2::   

    if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorShiftN2, 400 
    
    return
    
    KeyPressMonitorShiftN2:
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
    SetTimer, KeyPressMonitorShiftN2, Off 
    return
    
    ;>---------AUG CHORD BUILDER---------<

    f3::   

    if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorShiftA2, 400 
    
    return
    
    KeyPressMonitorShiftA2:
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
    SetTimer, KeyPressMonitorShiftA2, Off 
    return
    
    ;>---------DIM CHORD BUILDER---------<
    
    f4::   
    
    if (KeyPressCount > 0) 
    {
        KeyPressCount += 1 
    } else {
        KeyPressCount := 1 
    }
    
    SetTimer, KeyPressMonitorShiftD2, 400 
    
    return
    
    KeyPressMonitorShiftD2:
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
    SetTimer, KeyPressMonitorShiftD2, Off 
    return    

;>-------------------------------- TOGGLE TRACKS ON / OFF --------------------------------<

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

;>-------------------------------- SLICE NOTES --------------------------------<

;>--------- SLICE ON CURSOR POSITION ---------<

;(Shift + 1: Slice over cursor position)

RShift & 1::
send, +{e  down}
Send, {LButton}
sleep 10
send, +{e up}
Return

;>---------FAST SLICE (SHIFT+NUM) (2-9)---------<

;(Shift + 2: Slice in 2)

RShift & 2:: 

Send {Blind}{Ctrl down}
Send  {e}
Send {Up}
Send {Ctrl up}
Return

;(3)

RShift & 3::
Send {Blind}{Ctrl down}
Send  {e}
Send {Up 2}
Send {Ctrl up}
Return

;(4)

RShift & 4::
Send {Blind}{Ctrl down}
Send  {e}
Send {Up 3}
Send {Ctrl up}
Return

;(5)

RShift & 5::
Send {Blind}{Ctrl down}
Send  {e}
Send {Up 4}
Send {Ctrl up}
Return

;(6)

RShift & 6::
Send {Blind}{Ctrl down}
Send  {e}
Send {Up 5}
Send {Ctrl up}
Return

;(7)

RShift & 7::
Send {Blind}{Ctrl down}
Send  {e}
Send {Up 6}
Send {Ctrl up}
Return

;(8)

RShift & 8::
Send {Blind}{Ctrl down}
Send  {e}
Send {Up 7}
Send {Ctrl up}
Return

;(9)

RShift & 9::
Send {Blind}{Ctrl down}
Send  {e}
Send {Up 8}
Send {Ctrl up}
Return

;>-------------------------------- REVERSE --------------------------------<

;-In Development

;(RShift+R: Reverse clips / audio); pending

;>-------------------------------- LEGATO --------------------------------<

;-In Development

;(Shift+L: Legato);

;>-------------------------------- INVERT --------------------------------<

;-In Development

;(Shift+I: Invert); pending

;>-------------------------------- SWITCH AUDIO DRIVER --------------------------------<

;-In Development

RCtrl::

Send ^,
t1:=A_TickCount, Text:=X:=Y:=""

Text:="|<Preferences Audio - M.DARK>**50$69.0000000000000000000000000000000000000000000000000000000000000000w000000T001zU000006M009Y000000V001AU00000ABvrtxz00001UdHkAwA00008Z+Q1a0k0003AtH6AnW0000NX+NtaSE00020NHDAmm0000k3CMlaQE0006S83UAk60000aNUQ1b1U0007nzyzzjs0000000000000000000000000000000000000000000000004"

if (ok:=FindText(X, Y, 599-150000, 226-150000, 599+150000, 226+150000, 0, 0, Text))
{
   FindText().Click(X, Y, "L")
   Send {tab 2}
   Send {enter}
   
   t1:=A_TickCount, Text:=X:=Y:=""

   Text:="|<Audio / FL Studio - M.DARK>**50$67.000000000w0Tzk3wQ007z087M33S003NU43g30t001Ck2Tq1jQzjjbrx8P0rw7Kw3D3bxUMy3/Q1b0kSk67bZiwnD9zM3tmGqONbYzg3yN9vBAmmErtDAyxraNt8MAnDDAtXCNYA2QDVkS1bVy7z7yTzzzyzk000Q3XUS074"
   
   if (ok:=FindText(X, Y, 1093-150000, 211-150000, 1093+150000, 211+150000, 0, 0, Text))
   {
      FindText().Click(X, Y, "L")
   }
}
Return

#IfWinActive
