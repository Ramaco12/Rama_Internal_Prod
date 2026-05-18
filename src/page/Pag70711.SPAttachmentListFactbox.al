page 70711 "SP. Attachment List Factbox"
{
    Caption = 'SharePoint Documents';
    PageType = ListPart;
    DeleteAllowed = false;
    DelayedInsert = true;
    InsertAllowed = false;
    SourceTable = "SharePoint Attachment";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec."File Name")
                {
                    Caption = 'Name';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the attached file.';
                    Width = 30;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(Rec."Web Url");
                    end;
                }
                field("SharePoint Url"; Rec."SharePoint Url")
                {
                    Caption = 'SharePoint Url';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the attached file.';
                    Width = 30;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(Rec."SharePoint Url");
                    end;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the file extension of the attachment.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenInDetail)
            {
                ApplicationArea = Basic, Suite;
                Image = ViewDetails;
                Caption = 'Show details';
                ToolTip = 'Open the document in detail.';

                trigger OnAction()
                var
                    ZYSharePointAttachment: Record "SharePoint Attachment";
                begin
                    ZYSharePointAttachment.Reset();
                    ZYSharePointAttachment.SetRange("Table ID", Rec."Table ID");
                    ZYSharePointAttachment.SetRange("No.", Rec."No.");
                    Page.Run(Page::"SP Document Attachment Details", ZYSharePointAttachment);
                end;
            }
            action(Upload) //Commented PK_04/11/25 As multiple files not supported
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Upload';
                ToolTip = 'Upload a document to SharePoint.';
                trigger OnAction()
                var
                    InS: InStream;
                    FileMgt: Codeunit "File Management";
                    FileName: Text[250];
                    UploadFileMsg: Label 'Please select the file to upload';
                    SharePointHandler: Codeunit SharePointHandler;
                begin
                    UploadIntoStream(UploadFileMsg, '', '', FileName, InS);
                    SharePointHandler.UploadFilesToSharePoint(Rec, FileName, FileMgt.GetFileNameMimeType(FileName), InS);
                end;
            }

            /* action(Upload)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Upload';
                ToolTip = 'Executes the Upload action.';

                trigger OnAction()
                var
                    InS: InStream;
                    FileName: Text[250];
                    DocAttach: Record "Document Attachment";
                begin
                    if not UploadIntoStream('Select file', '', '', FileName, InS) then
                        exit;

                    DocAttach.Init();

                    // 🔴 IMPORTANT: replace correctly
                    DocAttach."Table ID" := Database::"Mandate Header"; // or your table
                    DocAttach."No." := Rec."No."; // MUST match your key field

                    DocAttach."File Name" := FileName;

                    // ✅ correct Media storage
                    DocAttach."Document Reference ID".ImportStream(InS, FileName);

                    DocAttach.Insert(true);

                    Message('Inserted: %1', FileName);
                end;
            } */
            fileuploadaction(UploadMultiple) //PK_04/11/25 As multiple files supported at a time.
            {
                ApplicationArea = All;
                Caption = 'Upload Multiple';
                Image = Import;
                ToolTip = 'Upload one or more documents to SharePoint.';
                AllowMultipleFiles = true;

                trigger OnAction(Files: List of [FileUpload])
                var
                    CurrentFile: FileUpload;
                    InS: InStream;
                    FileMgt: Codeunit "File Management";
                    SharePointHandler: Codeunit SharePointHandler;
                begin
                    foreach CurrentFile in Files do begin
                        // Get the file stream
                        CurrentFile.CreateInStream(InS);

                        // Pass each file to your SharePoint upload handler
                        SharePointHandler.UploadFilesToSharePoint(Rec, CurrentFile.FileName, FileMgt.GetFileNameMimeType(CurrentFile.FileName), InS);
                    end;
                end;
            }

            action(Delete)
            {
                ApplicationArea = All;
                Image = Delete;
                Caption = 'Delete';
                ToolTip = 'Delete a document in SharePoint.';
                trigger OnAction()
                var
                    SharePointHandler: Codeunit SharePointHandler;
                    UserSetup: Record "User Setup";
                begin
                    UserSetup.Reset();
                    UserSetup.SetRange("User ID", UserId);
                    if UserSetup.FindFirst() then begin
                        if UserSetup."Allow to Delete SP file" = true then
                            SharePointHandler.DeleteFileInSharePoint(Rec)
                        else
                            Error('You are not authorized to delete this file. Please contact your administrator.');
                    end;
                end;
            }
        }
    }
}