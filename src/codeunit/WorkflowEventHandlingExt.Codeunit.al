codeunit 70122 "Workflow Event Handling Ext"
{
    var
        WorkflowMgmt: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        MandateApprovalEventDescTxt: Label 'Approval for mandate Doc is requested';
        MandateApprReqCancelledEventDescTxt: Label 'Approval for mandate Doc is Cancelled';

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', False, false)]
    // local procedure OnAddWorkflowEventsToLibrary()
    // begin
    //     WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMandateHeaderApprovalCode(), Database::"Mandate Header", MandateApprovalEventDescTxt, 0, false);
    //     WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMandateApprovalCode(), Database::"Mandate Header", MandateApprReqCancelledEventDescTxt, 0, false);
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        WorkflowEvent: Record "Workflow Event";
    begin
        // SEND FOR APPROVAL
        WorkflowEvent.Reset();
        WorkflowEvent.SetRange(Description, MandateApprovalEventDescTxt);
        WorkflowEvent.SetRange("Table ID", Database::"Mandate Header");

        if not WorkflowEvent.FindFirst() then
            WorkflowEventHandling.AddEventToLibrary(
                'MANDATE_SEND_FOR_APPROVAL',
                Database::"Mandate Header",
                MandateApprovalEventDescTxt,
                0,
                false);

        // CANCEL APPROVAL
        WorkflowEvent.Reset();
        WorkflowEvent.SetRange(Description, MandateApprReqCancelledEventDescTxt);
        WorkflowEvent.SetRange("Table ID", Database::"Mandate Header");

        if not WorkflowEvent.FindFirst() then
            WorkflowEventHandling.AddEventToLibrary(
                'MANDATE_CANCEL_APPROVAL',
                Database::"Mandate Header",
                MandateApprReqCancelledEventDescTxt,
                0,
                false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt.Mandate", 'OnSendMandateforApproval', '', False, false)]
    local procedure RunWorkflowOnSendMandateHeaderApproval(var Mandate: Record "Mandate Header");
    begin
        WorkflowMgmt.HandleEvent(RunWorkflowOnSendMandateHeaderApprovalCode(), Mandate);
    end;

    procedure RunWorkflowOnSendMandateHeaderApprovalCode(): Code[128]
    begin
        exit(UpperCase('MANDATE_SEND_FOR_APPROVAL'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt.Mandate", 'OnCancelMandateForApproval', '', False, false)]
    local procedure RunWorkflowOnCancelMandateApproval(var Mandate: Record "Mandate Header");
    begin
        WorkflowMgmt.HandleEvent(RunWorkflowOnCancelMandateApprovalCode(), Mandate);
    end;

    procedure RunWorkflowOnCancelMandateApprovalCode(): Code[128]
    begin
        exit(UpperCase('MANDATE_CANCEL_APPROVAL'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', False, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelMandateApprovalCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMandateApprovalCode(), RunWorkflowOnSendMandateHeaderApprovalCode());
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendMandateHeaderApprovalCode());
        end;
    end;


}
