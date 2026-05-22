//comment tejswi22052026

// page 70163 "Mandate Subform"
// {
//     Caption = 'Mandate Subform';
//     PageType = ListPart;
//     SourceTable = "Mandate Line";
//     AutoSplitKey = true;
//     DelayedInsert = false;
//     Permissions = tabledata "Dimension Set Entry" = RIMD;
//     layout
//     {
//         area(content)
//         {
//             repeater(General)
//             {

//                 field(Type; Rec.Type)
//                 {
//                     ApplicationArea = all;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Type field.';

//                     trigger OnValidate()
//                     begin
//                         CurrPage.Update(false);
//                     end;
//                 }
//                 field("No."; rec."Item No.")
//                 {
//                     Caption = 'No';
//                     Editable = Rec.Invoiced = false;
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the Item Name New field.';

//                     trigger OnValidate()
//                     begin
//                         CurrPage.SaveRecord();
//                         CurrPage.Update(false);
//                     end;
//                 }
//                 field(Description; rec.Description)
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the Item Name field.';
//                     Editable = false;

//                     trigger OnValidate()
//                     begin
//                         Rec.TestField(Status, Rec.Status::Open);
//                     end;
//                 }
//                 field("Description 2"; rec."Description 2")
//                 {
//                     ApplicationArea = all;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Description 2 field.';
//                 }
//                 field(Quantity; rec.Quantity)
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the PR Qty field.';
//                     Editable = Rec.Invoiced = false;
//                 }

//                 field("Unit oF Measure Code"; rec."Unit oF Measure Code")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the Price Unit field.';
//                     Editable = Rec.Invoiced = false;

//                 }
//                 field("Invoice Type"; Rec."Invoice Type")
//                 {
//                     ShowMandatory = true;
//                     ApplicationArea = all;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Invoice Type field.';

//                     trigger OnValidate()
//                     var
//                         LrecML: Record "Mandate Line";
//                         LrecMH: Record "Mandate Header";
//                     begin
//                         if LrecMH.Get(Rec."Mandate Document No.") then
//                             if (LrecMH."Billing Type" = LrecMH."Billing Type"::Monthly) or (LrecMH."Billing Type" = LrecMH."Billing Type"::Quarterly) then begin
//                                 LrecML.Reset();
//                                 LrecML.SetRange("Mandate Document No.", LrecMH."No.");
//                                 LrecML.SetFilter(Status, '<>%1', LrecML.Status::Released);
//                                 if LrecML.FindSet() then
//                                     repeat
//                                         LrecML.Validate("Invoice Type", Rec."Invoice Type");
//                                         LrecML.Modify();
//                                     until LrecML.Next() = 0;
//                             end;
//                         CurrPage.Update(true);
//                     end;
//                 }
//                 field("Unit Cost"; Rec."Unit Cost")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the Unit cost field.';
//                     Editable = (Rec."Invoice Type" = Rec."Invoice Type"::Lumpsum) and EditableStatus and Rec.Invoiced = false;
//                     ;

//                     trigger OnValidate()
//                     begin
//                         if Rec."Unit Cost" <> 0 then begin
//                             Rec."%" := Rec.Quantity * Rec."Unit Cost";
//                             Rec.Amount := Rec.Quantity * Rec."Unit Cost";
//                             Rec.Modify();
//                         end;
//                     end;
//                 }
//                 field("%"; Rec."%")
//                 {
//                     Caption = 'Percentage(%)/amount';
//                     ApplicationArea = all;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Advanced(%)/amount field.';

//                     trigger OnValidate()
//                     begin
//                         Rec.TestField("Invoice Type");
//                         // Rec.TestField(Invoiced, false);
//                         if Rec."Amount Assigned" <> 0 then
//                             Error('Advanced% can not be changed after invoiced');
//                         if Rec.Amount = Rec."Amount Assigned" then
//                             Error('this line is already invoiced');
//                     end;

//                 }
//                 field(Amount; Rec.Amount)
//                 {
//                     Editable = false;
//                     Visible = true;
//                     ApplicationArea = all;
//                     ToolTip = 'Specifies the value of the Amount field.';

//                     trigger OnValidate()
//                     var
//                         RecMH: Record "Mandate Header";
//                         RecML: Record "Mandate Line";
//                         TotalAmount: Decimal;
//                     begin
//                         Rec.TestField("Invoice Type");

