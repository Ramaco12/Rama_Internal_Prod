page 70165 "Mandate List"
{
    ApplicationArea = All;
    Caption = 'Mandate List';
    PageType = List;
    SourceTable = "Mandate Header";
    UsageCategory = Lists;
    CardPageId = "Mandate E/L Card";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                // field("Customer No."; Rec."Customer No.")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Customer No. field.';
                // }
                // field("Customer Name"; Rec."Customer Name")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Customer Name field.';
                // }
                // field("Item Description"; rec."Item Description")
                // {
                //     ApplicationArea = all;
                //     ToolTip = 'Specifies the value of the Item Description field.';
                // }
                // // field("RFQ Date"; Rec."RFQ Date")
                // // {
                // //     ApplicationArea = All;
                // //     ToolTip = 'Specifies the value of the RFQ Date field.';
                // // }
                // field("Mandate Type"; Rec."Mandate Type")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Purchase Type field.';
                // }
                // field("No."; Rec."No.")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the  No. field.';
                // }
                // field(Status; rec.Status)
                // {
                //     ApplicationArea = All;
                //     StyleExpr = StyleTxt;
                //     ToolTip = 'Specifies the value of the Status field.';
                // }
                // field(SystemCreatedAt; rec.SystemCreatedAt)
                // {
                //     ApplicationArea = all;
                //     ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                // }
                // field(SystemCreatedBy; CreatedAt)
                // {
                //     ApplicationArea = all;
                //     ToolTip = 'Specifies the value of the CreatedAt field.';
                // }
                // field(SystemModifiedAt; rec.SystemModifiedAt)
                // {
                //     ApplicationArea = all;
                //     ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                // }
                // field(ModifiedAt; ModifiedAt)
                // {
                //     ApplicationArea = all;
                //     ToolTip = 'Specifies the value of the ModifiedAt field.';
                // }


                field("No."; Rec."No.")
                {
                    Caption = 'Mandate No';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Mandate No field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Mandate Type"; Rec."Mandate Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mandate Type field.';
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

                }
                field("E/L Date"; Rec."E/L Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the E/L Date field.';

                }

                field("Status"; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';

                }
                field("Total Man Days"; Rec."Total Man Days")
                {
                    Caption = 'EL Man Days';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the EL Man Days field.';

                }
                field("Total EL Amt"; Rec."Total EL Amt")

                {
                    Caption = 'Total EL Amt';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total EL Amt field.';

                }
                field("Businsess Vertical"; Rec."Businsess Vertical")
                {
                    Caption = 'Businsess Vertical';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Businsess Vertical field.';

                }
                field("Businsess Type"; Rec."Businsess Type")
                {
                    Caption = 'Businsess Type';
                    ApplicationArea = all;
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
                    Caption = 'Type of Services';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the BD Partner field.';
                }
                field("Sales PersonL"; Rec."Sales PersonL")
                {
                    Caption = 'Client Account Manager';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Client Account Manager field.';
                }


            }
        }
    }
    var
        StyleTxt: Text;
        CreatedAt: Text[80];
        ModifiedAt: Text[80];
        RecUser: Record User;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        if (rec.Status = Rec.Status::Open) then StyleTxt := 'Favorable';
        if (Rec.Status <> Rec.Status::Open) then StyleTxt := 'Strong';
        RecUser.Reset();
        RecUser.SetRange("User Security ID", rec.SystemCreatedBy);
        if RecUser.FindFirst() then CreatedAt := RecUser."Full Name";
        RecUser.Reset();
        RecUser.SetRange("User Security ID", rec.SystemModifiedBy);
        if RecUser.FindFirst() then ModifiedAt := RecUser."Full Name";
    end;
}
