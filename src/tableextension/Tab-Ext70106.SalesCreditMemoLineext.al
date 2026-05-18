tableextension 70106 SalesCreditMemoLineext extends "Sales Cr.Memo Line"
{
    fields
    {
        field(70109; "TCS Nature of Collection_"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
    }
}
