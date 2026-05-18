codeunit 70105 "Page Mgmt Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', False, false)]
    local procedure OnAfterGetPageID(var RecordRef: RecordRef; var PageID: Integer; ForceListPage: Boolean)
    begin
        if PageID = 0 then
            PageID := GetConditionalCardPageID(RecordRef);
    end;

    local procedure GetConditionalCardPageID(RecordRef: RecordRef): Integer
    begin
        case RecordRef.Number of
            Database::"Mandate Header":
                exit(page::"Mandate E/L Card");
        end;
    end;
}
