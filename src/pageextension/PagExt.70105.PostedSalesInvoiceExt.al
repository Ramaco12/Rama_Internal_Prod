pageextension 70105 PostedSalesInvex extends "Posted Sales Invoice"
{
    actions
    {
        // modify("GST Sales Tax Invoice")
        // {
        //     Visible = false;
        // }
        addafter(Print)
        {
            action("Sales Tax Invoice_New")
            {
                Caption = 'Sales Tax Invoice';
                ApplicationArea = all;
                Image = "Report";
                Promoted = true;
                PromotedCategory = Report;
                // Visible = ShowInvoiceIN;

                trigger OnAction()
                var
                    SalesInvHdr: Record "Sales Invoice Header";
                    // EANReport: Report 65413;
                    SalesTaxInv: Report 70122;
                begin
                    SalesInvHdr.Reset();
                    SalesInvHdr.SetRange("No.", Rec."No.");
                    if SalesInvHdr.FindFirst() then begin
                        SalesTaxInv.SetFromAction(true);   // pass flag
                        SalesTaxInv.SetTableView(SalesInvHdr);
                        SalesTaxInv.RunModal();
                    end;
                end;

                // trigger OnAction()
                // var
                //     salesinvHrd: Record "Sales Invoice Header";
                // begin
                //     salesinvHrd.RESET;
                //     salesinvHrd.SETRANGE("No.", Rec."No.");
                //     IF salesinvHrd.FINDFIRST THEN
                //         REPORT.RUNMODAL(65413, TRUE, FALSE, salesinvHrd);
                // end;//tejasvi comment 6 march 26 added new action
            }
        }

        modify("E-Invoice")
        {
            Caption='e';
        }
    }
}