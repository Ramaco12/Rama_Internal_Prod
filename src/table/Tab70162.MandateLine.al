table 70162 "Mandate Line"
{
    Caption = 'Mandate Line';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Mandate Document No."; Code[20])
        {
            Caption = 'Mandate Document No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Item No."; Code[20])
        {
            TableRelation =
                if (Type = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else if (Type = const(Item)) Item where(Blocked = const(false), "Sales Blocked" = const(false));

            trigger OnValidate()
            var
                ITM: Record Item;
                GLAcc: Record "G/L Account";
            begin
                // 1. If Item changed → reset dependent fields FIRST
                if xRec."Item No." <> Rec."Item No." then begin
                    Rec.Description := '';
                    Rec."Description 2" := '';
                    Rec."Unit oF Measure Code" := '';
                    Rec."Invoice Type" := Rec."Invoice Type"::Blank; // safer than Blank
                    Rec."%" := 0;
                    Rec.Amount := 0;
                    Rec."Amount to Assign" := 0;
                    Rec."Amount Assigned" := 0;
                end;

                // 2. If empty → exit
                if "Item No." = '' then
                    exit;

                // 3. Set Description based on Type
                case Type of
                    Type::Item:
                        if ITM.Get("Item No.") then
                            Rec.Description := ITM.Description;

                    Type::"G/L Account":
                        if GLAcc.Get("Item No.") then
                            Rec.Description := GLAcc.Name;
                end;
            end;
        }
        field(4; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Type; Enum "Sales Line Type")
        {

            trigger OnValidate()
            begin
                if xRec.Type <> Type then begin
                    "Item No." := '';
                    Description := '';
                end;
            end;
        }
        field(6; "Description 2"; Text[200])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }

        field(7; "Unit oF Measure Code"; Code[20])
        {
            Caption = 'Unit oF Measure Code';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }

        field(8; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(9; "Amount to Assign"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if rec."Amount to Assign" <> 0 then
                    Rec.TestField(Status, Status::Released);
            end;

        }
        field(10; "Amount Assigned"; Decimal)
        {
            Editable = false;
        }



        field(11; "Invoice Type"; Enum "Mandate Invoice Type")
        {
            Caption = 'Invoice Type';

            trigger OnValidate()
            var
                LineRec: Record "Mandate Line";
            begin
                // Get the FIRST line (smallest Line No.)
                LineRec.Reset();
                LineRec.SetRange("Mandate Document No.", "Mandate Document No.");
                LineRec.SetCurrentKey("Mandate Document No.", "Line No.");

                if LineRec.FindFirst() then
                    if "Line No." <> LineRec."Line No." then
                        if "Invoice Type" <> LineRec."Invoice Type" then
                            Error('Invoice Type must be %1 as per first line.', LineRec."Invoice Type");
            end;


        }
        field(12; "%"; Decimal)
        {
            Caption = '%';

            trigger OnValidate()
            var
                Header: Record "Mandate Header";
            begin

                // Get Header
                if not Header.Get("Mandate Document No.") then
                    Error('Mandate Header not found.');

                if "Invoice Type" = "Invoice Type"::Percentage then begin
                    if "%" > 100 then
                        Error('Percentage cannot be greater than 100.');

                    if "%" < 0 then
                        Error('Percentage cannot be negative.');
                end;

                CalculateAmount();
            end;






        }
        field(13; "Short Close Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            // Editable = false;
            Caption = 'Short Close Amount';
        }
        field(14; "Short Closed"; Boolean)
        {
            Caption = 'Short Closed';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(15; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
            DataClassification = ToBeClassified;
        }
        field(16; "Status"; Enum "Sales Document StatusL")
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Location Code"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Mandate Header"."Location Code" where("No." = field("Mandate Document No.")));
        }
        field(19; "Start Date"; Date)
        {
        }
        field(20; "End Date"; Date)
        {
        }
        field(21; Invoiced; Boolean)
        {
            Editable = false;
        }
        field(22; "Actual Man Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Actual End Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Remaining Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Billing Type"; Enum "Billing Type")
        {
            DataClassification = ToBeClassified;
        }
        field(26; "OPE Type"; enum "OPE Type")
        {
            Caption = 'OPE Type';
            DataClassification = ToBeClassified;
        }
        field(27; "TAX Type"; enum TAXType)
        {
            Caption = 'TAX Type';
            DataClassification = ToBeClassified;
        }
        field(28; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = ToBeClassified;
        }
        field(29; "Not Due"; Boolean)
        {
            Caption = 'Not Due';
            DataClassification = ToBeClassified;
        }
        field(30; "Due Date"; Date)
        {
            Caption = 'Invoice Due Date';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Mandate Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
    end;

    trigger OnInsert()
    var
        RecMH: Record "Mandate Header";
        RecML: Record "Mandate Line";
        TotalAmount: Decimal;
    begin
        if RecMH.Get(Rec."Mandate Document No.") then begin
            RecMH.TestField(Status, RecMH.Status::Open);
            RecML.Reset();
            RecML.SetRange("Mandate Document No.", RecMH."No.");
            if RecML.FindFirst() then
                repeat
                    TotalAmount += RecML.Amount;
                until RecML.Next() = 0;
            if RecMH."Total EL Amt" = TotalAmount then
                Error('New line can not be added because the total amount of line is equal to Total EL amount');

        end;
    end;

    procedure CheckAllLinesAreShortClosed(DocNo: Code[20]): Boolean
    var
        SELine: Record "Mandate Header";
    begin
        SELine.Reset();
        SELine.SetRange("No.", DocNo);
        if SELine.FindSet() then
            repeat
                if (SELine."Short Closed" = false) then
                    exit(false);
            until SELine.Next() = 0;
        exit(true);
    end;

    procedure CalculateAmount()
    var
        Header: Record "Mandate Header";
        LineRec: Record "Mandate Line";
        TotalPercent: Decimal;
        TotalAmount: Decimal;
    begin
        // Get header
        if not Header.Get("Mandate Document No.") then
            Error('Mandate Header not found.');

        // -------------------------
        // NEW: Calculate already used %
        // -------------------------
        TotalPercent := 0;

        LineRec.Reset();
        LineRec.SetRange("Mandate Document No.", "Mandate Document No.");

        if LineRec.FindSet() then
            repeat
                // exclude current line if needed (important for modify case)
                if LineRec."Line No." <> "Line No." then
                    TotalPercent += LineRec."%";
            until LineRec.Next() = 0;

        // NEW: validate total % should not exceed 100
        if ("Invoice Type" = "Invoice Type"::Percentage) then
            if (TotalPercent + "%") > 100 then
                Error(
                    'Total percentage cannot exceed 100. Already used: %1, Remaining: %2',
                    TotalPercent,
                    100 - TotalPercent);

        // -------------------------
        // Calculation logic
        // -------------------------
        if "Invoice Type" = "Invoice Type"::Percentage then begin
            if Header."Total EL Amt" = 0 then
                Error('Total EL Amount cannot be zero.');

            Amount := Round((Header."Total EL Amt" * "%") / 100, 0.01);
        end
        else begin

            if Header."Total EL Amt" = 0 then
                Error('Total EL Amount cannot be zero.');

            // -------------------------
            // FIX: validate using input field NOT Amount
            // -------------------------
            TotalAmount := 0;

            LineRec.Reset();
            LineRec.SetRange("Mandate Document No.", "Mandate Document No.");

            if LineRec.FindSet() then
                repeat
                    if LineRec."Line No." <> "Line No." then
                        TotalAmount += LineRec.Amount;
                until LineRec.Next() = 0;

            // IMPORTANT FIX HERE
            if (TotalAmount + "%") > Header."Total EL Amt" then
                Error(
                    'Total Lumpsum cannot exceed %1. Remaining: %2',
                    Header."Total EL Amt",
                    Header."Total EL Amt" - TotalAmount);

            // assign value
            Amount := "%";
        end;
    end;


    trigger OnDelete()
    begin
        if "Short Closed" then
            Error('You cannot delete this line because it is Short Closed.');
    end;


}
