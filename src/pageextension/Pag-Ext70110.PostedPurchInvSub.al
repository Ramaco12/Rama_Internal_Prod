pageextension 70110 PostedPurchInvSub extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter("Description 2")
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
            }
        }
    }
}
