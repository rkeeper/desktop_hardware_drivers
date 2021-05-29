unit ufpBaseProto_;

interface

uses
   Windows
  ,SysUtils
  ,Classes
  ,SimpleXML
  ,ufpDrivParamsXml
  ,uXMLcommon
  ,ufpFiscDocXml_
  ,ufpInitXmlReturn_
  ,ufpStatus
  ,uCommon
  ,uCallbacks
  ,uLog
  ,ufpResult_
  ,uUnFiscXml_
  ,ufpProgramXml_
  ,DateUtils
  ;

type
  TBaseProto = class
  public
    class function  MaxProtocolSupported: Integer;                                                                                     virtual;
    class function  MinProtocolSupported: Integer;                                                                                     virtual;
    procedure DriverOptions(out AsetOptions: TsetOptions);                                                                             virtual;
    procedure DriverMenu(AMenu: TMenu);                                                                                                virtual;
    function  DriverHardware(AHardware: THardware_tag; AResult: TUFRresult): Boolean;                                                  virtual;
    function  DriverDataFormat(ADataFormat: TDataFormat_tag; AResult: TUFRresult): Boolean;                                            virtual;
    function  DriverChangeFromTypeIndexes(AChangeFromTypeIndexes: TChangeFromTypeIndexes_tag; AResult: TUFRresult): Boolean;           virtual;
  public
    constructor Create(AParameters: TParameters; ACallBacks: TCallBacks; ALog: TLog; AResult: TUFRresult);                             virtual;
    destructor Destroy;                                                                                                                override;
    procedure BeforeLastInstanceDestroy;                                                                                               virtual; 
  protected
    FParameters: TParameters; //  ������ �� ���������, �������� ������ ������
    FCallBacks: TCallBacks; //  ������ �� ���������, �������� ������ ������
    FLog: TLog;             //  ������ �� ���������, �������� ������ ������
    FSkipResult: TUFRresult;
  public  //  �������� ������� ������ � ������ ��������
    function  PrintReceipt          (AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;        virtual;
    function  PrintCorrectionReceipt(AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;        virtual;
    function  PrintReceiptCopy      (AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;        virtual;
    function  PrintReport           (AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;        virtual;
    function  PrintCashInOut        (AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;        virtual;
    function  PrintCollectAll       (AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;        virtual;
    function  Custom                (AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRResult): Boolean;        virtual;
    function  PrintLog              (AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;        virtual;
    function  PrintUnfiscal         (AUnfiscal      : TUnfiscal_Tag      ;                       AResult: TUFRresult): Boolean;        virtual;
    function  Display               (AUnfiscal      : TUnfiscal_Tag      ;                       AResult: TUFRresult): Boolean;        virtual;
    function  OpenDrawer            (AiDrawerNum    : Integer            ;                       AResult: TUFRresult): Boolean;        virtual;
    function  Programming           (AProgramFR     : TProgramFR_Tag     ;                       AResult: TUFRResult): Boolean;        virtual;
    function  Started               (                                                            AResult: TUFRResult): Boolean;        virtual;
    function  MenuOperation(AMenuOperation: TMenuOperation; AMenuOperationResult: TMenuOperationResult; AResult: TUFRresult): Boolean; virtual;
    function  GetZReportData(out AZReportData: TZReportData; AResult: TUFRresult): Boolean;                                            virtual;
  public // ��������� ���������� �� ��
    function  GetStatus(AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;                                                           virtual;
  end;

implementation

{ TBaseProto }

constructor TBaseProto.Create(AParameters: TParameters; ACallBacks: TCallBacks; ALog: TLog; AResult: TUFRresult);
begin
  AResult.SetValue(errOk, '');
  FParameters := AParameters;
  FCallBacks := ACallBacks;
  FLog := ALog;

  FSkipResult := TUFRresult.Create;
end;

destructor TBaseProto.Destroy;
begin
  FreeAndNil(FSkipResult);

  inherited;
end;

procedure TBaseProto.BeforeLastInstanceDestroy;
begin

end;

class function TBaseProto.MaxProtocolSupported: Integer;
begin
  Result := iSelfVersion(2); // ������������ �������� �� 2-� ����� ������ c�. #76697
end;

class function TBaseProto.MinProtocolSupported: Integer;
begin
  Result := 0;
end;

procedure TBaseProto.DriverOptions(out AsetOptions: TsetOptions);
begin
  AsetOptions := [];
  //Include(AsetOptions, optText                ); // �� ������������ ��������� ������������ ������ (������������ ��������)
  //Include(AsetOptions, optZeroReceipt         ); // �� ������������ ������ �������� ���� (� ������� ����������)
  //Include(AsetOptions, optDeleteReceipt       ); // �� ������������ �������� ���� ��� �������
  //Include(AsetOptions, optZReport             ); // �� ������������ Z �����
  //Include(AsetOptions, optMoneyInOut          ); // �� ������������ ��������-������
  //Include(AsetOptions, optXReport             ); // �� ������������ X �����
  //Include(AsetOptions, optSpecialReport       ); // �� ������������ ����������� ������: ��������/���������������� ����� �� �����, �������� ����� �� ������.
  //Include(AsetOptions, optZeroSale            ); // �� ������������ ������ ������� � "�������" ������
  //Include(AsetOptions, optProgram             ); // �� ������������ ���������������� �������� [��� �������� �����]
  //Include(AsetOptions, optFullLastShift       ); // �� ������������ ���������� ��������� �����
  //Include(AsetOptions, optAllMoneyOut         ); // �� ������������ ������� ���� �����
  //Include(AsetOptions, optTextInReceipt       ); // �� ������������ ������������ ������ ������ ���� (������ <Header>)
  //Include(AsetOptions, optBarCodeInNotFisc    ); // �� ������������ ������ �����-���� � ������������ ����� ����
  //Include(AsetOptions, optZClearMoney         ); // Z-����� ������������� ������� ������� ����� � �����
  //Include(AsetOptions, optCheckCopy           ); // ���������� �������� - ����� ���� (���� ������ � ������)
  //Include(AsetOptions, optTextInLine          ); // �� ������������ ������������ ������ ������ ����� ���� (������ <Item> ��� <Payment> ��� <Discount>)
  //Include(AsetOptions, optItemDepartments     ); // �� ������������ ������ �� �������/�������
  //Include(AsetOptions, optOnlyFixed           ); // ������ ������ � ������� �������������������� ������� (RK7 � ���� ������ ���������� ����� "�����" �� ������� � ������ ������� � ������������� "���������" ���� � ������ �������), ������ - prim08 � ������ �������
  //Include(AsetOptions, optTextOpenShift       ); // �������, ��� ������������ ������ ��������� ���������� �����
  //Include(AsetOptions, optDrawerOpen          ); // �� ����� ��������� ����
  //Include(AsetOptions, optDrawerState         ); // �� ����� ���������� ��������� �����
  //Include(AsetOptions, optCustomerDisplay     ); // �� ������������ ����� �� ������� ����������
  //Include(AsetOptions, optSlip                ); // �� ������������ ������ �� ������
  //Include(AsetOptions, optCalcChange          ); // �� ������������ ���������� �����
  //Include(AsetOptions, optZWhenClosedShift    ); // �� ������������ ������ Z-������ ��� �������� �����
  //Include(AsetOptions, optAbsDiscountSum      ); // �� ������������ ���������� (�� ����������) ������/�������
  //Include(AsetOptions, optFiscInvoice         ); // �� ������������ ������ ����������� ���� ��� ����-�������
  //Include(AsetOptions, optCashRegValue        ); // �� ������������ ������� �������� �������� �������� ����������
  //Include(AsetOptions, optFixedNames          ); // �� ������� ������������ ��� ������� � ������� ���
  //Include(AsetOptions, optDeleteReturn        ); // (������ 1.1+) �� ������������ �������� �������� ��������
  //Include(AsetOptions, optDiscWithTaxes       ); // (������ 9+) �� ��������� ������ �� ��� ������ � ���������� ��������, ��������������, ������ ������ ����������� �� �������, � ������� �� ��� ���� ��������� ������, ����� ��� ����������� ������� ������� ������ ���� ��������� �� ������ (������� ������� ������ �� �����)
  //Include(AsetOptions, optCanIgnoreTaxes      ); // �� ����� ����� "��� �������", ����� �� ���������� ��� Taxes
  //Include(AsetOptions, optAbsItemDiscount     ); // (������ 11+) �� ����� �������� ������ �� �������, ��� ����� ������ ������ ����� ������ ��������� ����������, ���� �������� foAbsDiscountSum. ���� �������� foAbsItemDiscount � ��������� foAbsDiscountSum, �� �������� ������ ����������� �� ��������.
  //Include(AsetOptions, optAbsItemMarkup       ); // (������ 11+) �� ����� �������� ������� �� �������, ��� ����� ������ ������ ����� ������� ��������� ����������, ���� �������� foAbsDiscountSum. ���� �������� foAbsItemMarkup � ��������� foAbsDiscountSum, �� �������� ������� �������� � ������� �������� �� ������.
  //Include(AsetOptions, optAbsMarkupSum        ); // (������ 11+) �� ������������ ���������� (�� ����������)  ������� �� ���
  //Include(AsetOptions, optMaxOneMarkupDiscount); // (������ 16+) �� ������ ����� �������/������
  //Include(AsetOptions, optBill                ); // (������ 18+) �� �������� ���������� ��������� "����"
  //Include(AsetOptions, optCreateCloseOrder    ); // (������ 18+) �� �������� ���������� ��������� "�������� ������", "�������� ������"
  //Include(AsetOptions, optCorrection          ); // (������ 18+) �� �������� ���������� ��������� "��������� ������"
  //Include(AsetOptions, optReturnReceipt       ); // (������ 20+) �� �������� ���������� ��������� "������� �� ����"
  //Include(AsetOptions, optPayUngrouped        ); // (������ 24+) �� ������������ ������� �� ������� �������, ��������� � ��� Payment �������� ISOCode, Rate � OriginalValue
  //Include(AsetOptions, optLogger              ); // (������ 25+) ���������� ������������ �� ����������� ������ ������ ���������
  //Include(AsetOptions, optWorkWithoutPaper    ); // (������ 27+) ���������� ����� ��������� ���������� �������� ��� ������. ���� ��� �� ����������, ���� ������ ������������� PaperStatus
  //Include(AsetOptions, optCorrectPriceToPay   ); // (������ 32+) ���� ���� ������������ �������� 32 � ������� �������� ��� �����, ���� ������ ���������� ������� PriceToPay � ���, ����� PriceToPay * Quantity ����� ����� � ������ �� �������, ���� ����� ���, �� ����� ����������, ����� �� ����������, � ������� ����� ���������.
  //Include(AsetOptions, optRoundDiscountOnly   ); // (������ 32+) ���� ���������� ��� �����, �� ������������� ���������� ����������� ��������� ��������� ������� ��� ������� �� ��������� �����. ��� foAbsDiscountSum ��� foAbsItemDiscount ��������� �����������, �� ������ � �������� ���� foDiscWithTaxes.
  //Include(AsetOptions, optCorrectionReceipt   ); // (������ 35+) �� �������� ���������� ��������� "��� ���������" (������)
  //Include(AsetOptions, optOpenShiftReport     ); // (������ 48+) �� ����� ������ ����� OpenShiftReport - ����� �������� �����.
  //Include(AsetOptions, optCancelOrder         ); // (������ 57+) �� ����� �������� ���������� �������� CancelOrder
  //Include(AsetOptions, optCancelBill          ); // (������ 58+) ���������� �������� CancelBill - �������� ������ �����/�������
end;

procedure TBaseProto.DriverMenu(AMenu: TMenu);
{var
  eMenu: TeMenu;{}
begin
{  for eMenu := Low(TeMenu) to High(TeMenu) do AMenu.AddItem(TMenuItem_end_tag.Create(
    CodePageToUTF8(1251, sMenuCaption[eMenu]),
    sMenuGUID[eMenu],
    IntToStr(Integer(eMenu))
  ));{}
end;

function TBaseProto.DriverHardware(AHardware: THardware_tag; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function TBaseProto.DriverDataFormat(ADataFormat: TDataFormat_tag; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function TBaseProto.DriverChangeFromTypeIndexes(AChangeFromTypeIndexes: TChangeFromTypeIndexes_tag; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

//======= �������� ������� ��������� ���������� �� �� ==========================

function TBaseProto.GetStatus(AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

//======= �������� ������� ������ � ������ �������� ============================

function  TBaseProto.GetZReportData(out AZReportData: TZReportData; AResult: TUFRresult): Boolean;
begin
  AZReportData := nil;
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.MenuOperation(AMenuOperation: TMenuOperation; AMenuOperationResult: TMenuOperationResult; AResult: TUFRResult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.Programming(AProgramFR: TProgramFR_Tag; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.Started(AResult: TUFRResult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.PrintReceipt(AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.PrintCorrectionReceipt(AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.PrintReceiptCopy(AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.PrintReport(AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.PrintUnfiscal(AUnfiscal: TUnfiscal_Tag; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.PrintCashInOut(AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function TBaseProto.PrintCollectAll(AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.Custom(AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRResult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.Display(AUnfiscal: TUnfiscal_Tag; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function TBaseProto.PrintLog(AFiscalDocument: TFiscalDocument_Tag; AfpStatus: TfpStatus; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

function  TBaseProto.OpenDrawer(AiDrawerNum: Integer; AResult: TUFRresult): Boolean;
begin
  AResult.SetValue(errOk, '');
  Result := True;
end;

end.
