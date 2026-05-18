codeunit 70711 SharePointHandler
{
    procedure UploadFilesToSharePoint(var ZYSharePointAttachment: Record "SharePoint Attachment"; FileName: Text[250]; MimeType: Text; FileContent: InStream)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        JsonResponse: JsonObject;
        AuthToken: SecretText;
        SharePointFileUrl: Text;
        ResponseText: Text;
        FileMgt: Codeunit "File Management";
        JsonToken: JsonToken;
        ZYSharePointAttachment2: Record "SharePoint Attachment";
        ContainsSameFile: Label 'The file %1 already exists in the customer.';
        CompanyName: Text;
        FileUrl: Text;
        FolderUrl: Text;
        DocumentNo: Text;
    begin
        CompanyName := CompanyName();
        DocumentNo := Format(ZYSharePointAttachment."No.");
        DocumentNo := DocumentNo.replace('/', '-');

        //PK_16/04/26 ++ //Handle TempSalesQuote
        if FileName = 'TempSalesQuote.pdf' then begin
            DocumentNo := 'TempSalesQuote/' + DocumentNo;
        end;
        //PK_16/04/26 --

        // Check if there is a file with the same name in the customer, if it exists, an error message will be displayed
        ZYSharePointAttachment2.Reset();
        ZYSharePointAttachment2.SetRange("Table ID", ZYSharePointAttachment."Table ID");
        ZYSharePointAttachment2.SetRange("No.", ZYSharePointAttachment."No.");
        ZYSharePointAttachment2.SetRange("File Name", FileName);
        if ZYSharePointAttachment2.FindFirst() then
            Error(ContainsSameFile, FileName);

        // Get OAuth token
        AuthToken := GetOAuthToken();

        if AuthToken.IsEmpty() then
            Error('Failed to obtain access token.');

        // Define the SharePoint folder URL

        // application permissions (replace with the actual site-id, drive-id, folder path and file name)
        //  SharePointFileUrl := 'https://graph.microsoft.com/v1.0/sites/8199b3fb-1862-43a7-b9df-506801143348/drives/b!7Hw7W_7Lk0imOMGKNMajlK0n-8Wdev9FmPdhx03j5o95rz4xvtmtTIUW5qUH7Jww/root:/Business Central/' + FileName + ':/content';
        //SharePointFileUrl := 'https://graph.microsoft.com/v1.0/sites/c1a888b7-fb72-4c83-8d5e-c623d87f0fe2/drives/b!t4iowXL7g0yNXsYj2H8P4grELCHdxiFIt5bA-eEsMvkyE5gewlA-R6cEOj0oNMcj/root:/' + CompanyName + '/' + DocumentNo + '_' + FileName + ':/content';
        SharePointFileUrl := 'https://graph.microsoft.com/v1.0/sites/1d013aaa-3d34-4954-9b5b-1943a1458173/drives/b!qjoBHTQ9VEmbWxlDoUWBc8-V-TYaSfZEqG_SXc8bwYzaDkDJcdiJRbFE5z2QwGh-/root:/' + CompanyName + '/' + DocumentNo + '_' + FileName + ':/content';


        // Initialize the HTTP request
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.Method := 'PUT';
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', AuthToken));
        RequestContent.GetHeaders(ContentHeader);
        ContentHeader.Clear();

        //PK_13/10/25 Handle Text files++
        if MimeType = '' then
            MimeType := 'text/plain';
        //PK_13/10/25 --
        ContentHeader.Add('Content-Type', MimeType);
        HttpRequestMessage.Content.WriteFrom(FileContent);

        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging
            //Message('HTTP Status Code: %1', HttpResponseMessage.HttpStatusCode());

            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                // Message(ResponseText); //Test
                JsonResponse.ReadFrom(ResponseText);
                ZYSharePointAttachment.Init();

                JsonResponse.Get('name', JsonToken);
                ZYSharePointAttachment."File Name" := JsonToken.AsValue().AsText();

                JsonResponse.Get('id', JsonToken);
                ZYSharePointAttachment."SharePoint File ID" := JsonToken.AsValue().AsText();

                JsonResponse.Get('webUrl', JsonToken);
                ZYSharePointAttachment."Web Url" := JsonToken.AsValue().AsText();
                //Commented As folder URL not required PK_06/10/25
                /* FileUrl := JsonToken.AsValue().AsText();
                FolderUrl := GetFolderUrl(FileUrl);
                //Message('Folder URL: %1', FolderUrl);
                ZYSharePointAttachment."SharePoint Url" := FolderUrl; */
                ZYSharePointAttachment."SharePoint Url" := JsonToken.AsValue().AsText();

                ZYSharePointAttachment."File Extension" := FileMgt.GetExtension(FileName);
                ZYSharePointAttachment."Mime Type" := MimeType;
                ZYSharePointAttachment.ID := ZYSharePointAttachment.GetLastID() + 1;
                ZYSharePointAttachment."Line No." := ZYSharePointAttachment."Line No.";
                ZYSharePointAttachment.Insert(true);


            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('Failed to upload files to SharePoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to SharePoint');
    end;

    procedure UpdateFileInSharePoint(var ZYSharePointAttachment: Record "SharePoint Attachment")
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        AuthToken: SecretText;
        SharePointFileUrl: Text;
        ResponseText: Text;
        JsonRaw: JsonObject;
        JsonRawText: Text;
        ZYSharePointAttachment2: Record "SharePoint Attachment";
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
    begin
        // Get OAuth token
        AuthToken := GetOAuthToken();

        if AuthToken.IsEmpty() then
            Error('Failed to obtain access token.');

        //Add the fields and values ​​you need to modify 
        JsonRaw.Add('name', ZYSharePointAttachment."File Name");
        JsonRaw.WriteTo(JsonRawText);

        // Define the SharePoint folder URL

        // application permissions (replace with the actual site-id, drive-id, folder path and file name)
        // SharePointFileUrl := 'https://graph.microsoft.com/v1.0/sites/8199b3fb-1862-43a7-b9df-506801143348/drives/b!-7OZgWIYp0O531BoARQzSPaE3NIVRAhIqM29E4vjKX_cvFqAjvIYSYBbFPpz-OrR/items/' + ZYSharePointAttachment."SharePoint File ID";
        SharePointFileUrl := 'https://graph.microsoft.com/v1.0/sites/1d013aaa-3d34-4954-9b5b-1943a1458173/drives/b!qjoBHTQ9VEmbWxlDoUWBc8-V-TYaSfZEqG_SXc8bwYzaDkDJcdiJRbFE5z2QwGh-/items/' + ZYSharePointAttachment."SharePoint File ID";

        // Initialize the HTTP request
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.Method := 'PATCH';
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', AuthToken));
        RequestContent.GetHeaders(ContentHeader);
        RequestContent.WriteFrom(JsonRawText);
        ContentHeader.Clear();
        ContentHeader.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content(RequestContent);

        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging
            //Message('HTTP Status Code: %1', HttpResponseMessage.HttpStatusCode());

            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                //Update Web URL
                JsonResponse.ReadFrom(ResponseText);
                JsonResponse.Get('webUrl', JsonToken);
                ZYSharePointAttachment."Web Url" := JsonToken.AsValue().AsText();
                ZYSharePointAttachment.Modify(true);

                // Check if the file exists in other customers, if it exists, modify all records in the BC side.
                ZYSharePointAttachment2.Reset();
                ZYSharePointAttachment2.SetFilter(ID, '<>%1', ZYSharePointAttachment.ID);
                ZYSharePointAttachment2.SetRange("SharePoint File ID", ZYSharePointAttachment."SharePoint File ID");
                if ZYSharePointAttachment2.FindSet() then begin
                    ZYSharePointAttachment2.ModifyAll("File Name", ZYSharePointAttachment."File Name");
                    ZYSharePointAttachment2.ModifyAll("Web Url", ZYSharePointAttachment."Web Url");
                end;
            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('Failed to update file in SharePoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to SharePoint');
    end;

    procedure DeleteFileInSharePoint(var ZYSharePointAttachment: Record "SharePoint Attachment")
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        AuthToken: SecretText;
        SharePointFileUrl: Text;
        ResponseText: Text;
        ZYSharePointAttachment2: Record "SharePoint Attachment";
    begin
        // Check if the file exists in other customers, if it exists, just delete it in the BC side.
        ZYSharePointAttachment2.Reset();
        ZYSharePointAttachment2.SetFilter(ID, '<>%1', ZYSharePointAttachment.ID);
        ZYSharePointAttachment2.SetRange("SharePoint File ID", ZYSharePointAttachment."SharePoint File ID");
        if not ZYSharePointAttachment2.IsEmpty then begin
            ZYSharePointAttachment.Delete();
            exit;
        end;

        // Get OAuth token
        AuthToken := GetOAuthToken();

        if AuthToken.IsEmpty() then
            Error('Failed to obtain access token.');

        // Define the SharePoint folder URL

        // application permissions (replace with the actual site-id, drive-id, folder path and file name)
        // SharePointFileUrl := 'https://graph.microsoft.com/v1.0/sites/8199b3fb-1862-43a7-b9df-506801143348/drive/items/' + ZYSharePointAttachment."SharePoint File ID";

        // SharePointFileUrl := 'https://graph.microsoft.com/v1.0/sites/8199b3fb-1862-43a7-b9df-506801143348/drives/b!-7OZgWIYp0O531BoARQzSPaE3NIVRAhIqM29E4vjKX_cvFqAjvIYSYBbFPpz-OrR/items/' + ZYSharePointAttachment."SharePoint File ID";
        SharePointFileUrl := 'https://graph.microsoft.com/v1.0/sites/1d013aaa-3d34-4954-9b5b-1943a1458173/drives/b!qjoBHTQ9VEmbWxlDoUWBc8-V-TYaSfZEqG_SXc8bwYzaDkDJcdiJRbFE5z2QwGh-/items/' + ZYSharePointAttachment."SharePoint File ID";

        // Initialize the HTTP request
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.Method := 'DELETE';
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', AuthToken));

        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging
            //Message('HTTP Status Code: %1', HttpResponseMessage.HttpStatusCode());

            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                //JsonResponse.ReadFrom(ResponseText);
                ZYSharePointAttachment.Delete();
            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('Failed to Delete files in SharePoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to SharePoint');
    end;

    procedure CheckFileInSharePoint(var ZYSharePointAttachment: Record "SharePoint Attachment")
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        AuthToken: SecretText;
        SharePointFileUrl: Text;
        ResponseText: Text;
        LinkedToSharePointMsg: Label 'The file %1 is linked to SharePoint.';
        ProposeToDeleteMsg: Label 'The file %1 does not exist in SharePoint. Do you want to delete it from Business Central?\\%2 %3';
    begin
        // Check if the file exists in SharePoint, if not exists, propose to delete from BC side.
        if ZYSharePointAttachment."SharePoint File ID" = '' then
            if Confirm(StrSubstNo(ProposeToDeleteMsg, ZYSharePointAttachment."File Name")) then begin
                ZYSharePointAttachment.Delete();
                exit;
            end;

        // Get OAuth token
        AuthToken := GetOAuthToken();

        if AuthToken.IsEmpty() then
            Error('Failed to obtain access token.');

        // Define the SharePoint folder URL

        // application permissions (replace with the actual site-id, drive-id, folder path and file name)
        // SharePointFileUrl := 'https://graph.microsoft.com/v1.0/sites/8199b3fb-1862-43a7-b9df-506801143348/drives/b!-7OZgWIYp0O531BoARQzSPaE3NIVRAhIqM29E4vjKX_cvFqAjvIYSYBbFPpz-OrR/root:/Business Central/' + FileName + ':/content';
        // SharePointFileUrl := 'https://graph.microsoft.com/v1.0/sites/8199b3fb-1862-43a7-b9df-506801143348/drives/b!-7OZgWIYp0O531BoARQzSPaE3NIVRAhIqM29E4vjKX_cvFqAjvIYSYBbFPpz-OrR/items/' + ZYSharePointAttachment."SharePoint File ID";
        SharePointFileUrl := 'https://graph.microsoft.com/v1.0/sites/1d013aaa-3d34-4954-9b5b-1943a1458173/drives/b!qjoBHTQ9VEmbWxlDoUWBc8-V-TYaSfZEqG_SXc8bwYzaDkDJcdiJRbFE5z2QwGh-/items/' + ZYSharePointAttachment."SharePoint File ID";


        // Initialize the HTTP request
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', AuthToken));

        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging
            //Message('HTTP Status Code: %1', HttpResponseMessage.HttpStatusCode());

            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                //JsonResponse.ReadFrom(ResponseText);
                Message(LinkedToSharePointMsg, ZYSharePointAttachment."File Name");
            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                if Confirm(StrSubstNo(ProposeToDeleteMsg, ZYSharePointAttachment."File Name", HttpResponseMessage.HttpStatusCode(), ResponseText)) then begin
                    ZYSharePointAttachment.Delete();
                end;
                //Error('Failed to Delete files in SharePoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to SharePoint');
    end;

    procedure GetOAuthToken() AuthToken: SecretText
    var
        ClientID: Text;
        ClientSecret: Text;
        TenantID: Text;
        AccessTokenURL: Text;
        OAuth2: Codeunit OAuth2;
        Scopes: List of [Text];
    begin
        /* ClientID := '8afb6dfa-2603-4f02-99f3-7b4ca2a2e88f';
          ClientSecret := 'O7P8Q~FS7jTriB9CQjN4g3Vj24TaaocM4X7xpbJk';
          TenantID := '8acfc7c1-8f85-488a-af78-19f53fc9f5a3'; */ //Lykis
        ClientID := 'ec6d3e2b-0b14-4a74-9121-cbcc1669f37f';
        ClientSecret := 'y4H8Q~X1glMWmOnVzK4rDNkP.CyaWYcmNyN8idz8';
        TenantID := '0720bb80-1b5b-4a9f-83be-a1842b5b5f5b';
        AccessTokenURL := 'https://login.microsoftonline.com/' + TenantID + '/oauth2/v2.0/token';
        Scopes.Add('https://graph.microsoft.com/.default');
        if not OAuth2.AcquireTokenWithClientCredentials(ClientID, ClientSecret, AccessTokenURL, '', Scopes, AuthToken) then
            Error('Failed to get access token from response\%1', GetLastErrorText());
    end;


    procedure GetFolderUrl(FileUrl: Text): Text
    var
        LastSlashPos: Integer;
    begin
        LastSlashPos := StrPosRev(FileUrl, '/'); // custom helper since AL has no native reverse search
        if LastSlashPos > 0 then
            exit(CopyStr(FileUrl, 1, LastSlashPos - 1))
        else
            exit(FileUrl);
    end;

    /// Helper function to find last occurrence of a character
    procedure StrPosRev(Input: Text; SearchChar: Text[1]): Integer
    var
        i: Integer;
    begin
        for i := StrLen(Input) downto 1 do
            if CopyStr(Input, i, 1) = SearchChar then
                exit(i);
        exit(0);
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvHeaderInsert', '', false, false)]
    local procedure CopySPAttachmentsToInvoice(SalesHeader: Record "Sales Header"; SalesInvHeader: Record "Sales Invoice Header")
    var
        SPAttachment: Record "SharePoint Attachment";
        NewSPAttachment: Record "SharePoint Attachment";
    begin
        SPAttachment.Reset();
        SPAttachment.SetRange("Table ID", Database::"Sales Header");
        SPAttachment.SetRange("No.", SalesHeader."No.");
        SPAttachment.SetRange("Document Type", SalesHeader."Document Type");
        if SPAttachment.FindSet() then
            repeat
                Clear(NewSPAttachment);
                NewSPAttachment.Init();
                NewSPAttachment.TransferFields(SPAttachment);
                NewSPAttachment."Table ID" := Database::"Sales Invoice Header";
                NewSPAttachment."No." := SalesInvHeader."No.";
                //   NewSPAttachment."Document Type" := SalesInvHeader."Document Type";
                if not NewSPAttachment.Insert() then
                    NewSPAttachment.Modify();
            until SPAttachment.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPurchInvHeaderInsert, '', false, false)]
    local procedure "Purch.-Post_OnAfterPurchInvHeaderInsert"(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        SPAttachment: Record "SharePoint Attachment";
        NewSPAttachment: Record "SharePoint Attachment";
    begin
        SPAttachment.Reset();
        SPAttachment.SetRange("Table ID", Database::"Purchase Header");
        SPAttachment.SetRange("No.", PurchHeader."No.");
        SPAttachment.SetRange("Document Type", PurchHeader."Document Type");
        if SPAttachment.FindSet() then
            repeat
                Clear(NewSPAttachment);
                NewSPAttachment.Init();
                NewSPAttachment.TransferFields(SPAttachment);
                NewSPAttachment."Table ID" := Database::"Purch. Inv. Header";
                NewSPAttachment."No." := PurchInvHeader."No.";
                //   NewSPAttachment."Document Type" := SalesInvHeader."Document Type";
                if not NewSPAttachment.Insert() then
                    NewSPAttachment.Modify();
            until SPAttachment.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInsertGLEntry, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnAfterInsertGLEntry"(var Sender: Codeunit "Gen. Jnl.-Post Line"; GLEntry: Record "G/L Entry"; GenJnlLine: Record "Gen. Journal Line"; TempGLEntryBuf: Record "G/L Entry" temporary; CalcAddCurrResiduals: Boolean)
    var
        SPAttachment: Record "SharePoint Attachment";
        NewSPAttachment: Record "SharePoint Attachment";
    begin
        // Look up attachments linked to the journal line
        SPAttachment.Reset();
        SPAttachment.SetRange("Table ID", Database::"Gen. Journal Line");
        // SPAttachment.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        //SPAttachment.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        SPAttachment.SetRange("No.", GenJnlLine."Document No.");
        SPAttachment.SetRange("Line No.", GenJnlLine."Line No.");
        if SPAttachment.FindSet() then
            repeat
                Clear(NewSPAttachment);
                NewSPAttachment.Init();
                NewSPAttachment.TransferFields(SPAttachment);
                NewSPAttachment."Table ID" := Database::"G/L Entry";
                // NewSPAttachment."No." := GLEntry."Pre Postd Document No."; // since G/L Entry is int
                if not NewSPAttachment.Insert() then
                    NewSPAttachment.Modify();
            until SPAttachment.Next() = 0;
    end;





}