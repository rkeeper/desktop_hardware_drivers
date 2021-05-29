unit ufpInitXmlReturn_;

interface

uses
   SysUtils
  ,Simplexml
  ,uUnFiscXml_
  ,uCommon
  ;

type  //  ���������� �������� �� ���������!
  TeOption = (
     optText                  // �� ������������ ��������� ������������ ������ (�� � ����)
    ,optZeroReceipt           // �� ������������ ������ �������� ���� (� ������� ����������)
    ,optDeleteReceipt         // �� ������������ �������� ����
    ,optZReport               // �� ������������ Z �����
    ,optMoneyInOut            // �� ������������ ��������-������
    ,optXReport               // �� ������������ X �����
    ,optSpecialReport         // �� ������������ ����������� ������: - ��������/���������������� ����� �� �����; - �������� ����� �� ������.
    ,optZeroSale              // �� ������������ ������ ������� � "�������" ������
    ,optProgram               // �� ������������ ���������������� �������� [��� �������� �����]
    ,optFullLastShift         // �� ������������ ���������� ��������� �����
    ,optAllMoneyOut           // �� ������������ ������� ���� �����
    ,optTextInReceipt         // �� ������������ ������������ ������ ������ ���� (������ <Header>)
    ,optBarCodeInNotFisc      // �� ������������ ������ �����-���� � ������������ ����� ����
    ,optZClearMoney           // Z ����� ������������� ������� ������� ����� � �����
    ,optCheckCopy             // ���������� �������� - ����� ���� (���� ������ � ������)
    ,optTextInLine            // �� ������������ ������������ ������ ������ ����� ���� (������ <Item> ��� <Payment> ��� <Discount>)
    ,optItemDepartments       // �� ������������ ������ �� �������/�������
    ,optOnlyFixed             // ������ ������ � ������� �������������������� ������� (RK7 � ���� ������ ���������� ����� "�����" �� ������� � ������ ������� � ������������� "���������" ���� � ������ �������)
    ,optTextOpenShift         // �������, ��� ������������ ������ ��������� ���������� �����
    ,optDrawerOpen            // ����� ��������� ����
    ,optDrawerState           // ����� ���������� ��������� �����
    ,optCustomerDisplay       // ������������ ����� �� ������� ����������
    ,optSlip                  // ������������ ������ �� ������
    ,optCalcChange            // �� ������������ ���������� �����
    ,optZWhenClosedShift      // �� ������������ ������ Z-������ ��� �������� �����
    ,optAbsDiscountSum        // �� ������������ ���������� �������� ������(�� ������ 11 ��������� ����� ����� �������� ��������� � foAbsItemDiscount, foAbsItemMarkup, foAbsMarkupSum)
    ,optFiscInvoice           // �� ������������ ������ ����������� ���� ��� ����-�������
    ,optCashRegValue          // �� ������������ ������� �������� �������� �������� ����������
    ,optFixedNames            // �� ������� ������������ ��� ������� � ������� ���
    ,optDeleteReturn          // (������ 1.1+) �� ������������ �������� �������� ��������
    ,optDiscWithTaxes         // (������ 9+) �� ��������� ������ �� ��� ������ � ���������� ��������, ��������������, ������ ������ ����������� �� �������,   � ������� �� ��� ���� ��������� ������, ����� ��� ����������� ������� ������� ������ ���� ��������� �� ������ (������� ������� ������ �� �����)
    ,optCanIgnoreTaxes        // �� ����� ����� "��� �������", ����� �� ���������� ��� Taxes
    ,optAbsItemDiscount       // (������ 11+) �� ����� �������� ������ �� �������, ��� ����� ������ ������ ����� ������ ��������� ����������, ���� �������� foAbsDiscountSum. ���� �������� foAbsItemDiscount � ��������� foAbsDiscountSum, �� �������� ������ ����������� �� ��������.
    ,optAbsItemMarkup         // (������ 11+) �� ����� �������� ������� �� �������, ��� ����� ������ ������ ����� ������� ��������� ����������, ���� �������� foAbsDiscountSum. ���� �������� foAbsItemMarkup � ��������� foAbsDiscountSum, �� �������� ������� �������� � ������� �������� �� ������.
    ,optAbsMarkupSum          // (������ 11+) �� ������������ ���������� (�� ����������) ������� �� ���
    ,optMaxOneMarkupDiscount  // (������ 16+) �� ������ ����� �������/������
    ,optBill                  // (������ 18+) �� �������� ���������� ��������� "����"
    ,optCreateCloseOrder      // (������ 18+) �� �������� ���������� ��������� "�������� ������", "�������� ������"
    ,optCorrection            // (������ 18+) �� �������� ���������� ��������� "��������� ������"
    ,optReturnReceipt         // (������ 20+) �� �������� ���������� ��������� "������� �� ����"
    ,optPayUngrouped          // (������ 24+) �� ������������ ������� �� ������� �������, ��������� � ��� Payment �������� ISOCode, Rate � OriginalValue
    ,optLogger                // (������ 25+) ���������� ������������ �� ����������� ������ ������ ���������
    ,optWorkWithoutPaper      // (������ 27+) ���������� ����� ��������� ���������� �������� ��� ������. ���� ��� �� ����������, ���� ������ ������������� PaperStatus
    ,optCorrectPriceToPay     // (������ 32+) ���� ���� ������������ �������� 32 � ������� �������� ��� �����, ���� ������ ���������� ������� PriceToPay � ���, ����� PriceToPay * Quantity ����� ����� � ������ �� �������, ���� ����� ���, �� ����� ����������, ����� �� ����������, � ������� ����� ���������.
    ,optRoundDiscountOnly     // (������ 32+) ���� ���������� ��� �����, �� ������������� ���������� ����������� ��������� ��������� ������� ��� ������� �� ��������� �����. ��� foAbsDiscountSum ��� foAbsItemDiscount ��������� �����������, �� ������ � �������� ���� foDiscWithTaxes.
    ,optCorrectionReceipt     // (������ 35+) �� �������� ���������� ��������� "��� ���������" (������)
    ,optManyCashInOutPayments // (������ 40+) �� ����� ��������� ��������� ����� �������� � ����� ��������� CashInOut. ���� �� �������, �� ��� Payment ������ ���� ������ ����.
    ,optOpenShiftReport       // (������ 48+) �� ����� ������ ����� OpenShiftReport - ����� �������� �����.
    ,optCancelOrder           // (������ 57+) �� ����� �������� ���������� �������� CancelOrder
    ,optCancelBill            // (������ 58+) �� ����� �������� ���������� �������� CancelBill - �������� ������ �����/�������
  );
  TsetOptions = set of TeOption;
