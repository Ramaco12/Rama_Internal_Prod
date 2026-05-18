report 71000 "Purchase Register_RAMA"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Purchase Register_RAMA';

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = field("No.");

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    RecRef.OPEN(DATABASE::"Purch. Inv. Line");
                    FildRef := RecRef.Field(3);
                    FildLineNoRef := RecRef.Field(4);
                    //FilterDate := "Purch. Inv. Header"."Posting Date";
                    "Purch. Inv. Header".SetFilter("Posting Date", '%1..%2', PostingDate, ToDate);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    // Sr += 1;
                    DocNo := "Purch. Inv. Header"."No.";
                    LineDocNo := "Purch. Inv. Line"."Line No.";
                    //  if FilterDate >= PostingDate then
                    FildRef.SetRange(DocNo);
                    // FildLineNoRef.SetRange(LineDocNo);
                    Clear(TotalCGSTAmt);
                    Clear(TotalIGSTAmt);
                    Clear(TotalSGSTAmt);
                    Clear(CGSTAmt);
                    Clear(IGSTAmt);
                    Clear(SGSTAmt);
                    Clear(GSTPer);
                    Clear(TotalNetAmt);
                    Clear(TaxAmt1);
                    Clear(CGSTPer);
                    Clear(IGSTper);
                    Clear(SGSTPer);
                    LineNo := Format("Line No.");
                    RecRef.Next();
                    IF RecRef.Find() THEN begin
                        //  repeat 
                        if (Type = Type::" ") or ("No." = '700240') then CurrReport.Skip();
                        RecID := RecRef.RECORDID;
                        RecTAXTransValue.Reset();
                        RecTaxComponent.Reset();
                        RecTAXTransValue.SetFilter("Tax Record ID", '%1', RecID);
                        RecTAXTransValue.SetFilter(Amount, '<>0');
                        RecTAXTransValue.SetFilter("Visible on Interface", 'Yes');
                        if RecTAXTransValue.FindFirst() then begin
                            repeat
                                RecTaxComponent.SetRange(ID, RecTAXTransValue."Value ID");
                                if RecTaxComponent.FindFirst() then begin
                                    TaxType := RecTaxComponent."Tax Type";
                                    CompID := RecTaxComponent.ID;
                                    TaxCompName := RecTaxComponent.Name;
                                end;
                                // if (TaxType = RecTAXTransValue."Tax Type") and (CompID = RecTAXTransValue."Value ID") then begin
                                if (RecTAXTransValue."Tax Type" = 'GST') and (CompID = RecTAXTransValue."Value ID") then begin
                                    if TaxCompName = 'CGST' then begin
                                        CGSTPer := RecTAXTransValue.Percent;
                                        CGSTAmt := RecTAXTransValue.Amount;
                                        TotalCGSTAmt += RecTAXTransValue.Amount;
                                    end
                                    else if TaxCompName = 'SGST' then begin
                                        SGSTPer := RecTAXTransValue.Percent;
                                        SGSTAmt := RecTAXTransValue.Amount;
                                        TotalSGSTAmt += RecTAXTransValue.Amount;
                                    end
                                    else if TaxCompName = 'IGST' then begin
                                        IGSTper := RecTAXTransValue.Percent;
                                        IGSTAmt := RecTAXTransValue.Amount;
                                        TotalIGSTAmt += RecTAXTransValue.Amount;
                                    end
                                    else if TaxCompName = 'GST Base Amount' then begin
                                        GSTBaseAmt := RecTAXTransValue.Amount;
                                    end;
                                    GSTPer += RecTAXTransValue.Percent;
                                    NetAmt := (TotalCGSTAmt + TotalSGSTAmt + TotalIGSTAmt);
                                end
                                else if (RecTAXTransValue."Tax Type" = 'TDS') and (RecTAXTransValue."Value ID" = 1) then begin
                                    TaxPer := RecTAXTransValue.Percent;
                                    TaxAmt1 := RecTAXTransValue.Amount;
                                end;
                            until RecTAXTransValue.Next() = 0;
                            TotalNetAmt := "Line Amount" + NetAmt;
                        end;
                        // until RecRef.Next() = 0;
                    end;
                    TotalAmtRecdINRVar += (TotalNetAmt + TaxAmt1);
                    //-----------------------------------------------------------------
                    Clear(CGSTAmtNew);
                    Clear(CGSTPerNew);
                    Clear(SGSTAmtNew);
                    Clear(SGSTPerNew);
                    Clear(IGSTAmtNew);
                    Clear(IGSTPerNew);
                    DGSTLedEntry.Reset();
                    DGSTLedEntry.SetRange("Document No.", "Purch. Inv. Line"."Document No.");
                    DGSTLedEntry.SetRange("No.", "Purch. Inv. Line"."No.");
                    DGSTLedEntry.SetRange("Document Line No.", "Purch. Inv. Line"."Line No.");
                    DGSTLedEntry.SETRANGE("Entry Type", DGSTLedEntry."Entry Type"::"Initial Entry");
                    DGSTLedEntry.SetFilter("GST Group Code", 'RCM*');
                    if DGSTLedEntry.FindFirst() then begin
                        repeat
                            if DGSTLedEntry."GST Component Code" = 'CGST' then begin
                                CGSTAmtNew += DGSTLedEntry."GST Amount";
                                CGSTPerNew := DGSTLedEntry."GST %";
                            end;
                            if DGSTLedEntry."GST Component Code" = 'SGST' then begin
                                SGSTAmtNew += DGSTLedEntry."GST Amount";
                                SGSTPerNew := DGSTLedEntry."GST %";
                            end;
                            if DGSTLedEntry."GST Component Code" = 'IGST' then begin
                                IGSTAmtNew += DGSTLedEntry."GST Amount";
                                IGSTPerNew := DGSTLedEntry."GST %";
                            end;
                        until DGSTLedEntry.Next() = 0;
                    end;
                    //tejasvi 19 march2025
                    Clear(GLCode);
                    Clear(GLName);
                    RecGLEntry.Reset();
                    RecGLEntry.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    if RecGLEntry.FindFirst() then begin
                        GLCode := RecGLEntry."G/L Account No.";
                        RecGLEntry.CalcFields(RecGLEntry."G/L Account Name");
                        GLName := RecGLEntry."G/L Account Name";
                    end;
                    //tejasvi 19 march2025
                    ExcelBuffer.NewRow;
                    //ExcelBuffer.AddColumn(Sr, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."Vendor Invoice No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."Vendor Invoice Date_L", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."Payment Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date); //Sk added 27-01-2025
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."E-Way Bill No.L", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."E-Way Bill DateL", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."Buy-from Vendor No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."Buy-from Vendor Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."Vendor Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."Vendor GST Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(VendStatName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Inv. Line".Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Inv. Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Inv. Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Inv. Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Inv. Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Inv. Line"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(locName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Inv. Header"."Location GST Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(StateName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Inv. Line"."Order Address Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(OrderName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(orderGST, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(orderState, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Inv. Line"."HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CGSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(SGSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(SGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IGSTper, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    //---------------------------------------------------------------------------------------------------------
                    //added fields tejasvi 19march2025
                    ExcelBuffer.AddColumn(RecGLEntry."G/L Account No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(RecGLEntry."G/L Account Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Inv. Line"."GST Credit", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Inv. Line"."GST Vendor Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(SGSTPerNew, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(SGSTAmtNew, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CGSTPerNew, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CGSTAmtNew, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IGSTperNew, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IGSTAmtNew, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    //---------------------------------------------------------------------------------------------------------
                    ExcelBuffer.AddColumn("Purch. Inv. Line"."TDS Section Code", FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TaxPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Inv. Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TaxAmt1, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(GSTBaseAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(((GSTBaseAmt + CGSTAmt + SGSTAmt + IGSTAmt) - TaxAmt1), FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    //  ExcelBuffer.AddColumn("Purch. Inv. Header"."Vehicle No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(SIComment, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(FullName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //added certificate no in sales register report tejasvi 25march25
                end;

                trigger OnPostDataItem()
                var
                    myInt: Integer;
                begin
                    RecRef.Close();
                end;
            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                SetRange("Posting Date", PostingDate, ToDate);
                //Sr := 0;
                ExcelBuffer.NewRow();
                // ExcelBuffer.AddColumn('Sr.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Invoice No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Document No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Payment Date', false, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //Sk added 27-01-2025
                ExcelBuffer.AddColumn('Vendor E-Way Bill No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Vendor E-Way Bill Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Vendor No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Vendor Group ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Vendor GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Vendor State', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Item Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Quantity', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location State ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Order Address Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Order Address Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Order Address GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Order Address State', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('GST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('HSN Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('CGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('CGST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('SGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('SGST ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('IGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('IGST ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                //-------------------------------------------------------------------------------------------------
                //added fields tejasvi 19march2025
                ExcelBuffer.AddColumn('GL CODE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('GL NAME', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('GST CREDIT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Vendor Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('RCM SGST%', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('RCM SGST AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('RCM CGST%', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('RCM CGST AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('RCM IGST%', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('RCM IGST AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                //----------------------------------------------------------------------------------------------------------
                ExcelBuffer.AddColumn('TDS Section ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TDS % ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TDS Taxable Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TDS Amount ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Gross Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Net Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                //  ExcelBuffer.AddColumn('Vehicle No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Comments', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('User ID', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Deduction Applicability/Certificate no.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                Comlogo();
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Clear(locName);
                RecLoc.Reset();
                RecLoc.SetRange(Code, "Location Code");
                if RecLoc.FindFirst() then locName := RecLoc.Name;
                RecState.Reset();
                Clear(StateName);
                RecState.SetRange(Code, "Location State Code");
                if RecState.FindFirst() then StateName := RecState.Description;
                RecUser.Reset();
                RecUser.SetRange("User Name", "User ID");
                if RecUser.FindFirst() then
                    FullName := RecUser."Full Name"
                else
                    FullName := RecUser."User Name";
                RecVendor.Reset();
                Clear(VendStatName);
                RecVendor.SetRange("No.", "Buy-from Vendor No.");
                if RecVendor.FindFirst() then begin
                    RecState.SetRange(Code, RecVendor."State Code");
                    if RecState.FindFirst() then VendStatName := RecState.Description;
                end;
                RecOrDerAdd.Reset();
                Clear(OrderName);
                Clear(orderGST);
                Clear(orderState);
                RecOrDerAdd.SetRange(Code, "Order Address Code");
                if RecOrDerAdd.FindFirst() then begin
                    OrderName := RecOrDerAdd.Name;
                    orderGST := RecOrDerAdd."GST Registration No.";
                    orderState := RecOrDerAdd.State;
                end;
                RecPCL.Reset();
                Clear(SIComment);
                RecPCL.SetRange("No.", "Purch. Inv. Header"."No.");
                if RecPCL.FindFirst() then SIComment := RecPCL.Comment;
                //tejasvi
            end;
        }
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemLink = "Document No." = field("No.");

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    CM_RecRef.OPEN(DATABASE::"Purch. Cr. Memo Line");
                    CM_FildRef := CM_RecRef.Field(3);
                    //FilterDate := "Purch. Inv. Header"."Posting Date";
                    "Purch. Cr. Memo Hdr.".SetFilter("Posting Date", '%1..%2', PostingDate, ToDate);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    // Sr2 += 1;
                    CM_DocNo := "Purch. Cr. Memo Hdr."."No.";
                    CM_LineDocNo := "Purch. Cr. Memo Line"."Line No.";
                    //  if FilterDate >= PostingDate then
                    CM_FildRef.SetRange(CM_DocNo);
                    Clear(CM_TotalCGSTAmt);
                    Clear(CM_TotalIGSTAmt);
                    Clear(CM_TotalSGSTAmt);
                    Clear(CM_CGSTAmt);
                    Clear(CM_IGSTAmt);
                    Clear(CM_SGSTAmt);
                    Clear(CM_GSTPer);
                    Clear(CM_CGSTPer);
                    Clear(CM_IGSTper);
                    Clear(CM_SGSTPer);
                    Clear(CM_TotalNetAmt);
                    Clear(CM_TaxAmt1);
                    CM_LineNo := Format("Line No.");
                    CM_RecRef.Next();
                    IF CM_RecRef.Find() THEN begin
                        //  repeat 
                        if ("Purch. Cr. Memo Line".Type = Type::" ") or ("Purch. Cr. Memo Line"."No." = '700240') then CurrReport.Skip();
                        CM_RecID := CM_RecRef.RECORDID;
                        CM_RecTAXTransValue.Reset();
                        CM_RecTaxComponent.Reset();
                        CM_RecTAXTransValue.SetFilter("Tax Record ID", '%1', CM_RecID);
                        CM_RecTAXTransValue.SetFilter(Amount, '<>0');
                        CM_RecTAXTransValue.SetFilter("Visible on Interface", 'Yes');
                        if CM_RecTAXTransValue.FindFirst() then begin
                            repeat
                                CM_RecTaxComponent.SetRange(ID, CM_RecTAXTransValue."Value ID");
                                if CM_RecTaxComponent.FindFirst() then begin
                                    CM_TaxType := CM_RecTaxComponent."Tax Type";
                                    CM_CompID := CM_RecTaxComponent.ID;
                                    CM_TaxCompName := CM_RecTaxComponent.Name;
                                end;
                                // if (TaxType = RecTAXTransValue."Tax Type") and (CompID = RecTAXTransValue."Value ID") then begin
                                if (CM_RecTAXTransValue."Tax Type" = 'GST') and (CM_CompID = CM_RecTAXTransValue."Value ID") then begin
                                    if CM_TaxCompName = 'CGST' then begin
                                        CM_CGSTPer := CM_RecTAXTransValue.Percent;
                                        CM_CGSTAmt := CM_RecTAXTransValue.Amount;
                                        CM_TotalCGSTAmt += CM_RecTAXTransValue.Amount;
                                    end
                                    else if CM_TaxCompName = 'SGST' then begin
                                        CM_SGSTPer := CM_RecTAXTransValue.Percent;
                                        CM_SGSTAmt := CM_RecTAXTransValue.Amount;
                                        CM_TotalSGSTAmt += CM_RecTAXTransValue.Amount;
                                    end
                                    else if CM_TaxCompName = 'IGST' then begin
                                        CM_IGSTper := CM_RecTAXTransValue.Percent;
                                        CM_IGSTAmt := CM_RecTAXTransValue.Amount;
                                        CM_TotalIGSTAmt += CM_RecTAXTransValue.Amount;
                                    end
                                    else if CM_TaxCompName = 'GST Base Amount' then begin
                                        CM_GSTBaseAmt := CM_RecTAXTransValue.Amount;
                                    end;
                                    CM_GSTPer += CM_RecTAXTransValue.Percent;
                                    CM_NetAmt := (CM_TotalCGSTAmt + CM_TotalSGSTAmt + CM_TotalIGSTAmt);
                                end
                                else if (CM_RecTAXTransValue."Tax Type" = 'TCS') and (CM_RecTAXTransValue."Value ID" = 1) then begin
                                    CM_TaxPer := RecTAXTransValue.Percent;
                                    CM_TaxAmt1 := RecTAXTransValue.Amount;
                                end;
                            until CM_RecTAXTransValue.Next() = 0;
                            CM_TotalNetAmt := "Line Amount" + CM_NetAmt;
                        end;
                        // until RecRef.Next() = 0;
                    end;
                    CM_TotalAmtRecdINRVar += (CM_TotalNetAmt + CM_TaxAmt1);
                    ExcelBuffer.NewRow;
                    // ExcelBuffer.AddColumn(Sr2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Buy-from Vendor No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Buy-from Vendor Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Vendor Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_VendStatName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Line".Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Line"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_locName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Location GST Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(CM_StateName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Line"."Order Address Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(CM_OrderName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(CM_orderGST, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(CM_orderState, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(CM_GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Line"."HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_CGSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_CGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_SGSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_SGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_IGSTper, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_IGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_TaxPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Purch. Cr. Memo Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_TaxAmt1, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_GSTBaseAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(((CM_GSTBaseAmt + CM_CGSTAmt + CM_SGSTAmt + CM_IGSTAmt) - CM_TaxAmt1), FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    //  ExcelBuffer.AddColumn("Purch. Cr. Memo Hdr."."Vehicle No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_SIComment, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_FullName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                end;

                trigger OnPostDataItem()
                var
                    myInt: Integer;
                begin
                    CM_RecRef.Close();
                end;
            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                SetRange("Posting Date", PostingDate, ToDate);
                //  Sr2 := 0;
                ExcelBuffer.NewRow();
                CM_MakeExcelHeader();
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn('Sr.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Invoice No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Document No. ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Vendor E-Way Bill No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Vendor E-Way Bill Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Vendor No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Vendor Group ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Vendor GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Vendor State', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Item Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Quantity', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location State ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Order Address Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Order Address Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Order Address GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Order Address State', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('GST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('HSN Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('CGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('CGST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('SGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('SGST ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('IGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('IGST ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TDS Section ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TDS % ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TDS Taxable Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('TDS Amount ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Gross Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Net Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                // ExcelBuffer.AddColumn('Vehicle No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Comments', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('User ID', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Clear(CM_locName);
                CM_RecLoc.Reset();
                CM_RecLoc.SetRange(Code, "Location Code");
                if CM_RecLoc.FindFirst() then CM_locName := RecLoc.Name;
                CM_RecState.Reset();
                Clear(CM_StateName);
                CM_RecState.SetRange(Code, "Location State Code");
                if CM_RecState.FindFirst() then CM_StateName := RecState.Description;
                CM_RecUser.Reset();
                CM_RecUser.SetRange("User Name", "User ID");
                if CM_RecUser.FindFirst() then
                    CM_FullName := RecUser."Full Name"
                else
                    CM_FullName := RecUser."User Name";
                CM_RecVendor.Reset();
                Clear(CM_VendStatName);
                CM_RecVendor.SetRange("No.", "Buy-from Vendor No.");
                if CM_RecVendor.FindFirst() then begin
                    CM_RecState.SetRange(Code, CM_RecVendor."State Code");
                    if CM_RecState.FindFirst() then CM_VendStatName := CM_RecState.Description;
                end;
                CM_RecPCL.Reset();
                Clear(CM_SIComment);
                CM_RecPCL.SetRange("No.", "Purch. Cr. Memo Hdr."."No.");
                if CM_RecPCL.FindFirst() then CM_SIComment := CM_RecPCL.Comment;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Date Filters")
                {
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the value of the Posting Date field.';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                        ToolTip = 'Specifies the value of the To Date field.';
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
    var
        myInt: Integer;
    begin
        ExcelBuffer.DELETEALL;
        Clear(PeriodText);
        Clear(PeriodText1);
        PeriodText := Format(PostingDate);
        PeriodText1 := Format(ToDate);
        companyinf.Reset();
        if companyinf.FindFirst() then CompName := companyinf.Name;
        MakeExcelInfo();
        MakeExcelHeader();
    end;

    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        CreateExcel();
        //CurrReport.SHOWOUTPUT(FALSE);
        //CurrReport.QUIT;
    end;

    var
        recpurchinv: Record "Purch. Inv. Header";
        GLCode: Code[100];
        GLName: Text[300];
        IGSTperNew: Decimal;
        CGSTPerNew: Decimal;
        SGSTPerNew: Decimal;
        IGSTAmtNew: Decimal;
        CGSTAmtNew: Decimal;
        SGSTAmtNew: Decimal;
        DGSTLedEntry: Record "Detailed GST Ledger Entry";
        RecGLEntry: Record "G/L Entry";
        RecPCL: Record "Purch. Comment Line";
        SIComment: Text;
        CM_RecPCL: Record "Purch. Comment Line";
        CM_SIComment: Text;
        myInt: Integer;
        PeriodText1: Text[30];
        PeriodText: Text[30];
        ExcelBuffer: Record "Excel Buffer" temporary;
        txtData: array[250] of Text[250];
        txtData1: array[250] of Text[250];
        companyinf: Record "Company Information";
        Sr: Integer;
        Sr2: Integer;
        PostingDate: Date;
        ToDate: Date;
        RecLoc: Record Location;
        locName: Text;
        RecState: Record State;
        StateName: Text;
        GSTPlaceOfSupply: Text;
        GSTStateName: Text;
        RecUser: Record User;
        FullName: Text;
        RecVendor: Record Vendor;
        VendStatName: text;
        RecOrDerAdd: Record "Order Address";
        OrderName: Text[100];
        orderGST: Code[20];
        orderState: Code[10];
        CM_RecVendor: Record Vendor;
        CM_VendStatName: text;
        CM_RecOrDerAdd: Record "Order Address";
        CM_OrderName: Text[100];
        CM_orderGST: Code[20];
        CM_orderState: Code[10];
        //GST Calculation
        RecTAXTransValue: Record "Tax Transaction Value";
        LineDocNo: Integer;
        LineNo: Code[20];
        RecID: RecordId;
        RecRef: RecordRef;
        VarTableNo: Integer;
        TotalIGSTAmt: Decimal;
        TotalCGSTAmt: Decimal;
        TotalSGSTAmt: Decimal;
        EvaLineNo: Text;
        EvalDocNo: Text;
        TaxRecID: Text;
        RecTaxComponent: Record "Tax Component";
        TaxType: code[20];
        CompID: Integer;
        FildRef: FieldRef;
        FildLineNoRef: FieldRef;
        FilterDate: Date;
        TaxCompName: Text;
        TotalGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        TotalNetAmt: Decimal;
        NetAmt: Decimal;
        TotalLineAmt: Decimal;
        GSTPer: Decimal;
        TaxPer: Decimal;
        TaxAmt1: Decimal;
        TotalAmtRecdINRVar: Decimal;
        DocNo: Code[20];
        IGSTper: Decimal;
        CGSTPer: Decimal;
        SGSTPer: Decimal;
        GSTBaseAmt: Decimal;
        CompName: text;
        //GST Calculation for credit memo
        CM_ExcelBuffer: Record "Excel Buffer" temporary;
        CM_txtData: array[250] of Text[250];
        CM_RecLoc: Record Location;
        CM_locName: Text;
        CM_RecState: Record State;
        CM_StateName: Text;
        CM_GSTPlaceOfSupply: Text;
        CM_GSTStateName: Text;
        CM_RecUser: Record User;
        CM_FullName: Text;
        CM_RecTAXTransValue: Record "Tax Transaction Value";
        CM_LineDocNo: Integer;
        CM_LineNo: Code[20];
        CM_RecID: RecordId;
        CM_RecRef: RecordRef;
        CM_VarTableNo: Integer;
        CM_TotalIGSTAmt: Decimal;
        CM_TotalCGSTAmt: Decimal;
        CM_TotalSGSTAmt: Decimal;
        CM_EvaLineNo: Text;
        CM_EvalDocNo: Text;
        CM_TaxRecID: Text;
        CM_RecTaxComponent: Record "Tax Component";
        CM_TaxType: code[20];
        CM_CompID: Integer;
        CM_FildRef: FieldRef;
        CM_FilterDate: Date;
        CM_TaxCompName: Text;
        CM_TotalGSTAmt: Decimal;
        CM_IGSTAmt: Decimal;
        CM_CGSTAmt: Decimal;
        CM_SGSTAmt: Decimal;
        CM_TotalNetAmt: Decimal;
        CM_NetAmt: Decimal;
        CM_TotalLineAmt: Decimal;
        CM_GSTPer: Decimal;
        CM_TaxPer: Decimal;
        CM_TaxAmt1: Decimal;
        CM_TotalAmtRecdINRVar: Decimal;
        CM_DocNo: Code[20];
        CM_IGSTper: Decimal;
        CM_CGSTPer: Decimal;
        CM_SGSTPer: Decimal;
        CM_GSTBaseAmt: Decimal;

    procedure Comlogo()
    var
        myInt: Integer;
    begin
        companyinf.get();
        companyinf.CalcFields(Picture);
    end;

    procedure MakeexcelInfo()
    var
        myInt: Integer;
    begin
        ExcelBuffer.SetUseInfoSheet;
        ExcelBuffer.AddInfoColumn(COMPANYNAME, FALSE, TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddInfoColumn(USERID, FALSE, TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddInfoColumn(Today, false, TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.ClearNewRow;
    end;

    procedure MakeExcelHeader()
    var
        myInt: Integer;
    begin
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Purchase Register', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(CompName, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(PeriodText, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(PeriodText1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Details Of Purchase Invoice', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    procedure CM_MakeExcelHeader()
    var
        myInt: Integer;
    begin
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Details Of Credit Note', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    procedure CreateExcel()
    var
        myInt: Integer;
    begin
        //ExcelBuffer.CreateNewExcelBookL('', 'Purchase Register', 'Purchase Register', CompanyName, UserId);
        ExcelBuffer.CreateNewBook('Purchase Register');
        ExcelBuffer.WriteSheet('Purchase Register', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.OpenExcel();
    end;
}
