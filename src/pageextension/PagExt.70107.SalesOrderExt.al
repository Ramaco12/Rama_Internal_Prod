pageextension 70107 SalesOrdExxt extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Print")
        {
            action("Proforma Invoice")
            {
                Caption = 'Proforma Invoice';
                ApplicationArea = all;
                Image = "Report";
                Promoted = true;
                PromotedCategory = Report;
                // Visible = ShowInvoiceIN;

                trigger OnAction()
                var
                    SalesHdr: Record "Sales Header";
                begin
                    SalesHdr.RESET;
                    SalesHdr.SETRANGE("No.", Rec."No.");
                    IF SalesHdr.FINDFIRST THEN
                        // REPORT.RUNMODAL(52101, TRUE, FALSE, SalesHdr);
                          REPORT.RUNMODAL(70123, TRUE, FALSE, SalesHdr);
                end;
            }
        }
    }

    var
        myInt: Integer;
}