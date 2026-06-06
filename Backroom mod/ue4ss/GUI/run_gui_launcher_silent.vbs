Set objShell = CreateObject("WScript.Shell")
Dim strPath
strPath = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)

On Error Resume Next
Dim strCmd
strCmd = "cmd.exe /c start """" /B "C:\\Users\\Carso\\AppData\\Local\\Programs\\Python\\Python311\\pythonw.exe" " & Chr(34) & strPath & "\awspam_gui.py" & Chr(34)
objShell.Run strCmd, 0, False
If Err.Number <> 0 Then
    Err.Clear
    strCmd = "cmd.exe /c start """" /B pythonw " & Chr(34) & strPath & "\awspam_gui.py" & Chr(34)
    objShell.Run strCmd, 0, False
    If Err.Number <> 0 Then
        Err.Clear
        strCmd = "cmd.exe /c start """" /B python " & Chr(34) & strPath & "\awspam_gui.py" & Chr(34)
        objShell.Run strCmd, 0, False
    End If
End If
On Error GoTo 0

WScript.Quit
