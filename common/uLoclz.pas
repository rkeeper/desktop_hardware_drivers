unit uLoclz;

interface

//�������� ���������.
procedure LoadLanguage(const langname: String);

//�������
function tr(const source: UTF8String ): UTF8String; //������� ������. ���� � ����� � UTF8
function trc(const source: AnsiString): UTF8String; //������� ������. ��������� �� ���� �������� ��������� � ��������� uCommon.STRING_CONST_CODEPAGE. ����� � UTF8
function trf(const fmt: UTF8String; args: array of const): UTF8String; //������� � ��������������. fmt � ������ � args � UTF8. ����� � UTF8
function trfc(const fmt: AnsiString; args: array of const): UTF8String; //������� � ��������������. fmt � STRING_CONST_CODEPAGE. ������ � args � UTF8. ����� � UTF8

//�� �������. ��� ����������� �����, �� ��������� ��������.
function notr(const source: UTF8String ): UTF8String; //��� ����������� �����, �� ��������� ��������. ���� � ����� � UTF8
function notrc(const source: AnsiString): UTF8String; //��� ����������� �����, �� ��������� ��������. ��������� �� ���� �������� ��������� � ��������� uCommon.STRING_CONST_CODEPAGE. ����� � UTF8
function notrf(const fmt: UTF8String; args: array of const): UTF8String; //Format ��� ��������. ��� ����������� �����, �� ��������� ��������. fmt � ������ � args � UTF8. ����� � UTF8
function notrfc(const fmt: AnsiString; args: array of const): UTF8String; //Format ��� ��������. ��� ����������� �����, �� ��������� ��������. fmt � STRING_CONST_CODEPAGE. ������ � args � UTF8. ����� � UTF8
function notrfRaw(const fmt: AnsiString; args: array of const): AnsiString;//Format ��� ��������. ��� ����������� �����, �� ��������� ��������. �� ������� ��������� fmt � args

//�������
function MainCodePage: Cardinal;// ��������� Main. ���������� 1250 �� <xlif><file 'ucslng:charset'='238'> ����� CharSetToCodePage
function MainToUTF8(const S: AnsiString): UTF8String;
function UTF8ToMain(const S: UTF8String): AnsiString;

implementation

uses
  SysUtils
  ,Classes
  ,Windows
  ,uCommon
  ,SimpleXml
  ;

//������ windows �������� ������������ �������� TranslateCharsetInfo ��� ������������� � TCI_SRCCHARSET, ������� ����� ��������������
function TranslateCharsetInfo_TCI_SRCCHARSET(lpSrc: DWORD; var lpCs: TCharsetInfo; dwFlags: DWORD): BOOL; stdcall; external 'gdi32.dll' name 'TranslateCharsetInfo';

function CharSetToCodePage(ciCharset: DWORD): Cardinal;
var
  C: TCharsetInfo;
begin
  Result:=CP_ACP; //default ANSI code page
  if ciCharset=DEFAULT_CHARSET then
    //nothing
  else if ciCharset = 85 then
    Result := CP_UTF8
  else if TranslateCharsetInfo_TCI_SRCCHARSET(ciCharset, C, TCI_SRCCHARSET) then
     Result := C.ciACP
end;

function MainToUTF8(const S: AnsiString): UTF8String;
begin
  Result := CodePageToUTF8(MainCodePage, S);
end;

function UTF8ToMain(const S: UTF8String): AnsiString;
begin
  Result := UTF8toCodePage(S, MainCodePage);
end;

function TranslateA( S: UTF8String): AnsiString;
begin
  Result := UTF8ToMain(tr(S));
end;

type
  TStorageUnit = class
    target: UTF8String;
  end;

  TDict = class
  public
    constructor Create;
    destructor Destroy; override;
  public
    function tr(source: UTF8String): UTF8String;
    function CodePage: Cardinal;
  public
    procedure Clear;
    function  LoadFromFile(name: String; language: String=''): Boolean;
    procedure LoadFilesMask(FileMask: String; language: String='');
    procedure LoadLanguage(langname: String);
  private
    FCharset: Integer;
    FCodepage: Cardinal;
    FStorage: TStringList;
  private
    procedure Add(source, target: UTF8String);
    function FindIndex(source: UTF8String): Integer;
    function LoadFromXLIFF(name: String; language: String=''): Boolean;
  end;

{ TDict }

procedure TDict.Add(source, target: UTF8String);
var
  i: Integer;
  u: TStorageUnit;
begin
  i := FindIndex(source);
  if i < 0 then begin
    u := TStorageUnit.Create;
    u.target := target;
    FStorage.AddObject(source, u);
  end else begin
    u := TStorageUnit(FStorage.Objects[i]);
    u.target := target;
  end;
end;

constructor TDict.Create;
begin
  inherited;
  FStorage := TStringList.Create;
  Clear;
end;

procedure TDict.Clear;
var
  i: Integer;
begin
  for i :=0 to FStorage.Count-1 do begin
    TStorageUnit(FStorage.Objects[i]).Free;
  end;
  FStorage.Clear;
  FStorage.Sorted := True;
  FCharset := RUSSIAN_CHARSET;
  FCodepage:=CharSetToCodePage(FCharset);
