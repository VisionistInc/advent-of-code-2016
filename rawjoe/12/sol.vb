Module sol
    Sub Main()
        Const JNZ As Integer = 0, CPY As Integer = 1, INC As Integer = 2, DEC As Integer = 3
        Const REG As Integer = 0, VAL As Integer = 1
        Const REGC As Integer = 0
        ' Const REGC As Integer = 1
        Dim regs(4) As Integer
        Dim instructions(50) As Integer
        Dim flag(50) As Integer
        Dim param1(50) As Integer
        Dim param2(50) As Integer
        Dim pc As Integer
        Console.WriteLine("Hello, World!") ' Display message on computer screen.
        Dim reader = My.Computer.FileSystem.OpenTextFileReader("C:\DataStore\input")
        Dim a As String
        Dim lastInst As Integer

        pc = 0
        Do
            a = reader.ReadLine
            Dim params() As String = Split(a)
            If params(0).Equals("jnz") Then
                instructions(pc) = JNZ
                param2(pc) = CInt(params(2))
                If params(1)(0) > "9" Then
                    flag(pc) = REG
                    param1(pc) = Microsoft.VisualBasic.AscW(params(1)(0)) - Microsoft.VisualBasic.AscW("a")
                Else
                    flag(pc) = VAL
                    param1(pc) = CInt(params(1))
                End If
            End If
            If params(0).Equals("cpy") Then
                instructions(pc) = CPY
                param2(pc) = Microsoft.VisualBasic.AscW(params(2)(0)) - Microsoft.VisualBasic.AscW("a")
                If params(1)(0) > "9" Then
                    flag(pc) = REG
                    param1(pc) = Microsoft.VisualBasic.AscW(params(1)(0)) - Microsoft.VisualBasic.AscW("a")
                Else
                    flag(pc) = VAL
                    param1(pc) = CInt(params(1))
                End If
            End If
            If params(0).Equals("inc") Then
                instructions(pc) = INC
                param1(pc) = Microsoft.VisualBasic.AscW(params(1)(0)) - Microsoft.VisualBasic.AscW("a")
            End If
            If params(0).Equals("dec") Then
                instructions(pc) = DEC
                param1(pc) = Microsoft.VisualBasic.AscW(params(1)(0)) - Microsoft.VisualBasic.AscW("a")
            End If
            pc = pc + 1
            Console.WriteLine(a)
        Loop Until a Is Nothing
        reader.Close()
        lastInst = pc - 1
        pc = 0
        regs(0) = 0
        regs(1) = 0
        regs(2) = REGC
        regs(3) = 0
        Do
            If instructions(pc) = JNZ Then
                If flag(pc) = REG Then
                    If regs(param1(pc)) = 0 Then
                        pc = pc + 1
                    Else
                        pc = pc + param2(pc)
                    End If
                Else
                    If param1(pc) = 0 Then
                        pc = pc + 1
                    Else
                        pc = pc + param2(pc)
                    End If
                End If
            ElseIf instructions(pc) = CPY Then
                If flag(pc) = REG Then
                    regs(param2(pc)) = regs(param1(pc))
                Else
                    regs(param2(pc)) = param1(pc)
                End If
                pc = pc + 1
            ElseIf instructions(pc) = INC Then
                regs(param1(pc)) = regs(param1(pc)) + 1
                pc = pc + 1
            Else
                regs(param1(pc)) = regs(param1(pc)) - 1
                pc = pc + 1
            End If
        Loop Until pc = lastInst
        For i As Integer = 0 To 3
            Console.Write(regs(i) & " ")
        Next
        Console.WriteLine("")

        Console.ReadLine()
    End Sub
End Module