//                         if RecMH.Get(Rec."Mandate Document No.") then begin
//                             RecMH.TestField("Total EL Amt");
//                             RecML.Reset();
//                             RecML.SetRange("Mandate Document No.", RecMH."No.");
//                             if RecML.FindFirst() then
//                                 repeat
//                                     TotalAmount += RecML.Amount;
//                                 until RecML.Next() = 0;
//                             if RecMH."Total EL Amt" = TotalAmount then
//                                 Error('Amount Must be equal to or less then %1', RecMH."Total EL Amt" - TotalAmount);
//                         end;
//                     end;
//                 }
//                 field("Amount to Assign"; Rec."Amount to Assign")
//                 {
//                     ApplicationArea = All;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the PR Qty In field.';

//                     trigger OnValidate()
//                     begin
//                         Rec.TestField(Amount);
//                         Rec.TestField("Invoice Type");
//                         if Rec."Amount to Assign" > Rec.Amount then
//                             Error('Amount to assign must not be greater then amount');
//                         if Rec.Amount = Rec."Amount Assigned" then
//                             Error('this line is already invoiced');
//                         if (Rec."Amount to Assign" + Rec."Amount Assigned") > Rec.Amount then
//                             Error('Amount must be less then or equal to amount in line');
//                     end;
//                 }
//                 field("Amount Assigned"; Rec."Amount Assigned")
//                 {
//                     ApplicationArea = All;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Item ID Based On  field.';
//                 }
//                 field("Remaining Amount"; Rec."Remaining Amount")
//                 {
//                     ApplicationArea = all;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Remaining Amount field.';
//                 }
//                 field("Short Close Qty."; Rec."Short Close Qty.")
//                 {
//                     ToolTip = 'Specifies the value of the Short Close Qty. field';
//                     ApplicationArea = All;
//                     Editable = Rec."Short Closed" <> true and Rec.Invoiced = false;
//                     ;
//                 }
//                 field("Short Closed"; Rec."Short Closed")
//                 {
//                     ToolTip = 'Specifies the value of the Short Closed field';
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field("Reason Code"; rec."Reason Code")
//                 {
//                     ApplicationArea = All;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Reason Code field.';
//                 }
//                 field(Status; Rec.Status)
//                 {
//                     ApplicationArea = All;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Status field.';
//                     // StyleExpr = StyleTxt;
//                 }
//                 field(Invoiced; Rec.Invoiced)
//                 {
//                     ToolTip = 'Specifies the value of the Invoiced field.';
//                     ApplicationArea = All;
//                     Editable = Rec.Invoiced = false;
//                 }
//                 field("Location Code"; Rec."Location Code")
//                 {
//                     ApplicationArea = all;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Location Code field.';
//                 }
//                 field("Start Date"; Rec."Start Date")
//                 {
//                     ApplicationArea = all;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Start Date field.';
//                 }
//                 field("End Date"; Rec."End Date")
//                 {
//                     Caption = 'End Date';
//                     ApplicationArea = all;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the End Date field.';
//                 }


//                 field("Actual End Date"; Rec."Actual End Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Actual End Date field.';
//                     trigger OnValidate()
//                     begin

//                         if (Rec."Actual End Date" < Rec."Start Date") then
//                             Error('Please fill the correct actual end date cannot be before start date but can be after end date');
//                     end;
//                 }
//                 field("Actual Man Days"; Rec."Actual Man Days")
//                 {
//                     ApplicationArea = all;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Actual Man Days field.';
//                 }
//                 field("Billing Type"; Rec."Billing Type")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                     ToolTip = 'Specifies the value of the Billing Type field.';
//                 }
//                 field("OPE Type"; Rec."OPE Type")
//                 {
//                     ApplicationArea = All;
//                     Editable = (Rec.Status = Rec.Status::Open) and Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the OPE Type field.';
//                 }
//                 field("TAX Type"; Rec."TAX Type")
//                 {
//                     ApplicationArea = All;
//                     Editable = (Rec.Status = Rec.Status::Open) and Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the TAX Type field.';
//                 }
//                 field("Not Due"; Rec."Not Due")
//                 {
//                     ApplicationArea = All;
//                     Editable = Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the IDNB field.';
//                 }
//                 field("Due Date"; Rec."Due Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = Rec."Not Due" = true and Rec.Invoiced = false;
//                     ToolTip = 'Specifies the value of the Due Date field.';
//                 }
//             }
//         }
//     }
//     actions
//     {
//         area(Processing)
//         {
//             action("Short Close")
//             {
//                 ApplicationArea = All;
//                 Caption = 'Short Close', comment = 'NLB="YourLanguageCaption"';
//                 Image = CloseDocument;
//                 ToolTip = 'Executes the Short Close action.';

