tableextension 70170 "User Setup" extends "User Setup"
{
    fields
    {
        field(50200; "Mandate Released"; Boolean)
        {
            Caption = 'SE Released';
            DataClassification = ToBeClassified;
        }
        field(50201; "Mandate Type"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50202; "Allow to Delete SP file"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Allow to Delete SP file';
            ToolTip = 'Specifies whether the user is allowed to delete files uploaded to SharePoint from Business Central.';
        }
    }
}
