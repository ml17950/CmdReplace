Const APP_VERSION As String = "23.12.18"

'##################################################################################
' GLOBAL INCLUDES
'##################################################################################

' - none -

'##################################################################################
' GLOBAL VARIABLES
'##################################################################################

' - none -

'##################################################################################
' PROJECT INCLUDES
'##################################################################################

' - none -

'##################################################################################
' FUNCTIONS
'##################################################################################

Sub displayHelp()
	Print
	Print "CmdReplace - replace a string in text/data from a file - by M. Lindner / Version " & APP_VERSION
	Print
	Print "usage: CmdReplace <sourcefile> <search> <replace> [targetfile]"
	Print
	Print "Options"
	Print "======================================================================="
	Print " sourcefile       source file to read from"
	Print " search           search for the string (\r,\n,\t possible)"
	Print " replace          replace with this string"
	Print " targetfile       target file to write to"
	Print "                  if empty, print to stdout"
End Sub

Function replaceString(ByVal StrEx As String, _
                    ByVal StrMask As String, _
                    ByVal StrRplce As String, _
                    ByVal FirstPos As UInteger=0, _
                    ByVal LastPos As UInteger=0) As String

	If Len(StrEx)=0 Or Len(StrMask)>Len(StrEx) Then Return StrEx
	FirstPos = IIf (FirstPos=0, 1, FirstPos)
	LastPos  = IIf (LastPos=0, Len(StrEx), LastPos)
	LastPos  = IIf (LastPos>Len(StrEx), Len(StrEx), LastPos)

	If FirstPos>Len(StrEx) Or FirstPos>LastPos Then Return StrEx

	Dim Buffer As String=StrEx
	Dim MaskSearch As UInteger
	Dim MFound As Byte
	Dim lp As UInteger=FirstPos

	Do
		MaskSearch=InStr(lp,Buffer,StrMask)
		MFound=0

		If MaskSearch And MaskSearch<LastPos+1 Then
			MFound=1:lp=MaskSearch+Len(StrRplce)
			Buffer=Left(Buffer,MaskSearch-1) + StrRplce + Right(Buffer,Len(Buffer)-(MaskSearch+(Len(StrMask)-1)))
		End If
	Loop While MFound=1

	Return Buffer
End Function

'##################################################################################
' MAIN PROG
'##################################################################################

Dim source_file As String
Dim replace_what As String
Dim replace_with As String
Dim target_file As String
Dim in_buffer As String
Dim out_buffer As String
Dim f As Integer

'=======================================
' Parameter
'=======================================

If __FB_ARGC__ < 3 Then
	displayHelp()
	End
EndIf

source_file  = Command(1)
replace_what = Command(2)
replace_with = Command(3)
target_file  = Command(4)

'Print "IN  : [" & source_file & "]"
'Print "OUT : [" & target_file & "]"
'Print "WHAT: [" & replace_what & "]"

Select Case replace_what
	Case "\t": replace_what = Chr(9)
	Case "\r": replace_what = Chr(13)
	Case "\n": replace_what = Chr(10)
End Select

'Print "WHAT: [" & replace_what & "]"
'Print "WITH: [" & replace_with & "]"
'Print

' Read source file
f = FreeFile
Open source_file For Binary As #f
	in_buffer = Space(Lof(f))
	Get #f,, in_buffer
Close #f

' Replace data
out_buffer = replaceString(in_buffer, replace_what, replace_with)

' Write target file
If target_file <> "" Then
	f = FreeFile
	Open target_file For Output As #f
		Print #f, out_buffer;
	Close #f
Else
	Print out_buffer
EndIf
