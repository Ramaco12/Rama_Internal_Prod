// report 65413 "GST Sales Tax Invoice Copy1_" //CreativeRamaCustom
report 70122 "Sales Tax Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src\Layout\Sales Tax Invoice.rdl';
    Caption = 'Sales Tax Invoice';
    PreviewMode = PrintLayout;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    Permissions = tabledata "Sales Invoice Header" = M;

    dataset
    {
        // dataitem(CopyLoop;Table2000000026)
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number);
            // dataitem(PageLoop;Table2000000026)
            dataitem(PageLoop; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(OutputNo; OutputNo)
                {
                }
                column(Hedername; CopyText)
                {
                }
                column(PagesNo; PagesNo)
                {
                }
                column(Div_Pages; Div_Pages)
                {
                }
                column(Picturetest; CompanyInfo.Picture)
                {
                }
                // dataitem(DataItem1000000000;Table112)
                dataitem("Sales Invoice Header"; "Sales Invoice Header")
                {
                    // CalcFields = "Amount to Customer"; //Comm Misc PK_13/01/25
                    RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
                    RequestFilterHeading = 'Posted Sales Invoice';
                    column(DimValName; DimValName)
                    {
                    }
                    column(QrImage; QrImage)
                    {
                    }
                    column(TaxCaption; TaxCaption) { }
                    column(VATAmt; VATAmt) { }

                    column(NoteTextforPrint; NoteTextforPrint)
                    {
                    }
                    column(comp_pan; CompanyInfo."P.A.N. No.")
                    {
                    }
                    column(CUstomerPAN; CUstomerPAN)
                    {
                    }
                    column(Cust_pan; Cust_pan)
                    {
                    }
                    column(ship_pan; ship_pan)
                    {
                    }
                    column(HeaderCopyText; CopyText)
                    {
                    }
                    column(SalesInvHdr_DocNo; "Sales Invoice Header"."No.")
                    {
                    }
                    column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
                    column(Bill_to_Name; "Bill-to Name") { }
                    column(Bill_to_Address; "Bill-to Address") { }
                    column(Bill_to_Address_2; "Bill-to Address 2") { }
                    column(Bill_to_City; "Bill-to City") { }
                    column(Bill_to_Post_Code; "Bill-to Post Code") { }
                    column(Ship_to_Phone_No_; "Ship-to Phone No.") { }
                    column(External_Document_No_; "External Document No.") { }
                    column(Ship_to_Name; "Ship-to Name") { }
                    column(Ship_to_Address; "Ship-to Address") { }
                    column(Ship_to_Address_2; "Ship-to Address 2") { }
                    column(Ship_to_City; "Ship-to City") { }
                    column(Ship_to_Post_Code; "Ship-to Post Code") { }
                    column(GSTLoction; GSTLoction) { }
                    column(HeaderBox1Line1; CompanyInfo.Name)
                    {
                    }
                    column(HeaderBox1Line2; Address + ' ' + Address2)
                    {
                    }
                    column(HeaderBox1Line55; 'Reg off:' + ' ' + CompanyInfo.Address + ' ' + CompanyInfo."Address 2" + ' , ' + CompanyInfo.City + ' ' + CompanyInfo."Post Code")
                    {
                    }
                    column(HeaderBox1Line3; City + ' ,' + 'Pin -' + PostCode)
                    {
                    }
                    column(HeaderBox1Line4; PhNo)
                    {
                    }
                    // column(TotalNoofBox; "Sales Invoice Header"."Total No of Box")
                    // {
                    // }
                    column(TotalNoofBox; '')
                    {
                    }
                    // column(BuyerPurchaseOrderNo_SalesInvoiceHeader; "Sales Invoice Header"."Buyer Purchase Order No.")
                    // {
                    // }
                    column(BuyerPurchaseOrderNo_SalesInvoiceHeader; '')
                    {
                    }
                    column(CompEmail; CEComm)
                    {
                    }
                    // column(companyNamenew; companyNamenew)
                    // {
                    // }
                    column(companyNamenew; CompanyInfo.Name)
                    {
                    }
                    column(CompanyNameOld; CompanyNameOld)
                    {
                    }
                    column(HeaderBox1Line11; CompanyInfo.Name)
                    {
                    }
                    column(HeaderBox1Line21; CompanyInfo.Address + ' ' + CompanyInfo."Address 2")
                    {
                    }
                    column(HeaderBox1Line31; CompanyInfo.City + ' ,' + 'Pin -' + CompanyInfo."Post Code")
                    {
                    }
                    column(HeaderBox1Picture; CompanyInfo.Picture)
                    {
                    }
                    // column(picture2; CompanyInfo.Picture1)
                    // {
                    // }
                    column(picture2; '')
                    {
                    }
                    column(showoldpic; showoldpic)
                    {
                    }
                    column(Comp_FaxNo; FaxNo)
                    {
                    }
                    column(Comp_PANNo; CompanyInfo."P.A.N. No.")
                    {
                    }
                    column(Comp_State; State_.Description)
                    {
                    }
                    column(Comp_StateCode; State_."State Code (GST Reg. No.)")
                    {
                    }
                    column(HeaderBox2Line3; "Sales Invoice Header"."External Document No.")
                    {
                    }
                    column(HeaderBox2Line4; "Sales Invoice Header"."No.")
                    {
                    }
                    column(HeaderBox2Line5; FORMAT("Sales Invoice Header"."Posting Date", 0, '<day,2>-<month,2>-<year4>'))
                    {
                    }
                    column(HeaderBox2Line6; FORMAT("Sales Invoice Header"."Posting Date", 0, 4))
                    {
                    }
                    column(HeaderBox2Line7; FORMAT("Sales Invoice Header"."Time of Removal"))
                    {
                    }
                    column(HeaderBox2Line8; FORMAT("Sales Invoice Header"."Posting Date", 0, 4))
                    {
                    }
                    column(HeaderBox2Line9; ExDutyRate)
                    {
                    }
                    column(HeaderBox3Line1; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(HeaderBox3Line2; "Sales Invoice Header"."Bill-to Name")
                    {
                    }
                    column(HeaderBox3Line3; "Sales Invoice Header"."Bill-to Address" + ' ' + "Sales Invoice Header"."Bill-to Address 2" + '  ' + "Sales Invoice Header"."Bill-to City" + ', ' + "Sales Invoice Header"."Bill-to Post Code" + ' , ' + billphnno)
                    {
                    }
                    column(BilltoCustomerState_SIH; RecState.Description)
                    {
                    }
                    column(BilltoCustomerStateCode_SIH; RecState."State Code (GST Reg. No.)")
                    {
                    }
                    column(CustGSTReg; CustGSTReg)
                    {
                    }
                    column(HeaderBox3Line4; FORMAT(CustTinNo) + 'V' + ' ,' + 'DT' + FORMAT(Date))
                    {
                    }
                    column(HeaderBox3Line5; FORMAT(CustCSTNo) + ',' + 'DT' + FORMAT(Date))
                    {
                    }
                    column(HeaderBox3Line6; CustECCNo)
                    {
                    }
                    column(HeaderBox3Line7; CustLiceNo)
                    {
                    }
                    column(ShiptoCode_SIH; ShipToCode)
                    {
                    }
                    column(HeaderBox4Line1; "Sales Invoice Header"."Ship-to Name")
                    {
                    }
                    column(HeaderBox4Line2; "Sales Invoice Header"."Ship-to Address" + ',' + "Sales Invoice Header"."Ship-to Address 2" + ' ' + "Sales Invoice Header"."Ship-to City" + ' ' + "Sales Invoice Header"."Ship-to Post Code" + ' , ' + billphnno)
                    {
                    }
                    column(HeaderBox4Line3; "Sales Invoice Header"."Ship-to County")
                    {
                    }
                    // column(GSTShiptoStateCode_SIH; "Sales Invoice Header"."Ship-to State GSTIN No.")
                    // {
                    // }
                    column(GSTShiptoStateCode_SIH; '')
                    {
                    }
                    column(HeaderBox4Line4; shiptin)
                    {
                    }
                    column(ShipStateCode; ShipStateCode)
                    {
                    }
                    column(ShipStateDescr; ShipStateDescr)
                    {
                    }
                    column(HeaderBox4Line5; FORMAT(shipcst) + ',' + 'DT' + FORMAT(Shipdate))
                    {
                    }
                    column(HeaderBox4Line6; shipEccNo)
                    {
                    }
                    column(FooterCompanyAddress; CompanyAddr[2] + ' ' + CompanyAddr[3] + ' ' + CompanyAddr[4] + ' ' + CompanyAddr[5] + ' Tel. ' + FORMAT(CompanyInfo."Phone No."))
                    {
                    }
                    /* column(FooterCompanyTINDtls; FORMAT(CompanyInfo."T.I.N. No.")+'V'+'  '+'01/04/2006')
                    {
                    }
                    column(FooterCompanyCSTDtls; FORMAT(CompanyInfo."C.S.T No.")+'  '+'01/04/2006')
                    {
                    } */
                    //PK_16/01/25
                    column(FooterCompanyTINDtls; 'V' + '  ' + '01/04/2006')//FORMAT(CompanyInfo."T.I.N. No.") +
                    {
                    }
                    column(FooterCompanyCSTDtls; '  ' + '01/04/2006') //FORMAT(CompanyInfo."C.S.T No.") + 
                    {
                    }
                    column(OrderDate_SIH; FORMAT("Sales Invoice Header"."Order Date"))
                    {
                    }
                    column(OrderNo_SIH; "Sales Invoice Header"."Order No.")
                    {
                    }
                    column(PaymentTermsCode_SIH; "Sales Invoice Header"."Payment Terms Code")
                    {
                    }
                    column(BankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(BankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(IFSCcode; CompanyInfo.IBAN)
                    {
                    }
                    column(BankBranch; CompanyInfo."Bank Branch No.")
                    {
                    }
                    column(ShipMethodCode_SIH; ShipmentMethod.Description)
                    {
                    }
                    // column(TransportMode_; "Sales Invoice Header"."Transport Mode")
                    // {
                    // }
                    column(TransportMode_; '')
                    {
                    }
                    column(VehicleNo_; "Sales Invoice Header"."Vehicle No.")
                    {
                    }
                    column(PTOBool; PTOBool)
                    {
                    }
                    // column(CNINO; CompanyInfo."CIN Number")
                    // {
                    // }
                    column(CNINO; '')
                    {
                    }
                    column(Rs; Rs)
                    {
                    }
                    column(Rs1; Rs1)
                    {
                    }
                    // column(Narration_SalesINVHdr; "Sales Invoice Header".Narration)
                    // {
                    // }
                    column(Narration_SalesINVHdr; '')
                    {
                    }
                    column(Narrtion_boolean; Narrtion)
                    {
                    }
                    // column(Dispatch_Loc; "Sales Invoice Header"."Disptach Location")
                    // {
                    // }
                    // column(Dispatch_Name; "Sales Invoice Header"."Dispatch Name")
                    // {
                    // }
                    // column(Dispatch_Address; "Sales Invoice Header"."Dispatch Address")
                    // {
                    // }
                    // column(Dispatch_Address2; "Sales Invoice Header"."Dispatch Address 2")
                    // {
                    // }
                    column(Dispatch_Loc; '')
                    {
                    }
                    column(Dispatch_Name; '')
                    {
                    }
                    column(Dispatch_Address; '')
                    {
                    }
                    column(Dispatch_Address2; '')
                    {
                    }
                    column(Dispatch_PinCode; Dispatch_PinCode)
                    {
                    }
                    // column(ShiptoContact_SH; "Sales Invoice Header"."Ship-to Contact")
                    // {
                    // }
                    column(ShiptoContact_SH; "Sales Invoice Header"."Ship-to Phone No.")
                    {
                    }
                    column(IRNNO; IRNNO)
                    {
                    }
                    column(Acknowledgement_No_; "Acknowledgement No.")
                    {
                    }
                    column(Acknowledgement_Date; "Acknowledgement Date")
                    {
                    }
                    // column(EWAYBill; EWAYBill)
                    // {
                    // }
                    column(EWAYBill; "E-Way Bill No.") //MRP_18/09/25
                    {
                    }
                    // column(QRCodeIRN; ClearTaxOutputList."QR Code Temp")
                    // {
                    // }
                    column(QRCodeIRN; '')
                    {
                    }
                    // column(B2CQRCode; "Sales Invoice Header"."B2C QR Code")
                    // {
                    // }
                    column(B2CQRCode; QrImageB2C) //Changes 28/04/25
                    {
                    }
                    column(PackageTrackingNo_SalesInvoiceHeader; "Sales Invoice Header"."Package Tracking No.") //"Sales Invoice Header"."Package Tracking No." //PK
                    {
                    }
                    // column(TotalNoofBox_SalesInvoiceHeader; "Sales Invoice Header"."Logistics Remarks")
                    // {
                    // }
                    column(TotalNoofBox_SalesInvoiceHeader; '')
                    {
                    }
                    column(CustomerGSTRegNo_SalesInvoiceHeader; "Sales Invoice Header"."Customer GST Reg. No.")
                    {
                    }
                    column(CustGSTNo; CustGSTNo)
                    {
                    }
                    column(InvoiceType; InvoiceType)
                    {
                    }
                    column(HeaderTxt; HeaderTxt)
                    {
                    }
                    column(CompanyInfoGST; CompanyInfo."GST Registration No.") { }
                    column(RepTypeOpt; RepTypeOpt) { }
                    // dataitem(DataItem1000000027;Table113)
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Sell-to Customer No." = FIELD("Sell-to Customer No."),
                                       "Document No." = FIELD("No.");
                        DataItemTableView = SORTING("Document No.", "Line No.")
                                            ORDER(Ascending)
                                            WHERE(Quantity = FILTER(<> 0));
                        column(SILItemNo; "Sales Invoice Line"."No.")
                        {
                        }
                        column(SalesInvLineLnNo; "Sales Invoice Line"."Line No.")
                        {
                        }
                        column(Doc_No; "Sales Invoice Line"."Document No.")
                        {
                        }
                        column(SNo; SNo)
                        {
                        }
                        column(SrNo; SrNo)
                        {
                        }
                        column(Ctr; CtrTExt)
                        {
                        }
                        column(SalesInvLineNo; "Sales Invoice Line"."No.")
                        {
                        }
                        // column(SalesInvLineDesc; "Sales Invoice Line".Description + '  ' + "Sales Invoice Line"."Description 2")
                        // {
                        // }
                        column(SalesInvLineDesc; "Sales Invoice Line".Description)
                        {
                        }
                        column(SalesInvChapNo; chapno)
                        {
                        }
                        column(SalesInvLinPkgs; TotNoOfPkgs)
                        {
                        }
                        column(UnitofMeasureCode_SIL; "Sales Invoice Line"."Unit of Measure Code")
                        {
                        }
                        column(SalesInvLinUnitPerParcel; "Sales Invoice Line"."Units per Parcel")
                        {
                        }
                        column(SalesInvLinQty; "Sales Invoice Line".Quantity)
                        {
                        }
                        column(SalesInvLinUnitPrice; "Sales Invoice Line"."Unit Price")
                        {
                        }
                        column(SalesInvLinLnAmt; "Sales Invoice Line"."Line Amount")
                        {
                        }
                        /* column(SalesInvLinXciseAmt; "Sales Invoice Line"."Excise Amount")
                        {
                        }
                        column(AmountToCustomer_SIL; "Sales Invoice Line"."Amount To Customer")
                        {
                        } */
                        //PK_16/01/25
                        column(SalesInvLinXciseAmt; '')
                        {
                        }
                        column(AmountToCustomer_SIL; '')
                        {
                        }
                        column(SalesLineFooterTotalPkgs; TotalTotNoOfPkgs)
                        {
                        }
                        column(SalesLineFooterTotalQty; TotalQty)
                        {
                        }
                        column(SalesLineFooterTotalLineAmt; TotalLineAmt)
                        {
                        }
                        column(SalesLineFooterTotalXciseAmt; TotalExciseAmt2)
                        {
                        }
                        column(SalesLineFooterTotalTaxAmtCaption; Taxp)
                        {
                        }
                        column(SalesLineFooterTotalTaxAmt; TotalTaxAmt)
                        {
                        }
                        column(SalesLineFooterInvoiceAmt; TotalAmtToCustomerInvrounding)
                        {
                        }
                        column(Othercharge; Othercharge)
                        {
                        }
                        column(SalesLineFooterExciseInWords; NoTextExcise[1] + ' ' + NoTextExcise[2])
                        {
                        }
                        column(SalesLineFooterExciseInWords2; NoTextExcise[2])
                        {
                        }
                        // column(SalesLineFooterInvoiceInWords; NoText[1] + ' ' + NoText[2])
                        // {
                        // }
                        column(SalesLineFooterInvoiceInWords; AmountInWords)
                        {
                        }

                        column(SalesLineFooterInvoiceInWords2; NoText[2])
                        {
                        }
                        column(LOTNO; LOTNO)
                        {
                        }
                        column(LotQTY; LotQTY)
                        {
                        }
                        column(SalesLineDocNo; "Sales Invoice Line"."Document No.")
                        {
                        }
                        column(SalesLineGlbItemNo; GlbItemNo)
                        {
                        }
                        column(InvoiceRoundoff; InvoiceRoundoff)
                        {
                        }
                        column(HSNSACCode_SalesInvoiceLine; HSNCode)
                        {
                        }
                        column(CGSTPer; CGSTPer)
                        {
                        }
                        column(CGSTAmt; CGSTAmt)
                        {
                        }
                        column(SGSTPer; SGSTPer)
                        {
                        }
                        column(SGSTAmt; SGSTAmt)
                        {
                        }
                        column(IGSTPer; IGSTPer)
                        {
                        }
                        column(IGSTAmt; IGSTAmt)
                        {
                        }
                        column(VATPer; "VAT %")
                        {
                        }
                        column(LineDiscount_SIL; "Sales Invoice Line"."Line Discount Amount")
                        {
                        }
                        /* column(AssessableValue_SIL; "Sales Invoice Line"."Assessable Value")
                        {
                        }
                        column(GSTBaseAmount_SIL; "Sales Invoice Line"."GST Base Amount")
                        {
                        }
                        column(TotalGSTAmount_SIL; "Sales Invoice Line"."Total GST Amount")
                        {
                        } */
                        //PK_16/01/25 Temp
                        column(AssessableValue_SIL; '')
                        {
                        }
                        column(GSTBaseAmount_SIL; "Sales Invoice Line"."Line Amount")
                        {
                        }
                        column(TotalGSTAmount_SIL; '')
                        {
                        }
                        column(UnitPrice_SIL; "Sales Invoice Line"."Unit Price")
                        {
                        }
                        column(ReverseChg; ReverseChg)
                        {
                        }
                        column(InsuranAmt; InsuranAmt)
                        {
                        }
                        column(PackingChrs; PackingChrs)
                        {
                        }
                        column(FreightAmt; FreightAmt)
                        {
                        }
                        // column(PartCode; "Sales Invoice Line"."Part Code")
                        // {
                        // }
                        column(PartCode; '')
                        {
                        }
                        column(ILE_SerialNo; SerialNos + serialNo1)
                        {
                        }
                        column(qtytotal; qtytotal)
                        {
                        }
                        // column(Dis_per; "Sales Invoice Line"."Dis.%")
                        // {
                        // }
                        column(Dis_per; '')
                        {
                        }
                        // column(amount; "Sales Invoice Line"."GST Base Amount") { }
                        column(amount; "Sales Invoice Line".Amount) { }
                        // column(Gstamt; "Sales Invoice Line"."Total GST Amount") { }
                        column(Gstamt; '') { } //PK_16/01/25 Temp
                        column(TotalAmtCustomer; TotalAmtToCustomer)
                        {
                        }
                        column(VATAmount; TotalAmtToCustomer - TotalLineAmt) //VAT Amt
                        {
                        }
                        column(Type_SalesInvoiceLine; "Sales Invoice Line".Type)
                        {
                        }
                        column(TCSPer; TCSPer)
                        {
                        }
                        column(TCSAmt; TcsAmt)
                        {
                        }
                        column(TotalAmount; TotalAmount)
                        {
                        }
                        column(TotalAmtToCust; TotalAmtToCust)
                        {
                        }


                        trigger OnAfterGetRecord()
                        var
                            UserSetup: Record "User Setup";
                            LocationRec: Record Location;
                        begin
                            SNo += 1;
                            TotNoOfPkgs := 0;
                            IF "Sales Invoice Line"."Units per Parcel" > 0 THEN BEGIN
                                TotNoOfPkgs := "Sales Invoice Line".Quantity / "Sales Invoice Line"."Units per Parcel";
                            END;
                            IF "Sales Invoice Line".Type = "Sales Invoice Line".Type::Item THEN
                                qtytotal += "Sales Invoice Line".Quantity;

                            //IF ("Sales Invoice Line"."No." <> '') AND ("Sales Invoice Line".Type = "Sales Invoice Line".Type::Item) THEN BEGIN
                            IF ("Sales Invoice Line"."No." <> '') THEN BEGIN //PK_24/04/26
                                ctr += 1;
                                CtrTExt := FORMAT(ctr);
                            END ELSE
                                CtrTExt := '';
                            SrNo := ctr;

                            HSNCode := '';
                            //HSNCode :=COPYSTR("Sales Invoice Line"."HSN/SAC Code",1,4);
                            HSNCode := "Sales Invoice Line"."HSN/SAC Code";

                            // TJ 27Feb26 +++
                            // if not IsCounted then begin

                            //     SalesInvHdr.Get("Sales Invoice Header"."No.");

                            //     // Check if already printed
                            //     if SalesInvHdr."No. Printed Report" > 0 then begin
                            //         if not Confirm('This invoice is already printed %1 time(s). Do you want to reprint?',
                            //                        false,
                            //                        SalesInvHdr."No. Printed Report") then
                            //             CurrReport.Quit();
                            //     end;

                            //     // Increase count only if YES
                            //     SalesInvHdr."No. Printed Report" += 1;
                            //     SalesInvHdr.Modify();

                            //     IsCounted := true;
                            // end;
                            /*  if not IsCounted then begin
                                 SalesInvHdr.Get("Sales Invoice Header"."No.");
                                 if FromAction then begin
                                     if SalesInvHdr."No. Printed Report" > 0 then begin
                                         if not Confirm(
                                             'This invoice is already printed %1 time(s). Do you want to reprint?',
                                             false,
                                             SalesInvHdr."No. Printed Report")
                                         then
                                             CurrReport.Quit();
                                     end;
                                     SalesInvHdr."No. Printed Report" += 1;
                                     SalesInvHdr.Modify();
                                 end;
                                 IsCounted := true;
                             end; */
                            //TJ ----



                            // TotalTotNoOfPkgs += TotNoOfPkgs;
                            // TotalQty += "Sales Invoice Line".Quantity;

                            // RepCheck[2].InitTextVariable;
                            // RepCheck[2].FormatNoText(NoTextExcise,TotalExciseAmt +
                            //                          ROUND(((TotalExciseAmt*ExcisePostingSetup."eCess %")/100),1) +
                            //                            ROUND(((TotalExciseAmt*ExcisePostingSetup."SHE Cess %")/100),1)
                            // ,"Sales Invoice Header"."Currency Code");


                            CGSTPer := 0;
                            CGSTAmt := 0;
                            SGSTPer := 0;
                            SGSTAmt := 0;
                            IGSTPer := 0;
                            IGSTAmt := 0;
                            TotalAmtToCust := 0;
                            TotalGSTNew := 0;  //PK

                            DetailedGSTLedgerEntry.RESET;
                            DetailedGSTLedgerEntry.SETRANGE("Document No.", "Document No.");
                            DetailedGSTLedgerEntry.SETRANGE("Document Line No.", "Line No.");
                            DetailedGSTLedgerEntry.SETFILTER("Entry Type", '%1', DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                            IF DetailedGSTLedgerEntry.FIND('-') THEN
                                REPEAT
                                    CASE DetailedGSTLedgerEntry."GST Component Code" OF
                                        'CGST':
                                            BEGIN
                                                CGSTPer := DetailedGSTLedgerEntry."GST %";
                                                CGSTAmt += DetailedGSTLedgerEntry."GST Amount" * -1;
                                                TotalGSTNew += DetailedGSTLedgerEntry."GST Amount" * -1; //PK
                                            END;
                                        'SGST':
                                            BEGIN
                                                SGSTPer := DetailedGSTLedgerEntry."GST %";
                                                SGSTAmt += DetailedGSTLedgerEntry."GST Amount" * -1;
                                                TotalGSTNew += DetailedGSTLedgerEntry."GST Amount" * -1; //PK
                                            END;
                                        'IGST':
                                            BEGIN
                                                IGSTPer := DetailedGSTLedgerEntry."GST %";
                                                IGSTAmt += DetailedGSTLedgerEntry."GST Amount" * -1;
                                                TotalGSTNew += DetailedGSTLedgerEntry."GST Amount" * -1; //PK
                                            END;
                                    END;
                                UNTIL DetailedGSTLedgerEntry.NEXT = 0;
                            //LFS-KB-10251++
                            IF "Sales Invoice Header"."Currency Code" <> '' THEN BEGIN
                                CGSTAmt := CGSTAmt * "Sales Invoice Header"."Currency Factor";
                                SGSTAmt := SGSTAmt * "Sales Invoice Header"."Currency Factor";
                                IGSTAmt := IGSTAmt * "Sales Invoice Header"."Currency Factor";
                                TotalGSTNew := TotalGSTNew * "Sales Invoice Header"."Currency Factor";  //PK
                                TotalAmtToCust := "Sales Invoice Header"."Amount Including VAT" * "Sales Invoice Header"."Currency Factor";
                            END;
                            //LFS-KB-10251--
                            IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                                ReverseChg := ReverseChg::Yes
                            ELSE
                                ReverseChg := ReverseChg::No;

                            //Comm GST PK_13/01/25
                            /* StructureLineDetails.RESET;
                            StructureLineDetails.SETRANGE("Invoice No.", "Sales Invoice Line"."Document No.");
                            StructureLineDetails.SETFILTER(Type, '%1', StructureLineDetails.Type::Sale);
                            IF StructureLineDetails.FIND('-') THEN
                                REPEAT
                                    CASE StructureLineDetails."Tax/Charge Group" OF
                                        'FREIGHT':
                                            FreightAmt += StructureLineDetails.Amount;
                                        'PACKING':
                                            PackingChrs += StructureLineDetails.Amount;
                                        'INSURANCE':
                                            InsuranAmt += StructureLineDetails.Amount;
                                    END;
                                UNTIL StructureLineDetails.NEXT = 0; */



                            //LFS-PPG-06964.01++
                            SerialNos := '';
                            serialNo1 := '';
                            IF ViewSerialNo <> FALSE THEN BEGIN
                                ValueEntry.RESET;
                                ValueEntry.SETCURRENTKEY("Document No.");
                                ValueEntry.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                                ValueEntry.SETRANGE("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                                ValueEntry.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                                ValueEntry.SETRANGE(ValueEntry.Adjustment, FALSE);
                                IF ValueEntry.FINDSET THEN
                                    REPEAT
                                        ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
                                        IF (ItemLedgEntry."Document Type" = ItemLedgEntry."Document Type"::"Sales Shipment") THEN
                                            IF SalesShptLine.GET(ItemLedgEntry."Document No.", ItemLedgEntry."Document Line No.") THEN BEGIN
                                                IF ItemLedgEntry."Serial No." <> '' THEN BEGIN
                                                    IF SerialNos = '' THEN
                                                        SerialNos := ItemLedgEntry."Serial No."
                                                    ELSE
                                                        IF STRLEN(SerialNos + ',' + ItemLedgEntry."Serial No.") < 1024 THEN //LFS-AVY 07936 ++
                                                            SerialNos += ',' + ItemLedgEntry."Serial No."
                                                        ELSE
                                                            serialNo1 += ',' + ItemLedgEntry."Serial No."; //LFS-AVY 07936 ++
                                                END ELSE BEGIN
                                                    /* PostedSalesSerialNo.RESET;
                                                    PostedSalesSerialNo.SETRANGE(PostedSalesSerialNo."Document No.", "Sales Invoice Line"."Document No.");
                                                    PostedSalesSerialNo.SETRANGE(PostedSalesSerialNo."Line No.", "Sales Invoice Line"."Line No.");
                                                    PostedSalesSerialNo.SETFILTER(PostedSalesSerialNo."Serial No.", '<>%1', '');
                                                    IF PostedSalesSerialNo.FINDSET THEN
                                                        REPEAT
                                                            IF SerialNos = '' THEN
                                                                SerialNos := PostedSalesSerialNo."Serial No."
                                                            ELSE
                                                                IF STRLEN(SerialNos + ',' + PostedSalesSerialNo."Serial No.") < 1024 THEN //LFS-AVY 07936 ++
                                                                    SerialNos += ',' + PostedSalesSerialNo."Serial No."
                                                                ELSE
                                                                    serialNo1 += ',' + PostedSalesSerialNo."Serial No."; //LFS-AVY 07936 ++
                                                        UNTIL PostedSalesSerialNo.NEXT = 0; */
                                                END;
                                            END;
                                    UNTIL ValueEntry.NEXT = 0;
                            END;
                            //LFS-PPG-06964.01--

                            //Comm GST PK_13/01/25
                            /* IF "Sales Invoice Line"."TDS/TCS Amount" <> 0 THEN BEGIN
                                TCSPer := '@ ' + FORMAT("Sales Invoice Line"."TDS/TCS %") + ' %';
                                TcsAmt += "Sales Invoice Line"."TDS/TCS Amount";
                            END; */

                            TotalLineAmt += "Sales Invoice Line"."Line Amount";
                            TotalAmtToCustomer += "Sales Invoice Line"."Amount Including VAT";
                            // TotalGSTBaseAmt += "Sales Invoice Line"."Total GST Amount";//LFS-IS  //Comm GST PK_13/01/25
                            TotalGSTBaseAmt += TotalGSTNew; //PK_New
                            TotalAmount := ROUND(TotalAmtToCustomer + TotalGSTBaseAmt + TcsAmt, 1); //LFS-IS
                                                                                                    //ELSE
                                                                                                    //TotalAmtToCustomer += "Sales Invoice Line"."Amount To Customer"-InvoiceRoundoff;

                            //MRP_18/09/25 ++
                            UserSetup.Reset();
                            LocationRec.Reset();
                            LocationRec.SetRange(Code, "Sales Invoice Header"."Location Code");
                            if LocationRec.FindFirst() then
                                /* if LocationRec."Sales Invoice Print" = false then begin
                                    UserSetup.Get(UserId);
                                    if UserSetup."Super User" = false then begin
                                        // Error('You are Not Authorized Person')
                                        "Sales Invoice Header".CalcFields(Amount);
                                        if ("Sales Invoice Header"."E-Way Bill No." = '') AND (TotalAmount > 50000) then
                                            Error('E-Way Bill No. is required for invoices above 50,000.');
                                    end;
                                end; */
                                //MRP_18/09/25 --

                                TotalAmtToCustomerInvrounding := TotalAmtToCustomer; //+ InvoiceRoundoff;


                            // RepCheck[1].InitTextVariable;
                            // //RepCheck[1].FormatNoText(NoText,TotalAmtToCustomerInvrounding,"Sales Invoice Header"."Currency Code");
                            // "Sales Invoice Header".CALCFIELDS("Sales Invoice Header"."Amount Including VAT");
                            // RepCheck[1].FormatNoText(NoText, ROUND("Sales Invoice Header"."Amount Including VAT" + TcsAmt + TotalGSTBaseAmt, 1), "Sales Invoice Header"."Currency Code");  //2573
                            //TotalAmountNew := ROUND("Sales Invoice Header"."Amount Including VAT" + TcsAmt + TotalGSTBaseAmt, 1);


                            Totalfin := ROUND((TotalLineAmt * 12) / 100) + ROUND(((TotalLineAmt * 12) / 100) * 0.02)
                            + ROUND(((TotalLineAmt * 12) / 100) * 0.01);

                            InitTextVariable();
                            if "Sales Invoice Header"."Currency Code" = 'USD' then begin
                                AmountInWords := NumberInWordsUSD(TotalAmount, '', 'USD');
                            end;
                            //PK_24/04/26 ++
                            if "Sales Invoice Header"."Currency Code" = 'AED' then begin
                                AmountInWords := NumberInWordsAED(TotalAmount, '', 'AED');
                            end;
                            if "Sales Invoice Header"."Currency Code" = 'QAR' then begin
                                AmountInWords := NumberInWordsQAR(TotalAmount, '', 'QAR');
                            end;
                            //PK_24/04/26 --
                            if ("Sales Invoice Header"."Currency Code" = '') or ("Sales Invoice Header"."Currency Code" = 'INR') then begin
                                AmountInWords := "AmtInWords-Rupees"(TotalAmount);
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            TotalAmtToCustomer := 0;
                            FreightAmt := 0;
                            PackingChrs := 0;
                            InsuranAmt := 0;
                            CLEAR(TCSPer);
                            CLEAR(TcsAmt);
                            CLEAR(TotalGSTBaseAmt);
                            CLEAR(TotalAmount);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                    // LocationARNMaster: Record 50021;
                    begin
                        IF "Sales Invoice Header"."Nature of Supply" = "Sales Invoice Header"."Nature of Supply"::B2C THEN
                            // IF NOT "Sales Invoice Header"."IRN No. Generated" THEN
                               IF NOT ("Sales Invoice Header"."IRN HASH" <> '') THEN
                                IF "Sales Invoice Header"."QR Code".HASVALUE THEN
                                    "Sales Invoice Header".CALCFIELDS("Sales Invoice Header"."QR Code");
                        FormatAddr.Company(CompanyAddr, CompanyInfo);

                        // IF State_.GET(CompanyInfo.state) THEN;
                        IF State_.GET(CompanyInfo."State Code") THEN;


                        IF RecState.GET("Sales Invoice Header"."GST Bill-to State Code") THEN;

                        // Get values from location if not blank
                        IF Location.GET("Location Code") THEN BEGIN
                            Address := Location.Address;
                            Address2 := Location."Address 2";
                            City := Location.City;
                            StateCode := Location."State Code";
                            CountryCode := Location."Country/Region Code";
                            PostCode := Location."Post Code";
                            PhNo := Location."Phone No.";
                            FaxNo := Location."Fax No.";
                            CEComm := Location."E-Mail";
                            GSTLoction := Location."GST Registration No.";
                        END;
                        // Get values from location if not blank
                        CLEAR(billphnno);
                        IF reccust.GET("Sales Invoice Header"."Ship-to Code") THEN BEGIN
                            billphnno := reccust."Phone No.";
                        END;

                        IF ShipmentMethod.GET("Sales Invoice Header"."Shipment Method Code") THEN;

                        CLEAR(billphnno);
                        IF customer.GET("Sales Invoice Header"."Bill-to Customer No.") THEN BEGIN

                            //Comm Misc PK_13/01/25
                            /* CustTinNo := customer."T.I.N. No.";
                            CustCSTNo := customer."C.S.T. No.";
                            CustECCNo := customer."E.C.C. No."; */
                            CustGSTReg := customer."GST Registration No.";
                            Cust_pan := customer."P.A.N. No.";
                            billphnno := customer."Phone No.";
                        END;

                        IF "Ship-to Code" <> '' THEN BEGIN
                            ship.RESET;
                            ship.SETFILTER(ship.Code, "Sales Invoice Header"."Ship-to Code");
                            ship.SETFILTER(ship."Customer No.", "Sales Invoice Header"."Bill-to Customer No.");
                            IF ship.FINDFIRST THEN BEGIN
                                ShipToCode := ship.Code;
                                shiptin := ship."GST Registration No.";
                                /* IF ShipState.GET("Sales Invoice Header"."Ship-to State") THEN BEGIN //LFS-AS-6516
                                    ShipStateCode := ShipState."State Code (GST Reg. No.)";
                                    ShipStateDescr := ShipState.Description;
                                END; */
                            END;
                        END ELSE BEGIN
                            ShipToCode := "Sales Invoice Header"."Bill-to Customer No.";
                            /* IF "Sales Invoice Header"."Ship-to State" = customer."State Code" THEN
                                IF "Sales Invoice Header"."GST Customer Type" = "Sales Invoice Header"."GST Customer Type"::"SEZ Unit" THEN BEGIN //lFS-MR-11699++
                                    IF customer.GET("Sales Invoice Header"."Bill-to Customer No.") THEN
                                        shiptin := customer."GST Registration No."
                                    // shiptin  := CustGSTReg
                                END ELSE begin
                                    //lFS-MR-11699--
                                    shiptin := "Sales Invoice Header"."Customer GST Reg. No.";    //LFS-CG-11699

                                    //PK_17/12/25 ++ Tukaram ji
                                    if "Sales Invoice Header"."Ship-to Address" <> "Sales Invoice Header"."Sell-to Address" then
                                        shiptin := "Sales Invoice Header"."Ship-to State GSTIN No.";
                                    //PK_17/12/25 --
                                end
                            ELSE
                                shiptin := "Sales Invoice Header"."Ship-to State GSTIN No.";
                            ShipStateCode := RecState."State Code (GST Reg. No.)";
                            ShipStateDescr := RecState.Description;
                            shipcst := CustCSTNo;
                            shipEccNo := CustECCNo;
                            Shipdate := Date;
                            IF "Sales Invoice Header"."Ship-to State" <> '' THEN
                                IF ShipState.GET("Sales Invoice Header"."Ship-to State") THEN BEGIN
                                    ShipStateCode := ShipState."State Code (GST Reg. No.)";
                                    ShipStateDescr := ShipState.Description;
                                END; */
                        END;

                        /* //7093 ++
                        CLEAR(companyNamenew);
                        CLEAR(CompanyNameOld);
                        //CompanyInfo.GET;
                        IF CompanyInfo."Name Change Effective Date" <= "Sales Invoice Header"."Posting Date" THEN BEGIN
                            companyNamenew := CompanyInfo.Name;
                            IF CompanyInfo."Old Company Name Add on Report" THEN
                                CompanyNameOld := 'Formerly known as ' + CompanyInfo."Old Company Name";
                            showoldpic := FALSE;
                        END ELSE BEGIN
                            companyNamenew := CompanyInfo."Old Company Name";
                            showoldpic := TRUE;
                        END;
                        //7093 -- */

                        //LFS-ASP-  ++
                        IF (("Sales Invoice Header"."Currency Code" = 'INR') OR ("Sales Invoice Header"."Currency Code" = '')) THEN BEGIN
                            Rs := '₹';
                        END ELSE
                            IF "Sales Invoice Header"."Currency Code" = 'USD' THEN BEGIN
                                Rs := '$';
                            END;

                        IF (("Sales Invoice Header"."Currency Code" = 'INR') OR ("Sales Invoice Header"."Currency Code" = '')) THEN BEGIN
                            Rs1 := '₹';
                        END ELSE
                            IF "Sales Invoice Header"."Currency Code" = 'USD' THEN BEGIN
                                Rs1 := 'Dollar';
                            END;

                        //LFS-ASP- --
                        CLEAR(IRNNO);
                        CLEAR(EWAYBill);
                        ClearTaxOutputList.RESET;
                        ClearTaxOutputList.SETRANGE("e_Document No.", "Sales Invoice Header"."No.");
                        IF ClearTaxOutputList.FINDFIRST THEN BEGIN
                            IRNNO := ClearTaxOutputList.e_IRN;
                            // AckNo := ClearTaxOutputList.e_AckNo;
                            // AckDate := ClearTaxOutputList.e_AckDt;
                            EWAYBill := ClearTaxOutputList.e_EwbNo;
                            ClearTaxOutputList.CALCFIELDS(e_SignedQRCode);
                        END;

                        TotalQty := 0;
                        TotalLineAmt := 0;
                        TotalAmtToCustomer := 0;
                        TotalAmtToCustomerInvrounding := 0;
                        TotalExciseAmt := 0;
                        TotalExciseAmt2 := 0;
                        TotalTaxAmt := 0;
                        SNo := 0;
                        ctr := 0;
                        CtrTExt := '';
                        SrNo := 0;

                        //LFS-AY-20.10.2020++
                        CLEAR(CUstomerPAN);
                        Customer_GRec.RESET;
                        Customer_GRec.SETRANGE("No.", "Sales Invoice Header"."Bill-to Customer No.");
                        IF Customer_GRec.FINDFIRST THEN
                            CUstomerPAN := Customer_GRec."P.A.N. No.";
                        //LFS-AY-20.10.2020--

                        //LFS-NG-7857 >>
                        /* IF "Sales Invoice Header"."GST Customer Type" = "Sales Invoice Header"."GST Customer Type"::"SEZ Unit" THEN BEGIN
                            LocationARNMaster.GetARNandRelatedFeilds("Sales Invoice Header"."Location Code", "Sales Invoice Header"."Posting Date",
                            NoteTextforPrint);
                        END; */
                        //LFS-NG-7857 <<
                        //LFS-SG-8886++
                        Dimension.RESET;
                        Dimension.SETRANGE("Dimension Set ID", "Sales Invoice Header"."Dimension Set ID");
                        Dimension.SETRANGE("Dimension Code", 'PRODUCT');
                        IF Dimension.FINDFIRST THEN BEGIN
                            Dimension.CALCFIELDS("Dimension Value Name");
                            DimValName := Dimension."Dimension Value Name";
                        END;
                        //LFS-SG-8886--
                        //LFS-MR-11699++
                        IF "Sales Invoice Header"."GST Customer Type" = "Sales Invoice Header"."GST Customer Type"::"SEZ Unit" THEN BEGIN
                            IF customer.GET("Sales Invoice Header"."Sell-to Customer No.") THEN
                                CustGSTNo := customer."GST Registration No.";
                        END ELSE
                            CustGSTNo := "Sales Invoice Header"."Customer GST Reg. No.";
                        //LFS-MR-11699--



                        ///QR Generation // Rk 010425
                        //QR code Start
                        Clear(tempBlob);
                        Clear(QrInstream);
                        Clear(QrImage);
                        Clear(QRCodeInStream);
                        RecEinvoice.Reset();
                        RecEinvoice.SetRange("e_Document No.", "No.");
                        if RecEinvoice.FindFirst() then
                            IF RecEinvoice."e_IRN" <> '' then begin
                                // EwayBillDate := format(RecEinvoice.e_EwbDt);
                                if RecEinvoice."e_EwbDt" <> '' then
                                    Evaluate(EwayBillDate, RecEinvoice."e_EwbDt");
                                RecEinvoice.CALCFIELDS("e_SignedQRCode");
                                tempBlob.CreateInStream(QrInstream, TextEncoding::WINDOWS);
                                RecEinvoice.CalcFields("e_SignedQRCode");
                                RecEinvoice."e_SignedQRCode".CreateInStream(QRCodeInStream);
                                QRCodeInStream.ReadText(QRText);
                                if QRText <> '' then begin
                                    QRGenerator.GenerateQRCodeImage(QRText, tempBlob);
                                    QrImage := base64Convert.ToBase64(QrInstream);
                                end;
                            end;
                        //QR code End

                        //QR B2C code Start
                        Clear(tempBlobB2C);
                        Clear(QrInstreamB2C);
                        Clear(QrImageB2C);
                        Clear(QRCodeInStreamB2C);
                        // RecEinvoiceB2C.Reset();
                        // RecEinvoiceB2C.SetRange("Document No.", "No.");
                        // if RecEinvoiceB2C.FindFirst() then
                        //     IF RecEinvoiceB2C."IRN No." <> '' then begin
                        // EwayBillDate := format(RecEinvoice.e_EwbDt);
                        // Evaluate(EwayBillDate, RecEinvoice."EWB Date");
                        "Sales Invoice Header".CALCFIELDS("QR Code");
                        tempBlobB2C.CreateInStream(QrInstreamB2C, TextEncoding::WINDOWS);
                        // RecEinvoice.CalcFields("QR Code");
                        // RecEinvoice."QR Code".CreateInStream(QRCodeInStream);
                        "Sales Invoice Header".CalcFields("Sales Invoice Header"."QR Code");
                        "Sales Invoice Header"."QR Code".CreateInStream(QRCodeInStreamB2C);
                        QRCodeInStreamB2C.ReadText(QRTextB2C);
                        if QRTextB2C <> '' then begin
                            QRGeneratorB2C.GenerateQRCodeImage(QRTextB2C, tempBlobB2C);
                            QrImageB2C := base64ConvertB2C.ToBase64(QrInstreamB2C);
                        end;
                        //end;
                        //QR B2C code End

                        /* //Disptach Details from Vendor for E-way +++++ PK_02/02/26
                        Clear(Dispatch_PinCode);
                        if "Sales Invoice Header"."Vendor Code" <> '' then begin
                            if "Sales Invoice Header"."Vendor Order Address Code" <> '' then begin
                                OrderAddress.Reset();
                                OrderAddress.SetRange("Vendor No.", "Sales Invoice Header"."Vendor Code");
                                OrderAddress.SetRange(Code, "Sales Invoice Header"."Vendor Order Address Code");
                                if OrderAddress.FindFirst() then begin
                                    Dispatch_PinCode := OrderAddress."Post Code";
                                end;
                            end else begin
                                RecVendor.Reset();
                                RecVendor.SetRange("No.", "Sales Invoice Header"."Vendor Code");
                                if RecVendor.FindFirst() then begin
                                    Dispatch_PinCode := RecVendor."Post Code";
                                end;
                            end;
                        end;
                        if "Sales Invoice Header"."Disptach Location" <> '' then begin
                            DispLocation.Reset();
                            DispLocation.SetRange(Code, "Sales Invoice Header"."Disptach Location");
                            if DispLocation.Findfirst() then begin
                                Dispatch_PinCode := DispLocation."Post Code";
                            end;
                        end;
                        //Disptach Details from Vendor for E-way ----- PK_02/02/26 */

                        Clear(TaxCaption);
                        Clear(VATAmt);
                        TaxCaption := GetTaxCaption("Sales Invoice Header");
                        VATEntry1.Reset();
                        VATEntry1.SetRange("Document No.", "Sales Invoice Header"."No.");
                        if VATEntry1.FindSet() then begin
                            repeat
                                VATAmt := Abs(VATEntry1.Amount);
                            until VATEntry1.Next() = 0;
                        end;


                    end;

                    trigger OnPreDataItem()
                    begin
                        TotalQty := 0;
                        TotalLineAmt := 0;
                        TotalAmtToCustomer := 0;
                        qtytotal := 0;
                        //"Sales Invoice Header"."No."
                        IF documntno <> '' THEN
                            "Sales Invoice Header".SETRANGE("No.", documntno);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                IF OptionTyp <> '' THEN BEGIN
                    IF RepTypeOpt = RepTypeOpt::"Original For Recipient" THEN BEGIN
                        CopyText := 'Original For Recipient';
                        OutputNo += 1;
                        PagesNo += 1;  //LFS-AK-3376
                    END;
                END
                ELSE
                    IF RepTypeOpt = RepTypeOpt::"All Pages" THEN BEGIN
                        Div_Pages := 3;  //LFS-AK-3376
                        IF Number = 1 THEN BEGIN
                            CopyText := 'Original For Recipient';
                            OutputNo += 1;
                            PagesNo += 1;  //LFS-AK-3376
                        END
                        ELSE IF Number = 2 THEN BEGIN
                            CopyText := 'Duplicate For Supplier/Transporter';
                            OutputNo += 1;
                            PagesNo += 1;  //LFS-AK-3376
                        END
                        ELSE IF Number = 3 THEN BEGIN
                            CopyText := 'Triplicate For Supplier';
                            OutputNo += 1;
                            PagesNo += 1;  //LFS-AK-3376
                        END

                    END
                    ELSE BEGIN
                        Div_Pages := 1;  //LFS-AK-3376
                        IF RepTypeOpt = RepTypeOpt::"Original For Recipient" THEN BEGIN
                            CopyText := 'Original For Recipient';
                            OutputNo += 1;
                            PagesNo += 1;  //LFS-AK-3376
                        END
                        ELSE IF RepTypeOpt = RepTypeOpt::"Duplicate For Supplier/Transporter" THEN BEGIN
                            OutputNo += 1;
                            PagesNo += 1;  //LFS-AK-3376
                            CopyText := 'Duplicate For Supplier/Transporter';
                        END
                        ELSE IF RepTypeOpt = RepTypeOpt::"Triplicate For Supplier" THEN BEGIN
                            CopyText := 'Triplicate For Supplier';
                            OutputNo += 1;
                            PagesNo += 1;  //LFS-AK-3376
                        END;

                    END;
                // IF OptionTyp<>'' THEN
                //  IF RepTypeOpt=RepTypeOpt::"Original For Receipient" THEN BEGIN
                //      CopyText := 'Original For Receipient';
                //      OutputNo += 1;
                //    END;

                // CurrReport.PAGENO := 1; //PK_
            end;

            trigger OnPreDataItem()
            begin

                //CompanyInfo.CALCFIELDS(Picture1);
                IF OptionTyp = '' THEN BEGIN
                    IF RepTypeOpt = RepTypeOpt::"All Pages" THEN
                        NoOfCopies := 3
                    ELSE
                        NoOfCopies := 1;
                END ELSE
                    NoOfCopies := 1;
                NoOfLoops := NoOfCopies;
                IF NoOfLoops <= 0 THEN
                    NoOfLoops := 1;
                CopyText := '';
                SETRANGE(Number, 1, NoOfLoops);
                OutputNo := 1;
                PagesNo := 0; //LFS-AK-3376
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Report Type Filter")
                {
                }
                field("Report Type"; RepTypeOpt)
                {
                    ApplicationArea = All;

                }
                group("Report Options")
                {
                }
                /* field("View Serial Nos."; ViewSerialNo)
                {
                    ApplicationArea = All;
                }
                field("P.T.O"; PTOBool)
                {
                    ApplicationArea = All;
                }
                field(Narrtion; Narrtion)
                {
                    ApplicationArea = All;
                    Caption = 'Narrtion';
                }
                field("Run SerialNo REport"; RunSerialNoREport)
                {
                    ApplicationArea = All;
                } */
                field("Invoice Type"; InvoiceType)
                {
                    ApplicationArea = All;
                }
                // field("Header Text"; HeaderTxt)
                // {
                //     ApplicationArea = All;
                // }
            }
        }
    }

    trigger OnInitReport()
    begin
        PTOBool := FALSE;   //LFS-PPG-06964.01
        Div_Pages := 0; //LFS-AK-3376
    end;

    trigger OnPostReport()
    begin
        //LFS-AK-3651++
        IF RunSerialNoREport = TRUE THEN
            RunSalesInvSerialNoReport("Sales Invoice Header"."No.");
        //LFS-AK-3651--
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        // CompanyInfo.CALCFIELDS(Picture1);
        InvoiceRoundoff := 0;
    end;

    var
        Dispatch_PinCode: Code[20];
        RecVendor: Record Vendor;
        OrderAddress: Record "Order Address";
        DispLocation: Record Location;
        //QRCode B2C Start
        QRCodeInStreamB2C: InStream;
        QRTextB2C: Text;
        tempBlobB2C: Codeunit "Temp Blob";
        NewBlobB2C: Codeunit "Temp Blob";
        base64ConvertB2C: Codeunit "Base64 Convert";
        //Base64ConvertImpl: Codeunit "Base64 Convert Impl.";
        QrImageB2C: Text;
        QRGeneratorB2C: Codeunit "QR Generator";
        QrInstreamB2C: InStream;
        // RecEinvoiceB2C: Record "ClearTax Output List";
        EwayBillDateB2C: Text[50];
        EwayValidDateB2C: Text[50];

        // RecEinvoice1B2C: Record "ClearTax Output List";

        //QRCode B2C End

        //QRCode Start
        QRCodeInStream: InStream;
        QRText: Text;
        tempBlob: Codeunit "Temp Blob";
        NewBlob: Codeunit "Temp Blob";
        base64Convert: Codeunit "Base64 Convert";
        //Base64ConvertImpl: Codeunit "Base64 Convert Impl.";
        QrImage: Text;
        QRGenerator: Codeunit "QR Generator";
        QrInstream: InStream;
        // RecEinvoice: Record "ClearTax Output List";
        RecEinvoice: Record "e-Invoice Response";
        EwayBillDate: Text[50];
        EwayValidDate: Text[50];

        // RecEinvoice1: Record "ClearTax Output List";

        //QRCode End
        GSTLoction: Code[20];
        TotalGSTNew: Decimal;
        CompanyInfo: Record 79;
        Location: Record 14;
        Address: Text[50];
        Address2: Text[50];
        City: Text[50];
        StateCode: Code[10];
        StateDesc: Text[50];
        CountryCode: Code[10];
        PostCode: Code[20];
        PhNo: Text[30];
        FaxNo: Text[30];
        CEComm: Text[100];
        ECCNo: Code[20];
        EPGVAL: Code[10];
        chapno: Text[30];
        SIL: Record 113;
        customer: Record 18;
        CustTinNo: Code[20];
        CustCSTNo: Code[20];
        CustECCNo: Code[20];
        CustLiceNo: Text[50];
        CustGSTReg: Code[20];
        Date: Date;
        ship: Record 222;
        shiptin: Code[20];
        shipcst: Code[20];
        shipEccNo: Code[20];
        Shipdate: Date;
        SNo: Integer;
        TotNoOfPkgs: Decimal;
        upp: Decimal;
        TotalTotNoOfPkgs: Decimal;
        TotalQty: Decimal;
        TotalLineAmt: Decimal;
        TotalExciseAmt: Decimal;
        TotalAmtToCustomer: Decimal;
        // StructureLineDetails: Record "13798"; //Comm GST PK_13/01/25
        ChargesAmount: Decimal;
        OtherTaxesAmount: Decimal;
        paydesc: Text[50];
        paymentmethod: Record 289;
        creditperiod: Text[50];
        transport: Text[150];
        transporternm: Text[100];
        roadpermitno: Code[20];
        // RepCheck: array[2] of Report Check; //MRP_28/3/25
        //RepCheck: array[2] of Report "Check Report";
        NoTextExcise: array[2] of Text[80];
        NoText: array[2] of Text[80];
        Totalfin: Decimal;
        Text12: Label '"I/We hereby certify that my/our Registration certificate under the Maharashtra Value Added Tax Act , 2002 is in force on the date on which the sale of the goods specified in this tax invoice is made me/us and that the transaction of sale covered by this tax invoice has been affected by me/us and it shall be accounted for in the turnover of sales while filing of return and the due tax. If any payable on the sale has been paid or shall be paid."';
        Text13: Label 'Certified that the particulars given above are true & correct & the amount indicated represents the price actually charged and that there is no flow of additional consideration directly or indirectly from the buyer.';
        FormatAddr: Codeunit 365;
        CompanyAddr: array[8] of Text[50];
        ExDutyRate: Text[30];
        SalesInvLine1: Record 113;
        TotalTaxAmt: Decimal;
        FreAmt: Decimal;
        SpeAmt: Decimal;
        // RepTypeOpt: Option "All Pages","Original For Recipient","Duplicate For Supplier/Transporter","Triplicate For Supplier";
        RepTypeOpt: Option "Original For Recipient","Duplicate For Supplier/Transporter","Triplicate For Supplier","All Pages";
        CopyText: Text[100];
        VLE: Record 5802;
        ILE: Record 32;
        LOTNO: Code[20];
        LotQTY: Decimal;
        i: Integer;
        GlbItemNo: Code[20];
        InvoiceRoundoff: Decimal;
        Taxp: Text;
        TotalAmtToCustomerInvrounding: Decimal;
        TcsAmt: Decimal;
        InsuAmt: Decimal;
        TotalExciseAmt2: Decimal;
        Salesinvhrd: Record 112;
        SALESINVNO: Code[20];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        Cust_pan: Code[20];
        ship_pan: Code[20];
        Othercharge: Decimal;
        ctr: Integer;
        SrNo: Integer;
        CGSTPer: Decimal;
        CGSTAmt: Decimal;
        SGSTPer: Decimal;
        SGSTAmt: Decimal;
        IGSTPer: Decimal;
        IGSTAmt: Decimal;
        // DetailedGSTLedgerEntry: Record "16419";
        // State_: Record "13762";
        // RecState: Record "13762";
        // ShipState: Record "13762";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        State_: Record State;
        RecState: Record State;
        ShipState: Record State;
        ShipStateCode: Code[20];
        ShipStateDescr: Code[50];
        ShipToCode: Code[20];
        ReverseChg: Option Yes,No;
        ShipmentMethod: Record 10;
        FreightAmt: Decimal;
        PackingChrs: Decimal;
        InsuranAmt: Decimal;
        InterestAmt: Decimal;
        OtherChrgs: Decimal;
        ItemLedEntry: Record 32;
        SerialNos: Text;
        ValueEntry: Record 5802;
        ItemLedgEntry: Record 32;
        SalesShptLine: Record 111;
        // PostedSalesSerialNo: Record 50008;
        ViewSerialNo: Boolean;
        PTOBool: Boolean;
        billphnno: Text[50];
        shiptophoneno: Text[50];
        reccust: Record 18;
        qtytotal: Decimal;
        HSNCode: Code[15];
        serialNo1: Text;
        Rs: Text;
        Rs1: Text;
        serialNo2: Code[1024];
        Narrtion: Boolean;
        OptionTyp: Text;
        documntno: Code[20];
        PagesNo: Integer;
        Div_Pages: Integer;
        RunSerialNoREport: Boolean;
        TCSPer: Text;
        IRNNO: Text;
        // AckNo: Code[50];
        // AckDate: Date;
        // ClearTaxOutputList: Record 50005;
        ClearTaxOutputList: Record "e-Invoice Response";
        EWAYBill: Text;
        Customer_GRec: Record 18;
        CUstomerPAN: Code[20];
        CtrTExt: Text;
        companyNamenew: Text[250];
        CompanyNameOld: Text[250];
        showoldpic: Boolean;
        NoteTextforPrint: Text;
        Dimension: Record 480;
        DimValName: Text;
        TotalAmount: Decimal;
        TotalGSTBaseAmt: Decimal;
        CustGSTNo: Code[15];
        TotalAmtToCust: Decimal;
        InvoiceType: Option "TAX INVOICE","BILL OF SUPPLY","DEBIT NOTE";
        HeaderTxt: Text;
        //  AmountInWords: Text[300];
        AmountInWords1: Text[300];
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND ';
        WholeInWords: Text[300];
        DecimalInWords: Text[300];
        WholePart: Integer;
        DecimalPart: Integer;
        OnesText: array[20] of Text[90];
        TensText: array[10] of Text[90];
        ThousText: array[5] of Text[90];
        //Check_Rep: report Check;
        AmountInWordAED: Text;
        AmountInWordAED1: Text;
        AmountInWords: Text[300];

        Text029: Label '%1 results in a written number that is too long.';

        //>> AL
        IndianRupees1: Text[250];
        FinalAmt: Decimal;
        // IndianRupees: Text[250];
        IndianRupeesFinal: Text[250];
        convr: Report Check;

        ExponentText: array[5] of Text[30];
        atext: array[2] of Text[80];
        //RepCheck: Report "W_Check Report";
        //  NoTextExcise: array[2] of Text[80];
        //  NoText: array[2] of Text[80];//
        GLSetup: Record "General Ledger Setup";
        DimensionSetEntry: Record "Dimension Set Entry";
        TotalAmountNew: Decimal;

        SalesInvHdr: Record "Sales Invoice Header";
        IsCounted: Boolean;
        FromAction: Boolean;
        TaxCaption: Text;
        VATAmt: Decimal;
        VATEntry1: Record "VAT Entry";

    //TAX Caption
    local procedure GetTaxCaption(PostedSalesInvoiceHeader: Record "Sales Invoice Header"): Text
    var
        GSTLedgerEntry: Record "Detailed GST Ledger Entry";
        // WHTEntry: Record "WHT Entry";
        VATEntry: Record "VAT Entry";
        SalesInvLine: Record "Sales Invoice Line";
        GLAccount: Record "G/L Account";
    begin
        // Check GST first (India Localization)
        GSTLedgerEntry.SetRange("Document No.", PostedSalesInvoiceHeader."No.");
        // GSTLedgerEntry.SetRange("Line No.", PostedSalesInvoiceLine."Line No.");
        if not GSTLedgerEntry.IsEmpty() then
            exit('GST');

        // Check VAT
        VATEntry.SetRange("Document No.", PostedSalesInvoiceHeader."No.");
        if not VATEntry.IsEmpty() then begin
            SalesInvLine.Reset();
            SalesInvLine.SetRange("Document No.", PostedSalesInvoiceHeader."No.");
            SalesInvLine.SetFilter(Type, '%1|%2', SalesInvLine.Type::Item, SalesInvLine.Type::"G/L Account");
            if SalesInvLine.FindFirst() then begin
                GLAccount.Reset();
                GLAccount.SetRange("No.", SalesInvLine."No.");
                if GLAccount.FindFirst() then
                    if GLAccount."VAT Bus. Posting Group" = 'WHT' then
                        exit('WHT');
            end;

            //If its not WHT then
            exit('VAT');
        end;

        if PostedSalesInvoiceHeader."VAT Bus. Posting Group" = 'WHT' then
            exit('WHT');

        // Check WHT/TCS
        // WHTEntry.SetRange("Document No.", PostedSalesInvoiceLine."Document No.");
        // if not WHTEntry.IsEmpty() then
        //     exit('WHT');

        exit('Tax'); // fallback
    end;

    procedure SetFromAction(Value: Boolean) //tejasvi 6 march 26
    begin
        FromAction := Value;
    end;



    procedure setvalues(OptionType: Option "All Pages","Original For Recipient","Duplicate For Supplier/Transporter","Triplicate For Supplier"; docno: Code[20])
    begin
        OptionTyp := FORMAT(OptionType);
        documntno := docno;
    end;

    local procedure RunSalesInvSerialNoReport(DocNo: Code[20])
    var
        SalesInvLine: Record 113;
        Booln: Boolean;
        PostedSalesInvoice: Page 132;
    begin
        //LFS-AK-3651++
        SalesInvLine.RESET;
        SalesInvLine.SETRANGE("Document No.", DocNo);
        IF SalesInvLine.FINDFIRST THEN
            REPORT.RUNMODAL(50061, TRUE, FALSE, SalesInvLine);
        //LFS-AK-3651--
    end;

    procedure NumberInWordsUSD(number: Decimal; CurrencyName: Text[30]; DenomName: Text[30]): Text[300]
    begin
        WholePart := ROUND(ABS(number), 1, '<');
        DecimalPart := ABS((ABS(number) - WholePart) * 100);
        WholeInWords := NumberToWords(WholePart, CurrencyName);
        IF DecimalPart <> 0 THEN BEGIN
            DecimalInWords := NumberToWords(DecimalPart, 'Cents ');
            if (CurrencyName = 'USD') or (CurrencyName = '') then
                WholeInWords := WholeInWords + 'Dollars and ' + DecimalInWords
            Else
                WholeInWords := WholeInWords + ' and ' + DecimalInWords;
        END
        Else if (CurrencyName = 'USD') or (CurrencyName = '') then
            WholeInWords := WholeInWords + 'Dollars '
        else
            WholeInWords := WholeInWords;
        AmountInWords := DenomName + ' ' + WholeInWords + 'Only';
        EXIT(AmountInWords);
    end;

    //PK_24/04/26 ++
    procedure NumberInWordsAED(number: Decimal; CurrencyName: Text[30]; DenomName: Text[30]): Text[300]
    begin
        WholePart := ROUND(ABS(number), 1, '<');
        DecimalPart := ABS((ABS(number) - WholePart) * 100);
        // WholeInWords := NumberToWords(DecimalPart, CurrencyName);
        WholeInWords := NumberToWords(WholePart, CurrencyName);
        IF DecimalPart <> 0 THEN BEGIN
            DecimalInWords := NumberToWords(DecimalPart, 'fils ');
            if (CurrencyName = 'AED') or (CurrencyName = '') then
                // WholeInWords := 'Dirhams and ' + DecimalInWords
                WholeInWords := DecimalInWords

            Else
                WholeInWords := WholeInWords + ' and ' + DecimalInWords;
        END
        Else if (CurrencyName = 'AED') or (CurrencyName = '') then
            WholeInWords := WholeInWords + 'Dirhams '
        else
            WholeInWords := WholeInWords;
        //AmountInWords := DenomName + ' ' + WholeInWords + 'Only';
        AmountInWords := WholeInWords + 'Only';

        EXIT(AmountInWords);
    end;

    procedure NumberInWordsQAR(number: Decimal; CurrencyName: Text[30]; DenomName: Text[30]): Text[300]
    begin
        WholePart := ROUND(ABS(number), 1, '<');
        DecimalPart := ABS((ABS(number) - WholePart) * 100);
        WholeInWords := NumberToWords(WholePart, CurrencyName);
        IF DecimalPart <> 0 THEN BEGIN
            DecimalInWords := NumberToWords(DecimalPart, 'Dirham');
            if (CurrencyName = 'QAR') or (CurrencyName = '') then
                WholeInWords := WholeInWords + 'Qatar Riyals AND ' + DecimalInWords
            Else
                WholeInWords := WholeInWords + ' AND ' + DecimalInWords;
        END
        Else
            if (CurrencyName = 'QAR') or (CurrencyName = '') then
                WholeInWords := WholeInWords + 'Qatar Riyals '
            else
                WholeInWords := WholeInWords;
        AmountInWords := WholeInWords + ' Only';
        EXIT(AmountInWords);
    end;
    //PK_24/04/26 --

    procedure NumberToWords(number: Decimal; appendScale: Text[50]): Text[300]
    var
        numString: Text[300];
        pow: Integer;
        powStr: Text[50];
        log: Integer;
    begin
        numString := '';
        IF number < 100 THEN
            IF number < 20 THEN BEGIN
                IF number <> 0 THEN numString := OnesText[number];
            END
            ELSE BEGIN
                numString := TensText[number DIV 10];
                IF (number MOD 10) > 0 THEN numString := numString + ' ' + OnesText[number MOD 10];
            END
        ELSE BEGIN
            pow := 0;
            powStr := '';
            IF number < 1000 THEN BEGIN // number is between 100 and 1000
                pow := 100;
                powStr := ThousText[1];
            END
            ELSE BEGIN // find the scale of the number
                log := ROUND(STRLEN(FORMAT(number DIV 1000)) / 3, 1, '>');
                pow := POWER(1000, log);
                powStr := ThousText[log + 1];
            END;
            numString := NumberToWords(number DIV pow, powStr) + ' ' + NumberToWords(number MOD pow, '');
        END;
        EXIT(DELCHR(numString, '<>', ' ') + ' ' + appendScale);
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := 'One';
        OnesText[2] := 'Two';
        OnesText[3] := 'Three';
        OnesText[4] := 'Four';
        OnesText[5] := 'Five';
        OnesText[6] := 'Six';
        OnesText[7] := 'Seven';
        OnesText[8] := 'Eight';
        OnesText[9] := 'Nine';
        OnesText[10] := 'Ten';
        OnesText[11] := 'Eleven';
        OnesText[12] := 'Twelve';
        OnesText[13] := 'Thirteen';
        OnesText[14] := 'Fourteen';
        OnesText[15] := 'Fifteen';
        OnesText[16] := 'Sixteen';
        OnesText[17] := 'Seventeen';
        OnesText[18] := 'Eighteen';
        OnesText[19] := 'Nineteen';
        TensText[1] := '';
        TensText[2] := 'Twenty';
        TensText[3] := 'Thirty';
        TensText[4] := 'Forty';
        TensText[5] := 'Fifty';
        TensText[6] := 'Sixty';
        TensText[7] := 'Seventy';
        TensText[8] := 'Eighty';
        TensText[9] := 'Ninety';
        ThousText[1] := 'Hundred';
        ThousText[2] := 'Thousand';
        ThousText[3] := 'Million';
        ThousText[4] := 'Billion';
        ThousText[5] := 'Trillion';
    end;

    PROCEDURE "AmtInWords-Rupees"(Mamount: Decimal): Text[300];
    VAR
        paise: Integer;
        crore: Integer;
        lakh: Integer;
        thousand: Integer;
        hundred: Integer;
        rupee: Integer;
        intamount: Decimal;
        AMTTEXT: Text[300];
    BEGIN
        intamount := ROUND(Mamount, 1, '<');
        paise := (Mamount - intamount) * 100;
        crore := ROUND(Mamount / 10000000, 1, '<');
        Mamount := Mamount MOD 10000000;
        lakh := ROUND(Mamount / 100000, 1, '<');
        Mamount := Mamount MOD 100000;
        thousand := ROUND(Mamount / 1000, 1, '<');
        Mamount := Mamount MOD 1000;
        hundred := ROUND(Mamount / 100, 1, '<');
        rupee := ROUND((Mamount MOD 100), 1, '<');
        AMTTEXT += '';
        IF crore <> 0 THEN AMTTEXT += Rno(crore) + ' Crore ';
        IF lakh <> 0 THEN AMTTEXT += Rno(lakh) + ' Lakh ';
        IF thousand <> 0 THEN AMTTEXT += Rno(thousand) + ' Thousand ';
        IF hundred <> 0 THEN AMTTEXT += Rno(hundred) + ' Hundred ';
        IF rupee <> 0 THEN AMTTEXT += Rno(rupee) + ' ';
        IF paise <> 0 THEN
            AMTTEXT += 'And ' + Rno(paise) + ' ' + 'Paisa Only'
        ELSE
            AMTTEXT += 'And' + ' ' + 'Zero' + ' ' + 'Paisa Only';
        //AMTTEXT += '';
        //AMTTEXT += 'And ' + Rno(paise) + ' ' + 'Paisa Only';
        EXIT(AMTTEXT);
    END;

    PROCEDURE Rno(No: Integer): Text[30];
    BEGIN
        IF No = 0 THEN EXIT('Zero');
        IF No = 1 THEN EXIT('One');
        IF No = 2 THEN EXIT('Two');
        IF No = 3 THEN EXIT('Three');
        IF No = 4 THEN EXIT('Four');
        IF No = 5 THEN EXIT('Five');
        IF No = 6 THEN EXIT('Six');
        IF No = 7 THEN EXIT('Seven');
        IF No = 8 THEN EXIT('Eight');
        IF No = 9 THEN EXIT('Nine');
        IF No = 10 THEN EXIT('Ten');
        IF No = 11 THEN EXIT('Eleven');
        IF No = 12 THEN EXIT('Twelve');
        IF No = 13 THEN EXIT('Thirteen');
        IF No = 14 THEN EXIT('Fourteen');
        IF No = 15 THEN EXIT('Fifteen');
        IF No = 16 THEN EXIT('Sixteen');
        IF No = 17 THEN EXIT('Seventeen');
        IF No = 18 THEN EXIT('Eighteen');
        IF No = 19 THEN EXIT('Nineteen');
        IF No = 20 THEN EXIT('Twenty');
        IF No = 21 THEN EXIT('Twenty One');
        IF No = 22 THEN EXIT('Twenty Two');
        IF No = 23 THEN EXIT('Twenty Three');
        IF No = 24 THEN EXIT('Twenty Four');
        IF No = 25 THEN EXIT('Twenty Five');
        IF No = 26 THEN EXIT('Twenty Six');
        IF No = 27 THEN EXIT('Twenty Seven');
        IF No = 28 THEN EXIT('Twenty Eight');
        IF No = 29 THEN EXIT('Twenty Nine');
        IF No = 30 THEN EXIT('Thirty');
        IF No = 31 THEN EXIT('Thirty One');
        IF No = 32 THEN EXIT('Thirty Two');
        IF No = 33 THEN EXIT('Thirty Three');
        IF No = 34 THEN EXIT('Thirty Four');
        IF No = 35 THEN EXIT('Thirty Five');
        IF No = 36 THEN EXIT('Thirty Six');
        IF No = 37 THEN EXIT('Thirty Seven');
        IF No = 38 THEN EXIT('Thirty Eight');
        IF No = 39 THEN EXIT('Thirty Nine');
        IF No = 40 THEN EXIT('Forty');
        IF No = 41 THEN EXIT('Forty One');
        IF No = 42 THEN EXIT('Forty Two');
        IF No = 43 THEN EXIT('Forty Three');
        IF No = 44 THEN EXIT('Forty Four');
        IF No = 45 THEN EXIT('Forty Five');
        IF No = 46 THEN EXIT('Forty Six');
        IF No = 47 THEN EXIT('Forty Seven');
        IF No = 48 THEN EXIT('Forty Eight');
        IF No = 49 THEN EXIT('Forty Nine');
        IF No = 50 THEN EXIT('Fifty');
        IF No = 51 THEN EXIT('Fifty One');
        IF No = 52 THEN EXIT('Fifty Two');
        IF No = 53 THEN EXIT('Fifty Three');
        IF No = 54 THEN EXIT('Fifty Four');
        IF No = 55 THEN EXIT('Fifty Five');
        IF No = 56 THEN EXIT('Fifty Six');
        IF No = 57 THEN EXIT('Fifty Seven');
        IF No = 58 THEN EXIT('Fifty Eight');
        IF No = 59 THEN EXIT('Fifty Nine');
        IF No = 60 THEN EXIT('Sixty');
        IF No = 61 THEN EXIT('Sixty One');
        IF No = 62 THEN EXIT('Sixty Two');
        IF No = 63 THEN EXIT('Sixty Three');
        IF No = 64 THEN EXIT('Sixty Four');
        IF No = 65 THEN EXIT('Sixty Five');
        IF No = 66 THEN EXIT('Sixty Six');
        IF No = 67 THEN EXIT('Sixty Seven');
        IF No = 68 THEN EXIT('Sixty Eight');
        IF No = 69 THEN EXIT('Sixty Nine');
        IF No = 70 THEN EXIT('Seventy');
        IF No = 71 THEN EXIT('Seventy One');
        IF No = 72 THEN EXIT('Seventy Two');
        IF No = 73 THEN EXIT('Seventy Three');
        IF No = 74 THEN EXIT('Seventy Four');
        IF No = 75 THEN EXIT('Seventy Five');
        IF No = 76 THEN EXIT('Seventy Six');
        IF No = 77 THEN EXIT('Seventy Seven');
        IF No = 78 THEN EXIT('Seventy Eight');
        IF No = 79 THEN EXIT('Seventy Nine');
        IF No = 80 THEN EXIT('Eighty');
        IF No = 81 THEN EXIT('Eighty One');
        IF No = 82 THEN EXIT('Eighty Two');
        IF No = 83 THEN EXIT('Eighty Three');
        IF No = 84 THEN EXIT('Eighty Four');
        IF No = 85 THEN EXIT('Eighty Five');
        IF No = 86 THEN EXIT('Eighty Six');
        IF No = 87 THEN EXIT('Eighty Seven');
        IF No = 88 THEN EXIT('Eighty Eight');
        IF No = 89 THEN EXIT('Eighty Nine');
        IF No = 90 THEN EXIT('Ninety');
        IF No = 91 THEN EXIT('Ninety One');
        IF No = 92 THEN EXIT('Ninety Two');
        IF No = 93 THEN EXIT('Ninety Three');
        IF No = 94 THEN EXIT('Ninety Four');
        IF No = 95 THEN EXIT('Ninety Five');
        IF No = 96 THEN EXIT('Ninety Six');
        IF No = 97 THEN EXIT('Ninety Seven');
        IF No = 98 THEN EXIT('Ninety Eight');
        IF No = 99 THEN EXIT('Ninety Nine');
    END;
}

