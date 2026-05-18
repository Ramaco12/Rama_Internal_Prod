page 70701 "SharePoint Attachment API"
{
    APIGroup = 'PK';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'sharePointAttachmentAPI';
    DelayedInsert = true;
    EntityName = 'sharePointAttachmentAPI';
    EntitySetName = 'sharePointAttachmentAPI';
    PageType = API;
    SourceTable = "SharePoint Attachment";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(attachedBy; Rec."Attached By")
                {
                    Caption = 'Attached By';
                }
                field(attachedDate; Rec."Attached Date")
                {
                    Caption = 'Attached Date';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(fileExtension; Rec."File Extension")
                {
                    Caption = 'File Extension';
                }
                field(fileName; Rec."File Name")
                {
                    Caption = 'Attachment';
                }
                field(id; Rec.ID)
                {
                    Caption = 'ID';
                }
                field(journalBatchName; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name';
                }
                field(journalTemplateName; Rec."Journal Template Name")
                {
                    Caption = 'Journal Template Name';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(mimeType; Rec."Mime Type")
                {
                    Caption = 'Mime Type';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(sharePointFileID; Rec."SharePoint File ID")
                {
                    Caption = 'SharePoint File ID';
                }
                field(sharePointUrl; Rec."SharePoint Url")
                {
                    Caption = 'SharePoint URL';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
                field(tableID; Rec."Table ID")
                {
                    Caption = 'Table ID';
                }
                field(user; Rec.User)
                {
                    Caption = 'User';
                }
                field(webUrl; Rec."Web Url")
                {
                    Caption = 'Web URL';
                }
            }
        }
    }
}