//                 trigger OnAction()
//                 var
//                     MandateHdr: Record "Mandate Header";
//                     MandLine: Record "Mandate Line";
//                     RemainingAmt: Decimal;
//                     TotalAmount: Decimal;
//                 begin
//                     Clear(TotalAmount);
//                     Clear(RemainingAmt);
//                     Rec.TestField("Reason Code");
//                     Rec.TestField("Short Closed", false);

//                     if MandateHdr.Get(Rec."Mandate Document No.") then begin
//                         MandateHdr.TestField(Status, MandateHdr.Status::Released);
//                         MandLine.Reset();
//                         MandLine.SetRange("Mandate Document No.", MandateHdr."No.");
//                         if MandLine.FindSet() then
//                             repeat
//                                 TotalAmount += MandLine."Amount Assigned";
//                             until MandLine.Next() = 0;

//                         RemainingAmt := MandateHdr."Total EL Amt" - TotalAmount;
//                         if TotalAmount <> 0 then
//                             if RemainingAmt <> 0 then begin
//                                 Rec."Short Close Qty." := RemainingAmt;
//                                 Rec."Amount" := 0;
//                                 Rec."Short Closed" := true;
//                                 Rec.Status := Rec.Status::"Short Closed";
//                                 Rec.Modify(true);
//                             end;
//                         MandateHdr.Status := MandateHdr.Status::Closed;
//                         MandateHdr."Short Closed" := true;
//                         MandateHdr.Modify();
//                     end;

//                     ShortCloseValidation(Rec);
//                     CurrPage.Update(false);
//                 end;
//             }

//             action("Convert Sales Invoice")
//             {
//                 ApplicationArea = All;
//                 Caption = 'Make Sales Invoice';
//                 Image = Invoice;
//                 ToolTip = 'Executes the Make Sales Invoice action.';

//                 trigger OnAction()
//                 var
//                     SalesHdr: Record "Sales Header";
//                     MandateLine: Record "Mandate Line";
//                     SalesHeaderNO: Code[20];
//                 begin
//                     MandateLine.Reset();
//                     CurrPage.SetSelectionFilter(MandateLine);
//                     if MandateLine.FindSet() then
//                         repeat
//                             MandateLine.TestField(Status, MandateLine.Status::Released);
//                             if MandateLine."Amount to Assign" = 0 then
//                                 Error('Amount To Asign must have a value in Line no: %1', MandateLine."Line No.");
//                         until MandateLine.Next() = 0;

//                     SalesHeaderNO := CreateSalesInvHeader(Rec);
//                     MandateLine.Reset();
//                     CurrPage.SetSelectionFilter(MandateLine);
//                     if MandateLine.FindSet() then
//                         repeat
//                             CreateSalesInvoice(MandateLine, SalesHeaderNO);
//                         until MandateLine.Next() = 0;
//                     Message('Sales Invoice %1 created successfully.', SalesHeaderNO);
//                     if SalesHdr.get(SalesHdr."Document Type"::Invoice, SalesHeaderNO) then
//                         Page.Run(Page::"Sales Invoice", SalesHdr);
//                 end;
//             }
//             action(SplitLines)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Split Lines';
//                 Image = Splitlines;
//                 ToolTip = 'Executes the Split Lines action.';
//                 // Enabled = EditableStatus;

//                 trigger OnAction()
//                 begin
//                     SplitLinesMonthWise();
//                 end;
//             }
//         }
//     }

//     trigger OnDeleteRecord(): Boolean
//     begin
//         Rec.TestField(Status, Rec.Status::Open);
//     end;

//     trigger OnAfterGetCurrRecord()
//     begin

//         rec."Remaining Amount" := abs(rec."Amount Assigned" - rec.Amount);

