pageextension 70108 SalesInvExt extends "Sales Invoice"
{

    layout
    {

    }
    actions
    {
        addafter(Dimensions)
        {

            action("Proforma Invoice")
            {
                ApplicationArea = all;
                Image = Report;
                Caption = 'Proforma Invoice';
                Promoted = true;
                PromotedCategory = New;
                //Promoted = true;
                // PromotedCategory = Category11;
                trigger OnAction()
                var
                    IsHandled: Boolean;
                    ProformaReport: Report "Proforma Invoice";
                begin
                    ProformaReport.SetSalesHeader(Rec);
                    ProformaReport.RunModal();
                end;
            }

        }
    }
    var

        RecSalesHdr: Record "Sales Header";
}