const
  S_OPTION: array[TeOption] of UTF8String = (
     'Text'
    ,'ZeroReceipt'
    ,'DeleteReceipt'
    ,'ZReport'
    ,'MoneyInOut'
    ,'XReport'
    ,'SpecialReport'
    ,'ZeroSale'
    ,'Program'
    ,'FullLastShift'
    ,'AllMoneyOut'
    ,'TextInReceipt'
    ,'BarCodeInNotFisc'
    ,'ZClearMoney'
    ,'CheckCopy'
    ,'TextInLine'
    ,'ItemDepartments'
    ,'OnlyFixed'
    ,'TextOpenShift'
    ,'DrawerOpen'
    ,'DrawerState'
    ,'CustomerDisplay'
    ,'Slip'
    ,'CalcChange'
    ,'ZWhenClosedShift'
    ,'AbsDiscountSum'
    ,'FiscInvoice'
    ,'CashRegValue'
    ,'FixedNames'
    ,'DeleteReturn'
    ,'DiscWithTaxes'
    ,'CanIgnoreTaxes'
    ,'AbsItemDiscount'
    ,'AbsItemMarkup'
    ,'AbsMarkupSum'
    ,'MaxOneMarkupDiscount' //  � ������ 16
    ,'Bill'              // (������ 18+)
    ,'CreateCloseOrder'  // (������ 18+)
    ,'Correction'        // (������ 18+)
    ,'ReturnReceipt'     // (������ 20+) �� �������� ���������� ��������� "������� �� ����"
    ,'PayUngrouped'      // (������ 24+) �� ������������ ������� �� ������� �������, ��������� � ��� Payment �������� ISOCode, Rate � OriginalValue
    ,'Logger'            // (������ 25+) ���������� ������������ �� ����������� ������ ������ ���������
    ,'WorkWithoutPaper'  // (������ 27+) ���������� ����� ��������� ���������� �������� ��� ������. ���� ��� �� ����������, ���� ������ ������������� PaperStatus
    ,'CorrectPriceToPay' // (������ 32+) ���� ���� ������������ �������� 32 � ������� �������� ��� �����, ���� ������ ���������� ������� PriceToPay � ���, ����� PriceToPay * Quantity ����� ����� � ������ �� �������, ���� ����� ���, �� ����� ����������, ����� �� ����������, � ������� ����� ���������.
    ,'RoundDiscountOnly' // (������ 32+) ���� ���������� ��� �����, �� ������������� ���������� ����������� ��������� ��������� ������� ��� ������� �� ��������� �����. ��� foAbsDiscountSum ��� foAbsItemDiscount ��������� �����������, �� ������ � �������� ���� foDiscWithTaxes.
    ,'CorrectionReceipt' // (������ 35+) �� �������� ���������� ��������� "��� ���������" (������)
    ,'ManyCashInOutPayments' // (������ 40+) �� ����� ��������� ��������� ����� �������� � ����� ��������� CashInOut. ���� �� �������, �� ��� Payment ������ ���� ������ ����.
    ,'OpenShiftReport'       // (������ 48+) �� ����� ������ ����� OpenShiftReport - ����� �������� �����.
    ,'CancelOrder'           // (������ 57+) �� ����� �������� ���������� �������� CancelOrder
    ,'CancelBill'            // (������ 58+) �� ����� �������� ���������� �������� CancelBill - �������� ������ �����/�������
  );
