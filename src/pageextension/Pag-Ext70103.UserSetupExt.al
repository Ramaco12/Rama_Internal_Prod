pageextension 70103 UserSetupExt extends "User Setup"
{
    layout
    {
        addafter(PhoneNo)
        {
            field("Mandate Type"; Rec."Mandate Type")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Mandate Type field.';
            }
            field("Allow to Delete SP file"; Rec."Allow to Delete SP file")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Allow to Delete SP file field.';
            }
        }
    }
}