end;

destructor TDict.Destroy;
begin
  Clear;
  FStorage.Free;
  inherited;
end;

function TDict.FindIndex(source: UTF8String): Integer;
begin
  Result := FStorage.IndexOf(source);
end;

function TDict.tr(source: UTF8String): UTF8String;
var
  i: Integer;
begin
  Result := source;
  if source = '' then Exit;
  i := FindIndex(source);
  if i<0 then Exit;
  if not Assigned(FStorage.Objects[i]) then Exit;
  Result := TStorageUnit(FStorage.Objects[i]).target;
end;

function TDict.LoadFromFile(name: String; language: String=''): Boolean;
begin
  Result := True;
  if LoadFromXLIFF(name, language) then Exit;
end;

procedure TDict.LoadFilesMask(FileMask: String; language: String='');
var
  Files: TStringList;
  SR   : TSearchRec;
  Code : Integer;
  Path : String;
  I    : Integer;
begin
  Files := TStringList.Create;
  try
    {����� ��� �����}
    Path := ExtractFilePath(FileMask);
    Code := FindFirst( FileMask, faAnyFile, SR );
    while Code = 0 do begin
      Files.add(Path + SR.Name);
      Code := FindNext( SR );
    end;
    SysUtils.FindClose( SR );
    {��������� �������� �����}
    For I := 0 to Files.Count - 1 do begin
      LoadFromFile(Files[i], language);
    end;
  finally
    Files.Free;
  end;
end;

function TDict.LoadFromXLIFF(name: String; language: String=''): Boolean;
var
  xmld: IXmlDocument;
  node: IXmlNode;
  units: IXmlNodeList;
  i: Integer;
  source,target: UTF8String;
begin
  Result := False;
  try
    xmld := LoadXmlDocument(name);
  except
    Exit; // � ������ ������ ����� �������.
  end;

  if xmld.DocumentElement.NodeName <> 'xliff' then Exit;

  node:=xmld.SelectSingleNode('xliff/file');
  if not Assigned(node) then Exit;

  if language <> '' then begin
    //����� ����, ������ ��������� target-language
    if node.GetAttr('target-language', '') <> language then Exit;
  end;

  FCharset:= StrToInt64Def(node.GetAttr('ucslng:charset', ''), RUSSIAN_CHARSET);
  FCodepage:=CharSetToCodePage(FCharset);

  node := xmld.SelectSingleNode('xliff/file/body');
  if not Assigned(node) then Exit;

  units := node.SelectNodes('trans-unit');
  for i:= 0 to units.Count -1 do begin
    source := units[i].GetChildText('source','');
    target := units[i].GetChildText('target','');
    if source <> '' then Add(source, target);
  end;

  Result := True;
end;

function TDict.CodePage: Cardinal;
begin
  Result := FCodepage;
end;

procedure TDict.LoadLanguage(langname: String);
var
  selfname: String;
begin
  Clear;
  selfname := ChangeFileExt(GetSelfModuleFileName,'');
  LoadFilesMask(selfname + '.*.xlf', langname);
  LoadFilesMask(selfname + '.*.xliff', langname);
  LoadFilesMask(selfname + '.' + langname + '.xlf', '');
  LoadFilesMask(selfname + '.' + langname + '.xliff', '');
end;

var d: TDict;

procedure LoadLanguage(const langname: String);
begin
  d.LoadLanguage(langname);
end;

function MainCodePage: Cardinal;
begin
  Result := d.CodePage;
end;

function tr(const source: UTF8String ): UTF8String;
begin
  Result := d.tr(source);
end;

function trc(const source: AnsiString): UTF8String;
begin
  Result := d.tr(StrConstToUTF8(source));
end;

function trf(const fmt: UTF8String; args: array of const): UTF8String;
var
  sOriginal: UTF8String;
  trFmt: UTF8String;
begin
  sOriginal := Format(fmt, args); //����������� �� ��������� �������, ����� ��� �� ������� ���������� ������������ ������ �������� �����
  trFmt := d.tr(fmt);
  try
    Result := Format(trFmt, args);
  except//������ � ������� ��������.
    if (trFmt <> '') and (trFmt <> fmt) then begin
      Result := trFmt + ' ' + sOriginal //����������. ����� ������� � �������������� �� ���������
    end else begin
      Result := sOriginal; //�� ����������. ������ ������ �� ���������.
    end;
  end;
end;

function trfc(const fmt: AnsiString; args: array of const): UTF8String;
begin
  Result := trf(StrConstToUTF8(fmt), args);
end;

function notr(const source: UTF8String ): UTF8String;
begin
  Result := source;
end;

function notrc(const source: AnsiString): UTF8String;
begin
  Result := StrConstToUTF8(source);
end;

function notrf(const fmt: UTF8String; args: array of const): UTF8String;
begin
  Result := Format(fmt, args);
end;

function notrfc(const fmt: AnsiString; args: array of const): UTF8String;
begin
  Result := Format(StrConstToUTF8(fmt), args);
end;

function notrfRaw(const fmt: AnsiString; args: array of const): AnsiString;
begin
  Result := Format(fmt, args);
end;

begin
  d := TDict.Create;
end.
