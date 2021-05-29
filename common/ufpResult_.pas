unit ufpResult_;

interface

uses
  SysUtils
  ;

const //  ���� ������
  errOk = 0; //��� ������

  //  ������������� ������ �������������: 1..99
  errPortAlreadyUsed                      = 1; // ���� ��� ������������.
  errIllegalOS                            = 2; // �� �� OS.
  errProtocolNotSupported                 = 3; // ������������� �������� �� ��������������.
  errFunctionNotSupported                 = 4; // ������� �������� �� �������������� ������ ��.
  errInvalidHandle                        = 5; // ���������������� ���������� (handle).
  errPortOpenError                        = 6; // ������ �������� �����.
  errPortBadBaud                          = 7; // ������������ �������� ��� �����.
  errInternalException                    = 8; // ����������� ���������� (���������� ������)
  errExtPrintError                        = 9; // ������ ������ ����� ������� �������, ����� ����������� ����� ������
                                                    
  //  ������������� ������ ������� ������: 100..199 
  errLowNotReady                          = 101; // ���������� �� ������ ������� �������. ������� ��������.
  errLowSendError                         = 102; // ���������� �������� ������� ����� �������.
  errLowAnswerTimeout                     = 103; // ���������� �� �������� �� �������.
  errLowInactiveOnExec                    = 104; // ���������� �� �������� �� �������� ����������������� ����� �������� �������.
  errLowBadAnswer                         = 105; // ���������� �������� ������� (� ���������� ��������� ��� ������ �� �����).
  errLowInternalError                     = 106; // ���������� exception � �.�.
                                                    
  //  ���������� ������, ��������� ������� ��: 200..299.
  //  ����������. �� ������� ������� ���������� ���� ����������� ��������� ����� ��������� ���������� ����� �������������� ����� "UFRGetLastLogicError"
  errLogicError                           = 200; // ���������� ������ ������������ ����.
  errLogic24hour                          = 201; // ����� ��������� ������������ �����������������.
  errLogicPrinterNotReady                 = 202; // ������ ���� �������� �� ������������ ��������. ��� ������� ������� �� ���� ���������� ��� ������.
  errLogicPaperOut                        = 203; // ����������� ������ �� ����� ������. ��� ������� ������� �� ���� ���������� ��� ������.
  errLogicBadAnswerFormat                 = 204; // � ������ ����� �� �� ����� � ��� ������, �� ��� �� ������������� �� ��
  errLogicShiftAlreadyOpened              = 205; // � ����� �� OpenShiftReport ���� ����� ��� �������

  //  ������ �� ������� ������, ������������ �� �������� ������ � ��: 300..399
  errAssertItemsPaysDifferent             = 301; // � ���� �� ��������� ����� �� ������� � ��������.
  errAssertInvalidXMLInitializationParams = 302; // ������ ������������ XMLParams, ������������ �� ����� ������������� UFRInit. ��� ��������� ����� ��������� ���������� ������� "UFRGetLastLogicError".
  errAssertInvalidXMLParams               = 303; // ������ XML, ����������� �: UFRFiscalDocument, UFRUnfiscalPrint, UFRCustomerDisplay. ��� ��������� ����� ��������� ���������� ������� "UFRGetLastLogicError".
  errAssertInsufficientBufferSize         = 304; // ������������� ������ ������ ��� ��������� ������.

type
  TUFRLogicError = packed record
    Size              : Integer;     // SizeOf(TUFRLogicError)

    LogicError        : Integer;     // ���������� ��� ���������� ������ ��
    LogicErrorTextANSI: ShortString; // �������� ���������� ������ �� ANSI, ��� ��������� 6 ����������
    LogicErrorTextUTF8: ShortString; // �������� ���������� ������ �� UTF8
  end;

type
  TUFRresult = class
  public
    constructor Create(AiError: Integer = errOk; const AusMessage: UTF8String = '');
    procedure SetValue(AiError: Integer; const AusMessage: UTF8String; const AusFuncName: UTF8String = '');  //  ���� �������� AsFuncName �� �����������, �� �� ����������
    function SetIfStrError(AiError: Integer; const AusMessage: UTF8String; const AusFuncName: UTF8String = ''): Boolean;
    function SetIfWinError(AiError: Integer; AiWinErrCode: Integer = 0; const AusMessagePrefix: UTF8String = ''; const AusFuncName: UTF8String = ''): Boolean;
  private
    FiError: Integer;  //  ���� �� �������� errXX..XX
    FusMessage: UTF8String;  //  �������� ������
    FusFuncName: UTF8String;
    function GetusError: UTF8String;
    function GetusLogText: UTF8String;
  public
    property iError: Integer read FiError;
    property usMessage: UTF8String read FusMessage;
    property usFuncName: UTF8String read FusFuncName write FusFuncName;
  public
    property usLogText: UTF8String read GetusLogText; //  �����, ������� ���������� (�������)
  end;

implementation

{ TResult }

constructor TUFRresult.Create(AiError: Integer; const AusMessage: UTF8String);
begin
  SetValue(AiError, AusMessage);
end;

