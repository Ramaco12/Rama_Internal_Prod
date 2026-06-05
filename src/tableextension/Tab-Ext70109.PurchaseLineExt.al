tableextension 70109 PurchaseLineExt extends "Purchase Line"
{
    fields
    {
        field(70100; "Narration"; Text[200])
        {
            Caption = 'Narration';
            DataClassification = ToBeClassified;
        }
    }
}
