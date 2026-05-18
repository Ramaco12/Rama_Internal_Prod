pageextension 70161 "Sales & Recei Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Posted Shipment Nos.")
        {
            field("Mandate E/L Nos."; rec."Mandate E/L Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Mandate E/L Nos. field.';
            }
        }
    }
}
