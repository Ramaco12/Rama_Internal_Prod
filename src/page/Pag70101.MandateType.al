page 70101 "Mandate Type"
{
    ApplicationArea = All;
    Caption = 'Mandate Type';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = MandateType;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }


}