const
  I6_OPTION: array[TeOption] of Int64 = (
     $00000000000001 // Text                  �� ������������ ��������� ������������ ������ (�� � ����)
    ,$00000000000002 // ZeroReceipt           �� ������������ ������ �������� ���� (� ������� ����������)
    ,$00000000000004 // DeleteReceipt         �� ������������ �������� ����
    ,$00000000000008 // ZReport               �� ������������ Z �����
    ,$00000000000010 // MoneyInOut            �� ������������ ��������-������
    ,$00000000000020 // XReport               �� ������������ X �����
    ,$00000000000040 // SpecialReport         �� ������������ ����������� ������: - ��������/���������������� ����� �� �����; - �������� ����� �� ������.
    ,$00000000000080 // ZeroSale              �� ������������ ������ ������� � "�������" ������
    ,$00000000000100 // Program               �� ������������ ���������������� �������� [��� �������� �����]
    ,$00000000000200 // FullLastShift         �� ������������ ���������� ��������� �����
    ,$00000000000400 // AllMoneyOut           �� ������������ ������� ���� �����
    ,$00000000000800 // TextInReceipt         �� ������������ ������������ ������ ������ ���� (������ <Header>)
    ,$00000000001000 // BarCodeInNotFisc      �� ������������ ������ �����-���� � ������������ ����� ����
    ,$00000000002000 // ZClearMoney           Z ����� ������������� ������� ������� ����� � �����
    ,$00000000004000 // CheckCopy             ���������� �������� - ����� ���� (���� ������ � ������)
    ,$00000000008000 // TextInLine            �� ������������ ������������ ������ ������ ����� ���� (������ <Item> ��� <Payment> ��� <Discount>)
    ,$00000000010000 // ItemDepartments       �� ������������ ������ �� �������/�������
    ,$00000000020000 // OnlyFixed             ������ ������ � ������� �������������������� ������� (RK7 � ���� ������ ���������� ����� "�����" �� ������� � ������ ������� � ������������� "���������" ���� � ������ �������)
    ,$00000000040000 // TextOpenShift         �������, ��� ������������ ������ ��������� ���������� �����
    ,$00000000080000 // DrawerOpen            ����� ��������� ����
    ,$00000000100000 // DrawerState           ����� ���������� ��������� �����
    ,$00000000200000 // CustomerDisplay       ������������ ����� �� ������� ����������
    ,$00000000400000 // Slip                  ������������ ������ �� ������
    ,$00000000800000 // CalcChange            �� ������������ ���������� �����
    ,$00000001000000 // ZWhenClosedShift      �� ������������ ������ Z-������ ��� �������� �����
    ,$00000002000000 // AbsDiscountSum        �� ������������ ���������� �������� ������(�� ������ 11 ��������� ����� ����� �������� ��������� � foAbsItemDiscount, foAbsItemMarkup, foAbsMarkupSum)
    ,$00000004000000 // FiscInvoice           �� ������������ ������ ����������� ���� ��� ����-�������
    ,$00000008000000 // CashRegValue          �� ������������ ������� �������� �������� �������� ����������
    ,$00000010000000 // FixedNames            �� ������� ������������ ��� ������� � ������� ���
    ,$00000020000000 // DeleteReturn          (������ 1.1+) �� ������������ �������� �������� ��������
    ,$00000040000000 // DiscWithTaxes         (������ 9+) �� ��������� ������ �� ��� ������ � ���������� ��������, ��������������, ������ ������ ����������� �� �������, � ������� �� ��� ���� ��������� ������, ����� ��� ����������� ������� ������� ������ ���� ��������� �� ������ (������� ������� ������ �� �����)
    ,$00000080000000 // CanIgnoreTaxes        �� ����� ����� "��� �������", ����� �� ���������� ��� Taxes
    ,$00000100000000 // AbsItemDiscount       (������ 11+) �� ����� �������� ������ �� �������, ��� ����� ������ ������ ����� ������ ��������� ����������, ���� �������� foAbsDiscountSum. ���� �������� foAbsItemDiscount � ��������� foAbsDiscountSum, �� �������� ������ ����������� �� ��������.
    ,$00000200000000 // AbsItemMarkup         (������ 11+) �� ����� �������� ������� �� �������, ��� ����� ������ ������ ����� ������� ��������� ����������, ���� �������� foAbsDiscountSum. ���� �������� foAbsItemMarkup � ��������� foAbsDiscountSum, �� �������� ������� �������� � ������� �������� �� ������.
    ,$00000400000000 // AbsMarkupSum          (������ 11+) �� ������������ ���������� (�� ����������) ������� �� ���
    ,$00000800000000 // MaxOneMarkupDiscount  (������ 16+) �� ������ ����� �������/������
    ,$00001000000000 // Bill                  (������ 18+) �� �������� ���������� ��������� "����"
    ,$00002000000000 // CreateCloseOrder      (������ 18+) �� �������� ���������� ��������� "�������� ������", "�������� ������"
    ,$00004000000000 // Correction            (������ 18+) �� �������� ���������� ��������� "��������� ������"
    ,$00008000000000 // ReturnReceipt         (������ 20+) �� �������� ���������� ��������� "������� �� ����"
    ,$00010000000000 // PayUngrouped          (������ 24+) �� ������������ ������� �� ������� �������, ��������� � ��� Payment �������� ISOCode, Rate � OriginalValue
    ,$00020000000000 // Logger                (������ 25+) ���������� ������������ �� ����������� ������ ������ ���������
    ,$00040000000000 // WorkWithoutPaper      (������ 27+) ���������� ����� ��������� ���������� �������� ��� ������. ���� ��� �� ����������, ���� ������ ������������� PaperStatus
    ,$00080000000000 // CorrectPriceToPay     (������ 32+) ���� ���� ������������ �������� 32 � ������� �������� ��� �����, ���� ������ ���������� ������� PriceToPay � ���, ����� PriceToPay * Quantity ����� ����� � ������ �� �������, ���� ����� ���, �� ����� ����������, ����� �� ����������, � ������� ����� ���������.
    ,$00100000000000 // RoundDiscountOnly     (������ 32+) ���� ���������� ��� �����, �� ������������� ���������� ����������� ��������� ��������� ������� ��� ������� �� ��������� �����. ��� foAbsDiscountSum ��� foAbsItemDiscount ��������� �����������, �� ������ � �������� ���� foDiscWithTaxes.
    ,$00200000000000 // CorrectionReceipt     (������ 35+) �� �������� ���������� ��������� "��� ���������" (������)
    ,$00400000000000 // ManyCashInOutPayments (������ 40+) �� ����� ��������� ��������� ����� �������� � ����� ��������� CashInOut. ���� �� �������, �� ��� Payment ������ ���� ������ ����.
    ,$00800000000000 // OpenShiftReport       (������ 48+) �� ����� ������ ����� OpenShiftReport - ����� �������� �����.
    ,$01000000000000 // CancelOrder           (������ 57+) �� ����� �������� ���������� �������� CancelOrder
    ,$02000000000000 // CancelBill            (������ 58+) �� ����� �������� ���������� �������� CancelBill - �������� ������ �����/�������
  );

