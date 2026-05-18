report 70118 "Aged Accounts PayableR"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src\Layout\AgedAccountsPayable1.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Aged Accounts Payable_RAMA';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(TodayFormatted; TodayFormatted)
            {
            }
            column(CompanyName; CompanyDisplayName)
            {
            }
            column(NewPagePerVendor; NewPagePerVendor)
            {
            }
            column(AgesAsOfEndingDate; StrSubstNo(Text006, Format(EndingDate, 0, 4)))
            {
            }
            column(SelectAgeByDuePostngDocDt; StrSubstNo(Text007, SelectStr(AgingBy + 1, Text009)))
            {
            }
            column(PrintAmountInLCY; PrintAmountInLCY)
            {
            }
            column(CaptionVendorFilter; TableCaption + ': ' + VendorFilter)
            {
            }
            column(VendorFilter; VendorFilter)
            {
            }
            column(AgingBy; AgingBy)
            {
            }
            column(SelctAgeByDuePostngDocDt1; StrSubstNo(Text004, SelectStr(AgingBy + 1, Text009)))
            {
            }
            column(HeaderText8; HeaderText[8])
            {
            }
            column(HeaderText7; HeaderText[7])
            {
            }

            column(HeaderText6; HeaderText[6])
            {
            }
            column(HeaderText5; HeaderText[5])
            {
            }
            column(HeaderText4; HeaderText[4])
            {
            }
            column(HeaderText3; HeaderText[3])
            {
            }
            column(HeaderText2; HeaderText[2])
            {
            }
            column(HeaderText1; HeaderText[1])
            {
            }
            column(HeaderText11; HeaderText1[1])
            {
            }
            column(HeaderText12; HeaderText1[2])
            {
            }
            column(HeaderText13; HeaderText1[3])
            {
            }


            column(PrintDetails; PrintDetails)
            {
            }
            column(GrandTotalVLE8RemAmtLCY; GrandTotalVLERemaingAmtLCY[8])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE7RemAmtLCY; GrandTotalVLERemaingAmtLCY[7])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE6RemAmtLCY; GrandTotalVLERemaingAmtLCY[6])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE5RemAmtLCY; GrandTotalVLERemaingAmtLCY[5])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE4RemAmtLCY; GrandTotalVLERemaingAmtLCY[4])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE3RemAmtLCY; GrandTotalVLERemaingAmtLCY[3])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE2RemAmtLCY; GrandTotalVLERemaingAmtLCY[2])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE1RemAmtLCY; GrandTotalVLERemaingAmtLCY[1])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE1AmtLCY; GrandTotalVLEAmtLCY)
            {
                AutoFormatType = 1;
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(No_Vendor; "No.")
            {
            }
            column(AgedAcctPayableCaption; AgedAcctPayableCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(AllAmtsinLCYCaption; AllAmtsinLCYCaptionLbl)
            {
            }
            column(AgedOverdueAmsCaption; AgedOverdueAmsCaptionLbl)
            {
            }
            column(GrandTotalVLE5RemAmtLCYCaption; GrandTotalVLE5RemAmtLCYCaptionLbl)
            {
            }
            column(AmountLCYCaption; AmountLCYCaptionLbl)
            {
            }
            column(DueDateCaption; DueDateCaptionLbl)
            {
            }
            column(DocumentNoCaption; DocNoCaption)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(DocumentTypeCaption; DocumentTypeCaptionLbl)
            {
            }
            column(VendorNoCaption; FieldCaption("No."))
            {
            }
            column(VendorNameCaption; FieldCaption(Name))
            {
            }
            column(CurrencyCaption; CurrencyCaptionLbl)
            {
            }
            column(TotalLCYCaption; TotalLCYCaptionLbl)
            {
            }
            column(VendorPhoneNoCaption; FieldCaption("Phone No."))
            {
            }
            column(VendorContactCaption; FieldCaption(Contact))
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord()
                var
                    VendorLedgEntry: Record "Vendor Ledger Entry";
                begin
                    VendorLedgEntry.SetCurrentKey("Closed by Entry No.");
                    VendorLedgEntry.SetRange("Closed by Entry No.", "Entry No.");
                    VendorLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                    CopyDimFiltersFromVendor(VendorLedgEntry);
                    if VendorLedgEntry.FindSet(false, false) then
                        repeat
                            InsertTemp(VendorLedgEntry);
                        until VendorLedgEntry.Next() = 0;

                    if "Closed by Entry No." <> 0 then begin
                        VendorLedgEntry.SetRange("Closed by Entry No.", "Closed by Entry No.");
                        if VendorLedgEntry.FindSet(false, false) then
                            repeat
                                InsertTemp(VendorLedgEntry);
                            until VendorLedgEntry.Next() = 0;
                    end;

                    VendorLedgEntry.Reset();
                    VendorLedgEntry.SetRange("Entry No.", "Closed by Entry No.");
                    VendorLedgEntry.SetRange("Posting Date", 0D, EndingDate);
                    CopyDimFiltersFromVendor(VendorLedgEntry);
                    if VendorLedgEntry.FindSet(false, false) then
                        repeat
                            InsertTemp(VendorLedgEntry);
                        until VendorLedgEntry.Next() = 0;
                    CurrReport.Skip();
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", EndingDate + 1, DMY2Date(31, 12, 9999));
                    CopyDimFiltersFromVendor("Vendor Ledger Entry");
                    Vendor.CopyFilter("Currency Filter", "Currency Code");
                end;
            }
            dataitem(OpenVendorLedgEntry; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord()
                begin
                    if AgingBy = AgingBy::"Posting Date" then begin
                        CalcFields("Remaining Amt. (LCY)");
                        if "Remaining Amt. (LCY)" = 0 then
                            CurrReport.Skip();
                    end;
                    InsertTemp(OpenVendorLedgEntry);
                    CurrReport.Skip();
                end;

                trigger OnPreDataItem()
                begin
                    if AgingBy = AgingBy::"Posting Date" then begin
                        SetRange("Posting Date", 0D, EndingDate);
                        SetRange("Date Filter", 0D, EndingDate);
                    end;
                    CopyDimFiltersFromVendor(OpenVendorLedgEntry);
                    Vendor.CopyFilter("Currency Filter", "Currency Code");
                end;
            }
            dataitem(CurrencyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                PrintOnlyIfDetail = true;
                dataitem(TempVendortLedgEntryLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    column(VendorName; Vendor.Name)
                    {
                    }
                    column(VendorNo; Vendor."No.")
                    {
                    }
                    column(VendorPhoneNo; Vendor."Phone No.")
                    {
                    }
                    column(VendorContactName; Vendor.Contact)
                    {
                    }
                    column(VLEEndingDateRemAmtLCY; VendorLedgEntryEndingDate."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVLE1RemAmtLCY; AgedVendorLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmtLCY; AgedVendorLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmtLCY; AgedVendorLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmtLCY; AgedVendorLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt5RemAmtLCY; AgedVendorLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt6RemAmtLCY; AgedVendorLedgEntry[6]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt7RemAmtLCY; AgedVendorLedgEntry[7]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt8RemAmtLCY; AgedVendorLedgEntry[8]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndDtAmtLCY; VendorLedgEntryEndingDate."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndDtDueDate; Format(VendorLedgEntryEndingDate."Due Date"))
                    {
                    }
                    column(VendLedgEntryEndDtDocNo; DocumentNo)
                    {
                    }
                    column(VendLedgEntyEndgDtDocType; Format(VendorLedgEntryEndingDate."Document Type"))
                    {
                    }
                    column(VendLedgEntryEndDtPostgDt; Format(VendorLedgEntryEndingDate."Posting Date"))
                    {
                    }
                    column(AgedVendLedgEnt8RemAmt; AgedVendorLedgEntry[8]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt7RemAmt; AgedVendorLedgEntry[6]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt6RemAmt; AgedVendorLedgEntry[7]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt5RemAmt; AgedVendorLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmt; AgedVendorLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmt; AgedVendorLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmt; AgedVendorLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt1RemAmt; AgedVendorLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VLEEndingDateRemAmt; VendorLedgEntryEndingDate."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndingDtAmt; VendorLedgEntryEndingDate.Amount)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalVendorName; StrSubstNo(Text005, Vendor.Name))
                    {
                    }
                    column(CurrCode_TempVenLedgEntryLoop; CurrencyCode)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    var
                        PeriodIndex: Integer;
                    begin
                        if Number = 1 then begin
                            if not TempVendorLedgEntry.FindSet(false, false) then
                                CurrReport.Break();
                        end else
                            if TempVendorLedgEntry.Next() = 0 then
                                CurrReport.Break();

                        VendorLedgEntryEndingDate := TempVendorLedgEntry;
                        DetailedVendorLedgerEntry.SetRange("Vendor Ledger Entry No.", VendorLedgEntryEndingDate."Entry No.");
                        if DetailedVendorLedgerEntry.FindSet(false, false) then
                            repeat
                                if (DetailedVendorLedgerEntry."Entry Type" =
                                    DetailedVendorLedgerEntry."Entry Type"::"Initial Entry") and
                                   (VendorLedgEntryEndingDate."Posting Date" > EndingDate) and
                                   (AgingBy <> AgingBy::"Posting Date")
                                then begin
                                    if (VendorLedgEntryEndingDate."Document Date" <= EndingDate) and
                                       (VendorLedgEntryEndingDate."Posting Date" <= EndingDate)
                                    then
                                        DetailedVendorLedgerEntry."Posting Date" :=
                                          VendorLedgEntryEndingDate."Document Date"
                                    else
                                        if (VendorLedgEntryEndingDate."Due Date" <= EndingDate) and
                                           (AgingBy = AgingBy::"Due Date")
                                        then
                                            DetailedVendorLedgerEntry."Posting Date" :=
                                              VendorLedgEntryEndingDate."Due Date"
                                end;

                                if (DetailedVendorLedgerEntry."Posting Date" <= EndingDate) or
                                   (TempVendorLedgEntry.Open and
                                    (AgingBy = AgingBy::"Due Date") and
                                    (VendorLedgEntryEndingDate."Due Date" > EndingDate) and
                                    (VendorLedgEntryEndingDate."Posting Date" <= EndingDate))
                                then begin
                                    if DetailedVendorLedgerEntry."Entry Type" in
                                       [DetailedVendorLedgerEntry."Entry Type"::"Initial Entry",
                                        DetailedVendorLedgerEntry."Entry Type"::"Unrealized Loss",
                                        DetailedVendorLedgerEntry."Entry Type"::"Unrealized Gain",
                                        DetailedVendorLedgerEntry."Entry Type"::"Realized Loss",
                                        DetailedVendorLedgerEntry."Entry Type"::"Realized Gain",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Adjustment)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]
                                    then begin
                                        VendorLedgEntryEndingDate.Amount := VendorLedgEntryEndingDate.Amount + DetailedVendorLedgerEntry.Amount;
                                        VendorLedgEntryEndingDate."Amount (LCY)" :=
                                          VendorLedgEntryEndingDate."Amount (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                    end;
                                    if DetailedVendorLedgerEntry."Posting Date" <= EndingDate then begin
                                        VendorLedgEntryEndingDate."Remaining Amount" :=
                                          VendorLedgEntryEndingDate."Remaining Amount" + DetailedVendorLedgerEntry.Amount;
                                        VendorLedgEntryEndingDate."Remaining Amt. (LCY)" :=
                                          VendorLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                    end;
                                end;
                            until DetailedVendorLedgerEntry.Next() = 0;

                        if UseExternalDocNo then
                            DocumentNo := VendorLedgEntryEndingDate."External Document No."
                        else
                            DocumentNo := VendorLedgEntryEndingDate."Document No.";

                        if VendorLedgEntryEndingDate."Remaining Amount" = 0 then
                            CurrReport.Skip();

                        case AgingBy of
                            AgingBy::"Due Date":
                                PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Due Date");
                            AgingBy::"Posting Date":
                                PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Posting Date");
                            AgingBy::"Document Date":
                                begin
                                    if VendorLedgEntryEndingDate."Document Date" > EndingDate then begin
                                        VendorLedgEntryEndingDate."Remaining Amount" := 0;
                                        VendorLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
                                        VendorLedgEntryEndingDate."Document Date" := VendorLedgEntryEndingDate."Posting Date";
                                    end;
                                    PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Document Date");
                                end;
                        end;
                        Clear(AgedVendorLedgEntry);
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amount" := VendorLedgEntryEndingDate."Remaining Amount";
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amount" += VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalVLERemaingAmtLCY[PeriodIndex] += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalVendorLedgEntry[1].Amount += VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[1]."Amount (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalVLEAmtLCY += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                    end;

                    trigger OnPostDataItem()
                    begin
                        if not PrintAmountInLCY then
                            UpdateCurrencyTotals;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not PrintAmountInLCY then
                            TempVendorLedgEntry.SetRange("Currency Code", TempCurrency.Code);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(TotalVendorLedgEntry);

                    if Number = 1 then begin
                        if not TempCurrency.FindSet(false, false) then
                            CurrReport.Break();
                    end else
                        if TempCurrency.Next() = 0 then
                            CurrReport.Break();

                    if TempCurrency.Code <> '' then
                        CurrencyCode := TempCurrency.Code
                    else
                        CurrencyCode := GLSetup."LCY Code";

                    NumberOfCurrencies := NumberOfCurrencies + 1;
                end;

                trigger OnPreDataItem()
                begin
                    NumberOfCurrencies := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if NewPagePerVendor then
                    PageGroupNo := PageGroupNo + 1;

                TempCurrency.Reset();
                TempCurrency.DeleteAll();
                TempVendorLedgEntry.Reset();
                TempVendorLedgEntry.DeleteAll();
                Clear(GrandTotalVLERemaingAmtLCY);
                GrandTotalVLEAmtLCY := 0;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
            end;
        }
        dataitem(CurrencyTotals; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(Number_CurrencyTotals; Number)
            {
            }
            column(NewPagePerVend_CurrTotal; NewPagePerVendor)
            {
            }
            column(TempCurrency2Code; TempCurrency2.Code)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt9RemAmtLCY9; AgedVendorLedgEntry[9]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt8RemAmtLCY8; AgedVendorLedgEntry[8]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt7RemAmtLCY7; AgedVendorLedgEntry[7]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt6RemAmtLCY5; AgedVendorLedgEntry[6]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt1RemAmtLCY1; AgedVendorLedgEntry[1]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt2RemAmtLCY2; AgedVendorLedgEntry[2]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt3RemAmtLCY3; AgedVendorLedgEntry[3]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt4RemAmtLCY4; AgedVendorLedgEntry[4]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt5RemAmtLCY5; AgedVendorLedgEntry[5]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(CurrencySpecificationCaption; CurrencySpecificationCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                    if not TempCurrency2.FindSet(false, false) then
                        CurrReport.Break();
                end else
                    if TempCurrency2.Next() = 0 then
                        CurrReport.Break();

                Clear(AgedVendorLedgEntry);
                TempCurrencyAmount.SetRange("Currency Code", TempCurrency2.Code);
                if TempCurrencyAmount.FindSet(false, false) then
                    repeat
                        if TempCurrencyAmount.Date <> DMY2Date(31, 12, 9999) then
                            AgedVendorLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                              TempCurrencyAmount.Amount
                        else
                            AgedVendorLedgEntry[9]."Remaining Amount" := TempCurrencyAmount.Amount;
                    until TempCurrencyAmount.Next() = 0;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AgedAsOf; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged As Of';
                        ToolTip = 'Specifies the date that you want the aging calculated for.';
                    }
                    field(AgingBy; AgingBy)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aging by';
                        OptionCaption = 'Due Date,Posting Date,Document Date';
                        ToolTip = 'Specifies if the aging will be calculated from the due date, the posting date, or the document date.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                    field(PL2; PL2)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length2';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                    field(PL3; PL3)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length3';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                    field(PL4; PL4)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length4';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                    field(PL5; PL5)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length5';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                    field(PL6; PL6)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length6';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                    field(PrintAmountInLCY; PrintAmountInLCY)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Amounts in LCY';
                        ToolTip = 'Specifies if you want the report to specify the aging per vendor ledger entry.';
                    }
                    field(PrintDetails; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Details';
                        ToolTip = 'Specifies if you want the report to show the detailed entries that add up the total balance for each vendor.';
                    }
                    field(HeadingType; HeadingType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Heading Type';
                        OptionCaption = 'Date Interval,Number of Days';
                        ToolTip = 'Specifies if the column heading for the three periods will indicate a date interval or the number of days overdue.';
                    }
                    field(NewPagePerVendor; NewPagePerVendor)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Vendor';
                        ToolTip = 'Specifies if each vendor''s information is printed on a new page if you have chosen two or more vendors to be included in the report.';
                    }
                    field(UseExternalDocNo; UseExternalDocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Use External Document No.';
                        ToolTip = 'Specifies if you want to print the vendor''s document numbers, such as the invoice number, on all transactions. Clear this check box to print only internal document numbers.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if EndingDate = 0D then
                EndingDate := WorkDate;
            if Format(PeriodLength) = '' then
                Evaluate(PeriodLength, '<30D>');

            //added
            // if EndingDate = 0D then
            // EndingDate := WorkDate;
            // if Format(PL2) = '' then
            // Evaluate(PL2, '<60D>');
            //added
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        VendorFilter := FormatDocument.GetRecordFiltersWithCaptions(Vendor);

        GLSetup.Get();

        CalcDates;
        CalcDatesPL2();//added
        CalcDatesPL3();
        CalcDatesPL4();
        CalcDatesPL5();
        CalcDatesPL6();
        CreateHeadings;
        CreateHeadingsPL2();//added
        CreateHeadingsPL3();
        CreateHeadingsPL4();
        CreateHeadingsPL5();
        CreateHeadingsPL6();
        TodayFormatted := TypeHelper.GetFormattedCurrentDateTimeInUserTimeZone('f');
        CompanyDisplayName := COMPANYPROPERTY.DisplayName;

        if UseExternalDocNo then
            DocNoCaption := ExternalDocumentNoCaptionLbl
        else
            DocNoCaption := DocumentNoCaptionLbl;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        VendorLedgEntryEndingDate: Record "Vendor Ledger Entry";
        TotalVendorLedgEntry: array[8] of Record "Vendor Ledger Entry";
        AgedVendorLedgEntry: array[9] of Record "Vendor Ledger Entry";
        TempCurrency: Record Currency temporary;
        TempCurrency2: Record Currency temporary;
        TempCurrencyAmount: Record "Currency Amount" temporary;
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        TypeHelper: Codeunit "Type Helper";
        GrandTotalVLERemaingAmtLCY: array[8] of Decimal;
        GrandTotalVLEAmtLCY: Decimal;
        VendorFilter: Text;
        PrintAmountInLCY: Boolean;
        EndingDate: Date;
        AgingBy: Option "Due Date","Posting Date","Document Date";
        PeriodLength: DateFormula;
        PL2: DateFormula; //added 

        PL3: DateFormula;  //added
        PL4: DateFormula; //added 

        PL5: DateFormula;  //added
        PL6: DateFormula;
        PrintDetails: Boolean;
        UseExternalDocNo: Boolean;
        HeadingType: Option "Date Interval","Number of Days";
        NewPagePerVendor: Boolean;
        PeriodStartDate: array[8] of Date;
        PeriodEndDate: array[8] of Date;
        PeriodStartDate1: array[8] of Date; //added
        PeriodEndDate1: array[8] of Date;  //added

        HeaderText: array[8] of Text[30];

        HeaderText1: array[8] of Text[30];
        Text000: Label 'Not Due';
        AfterTok: Label 'After';
        CurrencyCode: Code[10];
        Text002: Label 'days';
        Text004: Label 'Aged by %1';
        Text005: Label 'Total for %1';
        Text006: Label 'Aged as of %1';
        Text007: Label 'Aged by %1';
        NumberOfCurrencies: Integer;
        Text009: Label 'Due Date,Posting Date,Document Date';
        Text010: Label 'The Date Formula %1 cannot be used. Try to restate it, for example, by using 1M+CM instead of CM+1M.';
        PageGroupNo: Integer;
        EnterDateFormulaErr: Label 'Enter a date formula in the Period Length field.';
        Text027: Label '-%1', Comment = 'Negating the period length: %1 is the period length';
        AgedAcctPayableCaptionLbl: Label 'Aged Accounts Payable';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AllAmtsinLCYCaptionLbl: Label 'All Amounts in LCY';
        AgedOverdueAmsCaptionLbl: Label 'Aged Overdue Amounts';
        GrandTotalVLE5RemAmtLCYCaptionLbl: Label 'Balance';
        AmountLCYCaptionLbl: Label 'Original Amount';
        DueDateCaptionLbl: Label 'Due Date';
        DocumentNoCaptionLbl: Label 'Document No.';
        ExternalDocumentNoCaptionLbl: Label 'External Document No.';
        PostingDateCaptionLbl: Label 'Posting Date';
        DocumentTypeCaptionLbl: Label 'Document Type';
        CurrencyCaptionLbl: Label 'Currency Code';
        TotalLCYCaptionLbl: Label 'Total (LCY)';
        CurrencySpecificationCaptionLbl: Label 'Currency Specification';
        TodayFormatted: Text;
        CompanyDisplayName: Text;
        DocNoCaption: Text;
        DocumentNo: Code[35];

    protected var
        TempVendorLedgEntry: Record "Vendor Ledger Entry" temporary;

    // Dates Calculation
    local procedure CalcDates()
    var
        PeriodLength2: DateFormula;
        i: Integer;
    begin
        if not Evaluate(PeriodLength2, StrSubstNo(Text027, PeriodLength)) then Error(EnterDateFormulaErr);
        if AgingBy = AgingBy::"Due Date" then begin
            PeriodEndDate[1] := DMY2Date(31, 12, 9999);
            PeriodStartDate[1] := EndingDate + 1;
        end
        else begin
            PeriodEndDate[1] := EndingDate;
            PeriodStartDate[1] := CalcDate(PeriodLength2, EndingDate + 1);
        end;
        if AgingBy = AgingBy::"Due Date" then begin
            for i := 2 to ArrayLen(PeriodEndDate) do begin
                PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1)
            end;
        end else begin
            for i := 2 to ArrayLen(PeriodEndDate) do begin
                PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
            end;
        end;
        PeriodStartDate[i] := 0D;
        for i := 1 to ArrayLen(PeriodEndDate) do if PeriodEndDate[i] < PeriodStartDate[i] then
                Error(Text010, PeriodLength);
    end;

    local procedure CreateHeadings()
    var
        i: Integer;
    begin
        if AgingBy = AgingBy::"Due Date" then begin
            HeaderText[1] := Text000;
            i := 2;
        end
        else begin
            i := 1;
        end;
        while i < ArrayLen(PeriodEndDate) do begin
            if HeadingType = HeadingType::"Date Interval" then
                HeaderText[i] := StrSubstNo('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
            else
                HeaderText[i] := StrSubstNo('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
            i := i + 1;
        end;
        if HeadingType = HeadingType::"Date Interval" then
            HeaderText[i] := StrSubstNo('%1 %2', AfterTok, PeriodStartDate[i - 1])
        else
            HeaderText[i] := StrSubstNo('%1 %2 %3', AfterTok, EndingDate - PeriodStartDate[i - 1] + 1, Text002);
    end;

    local procedure CalcDatesPL2()
    var
        i: Integer;
        PeriodLength2: DateFormula;
    begin
        if Format(PL2) <> '' then begin
            if not Evaluate(PeriodLength2, StrSubstNo(Text027, PL2)) then //begin
                Error(EnterDateFormulaErr);
            if AgingBy = AgingBy::"Due Date" then begin
                PeriodEndDate[1] := DMY2Date(31, 12, 9999);
                PeriodStartDate[1] := EndingDate + 1;
            end else begin
                PeriodEndDate[2] := PeriodStartDate[1] - 1;
                PeriodStartDate[2] := CalcDate(PeriodLength2, EndingDate + 1);
            end;
            if AgingBy = AgingBy::"Due Date" then begin
                for i := 3 to ArrayLen(PeriodEndDate) do begin
                    PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                    PeriodStartDate[i] := CalcDate(Format(PeriodLength) + Format(PeriodLength2), PeriodEndDate[i] + 1);
                    for i := 4 to ArrayLen(PeriodEndDate) do begin
                        PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                        PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
                    end;
                end;
            end else begin
                for i := 2 to ArrayLen(PeriodEndDate) do begin
                    PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                    PeriodStartDate[i] := CalcDate(Format(PeriodLength) + Format(PeriodLength2), PeriodEndDate[i] + 1);
                    for i := 3 to ArrayLen(PeriodEndDate) do begin
                        PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                        PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
                    end;
                end;
            end;
            i := ArrayLen(PeriodEndDate);
            PeriodStartDate[i] := 0D;
            for i := 1 to ArrayLen(PeriodEndDate) do
                if PeriodEndDate[i] < PeriodStartDate[i] then
                    Error(Text010, PeriodLength);
        end;

    end;

    local procedure CreateHeadingsPL2()
    var
        i: Integer;
    begin

        if Format(PL2) <> '' then begin
            if AgingBy = AgingBy::"Due Date" then begin
                HeaderText[1] := Text000;
                i := 2;
            end else
                i := 1;
            while i < ArrayLen(PeriodEndDate) do begin
                if HeadingType = HeadingType::"Date Interval" then
                    HeaderText[i] := StrSubstNo('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
                else
                    HeaderText[i] :=
                      StrSubstNo('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
                i := i + 1;
            end;
            if HeadingType = HeadingType::"Date Interval" then
                HeaderText[i] := StrSubstNo('%1\%2', AfterTok, PeriodStartDate[i - 1])
            else
                HeaderText[i] := StrSubstNo('%1 %2 %3', AfterTok, EndingDate - PeriodStartDate[i - 1] + 1, Text002);

        end;
    end;

    local procedure CalcDatesPL3()
    var
        i: Integer;
        PeriodLength2: DateFormula;
    begin
        if Format(PL3) <> '' then begin
            if not Evaluate(PeriodLength2, StrSubstNo(Text027, PL3)) then //begin
                Error(EnterDateFormulaErr);
            if AgingBy = AgingBy::"Due Date" then begin
                PeriodEndDate[1] := DMY2Date(31, 12, 9999);
                PeriodStartDate[1] := EndingDate + 1;
            end else begin
                PeriodEndDate[3] := PeriodStartDate[2] - 1;
                PeriodStartDate[3] := CalcDate(PeriodLength2, EndingDate + 1);
            end;
            if AgingBy = AgingBy::"Due Date" then begin
                for i := 4 to ArrayLen(PeriodEndDate) do begin
                    PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                    PeriodStartDate[i] := CalcDate(Format(PL2) + Format(PeriodLength2), PeriodEndDate[i] + 1);
                    for i := 5 to ArrayLen(PeriodEndDate) do begin
                        PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                        PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
                    end;
                end;
            end else begin
                for i := 3 to ArrayLen(PeriodEndDate) do begin
                    PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                    PeriodStartDate[i] := CalcDate(Format(PL2) + Format(PeriodLength2), PeriodEndDate[i] + 1);
                    for i := 4 to ArrayLen(PeriodEndDate) do begin
                        PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                        PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
                    end;
                end;
            end;
            i := ArrayLen(PeriodEndDate);
            PeriodStartDate[i] := 0D;
            for i := 1 to ArrayLen(PeriodEndDate) do
                if PeriodEndDate[i] < PeriodStartDate[i] then
                    Error(Text010, PeriodLength);
        end;
    end;

    local procedure CreateHeadingsPL3()
    var
        i: Integer;
    begin
        if Format(PL3) <> '' then begin
            if AgingBy = AgingBy::"Due Date" then begin
                HeaderText[1] := Text000;
                i := 2;
            end else
                i := 1;
            while i < ArrayLen(PeriodEndDate) do begin
                if HeadingType = HeadingType::"Date Interval" then
                    HeaderText[i] := StrSubstNo('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
                else
                    HeaderText[i] :=
                      StrSubstNo('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
                i := i + 1;
            end;
            if HeadingType = HeadingType::"Date Interval" then
                HeaderText[i] := StrSubstNo('%1\%2', AfterTok, PeriodStartDate[i - 1])
            else
                HeaderText[i] := StrSubstNo('%1 %2 %3', AfterTok, EndingDate - PeriodStartDate[i - 1] + 1, Text002);

        end;
    end;

    local procedure CalcDatesPL4()
    var
        i: Integer;
        PeriodLength2: DateFormula;
    begin
        if Format(PL4) <> '' then begin
            if not Evaluate(PeriodLength2, StrSubstNo(Text027, PL4)) then //begin
                Error(EnterDateFormulaErr);
            if AgingBy = AgingBy::"Due Date" then begin
                PeriodEndDate[1] := DMY2Date(31, 12, 9999);
                PeriodStartDate[1] := EndingDate + 1;
            end else begin
                PeriodEndDate[4] := PeriodStartDate[3] - 1;
                PeriodStartDate[4] := CalcDate(PeriodLength2, EndingDate + 1);
            end;
            if AgingBy = AgingBy::"Due Date" then begin
                for i := 5 to ArrayLen(PeriodEndDate) do begin
                    PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                    PeriodStartDate[i] := CalcDate(Format(PL3) + Format(PeriodLength2), PeriodEndDate[i] + 1);
                    for i := 6 to ArrayLen(PeriodEndDate) do begin
                        PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                        PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
                    end;
                end;
            end else begin
                for i := 4 to ArrayLen(PeriodEndDate) do begin
                    PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                    PeriodStartDate[i] := CalcDate(Format(PL3) + Format(PeriodLength2), PeriodEndDate[i] + 1);
                    for i := 5 to ArrayLen(PeriodEndDate) do begin
                        PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                        PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
                    end;
                end;
            end;
        end;
        i := ArrayLen(PeriodEndDate);
        PeriodStartDate[i] := 0D;
        for i := 1 to ArrayLen(PeriodEndDate) do
            if PeriodEndDate[i] < PeriodStartDate[i] then
                Error(Text010, PeriodLength);
    end;


    local procedure CreateHeadingsPL4()
    var
        i: Integer;
    begin
        if Format(PL3) <> '' then begin
            if AgingBy = AgingBy::"Due Date" then begin
                HeaderText[1] := Text000;
                i := 2;
            end else
                i := 1;
            while i < ArrayLen(PeriodEndDate) do begin
                if HeadingType = HeadingType::"Date Interval" then
                    HeaderText[i] := StrSubstNo('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
                else
                    HeaderText[i] :=
                      StrSubstNo('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
                i := i + 1;
            end;
            if HeadingType = HeadingType::"Date Interval" then
                HeaderText[i] := StrSubstNo('%1\%2', AfterTok, PeriodStartDate[i - 1])
            else
                HeaderText[i] := StrSubstNo('%1 %2 %3', AfterTok, EndingDate - PeriodStartDate[i - 1] + 1, Text002);

        end;
    end;

    local procedure CalcDatesPL5()
    var
        i: Integer;
        PeriodLength2: DateFormula;
    begin
        if Format(PL5) <> '' then begin
            if not Evaluate(PeriodLength2, StrSubstNo(Text027, PL5)) then //begin
                Error(EnterDateFormulaErr);
            if AgingBy = AgingBy::"Due Date" then begin
                PeriodEndDate[1] := DMY2Date(31, 12, 9999);
                PeriodStartDate[1] := EndingDate + 1;
            end else begin
                PeriodEndDate[5] := PeriodStartDate[4] - 1;
                PeriodStartDate[5] := CalcDate(PeriodLength2, EndingDate + 1);
            end;
            if AgingBy = AgingBy::"Due Date" then begin
                for i := 6 to ArrayLen(PeriodEndDate) do begin
                    PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                    PeriodStartDate[i] := CalcDate(Format(PL4) + Format(PeriodLength2), PeriodEndDate[i] + 1);
                    for i := 7 to ArrayLen(PeriodEndDate) do begin
                        PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                        PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
                    end;
                end;
            end else begin
                for i := 5 to ArrayLen(PeriodEndDate) do begin
                    PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                    PeriodStartDate[i] := CalcDate(Format(PL4) + Format(PeriodLength2), PeriodEndDate[i] + 1);
                    for i := 6 to ArrayLen(PeriodEndDate) do begin
                        PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                        PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
                    end;
                end;
            end;
        end;
        i := ArrayLen(PeriodEndDate);
        PeriodStartDate[i] := 0D;
        for i := 1 to ArrayLen(PeriodEndDate) do
            if PeriodEndDate[i] < PeriodStartDate[i] then
                Error(Text010, PeriodLength);
    end;

    local procedure CreateHeadingsPL5()
    var
        i: Integer;
    begin
        if Format(PL5) <> '' then begin
            if AgingBy = AgingBy::"Due Date" then begin
                HeaderText[1] := Text000;
                i := 2;
            end else
                i := 1;
            while i < ArrayLen(PeriodEndDate) do begin
                if HeadingType = HeadingType::"Date Interval" then
                    HeaderText[i] := StrSubstNo('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
                else
                    HeaderText[i] :=
                      StrSubstNo('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
                i := i + 1;
            end;
            if HeadingType = HeadingType::"Date Interval" then
                HeaderText[i] := StrSubstNo('%1\%2', AfterTok, PeriodStartDate[i - 1])
            else
                HeaderText[i] := StrSubstNo('%1 %2 %3', AfterTok, EndingDate - PeriodStartDate[i - 1] + 1, Text002);

        end;
    end;

    local procedure CalcDatesPL6()
    var
        i: Integer;
        PeriodLength2: DateFormula;
    begin
        if Format(PL6) <> '' then begin
            if not Evaluate(PeriodLength2, StrSubstNo(Text027, PL6)) then //begin
                Error(EnterDateFormulaErr);
            if AgingBy = AgingBy::"Due Date" then begin
                PeriodEndDate[1] := DMY2Date(31, 12, 9999);
                PeriodStartDate[1] := EndingDate + 1;
            end else begin
                PeriodEndDate[6] := PeriodStartDate[6] - 1;
                PeriodStartDate[6] := CalcDate(PeriodLength2, EndingDate + 1);
            end;
            if AgingBy = AgingBy::"Due Date" then begin
                for i := 7 to ArrayLen(PeriodEndDate) do begin
                    PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                    PeriodStartDate[i] := CalcDate(Format(PL5) + Format(PeriodLength2), PeriodEndDate[i] + 1);
                    for i := 8 to ArrayLen(PeriodEndDate) do begin
                        PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                        PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
                    end;
                end;
            end else begin
                for i := 6 to ArrayLen(PeriodEndDate) do begin
                    PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                    PeriodStartDate[i] := CalcDate(Format(PL5) + Format(PeriodLength2), PeriodEndDate[i] + 1);
                    for i := 7 to ArrayLen(PeriodEndDate) do begin
                        PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
                        PeriodStartDate[i] := CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
                    end;
                end;
            end;
        end;
        i := ArrayLen(PeriodEndDate);
        PeriodStartDate[i] := 0D;
        for i := 1 to ArrayLen(PeriodEndDate) do
            if PeriodEndDate[i] < PeriodStartDate[i] then
                Error(Text010, PeriodLength);
    end;


    local procedure CreateHeadingsPL6()
    var
        i: Integer;
    begin
        if Format(PL6) <> '' then begin
            if AgingBy = AgingBy::"Due Date" then begin
                HeaderText[1] := Text000;
                i := 2;
            end else
                i := 1;
            while i < ArrayLen(PeriodEndDate) do begin
                if HeadingType = HeadingType::"Date Interval" then
                    HeaderText[i] := StrSubstNo('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
                else
                    HeaderText[i] :=
                      StrSubstNo('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
                i := i + 1;
            end;
            if HeadingType = HeadingType::"Date Interval" then
                HeaderText[i] := StrSubstNo('%1\%2', AfterTok, PeriodStartDate[i - 1])
            else
                HeaderText[i] := StrSubstNo('%1 %2 %3', AfterTok, EndingDate - PeriodStartDate[i - 1] + 1, Text002);

        end;

    end;

    // Dates Calculation
    local procedure InsertTemp(var VendorLedgEntry: Record "Vendor Ledger Entry")
    var
        Currency: Record Currency;
    begin
        if TempVendorLedgEntry.Get(VendorLedgEntry."Entry No.") then
            exit;
        TempVendorLedgEntry := VendorLedgEntry;
        TempVendorLedgEntry.Insert;
        if PrintAmountInLCY then begin
            Clear(TempCurrency);
            TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            if TempCurrency.Insert() then;
            exit;
        end;
        if TempCurrency.Get(TempVendorLedgEntry."Currency Code") then
            exit;
        if TempVendorLedgEntry."Currency Code" <> '' then
            Currency.Get(TempVendorLedgEntry."Currency Code")
        else begin
            Clear(Currency);
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        end;
        TempCurrency := Currency;
        TempCurrency.Insert();
    end;

    local procedure GetPeriodIndex(Date: Date): Integer
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(PeriodEndDate) do
            if Date in [PeriodStartDate[i] .. PeriodEndDate[i]] then
                exit(i);
    end;

    local procedure UpdateCurrencyTotals()
    var
        i: Integer;
    begin
        TempCurrency2.Code := CurrencyCode;
        if TempCurrency2.Insert() then;
        for i := 1 to ArrayLen(TotalVendorLedgEntry) do begin
            TempCurrencyAmount."Currency Code" := CurrencyCode;
            TempCurrencyAmount.Date := PeriodStartDate[i];
            if TempCurrencyAmount.Find then begin
                TempCurrencyAmount.Amount := TempCurrencyAmount.Amount + TotalVendorLedgEntry[i]."Remaining Amount";
                TempCurrencyAmount.Modify;
            end else begin
                TempCurrencyAmount."Currency Code" := CurrencyCode;
                TempCurrencyAmount.Date := PeriodStartDate[i];
                TempCurrencyAmount.Amount := TotalVendorLedgEntry[i]."Remaining Amount";
                TempCurrencyAmount.Insert;
            end;
        end;
        TempCurrencyAmount."Currency Code" := CurrencyCode;
        TempCurrencyAmount.Date := DMY2Date(31, 12, 9999);
        if TempCurrencyAmount.Find then begin
            TempCurrencyAmount.Amount := TempCurrencyAmount.Amount + TotalVendorLedgEntry[1].Amount;
            TempCurrencyAmount.Modify;
        end else begin
            TempCurrencyAmount."Currency Code" := CurrencyCode;
            TempCurrencyAmount.Date := DMY2Date(31, 12, 9999);
            TempCurrencyAmount.Amount := TotalVendorLedgEntry[1].Amount;
            TempCurrencyAmount.Insert;
        end;
    end;

    procedure InitializeRequest(NewEndingDate: Date; NewAgingBy: Option; NewPeriodLength: DateFormula; NewPrintAmountInLCY: Boolean; NewPrintDetails: Boolean; NewHeadingType: Option; NewNewPagePerVendor: Boolean)
    begin
        EndingDate := NewEndingDate;
        AgingBy := NewAgingBy;
        PeriodLength := NewPeriodLength;
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintDetails := NewPrintDetails;
        HeadingType := NewHeadingType;
        NewPagePerVendor := NewNewPagePerVendor;
    end;

    local procedure CopyDimFiltersFromVendor(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        if Vendor.GetFilter("Global Dimension 1 Filter") <> '' then
            VendorLedgerEntry.SetFilter("Global Dimension 1 Code", Vendor.GetFilter("Global Dimension 1 Filter"));
        if Vendor.GetFilter("Global Dimension 2 Filter") <> '' then
            VendorLedgerEntry.SetFilter("Global Dimension 2 Code", Vendor.GetFilter("Global Dimension 2 Filter"));
    end;
}

