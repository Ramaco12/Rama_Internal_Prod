pageextension 70102 postedsalesinvext extends "Posted Sales Invoice"
{
    layout
    {

        addafter("Posting Date")
        {
            field("Mandate No"; Rec."Mandate No")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Mandate No field.';
            }
        }
    }
}