//         RecMHdr.Reset();
//         if RecMHdr.Get(Rec."Mandate Document No.") then
//             if RecMHdr."Businsess Type" = 'LICENSE' then
//                 EditableStatus := true
//             else
//                 EditableStatus := false;
//     end;


//     trigger OnAfterGetRecord()
//     begin

//         rec."Remaining Amount" := abs(rec."Amount Assigned" - rec.Amount);
//         RecMHdr.Reset();
//         RecMHdr.SetRange("No.", Rec."Mandate Document No.");
//         if RecMHdr.FindFirst() then begin
//             Rec.Status := RecMHdr.Status;
//             Rec."Billing Type" := RecMHdr."Billing Type";
//             Rec."OPE Type" := RecMHdr."OPE Type";
//             Rec."TAX Type" := RecMHdr."TAX Type";
//             Rec.Modify()
//         end;
//         //071123Rk
//         IF Rec.Amount <> 0 then
//             if Rec.Amount = Rec."Amount Assigned" then begin
//                 Rec.Invoiced := true;
//                 Rec.Status := Rec.Status::Closed;
//                 Rec.Modify();
//             end
//             else begin
//                 RecMHdr.Reset();
//                 RecMHdr.SetRange("No.", Rec."Mandate Document No.");
//                 if RecMHdr.FindFirst() then begin
//                     Rec.Status := RecMHdr.Status;
//                     Rec.Modify()
//                 end;
//             end;
//         RecMHdr.Reset();
//         if RecMHdr.Get(Rec."Mandate Document No.") then
//             if RecMHdr."Businsess Type" = 'LICENSE' then
//                 EditableStatus := true
//             else
//                 EditableStatus := false;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         Rec.Quantity := 1;
//         if rec.Type = rec.Type::" " then
//             rec.Type := rec.Type::"G/L Account";
//     end;

//     var
//         RecMHdr: Record "Mandate Header";
//         EditableStatus: Boolean;

//     procedure ShortCloseValidation(var LRecML: Record "Mandate Line")
//     var
//         LrecMH: Record "Mandate Header";
//         LrecML1: Record "Mandate Line";
//         TotalLineAmount: Decimal;
//     begin
//         if LrecMH.Get(LrecML1."Mandate Document No.") then begin
//             LrecML1.Reset();
//             LrecML1.SetRange("Mandate Document No.", LrecMH."No.");
//             if LrecML1.FindSet() then
//                 repeat
//                     if LrecML1."Short Close Qty." <> 0 then
//                         TotalLineAmount += LrecML1."Short Close Qty."
//                     else
//                         TotalLineAmount += LrecML1."Amount Assigned";
//                 until LrecML1.Next() = 0;
//             if (LrecMH."Total EL Amt" <> 0) and (TotalLineAmount <> 0) then
//                 if TotalLineAmount = LrecMH."Total EL Amt" then begin
//                     LrecMH.Status := LrecMH.Status::Closed;
//                     LrecMH.Modify(true);
//                 end;

//         end;
//     end;

//     procedure CreateSalesInvoice(var MLine: Record "Mandate Line"; salesInvNo: Code[20])
//     var
//         SalesLine: Record "Sales Line";
//         MandateHeader: Record "Mandate Header";
//         SalesInvHeader: Record "Sales Header";
//         NextLineNo: Integer;
//         QtyToUse: Decimal;
//     begin
//         if SalesInvHeader.get(SalesInvHeader."Document Type"::Invoice, salesInvNo) then begin
//             SalesLine.Reset();
//             SalesLine.SetRange("Document Type", SalesInvHeader."Document Type");
//             SalesLine.SetRange("Document No.", SalesInvHeader."No.");
//             if SalesLine.FindLast() then
//                 NextLineNo := SalesLine."Line No." + 10000
//             else
//                 NextLineNo := 10000;

//             SalesLine.Reset();
//             SalesLine.Init();
//             SalesLine."Document Type" := SalesInvHeader."Document Type";
//             SalesLine."Document No." := SalesInvHeader."No.";
//             SalesLine."Line No." := NextLineNo;

//             SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
//             SalesLine.Validate("No.", MLine."Item No.");

//             if MLine."Location Code" <> '' then
//                 SalesLine.Validate("Location Code", MLine."Location Code");

