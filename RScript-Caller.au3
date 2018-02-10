#include <File.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#pragma compile(Icon, 'icon.ico')

$rscript_path = IniRead ( @ScriptDir & "\config.ini", "config", "rscript_path", "C:\Program Files\R\R-3.4.1\bin\Rscript.exe" )

If Not(FileExists($rscript_path)) Then
   MsgBox($MB_SYSTEMMODAL, "Config Error", "RSciprt doesn't exists in path " & $rscript_path & @LF & "Please setup your config.ini")
   Exit (1)
EndIf

Local $CommandLine = $CmdLine

For $i = 1 To $CommandLine[0]
   Local $file = $CommandLine[$i]
   IF FileExists($file) = False Then
	  ContinueLoop
   EndIf

   Local $tmp = _TempFile() & '.bat'

   If FileExists($tmp) Then
	  FileRecycle($tmp)
   EndIf

   Local $hFileOpen = FileOpen($tmp, $FO_APPEND)
   FileWriteLine($hFileOpen, '"' & $rscript_path & '" "' & $file & '"')
   FileWriteLine($hFileOpen, 'pause')
   FileClose($hFileOpen)

   RunWait($tmp)
   FileRecycle($tmp)
Next