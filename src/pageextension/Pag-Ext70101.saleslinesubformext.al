pageextension 70101 saleslinesubformext extends "Sales invoice Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Invoice Type"; Rec."Invoice Type_")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Invoice Type_ field.';
                Visible = false;
            }
            field("%"; Rec."%")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the % field.';
                Visible = false;
            }
            field("Mandate No"; Rec."Mandate No")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Mandate No field.';
            }
            field("Billing Type"; Rec."Billing Type")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Billing Type field.';
            }
            field("OPE Type"; Rec."OPE Type")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the OPE Type field.';
            }
            field("TAX Type"; Rec."TAX Type")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the TAX Type field.';
            }
        }
    }
}