type // ���������� �������� �� ���������!
  TeDialogType = (
     dlgtDateInterval
    ,dlgtNumberInterval
    ,dlgtOneDate
    ,dlgtOneNumber
  );
const
  S_DIALOG_TYPE: array[TeDialogType] of UTF8String = (
     'DateInterval'
    ,'NumberInterval'
    ,'OneDate'
    ,'OneNumber'
  );

type
  TDialogInfo_tag = class
  private
    FeDialogType: TeDialogType;
    FusCaption: UTF8String; //  �� ������������
  public
    constructor Create(AeDialogType: TeDialogType; const AusCaption: UTF8String = '');
    function ToXML: IXmlNode;
  end;

  TMenuItem_tag = class
  private
    FusCaption: UTF8String; //  ������������
  public
    function ToXML: IXmlNode; virtual; abstract;
  end;

  TMenuItem_end_tag = class(TMenuItem_tag)
  private
    FusOperationId: UTF8String; //  {123E720F-BAFC-453F-9948-50662663F75C} - ������������ ��� ������������ ������ ����
    FusParameter: UTF8String; //  "12345" - �����, �� ������������, ���� ���� ����� ���������� ��� ������ � parameter
    FusPurposeToLock: UTF8String; //  {7DA9C7F9-7DAE-462F-9FC5-113E2E3810B2} - ���������� ������, ����� ����������� ������� � ����� ���������� ����� ������������, �� ������������, ({7DA9C7F9-7DAE-462F-9FC5-113E2E3810B2} - � RK7 "��� ��������")
    FusUserRight: UTF8String; //  {A4C4606D-F7C4-4FBF-83D7-00AD12DD7E55} - ���������������� �����, ������� ����� ����������� ����� �����������, �� ������������
  private
    FDialogInfo: TDialogInfo_tag;
  public
    constructor Create(const AusCaption: UTF8String;
                       const AusOperationId: UTF8String;
                       const AusParameter: UTF8String = '';
                       const AusPurposeToLock: UTF8String = '';
                       const AusUserRight: UTF8String = '';
                       ADialogInfo: TDialogInfo_tag = nil);
    function ToXML: IXmlNode; override;
    destructor Destroy; override;
  end;

  TMenuItem_node_tag = class(TMenuItem_tag)
  private
    FarMenuItem: array of TMenuItem_tag;
  public
    constructor Create(const AusCaption: UTF8String);
    function ToXML: IXmlNode; override;
    procedure AddItem(AMenuItem: TMenuItem_tag);
    destructor Destroy; override;
  end;

  TMenu = class
  private
    FarMenuItem: array of TMenuItem_tag;
  public
    function ToXML: IXmlNode;
    procedure AddItem(AMenuItem: TMenuItem_tag);
    destructor Destroy; override;
  end;

