report 70205 "Mandate E/L Uploader"
{
    Caption = 'Mandate E/L Uploader';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Mandate Header"; "Mandate Header")
        {
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            begin
                if DocumentNo <> '' then
                    SetRange("No.", DocumentNo);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(ServerFileName; ServerFileName)
                    {
                        ApplicationArea = All;
                        Caption = 'File Name';
                        ToolTip = 'Specifies the value of the File Name field.';

                        trigger OnAssistEdit()
                        begin
                            UploadIntoStream(UploadExcelMsg, '', '', FromServerFileName, Istream);
                            if FromServerFileName <> '' then
                                ServerFileName := FileManagement.GetFileName(FromServerFileName)
                            else
                                ERROR('File does not exit');
                        end;
                    }
                    field(SheetName; SheetName)
                    {
                        ApplicationArea = All;
                        Caption = 'Sheet Name';
                        ToolTip = 'Specifies the value of the Sheet Name field.';

                        trigger OnAssistEdit()
                        begin
                            SheetName := ExcelBuffer.SelectSheetsNameStream(Istream);
                            IF SheetName = '' THEN ERROR('');
                        end;
                    }
                    field(ExportTemplateFormat; ExportTemplateFormat)
                    {
                        ApplicationArea = All;
                        Caption = 'Export Template Format';
                        ToolTip = 'Specifies the value of the Export Template Format field.';
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the ActionName action.';
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        IF ExportTemplateFormat THEN BEGIN
            TempExcelBuffer.DELETEALL;
            MakeHeader;
        END;
    end;

    trigger OnpostReport()
    begin
        IF NOT ExportTemplateFormat THEN BEGIN
            ExcelBuffer.DELETEALL;
            ExcelBuffer.LOCKTABLE;
            ExcelBuffer.OpenBookStream(Istream, SheetName);
            ExcelBuffer.ReadSheet();
            GetLastRowandColumn;
            FOR X := 2 TO TotalRows DO InsertData(X);
            ExcelBuffer.DELETEALL;
        END;
        IF ExportTemplateFormat THEN begin
            CreateExcelBook;
        end
        else
            Message('Mandate Line Successfully Created');
    end;

    var
        ExportTemplateFormat: boolean;
        SheetName: Text;
        ServerFileName: Text;
        DocumentNo: Code[20];
        FromServerFileName: Text;
        ExcelBuffer: record "Excel Buffer";
        FileManagement: Codeunit "File Management";
        TotalColumns: Integer;
        TotalRows: Integer;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        X: Integer;
        Istream: InStream;
        UploadExcelMsg: Text;
        TempDocumentNo: code[20];
        LineNo: Integer;
        CustOrderNo: Code[20];
        TempCustOrderNo: code[20];
        // NoSeriesLine: Record "No. Series Line";
        TempDocNo: Code[20];
        PurchaseLine: Record "Mandate Line";

    procedure SetDocNo(DocNo: Code[20])
    begin
        DocumentNo := DocNo;
    end;

    local procedure MakeHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('No.', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Quantity', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Unit Of Measure Code', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description 2', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuffer."Cell Type"::Text);

    end;

    Local procedure CreateExcelBook();
    begin
        TempExcelBuffer.CreateNewBook('Mandate Lines');
        TempExcelBuffer.WriteSheet('Mandate Lines', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Mandate Lines');
        TempExcelBuffer.OpenExcel();
    end;

    local procedure GetLastRowandColumn()
    var
        myInt: Integer;
    begin
        ExcelBuffer.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuffer.COUNT;
        ExcelBuffer.RESET;
        IF ExcelBuffer.FINDLAST THEN TotalRows := ExcelBuffer."Row No.";
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): text
    begin
        IF ExcelBuffer.GET(RowNo, ColNo) THEN
            EXIT(ExcelBuffer."Cell Value as Text");
    end;

    local procedure InsertData(RowNo: Integer)
    var
        Type: Text;
        Text000: Label 'You are not allow to enter duplicate Item No. %1';
        LineNo: Integer;
        purchaseLineLrec: Record "Mandate Line";
    begin
        purchaseLineLrec.Reset();
        // purchaseLineLrec.SetRange("Document Type", purchaseLineLrec."Document Type"::Order);
        purchaseLineLrec.SetRange("Mandate Document No.", "Mandate Header"."No.");
        if purchaseLineLrec.FindLast() then
            LineNo := purchaseLineLrec."Line No." + 10000
        else
            LineNo := 10000;

        PurchaseLine.Init();
        // PurchaseLine."Document Type" := "Purchase Header"."Document Type";
        PurchaseLine."Mandate Document No." := "Mandate Header"."No.";
        PurchaseLine."Line No." := LineNo;
        PurchaseLine.Insert(true);

        IF GetValueAtCell(RowNo, 1) <> '' THEN begin
            PurchaseLine.Validate("Item No.", GetValueAtCell(RowNo, 1));
        end
        ELSE
            ERROR('Item No. must not be blank');

        IF GetValueAtCell(RowNo, 2) <> '' THEN begin
            Evaluate(PurchaseLine.Quantity, GetValueAtCell(RowNo, 2));
            PurchaseLine.Validate(Quantity);
        end
        else
            Error('Quantity must not be blank.');

        IF GetValueAtCell(RowNo, 3) <> '' THEN begin
            PurchaseLine.Validate("Unit of Measure Code", GetValueAtCell(RowNo, 3));
        end;

        IF GetValueAtCell(RowNo, 4) <> '' THEN begin
            PurchaseLine.Description := GetValueAtCell(RowNo, 4);
        end;
        // ELSE
        //     ERROR('Description must not be blank');
        PurchaseLine."Description 2" := GetValueAtCell(RowNo, 5);

        PurchaseLine.Modify(true);
    end;
}
