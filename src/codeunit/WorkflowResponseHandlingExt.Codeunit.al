codeunit 70123 "Workflow Response Handling Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', False, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        MandateHeader: Record "Mandate Header";
    begin
        case RecRef.Number of
            Database::"Mandate Header":
                begin
                    RecRef.SetTable(MandateHeader);
                    MandateHeader.Status := MandateHeader.Status::Open;
                    MandateHeader.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', False, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        MandateHeader: Record "Mandate Header";
    begin
        case RecRef.Number of
            Database::"Mandate Header":
                begin
                    RecRef.SetTable(MandateHeader);
                    MandateHeader.Status := MandateHeader.Status::Released;
                    MandateHeader.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', False, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        MandateHeader: Record "Mandate Header";
    begin
        case RecRef.Number of
            Database::"Mandate Header":
                begin
                    RecRef.SetTable(MandateHeader);
                    MandateHeader.Status := MandateHeader.Status::"Pending Approval";
                    MandateHeader.Modify();
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', False, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext";
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(
                    WorkflowResponseHandling.SetStatusToPendingApprovalCode(),
                    WorkflowEventHandlingExt.RunWorkflowOnSendMandateHeaderApprovalCode());

            WorkflowResponseHandling.CreateApprovalRequestsCode():   // ✅ FIXED
                WorkflowResponseHandling.AddResponsePredecessor(
                    WorkflowResponseHandling.CreateApprovalRequestsCode(),
                    WorkflowEventHandlingExt.RunWorkflowOnSendMandateHeaderApprovalCode());

            WorkflowResponseHandling.CancelAllApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(
                    WorkflowResponseHandling.CancelAllApprovalRequestsCode(),
                    WorkflowEventHandlingExt.RunWorkflowOnCancelMandateApprovalCode());

            WorkflowResponseHandling.OpenDocumentCode():
                WorkflowResponseHandling.AddResponsePredecessor(
                    WorkflowResponseHandling.OpenDocumentCode(),
                    WorkflowEventHandlingExt.RunWorkflowOnCancelMandateApprovalCode());
        end;
        // case ResponseFunctionName of
        //     WorkflowResponseHandling.SetStatusToPendingApprovalCode():
        //         WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkflowEventHandlingExt.RunWorkflowOnSendMandateHeaderApprovalCode());
        //     WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
        //         WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkflowEventHandlingExt.RunWorkflowOnSendMandateHeaderApprovalCode());
        //     WorkflowResponseHandling.CancelAllApprovalRequestsCode():
        //         WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkflowEventHandlingExt.RunWorkflowOnCancelMandateApprovalCode());
        //     WorkflowResponseHandling.OpenDocumentCode():
        //         WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkflowEventHandlingExt.RunWorkflowOnCancelMandateApprovalCode());
        // end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure AddWorkflowResponsesToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(
            WorkflowResponseHandling.CreateApprovalRequestsCode(),
            0,
            'Create approval request',
            'GROUP 0');

        WorkflowResponseHandling.AddResponseToLibrary(
            WorkflowResponseHandling.CancelAllApprovalRequestsCode(),
            0,
            'Cancel approval request',
            'GROUP 0');
    end;

}