type
  TDialogInfo_oper_tag = class
  private
    FusFrom: UTF8String;
    FusTo: UTF8String;
    function fGeti6(const AsCaption, AsValue: AnsiString): Int64;
    function fGetdt(const AsCaption, AsValue: AnsiString): TDateTime;
    function GetdtFrom: TDateTime;
    function GetdtTo: TDateTime;
    function Geti6From: Int64;
    function Geti6To: Int64;
  public
    constructor Create(AndDialogInfo: IXmlNode);
  public
    property usFrom: UTF8String read FusFrom;
    property usTo  : UTF8String read FusTo  ;
    property dtFrom: TDateTime read GetdtFrom;
    property dtTo  : TDateTime read GetdtTo  ;
    property i6From: Int64 read Geti6From;
    property i6To  : Int64 read Geti6To  ;
  end;

  TMenuOperation = class
  private
    FusOperationId: UTF8String; //  "5B3F851D-1C75-41C1-B3B3-B0927E49D3ED"
    FusParameter: UTF8String; //  "12345"
    FDialogInfo_oper: TDialogInfo_oper_tag;
  public
    constructor Create(ApcXMLData: PAnsiChar; out AusError: UTF8String);
    destructor Destroy; override;
  public
    property usOperationId: UTF8String read FusOperationId;
    property usParameter  : UTF8String read FusParameter  ;
    property DialogInfo_oper: TDialogInfo_oper_tag read FDialogInfo_oper;
  end;

type
  TFiscal_tag = class
  private
    FusEndDate: UTF8String; // "2020-12-23" ���� ��������� ������ (������ ����, ����� �� ����� ��������) ����������� ���������� (� ��� ��������), ��� ������������� ��������� - �� ��������� �������
  public
    constructor Create;
  public
    function  ToXML: IXmlNode;
    procedure SetEndDate(AdtEndDate: TDateTime);
    property  usEndDate: UTF8String read FusEndDate;
  end;

type
  THardware_tag = class
  private
    FFiscal: TFiscal_tag;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function ToXML: IXmlNode;
    property Fiscal: TFiscal_tag read FFiscal;
  end;

type
  TRounding_tag = class
  private
    Fi6Multiplier: Int64;
  public
    constructor Create;
    function ToXML: IXmlNode;
    property Multiplier: Int64 read Fi6Multiplier write Fi6Multiplier;
  end;

  TDataFormat_tag = class
  private
    FRounding: TRounding_tag;
  public
    constructor Create;
    destructor Destroy; override;
    function ToXML: IXmlNode;
    property Rounding: TRounding_tag  read FRounding;
  end;

type
  TChangeFromTypeIndexes_tag = class
  private
    FarIndexes: array of Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function ToXML: IXmlNode;
    procedure Clear;
    procedure Add(AiIndex: Integer);
  end;

