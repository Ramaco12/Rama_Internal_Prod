codeunit 70104 "Workflow Setup Ext"
{
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        MandateWorkflowCategoryTxt: Label 'MDW1';
        MandateWorkflowCategoryDescTxt: Label 'Mandate Document New';
        MandateApprovalWorkflowCodeTxt: Label 'MHAW1';
        MandateApprovalWorkflowDescTxt: Label 'Mandate Document Workflow New';
        MandateTypeCondTxt: Label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Mandate Header">%1</DataItem></DataItems></ReportParameters>';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', False, false)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(MandateWorkflowCategoryTxt, MandateWorkflowCategoryDescTxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', False, false)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WorkflowSetup.InsertTableRelation(Database::"Mandate Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', False, false)]
    local procedure OnInsertWorkflowTemplates()
    begin
        InsertMandateApprovalWorkflowTemplate()
    end;

    local procedure InsertMandateApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, MandateApprovalWorkflowCodeTxt, MandateApprovalWorkflowDescTxt, MandateWorkflowCategoryTxt);
        InsertMandateApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertMandateApprovalWorkflowDetails(Workflow: Record Workflow)
    var
        WorkflowSetupArgument: Record "Workflow Step Argument";
        Mandate: Record "Mandate Header";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        BlankDateFormula: DateFormula;
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowSetupArgument, WorkflowSetupArgument."Approver Type"::"Salesperson/Purchaser",
        WorkflowSetupArgument."Approver Limit Type"::"Approver Chain", 0, '', BlankDateFormula, true);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(Workflow, BuildMandateTypeConditions(Mandate.Status::Open), WorkflowEventHandlingExt.RunWorkflowOnSendMandateHeaderApprovalCode(),
        BuildMandateTypeConditions(Mandate.Status::"Pending Approval"), WorkflowEventHandlingExt.RunWorkflowOnCancelMandateApprovalCode(),
        WorkflowSetupArgument, true);
    end;

    local procedure BuildMandateTypeConditions(Status: Integer): Text
    var
        Mandate: Record "Mandate Header";
    begin
        Mandate.SetRange(Status, Status);
        exit(StrSubstNo(MandateTypeCondTxt, WorkflowSetup.Encode(Mandate.GetView(false))));
    end;
}
