page 70161 "Mandate E/L Card"
{
    Caption = 'Mandate E/L ';
    PageType = Card;
    SourceTable = "Mandate Header";
    PromotedActionCategories = 'New,Process,Report,Status,Release,Prepare,Comment,Request Approval,History,Print/Send,Navigate';
    DataCaptionFields = "No.", "Customer Name";
    RefreshOnActivate = true;
    InsertAllowed = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = (Rec.Status = Rec.Status::Open) or (Rec.Status = Rec.Status::"Pending Approval");
                field("Document Date"; rec."Document Date")
                {
                    ApplicationArea = all;
                    Editable = EditableStatus;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    ShowMandatory = true;
                    Editable = EditableStatus;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    Editable = false;
                }
                field("Customer Address"; Rec."Customer Address")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Customer Address field.';
                    Editable = false;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the City field.';
                    Editable = false;
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Country field.';
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if Rec."Currency Code" = 'INR' then begin
                            Rec."Location Code" := 'DOMESTIC';
                            Rec.Modify();
                        end else begin
                            Rec."Location Code" := 'EXPORT';
                            Rec.Modify();
                        end;
                    end;
                }
                field("Mandate Type"; Rec."Mandate Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mandate Type field.';
                    NotBlank = true;
                    Editable = EditableStatus;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the End Date field.';

                    trigger OnValidate()
                    begin
                        if Rec."End Date" < Rec."Start Date" then
                            Error('End Date must be greater than start date');
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Location Code field.';

                    trigger OnValidate()
                    begin
                        if Rec."Currency Code" = 'INR' then
                            Rec.TestField("Location Code", 'DOMESTIC')
                        else
                            Rec.TestField("Location Code", 'EXPORT');
                    end;
                }

                field("E/L Date"; Rec."E/L Date")
                {
                    ApplicationArea = All;
                    Editable = EditableStatus;
                    ToolTip = 'Specifies the value of the Enquiry Date field.';
                }
                field("EL Ref No."; Rec."EL Ref No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the E/L Referance No. field.';
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Status field.';
                }

                field(Comment; Rec.Comment)
                {
                    applicationArea = All;
                }
                field("Short Closed"; rec."Short Closed")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Short Closed field.';
                }
                field("Total Man Days"; Rec."Total Man Days")
                {
                    Caption = 'Total E/L Man Days';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Man Days  field.';
                }
                field("Total EL Amt"; Rec."Total EL Amt")
                {
                    Caption = 'Total E/L Amount';
                    ApplicationArea = ALL;
                    Editable = Rec.Status = Rec.Status::Open;
                    ToolTip = 'Specifies the value of the Total EL Amt field.';

                    trigger OnValidate()
                    var
                        LrecML: Record "Mandate Line";
                        totalamount: Decimal;
                    begin
                        if Rec."Total EL Amt" = 0 then begin
                            LrecML.Reset();
                            LrecML.SetRange("Mandate Document No.", Rec."No.");
                            LrecML.SetFilter(Status, '<>%1', LrecML.Status::Released);
                            if LrecML.FindSet() then
                                repeat
                                    if LrecML."Amount Assigned" <> 0 then begin
                                        LrecML.Amount := 0;
                                        LrecML."Amount to Assign" := 0;
                                        LrecML."%" := 0;
                                        LrecML.Modify();
                                    end;
                                until LrecML.Next() = 0;
                        end;

                        if Rec."Total EL Amt" < xRec."Total EL Amt" then begin
                            LrecML.Reset();
                            LrecML.SetRange("Mandate Document No.", Rec."No.");
                            LrecML.SetFilter(Status, '<>%1', LrecML.Status::Released);
                            if LrecML.FindSet() then
                                repeat
                                    totalamount += LrecML.Amount;
                                until LrecML.Next() = 0;
                            if totalamount > Rec."Total EL Amt" then
                                Error('Total E/L Amount must be greater than or equal to total amount assigned in lines.');
                        end;
                    end;
                }
                field("Committed Business"; Rec."Committed Business")
                {
                    ApplicationArea = all;
                }
                field("TAX Type"; Rec."TAX Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TAX Type field.';
                }
                group("Dimension")
                {
                    field("Businsess Vertical"; Rec."Businsess Vertical")
                    {
                        ApplicationArea = All;
                        ShowMandatory = true;
                        Editable = EditableStatus;
                        ToolTip = 'Specifies the value of the Businsess Vertical field.';
                    }
                    field("Businsess Type"; Rec."Businsess Type")
                    {
                        ApplicationArea = All;
                        Caption = 'Businsess Type';
                        ShowMandatory = true;
                        Editable = EditableStatus;
                        ToolTip = 'Specifies the value of the Businsess Type field.';

                    }
                    field("Type of vertical"; Rec."Type of vertical")
                    {
                        Caption = 'Type of Services';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Type of Services field.';
                    }
                    field("BD Partner"; Rec."BD Partner")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the BD Partner field.';
                    }
                    field("Sales PersonL"; rec."Sales PersonL")
                    {
                        ApplicationArea = All;
                        ShowMandatory = true;
                        Caption = 'Client Account Manager';
                        Editable = EditableStatus;
                        ToolTip = 'Specifies the value of the Sales Person field.';
                    }
                    field("Sales Invoice List"; Rec."Sales Invoice List")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Sales Invoice List field.';
                        trigger OnDrillDown()
                        var
                            SalesHeader: Record "Sales Header";
                        begin
                            SalesHeader.Reset();
                            SalesHeader.SetRange("Mandate No.", Rec."No.");
                            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);

                            Page.Run(Page::"Sales Invoice List", SalesHeader);
                        end;
                    }

                    field("Posted Sales Invoice List"; Rec."Posted Sales Invoice List")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Posted Sales Invoice List field.';
                        trigger OnDrillDown()
                        var
                            SalesInvHeader: Record "Sales Invoice Header";
                        begin
                            SalesInvHeader.Reset();
                            SalesInvHeader.SetRange("Mandate No", Rec."No.");
                            if SalesInvHeader.FindFirst() then
                                Page.Run(Page::"Posted Sales Invoices", SalesInvHeader);
                        end;
                    }
                    field("Billing Type"; Rec."Billing Type")
                    {
                        ApplicationArea = All;

                        ToolTip = 'Specifies the value of the Billing Type field.';

                        trigger OnValidate()
                        begin
                            if Rec."Billing Type" <> xRec."Billing Type" then begin
                                Rec."No. of Months" := 0;
                                Rec."G/L Account" := '';
                            end;
                            if Rec."Billing Type" <> xRec."Billing Type" then
                                DeleteMandateLines();
                        end;
                    }
                    field("No. of Months"; Rec."No. of Months")
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Months/Quarter';
                        ToolTip = 'Specifies the value of the No. of Months field.';
                        Editable = (Rec."Billing Type" = Rec."Billing Type"::Monthly) or (Rec."Billing Type" = Rec."Billing Type"::Quarterly);

                        trigger OnValidate()

                        begin
                            UpdateLinesBillingType();
                            if Rec."Billing Type" = Rec."Billing Type"::Quarterly then
                                if Rec."No. of Months" > 4 then
                                    Error('No. Of Quarter must be less then or equal to 4');
                        end;
                    }
                    field("G/L Account"; Rec."G/L Account")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the G/L Account field.';
                        Editable = (Rec."Billing Type" = Rec."Billing Type"::Monthly) or (Rec."Billing Type" = Rec."Billing Type"::Quarterly);

                        trigger OnValidate()
                        begin
                            if Rec."G/L Account" <> xRec."G/L Account" then
                                UpdateLinesGLAccount();
                        end;
                    }
                    field("OPE Type"; Rec."OPE Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the OPE Type field.';

                        trigger OnValidate()
                        begin
                            UpdateLinesOPEType();
                        end;
                    }
                }
            }

            part(Lines; "Mandate Subform")
            {
                Caption = 'Lines';
                ApplicationArea = Basic, Suite;
                SubPageLink = "Mandate Document No." = field("No.");
                UpdatePropagation = Both;
            }
        }
        area(FactBoxes)
        {
            part("SP. Attached Documents List"; "SP. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'SharePoint Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"Mandate Header"),
                              "No." = field("No.");
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(Process)
            {
                action("Mandate E/L Uploader")
                {
                    ApplicationArea = All;
                    Caption = 'Mandate E/L Uploader';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Mandate E/L Uploader Uploader action.';

                    trigger OnAction()
                    var
                        POuploaderReport: Report "Mandate E/L Uploader";
                    begin
                        POuploaderReport.SetDocNo(Rec."No.");
                        POuploaderReport.RunModal();
                    end;
                }
                action("Convert Sales Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Make Sales Invoice';
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Make Sales Invoice action.';

                    trigger OnAction()
                    var
                        SalesHdr: Record "Sales Header";
                        MandateLine: Record "Mandate Line";
                    begin
                        MandateLine.Reset();
                        MandateLine.SetRange("Mandate Document No.", Rec."No.");
                        if MandateLine.FindSet() then
                            repeat
                                MandateLine.TestField(Status, MandateLine.Status::Released);
                                if MandateLine."Amount to Assign" = 0 then
                                    Error('Amount To Asign must have a value in Line no: %1', MandateLine."Line No.");
                            until MandateLine.Next() = 0;

                        CreateSalesInvHeader(Rec, SalesHdr);
                        MandateLine.Reset();
                        MandateLine.SetRange("Mandate Document No.", Rec."No.");
                        if MandateLine.FindSet() then
                            repeat
                                CreateSalesInvoice(MandateLine, SalesHdr);
                            until MandateLine.Next() = 0;
                        Message('Sales Invoice %1 created successfully.', SalesHdr."No.");
                        Page.Run(Page::"Sales Invoice", SalesHdr);
                    end;
                }

                group(Status1)
                {
                    Caption = 'Status';

                    action("Cancel1")
                    {
                        ApplicationArea = All;
                        Caption = 'Cancel';
                        Image = Quote;
                        Promoted = true;
                        PromotedCategory = Category5;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        Enabled = (rec.Status <> rec.Status::Cancelled) and (rec.Status <> rec.Status::Closed);
                        ToolTip = 'Executes the Cancel action.';

                        trigger OnAction()
                        var
                            RecMELine: Record "Mandate Line";
                            QtyAss: Decimal;
                            Qty: Decimal;
                        begin
                            if Rec.Status = Rec.Status::Cancelled then Error('Mandate E/L %1 is already cancel', rec."No.");
                            RecMELine.Reset();
                            Clear(Qty);
                            Clear(QtyAss);
                            RecMELine.SetRange("Mandate Document No.", rec."No.");
                            if RecMELine.FindSet() then
                                repeat
                                    Qty += RecMELine.Quantity;
                                    QtyAss += RecMELine."Amount Assigned";
                                until RecMELine.Next() = 0;
                        end;
                    }
                    action("Release")
                    {
                        Visible = true;
                        ApplicationArea = All;
                        Caption = 'Release';
                        Image = Quote;
                        Promoted = true;
                        PromotedCategory = Category5;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        Enabled = (rec.Status <> rec.Status::Cancelled) and (rec.Status <> rec.Status::Closed);
                        ToolTip = 'Executes the Release action.';

                        trigger OnAction()
                        var
                            SPAttachment: Record "SharePoint Attachment";
                        begin

                            if rec.Status <> rec.Status::"Pending Approval" then
                                Error('Please Send Approval Request first');//Tejswi22052026


                            SPAttachment.Reset();
                            SPAttachment.SetRange("Table ID", Database::"Mandate Header");
                            SPAttachment.SetRange("No.", Rec."No.");
                            if not SPAttachment.FindFirst() then
                                Error('This document must have an attachment before Release');
                            Rec.Status := Rec.Status::Released;
                            Rec.Modify(true);
                        end;
                    }

                    action(Reopen)
                    {
                        ApplicationArea = All;
                        Caption = 'Reopen';
                        Image = Quote;
                        Promoted = true;
                        PromotedCategory = Category5;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        Enabled = (rec.Status <> rec.Status::Cancelled) and (rec.Status <> rec.Status::Closed);
                        ToolTip = 'Executes the Reopen action.';

                        trigger OnAction()
                        var
                            RecSELine: Record "Mandate Line";
                            QtyAss: Decimal;
                        begin
                            RecSELine.Reset();
                            RecSELine.SetRange("Mandate Document No.", rec."No.");
                            if RecSELine.FindFirst() then
                                repeat
                                    QtyAss += RecSELine."Amount Assigned";
                                until RecSELine.Next() = 0;

                            if QtyAss = 0 then begin
                                Rec.Status := Rec.Status::Open;
                                rec.Modify();
                            end;
                            // else
                            //     Error('You can not open as all sales Invoice is not cancelled.');//Tejswi22052026

                            if rec.Status <> Rec.Status::Cancelled then begin
                                rec.Status := Rec.Status::Open;
                                rec.Modify();
                            end
                            else
                                Error('You can not open as it is cancel.');
                        end;
                    }

                }

            }

        }

        area(Navigation)
        {
            group("Comment Group")
            {
                Caption = 'Comments';
                Image = Comment;


                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    //PromotedIsBig = true;
                    Enabled = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        SPAttachment: Record "SharePoint Attachment";
                    begin
                        // MandateLine.Reset();
                        // MandateLine.SetRange("Mandate Document No.", Rec."No.");
                        // if MandateLine.FindFirst() then
                        //     repeat
                        //         if MandateLine."Amount to Assign" = 0 then Error('Amount to Assign should not be blank.');
                        //     until MandateLine.Next() = 0
                        // else
                        //     Error('Amount to Assign should not be blank.');
                        SPAttachment.Reset();
                        SPAttachment.SetRange("Table ID", Database::"Mandate Header");
                        SPAttachment.SetRange("No.", Rec."No.");
                        if not SPAttachment.FindFirst() then
                            Error('This document must have an attachment before Post');
                        if not ApprovalMgmtMandate.IsMandateEnabled(Rec) then
                            Error('No workflow enabled for this record.');
                        ApprovalMgmtMandate.OnSendMandateforApproval(Rec);
                        // if ApprovalMgmtMandate.IsMandateEnabled(Rec) then
                        //     ApprovalMgmtMandate.OnSendMandateforApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    //Enabled = rec.Status <> rec.Status::Closed;
                    Enabled = CancancelApprovalForRecord or CancancelApprovalForFlow;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                    begin
                        ApprovalMgmtMandate.OnCancelMandateForApproval(Rec);
                    end;
                }
            }

        }
    }
    trigger OnModifyRecord(): Boolean
    var
        RecMHHdr: Record "Mandate Header";
    begin
        if rec.Status = rec.Status::Released then Error('You can not modify the record as status is released.');
        RecReqForQutHdr.Reset();
        RecReqForQutHdr.SetRange("Mandate No.", rec."No.");
        if RecReqForQutHdr.FindFirst() then Error('You can not modify the record');
    end;

    trigger OnOpenPage()
    var
        RecMHdr1: Record "Mandate Header";
    begin
        RecMHdr1.Reset();
        RecMHdr1.SetRange("No.", rec."No.");
        if RecMHdr1.FindFirst() then
            if (RecMHdr1.Status = RecMHdr1.Status::Cancelled) then CurrPage.Editable(false);

        // ///Rk 240124  //commented and add below code tejswi22052026      
        // if RecMHdr1.Status = RecMHdr1.Status::"Pending Approval" then
        //     EditableStatus := false
        // else
        //     EditableStatus := true;
        ///Rk 240124


        if (RecMHdr1.Status = RecMHdr1.Status::"Pending Approval") or (RecMHdr1.Status = RecMHdr1.Status::Released) then
            EditableStatus := false
        else
            EditableStatus := true;
    end;

    trigger OnAfterGetRecord()
    var
        LrecML1: Record "Mandate Line";
        TotalLineAmount: Decimal;
    begin
        Clear(TotalLineAmount);
        if (rec.Status = Rec.Status::Open) then StyleTxt := 'Favorable';
        if (Rec.Status <> Rec.Status::Open) then StyleTxt := 'Strong';
        ///Rk 240125
        // if Rec.Status = Rec.Status::"Pending Approval" then//comment and add below code tejswi22052026
        //     EditableStatus := false
        // else
        //     EditableStatus := true;
        // //Temp logic //29/01/2024


        if (Rec.Status = Rec.Status::"Pending Approval") or (rec.Status = rec.Status::Released) then
            EditableStatus := false
        else
            EditableStatus := true;


        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);

        LrecML1.Reset();
        LrecML1.SetRange("Mandate Document No.", Rec."No.");
        if LrecML1.FindSet() then
            repeat
                if LrecML1."Short Close Qty." <> 0 then
                    TotalLineAmount += LrecML1."Short Close Qty."
                else
                    TotalLineAmount += LrecML1."Amount Assigned";
            until LrecML1.Next() = 0;
        if (Rec."Total EL Amt" <> 0) and (TotalLineAmount <> 0) then
            if TotalLineAmount = Rec."Total EL Amt" then begin
                Rec.Status := Rec.Status::Closed;
                Rec.Modify(true);
            end;

        // OpenApprovalEntriesExistForcurruser := ApprovalMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CancancelApprovalForRecord := ApprovalMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgmt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CancancelApprovalForFlow);


    end;

    trigger OnDeleteRecord(): Boolean
    var
        RecSI: Record "Sales Header";
        RecMELine: Record "Mandate Line";
    begin
        RecSI.Reset();
        RecSI.SetRange("Mandate No.", rec."No.");
        if RecSI.FindFirst() then Error('You cannot delete Mandate %1 because there is at least one mandate for this Enquiry.', rec."No.");
        RecMELine.Reset();
        RecMELine.SetRange("Mandate Document No.", rec."No.");
        if RecMELine.FindFirst() then RecMELine.Delete();
    end;

    var
        RecReqForQutHdr: Record "Sales Header";
        UserSetup: Record "User Setup";
        ApprovalMgmtMandate: Codeunit "Approval Mgmt.Mandate";
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgmt: Codeunit "Workflow Webhook Management";
        OpenApprovalEntriesExist: Boolean;
        OpenApprovalEntriesExistForcurruser: Boolean;
        CancancelApprovalForRecord: Boolean;
        CancancelApprovalForFlow: Boolean;
        CanRequestApprovalForFlow: Boolean;
        StyleTxt: Text;
        EditableStatus: Boolean;

    procedure CreateSalesInvoice(var MLine: Record "Mandate Line"; SalesInvHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        MandateHeader: Record "Mandate Header";
        NextLineNo: Integer;
        QtyToUse: Decimal;
    begin

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesInvHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesInvHeader."No.");
        if SalesLine.FindLast() then
            NextLineNo := SalesLine."Line No." + 10000
        else
            NextLineNo := 10000;

        SalesLine.Reset();
        SalesLine.Init();
        SalesLine."Document Type" := SalesInvHeader."Document Type";
        SalesLine."Document No." := SalesInvHeader."No.";
        SalesLine."Line No." := NextLineNo;

        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
        SalesLine.Validate("No.", MLine."Item No.");

        if MLine."Location Code" <> '' then
            SalesLine.Validate("Location Code", MLine."Location Code");

        SalesLine.Validate(Description, MLine.Description);
        SalesLine.Validate("Description 2", MLine."Description 2");

        if MLine.Quantity <> 0 then
            QtyToUse := MLine.Quantity
        else
            QtyToUse := 1;

        SalesLine.Validate(Quantity, QtyToUse);
        SalesLine.Validate("Unit of Measure Code", MLine."Unit of Measure Code");

        SalesLine."Mandate No" := MLine."Mandate Document No.";
        SalesLine.Validate("%", MLine."%");
        if MLine."Unit Cost" <> 0 then
            SalesLine.Validate("Unit Price", MLine."Unit Cost")
        else
            SalesLine.Validate("Unit Price", MLine."Amount to Assign");

        SalesLine.Validate("%", MLine."%");
        SalesLine.Validate("Unit Price", MLine."Amount to Assign");
        if MandateHeader.Get(MLine."Mandate Document No.") then begin
            SalesLine."Shortcut Dimension 1 Code" := MandateHeader."Businsess Type";
            SalesLine."Shortcut Dimension 2 Code" := MandateHeader."Businsess Vertical";
        end;
        SalesLine."Billing Type" := MLine."Billing Type";
        SalesLine."TAX Type" := MLine."TAX Type";
        SalesLine."OPE Type" := MLine."OPE Type";
        SalesLine.Insert(true);

        //Update Mandate Line
        MLine."Amount Assigned" += MLine."Amount to Assign";
        MLine."Amount to Assign" := 0;
        if MLine.Amount = MLine."Amount Assigned" then
            MLine.Invoiced := true;
        MLine.Modify(true);
    end;

    procedure CreateSalesInvHeader(var MHeader: Record "Mandate Header"; SalesHdr: Record "Sales Header")
    var
        // SalesHdr: Record "Sales Header";
        MandateHeader: Record "Mandate Header";
        NoSeries: Record "No. Series";
        NoSeriesMgmt: Codeunit "No. Series";
        NoSeriesCode: Code[20];
    begin
        //Added Multiple Location
        if MandateHeader."Location Code" = 'EXPORT' then
            NoSeriesCode := 'SI-EXP'
        else
            NoSeriesCode := 'SI-DOM';


        // Create Sales Invoice Header
        SalesHdr.Init();
        SalesHdr."Document Type" := SalesHdr."Document Type"::Invoice;
        SalesHdr."No. Series" := NoSeriesCode;
        SalesHdr."No." := NoSeriesMgmt.GetNextNo(NoSeriesCode, WorkDate(), true);
        SalesHdr.Insert(true);

        NoSeries.Reset();
        NoSeries.SetRange(Code, SalesHdr."No. Series");
        if NoSeries.FindFirst() then
            SalesHdr."Posting No. Series" := NoSeries."Posted Doc. No. Sr";

        //Set Header Fields
        SalesHdr.Validate("Sell-to Customer No.", MandateHeader."Customer No.");
        SalesHdr.Validate("Document Date", MandateHeader."Document Date");
        SalesHdr.Validate("Currency Code", MandateHeader."Currency Code"); // important

        if Rec."Location Code" <> '' then
            SalesHdr.Validate("Location Code", Rec."Location Code");

        SalesHdr."Mandate No." := MandateHeader."No.";
        SalesHdr.Modify(true);

        AddDimensions(MandateHeader, SalesHdr);
        // end;
    end;

    procedure AddDimensions(MandateHeader: Record "Mandate Header"; SalesHdr: Record "Sales Header")
    var
        DimsetEntry: Record "Dimension Set Entry";
        DimsetEntry1: Record "Dimension Set Entry";
        DimSetID: Integer;
    begin
        DimsetEntry.Reset();
        if DimsetEntry.FindLast() then
            DimSetID := DimsetEntry."Dimension Set ID" + 1
        else
            DimSetID := 1;

        DimsetEntry1.Init();
        DimsetEntry1.Validate("Dimension Set ID", DimSetID);
        DimsetEntry1.Validate("Dimension Code", 'TYPE OF SERVICES');
        DimsetEntry1.Validate("Dimension Value Code", MandateHeader."Type of vertical");
        DimsetEntry1.Insert(true);

        DimsetEntry.Reset();
        DimsetEntry.SetRange("Dimension Set ID", DimSetID);
        if DimsetEntry.FindLast() then begin
            DimsetEntry1.Init();
            DimsetEntry1.Validate("Dimension Set ID", DimsetEntry."Dimension Set ID");
            DimsetEntry1.Validate("Dimension Code", 'BUSINESS VERTICAL');
            DimsetEntry1.Validate("Dimension Value Code", MandateHeader."Businsess Vertical");
            DimsetEntry1.Insert(true);

            DimsetEntry1.Init();
            DimsetEntry1.Validate("Dimension Set ID", DimsetEntry."Dimension Set ID");
            DimsetEntry1.Validate("Dimension Code", 'BUSINESS TYPE');
            DimsetEntry1.Validate("Dimension Value Code", MandateHeader."Businsess Type");
            DimsetEntry1.Insert(true);

            DimsetEntry1.Init();
            DimsetEntry1.Validate("Dimension Set ID", DimsetEntry."Dimension Set ID");
            DimsetEntry1.Validate("Dimension Code", 'BD PARTNER');
            DimsetEntry1.Validate("Dimension Value Code", MandateHeader."BD Partner");
            DimsetEntry1.Insert(true);
        end;

        SalesHdr."Dimension Set ID" := DimSetID;
        SalesHdr.Modify(true);
    end;

    procedure DeleteMandateLines()
    var
        MandateLine: Record "Mandate Line";
    begin
        MandateLine.Reset();
        MandateLine.SetRange("Mandate Document No.", Rec."No.");
        if MandateLine.FindSet() then
            MandateLine.DeleteAll(true);
    end;

    procedure UpdateLinesBillingType()
    var
        PeriodMonths: Integer;
    begin
        case Rec."Billing Type" of
            Rec."Billing Type"::Monthly:
                begin
                    PeriodMonths := Rec."No. of Months";
                    Rec."End Date" := CalcDate('<+' + Format(PeriodMonths) + 'M-1D>', Rec."Start Date");
                    Rec.Modify();
                end;
            Rec."Billing Type"::Quarterly:
                begin
                    PeriodMonths := Rec."No. of Months" * 3;
                    Rec."End Date" := CalcDate('<+' + Format(PeriodMonths) + 'M-1D>', Rec."Start Date");
                    Rec.Modify();
                end;
        end;
    end;

    procedure UpdateLinesOPEType()
    var
        MandateLine: Record "Mandate Line";
    begin
        MandateLine.Reset();
        MandateLine.SetRange("Mandate Document No.", Rec."No.");
        if MandateLine.FindSet() then
            repeat
                MandateLine.Validate("OPE Type", Rec."OPE Type");
                MandateLine.Modify();
            until MandateLine.Next() = 0;
    end;

    procedure UpdateLinesGLAccount()
    var
        MandateLine: Record "Mandate Line";
    begin
        MandateLine.Reset();
        MandateLine.SetRange("Mandate Document No.", Rec."No.");
        if MandateLine.FindSet() then
            repeat
                MandateLine.Validate("Item No.", Rec."G/L Account");
                MandateLine.Modify();
            until MandateLine.Next() = 0;
    end;
}
