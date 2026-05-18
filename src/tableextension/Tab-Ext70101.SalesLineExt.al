tableextension 70101 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(70100; "Invoice Type_"; Enum "Invoice Type Sales Enum")
        {
            DataClassification = ToBeClassified;
        }
        field(70101; "%"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70102; "Mandate No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70103; "Billing Type"; Enum "Billing Type")
        {
            DataClassification = ToBeClassified;
        }
        field(70104; "OPE Type"; enum "OPE Type")
        {
            Caption = 'OPE Type';
            DataClassification = ToBeClassified;
        }
        field(70105; "TAX Type"; enum TAXType)
        {
            Caption = 'TAX Type';
            DataClassification = ToBeClassified;
        }
    }
}
