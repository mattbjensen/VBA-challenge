Attribute VB_Name = "Module2"

Sub WallStreetVBA()
    
    'Author: Matt Jensen
    
    'Define variables
    Dim start As Double
    Dim last_row As Double
    Dim last_ticker_row As Double
       
    Dim open_date As Double
    Dim close_date As Double
    Dim volume As Double
    Dim ticker_open As Double
    Dim ticker_close As Double
    
    Dim ws As Worksheet
                
    'Loop through all sheets
    For Each ws In Worksheets
       
    
        'Set the starting row and find the last row of data
        start = 2
        last_row = Cells(Rows.Count, 1).End(xlUp).Row
    
        'Add labels for results section
        ws.Range("I1").Value = "Ticker"
        ws.Range("J1").Value = "Yearly Change"
        ws.Range("K1").Value = "Percent Change"
        ws.Range("L1").Value = "Total Stock Volume"
        ws.Range("P1").Value = "Ticker"
        ws.Range("Q1").Value = "Value"
        ws.Range("O2").Value = "Greatest % Increase"
        ws.Range("O3").Value = "Greatest % Decrease"
        ws.Range("O4").Value = "Greatest Total Volume"

        'Find unique ticker symbols
        ws.Range("A2:A" & last_row).AdvancedFilter _
            Action:=xlFilterCopy, _
            CopyToRange:=ws.Range("I2"), _
            Unique:=True
        ws.Range("I2").Delete xlShiftUp
                    
        'Find last row of unique ticker symbols
        last_ticker_row = ws.Cells(Rows.Count, 9).End(xlUp).Row
                    
        'Loop to add total stock volume, yearly change, and percent change
        For start = 2 To last_ticker_row
        
            'Find beginning and ending dates of data for the yearly change and percent change formulas
            open_date = WorksheetFunction.MinIfs(ws.Range("B2:B" & last_row), ws.Range("A2:A" & last_row), ws.Range("I" & start))
            close_date = WorksheetFunction.MaxIfs(ws.Range("B2:B" & last_row), ws.Range("A2:A" & last_row), ws.Range("I" & start))
            
            'Determine the opening price and the closing price for the yearly change and percent change formulas
            ticker_open = WorksheetFunction.SumIfs(ws.Range("C2:C" & last_row), ws.Range("A2:A" & last_row), ws.Range("I" & start), ws.Range("B2:B" & last_row), open_date)
            ticker_close = WorksheetFunction.SumIfs(ws.Range("F2:F" & last_row), ws.Range("A2:A" & last_row), ws.Range("I" & start), ws.Range("B2:B" & last_row), close_date)
            
            'Return and formatting the yearly change in column K
            ws.Range("J" & start).Value = ticker_close - ticker_open
            ws.Range("J" & start).NumberFormat = "$#,##0.00"
            If ws.Range("J" & start).Value < 0 Then
                ws.Range("J" & start).Interior.ColorIndex = 3
            Else: ws.Range("J" & start).Interior.ColorIndex = 4
            
            End If
                    
            'Return the percent change and formatting in column L
            If ticker_open = 0 Then
                ws.Range("K" & start).Value = 0
            Else
                ws.Range("K" & start).Value = WorksheetFunction.IfError((ticker_close / ticker_open) - 1, 0)
            End If
                
            ws.Range("K" & start).NumberFormat = "#,##0.0%"
                   
            'Add total volume and format cells
            volume = WorksheetFunction.SumIfs(ws.Range("G2:G" & last_row), ws.Range("A2:A" & last_row), ws.Range("I" & start))
            ws.Range("L" & start).Value = volume
            ws.Range("L" & start).NumberFormat = "#,##0"
                                
            'Reset variables for next calculation in the loop
            volume = Empty
            open_date = Empty
            close_date = Empty
            ticker_open = Empty
            ticker_close = Empty
                                
        Next start
                        
        'Find and return greatest increase, greatest decrease, and greatest total volume stocks
        ws.Range("Q2").Value = WorksheetFunction.Max(ws.Range("K2:K" & last_ticker_row))
        ws.Range("Q2").NumberFormat = "#,##0.0%"
        ws.Range("P2").Value = WorksheetFunction.Index(ws.Range("I2:I" & last_ticker_row), WorksheetFunction.Match(ws.Range("Q2"), ws.Range("K2:K" & last_ticker_row), 0))
        
        ws.Range("Q3").Value = WorksheetFunction.Min(ws.Range("K2:K" & last_ticker_row))
        ws.Range("Q3").NumberFormat = "#,##0.0%"
        ws.Range("P3").Value = WorksheetFunction.Index(ws.Range("I2:I" & last_ticker_row), WorksheetFunction.Match(ws.Range("Q3"), ws.Range("K2:K" & last_ticker_row), 0))
        
        ws.Range("Q4").Value = WorksheetFunction.Max(ws.Range("L2:L" & last_ticker_row))
        ws.Range("Q4").NumberFormat = "#,##0"
        ws.Range("P4").Value = WorksheetFunction.Index(ws.Range("I2:I" & last_ticker_row), WorksheetFunction.Match(ws.Range("Q4"), ws.Range("L2:L" & last_ticker_row), 0))
        
        'Auto-fit column widths
        ws.Columns("I:Q").EntireColumn.AutoFit
        
        'Reset variables for next sheet in the loop
        start = Empty
        last_row = Empty
        last_ticker_row = Empty
        
    Next
    
    
End Sub


