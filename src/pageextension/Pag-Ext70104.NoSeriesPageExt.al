pageextension 70104 "No. Series PageExt" extends "No. Series"
{
    layout
    {
        addafter(Description)
        {
            field("Posted Doc. No. Sr"; Rec."Posted Doc. No. Sr")
            {
                ToolTip = 'Specifies the value of the Posted Doc. No. Sr field';
                ApplicationArea = All;
            }
        }
    }
}