type
  TUFRInitXMLReturn = class
  private
    FiProtocolVersion: Integer;
    FsVersionInfo: AnsiString;
    FsName: AnsiString;
    FsetOptions: TsetOptions;
    FMenu: TMenu;
    FHardware: THardware_tag;
    FDataFormat: TDataFormat_tag;
    FChangeFromTypeIndexes: TChangeFromTypeIndexes_tag;
  public
    constructor Create(AsetOptions: TsetOptions; AiProtocolVersion: Integer; AsName: AnsiString = ''; AsVersionInfo: AnsiString = ''); overload;
    constructor Create(ADriverOptionsMask: Int64; AiProtocolVersion: Integer; AsName: AnsiString = ''; AsVersionInfo: AnsiString = ''); overload;
    destructor Destroy; override;
    function  ToXML: UTF8String;
  public
    property Menu: TMenu read FMenu;
    property Hardware: THardware_tag read FHardware;
    property DataFormat:TDataFormat_tag read FDataFormat;
    property ChangeFromTypeIndexes:TChangeFromTypeIndexes_tag read FChangeFromTypeIndexes;
  end;

type
  TMenuOperationResult = class
  private
    FusOperationId: UTF8String;
//    FPrintUnfiscal: TPrintUnfiscal;
  public
    constructor Create(const AusOperationId: UTF8String);
    destructor Destroy; override;
    function  ToXML: UTF8String;
//  public
//    property PrintUnfiscal: TPrintUnfiscal read FPrintUnfiscal;
  end;

implementation

{ TDialogInfo }

constructor TDialogInfo_tag.Create(AeDialogType: TeDialogType; const AusCaption: UTF8String);
begin
  FeDialogType := AeDialogType;
  FusCaption := AusCaption;
end;

function TDialogInfo_tag.ToXML: IXmlNode;
begin
  Result := CreateXmlElement('DIALOGINFO');

  Result.SetAttr('dialogType', S_DIALOG_TYPE[FeDialogType]);
  if FusCaption <> '' then Result.SetAttr('caption', FusCaption);
end;

{ TMenuItem_end }

constructor TMenuItem_end_tag.Create(const AusCaption, AusOperationId, AusParameter, AusPurposeToLock, AusUserRight: UTF8String; ADialogInfo: TDialogInfo_tag);
begin
  FusCaption := AusCaption;
  FusOperationId   := AusOperationId;
  FusParameter     := AusParameter;
  FusPurposeToLock := AusPurposeToLock;
  FusUserRight     := AusUserRight;

  FDialogInfo := ADialogInfo;
end;

destructor TMenuItem_end_tag.Destroy;
begin
  FDialogInfo.Free;
  
  inherited;
end;

function TMenuItem_end_tag.ToXML: IXmlNode;
begin
  Result := CreateXmlElement('MENUITEM');

  Result.SetAttr('caption', FusCaption);
  if FusOperationId   <> '' then Result.SetAttr('operationId', FusOperationId);
  if FusParameter     <> '' then Result.SetAttr('parameter', FusParameter);
  if FusPurposeToLock <> '' then Result.SetAttr('purposeToLock', FusPurposeToLock);
  if FusUserRight     <> '' then Result.SetAttr('userRight', FusUserRight);

  if Assigned(FDialogInfo) then Result.AppendChild(FDialogInfo.ToXML);
end;

{ TMenuItem_node }

procedure TMenuItem_node_tag.AddItem(AMenuItem: TMenuItem_tag);
begin
  SetLength(FarMenuItem, Length(FarMenuItem) + 1);
  FarMenuItem[High(FarMenuItem)] := AMenuItem;
end;

constructor TMenuItem_node_tag.Create(const AusCaption: UTF8String);
begin
  FusCaption := AusCaption;
end;

destructor TMenuItem_node_tag.Destroy;
var
  i: Integer;
begin
  for i := Low(FarMenuItem) to High(FarMenuItem) do FarMenuItem[i].Free;

  inherited;
end;

function TMenuItem_node_tag.ToXML: IXmlNode;
var
  i: Integer;
begin
  Result := CreateXmlElement('MENUITEM');

  Result.SetAttr('caption', FusCaption);

  for i := Low(FarMenuItem) to High(FarMenuItem) do Result.AppendChild(FarMenuItem[i].ToXML);
end;

{ TMenu }

procedure TMenu.AddItem(AMenuItem: TMenuItem_tag);
begin
  SetLength(FarMenuItem, Length(FarMenuItem) + 1);
  FarMenuItem[High(FarMenuItem)] := AMenuItem;
end;

destructor TMenu.Destroy;
var
  i: Integer;
begin
  for i := Low(FarMenuItem) to High(FarMenuItem) do FarMenuItem[i].Free;

  inherited;
end;

function TMenu.ToXML: IXmlNode;
var
  i: Integer;
begin
  Result := CreateXmlElement('MENU');

  for i := Low(FarMenuItem) to High(FarMenuItem) do Result.AppendChild(FarMenuItem[i].ToXML);
