table 70104 "PortL"
{
    Caption = 'Port ';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Port Code"; Code[30])
        {
            Caption = 'Port Code';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RecPort: Record PortL;
            begin
                "Port Name" := "Port Code";
            end;
        }
        field(2; "Port Name"; Text[100])
        {
            Caption = 'Port Name';
            DataClassification = ToBeClassified;
        }
        field(3; Country; Text[50])
        {
            Caption = 'Country';
            DataClassification = ToBeClassified;
        }
        field(4; CityL; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".City;
            trigger OnValidate()
            var
                RecCity: Record "Post Code";
                RecCounReg: Record "Country/Region";
                CounReg: Code[20];
            begin
                RecCity.Reset();
                RecCity.SetRange(City, rec.CityL);
                if RecCity.FindFirst() then begin
                    Country := RecCity."Country/Region Code";
                    if RecCounReg.Get(Country) then
                        Country := RecCounReg.Name;
                end;
            end;
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = ToBeClassified;
        }
        field(8; "Type"; Enum "Port Type")
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(9; "Port No. Series"; Code[20])
        {
            Caption = 'Port No. Series';
            DataClassification = ToBeClassified;
        }
        //New Field Added AMOL
        field(15; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(16; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF (Country = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD(Country));
            // TableRelation = IF (Country = CONST('')) "Post Code"
            // ELSE
            // IF (Country = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD(Country));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(92; "State"; Code[20])
        {
            Caption = 'State';
            TableRelation = State.Code;
        }
        // New Field End

    }
    keys
    {
        key(PK; "Port Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Port Code", "Port Name", CityL, Country)
        {

        }
    }
    trigger OnInsert()
    var
        myInt: Integer;
    begin

    end;

    //NEW ADDED 
    var
        PostCode: Record "Post Code";

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupPostCode(var Port: Record PortL; var PostCodeRec: Record "Post Code")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLookupPostCode(var Port: Record PortL; var PostCodeRec: Record "Post Code")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidatePostCode(var Port: Record PortL; var PostCodeRec: Record "Post Code"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidatePostCode(var Port: Record PortL; xCustomer: Record Customer)
    begin
    end;
}