//             SalesLine.Validate(Description, MLine.Description);
//             SalesLine.Validate("Description 2", MLine."Description 2");

//             if MLine.Quantity <> 0 then
//                 QtyToUse := MLine.Quantity
//             else
//                 QtyToUse := 1;

//             SalesLine.Validate(Quantity, QtyToUse);
//             SalesLine.Validate("Unit of Measure Code", MLine."Unit of Measure Code");

//             SalesLine."Mandate No" := MLine."Mandate Document No.";
//             SalesLine.Validate("%", MLine."%");
//             if MLine."Unit Cost" <> 0 then
//                 SalesLine.Validate("Unit Price", MLine."Unit Cost")
//             else
//                 SalesLine.Validate("Unit Price", MLine."Amount to Assign");

//             if MandateHeader.Get(MLine."Mandate Document No.") then begin
//                 SalesLine."Shortcut Dimension 1 Code" := MandateHeader."Businsess Type";
//                 SalesLine."Shortcut Dimension 2 Code" := MandateHeader."Businsess Vertical";
//             end;
//             SalesLine."Billing Type" := MLine."Billing Type";
//             SalesLine."TAX Type" := MLine."TAX Type";
//             SalesLine."OPE Type" := MLine."OPE Type";
//             SalesLine.Insert(true);

//             //Update Mandate Line
//             MLine."Amount Assigned" += MLine."Amount to Assign";
//             MLine."Amount to Assign" := 0;
//             if MLine.Amount = MLine."Amount Assigned" then
//                 MLine.Invoiced := true;
//             MLine.Modify(true);
//         end;
//     end;

//     procedure CreateSalesInvHeader(var MLine: Record "Mandate Line"): Code[20]
//     var
//         SalesHdr: Record "Sales Header";
//         MandateHeader: Record "Mandate Header";
//         NoSeries: Record "No. Series";
//         NoSeriesMgmt: Codeunit "No. Series";
//         NoSeriesCode: Code[20];
//     begin
//         if MandateHeader.Get(MLine."Mandate Document No.") then begin
//             if MandateHeader."Location Code" = 'EXPORT' then
//                 NoSeriesCode := 'SI-EXP'
//             else
//                 NoSeriesCode := 'SI-DOM';


//             // Create Sales Invoice Header
//             SalesHdr.Init();
//             SalesHdr."Document Type" := SalesHdr."Document Type"::Invoice;
//             SalesHdr."No. Series" := NoSeriesCode;
//             SalesHdr."No." := NoSeriesMgmt.GetNextNo(NoSeriesCode, WorkDate(), true);
//             SalesHdr.Insert(true);

//             NoSeries.Reset();
//             NoSeries.SetRange(Code, SalesHdr."No. Series");
//             if NoSeries.FindFirst() then
//                 SalesHdr."Posting No. Series" := NoSeries."Posted Doc. No. Sr";
//             //Set Header Fields
//             SalesHdr.Validate("Sell-to Customer No.", MandateHeader."Customer No.");
//             SalesHdr.Validate("Document Date", MandateHeader."Document Date");
//             SalesHdr.Validate("Currency Code", MandateHeader."Currency Code");

//             if Rec."Location Code" <> '' then
//                 SalesHdr.Validate("Location Code", Rec."Location Code");

//             SalesHdr."Mandate No." := MandateHeader."No.";
//             SalesHdr.Modify(true);

//             AddDimensions(MandateHeader, SalesHdr);

//             exit(SalesHdr."No.");
//         end;
//     end;

//     procedure AddDimensions(MandateHeader: Record "Mandate Header"; SalesHdr: Record "Sales Header")
//     var
//         DimsetEntry: Record "Dimension Set Entry";
//         DimsetEntry1: Record "Dimension Set Entry";
//         DimSetID: Integer;
//     begin
//         DimsetEntry.Reset();
//         if DimsetEntry.FindLast() then
//             DimSetID := DimsetEntry."Dimension Set ID" + 1
//         else
//             DimSetID := 1;

//         DimsetEntry1.Init();
//         DimsetEntry1.Validate("Dimension Set ID", DimSetID);
//         DimsetEntry1.Validate("Dimension Code", 'TYPE OF SERVICES');
//         DimsetEntry1.Validate("Dimension Value Code", MandateHeader."Type of vertical");
//         DimsetEntry1.Insert(true);

