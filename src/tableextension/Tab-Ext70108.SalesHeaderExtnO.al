tableextension 70108 "Sales Header Ext nO" extends "Sales Header"
{
    fields
    {
        modify("Posting No. Series")
        {
            trigger OnAfterValidate()
            var
                NoSeries: Record "No. Series";
            begin
                NoSeries.Reset();
                NoSeries.SetRange(Code, Rec."No. Series");
                if NoSeries.FindFirst() then
                    if NoSeries."Posted Doc. No. Sr" <> '' then
                        Rec."Posting No. Series" := NoSeries."Posted Doc. No. Sr";
            end;
        }
    }
}
