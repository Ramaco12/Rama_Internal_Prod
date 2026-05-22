pageextension 70109 RequestToApproveExt extends "Requests to Approve"
{
    layout
    {
        addafter(ToApprove)
        {
            field(CustomerNo; CustomerNo)
            {
                ApplicationArea = All;
                Caption = 'Customer No.';
            }

            field(CustomerName; CustomerName)
            {
                ApplicationArea = All;
                Caption = 'Customer Name';
            }
            field(MandateType; MandateType)
            {
                ApplicationArea = all;
                Caption = 'Mandate Type';
            }
            field(StartDate; StartDate)
            {
                ApplicationArea = all;
                Caption = 'Start Date';
            }
            field(EndDate; EndDate)
            {
                ApplicationArea = all;
                Caption = 'End Date';
            }
            field(ELDate; ELDate)
            {
                ApplicationArea = all;
                Caption = 'E/L Date';
            }
            field(TotalELAmount; TotalELAmount)
            {
                ApplicationArea = all;
                Caption = 'Total E/L Amount';
            }
            field(BuisnessVertical; BuisnessVertical)
            {
                ApplicationArea = all;
                Caption = 'Buisness Vertical';
            }
            field(BuisnessType; BuisnessType)
            {
                ApplicationArea = all;
                Caption = 'Buisness Type';
            }
            field(TypeofServices; TypeofServices)
            {
                ApplicationArea = all;
                Caption = 'Type of Services';
            }
            field(BDPartner; BDPartner)
            {
                ApplicationArea = all;
                Caption = 'BD Partner';
            }
            field(SalesPersonL; SalesPersonL)
            {
                ApplicationArea = all;
                Caption = 'Client Account Manager';
            }
            field(BillingType; BillingType)
            {
                ApplicationArea = all;
                Caption = 'Billing Type';
            }
            field(OPEType; OPEType)

            {
                ApplicationArea = all;
                Caption = 'OPE Type';
            }


        }
        modify(Amount)
        {
            Visible = false;
        }
        modify("Amount (LCY)")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify(Details)
        {
            Visible = false;
        }
    }

    var
        CustomerNo: Code[20];
        CustomerName: Text[100];
        MandateType: code[20];
        StartDate: Date;
        EndDate: Date;
        ELDate: Date;
        TotalELManDays: Integer;
        TotalELAmount: Decimal;
        BuisnessVertical: Text[50];
        BuisnessType: text[50];
        TypeofServices: text[50];
        BDPartner: text[50];
        TaxType: Enum TAXType;
        BillingType: Enum "Billing Type";
        OPEType: Enum "OPE Type";
        SalesPersonL: text[50];









    trigger OnAfterGetRecord()
    var
        Mandate: Record "Mandate Header";
    begin
        Clear(CustomerNo);
        Clear(CustomerName);

        Mandate.SetRange("No.", Rec."Document No.");

        if Mandate.FindFirst() then begin
            CustomerNo := Mandate."Customer No.";
            CustomerName := Mandate."Customer Name";
            MandateType := Mandate."Mandate Type";
            StartDate := Mandate."Start Date";
            EndDate := Mandate."End Date";
            ELDate := Mandate."E/L Date";
            TotalELAmount := Mandate."Total EL Amt";
            BuisnessVertical := Mandate."Businsess Vertical";
            BuisnessType := Mandate."Businsess Type";
            TypeofServices := Mandate."Type of vertical";
            BDPartner := Mandate."BD Partner";
            SalesPersonL := Mandate."Sales PersonL";
            TaxType := Mandate."TAX Type";
            BillingType := Mandate."Billing Type";
            OPEType := Mandate."OPE Type";

        end;
    end;
}