//         DimsetEntry.Reset();
//         DimsetEntry.SetRange("Dimension Set ID", DimSetID);
//         if DimsetEntry.FindLast() then begin
//             DimsetEntry1.Init();
//             DimsetEntry1.Validate("Dimension Set ID", DimsetEntry."Dimension Set ID");
//             DimsetEntry1.Validate("Dimension Code", 'BUSINESS VERTICAL');
//             DimsetEntry1.Validate("Dimension Value Code", MandateHeader."Businsess Vertical");
//             DimsetEntry1.Insert(true);

//             DimsetEntry1.Init();
//             DimsetEntry1.Validate("Dimension Set ID", DimsetEntry."Dimension Set ID");
//             DimsetEntry1.Validate("Dimension Code", 'BUSINESS TYPE');
//             DimsetEntry1.Validate("Dimension Value Code", MandateHeader."Businsess Type");
//             DimsetEntry1.Insert(true);

//             DimsetEntry1.Init();
//             DimsetEntry1.Validate("Dimension Set ID", DimsetEntry."Dimension Set ID");
//             DimsetEntry1.Validate("Dimension Code", 'BD PARTNER');
//             DimsetEntry1.Validate("Dimension Value Code", MandateHeader."BD Partner");
//             DimsetEntry1.Insert(true);
//         end;

//         SalesHdr."Dimension Set ID" := DimSetID;
//         SalesHdr.Modify(true);
//     end;

//     procedure SplitLinesMonthWise()
//     var
//         MandHeader: Record "Mandate Header";
//         MandLines: Record "Mandate Line";
//         CheckLine: Record "Mandate Line";
//         I: Integer;
//         MonthStartDate: Date;
//         MonthEndDate: Date;
//         LineNo: Integer;
//         // TotalPeriods: Integer;
//         PeriodMonths: Integer;
//     begin
//         Clear(I);
//         Clear(MonthStartDate);
//         Clear(MonthEndDate);
//         Clear(LineNo);
//         if not MandHeader.Get(Rec."Mandate Document No.") then
//             exit;

//         // MandHeader.TestField("Billing Type", MandHeader."Billing Type"::Monthly);
//         MandHeader.TestField("No. of Months");
//         MandHeader.TestField("Start Date");
//         MandHeader.TestField("G/L Account");

//         // Decide period based on billing type
//         case MandHeader."Billing Type" of
//             MandHeader."Billing Type"::Monthly:
//                 PeriodMonths := 1;
//             MandHeader."Billing Type"::Quarterly:
//                 PeriodMonths := 3;
//         end;

//         for I := 1 to MandHeader."No. of Months" do begin
//             // Start Date
//             MonthStartDate := CalcDate('<+' + Format((I - 1) * PeriodMonths) + 'M>', MandHeader."Start Date");
//             // End Date
//             MonthEndDate := CalcDate('<+' + Format(PeriodMonths) + 'M-1D>', MonthStartDate);

//             // Check duplicate line for same month
//             CheckLine.Reset();
//             CheckLine.SetRange("Mandate Document No.", MandHeader."No.");
//             CheckLine.SetRange(Type, CheckLine.Type::"G/L Account");
//             CheckLine.SetRange("Item No.", MandHeader."G/L Account");
//             CheckLine.SetRange("Start Date", MonthStartDate);
//             CheckLine.SetRange("End Date", MonthEndDate);
//             if not CheckLine.FindFirst() then begin

//                 // Get next line no.
//                 MandLines.Reset();
//                 MandLines.SetRange("Mandate Document No.", MandHeader."No.");
//                 if MandLines.FindLast() then
//                     LineNo := MandLines."Line No." + 10000
//                 else
//                     LineNo := 10000;

//                 // Insert line
//                 MandLines.Init();
//                 MandLines."Mandate Document No." := MandHeader."No.";
//                 MandLines."Line No." := LineNo;
//                 MandLines.Validate(Type, MandLines.Type::"G/L Account");
//                 MandLines.Validate("Item No.", MandHeader."G/L Account");
//                 MandLines.Validate("Start Date", MonthStartDate);
//                 MandLines.Validate("End Date", MonthEndDate);
//                 MandLines.Validate(Quantity, 1);
//                 MandLines.Insert(true);
//             end;
//         end;
//     end;
// }
