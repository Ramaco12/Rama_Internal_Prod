tableextension 70107 "No.SeriesTab Ext" extends "No. Series"
{
    fields
    {
        field(70100; "Posted Doc. No. Sr"; Code[20])
        {
            Caption = 'Posted Doc. No. Sr';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
    }
}
