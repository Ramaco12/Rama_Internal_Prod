tableextension 70121 "Purch Inv Hdr Exten" extends "Purch. Inv. Header"
{
    fields
    {
        field(70121; "Vendor Invoice Date_L"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Invoice Date';
        }
         field(70122; "E-Way Bill No.L"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Way Bill No.';
        }
        field(70123; "E-Way Bill DateL"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Way Bill Date';
        }
       
    }
}