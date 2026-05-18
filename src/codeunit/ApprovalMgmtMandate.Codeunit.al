codeunit 70171 "Approval Mgmt.Mandate"
{
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit "Workflow Event Handling Ext";

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendMandateforApproval(VAR Mandate: Record "Mandate Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMandateForApproval(var Mandate: Record "Mandate Header");
    begin
    end;

    // procedure IsMandateEnabled(var Mandate: Record "Mandate Header"): Boolean
    // begin
    //     if Mandate.Status <> Mandate.Status::Open then
    //         exit(false);
    //     exit(WFMngt.CanExecuteWorkflow(Mandate, WFCode.RunWorkflowOnSendMandateHeaderApprovalCode()))
    // end;
    procedure IsMandateEnabled(var Mandate: Record "Mandate Header"): Boolean
    begin
        if Mandate.Status <> Mandate.Status::Open then
            exit(false);
        exit(WFMngt.CanExecuteWorkflow(Mandate, WFCode.RunWorkflowOnSendMandateHeaderApprovalCode()));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', False, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        Mandate: Record "Mandate Header";
    begin
        case RecRef.Number of
            Database::"Mandate Header":
                begin
                    RecRef.SetTable(Mandate);
                    ApprovalEntryArgument."Document No." := Mandate."No.";
                end;
        end;
    end;
}
