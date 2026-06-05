codeunit 70121 Events
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterInsertInvoiceHeader, '', false, false)]
    local procedure "Sales-Post_OnAfterInsertInvoiceHeader"(var SalesHeader: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header")
    begin
        SalesInvHeader."Mandate No" := SalesHeader."Mandate No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterOnInsert', '', False, false)]
    local procedure OnAfterInitNoSeries(var SalesHeader: Record "Sales Header")
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.Reset();
        NoSeries.SetRange(Code, SalesHeader."No. Series");
        if NoSeries.FindFirst() then
            SalesHeader."Posting No. Series" := NoSeries."Posted Doc. No. Sr";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Document Date', False, false)]
    local procedure OnAfterModifyEvent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        NoSeries: Record "No. Series";
    begin
        // NoSeriesLines.Reset();
        // NoSeriesLines.SetRange("Last No. Used", Rec."No.");
        // if NoSeriesLines.FindFirst() then begin
        NoSeries.Reset();
        NoSeries.SetRange(Code, Rec."No. Series");
        if NoSeries.FindFirst() then
            if NoSeries."Posted Doc. No. Sr" <> '' then begin
                Rec."Posting No. Series" := NoSeries."Posted Doc. No. Sr";
                Rec.Modify();
            end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', False, false)]
    local procedure OnAfterModifyEventSellToCustomerNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.Reset();
        NoSeries.SetRange(Code, Rec."No. Series");
        if NoSeries.FindFirst() then
            if NoSeries."Posted Doc. No. Sr" <> '' then begin
                Rec."Posting No. Series" := NoSeries."Posted Doc. No. Sr";
                Rec.Modify();
            end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterRenameEvent', '', False, false)]
    local procedure OnAfterRenameEvent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.Reset();
        NoSeries.SetRange(Code, Rec."No. Series");
        if NoSeries.FindFirst() then
            if NoSeries."Posted Doc. No. Sr" <> '' then
                Rec."Posting No. Series" := NoSeries."Posted Doc. No. Sr";
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterGetPostingNoSeriesCode', '', False, false)]
    local procedure OnAfterTestNoSeries(SalesHeader: Record "Sales Header"; var PostingNos: Code[20])
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.Reset();
        NoSeries.SetRange(Code, SalesHeader."No. Series");
        if NoSeries.FindFirst() then
            if NoSeries."Posted Doc. No. Sr" <> '' then
                PostingNos := NoSeries."Posted Doc. No. Sr";
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnBeforeGetPostingNoSeriesCode', '', False, false)]

    local procedure OnBeforeGetPostingNoSeriesCode(var SalesHeader: Record "Sales Header"; SalesSetup: Record "Sales & Receivables Setup"; var NoSeriesCode: Code[20]; var IsHandled: Boolean)
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.Reset();
        NoSeries.SetRange(Code, SalesHeader."No. Series");
        if NoSeries.FindFirst() then
            if NoSeries."Posted Doc. No. Sr" <> '' then
                NoSeriesCode := NoSeries."Posted Doc. No. Sr";
        if NoSeriesCode <> '' then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPurchInvLineInsert, '', false, false)]
    local procedure "Purch.-Post_OnAfterPurchInvLineInsert"(var PurchInvLine: Record "Purch. Inv. Line"; PurchInvHeader: Record "Purch. Inv. Header"; PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchHeader: Record "Purchase Header"; PurchRcptHeader: Record "Purch. Rcpt. Header"; TempWhseRcptHeader: Record "Warehouse Receipt Header"; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    begin
        PurchInvLine.Narration := PurchLine.Narration;

    end;


}



