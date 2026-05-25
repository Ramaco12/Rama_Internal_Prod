tableextension 70102 SalesHrExt extends "Sales Header"
{
    fields
    {
        field(70103; "Mandate No."; Code[20])
        {
            Caption = 'Mandate No.';
            DataClassification = ToBeClassified;
        }

        field(70112; "Kind Attention"; Text[50]) //PK_18/05/26
        {
            Caption = 'Kind Attention';
            DataClassification = ToBeClassified;
        }
    }
}
