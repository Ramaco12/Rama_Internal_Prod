pageextension 70129 PurchInvExt extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("Description 2")
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea=all;
                
            }
        }
    }
}
