report 71001 "Sales Register_RAMA"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Sales Register_RAMA';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    RecRef.OPEN(DATABASE::"Sales Invoice Line");
                    FildRef := RecRef.Field(3);
                    //FilterDate := "Sales Invoice Header"."Posting Date";
                    "Sales Invoice Header".SetFilter("Posting Date", '%1..%2', PostingDate, ToDate);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Sr += 1;
                    DocNo := "Sales Invoice Header"."No.";
                    LineDocNo := "Sales Invoice Line"."Line No.";
                    //  if FilterDate >= PostingDate then
                    FildRef.SetRange(DocNo);
                    Clear(TotalCGSTAmt);
                    Clear(TotalIGSTAmt);
                    Clear(TotalSGSTAmt);
                    clear(GSTBaseAmt);
                    Clear(CGSTAmt);
                    Clear(IGSTAmt);
                    Clear(SGSTAmt);
                    Clear(GSTPer);
                    Clear(CGSTPer);
                    Clear(IGSTper);
                    Clear(SGSTPer);
                    Clear(TotalNetAmt);
                    Clear(TaxAmt1);
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
                                else if (RecTAXTransValue."Tax Type" = 'TCS') and (RecTAXTransValue."Value ID" = 1) then begin
                                    TaxPer := RecTAXTransValue.Percent;
                                    TaxAmt1 := RecTAXTransValue.Amount;
                                end;
                            until RecTAXTransValue.Next() = 0;
                            TotalNetAmt := "Line Amount" + NetAmt;
                        end;
                        // until RecRef.Next() = 0;
                    end;
                    TotalAmtRecdINRVar += (TotalNetAmt + TaxAmt1);
                    Clear(ExchangeRate);
                    RecCurrencyExchangeRate.Reset();
                    RecCurrencyExchangeRate.SetRange("Currency Code", "Sales Invoice Header"."Currency Code");
                    if RecCurrencyExchangeRate.FindLast() then begin
                        ExchangeRate := RecCurrencyExchangeRate."Relational Exch. Rate Amount";
                    end;
                    Clear("Amount(Lcy)");
                    if ExchangeRate <> 0 then
                        "Amount(Lcy)" := ExchangeRate * "Sales Invoice Line"."Line Amount"
                    else
                        "Amount(Lcy)" := "Sales Invoice Line"."Line Amount";
                    ExcelBuffer.NewRow;
                    // ExcelBuffer.AddColumn(Sr, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    //ExcelBuffer.AddColumn("Sales Invoice Header"."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    // ExcelBuffer.AddColumn("Sales Invoice Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."Pre-Assigned No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."Nature of Supply", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."E-Way Bill No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    // ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."E-Way Bill Date_L", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."SI_BL No.", false, '', false, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number); //DJ 12/03/25
                    ExcelBuffer.AddColumn("Sales Invoice Header"."SI_BL Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date); //DJ 12/03/25
                    ExcelBuffer.AddColumn("Sales Invoice Header"."Bill-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."Bill-to Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."Customer GST Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."GST Bill-to State Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Line".Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //Dj 12/03/25
                    // ExcelBuffer.AddColumn("Sales Invoice Header"."SI_Shipping Bill No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    // ExcelBuffer.AddColumn("Sales Invoice Header"."SI_Shipping Bill Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Header".SI_POL, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(RecPortName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    //ExcelBuffer.AddColumn(Glna, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Line"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(locName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."Location GST Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(StateName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."E-Invoice No._L", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."E-Invoice Date_L", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Line"."GST Place of Supply", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."Currency Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    GSTPlaceOfSupply := Format("GST Place of Supply");
                    if GSTPlaceOfSupply = 'Ship-to Address' then begin
                        ExcelBuffer.AddColumn("Sales Invoice Header"."Ship-to Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn("Sales Invoice Header"."Ship-to Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn("Sales Invoice Header"."Ship-to GST Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(GSTStateName, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    end
                    else begin
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    end;
                    ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Line"."HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CGSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(SGSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(SGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IGSTper, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Line"."TCS Nature of Collection_", FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TaxPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TaxAmt1, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    //  ExcelBuffer.AddColumn(GSTBaseAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    //ExcelBuffer.AddColumn(((GSTBaseAmt + CGSTAmt + SGSTAmt + IGSTAmt) + TaxAmt1), FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn((("Sales Invoice Line"."Line Amount" + CGSTAmt + SGSTAmt + IGSTAmt) + TaxAmt1), FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Amount(Lcy)", FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Header".Comment, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(FullName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Invoice Header"."Export Invoice Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //Sk added newly 27-01-2025
                    ExcelBuffer.AddColumn("Sales Invoice Header"."Bill Of Export Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //Sk added newly 27-01-2025
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
                Sr := 0;
                ExcelBuffer.NewRow();
                // ExcelBuffer.AddColumn('Sr.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                // ExcelBuffer.AddColumn('Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn('Invoice Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Document No. ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('External Document No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Type of Sale', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('E-way bill No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('E-way bill Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('BL No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //Dj 12/03/25
                ExcelBuffer.AddColumn('BL Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //Dj 12/03/25
                ExcelBuffer.AddColumn('Customer No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer Group ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer State', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Item Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Qty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Unit Price Excl VAT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //Dj 12/03/25
                ExcelBuffer.AddColumn('Shipping Bill Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Shipping Bill Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Port Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Port Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location State ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('E-Invoice No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('E-Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('GST Place Of Supply', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Currency Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Ship-to Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Ship-to Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Ship-to GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Ship-to State', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('GST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('HSN Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('CGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('CGST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('SGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('SGST ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('IGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('IGST ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TCS Section ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TCS % ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TCS Amount ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Gross Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Taxable Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Amount(Lcy)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Comments', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('User ID', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Export Invoice Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); //Sk added
                ExcelBuffer.AddColumn('Bill of Export Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text); //Sk added
                Comlogo();
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            //Glna: Text;
            begin
                //Added
                Clear(Glna);
                "Sales Invoice Line".Reset();
                "Sales Invoice Line".SetRange(Type, "Sales Invoice Line".Type::"G/L Account");
                "Sales Invoice Line".SetRange("No.", "No.");
                if "Sales Invoice Line".FindFirst() then Glna := "Sales Invoice Line".Description;
                //added
                Clear(locName);
                RecLoc.Reset();
                RecLoc.SetRange(Code, "Location Code");
                if RecLoc.FindFirst() then locName := RecLoc.Name;
                RecState.Reset();
                Clear(StateName);
                RecState.SetRange(Code, "Location State Code");
                if RecState.FindFirst() then StateName := RecState.Description;
                RecState.Reset();
                Clear(GSTStateName);
                RecState.SetRange(Code, "GST Ship-to State Code");
                if RecState.FindFirst() then GSTStateName := RecState.Description;
                RecUser.Reset();
                RecUser.SetRange("User Name", "User ID");
                if RecUser.FindFirst() then
                    FullName := RecUser."Full Name"
                else
                    FullName := RecUser."User Name";
                Clear(RecPortName);
                RecPortL.Reset();
                RecPortL.SetRange("Port Code", SI_POL);
                If RecPortL.FindFirst() then RecPortName := RecPortL."Port Name";
            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = field("No.");

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    CM_RecRef.OPEN(DATABASE::"Sales Cr.Memo Line");
                    CM_FildRef := CM_RecRef.Field(3);
                    //FilterDate := "Sales Invoice Header"."Posting Date";
                    "Sales Cr.Memo Header".SetFilter("Posting Date", '%1..%2', PostingDate, ToDate);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Sr2 += 1;
                    CM_DocNo := "Sales Cr.Memo Header"."No.";
                    CM_LineDocNo := "Sales Cr.Memo Line"."Line No.";
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
                        if ("Sales Cr.Memo Line".Type = Type::" ") or ("Sales Cr.Memo Line"."No." = '700240') then CurrReport.Skip();
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
                    CM_RecCurrencyExchangeRate.Reset();
                    CM_RecCurrencyExchangeRate.SetRange("Currency Code", "Sales Cr.Memo Header"."Currency Code");
                    if CM_RecCurrencyExchangeRate.FindLast() then begin
                        CM_ExchangeRate := RecCurrencyExchangeRate."Relational Exch. Rate Amount";
                    end;
                    Clear("CM_Amount(Lcy)");
                    "CM_Amount(Lcy)" := CM_ExchangeRate * "Sales Cr.Memo Line"."Line Amount";
                    ExcelBuffer.NewRow;
                    //  ExcelBuffer.AddColumn(Sr2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    //ExcelBuffer.AddColumn("Sales Cr.Memo Header"."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    // ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Pre-Assigned No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Nature of Supply", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Bill-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Bill-to Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Customer GST Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."GST Bill-to State Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Line".Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //Dj 12/03/25
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Line"."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_locName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Location GST Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(CM_StateName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Line"."GST Place of Supply", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Currency Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    CM_GSTPlaceOfSupply := Format("GST Place of Supply");
                    if CM_GSTPlaceOfSupply = 'Ship-to Address' then begin
                        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Ship-to Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Ship-to Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn("Sales Cr.Memo Header"."Ship-to GST Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(CM_GSTStateName, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    end
                    else begin
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    end;
                    ExcelBuffer.AddColumn(CM_GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Line"."HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_CGSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_CGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_SGSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_SGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_IGSTper, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_IGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Line"."TCS Nature of Collection_", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_TaxPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(CM_TaxAmt1, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    //ExcelBuffer.AddColumn(CM_GSTBaseAmt, FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    //xcelBuffer.AddColumn(((CM_GSTBaseAmt + CM_CGSTAmt + CM_SGSTAmt + CM_IGSTAmt) + CM_TaxAmt1), FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn((("Sales Cr.Memo Line"."Line Amount" + CM_CGSTAmt + CM_SGSTAmt + CM_IGSTAmt) + CM_TaxAmt1), FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("CM_Amount(Lcy)", FALSE, '', FALSE, FALSE, FALSE, '#,0.00', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn("Sales Cr.Memo Header".Comment, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
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
                Sr2 := 0;
                ExcelBuffer.NewRow();
                CM_MakeExcelHeader();
                ExcelBuffer.NewRow();
                // ExcelBuffer.AddColumn('Sr.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                // ExcelBuffer.AddColumn('E-Invoice', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                //   ExcelBuffer.AddColumn('Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn('Invoice Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Document No. ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('External Document No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Type of Sale', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Sales E-way bill No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Sales E-way bill Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer Group ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer State', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Item Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Qty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Unit Price Excl VAT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //Dj 12/03/25
                ExcelBuffer.AddColumn('Shipping Bill Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Shipping Bill Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Port Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Port Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Location State ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('GST Place Of Supply', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Currency Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Ship-to Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Ship-to Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Ship-to GSTN ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Ship-to State', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('GST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('HSN Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('CGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('CGST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('SGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('SGST ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('IGST %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('IGST ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TCS Section ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TCS % ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('TCS Amount ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Gross Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Taxable Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Amount(Lcy)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
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
                CM_RecState.Reset();
                Clear(CM_GSTStateName);
                CM_RecState.SetRange(Code, "GST Ship-to State Code");
                if CM_RecState.FindFirst() then CM_GSTStateName := RecState.Description;
                CM_RecUser.Reset();
                CM_RecUser.SetRange("User Name", "User ID");
                if CM_RecUser.FindFirst() then
                    CM_FullName := RecUser."Full Name"
                else
                    CM_FullName := RecUser."User Name";
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
        //  CurrReport.SHOWOUTPUT(FALSE);
        //CurrReport.QUIT;
    end;

    var
        RecPortL: Record PortL;
        RecCurrencyExchangeRate: Record "Currency Exchange Rate"; //Rk
        ExchangeRate: Decimal; //Rk
        "Amount(Lcy)": Decimal; //Rk
        RecPortName: Text[100];
        glname: Record "G/L Account"; //Added
        gldescrption: Record "G/L Account"; //added
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
        Glna: Text; //added
        locName: Text;
        RecState: Record State;
        StateName: Text;
        GSTPlaceOfSupply: Text;
        GSTStateName: Text;
        RecUser: Record User;
        FullName: Text;
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
        CM_RecCurrencyExchangeRate: Record "Currency Exchange Rate"; //Rk
        CM_ExchangeRate: Decimal; //Rk
        "CM_Amount(Lcy)": Decimal; //Rk
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
        ExcelBuffer.AddColumn('Sales Register', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(CompName, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(PeriodText, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(PeriodText1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Details Of Sales Invoice', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
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
        // ExcelBuffer.CreateNewExcelBookY('', 'Sales Register', 'Sales Register', CompanyName, UserId);
        ExcelBuffer.CreateNewBook('Sales Register');
        ExcelBuffer.WriteSheet('Sales Register', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.OpenExcel();
    end;
}
