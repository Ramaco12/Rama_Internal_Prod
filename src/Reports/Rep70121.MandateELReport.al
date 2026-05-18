report 70121 "Mandate E/L Report"
{
    ApplicationArea = All;
    Caption = 'Mandate E/L Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = '.src\Layout\MandateReport.rdl';
    dataset
    {
        dataitem(MandateHeader; "Mandate Header")
        {
            RequestFilterFields = "No.", "Customer No.", "Businsess Type", "Businsess Vertical", "Type of vertical", "BD Partner";
            column(No; "No.")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column("ELDescription"; Description)
            {

            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(MandateType; "Mandate Type")
            {
            }
            column(StartDate; "Start Date")
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(ELDate; "E/L Date")
            {
            }
            column(Status; Status)
            {
            }
            column(TotalManDays; "Total Man Days")
            {
            }
            column(TotalELAmt; "Total EL Amt")
            {
            }
            column(BusinsessVertical; "Businsess Vertical")
            {
            }
            column(BusinsessType; "Businsess Type")
            {
            }
            column(Typeofvertical; "Type of vertical")
            {
            }
            column(BD_Partner; "BD Partner")
            {

            }
            column(SalesPersonL; "Sales PersonL")
            {
            }

            column(Start_Date_; FromDate) { }
            column(End_Date_; ToDate) { }
            column(PrintBool; PrintBool) { }
            column(OPE_Type_; "OPE Type") { }
            column(Billing_Type_; "Billing Type") { }
            column(TAX_Type_; "TAX Type") { }


            dataitem("Mandate Line"; "Mandate Line")
            {
                DataItemLinkReference = MandateHeader;
                DataItemLink = "Mandate Document No." = field("No.");

                column(Mandate_Document_No_; "Mandate Document No.") { }
                column(Type; Type) { }
                column(Item_No_; "Item No.") { }
                column(Description; Description) { }
                column(Description_2; "Description 2") { }
                column(Quantity; Quantity) { }
                column(Unit_oF_Measure_Code; "Unit oF Measure Code") { }
                column(Invoice_Type; "Invoice Type") { }
                column(Unit_Cost; "Unit Cost") { }
                column(Percentage; "%") { }

                column(Amount; Amount) { }
                column(Amount_to_Assign; "Amount to Assign") { }
                column(Amount_Assigned; "Amount Assigned") { }
                column(Remaining_Amount; "Remaining Amount") { }
                column(Short_Close_Qty_; "Short Close Qty.") { }
                column(Short_Closed; "Short Closed") { }
                column(Reason_Code; "Reason Code") { }
                column(Status_; Status) { }
                column(Location_Code; "Location Code") { }
                column(Start_Date; "Start Date") { }
                column(End_Date; "End Date") { }
                column(Actual_End_Date; "Actual End Date") { }
                column(Actual_Man_Days; "Actual Man Days") { }
                column(Billing_Type; "Billing Type") { }
                column(OPE_Type; "OPE Type") { }
                column(TAX_Type; "TAX Type") { }
                column(Not_Due; "Not Due") { }
                column(Due_Date; "Due Date") { }
                column(ELDes; ELDes) { }
                column(DocumentDate_; DocumentDate) { }

                column(CustNo; CustNo) { }
                column(CustName; CustName) { }


                trigger OnAfterGetRecord()
                begin
                    RecMH.Reset();
                    RecMH.SetRange("No.", "Mandate Line"."Mandate Document No.");
                    if RecMH.Findfirst() then
                        ELDes := RecMH.Description;
                    DocumentDate := RecMH."Document Date";
                    CustNo := RecMH."Customer No.";
                    CustName := RecMH."Customer Name";

                end;


            }

            trigger OnPreDataItem()
            begin
                if (FromDate <> 0D) and (ToDate <> 0D) then
                    SetRange("Start Date", FromDate, ToDate);
            end;
        }
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Date Filter")
                {
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the value of the Start Date field.';


                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the value of the End Date field.';

                    }
                    field(PrintBool; PrintBool)
                    {
                        ApplicationArea = All;
                        Caption = 'Detailed';
                    }
                }


            }




        }



    }

    trigger OnPreReport()
    begin
        if FromDate = 0D then
            Error('Start Date must be entered');

        if ToDate = 0D then
            Error('End Date must be entered');
    end;

    var
        FromDate: Date;
        ToDate: Date;
        PrintBool: Boolean;
        ELDes: text[100];
        DocumentDate: date;
        CustNo: Code[20];
        CustName: Text[100];
        RecMH: Record "Mandate Header";
}
