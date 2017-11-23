
Function Replace(ByVal V_Data As String, ByVal V_Expression As String, ByVal V_ReplaceBy As String) As String
	Dim X As Long
	Dim SL As Long
	Dim D As String
	D = V_Data
	SL = Len(V_Expression)
	X = 0
	Do
	    X = X + 1
	    If X > Len(D) - SL + 1 Then Exit Do
	    If Mid(D, X, SL) = V_Expression Then
	        D = Mid(D, 1, X - 1) & V_ReplaceBy & Mid(D, X + SL)
	        X = X + (SL  - 1)
	        If X < 0 Then X = 0
	    End If
	Loop
	Return D
End Function

Dim source_file As String = Command(1)
Dim replace_what As String = Command(2)
Dim replace_with As String = Command(3)
Dim target_file As String = Command(4)

Dim in_buffer As String
Dim out_buffer As String
Dim f As Integer

'Print "IN  :" & source_file
'Print "OUT :" & target_file
'Print "WHAT:" & replace_what
'Print "WITH:" & replace_with
'Print

f = FreeFile
Open source_file For Input As #f
	Do Until Eof(f)
		Line Input #f, in_buffer
		
		out_buffer = out_buffer & Replace(in_buffer, replace_what, replace_with) ' & Chr(13, 10)
	Loop
Close #f

If target_file <> "" Then
	f = FreeFile
	Open target_file For Output As #f
		Print #f, out_buffer
	Close #f
Else
	Print out_buffer
EndIf
