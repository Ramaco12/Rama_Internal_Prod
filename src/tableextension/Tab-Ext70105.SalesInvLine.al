tableextension 70105 SalesInvLine extends "Sales Invoice Line"
{
    fields
    {
        field(70110; "TCS Nature of Collection_"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
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
        field(70105; "TAX Type"; enum "Tax Type")
        {
            Caption = 'TAX Type';
            DataClassification = ToBeClassified;
        }
    }
}
