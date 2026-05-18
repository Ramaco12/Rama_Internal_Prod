tableextension 70161 "Sales And Recei Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(70161; "Mandate E/L Nos."; Code[20])
        {
            Caption = 'Mandate E/L Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
