/*
================================================================================
Project: Micro Pomodoro & Billable Timer
Version: 1.0.0
Author: Rifins Dev
Website: https://www.rifins.com
Description: A minimalist, always-on-top timer for productivity tracking 
             and calculating freelance billable hours.
================================================================================
*/
#Requires AutoHotkey v2.0
#SingleInstance Force

; Application Metadata
AppTitle := "Rifins Timer"
AppWebsite := "www.rifins.com"

; Global Variables
Global TimeLeft := 1500 ; 25 minutes default
Global ElapsedTime := 0
Global IsRunning := false
Global TimerMode := "Pomodoro"

; Initialize GUI
MyGui := Gui("+AlwaysOnTop +MinimizeBox", AppTitle)

; PRO FEATURE: Drag-Anywhere functionality
OnMessage(0x0201, WM_LBUTTONDOWN)
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    PostMessage(0xA1, 2, , , "ahk_id " hwnd)
}

; Digital Display
DisplayTime := MyGui.Add("Text", "w200 Center s28 bold cBlack", "25:00")

; Control Buttons
MyGui.SetFont("s9 norm")
MyGui.Add("Button", "x15 y70 w85 h30", "Pomodoro").OnEvent("Click", StartPomodoro)
MyGui.Add("Button", "x105 y70 w85 h30", "Stopwatch").OnEvent("Click", StartStopwatch)
MyGui.Add("Button", "x15 y105 w175 h30", "Stop / Reset").OnEvent("Click", ResetTimer)

; Credit Label
MyGui.SetFont("s8 cBlue", "Inter")
MyGui.Add("Text", "x15 y145 w175 Center", AppWebsite).OnEvent("Click", (*) => Run("https://" . AppWebsite))

StartPomodoro(*) {
    Global IsRunning, TimerMode, TimeLeft
    TimerMode := "Pomodoro"
    TimeLeft := 1500
    if (!IsRunning) {
        SetTimer(UpdateTimer, 1000)
        IsRunning := true
    }
}

StartStopwatch(*) {
    Global IsRunning, TimerMode, ElapsedTime
    TimerMode := "Stopwatch"
    ElapsedTime := 0
    if (!IsRunning) {
        SetTimer(UpdateTimer, 1000)
        IsRunning := true
    }
}

ResetTimer(*) {
    Global IsRunning, TimerMode, TimeLeft, ElapsedTime
    IsRunning := false
    SetTimer(UpdateTimer, 0)
    if (TimerMode == "Pomodoro") {
        TimeLeft := 1500
        DisplayTime.Value := "25:00"
    } else {
        ElapsedTime := 0
        DisplayTime.Value := "00:00"
    }
}

UpdateTimer() {
    Global TimeLeft, ElapsedTime, TimerMode, IsRunning
    if (TimerMode == "Pomodoro") {
        if (TimeLeft > 0) {
            TimeLeft--
            DisplayTime.Value := Format("{:02}:{:02}", TimeLeft // 60, Mod(TimeLeft, 60))
        } else {
            SetTimer(UpdateTimer, 0)
            IsRunning := false
            MsgBox("Pomodoro session complete! Time for a break.", "Time's Up!", "Iconi")
        }
    } else {
        ElapsedTime++
        DisplayTime.Value := Format("{:02}:{:02}", ElapsedTime // 60, Mod(ElapsedTime, 60))
    }
}

MyGui.OnEvent("Close", (*) => ExitApp())
MyGui.Show("w205 h170")
