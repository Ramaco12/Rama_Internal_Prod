table 70102 MandateType
{
    Caption = 'Mandate Type';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Mandate Type";
    LookupPageId = "Mandate Type";


    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            trigger OnValidate()
            var
                RecUser: Record "User Setup";
            begin
                if not RecUser.Get(UserId) then
                    Error('User Setup not found');

                if not RecUser."Mandate Type" then
                    Error('Permission not granted');
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        RecUser: Record "User Setup";
    begin
        CheckMandatePermission();
    end;

    trigger OnModify()
    var
        RecUser: Record "User Setup";
    begin
        // CheckMandatePermission();
    end;

    trigger OnDelete()
    var
        RecUser: Record "User Setup";
    begin
        CheckMandatePermission();
    end;


    procedure CheckMandatePermission()
    var
        RecUser: Record "User Setup";
    begin
        if not RecUser.Get(UserId) then
            Error('User Setup not found');

        if not RecUser."Mandate Type" then
            Error('Permission not granted');
    end;
}