end;

{ TDialogInfo_oper }

constructor TDialogInfo_oper_tag.Create(AndDialogInfo: IXmlNode);
begin
  FusFrom := AndDialogInfo.GetAttr('from');
  FusTo := AndDialogInfo.GetAttr('to');
end;

function TDialogInfo_oper_tag.fGeti6(const AsCaption, AsValue: AnsiString): Int64;
begin
  if not TryStrToInt64(AsValue, Result) then raise Exception.CreateFmt('Wrong "%s" integer value %s', [AsCaption, AsValue]);
end;

function TDialogInfo_oper_tag.fGetdt(const AsCaption, AsValue: AnsiString): TDateTime;
var
  sError: AnsiString;
begin
  sError := ParseDate(AsValue, 'yyyy-mm-dd', Result);
  if sError <> '' then raise Exception.CreateFmt('Wrong "%s" date value %s: %s', [AsCaption, AsValue, sError]);
end;

function TDialogInfo_oper_tag.GetdtFrom: TDateTime;
begin
  Result := fGetdt('from', FusFrom);
end;

function TDialogInfo_oper_tag.GetdtTo: TDateTime;
begin
  Result := fGetdt('to', FusTo);
end;

function TDialogInfo_oper_tag.Geti6From: Int64;
begin
  Result := fGeti6('from', FusFrom);
end;

function TDialogInfo_oper_tag.Geti6To: Int64;
begin
  Result := fGeti6('to', FusTo);
end;

{ TMenuOperation }

constructor TMenuOperation.Create(ApcXMLData: PAnsiChar; out AusError: UTF8String);
var
  XmlDocument: IXmlDocument;
  ndMenuOperation: IXmlNode;
  ndDIALOGINFO: IXmlNode;
begin
  XmlDocument := CreateXmlDocument('', '1.0', 'utf-8');
  try
    XmlDocument.LoadXML(ApcXMLData);
  except
    on E: Exception do begin
      AusError := 'MenuOperation xml loading syntax error: ' + E.Message;
      Exit;
    end;
  end;
  ndMenuOperation := XmlDocument.DocumentElement;

  FusOperationId := ndMenuOperation.GetAttr('operationId');
  FusParameter   := ndMenuOperation.GetAttr('parameter');

  ndDIALOGINFO := ndMenuOperation.SelectSingleNode('DIALOGINFO');
  if Assigned(ndDIALOGINFO) then FDialogInfo_oper := TDialogInfo_oper_tag.Create(ndDIALOGINFO) else FDialogInfo_oper := nil;

  AusError := '';
end;

destructor TMenuOperation.Destroy;
begin
  FDialogInfo_oper.Free;
  
  inherited;
end;

{ TUFRInitXMLReturn }

constructor TUFRInitXMLReturn.Create(AsetOptions: TsetOptions; AiProtocolVersion: Integer; AsName: AnsiString = ''; AsVersionInfo: AnsiString = '');
begin
  FiProtocolVersion := AiProtocolVersion;

  FsetOptions       := AsetOptions;

  FMenu             := TMenu.Create;
  FHardware         := THardware_tag.Create;
  FDataFormat       := TDataFormat_tag.Create;
  FChangeFromTypeIndexes := TChangeFromTypeIndexes_tag.Create;
  FsName            := AsName;
  FsVersionInfo     := AsVersionInfo;
end;

constructor TUFRInitXMLReturn.Create(ADriverOptionsMask: int64; AiProtocolVersion: Integer; AsName: AnsiString = ''; AsVersionInfo: AnsiString = '');
var
  eOption: TeOption;
  setOptions: TsetOptions;
begin
  setOptions       := [];
  for eOption := Low(TeOption) to High(TeOption) do begin
    if (ADriverOptionsMask and  I6_OPTION[eOption]) <> 0 then begin
      Include(setOptions, eOption);
    end;
  end;
  Create(setOptions, AiProtocolVersion, AsName, AsVersionInfo);
end;

destructor TUFRInitXMLReturn.Destroy;
begin
  FMenu.Free;

  FHardware.Free;
  FDataFormat.Free;
  FChangeFromTypeIndexes.Free;
  inherited;
end;

function TUFRInitXMLReturn.ToXML: UTF8String;
var
  docXML: IXmlDocument;
  ndUFRInitXMLReturn: IXmlNode;
  ndOptions: IXmlNode;
  eOption: TeOption;
