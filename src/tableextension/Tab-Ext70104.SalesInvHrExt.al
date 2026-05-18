tableextension 70104 SalesInvHrExt extends "Sales Invoice Header"
{
    fields
    {
        field(70104; "E-Way Bill Date_L"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Way Bill Date';
        }
        field(70105; "SI_BL No."; Code[20])
        {
            Caption = 'BL No.';
            DataClassification = ToBeClassified;
        }
        field(70106; "SI_BL Date"; Date)
        {
            Caption = 'BL Date';
            DataClassification = ToBeClassified;
        }

        field(70108; "E-Invoice No._L"; Code[64])
        {
            DataClassification = ToBeClassified;
        }
        field(70109; "E-Invoice Date_L"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(70110; "Export Invoice Type"; Enum "Export Invoice Type")
        {
            DataClassification = ToBeClassified;
        }
        field(70111; SI_POL; Text[20])
        {
            Caption = 'POL';
            DataClassification = ToBeClassified;
        }

    }
}