function TUFRresult.GetusError: UTF8String;
begin
  case iError of
    errOk                                   : Result := 'Ok'; //��� ������
     // ������������� ������ �������������: 1..99
    errPortAlreadyUsed                      : Result := 'PortAlreadyUsed'; //���� ��� ������������.
    errIllegalOS                            : Result := 'IllegalOS'; //�� �� OS.
    errProtocolNotSupported                 : Result := 'ProtocolNotSupported'; //������������� �������� �� ��������������.
    errFunctionNotSupported                 : Result := 'FunctionNotSupported'; //������� �������� �� �������������� ������ ��.
    errInvalidHandle                        : Result := 'InvalidHandle'; //���������������� ���������� (handle).
    errPortOpenError                        : Result := 'PortOpenError'; //������ �������� �����.
    errPortBadBaud                          : Result := 'PortBadBaud'; //������������ �������� ��� �����.
    errInternalException                    : Result := 'InternalException'; //����������� ���������� (���������� ������)
     // ������������� ������ ������� ������: 100..199
    errLowNotReady                          : Result := 'LowNotReady'; //���������� �� ������ ������� �������. ������� ��������.
    errLowSendError                         : Result := 'LowSendError'; //���������� �������� ������� ����� �������.
    errLowAnswerTimeout                     : Result := 'LowAnswerTimeout'; //���������� �� �������� �� �������.
    errLowInactiveOnExec                    : Result := 'LowInactiveOnExec'; //���������� �� �������� �� �������� ����������������� ����� �������� �������.
    errLowBadAnswer                         : Result := 'LowBadAnswer'; //���������� �������� ������� (� ���������� ��������� ��� ������ �� �����).
    errLowInternalError                     : Result := 'LowInternalError'; //���������� exception � �.�.
     // ���������� ������, ��������� ������� ��: 200..299. ����������. �� ������� ������� ���������� ���� ����������� ��������� ����� ��������� ���������� ����� �������������� ����� "UFRGetLastLogicError"
    errLogicError                           : Result := 'LogicError'; //���������� ������ ������������ ����.
    errLogic24hour                          : Result := 'Logic24hour'; //����� ��������� ������������ �����������������.
    errLogicPrinterNotReady                 : Result := 'LogicPrinterNotReady'; //������ ���� �������� �� ������������ ��������. ��� ������� ������� �� ���� ���������� ��� ������.
    errLogicPaperOut                        : Result := 'LogicPaperOut'; //����������� ������ �� ����� ������. ��� ������� ������� �� ���� ���������� ��� ������.
    errLogicBadAnswerFormat                 : Result := 'LogicBadAnswerFormat'; //� ������ ����� �� �� ����� � ��� ������, �� ��� �� ������������� �� ��
    errLogicShiftAlreadyOpened              : Result := 'LogicShiftAlreadyOpened'; // � ����� �� OpenShiftReport ���� ����� ��� �������
     // ������ �� ������� ������, ������������ �� �������� ������ � ��: 300..399
    errAssertItemsPaysDifferent             : Result := 'AssertItemsPaysDifferent'; //� ���� �� ��������� ����� �� ������� � ��������.
    errAssertInvalidXMLInitializationParams : Result := 'AssertInvalidXMLInitializationParams'; //������ ������������ XMLParams, ������������ �� ����� ������������� UFRInit. ��� ��������� ����� ��������� ���������� ������� "UFRGetLastLogicError".
    errAssertInvalidXMLParams               : Result := 'AssertInvalidXMLParams'; //������ XML, ����������� �: UFRFiscalDocument, UFRUnfiscalPrint, UFRCustomerDisplay. ��� ��������� ����� ��������� ���������� ������� "UFRGetLastLogicError".
    errAssertInsufficientBufferSize         : Result := 'AssertInsufficientBufferSize'; //������������� ������ ������ ��� ��������� ������.
  else
    Result := 'Unknown error: ' + IntToStr(iError);
  end;
end;

function TUFRresult.GetusLogText: UTF8String;
var
  usMessage: UTF8String;
begin
  usMessage := '';
  if FusMessage <> '' then usMessage := usMessage + ' - ' + FusMessage;
  if FusFuncName <> '' then usMessage := usMessage + ' in ' + FusFuncName + '()';
  Result := GetusError + usMessage;
end;

function TUFRresult.SetIfStrError(AiError: Integer; const AusMessage, AusFuncName: UTF8String): Boolean;
begin
  Result := False;

  if AusMessage = '' then Exit;
  SetValue(AiError, AusMessage, AusFuncName);

  Result := True;
end;

function TUFRresult.SetIfWinError(AiError, AiWinErrCode: Integer; const AusMessagePrefix, AusFuncName: UTF8String): Boolean;
var
  sSeparator: AnsiString;
begin
  Result := False;

  if AiWinErrCode = 0 then AiWinErrCode := 0;//GetLastError;
  if AiWinErrCode = 0 then Exit;
  if AusMessagePrefix = '' then sSeparator := '' else sSeparator := '. ';
  SetValue(AiError, Format('%s%sWindows error 0x%s - %s', [AusMessagePrefix, sSeparator, IntToHex(AiWinErrCode, 8), SysErrorMessage(AiWinErrCode)]), AusFuncName);

  Result := True;
end;

procedure TUFRresult.SetValue(AiError: Integer; const AusMessage: UTF8String; const AusFuncName: UTF8String = '');
begin
  FiError := AiError;
  FusMessage := AusMessage;
  if AusFuncName <> '' then FusFuncName := AusFuncName;
end;

end.
