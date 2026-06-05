table 70101 "Mandate Header"
{
    Caption = 'Mandate Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(70100; "Mandate Type"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Mandate Type';
            TableRelation = MandateType.Code;


        }
        field(70101; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70102; "Description"; text[100])
        {
            Caption = 'Mandate/EL Description';
            DataClassification = ToBeClassified;
        }
        field(50102; "E/L Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(70103; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(70106; "Shipment Mode_SE"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Mode";
        }
        field(70107; "Shipment Term_SE"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Term";
        }
        field(70108; "Collect/prepaid_SE"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Collect/Prepaid";
        }
        field(70109; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = Customer."No." where(StatusL = const(Approved));
            TableRelation = Customer."No." where(Blocked = const(" "));

            trigger OnValidate()
            var
                RecCust: Record Customer;
                RecML: Record "Mandate Line";
            begin
                Rec.TestField(Status, Status::Open);
                if Rec."Customer No." <> xRec."Customer No." then begin
                    RecCust.Reset();
                    RecCust.SetRange("No.", Rec."Customer No.");
                    if RecCust.FindFirst() then begin
                        "Customer Name" := RecCust.Name;
                        "Customer Address" := RecCust.Address;
                        City := RecCust.City;
                        Country := RecCust."Country/Region Code";
                        Validate("Currency Code", RecCust."Currency Code");
                        "E/L Date" := WorkDate();
                        Modify();
                    end;

                    RecML.Reset();
                    RecML.SetRange("Mandate Document No.", Rec."No.");
                    if RecML.FindSet() then
                        RecML.DeleteAll(true);
                end;



            end;
        }
        field(70110; "Received Through"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Received Through";
        }
        field(70113; "PR Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(70114; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50115; "Customer Address"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70116; "City"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(70117; "Country"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(70118; Status; enum "Sales Document StatusL")
        {
            DataClassification = ToBeClassified;
        }
        field(70119; "Businsess Vertical"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Businsess Vertical';
            // TableRelation = Dimension.Code where(Code = const('BUSINESS VERTICAL'));
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BUSINESS VERTICAL'));
        }
        field(70120; "Businsess Type"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Businsess Type';
            //  TableRelation = "Dimension".Code where("Code" = const('BUSINESS TYPE'));
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BUSINESS TYPE'));
        }
        field(70121; "Sales PersonL"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Person';
            TableRelation = "Salesperson/Purchaser";
        }
        field(70122; "Costing Sheet No. Ref"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70123; "Costing Sheet Y/N"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Costing Sheet Y/N ';
        }
        field(70124; "Short Closed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70125; "User Id"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70126; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        // field(23; "Login User ID"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        // }
        field(70127; "Item Description"; Text[200])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Mandate Line".Description where("Mandate Document No." = field("No.")));
        }
        // field(70128; "Purchase Person"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Dimension Value".Code where("Dimension Code" = filter(= 'PURCHASE PERSON'));
        // }
        field(70129; "Total EL Amt"; Decimal) { }
        field(70130; "Location Code"; Code[20])
        {
            TableRelation = Location;



        }
        field(70131; "Start Date"; Date)
        {


        }
        field(70132; "End Date"; Date)
        {


        }
        field(70133; "Sales Invoice List"; Integer)
        {
            Caption = 'Sales Invoice List';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Mandate No." = field("No.")));


        }

        field(70134; "Posted Sales Invoice List"; Integer)
        {
            Caption = 'Posted Sales Invoice List';
            FieldClass = FlowField;
            CalcFormula = count("Sales Invoice Header" where("Mandate No" = field("No.")));



        }
        field(70135; "Type of vertical"; Text[50])
        {
            Caption = 'Type of Services';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('TYPE OF SERVICES'));
        }
        field(70136; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;

        }
        field(70137; "Total Man Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(70138; "Billing Type"; Enum "Billing Type")
        {
            DataClassification = ToBeClassified;
        }
        field(70139; "No. of Months"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(70140; "G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        // field(70141; "Accounts Manager"; Text[50])
        // {
        //     Caption = 'Client Account Manager';
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Dimension Value".Code where("Dimension Code" = const('ACCOUNT MANAGER'));
        // }
        field(70142; "BD Partner"; Text[50])
        {
            Caption = 'BD Partner';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BD PARTNER'));
        }
        field(70143; "OPE Type"; enum "OPE Type")
        {
            Caption = 'OPE Type';
            DataClassification = ToBeClassified;
        }
        field(70144; "TAX Type"; enum TAXType)
        {
            Caption = 'TAX Type';
            DataClassification = ToBeClassified;
        }
        field(70145; "EL Ref No."; Code[50])
        {
            Caption = 'E/L Reference No.';
            DataClassification = ToBeClassified;
        }
        field(70146; "Comment"; Text[500])//tejasvi 22 may 2026
        {
            DataClassification = ToBeClassified;
        }
        field(70147; "Committed Business"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Document Date" := WorkDate();
        SalesSetup.Get();
        if "No." = '' then begin
            SalesSetup.TestField("Mandate E/L Nos.");
            // NoSeriesMgt.InitSeries(SalesSetup."Sales Enquiry Nos.", xRec."No. Series", 0D, Rec."Enquiry No.", "No. Series");
            "No. Series" := SalesSetup."Mandate E/L Nos.";
            "No." := NoSeriesMgt.GetNextNo("No. Series", WorkDate(), true);
        end;
        "User Id" := UserId;
        //"Login User ID" := Database.UserId;
    end;

    procedure CalculateCommittedBusiness()
    var
        MandateLine: Record "Mandate Line";
        NotToAmount: Decimal;
    begin
        NotToAmount := 0;

        MandateLine.Reset();
        MandateLine.SetRange("Mandate Document No.", Rec."No.");
        MandateLine.SetRange("Not Due", true);

        if MandateLine.FindSet() then
            repeat
                NotToAmount += MandateLine.Amount;
            until MandateLine.Next() = 0;

        Rec."Committed Business" := Rec."Total EL Amt" - NotToAmount;
    end;
}
