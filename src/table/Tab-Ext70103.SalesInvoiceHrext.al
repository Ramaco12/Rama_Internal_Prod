tableextension 70103 SalesInvoiceHrext extends "Sales Invoice Header"
{
    fields
    {
        field(70100; "Mandate No"; Code[20])
        {
            Caption = 'Mandate No';
            DataClassification = ToBeClassified;
        }
    }
}
