page 70712 "SP Document Attachment Details"
{
    Caption = 'SharePoint Attached Documents';
    DelayedInsert = true;
    Editable = true;
    PageType = List;
    SourceTable = "SharePoint Attachment";
    SourceTableView = sorting(ID, "Table ID");
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec."File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the filename of the attachment.';

                   
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the file extension of the attachment.';
                }
                field("Mime Type"; Rec."Mime Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the MIME type of the attachment.';
                }
                field("Web Url"; Rec."Web Url")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the URL of the attachment in SharePoint.';
                }
                field("SharePoint File ID"; Rec."SharePoint File ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the ID of the attachment in SharePoint.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the user who attached the document.';
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the date when the document was attached.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Upload)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Upload';
                ToolTip = 'Upload a document to SharePoint.';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    InS: InStream;
                    FileMgt: Codeunit "File Management";
                    FileName: Text[250];
                    UploadFileMsg: Label 'Please select the file to upload';
                    //SharePointHandler: Codeunit SharePointHandler;
                begin
                    if UploadIntoStream(UploadFileMsg, '', '', FileName, InS) then begin
                        //SharePointHandler.UploadFilesToSharePoint(Rec, FileName, FileMgt.GetFileNameMimeType(FileName), InS);
                    end;
                end;
            }

            
            // action(Check)
            // {
            //     ApplicationArea = All;
            //     Image = CheckList;
            //     Caption = 'Check';
            //     ToolTip = 'Check the document in SharePoint.';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     trigger OnAction()
            //     var
            //         SharePointHandler: Codeunit SharePointHandler;
            //     begin
            //         SharePointHandler.CheckFileInSharePoint(Rec);
            //     end;
            // }
        }
    }
}