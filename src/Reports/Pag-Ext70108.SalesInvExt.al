pageextension 70108 SalesInvExt extends "Sales Invoice"
{

    layout
    {
        addafter("Your Reference")
        {
            field("Kind Attention"; Rec."Kind Attention")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter(ProformaInvoice)
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
                        REPORT.RUNMODAL(70123, TRUE, FALSE, SalesHdr);
                end;
            }
        }
    }
    var

        RecSalesHdr: Record "Sales Header";
}