begin
  docXML := CreateXmlDocument('UFRInitXMLReturn', '1.0', 'utf-8');
  ndUFRInitXMLReturn := docXML.documentElement;

  ndUFRInitXMLReturn.SetIntAttr('MaxProtocolSupported', FiProtocolVersion);
  ndUFRInitXMLReturn.SetAttr('DriverName', fsName);
  ndUFRInitXMLReturn.SetAttr('VersionInfo', FsVersionInfo);

  ndOptions := ndUFRInitXMLReturn.AppendElement('Options');

  for eOption := Low(TeOption) to High(TeOption) do if eOption in FsetOptions then ndOptions.AppendElement('Option').SetAttr('Name', S_OPTION[eOption]);

  ndUFRInitXMLReturn.AppendChild(FMenu.toXML);

  ndUFRInitXMLReturn.AppendChild(FHardware.toXML);
  ndUFRInitXMLReturn.AppendChild(FDataFormat.ToXML);
  ndUFRInitXMLReturn.AppendChild(FChangeFromTypeIndexes.ToXML);

  Result := docXML.XML;
end;

{ TMenuOperationResult }

constructor TMenuOperationResult.Create(const AusOperationId: UTF8String);
begin
  FusOperationId := AusOperationId;

//  FPrintUnfiscal := TPrintUnfiscal.Create;
end;

destructor TMenuOperationResult.Destroy;
begin
//  FPrintUnfiscal.Free;

  inherited;
end;

function TMenuOperationResult.ToXML: UTF8String;
var
  docXML: IXmlDocument;
  ndMENUOPERATIONRESULT: IXmlNode;
begin
  docXML := CreateXmlDocument('MENUOPERATIONRESULT', '1.0', 'utf-8');
  ndMENUOPERATIONRESULT := docXML.documentElement;

  ndMENUOPERATIONRESULT.SetAttr('operationId', FusOperationId);

//  if FPrintUnfiscal.isFilled then ndMENUOPERATIONRESULT.AppendChild(FPrintUnfiscal.ToXML);

  Result := docXML.XML;
end;

{ TFiscal_tag }

constructor TFiscal_tag.Create;
begin
  FusEndDate := '';
end;

procedure TFiscal_tag.SetEndDate(AdtEndDate: TDateTime);
begin
  FusEndDate := FormatDateTime('yyyy-mm-dd', AdtEndDate)
end;

function TFiscal_tag.ToXML: IXmlNode;
begin
  Result := CreateXmlElement('Fiscal');

  if FusEndDate <> '' then Result.SetAttr('EndDate', FusEndDate);
end;

{ THardware_tag }

constructor THardware_tag.Create;
begin
  inherited;
  
  FFiscal := TFiscal_tag.Create;
end;

destructor THardware_tag.Destroy;
begin
  FFiscal.Free;

  inherited;
end;

function THardware_tag.ToXML: IXmlNode;
begin
  Result := CreateXmlElement('Fiscal');

  Result.AppendChild(FFiscal.ToXML);
end;

{ TRounding_tag }

constructor TRounding_tag.Create;
begin
  inherited;
  Fi6Multiplier := 1; //�� ��������� 0.01
end;

function TRounding_tag.ToXML: IXmlNode;
begin
  Result := CreateXmlElement('Rounding');
  Result.SetFloatAttr('Multiplier', Fi6Multiplier / 100);
end;

{ TDataFormat_tag }

constructor TDataFormat_tag.Create;
begin
  inherited;
  FRounding := TRounding_tag.Create;
end;

destructor TDataFormat_tag.Destroy;
begin
  FRounding.Free;
  inherited;
end;

function TDataFormat_tag.ToXML: IXmlNode;
begin
  Result := CreateXmlElement('DataFormat');
  if Assigned(FRounding) then begin
    Result.AppendChild(FRounding.ToXML);
  end;
end;

{ TChangeFromTypeIndexes_tag }

procedure TChangeFromTypeIndexes_tag.Add(AiIndex: Integer);
begin
  SetLength(FarIndexes, Length(FarIndexes) + 1);
  FarIndexes[High(FarIndexes)] := AiIndex;
end;

procedure TChangeFromTypeIndexes_tag.Clear;
begin
  SetLength(FarIndexes, 0);
end;

constructor TChangeFromTypeIndexes_tag.Create;
begin
  inherited;
  Clear;
end;

destructor TChangeFromTypeIndexes_tag.Destroy;
begin
  Clear;
  inherited;
end;

function TChangeFromTypeIndexes_tag.ToXML: IXmlNode;
var
  i: Integer;
  s: string;
begin
  Result := CreateXmlElement('ChangeFromTypeIndexes');

  s := '';
  for i := 0 to High(FarIndexes) do begin
    if i <> 0 then begin
      s := s + ' ';
    end;
     s := s + IntToStr(FarIndexes[i]);
  end;

  Result.Text := s;
end;

end.

