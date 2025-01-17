//��� ����������� XML_WIDE_CHARS ������������� � utf-8 � ����� �������, ���� �� ������������ SetVarAttr � GetVarAttr.
//���� ������������ SetVarAttr � GetVarAttr, �� ���� ���������� LoadUTF8AsWideString=true (����� ������ ������ ����� ��������� ���������������� � �������, � GetAttr ����� �������������� �� ���������� ������)
//UTF-16 �������������� ������ XML_WIDE_CHARS � ������ UTF-16LE

{************************************************************
 SimpleXML - ���������� ��� ��������������� ������� ������� XML
	 � �������������� � �������� XML-��������.
	 � ��������: ����� ������������ �������� XML-��������, �
	 ��� �� ��� �������� ����� XML.
	 ��������� ������ ��� MSXML. ��� ������������� Ansi-�����
	 �������� ������� � ������ ������ ������.

 (�) ��������� ����� 2002,2003 ������ ������.
	 ���������� ���������� � ����� ���� ������������ �� ������ ����������.
	 ����������� �������� ����� ��������� � ������������� ����������
	 ��������� ��� �����������.
	 ������������ ����������: ������ ����� ������ ��������������
	 ��� ��������� �� ���� ������������ ����������.

	 ��� ��������� ����������� �� ������ misha@integro.ru
	 ��� �� ���������� �������� ��� ���������: http://mv.rb.ru
	 ��� �� ������ ������� ����� ��������� ������ ����������.
	 ����� ��������� ����������������, ������ ������.

	������� ������: 1.0.1
*************************************************************}
{$ifdef VER150}
  {$define Delphi7}
{$endif}
{$ifdef FPC}
  {$define Delphi7}
{$endif}
{$ifdef Dos32}
  {$define INTDATE}
{$endif}
{$define IntValueInt64}
{$H+}
unit SimpleXML;

interface

uses
	Windows, SysUtils, Classes;

const
	BinXmlSignatureSize = Length('< binary-xml >');
	BinXmlSignature: String = '< binary-xml >';

	BINXML_USE_WIDE_CHARS = 1;
	BINXML_COMPRESSED = 2;

	XSTR_NULL = '{{null}}';
	
	NODE_INVALID = $00000000;
	NODE_ELEMENT = $00000001;
	NODE_ATTRIBUTE = $00000002;
	NODE_TEXT = $00000003;
	NODE_CDATA_SECTION = $00000004;
	NODE_ENTITY_REFERENCE = $00000005;
	NODE_ENTITY = $00000006;
	NODE_PROCESSING_INSTRUCTION = $00000007;
	NODE_COMMENT = $00000008;
	NODE_DOCUMENT = $00000009;
	NODE_DOCUMENT_TYPE = $0000000A;
	NODE_DOCUMENT_FRAGMENT = $0000000B;
	NODE_NOTATION = $0000000C;

type
	// TXmlString - ��� ��������� ����������, ������������ � SimpleXML.
	//  ����� ���� String ��� WideString.

	{ $DEFINE XML_WIDE_CHARS}

	{$IFDEF XML_WIDE_CHARS}
	PXmlChar = PWideChar;
	TXmlChar = WideChar;
	TXmlString = WideString;
	{$ELSE}
	PXmlChar = PChar;
	TXmlChar = Char;
	TXmlString = String;
	{$ENDIF}
        {$IFDEF IntValueInt64}
          tIntValue=Int64;
        {$else}
          tIntValue=Integer;
        {$endif}

	IXmlDocument = interface;
	IXmlElement = interface;
	IXmlText = interface;
	IXmlCDATASection = interface;
	IXmlComment = interface;
	IXmlProcessingInstruction = interface;


	// IXmlBase - ������� ��������� ��� ���� ����������� SimpleXML.
	IXmlBase = interface
		// GetObject - ���������� ������ �� ������, ����������� ���������.
		function GetObject: TObject;
	end;

	// IXmlNameTable - ������� ����. ������� ����� �������������� �����
	//  ���������� �������� �������������. ������������ ��� ��������
	//  �������� ����� � ���������.
	IXmlNameTable = interface(IXmlBase)
		// GetID - ���������� �������� ������������� ��������� ������.
		function GetID(const aName: TXmlString; AnyCaseFirst:boolean = True): Integer;
		// GetID - ���������� ������, ��������������� ���������� ���������
		//  ��������������.
		function GetName(anID: Integer): TXmlString;
	end;

	IXmlNode = interface;

	// IXmlNodeList - ������ �����. ������ ����������� � ���� �������.
	//  ������ � ��������� ������ �� �������
	IXmlNodeList = interface(IXmlBase)
		// Get_Count - ���������� ����� � ������
		function Get_Count: Integer;
		// Get_Item - �������� ���� �� �������
		function Get_Item(anIndex: Integer): IXmlNode;
		// Get_XML - ���������� ������������� ��������� ������ � ������� XML
		function Get_XML: TXmlString;

		property Count: Integer read Get_Count;
		property Item[anIndex: Integer]: IXmlNode read Get_Item; default;
		property XML: TXmlString read Get_XML;
	end;

	// IXmlNode - ���� XML-������
	IXmlNode = interface(IXmlBase)
		// Get_NameTable - ������� ����, ������������ ������ �����
		function Get_NameTable: IXmlNameTable;
		// Get_NodeName - ���������� �������� ����. ������������� �������� ����
		//  ������� �� ��� ����
		function Get_NodeName: TXmlString;
		// Get_NodeNameID - ���������� ��� �������� ����
		function Get_NodeNameID: Integer;
		// Get_NodeType - ���������� ��� ����
		function Get_NodeType: Integer;
		// Get_Text - ���������� ����� ����
		function Get_Text: TXmlString;
		// Set_Text - �������� ����� ����
		procedure Set_Text(const aValue: TXmlString);
		// Get_DataType - ���������� ��� ������ ���� � �������� ���������
		function Get_DataType: Integer;
		// Get_TypedValue - ���������� 
		function Get_TypedValue: Variant;
		// Set_TypedValue - �������� ����� ���� �� �������������� ��������
		procedure Set_TypedValue(const aValue: Variant);
		// Get_XML - ���������� ������������� ���� � ���� ��������� �����
		//  � ������� XML.
		function Get_XML: TXmlString;

		// CloneNode - ������� ������ ����� ������� ����
		//  ���� ����� ������� aDeep, �� ��������� �����
		//  ���� ����� �������� �� ������� ����.
		function CloneNode(aDeep: Boolean = True): IXmlNode;

		// Get_ParentNode - ���������� ������������ ����
		function Get_ParentNode: IXmlNode;
		// Get_OwnerDocument - ���������� XML-��������,
		//  � ������� ���������� ������ ����
		function Get_OwnerDocument: IXmlDocument;

		// Get_ChildNodes - ���������� ������ �������� �����
		function Get_ChildNodes: IXmlNodeList;
		// AppendChild - ��������� ��������� ���� � ����� ������ �������� �����
		procedure AppendChild(const aChild: IXmlNode);
		// InsertBefore - ��������� ��������� ���� � ��������� ����� ������ �������� �����
		procedure InsertBefore(const aChild, aBefore: IXmlNode);
		// ReplaceChild - �������� ��������� ���� ������ �����
		procedure ReplaceChild(const aNewChild, anOldChild: IXmlNode);
		// RemoveChild - ������� ��������� ���� �� ������ �������� �����
		procedure RemoveChild(const aChild: IXmlNode);

		// AppendElement - ������� ������� � ��������� ��� � ����� ������
		//  � ����� ������ �������� ��������
		function AppendElement(aNameID: Integer): IXmlElement; overload;
		function AppendElement(const aName: TxmlString): IXmlElement; overload;

		// AppendText - ������� ��������� ���� � ��������� ���
		//  � ����� ������ �������� ��������
		function AppendText(const aData: TXmlString): IXmlText; 

		// AppendCDATA - ������� ������ CDATA � ��������� �� 
		//  � ����� ������ �������� ��������
		function AppendCDATA(const aData: TXmlString): IXmlCDATASection;

		// AppendComment - ������� ����������� � ��������� ��� 
		//  � ����� ������ �������� ��������
		function AppendComment(const aData: TXmlString): IXmlComment;

		// AppendProcessingInstruction - ������� ���������� � ��������� �
		//  � ����� ������ �������� ��������
		function AppendProcessingInstruction(aTargetID: Integer;
			const aData: TXmlString): IXmlProcessingInstruction; overload;
		function AppendProcessingInstruction(const aTarget: TXmlString;
			const aData: TXmlString): IXmlProcessingInstruction; overload;

		// GetChildText - ���������� �������� ��������� ����
		// SetChildText - ��������� ��� �������� �������� ��������� ����
		function GetChildText(const aName: TXmlString; const aDefault: TXmlString = ''): TXmlString; overload;
		function GetChildText(aNameID: Integer; const aDefault: TXmlString = ''): TXmlString; overload;
		procedure SetChildText(const aName, aValue: TXmlString); overload;
		procedure SetChildText(aNameID: Integer; const aValue: TXmlString); overload;

		// NeedChild - ���������� �������� ���� � ��������� ������.
		//  ���� ���� �� ������, �� ������������ ����������
		function NeedChild(aNameID: Integer): IXmlNode; overload;
		function NeedChild(const aName: TXmlString): IXmlNode; overload;

		// EnsureChild - ���������� �������� ���� � ��������� ������.
		//  ���� ���� �� ������, �� �� ����� ������
		function EnsureChild(aNameID: Integer): IXmlNode; overload;
		function EnsureChild(const aName: TXmlString): IXmlNode; overload;

		// RemoveAllChilds - ������� ��� �������� ����
		procedure RemoveAllChilds;

		// SelectNodes - ���������� ������� �����, ���������������
		//  ��������� ���������
		function SelectNodes(const anExpression: TXmlString): IXmlNodeList;
		// SelectSingleNode - ���������� ����� ������� ����, ����������������
		//  ��������� ���������
		function SelectSingleNode(const anExpression: TXmlString): IXmlNode;
		// FindElement - ���������� ����� ������� ����, ����������������
		//  ��������� ���������
		function FindElement(const anElementName, anAttrName: String; const anAttrValue: Variant): IXmlElement;

		// Get_AttrCount - ���������� ���������� ���������
		function Get_AttrCount: Integer;
		// Get_AttrNameID - ���������� ��� �������� ��������
		function Get_AttrNameID(anIndex: Integer): Integer;
		// Get_AttrName - ���������� �������� ��������
		function Get_AttrName(anIndex: Integer): TXmlString;
		// RemoveAttr - ������� �������
		procedure RemoveAttr(const aName: TXmlString); overload;
		procedure RemoveAttr(aNameID: Integer); overload;
		// RemoveAllAttrs - ������� ��� ��������
		procedure RemoveAllAttrs;

		// AttrExists - ���������, ����� �� ��������� �������.
		function AttrExists(aNameID: Integer): Boolean; overload;
		function AttrExists(const aName: TXmlString): Boolean; overload;

		// GetAttrType - ���������� ��� ������ �������� � �������� ���������
		function GetAttrType(aNameID: Integer): Integer; overload;
		function GetAttrType(const aName: TXmlString): Integer; overload;

		// GetAttrType - ���������� ��� ��������
		//  Result
		// GetVarAttr - ���������� �������������� �������� ���������� ��������.
		//  ���� ������� �� �����, �� ������������ �������� �� ���������
		// SetAttr - �������� ��� ��������� ��������� �������
		function GetVarAttr(aNameID: Integer; const aDefault: Variant): Variant; overload;
		function GetVarAttr(const aName: TXmlString; const aDefault: Variant): Variant; overload;
		procedure SetVarAttr(aNameID: Integer; const aValue: Variant); overload;
		procedure SetVarAttr(const aName: TXmlString; aValue: Variant); overload;

		// NeedAttr - ���������� ��������� �������� ���������� ��������.
		//  ���� ������� �� �����, �� ������������ ����������
		function NeedAttr(aNameID: Integer): TXmlString; overload;
		function NeedAttr(const aName: TXmlString): TXmlString; overload;

		// GetAttr - ���������� ��������� �������� ���������� ��������.
		//  ���� ������� �� �����, �� ������������ �������� �� ���������
		// SetAttr - �������� ��� ��������� ��������� �������
		function GetAttr(aNameID: Integer; const aDefault: TXmlString = ''): TXmlString; overload;
		function GetAttr(const aName: TXmlString; const aDefault: TXmlString = ''): TXmlString; overload;
		procedure SetAttr(aNameID: Integer; const aValue: TXmlString); overload;
		procedure SetAttr(const aName, aValue: TXmlString); overload;

		// GetBoolAttr - ���������� ������������� �������� ���������� ��������
		// SetBoolAttr - �������� ��� ��������� ��������� ������� �������������
		//  ���������
		function GetBoolAttr(aNameID: Integer; aDefault: Boolean = False): Boolean; overload;
		function GetBoolAttr(const aName: TXmlString; aDefault: Boolean = False): Boolean; overload;
		procedure SetBoolAttr(aNameID: Integer; aValue: Boolean = False); overload;
		procedure SetBoolAttr(const aName: TXmlString; aValue: Boolean); overload;

		// GetIntAttr - ���������� ������������� �������� ���������� ��������
		// SetIntAttr - �������� ��� ��������� ��������� ������� �������������
		//  ���������
		function GetIntAttr(aNameID: Integer; aDefault: tIntValue = 0): tIntValue; overload;
		function GetIntAttr(const aName: TXmlString; aDefault: tIntValue = 0): tIntValue; overload;
		procedure SetIntAttr(aNameID: Integer; aValue: tIntValue); overload;
		procedure SetIntAttr(const aName: TXmlString; aValue: tIntValue); overload;

		// GetDateTimeAttr - ���������� ������������� �������� ���������� ��������
		// SetDateTimeAttr - �������� ��� ��������� ��������� ������� �������������
		//  ���������
		function GetDateTimeAttr(aNameID: Integer; aDefault: TDateTime = 0): TDateTime; overload;
		function GetDateTimeAttr(const aName: TXmlString; aDefault: TDateTime = 0): TDateTime; overload;
		procedure SetDateTimeAttr(aNameID: Integer; aValue: TDateTime); overload;
		procedure SetDateTimeAttr(const aName: TXmlString; aValue: TDateTime); overload;

		// GetFloatAttr - ���������� �������� ���������� �������� � ����
		//  ������������� �����
		// SetFloatAttr - �������� ��� ��������� ��������� ������� ������������
		//  ���������
		function GetFloatAttr(aNameID: Integer; aDefault: Double = 0): Double; overload;
		function GetFloatAttr(const aName: TXmlString; aDefault: Double = 0): Double; overload;
		procedure SetFloatAttr(aNameID: Integer; aValue: Double); overload;
		procedure SetFloatAttr(const aName: TXmlString; aValue: Double); overload;

		// GetHexAttr - ��������� �������� ���������� �������� � ������������� ����.
		//  ��������� �������� �������� ������������� � ����� �����. ��������
		//  ������ ������ ���� ������ � ����������������� ���� ��� ���������
		//  ("$", "0x" � ��.) ���� �������������� �� ����� ���� ���������,
		//  ������������ ����������.
		//  ���� ������� �� �����, ������������ �������� ��������� aDefault.
		// SetHexAttr - ��������� �������� ���������� �������� �� ���������
		//  ������������� ������ ����� � ����������������� ���� ��� ���������
		//		("$", "0x" � ��.) ���� �������������� �� ����� ���� ���������,
		//		������������ ����������.
		//		���� ������� �� ��� �����, �� �� ����� ��������.
		//		���� ��� �����, �� ����� �������.
		function GetHexAttr(const aName: TXmlString; aDefault: Integer = 0): Integer; overload;
		function GetHexAttr(aNameID: Integer; aDefault: Integer = 0): Integer; overload;
		procedure SetHexAttr(const aName: TXmlString; aValue: Integer; aDigits: Integer = 8); overload;
		procedure SetHexAttr(aNameID: Integer; aValue: Integer; aDigits: Integer = 8); overload;

		//	GetEnumAttr - ���� �������� �������� � ��������� ������ ����� �
		//		���������� ������	��������� ������. ���� ������� ����� �� �� ������
		//		� ������, �� ������������ ����������.
		//		���� ������� �� �����, ������������ �������� ��������� aDefault.
		function GetEnumAttr(const aName: TXmlString;
			const aValues: array of TXmlString; aDefault: Integer): Integer; overload;
		function GetEnumAttr(aNameID: Integer;
			const aValues: array of TXmlString; aDefault: Integer): Integer; overload;

		function NeedEnumAttr(const aName: TXmlString;
			const aValues: array of TXmlString): Integer; overload;
		function NeedEnumAttr(aNameID: Integer;
			const aValues: array of TXmlString): Integer; overload;

		function Get_Values(const aName: String): Variant;
		procedure Set_Values(const aName: String; const aValue: Variant);

		function AsElement: IXmlElement;
		function AsText: IXmlText;
		function AsCDATASection: IXmlCDATASection;
		function AsComment: IXmlComment;
		function AsProcessingInstruction: IXmlProcessingInstruction;

		property NodeName: TXmlString read Get_NodeName;
		property NodeNameID: Integer read Get_NodeNameID;
		property NodeType: Integer read Get_NodeType;
		property ParentNode: IXmlNode read Get_ParentNode;
		property OwnerDocument: IXmlDocument read Get_OwnerDocument;
		property NameTable: IXmlNameTable read Get_NameTable;
		property ChildNodes: IXmlNodeList read Get_ChildNodes;
		property AttrCount: Integer read Get_AttrCount;
		property AttrNames[anIndex: Integer]: TXmlString read Get_AttrName;
		property AttrNameIDs[anIndex: Integer]: Integer read Get_AttrNameID;
		property Text: TXmlString read Get_Text write Set_Text;
		property DataType: Integer read Get_DataType;
		property TypedValue: Variant read Get_TypedValue write Set_TypedValue;
		property XML: TXmlString read Get_XML;
		property Values[const aName: String]: Variant read Get_Values write Set_Values; default;
	end;

	IXmlElement = interface(IXmlNode)
		//	ReplaceTextByCDATASection - ������� ��� ��������� �������� � ���������
		//		���� ������ CDATA, ���������� ��������� �����
		procedure ReplaceTextByCDATASection(const aText: TXmlString);

		//	ReplaceTextByBynaryData - ������� ��� ��������� �������� � ���������
		//		���� ��������� �������, ���������� ��������� �������� ������
		//		� ������� "base64".
		//		���� �������� aMaxLineLength �� ����� ����, �� ������������ ��������
		//		��������� ������ �� ������ ������ aMaxLineLength.
		//		������ ����������� ����� �������� #13#10 (CR,LF).
		//		����� ��������� ������ ��������� ������� �� �����������.
		procedure ReplaceTextByBynaryData(const aData; aSize: Integer;
			aMaxLineLength: Integer);

		//	GetTextAsBynaryData - c������� ��� ��������� �������� � ���� ������ �
		//		���������� �������������� �� ������� "base64" � �������� ������.
		//		��� �������������� ������������ ��� ���������� ������� (� ����� <= ' '),
		//		������������ � �������� ������.
		function GetTextAsBynaryData: TXmlString;

	end;

	IXmlCharacterData = interface(IXmlNode)
	end;

	IXmlText = interface(IXmlCharacterData)
	end;

	IXmlCDATASection = interface(IXmlCharacterData)
	end;

	IXmlComment = interface(IXmlCharacterData)
	end;

	IXmlProcessingInstruction = interface(IXmlNode)
	end;

        TGetBodyCallback = function(node:IXmlElement):TXmlString of object;
	IXmlDocument = interface(IXmlNode)
		function Get_DocumentElement: IXmlElement;
		function Get_BinaryXML: String;
                function Get_Encoding: string;
		function Get_PreserveWhiteSpace: Boolean;
		procedure Set_PreserveWhiteSpace(aValue: Boolean);

		function NewDocument(const aVersion, anEncoding: TXmlString;
			aRootElementNameID: Integer): IXmlElement; overload;
		function NewDocument(const aVersion, anEncoding,
			aRootElementName: TXmlString): IXmlElement; overload;

		function CreateElement(aNameID: Integer): IXmlElement; overload;
		function CreateElement(const aName: TXmlString): IXmlElement; overload;
		function CreateText(const aData: TXmlString): IXmlText;
		function CreateCDATASection(const aData: TXmlString): IXmlCDATASection;
		function CreateComment(const aData: TXmlString): IXmlComment;
		function CreateProcessingInstruction(const aTarget,
			aData: TXmlString): IXmlProcessingInstruction; overload;
		function CreateProcessingInstruction(aTargetID: Integer;
			const aData: TXmlString): IXmlProcessingInstruction; overload;

		procedure LoadXML(const aXML: TXmlString);
		procedure LoadBinaryXML(const aXML: String);

		procedure Load(aStream: TStream); overload;
		procedure Load(const aFileName: TXmlString); overload;

		procedure LoadResource(aType, aName: PChar);

		procedure Save(aStream: TStream); overload;
		procedure SaveWithElementBody(aStream: TStream; GetBodyCallback: TGetBodyCallback;
				TagToWriteIn:TXmlString);
		procedure Save(const aFileName: TXmlString); overload;

		procedure SaveBinary(aStream: TStream; anOptions: LongWord = 0); overload;
		procedure SaveBinary(const aFileName: TXmlString; anOptions: LongWord = 0); overload;

		property PreserveWhiteSpace: Boolean read Get_PreserveWhiteSpace write Set_PreserveWhiteSpace;
		property DocumentElement: IXmlElement read Get_DocumentElement;
		property BinaryXML: String read Get_BinaryXML;
                property Encoding: string read Get_Encoding;
	end;

  SimpleXMLException=class(Exception);
  NeedAttrException=class(SimpleXMLException);
  NeedChildException=class(SimpleXMLException);

function CreateNameTable(aHashTableSize: Integer = 4096): IXmlNameTable;
function CreateXmlDocument(
	const aRootElementName: String = '';
	const aVersion: String = '1.0';
	const anEncoding: String = ''; // SimpleXml.DefaultEncoding
	const aNames: IXmlNameTable = nil): IXmlDocument;

function CreateXmlElement(const aName: TXmlString; const aNameTable: IXmlNameTable = nil): IXmlElement;
function LoadXmlDocumentFromXML(const aXML: TXmlString): IXmlDocument;
function LoadXmlDocumentFromBinaryXML(const aXML: String): IXmlDocument;

function LoadXmlDocument(aStream: TStream): IXmlDocument; overload;
function LoadXmlDocument(const aFileName: TXmlString): IXmlDocument; overload;
function LoadXmlDocument(aResType, aResName: PChar): IXmlDocument; overload;


var
	DefaultNameTable: IXmlNameTable = nil;
	DefaultPreserveWhiteSpace: Boolean = False;
	DefaultEncoding: String = 'windows-1251';
	DefaultIndentText: String = ^I;
	IgnoreChildText: boolean = true;
{$IFDEF XML_WIDE_CHARS}
        LoadUTF8AsWideString: boolean = true;
{$else}
        LoadUTF8AsWideString: boolean = false;
{$endif}
{$ifdef Delphi7}
  XMLFormatSettings:tFormatSettings;
{$endif}

type
  tEncodingToCodePage=function (const Encoding:string):word;
var
  EncodingToCodePage:tEncodingToCodePage;

resourcestring
	SSimpleXmlError1 = '������ ��������� �������� ������: ������ ������� �� �������';
	SSimpleXmlError2 = 'Element definition is not finished';
	SSimpleXmlError3 = 'Bad character in element name';
	SSimpleXmlError4 = '������ ������ ��������� XML: ������������ ��� ����';
	SSimpleXmlError5 = '������ ������ ��������� XML: ������������ ��� ����';
	SSimpleXmlError6 = '�������� �������� �������� "%s" �������� "%s".'^M^J +
		'���������� ��������:'^M^J +
		'%s';
	SSimpleXmlError7 = 'Attribute "%s" is not found';
	SSimpleXmlError9 = 'Select node by expression is not implemented in SimpleXML';
	SSimpleXmlError10 = 'Error: child element "%s" not found.';
	SSimpleXmlError11 = 'Name must start with letter or "_"';
	SSimpleXmlError12 = 'Number expected';
	SSimpleXmlError13 = 'Hexadecimal number expected';
	SSimpleXmlError14 = '"#" expected or special symbol name';
	SSimpleXmlError15 = 'Bad special symbol name: "%s"';
	SSimpleXmlError16 = 'Character %s expected';
	SSimpleXmlError17 = '"%s" expected';
	SSimpleXmlError18 = 'Character "<" can not be used in attribute values';
	SimpleXmlError19 =  'Character "%s" expected';
	SSimpleXmlError20 = 'Attribute value expected';
	SSimpleXmlError21 = 'String constant expected';
	SimpleXmlError22 = '"%s" expected';
	SSimpleXmlError23 = 'Error reading data.';
	SSimpleXmlError24 = 'Error reading value: bad type.';
	SSimpleXmlError25 = 'Error writing value: bad type.';
	SBadIntAttribute  = 'Bad integer attribute %s value: "%s"';
	SBadUTF8          = 'Bad UTF8 format';
	SBadBase64        = 'Bad Base64 format';
	SSimpleXmlError26 = 'Error: no root element';

function XSTRToFloat(s: TXmlString): Double;
function FloatToXSTR(v: Double): TXmlString;
function XSTRToCurrency(s: TXmlString): Currency;
function CurrencyToXSTR(v: Currency): TXmlString;
function XSTRToDateTime(const s: String): TDateTime;
function DateTimeToXSTR(v: TDateTime): TXmlString;
function VarToXSTR(const v: TVarData;CodePage:integer): TXmlString;

function TextToXML(const aText: TXmlString; DecodeCRLF: boolean = True): TXmlString;
function BinToBase64(const aBin; aSize, aMaxLineLength: Integer): String;
function Base64ToBin(const aBase64: String): String;
function IsXmlDataString(const aData: String): Boolean;
function XmlIsInBinaryFormat(const aData: String): Boolean;
procedure PrepareToSaveXml(var anElem: IXmlElement; const aChildName: String);
function PrepareToLoadXml(var anElem: IXmlElement; const aChildName: String): Boolean;
function NameCanBeginWith(aChar: TXmlChar): Boolean;
function NameCanContain(aChar: TXmlChar): Boolean;
function IsName(const s: TXmlString): Boolean;

implementation
{$ifdef Delphi7}
uses
  Variants;
{$else}
//Variants support


type   TVarType = Word;

const
  varShortInt = $0010; { vt_i1          16 }
  varWord     = $0012; { vt_ui2         18 }
  varLongWord = $0013; { vt_ui4         19 }
  varInt64    = $0014; { vt_i8          20 }

function FindVarData(const V: Variant): PVarData;
begin
  Result := @TVarData(V);
  while Result.VType = varByRef or varVariant do
    Result := PVarData(Result.VPointer);
end;


function VarTypeIsFloat(const AVarType: TVarType): Boolean;
begin
  Result := AVarType in [varSingle, varDouble, varCurrency];
end;

function VarIsFloat(const V: Variant): Boolean;
begin
  Result := VarTypeIsFloat(FindVarData(V)^.VType);
end;

function VarTypeIsOrdinal(const AVarType: TVarType): Boolean;
begin
  Result := AVarType in [varSmallInt, varInteger, varBoolean, varShortInt,
                         varByte, varWord, varLongWord, varInt64];
end;

function VarTypeIsNumeric(const AVarType: TVarType): Boolean;
begin
  Result := VarTypeIsOrdinal(AVarType) or VarTypeIsFloat(AVarType);
end;

function VarIsNumeric(const V: Variant): Boolean;
begin
  Result := VarTypeIsNumeric(FindVarData(V)^.VType);
end;

function VarSameValue(const A, B: Variant): Boolean;
var
  LA, LB: TVarData;
begin
  LA := FindVarData(A)^;
  LB := FindVarData(B)^;
  try
    if LA.VType = varEmpty then
      Result := LB.VType = varEmpty
    else if LA.VType = varNull then
      Result := LB.VType = varNull
    else if LB.VType in [varEmpty, varNull] then
      Result := False
    else
      Result := A = B;
  except
    Result:=False;
  end;
end;

//����� ������� �� Variants
function Utf8ToUnicode(Dest: PWideChar; MaxDestChars: Cardinal; Source: PChar; SourceBytes: Cardinal): Cardinal;
var
  i, count: Cardinal;
  c: Byte;
  wc: Cardinal;
begin
  if Source = nil then
  begin
    Result := 0;
    Exit;
  end;
  Result := Cardinal(-1);
  count := 0;
  i := 0;
  if Dest <> nil then
  begin
    while (i < SourceBytes) and (count < MaxDestChars) do
    begin
      wc := Cardinal(Source[i]);
      Inc(i);
      if (wc and $80) <> 0 then
      begin
        if i >= SourceBytes then Exit;          // incomplete multibyte char
        wc := wc and $3F;
        if (wc and $20) <> 0 then
        begin
          c := Byte(Source[i]);
          Inc(i);
          if (c and $C0) <> $80 then Exit;      // malformed trail byte or out of range char
          if i >= SourceBytes then Exit;        // incomplete multibyte char
          wc := (wc shl 6) or (c and $3F);
        end;
        c := Byte(Source[i]);
        Inc(i);
        if (c and $C0) <> $80 then Exit;       // malformed trail byte

        Dest[count] := WideChar((wc shl 6) or (c and $3F));
      end
      else
        Dest[count] := WideChar(wc);
      Inc(count);
    end;
    if count >= MaxDestChars then count := MaxDestChars-1;
    Dest[count] := #0;
  end
  else
  begin
    while (i < SourceBytes) do
    begin
      c := Byte(Source[i]);
      Inc(i);
      if (c and $80) <> 0 then
      begin
        if i >= SourceBytes then Exit;          // incomplete multibyte char
        c := c and $3F;
        if (c and $20) <> 0 then
        begin
          c := Byte(Source[i]);
          Inc(i);
          if (c and $C0) <> $80 then Exit;      // malformed trail byte or out of range char
          if i >= SourceBytes then Exit;        // incomplete multibyte char
        end;
        c := Byte(Source[i]);
        Inc(i);
        if (c and $C0) <> $80 then Exit;       // malformed trail byte
      end;
      Inc(count);
    end;
  end;
  Result := count+1;
end;

{$endif Delphi7}


const LoChars:array[0..31] of PXmlChar=('&#0;','&#1;','&#2;','&#3;','&#4;','&#5;',
'&#6;', '&#7;', '&#8;', '&#9;', '&#10;','&#11;','&#12;','&#13;','&#14;','&#15;',
'&#16;','&#17;','&#18;','&#19;','&#20;','&#21;','&#22;','&#23;','&#24;','&#25;',
'&#26;','&#27;','&#28;','&#29;','&#30;','&#31;');

   ltString:PXmlChar='&lt;';
   gtString:PXmlChar='&gt;';
   ampString:PXmlChar='&amp;';
   quotString:PXmlChar='&quot;';

function TextToXML(const aText: TXmlString; DecodeCRLF: boolean = True): TXmlString;
var
	i, j: Integer;
begin
	j := 0;
	for i := 1 to Length(aText) do
		case aText[i] of
			'<', '>': Inc(j, 4);
			'&': Inc(j, 5);
			'"': Inc(j, 6);
      #0..#8: {inc(j,4)};
      #9: inc(j,4);
      #10,#13: if DecodeCRLF then
				Inc(j,5)
                else
				Inc(j);
      #11,#12,#14..#31: {inc(j,5)};
			else
				Inc(j);
		end;
	if j = Length(aText) then
		Result := aText
	else begin
		SetLength(Result, j);
		j := 1;
		for i := 1 to Length(aText) do
			case aText[i] of
				'<': begin Move(ltString^, Result[j], 4*sizeof(tXMLChar)); Inc(j, 4) end;
				'>': begin Move(gtString^, Result[j], 4*sizeof(tXMLChar)); Inc(j, 4) end;
				'&': begin Move(ampString^, Result[j], 5*sizeof(tXMLChar)); Inc(j, 5) end;
				'"': begin Move(quotString^, Result[j], 6*sizeof(tXMLChar)); Inc(j, 6) end;
                                #0..#8: {begin Move(LoChars[ord(aText[i])]^, Result[j], 4*sizeof(tXMLChar)); Inc(j, 4) end};
                                #9: begin Move(LoChars[ord(aText[i])]^, Result[j], 4*sizeof(tXMLChar)); Inc(j, 4) end;
                                #10,#13: if DecodeCRLF then begin
                                          Move(LoChars[ord(aText[i])]^, Result[j], 5*sizeof(tXMLChar)); Inc(j, 5)
                                        end else begin
                                        Result[j] := aText[i]; Inc(j)
                                        end;
                                #11,#12,#14..#31:{ begin Move(LoChars[ord(aText[i])]^, Result[j], 5*sizeof(tXMLChar)); Inc(j, 5) end};
				else begin Result[j] := aText[i]; Inc(j) end;
			end;
	end;
end;

function XSTRToFloat(s: TXmlString): Double;
{$ifndef Delphi7}
var
	aPos: Integer;
{$endif}
begin
  {$ifdef Delphi7}
  	Result := StrToFloat(s,XMLFormatSettings);
  {$else}
	if '.' = DecimalSeparator then
		aPos := Pos(',', s)
	else if ',' = DecimalSeparator then
		aPos := Pos('.', s)
	else begin
		aPos := Pos(',', s);
		if aPos = 0 then
			aPos := Pos('.', s);
	end;

	if aPos <> 0 then
		s[aPos] := TXmlChar(DecimalSeparator);
	Result := StrToFloat(s);
  {$endif}
end;

function FloatToXSTR(v: Double): TXmlString;
{$ifndef Delphi7}
var
	aPos: Integer;
{$endif}
begin
  {$ifdef Delphi7}
	Result := FloatToStr(v,XMLFormatSettings);
  {$else}
	Result := FloatToStr(v);
	aPos := Pos(DecimalSeparator, Result);
	if aPos <> 0 then
		Result[aPos] := '.';
  {$endif}
end;

function XSTRToCurrency(s: TXmlString): Currency;
begin
{$ifdef Delphi7}
  Result:=StrToCurr(s,XMLFormatSettings);
{$else}
  Result:=XSTRToFloat(s);
{$endif}
end;
function CurrencyToXSTR(v: Currency): TXmlString;
{$ifndef Delphi7}
var
	aPos: Integer;
{$endif}
begin
{$ifdef Delphi7}
  Result:=CurrToStr(v,XMLFormatSettings);
{$else}
  Result:=CurrToStr(v);
	aPos := Pos(DecimalSeparator, Result);
	if aPos <> 0 then
		Result[aPos] := '.';
{$endif}
end;

function XSTRToDateTime(const s: String): TDateTime;
var
	aPos: Integer;

	function FetchTo(aStop: Char): Integer;
	var
		i: Integer;
	begin
		i := aPos;
		while (i <= Length(s)) and (s[i] in ['0'..'9']) do
			Inc(i);
		if i > aPos then
			Result := StrToInt(Copy(s, aPos, i - aPos))
		else
			Result := 0;
		if (i <= Length(s)) and (s[i] = aStop) then
			aPos := i + 1
		else
			aPos := Length(s) + 1;
	end;

var
	y, m, d, h, n, ss, ms: Integer;
begin
	aPos := 1;
	y := FetchTo('-'); m := FetchTo('-');
  if y = 0 then // ���� ������ �����, ��� ����
    aPos := 1;
  d := FetchTo('T');
	h := FetchTo(':'); n := FetchTo(':'); ss := FetchTo('.'); ms := FetchTo('-');
  if y = 0 then Result := 0
  else Result := EncodeDate(y, m, d);
  Result := Result + EncodeTime(h, n, ss, ms);
end;

function DateTimeToXSTR(v: TDateTime): TXmlString;
var
	y, m, d, h, n, s, ms: Word;
begin
	DecodeDate(v, y, m, d);
	DecodeTime(v, h, n, s, ms);
	Result := Format('%.4d-%.2d-%.2dT%.2d:%.2d:%.2d', [y, m, d, h, n, s])
end;

function VarToXSTR(const v: TVarData;CodePage:integer): TXmlString;
const
	BoolStr: array[Boolean] of TXmlString = ('0', '1');
var
{$ifdef FPC}
  WS:WideString;
{$endif}
{$ifndef Delphi7}
  {$IFNDEF XML_WIDE_CHARS}
  NewLen:integer;
  {$ENDIF}
{$endif}
{$ifndef Dos32}
	p: Pointer;
{$endif}
begin
  try
    case v.VType of
      varNull: Result := XSTR_NULL;
      varSmallint: Result := IntToStr(v.VSmallInt);
      varInteger: Result := IntToStr(v.VInteger);
      varSingle: Result := FloatToXSTR(v.VSingle);
      varDouble: Result := FloatToXSTR(v.VDouble);
      varCurrency: Result := CurrencyToXSTR(v.VCurrency);
      varDate: Result := DateTimeToXSTR({$ifdef INTDATE}round(v.VDate*mSecsPerDay){$else}v.VDate{$endif});
      varOleStr:
  {$IFDEF XML_WIDE_CHARS}
          Result:=v.VOleStr;
  {$else}
        if CodePage=CP_UTF8 then begin
          {$ifdef Delphi7}
                  {$ifdef FPC}
                                    WS:=v.VOleStr;
                                    Result:=UTF8Encode(WS);
                  {$else}
                            Result:=UTF8Encode(v.VOleStr);
                  {$endif}
          {$else}
          SetLength(Result,length(v.VOleStr)*3);
          NewLen:=WideCharToMultiByte(CodePage, 0, PWideChar(v.VOleStr), length(v.VOleStr),
            PChar(Result), length(Result), nil, nil);
          SetLength(Result,NewLen);
          {$endif}
        end else begin
          SetLength(Result,length(v.VOleStr));
          WideCharToMultiByte(CodePage, 0, PWideChar(v.VOleStr), length(v.VOleStr),
            PChar(Result), length(Result), nil, nil);
        end;
  {$endif}
      varBoolean: Result := BoolStr[v.VBoolean = True];
      varShortInt: Result := IntToStr(ShortInt(v.VByte));
      varByte: Result := IntToStr(v.VByte);
      varWord: Result := IntToStr(word(v.VSmallInt));
      varLongWord: Result := IntToStr(LongWord(v.VInteger));
      varInt64: Result := IntToStr(PInt64(@v.VInteger)^);
      varString: Result := String(v.VString);
      varArray + varByte:
        begin
          {$ifdef Dos32}
          assert(false);
          {$else}
          p := VarArrayLock(Variant(v));
          try
            Result := BinToBase64(p^, VarArrayHighBound(Variant(v), 1) - VarArrayLowBound(Variant(v), 1) + 1, 0);
          finally
            VarArrayUnlock(Variant(v))
          end;
          {$endif}
        end;
      else
        Result := Variant(v)
    end;
  except
    Result:='*** ERROR !!! ***';
  end;
end;

procedure PrepareToSaveXml(var anElem: IXmlElement; const aChildName: String);
begin
	if aChildName <> '' then
		anElem := anElem.AppendElement(aChildName);
end;

function PrepareToLoadXml(var anElem: IXmlElement; const aChildName: String): Boolean;
begin
	if (aChildName <> '') and Assigned(anElem) then
		anElem := anElem.selectSingleNode(aChildName).AsElement;
	Result := Assigned(anElem);
end;

function LoadXMLResource(aModule: HMODULE; aName, aType: PChar; const aXMLDoc: IXmlDocument): boolean;
var
	aRSRC: HRSRC;
	aGlobal: HGLOBAL;
	aSize: DWORD;
	aPointer: Pointer;

	aStream: TStringStream;
begin
	Result := false;

	aRSRC := FindResource(aModule, aName, aType);
	if aRSRC <> 0 then begin
		aGlobal := LoadResource(aModule, aRSRC);
		aSize := SizeofResource(aModule, aRSRC);
		if (aGlobal <> 0) and (aSize <> 0) then begin
			aPointer := LockResource(aGlobal);
			if Assigned(aPointer) then begin
				aStream := TStringStream.Create('');
				try
					aStream.WriteBuffer(aPointer^, aSize);
					aXMLDoc.LoadXML(aStream.DataString);
					Result := true;
				finally
					aStream.Free;
				end;
			end;
		end;
	end;
end;

function IsXmlDataString(const aData: String): Boolean;
var
	i: Integer;
begin
	Result := Copy(aData, 1, BinXmlSignatureSize) = BinXmlSignature;
	if not Result then begin
		i := 1;
		while (i <= Length(aData)) and (aData[i] in [#10, #13, #9, ' ']) do
			Inc(i);
		Result := Copy(aData, i, Length('<?xml ')) = '<?xml ';
	end;
end;

function XmlIsInBinaryFormat(const aData: String): Boolean;
begin
	Result := Copy(aData, 1, BinXmlSignatureSize) = BinXmlSignature
end;

var
	Base64Map: array [0..63] of Char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

type
	PChars = ^TChars;
	TChars = packed record a, b, c, d: Char end;
	POctet = ^TOctet;
	TOctet = packed record a, b, c: Byte; end;

procedure OctetToChars(po: POctet; aCount: Integer; pc: PChars);
var
	o: Integer;
begin
	if aCount = 1 then begin
		o := po.a shl 16;
		LongWord(pc^) := $3D3D3D3D;
		pc.a := Base64Map[(o shr 18) and $3F];
		pc.b := Base64Map[(o shr 12) and $3F];
	end
	else if aCount = 2 then begin
		o := po.a shl 16 or po.b shl 8;
		LongWord(pc^) := $3D3D3D3D;
		pc.a := Base64Map[(o shr 18) and $3F];
		pc.b := Base64Map[(o shr 12) and $3F];
		pc.c := Base64Map[(o shr 6) and $3F];
	end
	else if aCount > 2 then begin
		o := po.a shl 16 or po.b shl 8 or po.c;
		LongWord(pc^) := $3D3D3D3D;
		pc.a := Base64Map[(o shr 18) and $3F];
		pc.b := Base64Map[(o shr 12) and $3F];
		pc.c := Base64Map[(o shr 6) and $3F];
		pc.d := Base64Map[o and $3F];
	end;
end;

function BinToBase64(const aBin; aSize, aMaxLineLength: Integer): String;
var
	o: POctet;
	c: PChars;
	aCount, ClearBase64Size, CRLFToInsert: Integer;
	i: Integer;
begin
	o := @aBin;
	aCount := aSize;
  ClearBase64Size := ((aCount + 2) div 3)*4;
  aMaxLineLength:=(aMaxLineLength div 4) * 4;
  if aMaxLineLength=0 then
    CRLFToInsert:=0
  else CRLFToInsert:=ClearBase64Size div aMaxLineLength;
	SetLength(Result, ClearBase64Size + CRLFToInsert*2);
	c := PChars(Result);
  if aMaxLineLength=0 then begin
    while aCount > 0 do begin
      OctetToChars(o, aCount, c);
		  Inc(o);
		  Inc(c);
		  Dec(aCount, 3);
    end;
	end else begin
    i:=0;
    while aCount > 0 do begin
      OctetToChars(o, aCount, c);
		  Inc(o);
		  Inc(c);
		  Dec(aCount, 3);
      inc(i,4);
      if i=aMaxLineLength then begin
        i:=0;
        c^.a:=#13;
        c^.b:=#10;
        c:=PChars(@c^.c);
      end;
    end;
	end;
end;

function CharTo6Bit(c: Char): Byte;
begin
	case c of
	'+': Result := 62;
	'/': Result := 63;
	'0'..'9':	Result := Ord(c) - Ord('0') + 52;
	//'=': Result := 0; - ���� = ��� �� ������ �������, ��. CharsToOctet
	'A'..'Z': Result := Ord(c) - Ord('A');
	'a'..'z':	Result := Ord(c) - Ord('a') + 26;
	else
		raise SimpleXMLException.CreateFmt(SBadBase64, []);
	end;
end;

procedure CharsToOctet(c: PChars; o: POctet);
var
	i: Integer;
begin
	if c.c = '=' then begin // 1 byte
		i := CharTo6Bit(c.a) shl 18 or CharTo6Bit(c.b) shl 12;
		o.a := (i shr 16) and $FF;
	end
	else if c.d = '=' then begin // 2 bytes
		i := CharTo6Bit(c.a) shl 18 or CharTo6Bit(c.b) shl 12 or CharTo6Bit(c.c) shl 6;
		o.a := (i shr 16) and $FF;
		o.b := (i shr 8) and $FF;
	end
	else begin // 3 bytes
		i := CharTo6Bit(c.a) shl 18 or CharTo6Bit(c.b) shl 12 or CharTo6Bit(c.c) shl 6 or CharTo6Bit(c.d);
		o.a := (i shr 16) and $FF;
		o.b := (i shr 8) and $FF;
		o.c := i and $FF;
	end;
end;

function Base64ToBin(const aBase64: String): String;
var
	o: POctet;
	c: PChars;
	aCount: Integer;
	s: String;
	i, j: Integer;
begin
	s := aBase64;
	i := 1;
	while i <= Length(s) do begin
		while (i <= Length(s)) and (s[i] > ' ') do
			Inc(i);
		if i <= Length(s) then begin
			j := i;
			while (j <= Length(s)) and (s[j] <= ' ') do
				Inc(j);
			Delete(s, i, j - i);
		end;
	end;

	if Length(s) < 4 then begin
		if length(s)>0 then
			raise SimpleXMLException.CreateFmt(SBadBase64, []);
		Result := '';
	end else begin
		aCount := ((Length(s) + 3) div 4)*3;
		if aCount > 0 then begin
			if s[Length(s) - 1] = '=' then
				Dec(aCount, 2)
			else if s[Length(s)] = '=' then
				Dec(aCount);
			SetLength(Result, aCount);
			FillChar(Result[1], aCount, '*');
			c := @s[1];
			o := @Result[1];
			while aCount > 0 do begin
				CharsToOctet(c, o);
				Inc(o);
				Inc(c);
				Dec(aCount, 3);
			end;
		end;
	end;
end;


type
	TBinXmlReader = class
	private
		FOptions: LongWord;
	public
		procedure Read(var aBuf; aSize: Integer); virtual; abstract;
		 
		function ReadLongint: Longint;
		function ReadAnsiString: String;
		function ReadWideString: WideString;
		function ReadXmlString: TXmlString;
		procedure ReadVariant(var v: TVarData);
	end;

	TStmXmlReader = class(TBinXmlReader)
	private
		FStream: TStream;
		FOptions: LongWord;
		FBufStart,
		FBufEnd,
		FBufPtr: PChar;
		FBufSize,
		FRestSize: Integer;
	public
		constructor Create(aStream: TStream; aBufSize: Integer);
		destructor Destroy; override;

		procedure Read(var aBuf; aSize: Integer); override;
	end;

	TStrXmlReader = class(TBinXmlReader)
	private
		FString: String;
		FOptions: LongWord;
		FPtr: PChar;
		FRestSize: Integer;
	public
		constructor Create(const aStr: String);

		procedure Read(var aBuf; aSize: Integer); override;
	end;

	TBinXmlWriter = class
	private
		FOptions: LongWord;
	public
		procedure Write(const aBuf; aSize: Integer); virtual; abstract;
		
		procedure WriteLongint(aValue: Longint);
		procedure WriteAnsiString(const aValue: String);
		procedure WriteWideString(const aValue: WideString);
		procedure WriteXmlString(const aValue: TXmlString);
		procedure WriteVariant(const v: TVarData);
	end;

	TStmXmlWriter = class(TBinXmlWriter)
	private
		FStream: TStream;
		FBufStart,
		FBufEnd,
		FBufPtr: PChar;
		FBufSize: Integer;
	public
		constructor Create(aStream: TStream; anOptions: LongWord; aBufSize: Integer);
		destructor Destroy; override;

		procedure Write(const aBuf; aSize: Integer); override;
	end;

	TStrXmlWriter = class(TBinXmlWriter)
	private
		FData: String;
		FBufStart,
		FBufEnd,
		FBufPtr: PChar;
		FBufSize: Integer;
    procedure FlushBuf;
	public
		constructor Create(anOptions: LongWord; aBufSize: Integer);
		destructor Destroy; override;

		procedure Write(const aBuf; aSize: Integer); override;
	end;
	
	TXmlBase = class(TInterfacedObject, IXmlBase)
	protected
		// ���������� ���������� IXmlBase
		function GetObject: TObject;
	public
	end;

	PNameIndexArray = ^TNameIndexArray;
	TNameIndexArray = array of Longint;
	TXmlNameTable = class(TXmlBase, IXmlNameTable)
	private
		FNames: array of TXmlString;
		FHashTable: array of TNameIndexArray;

		FXmlTextNameID: Integer;
		FXmlCDATASectionNameID: Integer;
		FXmlCommentNameID: Integer;
		FXmlDocumentNameID: Integer;
		FXmlID: Integer;
    cs: tRTLCriticalSection;
	protected
		function GetID(const aName: TXmlString; AnyCaseFirst: boolean = True): Integer;
		function GetName(anID: Integer): TXmlString;
	public
		constructor Create(aHashTableSize: Integer);
    destructor Destroy; override;

		procedure LoadBinXml(aReader: TBinXmlReader);
		procedure SaveBinXml(aWriter: TBinXmlWriter);
	end;

var
	DefaultNameTableImpl: TXmlNameTable = nil;

{ TXmlBase }

function TXmlBase.GetObject: TObject;
begin
	Result := Self;
end;

{ TXmlNameTable }

constructor TXmlNameTable.Create(aHashTableSize: Integer);
begin
	inherited Create;
  InitializeCriticalSection(cs);
	SetLength(FHashTable, aHashTableSize);
	FXmlTextNameID := GetID('#text');
	FXmlCDATASectionNameID := GetID('#cdata-section');
	FXmlCommentNameID := GetID('#comment');
	FXmlDocumentNameID := GetID('#document');
	FXmlID := GetID('xml', False);
end;

procedure TXmlNameTable.LoadBinXml(aReader: TBinXmlReader);
var
	aCount: LongInt;
	anIndex, i: Integer;
begin
	// ������� ������ ����
	aCount := aReader.ReadLongint;
	SetLength(FNames, aCount);
	for i := 0 to aCount - 1 do 
		FNames[i] := aReader.ReadXmlString;

	// ������� ���-�������
	SetLength(FHashTable, aReader.ReadLongint);
	for i := 0 to Length(FHashTable) - 1 do
		SetLength(FHashTable[i], 0);
	aCount := aReader.ReadLongint;
	for i := 0 to aCount - 1 do begin
		anIndex := aReader.ReadLongInt;
		SetLength(FHashTable[anIndex], aReader.ReadLongInt);
		aReader.Read(FHashTable[anIndex][0], Length(FHashTable[anIndex])*sizeof(Longint));
	end;
end;

procedure TXmlNameTable.SaveBinXml(aWriter: TBinXmlWriter);
var
	aCount: LongInt;
	i: Integer;
begin
	// �������� ������ ����
	aCount := Length(FNames);
	aWriter.WriteLongint(aCount);
	for i := 0 to aCount - 1 do 
		aWriter.WriteXmlString(FNames[i]);

	// �������� ���-�������
	aWriter.WriteLongint(Length(FHashTable));
	aCount := 0;
	for i := 0 to Length(FHashTable) - 1 do 
		if Length(FHashTable[i]) > 0 then
			Inc(aCount);
	aWriter.WriteLongint(aCount);
	for i := 0 to Length(FHashTable) - 1 do begin
		aCount := Length(FHashTable[i]);
		if aCount > 0 then begin
			aWriter.WriteLongint(i);
			aWriter.WriteLongint(aCount);
			aWriter.Write(FHashTable[i][0], aCount*sizeof(Longint));
		end
	end;
end;

function TXmlNameTable.GetID(const aName: TXmlString; AnyCaseFirst:boolean): Integer;

	function NameHashKey(const aName: TXmlString): UINT;
	var
		i: Integer;
	begin
		Result := 0;
		for i := 1 to Length(aName) do
			Result := UINT((int64(Result) shl 5) + Result + Ord(aName[i]));
	end;

	function TryFind(aName: TXmlString): Integer;
	var i: integer;
    	aNameIndexes: PNameIndexArray;
	begin
		aNameIndexes := @FHashTable[NameHashKey(aName) mod UINT(Length(FHashTable))];
		for i := 0 to Length(aNameIndexes^) - 1 do begin
			Result := aNameIndexes^[i];
			if (Length(FNames) > Result) and (FNames[Result] = aName) then
				Exit;
		end;
		Result := -1;
	end;

  function Low1Ch(const aName: TXmlString): TXmlString;
  begin
    Result := aName;
    if Length(Result) > 0 then begin
      if (Result[1] >= 'A') and (Result[1] <= 'Z') then
        Result[1] := char(Ord(Result[1]) + 32); // ������ �� ������� ����� ���������
    end;
  end;

  function High1Ch(const aName: TXmlString): TXmlString;
  begin
    Result := aName;
    if Length(Result) > 0 then begin
      if (Result[1] >= 'a') and (Result[1] <= 'z') then
        Result[1] := char(Ord(Result[1]) - 32); // ������ �� ��������� ����� ������� 
    end;
  end;

var
	aNameIndexes: PNameIndexArray;
begin
	if aName = '' then
		Result := -1
	else begin
    EnterCriticalSection(cs);
    try
      Result := TryFind(aName);
      if Result >= 0 then Exit;

      if AnyCaseFirst then begin
        // kudin: 17.04.2011 ���� �� �����, �� ������� �������� ���� �����, �� � ��������� �����
        Result := TryFind(Low1Ch(aName));
        if Result >= 0 then Exit;
        // kudin: 05.10.2011 ���� �� �����, �� ������� �������� ���� �����, �� � ������� �����
        Result := TryFind(High1Ch(aName));
        if Result >= 0 then Exit;
      end;

      Result := Length(FNames);
      SetLength(FNames, Result + 1);
      FNames[Result] := aName;

      aNameIndexes := @FHashTable[NameHashKey(aName) mod UINT(Length(FHashTable))];
      SetLength(aNameIndexes^, Length(aNameIndexes^) + 1);
      aNameIndexes^[Length(aNameIndexes^) - 1] := Result;
    finally
      LeaveCriticalSection(cs);
    end;
	end;
end;

function TXmlNameTable.GetName(anID: Integer): TXmlString;
begin
	if anID < 0 then
		Result := ''
	else
		Result := FNames[anID]
end;

function CreateNameTable(aHashTableSize: Integer): IXmlNameTable;
begin
	Result := TXmlNameTable.Create(aHashTableSize)
end;

type
	TXmlNode = class;
	TXmlToken = class
	private
		FValueBuf: TXmlString;
		FValueStart,
		FValuePtr,
		FValueEnd: PXmlChar;
	public
		constructor Create;
		procedure Clear;
		procedure AppendChar(aChar: TXmlChar);
		procedure AppendText(aText: PXmlChar; aCount: Integer);
		function Length: Integer;

		property ValueStart: PXmlChar read FValueStart;
	end;

	TXmlSource = class
	private
		FTokenStack: array of TXmlToken;
		FTokenStackTop: Integer;
		FToken: TXmlToken;
		function ExpectQuotedText(aQuote: TXmlChar): TXmlString;
	public
		CurChar: TXmlChar;
                fUTF8:boolean;
                fCodePage:word;
		constructor Create;
		destructor Destroy; override;

		function EOF: Boolean; virtual; abstract;
		function Next: Boolean; virtual; abstract;

		procedure SkipBlanks;
		function ExpectXmlName: TXmlString;
		function ExpectXmlEntity: TXmlChar;
		procedure ExpectChar(aChar: TXmlChar);
		procedure ExpectText(aText: PXmlChar);
		function ExpectDecimalInteger: Integer;
		function ExpectHexInteger: Integer;
		function ParseTo(aText: PXmlChar): TXmlString;
		procedure ParseAttrs(aNode: TXmlNode);

		procedure NewToken;
		procedure AppendTokenChar(aChar: TXmlChar);
		procedure AppendTokenText(aText: PXmlChar; aCount: Integer);
		function AcceptToken: TXmlString;
		procedure DropToken;
	end;

	TXmlStrSource = class(TXmlSource)
	private
		FSource: TXmlString;
		FSourcePtr,
		FSourceEnd: PXmlChar;
	public
		constructor Create(const aSource: TXmlString);
		function EOF: Boolean; override;
		function Next: Boolean; override;
	end;

	TXmlStmSource = class(TXmlSource)
	private
		FStream: TStream;
		FBufStart,
		FBufPtr,
		FBufEnd: PChar;
		FBufSize: Integer;
		FSize: Integer;
	{$IFDEF XML_WIDE_CHARS}
                IsUTF16: boolean;
                function AnsiToUnicode(c: AnsiChar): WideChar;
	{$endif}
		function InternalNext: Boolean;
	public
		constructor Create(aStream: TStream; aBufSize: Integer);
		function EOF: Boolean; override;
		function Next: Boolean; override;
		destructor Destroy; override;
	end;

	TXmlNodeList = class(TXmlBase, IXmlNodeList)
	private
		FOwnerNode: TXmlNode;

		FItems: array of TXmlNode;
		FCount: Integer;
		procedure Grow;
	protected
		function Get_Count: Integer;
		function Get_Item(anIndex: Integer): IXmlNode;
		function Get_XML: TXmlString;
	public
		constructor Create(anOwnerNode: TXmlNode);
		destructor Destroy; override;

		function IndexOf(aNode: TXmlNode): Integer;
		procedure ParseXML(aXML: TXmlSource; aNames: TXmlNameTable; aPreserveWhiteSpace: Boolean);

		procedure LoadBinXml(aReader: TBinXmlReader; aCount: Integer; aNames: TXmlNameTable);
		procedure SaveBinXml(aWriter: TBinXmlWriter);

		procedure Insert(aNode: TXmlNode; anIndex: Integer);
		function Remove(aNode: TXmlNode): Integer;
		procedure Delete(anIndex: Integer);
		procedure Replace(anIndex: Integer; aNode: TXmlNode);
		procedure Clear;
	end;

	PXmlAttrData = ^TXmlAttrData;
	TXmlAttrData = record
		NameID: Integer;
		Value: Variant;
	end;

	TXmlDocument = class;
	TXmlNode = class(TXmlBase, IXmlNode)
	private
		FParentNode: TXmlNode;
		// FNames - ������� ����. �������� �����
		FNames: TXmlNameTable;
		// ���������� ��������� � ������� FAttrs
		FAttrCount: Integer;
		// ������ ���������
		FAttrs: array of TXmlAttrData;
		// ������ �������� �����
		FChilds: TXmlNodeList;
		function GetChilds: TXmlNodeList; virtual;
		function FindFirstChild(aNameID: Integer): TXmlNode;
		function GetAttrsXML: TXmlString;
		function FindAttrData(aNameID: Integer): PXmlAttrData;
		function GetOwnerDocument: TXmlDocument;
		procedure SetNameTable(aValue: TXmlNameTable; aMap: TList);
		procedure SetNodeNameID(aValue: Integer); virtual;
		function DoCloneNode(aDeep: Boolean): IXmlNode; virtual; abstract;

	protected
		// IXmlNode
		function Get_NameTable: IXmlNameTable;
		function Get_NodeName: TXmlString;

		function Get_NodeNameID: Integer; virtual; abstract;
		function Get_NodeType: Integer; virtual; abstract;
		function Get_Text: TXmlString; virtual; abstract;
		procedure Set_Text(const aValue: TXmlString); virtual; abstract;
		function CloneNode(aDeep: Boolean): IXmlNode;

		procedure LoadBinXml(aReader: TBinXmlReader);
		procedure SaveBinXml(aWriter: TBinXmlWriter);

		function Get_DataType: Integer; virtual;
		function Get_TypedValue: Variant; virtual;
		procedure Set_TypedValue(const aValue: Variant); virtual;

		function Get_XML: TXmlString; virtual; abstract;

		function Get_OwnerDocument: IXmlDocument; virtual;
		function Get_ParentNode: IXmlNode;

		function Get_ChildNodes: IXmlNodeList; virtual;
		procedure AppendChild(const aChild: IXmlNode);

		function AppendElement(aNameID: Integer): IXmlElement; overload;
		function AppendElement(const aName: TxmlString): IXmlElement; overload;
		function AppendText(const aData: TXmlString): IXmlText;
		function AppendCDATA(const aData: TXmlString): IXmlCDATASection;
		function AppendComment(const aData: TXmlString): IXmlComment;
		function AppendProcessingInstruction(aTargetID: Integer;
			const aData: TXmlString): IXmlProcessingInstruction; overload;
		function AppendProcessingInstruction(const aTarget: TXmlString;
			const aData: TXmlString): IXmlProcessingInstruction; overload;

		procedure InsertBefore(const aChild, aBefore: IXmlNode);
		procedure ReplaceChild(const aNewChild, anOldChild: IXmlNode);
		procedure RemoveChild(const aChild: IXmlNode);
		function GetChildText(const aName: TXmlString; const aDefault: TXmlString = ''): TXmlString; overload;
		function GetChildText(aNameID: Integer; const aDefault: TXmlString = ''): TXmlString; overload;
		procedure SetChildText(const aName, aValue: TXmlString); overload;
		procedure SetChildText(aNameID: Integer; const aValue: TXmlString); overload;

		function NeedChild(aNameID: Integer): IXmlNode; overload;
		function NeedChild(const aName: TXmlString): IXmlNode; overload;
		function EnsureChild(aNameID: Integer): IXmlNode; overload;
		function EnsureChild(const aName: TXmlString): IXmlNode; overload;

		procedure RemoveAllChilds;

		function SelectNodes(const anExpression: TXmlString): IXmlNodeList;
		function SelectSingleNode(const anExpression: TXmlString): IXmlNode;
		function FindElement(const anElementName, anAttrName: String; const anAttrValue: Variant): IXmlElement;

		function Get_AttrCount: Integer;
		function Get_AttrNameID(anIndex: Integer): Integer;
		function Get_AttrName(anIndex: Integer): TXmlString;
		procedure RemoveAttr(const aName: TXmlString); overload;
		procedure RemoveAttr(aNameID: Integer); overload;
		procedure RemoveAllAttrs;

		function AttrExists(aNameID: Integer): Boolean; overload;
		function AttrExists(const aName: TXmlString): Boolean; overload;

		function GetAttrType(aNameID: Integer): Integer; overload;
		function GetAttrType(const aName: TXmlString): Integer; overload;

		function GetVarAttr(aNameID: Integer; const aDefault: Variant): Variant; overload;
		function GetVarAttr(const aName: TXmlString; const aDefault: Variant): Variant; overload;
		procedure SetVarAttr(aNameID: Integer; const aValue: Variant); overload;
		procedure SetVarAttr(const aName: TXmlString; aValue: Variant); overload;

		function NeedAttr(aNameID: Integer): TXmlString; overload;
		function NeedAttr(const aName: TXmlString): TXmlString; overload;

		function GetAttr(aNameID: Integer; const aDefault: TXmlString = ''): TXmlString; overload;
		function GetAttr(const aName: TXmlString; const aDefault: TXmlString = ''): TXmlString; overload;
		procedure SetAttr(aNameID: Integer; const aValue: TXmlString); overload;
		procedure SetAttr(const aName, aValue: TXmlString); overload;

		function GetBoolAttr(aNameID: Integer; aDefault: Boolean = False): Boolean; overload;
		function GetBoolAttr(const aName: TXmlString; aDefault: Boolean = False): Boolean; overload;
		procedure SetBoolAttr(aNameID: Integer; aValue: Boolean = False); overload;
		procedure SetBoolAttr(const aName: TXmlString; aValue: Boolean); overload;

		function GetIntAttr(aNameID: Integer; aDefault: tIntValue = 0): tIntValue; overload;
		function GetIntAttr(const aName: TXmlString; aDefault: tIntValue = 0): tIntValue; overload;
		procedure SetIntAttr(aNameID: Integer; aValue: tIntValue); overload;
		procedure SetIntAttr(const aName: TXmlString; aValue: tIntValue); overload;

		function GetDateTimeAttr(aNameID: Integer; aDefault: TDateTime = 0): TDateTime; overload;
		function GetDateTimeAttr(const aName: TXmlString; aDefault: TDateTime = 0): TDateTime; overload;
		procedure SetDateTimeAttr(aNameID: Integer; aValue: TDateTime); overload;
		procedure SetDateTimeAttr(const aName: TXmlString; aValue: TDateTime); overload;

		function GetFloatAttr(aNameID: Integer; aDefault: Double = 0): Double; overload;
		function GetFloatAttr(const aName: TXmlString; aDefault: Double = 0): Double; overload;
		procedure SetFloatAttr(aNameID: Integer; aValue: Double); overload;
		procedure SetFloatAttr(const aName: TXmlString; aValue: Double); overload;

		function GetHexAttr(const aName: TXmlString; aDefault: Integer = 0): Integer; overload;
		function GetHexAttr(aNameID: Integer; aDefault: Integer = 0): Integer; overload;
		procedure SetHexAttr(const aName: TXmlString; aValue: Integer; aDigits: Integer = 8); overload;
		procedure SetHexAttr(aNameID: Integer; aValue: Integer; aDigits: Integer = 8); overload;

		function GetEnumAttr(const aName: TXmlString;
			const aValues: array of TXmlString; aDefault: Integer): Integer; overload;
		function GetEnumAttr(aNameID: Integer;
			const aValues: array of TXmlString; aDefault: Integer): Integer; overload;
		function NeedEnumAttr(const aName: TXmlString;
			const aValues: array of TXmlString): Integer; overload;
		function NeedEnumAttr(aNameID: Integer;
			const aValues: array of TXmlString): Integer; overload;


		function Get_Values(const aName: String): Variant;
		procedure Set_Values(const aName: String; const aValue: Variant);

		function AsElement: IXmlElement; virtual;
		function AsText: IXmlText; virtual;
		function AsCDATASection: IXmlCDATASection; virtual;
		function AsComment: IXmlComment; virtual;
		function AsProcessingInstruction: IXmlProcessingInstruction; virtual; 

	public
		constructor Create(aNames: TXmlNameTable);
		destructor Destroy; override;
	end;

	TXmlElement = class(TXmlNode, IXmlElement)
	private
		FNameID: Integer;
		FData: Variant;
		procedure RemoveTextNodes;
		procedure SetNodeNameID(aValue: Integer); override;
		function DoCloneNode(aDeep: Boolean): IXmlNode; override;
	protected
		function GetChilds: TXmlNodeList; override;

		function Get_NodeNameID: Integer; override;
		function Get_NodeType: Integer; override;
		function Get_Text: TXmlString; override;
		procedure Set_Text(const aValue: TXmlString); override;
		function Get_DataType: Integer; override;
		function Get_TypedValue: Variant; override;
		procedure Set_TypedValue(const aValue: Variant); override;
		function Get_XML: TXmlString; override;
		function AsElement: IXmlElement; override;
		function Get_ChildNodes: IXmlNodeList; override;

		// IXmlElement
		procedure ReplaceTextByCDATASection(const aText: TXmlString);
		procedure ReplaceTextByBynaryData(const aData; aSize: Integer;
			aMaxLineLength: Integer);
		function GetTextAsBynaryData: TXmlString;
	public
		constructor Create(aNames: TXmlNameTable; aNameID: Integer);
	end;

	TXmlCharacterData = class(TXmlNode, IXmlCharacterData)
	private
		FData: TXmlString;
	protected
		function Get_Text: TXmlString; override;
		procedure Set_Text(const aValue: TXmlString); override;
	public
		constructor Create(aNames: TXmlNameTable; const aData: TXmlString);
	end;

	TXmlText = class(TXmlNode, IXmlText)
	private
		FData: Variant;
                IsBase64Text: boolean;
		function DoCloneNode(aDeep: Boolean): IXmlNode; override;
	protected
		function Get_NodeNameID: Integer; override;
		function Get_NodeType: Integer; override;
		function Get_Text: TXmlString; override;
		procedure Set_Text(const aValue: TXmlString); override;
		function Get_DataType: Integer; override;
		function Get_TypedValue: Variant; override;
		procedure Set_TypedValue(const aValue: Variant); override;
		function Get_XML: TXmlString; override;
		function AsText: IXmlText; override;
	public
		constructor Create(aNames: TXmlNameTable; const aData: Variant);
	end;

	TXmlCDATASection = class(TXmlCharacterData, IXmlCDATASection)
	protected
		function Get_NodeNameID: Integer; override;
		function Get_NodeType: Integer; override;
		function Get_XML: TXmlString; override;
		function AsCDATASection: IXmlCDATASection; override;
		function DoCloneNode(aDeep: Boolean): IXmlNode; override;
	public
	end;

	TXmlComment = class(TXmlCharacterData, IXmlComment)
	protected
		function Get_NodeNameID: Integer; override;
		function Get_NodeType: Integer; override;
		function Get_XML: TXmlString; override;
		function AsComment: IXmlComment; override;
		function DoCloneNode(aDeep: Boolean): IXmlNode; override;
	public
	end;

	TXmlProcessingInstruction = class(TXmlNode, IXmlProcessingInstruction)
	private
		FTargetID: Integer;
		FData: String;
		procedure SetNodeNameID(aValue: Integer); override;
		function DoCloneNode(aDeep: Boolean): IXmlNode; override;
	protected
		function Get_NodeNameID: Integer; override;
		function Get_NodeType: Integer; override;
		function Get_Text: TXmlString; override;
		procedure Set_Text(const aText: TXmlString); override;
		function Get_XML: TXmlString; override;
		function AsProcessingInstruction: IXmlProcessingInstruction; override;

	public
		constructor Create(aNames: TXmlNameTable; aTargetID: Integer;
			const aData: TXmlString);
	end;

	TXmlDocument = class(TXmlNode, IXmlDocument)
	private
		FPreserveWhiteSpace: Boolean;
    fCodePage:integer;
    fNewNames: TXmlNameTable;
  	ToWriteInEmptyXMLDocumentProc: TGetBodyCallback;//��� ���� ���������, ���� ���� �������� ����� ���� ��������� "���-XML"
    EmptyXMLDocumentElementToWriteIn: tXMLString;//���� ���� �������� ToWriteInEmptyXMLDocumentProc
    WriteBodyLevel:integer;
    FGetXMLIntend: Integer;

		function DoCloneNode(aDeep: Boolean): IXmlNode; override;
                function Get_Encoding: string;
                function CodePage:integer;
	protected
		function Get_NodeNameID: Integer; override;
		function Get_NodeType: Integer; override;
		function Get_Text: TXmlString; override;
		procedure Set_Text(const aText: TXmlString); override;
		function Get_XML: TXmlString; override;
		function Get_PreserveWhiteSpace: Boolean;
		procedure Set_PreserveWhiteSpace(aValue: Boolean);

		function NewDocument(const aVersion, anEncoding: TXmlString;
			aRootElementNameID: Integer): IXmlElement; overload;
		function NewDocument(const aVersion, anEncoding,
			aRootElementName: TXmlString): IXmlElement; overload;

		function CreateElement(aNameID: Integer): IXmlElement; overload;
		function CreateElement(const aName: TXmlString): IXmlElement; overload;
		function CreateText(const aData: TXmlString): IXmlText;
		function CreateCDATASection(const aData: TXmlString): IXmlCDATASection;
		function CreateComment(const aData: TXmlString): IXmlComment;
		function Get_DocumentElement: IXmlElement;
		function CreateProcessingInstruction(const aTarget,
			aData: TXmlString): IXmlProcessingInstruction; overload;
		function CreateProcessingInstruction(aTargetID: Integer;
			const aData: TXmlString): IXmlProcessingInstruction; overload;
		procedure LoadXML(const aXML: TXmlString);

		procedure Load(aStream: TStream); overload;
		procedure Load(const aFileName: TXmlString); overload;

		procedure LoadResource(aType, aName: PChar);

		procedure Save(aStream: TStream); overload;
		procedure SaveWithElementBody(aStream: TStream; GetBodyCallback: TGetBodyCallback;
			TagToWriteIn:TXmlString);
		procedure Save(const aFileName: TXmlString); overload;

		procedure SaveBinary(aStream: TStream; anOptions: LongWord); overload;
		procedure SaveBinary(const aFileName: TXmlString; anOptions: LongWord); overload;

		function Get_BinaryXML: String;
		procedure LoadBinaryXML(const aXML: String);
	public
		constructor Create(aNames: TXmlNameTable);
    destructor Destroy; override;
	end;

destructor TXmlNameTable.Destroy;
begin
  DeleteCriticalSection(cs);
  inherited;
end;

{ TXmlNodeList }

procedure TXmlNodeList.Clear;
var
	i: Integer;
	aNode: TXmlNode;
begin
	for i := 0 to FCount - 1 do begin
		aNode := FItems[i];
		if Assigned(FOwnerNode) and (FOwnerNode=aNode.FParentNode) then
			aNode.FParentNode := nil;
		aNode._Release;
	end;
	FCount := 0;
end;

procedure TXmlNodeList.Delete(anIndex: Integer);
var
	aNode: TXmlNode;
begin
	aNode := FItems[anIndex];
	Dec(FCount);
	if anIndex < FCount then
		Move(FItems[anIndex + 1], FItems[anIndex],
			(FCount - anIndex)*SizeOf(TXmlNode));
	if Assigned(aNode) then begin
		if Assigned(FOwnerNode) then
			aNode.FParentNode := nil;
		aNode._Release;
	end;
end;

constructor TXmlNodeList.Create(anOwnerNode: TXmlNode);
begin
	inherited Create;
	FOwnerNode := anOwnerNode;
end;

destructor TXmlNodeList.Destroy;
begin
	Clear;
	inherited;
end;

function TXmlNodeList.Get_Item(anIndex: Integer): IXmlNode;
begin
	if (anIndex < 0) or (anIndex >= FCount) then
		raise SimpleXMLException.Create(SSimpleXmlError1);
	Result := FItems[anIndex]
end;

function TXmlNodeList.Get_Count: Integer;
begin
	Result := FCount
end;

function TXmlNodeList.IndexOf(aNode: TXmlNode): Integer;
var
	i: Integer;
begin
	for i := 0 to FCount - 1 do
		if FItems[i] = aNode then begin
			Result := i;
			Exit
		end;
	Result := -1;
end;

procedure TXmlNodeList.Grow;
var
	aDelta: Integer;
begin
	if Length(FItems) > 64 then
		aDelta := Length(FItems) div 4
	else
		if Length(FItems) > 8 then
			aDelta := 16
		else
			aDelta := 4;
	SetLength(FItems, Length(FItems) + aDelta);
end;

procedure TXmlNodeList.Insert(aNode: TXmlNode; anIndex: Integer);
begin
	if anIndex = -1 then
		anIndex := FCount;
	if FCount = Length(FItems) then
		Grow;
	if anIndex < FCount then
		Move(FItems[anIndex], FItems[anIndex + 1],
			(FCount - anIndex)*SizeOf(TXmlNode));
	FItems[anIndex] := aNode;
	Inc(FCount);
	if aNode <> nil then begin
		aNode._AddRef;
		if Assigned(FOwnerNode) then begin
			aNode.FParentNode := FOwnerNode;
			aNode.SetNameTable(FOwnerNode.FNames, nil);
		end;
	end;
end;

function TXmlNodeList.Remove(aNode: TXmlNode): Integer;
begin
	Result := IndexOf(aNode);
	if Result <> -1 then
		Delete(Result);
end;

procedure TXmlNodeList.Replace(anIndex: Integer; aNode: TXmlNode);
var
	anOldNode: TXmlNode;
begin
	anOldNode := FItems[anIndex];
	if aNode <> anOldNode then begin
		if Assigned(anOldNode) then begin
			if Assigned(FOwnerNode) then
				anOldNode.FParentNode := nil;
			anOldNode._Release;
		end;
		FItems[anIndex] := aNode;
		if Assigned(aNode) then begin
			aNode._AddRef;
			if Assigned(FOwnerNode) then begin
				aNode.FParentNode := FOwnerNode;
				aNode.SetNameTable(FOwnerNode.FNames, nil);
			end
		end
	end;
end;

function TXmlNodeList.Get_XML: TXmlString;
var
	i: Integer;
begin
	Result := '';
	for i := 0 to FCount - 1 do
		Result := Result + FItems[i].Get_XML;
end;

procedure TXmlNodeList.ParseXML(aXML: TXmlSource; aNames: TXmlNameTable; aPreserveWhiteSpace: Boolean);

	// �� �����: ������ ������
	// �� ������: ������ �������� '<'
	procedure ParseText;
	var
		aText: String;
	{$IFNDEF XML_WIDE_CHARS}
        len: cardinal;
        WS: WideString;
	{$ENDIF}
	begin
		aXml.NewToken;
		while not aXML.EOF and (aXML.CurChar <> '<') do
			if aXML.CurChar = '&' then
				aXml.AppendTokenChar(aXml.ExpectXmlEntity)
			else begin
				aXml.AppendTokenChar(aXML.CurChar);
				aXML.Next;
			end;
		aText := aXml.AcceptToken;
		if aPreserveWhiteSpace or (Trim(aText) <> '') then begin
	{$IFNDEF XML_WIDE_CHARS}
                if aXML.fUTF8 then begin
                        len:=Utf8ToUnicode(nil, 0, pChar(aText), length(aText));
                        if len=Cardinal(-1) then
		                raise SimpleXMLException.CreateFmt(SBadUTF8, []);
                        if len=cardinal(length(aText)) then
                                Insert(TXmlText.Create(aNames, aText), -1)
                        else begin
                                SetLength(WS,len-1);
                                Utf8ToUnicode(PWideChar(WS), len, pChar(aText), length(aText));
                                Insert(TXmlText.Create(aNames, WS), -1);
                        end;
                end else
	{$ENDIF}
			Insert(TXmlText.Create(aNames, aText), -1);
                end;
	end;

	// CurChar - '?'
	procedure ParseProcessingInstruction;
	var
		aTarget: TXmlString;
		aNode: TXmlProcessingInstruction;
	begin
		aXML.Next;
		aTarget := aXML.ExpectXmlName;
		aNode := TXmlProcessingInstruction.Create(aNames, aNames.GetID(aTarget, False), '');
		Insert(aNode, -1);
		if aNode.FTargetID = aNames.FXmlID then begin
			aXml.ParseAttrs(aNode);
			aXml.ExpectText('?>');
                aXML.fCodePage:=EncodingToCodePage(aNode.GetAttr('encoding'));
		if LoadUTF8AsWideString and (aXML.fCodePage=CP_UTF8) then
			aXML.fUTF8:=True;
		end
		else
			aNode.FData := aXml.ParseTo('?>');
	end;

	// �� �����: ������ '--'
	// �� ������: ������ ����� '-->'
	procedure ParseComment;
	begin
		aXml.ExpectText('--');
		Insert(TXmlComment.Create(aNames, aXml.ParseTo('-->')), -1);
	end;

	// �� �����: '[CDATA['
	// �� ������: ������ ����� ']]>'
	procedure ParseCDATA;
	begin
		aXml.ExpectText('[CDATA[');
		Insert(TXmlCDATASection.Create(aNames, aXml.ParseTo(']]>')), -1);
	end;


	// �� �����: 'DOCTYPE'
	// �� ������: ������ ����� '>'
	procedure ParseDOCTYPE;
	begin
		aXml.ExpectText('DOCTYPE');
		aXml.ParseTo('>');
	end;

	// �� �����: '���-��������'
	// �� ������: ������ ����� '>'
	procedure ParseElement;
	var
		aNameID: Integer;
		aNode: TXmlElement;
	begin
		aNameID := aNames.GetID(aXml.ExpectXmlName, False);
		if aXml.EOF then
			raise SimpleXMLException.Create(SSimpleXMLError2);
		if not ((aXml.CurChar <= ' ') or (aXml.CurChar = '/') or (aXml.CurChar = '>')) then
			raise SimpleXMLException.Create(SSimpleXMLError3);
		aNode := TXmlElement.Create(aNames, aNameID);
		Insert(aNode, -1);
		aXml.ParseAttrs(aNode);
		if aXml.CurChar = '/' then
			aXml.ExpectText('/>')
		else begin
			aXml.ExpectChar('>');
			aNode.GetChilds.ParseXML(aXml, aNames, aPreserveWhiteSpace);
			aXml.ExpectChar('/');
			aXml.ExpectText(PXmlChar(aNames.GetName(aNameID)));
			aXml.SkipBlanks;
			aXml.ExpectChar('>');
		end;
	end;

begin
	while not aXML.EOF do begin
		ParseText;
		if aXML.CurChar = '<' then // ������ ��������
			if aXML.Next then
				if aXML.CurChar = '/' then // ����������� ��� ��������
					Exit
				else if aXML.CurChar = '?' then // ����������
					ParseProcessingInstruction
				else if aXML.CurChar = '!' then begin
					if aXML.Next then
						if aXML.CurChar = '-' then // ����������
							ParseComment
						else if aXML.CurChar = '[' then // ������ CDATA
							ParseCDATA
						else
							ParseDOCTYPE
				end
				else // ����������� ��� ��������
					ParseElement
	end;
end;

procedure TXmlNodeList.LoadBinXml(aReader: TBinXmlReader;
	aCount: Integer; aNames: TXmlNameTable);
var
	i: Integer;
	aNodeType: Byte;
	aNode: TXmlNode;
	aNameID: LongInt;
begin
	Clear;
	SetLength(FItems, aCount);
	for i := 0 to aCount - 1 do begin
		aReader.Read(aNodeType, sizeof(aNodeType));
		case aNodeType of
			NODE_ELEMENT:
				begin
					aNameID := aReader.ReadLongint;
					aNode := TXmlElement.Create(aNames, aNameID);
					Insert(aNode, -1);
					aReader.ReadVariant(TVarData(TXmlElement(aNode).FData));
					aNode.LoadBinXml(aReader);
				end;
			NODE_TEXT:
				begin
					aNode := TXmlText.Create(aNames, Unassigned);
					Insert(aNode, -1);
					aReader.ReadVariant(TVarData(TXmlText(aNode).FData));
				end;
			NODE_CDATA_SECTION:
				Insert(TXmlCDATASection.Create(aNames, aReader.ReadXmlString), -1);
			NODE_PROCESSING_INSTRUCTION:
				begin
					aNameID := aReader.ReadLongint;
					aNode := TXmlProcessingInstruction.Create(aNames, aNameID,
						aReader.ReadXmlString);
					Insert(aNode, -1);
					aNode.LoadBinXml(aReader);
				end;
			NODE_COMMENT:
				Insert(TXmlComment.Create(aNames, aReader.ReadXmlString), -1);
			else
				raise SimpleXMLException.Create(SSimpleXMLError4);
		end
	end;
end;

procedure TXmlNodeList.SaveBinXml(aWriter: TBinXmlWriter);
const
	EmptyVar: TVarData = (VType:varEmpty);
var
	aCount: LongInt;
	i: Integer;
	aNodeType: Byte;
	aNode: TXmlNode;
begin
	aCount := FCount;
	for i := 0 to aCount - 1 do begin
		aNode := FItems[i];
		aNodeType := aNode.Get_NodeType;
		aWriter.Write(aNodeType, sizeof(aNodeType));
		case aNodeType of
			NODE_ELEMENT:
				with TXmlElement(aNode) do begin
					aWriter.WriteLongint(FNameID);
					if Assigned(FChilds) and (FChilds.FCount > 0) or VarIsEmpty(FData) then
						aWriter.WriteVariant(EmptyVar)
					else
						aWriter.WriteVariant(TVarData(FData));
					SaveBinXml(aWriter);
				end;
			NODE_TEXT:
				aWriter.WriteVariant(TVarData(TXmlText(aNode).FData));
			NODE_CDATA_SECTION:
				aWriter.WriteXmlString(TXmlCDATASection(aNode).FData);
			NODE_PROCESSING_INSTRUCTION:
				begin
					aWriter.WriteLongint(TXmlProcessingInstruction(aNode).FTargetID);
					aWriter.WriteXmlString(TXmlProcessingInstruction(aNode).FData);
					aNode.SaveBinXml(aWriter);
				end;
			NODE_COMMENT:
				aWriter.WriteXmlString(TXmlComment(aNode).FData);
			else
				raise SimpleXMLException.Create(SSimpleXmlError5);
		end
	end;
end;

{ TXmlNode }

constructor TXmlNode.Create(aNames: TXmlNameTable);
begin
	inherited Create;
	FNames := aNames;
	FNames._AddRef;
end;

destructor TXmlNode.Destroy;
begin
	if Assigned(FChilds) then
		FChilds._Release;
	FNames._Release;
	inherited;
end;

function TXmlNode.GetChilds: TXmlNodeList;
begin
	if not Assigned(FChilds) then begin
		FChilds := TXmlNodeList.Create(Self);
		FChilds._AddRef;
	end;
	Result := FChilds;
end;

procedure TXmlNode.AppendChild(const aChild: IXmlNode);
begin
	GetChilds.Insert(aChild.GetObject as TXmlNode, -1);
end;

function TXmlNode.Get_AttrCount: Integer;
begin
	Result := FAttrCount;
end;

function TXmlNode.Get_AttrName(anIndex: Integer): TXmlString;
begin
	Result := FNames.GetName(FAttrs[anIndex].NameID);
end;

function TXmlNode.Get_AttrNameID(anIndex: Integer): Integer;
begin
	Result := FAttrs[anIndex].NameID;
end;

function TXmlNode.Get_ChildNodes: IXmlNodeList;
begin
	Result := GetChilds
end;

function TXmlNode.Get_NameTable: IXmlNameTable;
begin
	Result := FNames
end;

function TXmlNode.GetAttr(const aName, aDefault: TXmlString): TXmlString;
begin
	Result := GetAttr(FNames.GetID(aName), aDefault);
end;

function TXmlNode.GetAttr(aNameID: Integer;
	const aDefault: TXmlString): TXmlString;
var
	aData: PXmlAttrData;
begin
	aData := FindAttrData(aNameID);
	if Assigned(aData) then
		Result := aData.Value
	else
		Result := aDefault
end;

function TXmlNode.GetBoolAttr(aNameID: Integer;
  aDefault: Boolean): Boolean;
var
	aData: PXmlAttrData;
begin
	aData := FindAttrData(aNameID);
	if Assigned(aData) then
		Result := aData.Value
	else
		Result := aDefault
end;

function TXmlNode.GetBoolAttr(const aName: TXmlString;
  aDefault: Boolean): Boolean;
begin
	Result := GetBoolAttr(FNames.GetID(aName), aDefault)
end;

function TXmlNode.FindFirstChild(aNameID: Integer): TXmlNode;
var
	i: Integer;
begin
	if Assigned(FChilds) then
		for i := 0 to FChilds.FCount - 1 do begin
			Result := FChilds.FItems[i];
			if Result.Get_NodeNameID = aNameID then
				Exit
		end;
	Result := nil
end;

function TXmlNode.GetChildText(aNameID: Integer;
	const aDefault: TXmlString): TXmlString;
var
	aChild: TXmlNode;
begin
	aChild := FindFirstChild(aNameID);
	if Assigned(aChild) then
		Result := aChild.Get_Text
	else
		Result := aDefault
end;

function TXmlNode.GetChildText(const aName: TXmlString;
  const aDefault: TXmlString): TXmlString;
begin
	Result := GetChildText(FNames.GetID(aName), aDefault);
end;

function TXmlNode.GetEnumAttr(const aName: TXmlString;
	const aValues: array of TXmlString; aDefault: Integer): Integer;
begin
	Result := GetEnumAttr(FNames.GetID(aName), aValues, aDefault);
end;

function EnumAttrValue(aNode: TXmlNode; anAttrData: PXmlAttrData;
	const aValues: array of TXmlString): Integer;
var
	anAttrValue: TXmlString;
	s: String;
	i: Integer;
begin
	anAttrValue := anAttrData.Value;
	for Result := 0 to Length(aValues) - 1 do
		if AnsiCompareText(anAttrValue, aValues[Result]) = 0 then
			Exit;
	if Length(aValues) = 0 then
		s := ''
	else begin
		s := aValues[0];
		for i := 1 to Length(aValues) - 1 do
			s := s + ^M^J + aValues[i];
	end;
	raise SimpleXMLException.CreateFmt(SSimpleXmlError6,
		[aNode.FNames.GetName(anAttrData.NameID), aNode.Get_NodeName, s]);
end;

function TXmlNode.GetEnumAttr(aNameID: Integer;
	const aValues: array of TXmlString; aDefault: Integer): Integer;
var
	anAttrData: PXmlAttrData;
begin
	anAttrData := FindAttrData(aNameID);
	if Assigned(anAttrData) then
		Result := EnumAttrValue(Self, anAttrData, aValues)
	else
		Result := aDefault;
end;

function TXmlNode.NeedEnumAttr(const aName: TXmlString;
	const aValues: array of TXmlString): Integer;
begin
	Result := NeedEnumAttr(FNames.GetID(aName), aValues)
end;

function GetXmlPath(Node: IXmlNode): string;
begin
  Result := '';
  while (Node <> Nil) and (Node.NodeType = NODE_ELEMENT) do begin
    if Result = '' then
      Result := Node.NodeName
    else Result := Node.NodeName + '/' + Result;
    Node := Node.ParentNode; 
  end;
end;

function TXmlNode.NeedEnumAttr(aNameID: Integer;
	const aValues: array of TXmlString): Integer;
var
	anAttrData: PXmlAttrData;
begin
	anAttrData := FindAttrData(aNameID);
	if Assigned(anAttrData) then
		Result := EnumAttrValue(Self, anAttrData, aValues)
	else
		raise SimpleXMLException.CreateFmt(SSimpleXMLError7,
      [GetXmlPath(Self) + '/@' + FNames.GetName(aNameID)]);
end;

function TXmlNode.GetFloatAttr(const aName: TXmlString;
	aDefault: Double): Double;
begin
	Result := GetFloatAttr(FNames.GetID(aName), aDefault);
end;

function TXmlNode.GetFloatAttr(aNameID: Integer;
	aDefault: Double): Double;
var
	aData: PXmlAttrData;
begin
	aData := FindAttrData(aNameID);
	if Assigned(aData) then
		if VarIsNumeric(aData.Value) then
			Result := aData.Value
		else
			Result := XSTRToFloat(aData.Value)
	else
		Result := aDefault
end;

function TXmlNode.GetHexAttr(aNameID, aDefault: Integer): Integer;
var
	anAttr: PXmlAttrData;
begin
	anAttr := FindAttrData(aNameID);
	if Assigned(anAttr) then
		Result := StrToInt('$' + anAttr.Value)
	else
		Result := aDefault;
end;

function TXmlNode.GetHexAttr(const aName: TXmlString;
  aDefault: Integer): Integer;
begin
	Result := GetHexAttr(FNames.GetID(aName), aDefault)
end;

function TXmlNode.GetIntAttr(aNameID: Integer; aDefault: tIntValue): tIntValue;
var
	anAttr: PXmlAttrData;
begin
	anAttr := FindAttrData(aNameID);
	if Assigned(anAttr) then
{$ifdef IntValueInt64}
		Result := strtoint64(anAttr.Value)
{$else}
		Result := anAttr.Value
{$endif}                
	else
		Result := aDefault;
end;

function TXmlNode.GetIntAttr(const aName: TXmlString;
  aDefault: tIntValue): tIntValue;
begin
        try
        	Result := GetIntAttr(FNames.GetID(aName), aDefault)
        except
                on e: exception do
                        raise SimpleXMLException.CreateFmt(SBadIntAttribute,[aName,GetAttr(aName)]);
        end;
end;

function TXmlNode.NeedAttr(aNameID: Integer): TXmlString;
var
	anAttr: PXmlAttrData;
begin
	anAttr := FindAttrData(aNameID);
	if not Assigned(anAttr) then
		raise SimpleXMLException.CreateFmt(SSimpleXMLError7,
      [GetXmlPath(Self) + '/@' + FNames.GetName(aNameID)]);
	Result := anAttr.Value
end;

function TXmlNode.NeedAttr(const aName: TXmlString): TXmlString;
begin
	Result := NeedAttr(FNames.GetID(aName))
end;

function TXmlNode.GetVarAttr(aNameID: Integer;
  const aDefault: Variant): Variant;
var
	anAttr: PXmlAttrData;
begin
	anAttr := FindAttrData(aNameID);
	if Assigned(anAttr) then
		Result := anAttr.Value
	else
		Result := aDefault;
end;

function TXmlNode.GetVarAttr(const aName: TXmlString;
  const aDefault: Variant): Variant;
begin
	Result := GetVarAttr(FNames.GetID(aName), aDefault)
end;

function TXmlNode.Get_NodeName: TXmlString;
begin
	Result := FNames.GetName(Get_NodeNameID);
end;

function TXmlNode.GetOwnerDocument: TXmlDocument;
var
	aResult: TXmlNode;
begin
	aResult := Self;
	repeat
		if aResult is TXmlDocument then
			break
		else
			aResult := aResult.FParentNode;
	until not Assigned(aResult);
	Result := TXmlDocument(aResult)
end;

function TXmlNode.Get_OwnerDocument: IXmlDocument;
var
	aDoc: TXmlDocument;
begin
	aDoc := GetOwnerDocument;
	if Assigned(aDoc) then
		Result := aDoc
	else
		Result := nil;
end;

function TXmlNode.Get_ParentNode: IXmlNode;
begin
	Result := FParentNode
end;

function TXmlNode.Get_TypedValue: Variant;
begin
	Result := Get_Text
end;

procedure TXmlNode.InsertBefore(const aChild, aBefore: IXmlNode);
var
	i: Integer;
	aChilds: TXmlNodeList;
begin
	aChilds := GetChilds;
	if Assigned(aBefore) then
		i := aChilds.IndexOf(aBefore.GetObject as TXmlNode)
	else
		i := aChilds.FCount;
	GetChilds.Insert(aChild.GetObject as TXmlNode, i)
end;

procedure TXmlNode.RemoveAllAttrs;
begin
	FAttrCount := 0; 
end;

procedure TXmlNode.RemoveAllChilds;
begin
	if Assigned(FChilds) then
		FChilds.Clear
end;

procedure TXmlNode.RemoveAttr(const aName: TXmlString);
begin
	RemoveAttr(FNames.GetID(aName, False));
end;

procedure TXmlNode.RemoveAttr(aNameID: Integer);
var
	a1, a2: PXmlAttrData;
	i: Integer;
begin
	a1 := @FAttrs[0];
	i := 0;
	while (i < FAttrCount) and (a1.NameID <> aNameID) do begin
		Inc(a1);
		Inc(i)
	end;
	if i < FAttrCount then begin
		a2 := a1;
		Inc(a2);
		while i < FAttrCount - 1 do begin
			a1^ := a2^;
			Inc(a1);
			Inc(a2);
			Inc(i)
		end;
		VarClear(a1.Value);
		Dec(FAttrCount);
	end;
end;

procedure TXmlNode.RemoveChild(const aChild: IXmlNode);
begin
	GetChilds.Remove(aChild.GetObject as TXmlNode)
end;

procedure TXmlNode.ReplaceChild(const aNewChild, anOldChild: IXmlNode);
var
	i: Integer;
	aChilds: TXmlNodeList;
begin
	aChilds := GetChilds;
	i := aChilds.IndexOf(anOldChild.GetObject as TXmlNode);
	if i <> -1 then
		aChilds.Replace(i, aNewChild.GetObject as TXmlNode)
end;

function NameCanBeginWith(aChar: TXmlChar): Boolean;
begin
	{$IFDEF XML_WIDE_CHARS}
	Result := (aChar = '_')  or IsCharAlphaW(aChar)
	{$ELSE}
	Result := (aChar in ['_', 'A'..'Z','a'..'z','0'..'9'])
	{$ENDIF}
end;

function NameCanContain(aChar: TXmlChar): Boolean;
begin
	{$IFDEF XML_WIDE_CHARS}
	Result := (aChar = '_') or (aChar = '-') or (aChar = ':') or (aChar = '.') or
		IsCharAlphaNumericW(aChar)
	{$ELSE}
	Result := (aChar in ['_', '-', ':', '.', '&', 'A'..'Z','a'..'z','0'..'9']);
	{$ENDIF}
end;

function IsName(const s: TXmlString): Boolean;
var
	i: Integer;
begin
	if s = '' then
		Result := False
	else if not NameCanBeginWith(s[1]) then
		Result := False
	else begin
		for i := 2 to Length(s) do
			if not NameCanContain(s[i]) then begin
				Result := False;
				Exit
			end;
		Result := True;
	end;
end;

const
	ntComment = -2;
	ntNode = -3;
	ntProcessingInstruction = -4;
	ntText = -5;
		
type
	TAxis = (axAncestor, axAncestorOrSelf, axAttribute, axChild,
		axDescendant, axDescendantOrSelf, axFollowing, axFollowingSibling,
		axParent, axPreceding, axPrecedingSibling, axSelf);

	TPredicate = class
		function Check(aNode: TXmlNode): Boolean; virtual; abstract;
	end;

	TLocationStep = class
		Next: TLocationStep;
		Axis: TAxis;
		NodeTest: Integer;
		Predicates: TList;
	end;
	


function TXmlNode.SelectNodes(
	const anExpression: TXmlString): IXmlNodeList;
var
	aNodes: TXmlNodeList;
	aChilds: TXmlNodeList;
	aChild: TXmlNode;
	aNameID: Integer;
	i: Integer;
{
	aPath: TXmlPath;
}
begin
	if IsName(anExpression) then begin
		aNodes := TXmlNodeList.Create(nil);
		Result := aNodes;
		aChilds := GetChilds;
		aNameID := FNames.GetID(anExpression);
		for i := 0 to aChilds.FCount - 1 do begin
			aChild := aChilds.FItems[i];
			if (aChild.Get_NodeType = NODE_ELEMENT) and (aChild.Get_NodeNameID = aNameID) then
				aNodes.Insert(aChild, aNodes.FCount);
		end;
	end
	else begin
		raise
			SimpleXMLException.Create(SSimpleXmlError9);
{
		aPath := TXmlPath.Create;
		try
			aPath.Init(anExpression);
			Result := aPath.SelectNodes(Self);
		finally
			aPath.Free
		end
}
	end;
end;

function TXmlNode.SelectSingleNode(
	const anExpression: TXmlString): IXmlNode;
var
	aChilds: TXmlNodeList;
	aChild: TXmlNode;
	aNameID: Integer;
	i: Integer;
  str, aName: string;
begin
	if IsName(anExpression) then begin
		aChilds := GetChilds;
		aNameID := FNames.GetID(anExpression);
		for i := 0 to aChilds.FCount - 1 do begin
			aChild := aChilds.FItems[i];
			if (aChild.Get_NodeType = NODE_ELEMENT) and (aChild.Get_NodeNameID = aNameID) then begin
				Result := aChild;
				Exit
			end
		end;
		Result := nil;
	end
	else begin
    Result := Self;
    str := anExpression;
    while str <> '' do begin
      i := Pos('/', str);
      if i = 0 then begin
        aName := str;
        if not IsName(aName) then begin
          Result:=nil;
          Exit;
        end;
        str := '';
      end else begin
        aName := Copy(str, 1, i - 1);
        Delete(str, 1, i);
      end;
      Result := Result.SelectSingleNode(aName);
      if Result = Nil then
        Exit;//��� ������������ � ������� SelectSingleNode
    end;
	end
end;

function TXmlNode.FindElement(const anElementName, anAttrName: String;
	const anAttrValue: Variant): IXmlElement;
var
	aChild: TXmlNode;
	aNameID, anAttrNameID: Integer;
	i: Integer;
	pa: PXmlAttrData;
begin
	if Assigned(FChilds) then begin
		aNameID := FNames.GetID(anElementName);
		anAttrNameID := FNames.GetID(anAttrName);

		for i := 0 to FChilds.FCount - 1 do begin
			aChild := FChilds.FItems[i];
			if (aChild.Get_NodeType = NODE_ELEMENT) and (aChild.Get_NodeNameID = aNameID) then begin
				pa := aChild.FindAttrData(anAttrNameID);
				try
					if Assigned(pa) and VarSameValue(pa.Value, anAttrValue) then begin
						Result := aChild.AsElement;
						Exit
					end
				except
					// �������������� �������� ����� ���������� � ��� ������,
					// ���� ���������� ���� � ������� VarSameValue.
					// ����� ������� - ���� �������� ������ ����������.
				end;
			end
		end;
	end;
	Result := nil;
end;

procedure TXmlNode.Set_TypedValue(const aValue: Variant);
begin
  Set_Text(aValue)
end;

procedure TXmlNode.SetAttr(const aName, aValue: TXmlString);
begin
	SetVarAttr(FNames.GetID(aName, False), aValue)
end;

procedure TXmlNode.SetAttr(aNameID: Integer; const aValue: TXmlString);
begin
	SetVarAttr(aNameID, aValue)
end;

procedure TXmlNode.SetBoolAttr(aNameID: Integer; aValue: Boolean);
begin
	SetVarAttr(aNameID, aValue)
end;

procedure TXmlNode.SetBoolAttr(const aName: TXmlString; aValue: Boolean);
begin
	SetVarAttr(FNames.GetID(aName, False), aValue)
end;

procedure TXmlNode.SetChildText(const aName: TXmlString;
	const aValue: TXmlString);
begin
	SetChildText(FNames.GetID(aName, False), aValue)
end;

procedure TXmlNode.SetChildText(aNameID: Integer; const aValue: TXmlString);
var
	aChild: TXmlNode;
begin
	aChild := FindFirstChild(aNameID);
	if not Assigned(aChild) then begin
		aChild := TXmlElement.Create(FNames, aNameID);
		with GetChilds do
			Insert(aChild, FCount);
	end;
	aChild.Set_Text(aValue)
end;

procedure TXmlNode.SetFloatAttr(aNameID: Integer; aValue: Double);
begin
	SetVarAttr(aNameID, aValue)
end;

procedure TXmlNode.SetFloatAttr(const aName: TXmlString; aValue: Double);
begin
	SetVarAttr(FNames.GetID(aName, False), aValue);
end;

procedure TXmlNode.SetHexAttr(const aName: TXmlString; aValue,
  aDigits: Integer);
begin
	SetVarAttr(FNames.GetID(aName, False), IntToHex(aValue, aDigits))
end;

procedure TXmlNode.SetHexAttr(aNameID, aValue, aDigits: Integer);
begin
	SetVarAttr(aNameID, IntToHex(aValue, aDigits))
end;

procedure TXmlNode.SetIntAttr(aNameID: Integer; aValue: tIntValue);
begin
	SetVarAttr(aNameID,
{$ifdef IntValueInt64}
        inttostr(aValue)
{$else}
        aValue
{$endif}
        )
end;

procedure TXmlNode.SetIntAttr(const aName: TXmlString; aValue: tIntValue);
begin
	SetVarAttr(FNames.GetID(aName, False),
{$ifdef IntValueInt64}
        inttostr(aValue)
{$else}
        aValue
{$endif}
        )
end;

procedure TXmlNode.SetVarAttr(const aName: TXmlString; aValue: Variant);
begin
	SetVarAttr(FNames.GetID(aName, False), aValue)
end;

procedure TXmlNode.SetVarAttr(aNameID: Integer; const aValue: Variant);
var
	anAttr: PXmlAttrData;
var
	aDelta: Integer;
begin
	anAttr := FindAttrData(aNameID);
	if not Assigned(anAttr) then begin
		if FAttrCount = Length(FAttrs) then begin
			if FAttrCount > 64 then
				aDelta := FAttrCount div 4
			else if FAttrCount > 8 then
				aDelta := 16
			else
				aDelta := 4;
			SetLength(FAttrs, FAttrCount + aDelta);
		end;
		anAttr := @FAttrs[FAttrCount];
		anAttr.NameID := aNameID;
		Inc(FAttrCount);
	end;
	anAttr.Value := aValue
end;

function TXmlNode.FindAttrData(aNameID: Integer): PXmlAttrData;
var
	i: Integer;
begin
  if length(FAttrs)>0 then begin
	Result := @FAttrs[0];
	for i := 0 to FAttrCount - 1 do
		if Result.NameID = aNameID then
			Exit
		else
			Inc(Result);
  end;
  Result := nil;
end;

function TXmlNode.AsElement: IXmlElement;
begin
	Result := nil
end;

function TXmlNode.AsCDATASection: IXmlCDATASection;
begin
	Result := nil
end;

function TXmlNode.AsComment: IXmlComment;
begin
	Result := nil
end;

function TXmlNode.AsText: IXmlText;
begin
	Result := nil
end;

function TXmlNode.AsProcessingInstruction: IXmlProcessingInstruction;
begin
	Result := nil
end;

function TXmlNode.AppendCDATA(const aData: TXmlString): IXmlCDATASection;
var
	aChild: TXmlCDATASection;
begin
	aChild := TXmlCDATASection.Create(FNames, aData);
	GetChilds.Insert(aChild, -1);
	Result := aChild
end;

function TXmlNode.AppendComment(const aData: TXmlString): IXmlComment;
var
	aChild: TXmlComment;
begin
	aChild := TXmlComment.Create(FNames, aData);
	GetChilds.Insert(aChild, -1);
	Result := aChild
end;

function TXmlNode.AppendElement(const aName: TxmlString): IXmlElement;
var
	aChild: TXmlElement;
begin
	aChild := TXmlElement.Create(FNames, FNames.GetID(aName, False));
	GetChilds.Insert(aChild, -1);
	Result := aChild
end;

function TXmlNode.AppendElement(aNameID: Integer): IXmlElement;
var
	aChild: TXmlElement;
begin
	aChild := TXmlElement.Create(FNames, aNameID);
	GetChilds.Insert(aChild, -1);
	Result := aChild
end;

function TXmlNode.AppendProcessingInstruction(const aTarget,
  aData: TXmlString): IXmlProcessingInstruction;
var
	aChild: TXmlProcessingInstruction;
begin
	aChild := TXmlProcessingInstruction.Create(FNames, FNames.GetID(aTarget, False), aData);
	GetChilds.Insert(aChild, -1);
	Result := aChild
end;

function TXmlNode.AppendProcessingInstruction(aTargetID: Integer;
  const aData: TXmlString): IXmlProcessingInstruction;
var
	aChild: TXmlProcessingInstruction;
begin
	aChild := TXmlProcessingInstruction.Create(FNames, aTargetID, aData);
	GetChilds.Insert(aChild, -1);
	Result := aChild
end;

function TXmlNode.AppendText(const aData: TXmlString): IXmlText;
var
	aChild: TXmlText;
begin
	aChild := TXmlText.Create(FNames, aData);
	GetChilds.Insert(aChild, -1);
	Result := aChild
end;

function TXmlNode.GetAttrsXML: TXmlString;
var
	a: PXmlAttrData;
	i: Integer;
        cp: integer;
begin
	Result := '';
	if FAttrCount > 0 then begin
		a := @FAttrs[0];
    cp := GetOwnerDocument.CodePage;
		for i := 0 to FAttrCount - 1 do begin
			Result := Result + ' ' + FNames.GetName(a.NameID) + '="' + TextToXML(VarToXSTR(TVarData(a.Value),cp)) + '"';
			Inc(a);
		end;
	end;
end;

procedure TXmlNode.LoadBinXml(aReader: TBinXmlReader);
var
	aCount: LongInt;
	a: PXmlAttrData;
	i: Integer;
begin
	// ������� ��������
	RemoveAllAttrs;
	aCount := aReader.ReadLongint;
	SetLength(FAttrs, aCount);
	FAttrCount := aCount;
	a := @FAttrs[0];
	for i := 0 to aCount - 1 do begin
		a.NameID := aReader.ReadLongint;
		aReader.ReadVariant(TVarData(a.Value));
		Inc(a);
	end;

	// ������� �������� ����
	aCount := aReader.ReadLongint;
	if aCount > 0 then
		GetChilds.LoadBinXml(aReader, aCount, FNames);
end;

procedure TXmlNode.SaveBinXml(aWriter: TBinXmlWriter);
var
	aCount: LongInt;
	a: PXmlAttrData;
	i: Integer;
begin
	// ������� ��������
	aCount := FAttrCount;
	aWriter.WriteLongint(aCount);
	a := @FAttrs[0];
	for i := 0 to aCount - 1 do begin
		aWriter.WriteLongint(a.NameID);
		aWriter.WriteVariant(TVarData(a.Value));
		Inc(a);
	end;

	// �������� �������� ����
	if Assigned(FChilds) then begin
		aWriter.WriteLongint(FChilds.FCount);
		FChilds.SaveBinXml(aWriter);
	end
	else
		aWriter.WriteLongint(0);
end;

function TXmlNode.Get_DataType: Integer;
begin
	{$IFDEF XML_WIDE_CHARS}
	Result := varOleStr
	{$ELSE}
	Result := varString
	{$ENDIF}
end;

function TXmlNode.AttrExists(aNameID: Integer): Boolean;
begin
	Result := FindAttrData(aNameID) <> nil
end;

function TXmlNode.AttrExists(const aName: TXmlString): Boolean;
begin
	Result := FindAttrData(FNames.GetID(aName, True)) <> nil
end;

function TXmlNode.GetAttrType(aNameID: Integer): Integer;
var
	a: PXmlAttrData;
begin
	a := FindAttrData(aNameID);
	if Assigned(a) then
		Result := TVarData(a.Value).VType
	else
		{$IFDEF XML_WIDE_CHARS}
		Result := varOleStr
		{$ELSE}
		Result := varString
		{$ENDIF}
end;

function TXmlNode.GetAttrType(const aName: TXmlString): Integer;
begin
	Result := GetAttrType(FNames.GetID(aName));
end;

function TXmlNode.Get_Values(const aName: String): Variant;
var
	aChild: IXmlNode;
begin
	if aName = '' then
		Result := Get_TypedValue
	else if aName[1] = '@' then
		Result := GetVarAttr(Copy(aName, 2, Length(aName) - 1), '')
	else begin
		aChild := SelectSingleNode(aName);
		if Assigned(aChild) then
			Result := aChild.TypedValue
		else
			Result := ''
	end
end;

procedure TXmlNode.Set_Values(const aName: String; const aValue: Variant);
var
	aChild: IXmlNode;
begin
	if aName = '' then
		Set_TypedValue(aValue)
	else if aName[1] = '@' then
		SetVarAttr(Copy(aName, 2, Length(aName) - 1), aValue)
	else begin
		aChild := SelectSingleNode(aName);
		if not Assigned(aChild) then
			aChild := AppendElement(aName);
		aChild.TypedValue := aValue;
	end
end;

function VarAsDateTime(v:Variant):tDateTime;
begin
	Result := {$ifdef IntDate}round(VarAsType(v, varDate)*mSecsPerDay){$else}VarAsType(v, varDate){$endif}
end;

function TXmlNode.GetDateTimeAttr(aNameID: Integer;
	aDefault: TDateTime): TDateTime;
var
	anAttr: PXmlAttrData;
begin
	anAttr := FindAttrData(aNameID);
	if Assigned(anAttr) then begin
		if (VarType(anAttr.Value) = varString) or (VarType(anAttr.Value) = varOleStr) then
			Result := XSTRToDateTime(anAttr.Value)
		else
			Result := VarAsDateTime(anAttr.Value);
	end
	else
		Result := aDefault;
end;

function TXmlNode.GetDateTimeAttr(const aName: TXmlString;
	aDefault: TDateTime): TDateTime;
begin
	Result := GetDateTimeAttr(FNames.GetID(aName), aDefault)
end;

procedure TXmlNode.SetDateTimeAttr(aNameID: Integer; aValue: TDateTime);
begin
	SetVarAttr(aNameID, VarAsType(aValue{$ifdef INTDATE}/mSecsPerDay{$endif}, varDate))
end;

procedure TXmlNode.SetDateTimeAttr(const aName: TXmlString;
	aValue: TDateTime);
begin
	SetVarAttr(aName, VarAsType(aValue{$ifdef INTDATE}/mSecsPerDay{$endif}, varDate))
end;

function TXmlNode.EnsureChild(aNameID: Integer): IXmlNode;
var
	aChild: TXmlNode;
begin
	aChild := FindFirstChild(aNameID);
	if Assigned(aChild) then
		Result := aChild
	else
		Result := AppendElement(aNameID)
end;

function TXmlNode.EnsureChild(const aName: TXmlString): IXmlNode;
begin
	Result := EnsureChild(FNames.GetID(aName))
end;

function TXmlNode.NeedChild(aNameID: Integer): IXmlNode;
var
	aChild: TXmlNode;
begin
	aChild := FindFirstChild(aNameID);
	if not Assigned(aChild) then
		raise NeedChildException.CreateFmt(SSimpleXmlError10, [FNames.GetName(aNameID)]);
	Result := aChild
end;

function TXmlNode.NeedChild(const aName: TXmlString): IXmlNode;
begin
	Result := NeedChild(FNames.GetID(aName));
end;

procedure TXmlNode.SetNameTable(aValue: TXmlNameTable; aMap: TList);
var
	i, k: Integer;
	aNewMap: Boolean;
begin
	if aValue <> FNames then begin
		aNewMap := not Assigned(aMap);
		if aNewMap then begin
			aMap := TList.Create;
			for i := 0 to Length(FNames.FNames)-1 do
				aMap.Add(Pointer(i));
			for i := 0 to Length(aValue.FNames)-1 do begin
				k := FNames.GetID(aValue.FNames[i]);
				if aMap.IndexOf(Pointer(k)) = -1 then
					aMap.Add(Pointer(k));
			end;
		end;
		try
			SetNodeNameID(Integer(aMap[Get_NodeNameID]));
			for i := 0 to Length(FAttrs)-1 do
				with FAttrs[i] do
					NameID := Integer(aMap[NameID]);
			if Assigned(FChilds) then
				for i := 0 to FChilds.FCount - 1 do
					FChilds.FItems[i].SetNameTable(aValue, aMap);
		finally
			if aNewMap then
				aMap.Free
		end;
	end;
end;

procedure TXmlNode.SetNodeNameID(aValue: Integer);
begin

end;


function TXmlNode.CloneNode(aDeep: Boolean): IXmlNode;
begin
	Result := DoCloneNode(aDeep)
end;

{ TXmlElement }

constructor TXmlElement.Create(aNames: TXmlNameTable; aNameID: Integer);
begin
	inherited Create(aNames);
	FNameID := aNameID;
end;

function TXmlElement.Get_NodeNameID: Integer;
begin
	Result := FNameID
end;

function TXmlElement.Get_NodeType: Integer;
begin
	Result := NODE_ELEMENT
end;

function TXmlElement.GetChilds: TXmlNodeList;
begin
	Result := inherited GetChilds;
	if not TVarData(FData).VType in [varEmpty, varNull] then begin
		AppendChild(TXmlText.Create(FNames, FData));
		VarClear(FData);
	end;
end;

function TXmlElement.Get_Text: TXmlString;
var
	aChilds: TXmlNodeList;
	aChild: TXmlNode;
	aChildText: TXmlString;
	i: Integer;
	Doc: TXmlDocument;
begin
	Result := '';
	if Assigned(FChilds) and (FChilds.FCount > 0) then begin
		aChilds := FChilds;
		for i := 0 to aChilds.FCount - 1 do begin
			aChild := aChilds.FItems[i];
			if not IgnoreChildText and (aChild.Get_NodeType=NODE_ELEMENT)
			   or (aChild.Get_NodeType in [NODE_TEXT, NODE_CDATA_SECTION]) then begin
				aChildText := aChild.Get_Text;
				if aChildText <> '' then
					if Result = '' then
						Result := aChildText
					else begin
						Doc:=GetOwnerDocument;
						if (Doc<>nil) and Doc.FPreserveWhiteSpace or
                                                   (Doc=nil) and DefaultPreserveWhiteSpace or
                                                   (aChild.Get_NodeType=NODE_CDATA_SECTION) then
							Result := Result + aChildText
						else
							Result := Result + ' ' + aChildText
					end;
			end
		end;
	end
	else if VarIsEmpty(FData) then
		Result := ''
	else
		Result := VarToXSTR(TVarData(FData),GetOwnerDocument.CodePage)
end;

function TXmlElement.GetTextAsBynaryData: TXmlString;
begin
	Result := Base64ToBin(Get_Text);
end;

procedure TXmlElement.ReplaceTextByBynaryData(const aData; aSize: Integer;
	aMaxLineLength: Integer);
var Text: TXMLText;
begin
	RemoveTextNodes;
        Text := TXmlText.Create(FNames, BinToBase64(aData, aSize, aMaxLineLength));
        Text.IsBase64Text := True;
	GetChilds.Insert( Text, -1);
end;

procedure TXmlElement.RemoveTextNodes;
var
	i: Integer;
	aNode: TXmlNode;
begin
	if Assigned(FChilds) then
		for i := FChilds.FCount - 1 downto 0 do begin
			aNode := FChilds.FItems[i];
			if aNode.Get_NodeType in [NODE_TEXT, NODE_CDATA_SECTION] then
				FChilds.Remove(aNode);
		end;
end;

procedure TXmlElement.ReplaceTextByCDATASection(const aText: TXmlString);

	procedure AddCDATASection(const aText: TXmlString);
	var
		i: Integer;
		aChilds: TXmlNodeList;
	begin
		i := Pos(']]>', aText);
		aChilds := GetChilds;
		if i = 0 then
			aChilds.Insert(TXmlCDATASection.Create(FNames, aText), aChilds.FCount)
		else begin
			aChilds.Insert(TXmlCDATASection.Create(FNames, Copy(aText, 1, i)), aChilds.FCount);
			AddCDATASection(Copy(aText, i + 1, Length(aText) - i - 1));
		end;
	end;

begin
	RemoveTextNodes;
	AddCDATASection(aText);
end;

procedure TXmlElement.Set_Text(const aValue: TXmlString);
begin
	if Assigned(FChilds) then
		FChilds.Clear;
	FData := aValue;
end;

function TXmlElement.AsElement: IXmlElement;
begin
	Result := Self
end;

function GetIndentStr(aDoc:TXmlDocument): String;
var
	i: Integer;
begin
  if aDoc=nil then begin
    Result:='';
    exit;
  end;
	SetLength(Result, aDoc.FGetXMLIntend*Length(DefaultIndentText));
	for i := 0 to aDoc.FGetXMLIntend - 1 do
		Move(DefaultIndentText[1], Result[i*Length(DefaultIndentText) + 1], Length(DefaultIndentText));
end;

function HasCRLF(const s: String): Boolean;
var
	i: Integer;
begin
	for i := 1 to Length(s) do
		if (s[i] = ^M) or (s[i] = ^J) then begin
			Result := True;
			Exit
		end;
	Result := False;
end;

function EndWithCRLF(const s: String): Boolean;
begin
	Result :=
		(Length(s) > 1) and
		(s[Length(s) - 1] = ^M) and
		(s[Length(s)] = ^J);
end;

function TXmlElement.Get_XML: TXmlString;
var
	aChildsXML: TXmlString;
	aTag: TXmlString;
	aDoc: TXmlDocument;
	aPreserveWhiteSpace: Boolean;
        OldEmptyXMLDocumentElementToWriteIn:string;
begin
	aTag := FNames.GetName(FNameID);
	aDoc := GetOwnerDocument;
	if Assigned(aDoc) and assigned(aDoc.ToWriteInEmptyXMLDocumentProc) and
    (aDoc.EmptyXMLDocumentElementToWriteIn = aTag) and Assigned(FChilds) and
    (FChilds.Get_Count=1) and (aDoc.WriteBodyLevel=0)
  then begin
    OldEmptyXMLDocumentElementToWriteIn:=aDoc.EmptyXMLDocumentElementToWriteIn;
    inc(aDoc.WriteBodyLevel);
    try
      aDoc.EmptyXMLDocumentElementToWriteIn:=FChilds.Get_Item(0).NodeName;
      Result:=Get_XML;
    finally
      aDoc.EmptyXMLDocumentElementToWriteIn:=OldEmptyXMLDocumentElementToWriteIn;
      dec(aDoc.WriteBodyLevel);
    end;
    Exit;
  end;
	if Assigned(aDoc) then
		aPreserveWhiteSpace := aDoc.Get_PreserveWhiteSpace
	else
		aPreserveWhiteSpace := DefaultPreserveWhiteSpace;
	if aPreserveWhiteSpace then begin
		if Assigned(FChilds) and (FChilds.FCount > 0) then
			aChildsXML := FChilds.Get_XML
		else if VarIsEmpty(FData) then
			aChildsXML := ''
		else
			aChildsXML := TextToXML(VarToXSTR(TVarData(FData),GetOwnerDocument.CodePage));

		if assigned(aDoc.ToWriteInEmptyXMLDocumentProc) and (aChildsXML = '') and (aDoc.EmptyXMLDocumentElementToWriteIn = aTag) then
			aChildsXML := aDoc.ToWriteInEmptyXMLDocumentProc(Self);
		Result := '<' + aTag + GetAttrsXML;
		if aChildsXML = '' then
			Result := Result + '/>'
		else
			Result := Result + '>' + aChildsXML + '</' + aTag + '>'
	end
	else begin
		if Assigned(FChilds) and (FChilds.FCount > 0) then begin
      if aDoc=nil then
				aChildsXML := FChilds.Get_XML
      else begin
        Inc(aDoc.FGetXMLIntend);
        try
          aChildsXML := FChilds.Get_XML
        finally
          Dec(aDoc.FGetXMLIntend)
        end
      end;
		end
		else if VarIsEmpty(FData) then
			aChildsXML := ''
                else
			aChildsXML := TextToXML(VarToXSTR(TVarData(FData),GetOwnerDocument.CodePage));
		if assigned(aDoc) and assigned(aDoc.ToWriteInEmptyXMLDocumentProc) and (aDoc.EmptyXMLDocumentElementToWriteIn = aTag) then
                   if (aChildsXML = '') then
			aChildsXML := aDoc.ToWriteInEmptyXMLDocumentProc(Self)
                   else
			aDoc.ToWriteInEmptyXMLDocumentProc(Self);
		Result := ^M^J+GetIndentStr(aDoc) + '<' + aTag + GetAttrsXML;
		if aChildsXML = '' then
			Result := Result + '/>'
		else if HasCRLF(aChildsXML) then
			if EndWithCRLF(aChildsXML) then
				Result := Result + '>' + aChildsXML + GetIndentStr(aDoc) + '</' + aTag + '>'
			else
				Result := Result + '>' + aChildsXML + ^M^J + GetIndentStr(aDoc) + '</' + aTag + '>'
		else
			Result := Result + '>' + aChildsXML + '</' + aTag + '>';
	end;
end;

function TXmlElement.Get_TypedValue: Variant;
begin
	if Assigned(FChilds) and (FChilds.FCount > 0) then
		Result := Get_Text
	else
		Result := FData
end;

procedure TXmlElement.Set_TypedValue(const aValue: Variant);
begin
	if Assigned(FChilds) then
		FChilds.Clear;
	FData := aValue;
end;

function TXmlElement.Get_DataType: Integer;
begin
	if (Assigned(FChilds) and (FChilds.FCount > 0)) or VarIsEmpty(FData) then
		{$IFDEF XML_WIDE_CHARS}
		Result := varOleStr
		{$ELSE}
		Result := varString
		{$ENDIF}
	else
		Result := TVarData(FData).VType;
end;

function TXmlElement.Get_ChildNodes: IXmlNodeList;
begin
	Result := inherited Get_ChildNodes;
end;

procedure TXmlElement.SetNodeNameID(aValue: Integer);
begin
	FNameID := aValue
end;

function TXmlElement.DoCloneNode(aDeep: Boolean): IXmlNode;
var
	aClone: TXmlElement;
	i: Integer;
begin
	aClone := TXmlElement.Create(FNames, FNameID);
	Result := aClone;
	SetLength(aClone.FAttrs, FAttrCount);
	aClone.FAttrCount := FAttrCount;
	for i := 0 to FAttrCount - 1 do
		aClone.FAttrs[i] := FAttrs[i];
	if aDeep and Assigned(FChilds) and (FChilds.FCount > 0) then
		for i := 0 to FChilds.FCount - 1 do
			aClone.AppendChild(FChilds.FItems[i].CloneNode(True));
end;

{ TXmlCharacterData }

constructor TXmlCharacterData.Create(aNames: TXmlNameTable;
  const aData: TXmlString);
begin
	inherited Create(aNames);
	FData := aData;
end;

function TXmlCharacterData.Get_Text: TXmlString;
var
	aDoc: TXmlDocument;
	aPreserveWhiteSpace: Boolean;
begin
	aDoc := GetOwnerDocument;
	if Assigned(aDoc) then
		aPreserveWhiteSpace := aDoc.Get_PreserveWhiteSpace
	else
		aPreserveWhiteSpace := DefaultPreserveWhiteSpace;
	if aPreserveWhiteSpace or (Get_NodeType=NODE_CDATA_SECTION) then
		Result := FData
	else
		Result := Trim(FData);
end;

procedure TXmlCharacterData.Set_Text(const aValue: TXmlString);
begin
	FData := aValue
end;

{ TXmlText }

function TXmlText.AsText: IXmlText;
begin
	Result := Self;
end;

constructor TXmlText.Create(aNames: TXmlNameTable; const aData: Variant);
begin
	inherited Create(aNames);
	FData := aData;
end;

function TXmlText.DoCloneNode(aDeep: Boolean): IXmlNode;
begin
	Result := TXmlText.Create(FNames, FData);
end;

function TXmlText.Get_DataType: Integer;
begin
	Result := TVarData(FData).VType
end;

function TXmlText.Get_NodeNameID: Integer;
begin
	Result := FNames.FXmlTextNameID
end;

function TXmlText.Get_NodeType: Integer;
begin
	Result := NODE_TEXT
end;

function TXmlText.Get_Text: TXmlString;
begin
	Result := VarToXSTR(TVarData(FData),GetOwnerDocument.CodePage)
end;

function TXmlText.Get_TypedValue: Variant;
begin
	Result := FData
end;

function TXmlText.Get_XML: TXmlString;
begin
	Result := VarToXSTR(TVarData(FData),GetOwnerDocument.CodePage);
        if not IsBase64Text then
	        Result := TextToXML( Result );
end;

procedure TXmlText.Set_Text(const aValue: TXmlString);
begin
	FData := aValue;
        IsBase64Text := False;
end;

procedure TXmlText.Set_TypedValue(const aValue: Variant);
begin
	FData := aValue;
        IsBase64Text := False;
end;

{ TXmlCDATASection }

function TXmlCDATASection.AsCDATASection: IXmlCDATASection;
begin
	Result := Self
end;

function TXmlCDATASection.DoCloneNode(aDeep: Boolean): IXmlNode;
begin
  Result := TXmlCDATASection.Create(FNames, FData);
end;

function TXmlCDATASection.Get_NodeNameID: Integer;
begin
	Result := FNames.FXmlCDATASectionNameID
end;

function TXmlCDATASection.Get_NodeType: Integer;
begin
	Result := NODE_CDATA_SECTION
end;

function GenCDATAXML(const aValue: TXmlString): TXmlString;
var
	i: Integer;
begin
	i := Pos(']]>', aValue);
	if i = 0 then
		Result := '<![CDATA[' + aValue + ']]>'
	else
		Result := '<![CDATA[' + Copy(aValue, 1, i) + ']]>' + GenCDATAXML(Copy(aValue, i + 1, Length(aValue) - i - 1));
end;

function TXmlCDATASection.Get_XML: TXmlString;
begin
	Result := GenCDATAXML(FData); 
end;

{ TXmlComment }

function TXmlComment.AsComment: IXmlComment;
begin
	Result := Self
end;

function TXmlComment.DoCloneNode(aDeep: Boolean): IXmlNode;
begin
	Result := TXmlComment.Create(FNames, FData);
end;

function TXmlComment.Get_NodeNameID: Integer;
begin
	Result := FNames.FXmlCommentNameID
end;

function TXmlComment.Get_NodeType: Integer;
begin
	Result := NODE_COMMENT
end;

function TXmlComment.Get_XML: TXmlString;
begin
	Result := '<!--' + FData + '-->'
end;

{ TXmlDocument }

function DefEncodingToCodePage(const Encoding:string):word;
begin
    if SameText(Encoding,'UTF-8') then
      Result:=CP_UTF8
    else
    if SameText(Encoding,'Windows-1251') then
      Result:=1251
    else
    if SameText(Encoding,'IBM866') or SameText(Encoding,'CP866') then
      Result:=866
    else
      Result:=CP_ACP{0 - default};
end;

function TXmlDocument.CodePage: integer;
begin
  if Self=nil then begin
    Result:=EncodingToCodePage(DefaultEncoding);
    exit;
  end;
  if fCodePage=0 then
    fCodePage:=EncodingToCodePage(Get_Encoding);
  Result:=fCodePage;
end;

constructor TXmlDocument.Create(aNames: TXmlNameTable);
begin
  // kudin: 21.04.2011 �� ���������� ���������� ������� ����.
  // ������� � ���, ��� �� ���������� ������ ����� ��� ������ �������� �� �����,
  // � � �������������� xml ����� � ���������� ��������
  if aNames = DefaultNameTableImpl then begin
    fNewNames := TXmlNameTable.Create(4096);
    fNewNames._AddRef;
    aNames := fNewNames;
  end;
  inherited Create(aNames);
  FPreserveWhiteSpace := DefaultPreserveWhiteSpace;
end;

destructor TXmlDocument.Destroy;
begin
  if Assigned(FNewNames) then
   	FNewNames._Release;
  inherited;
end;

function TXmlDocument.CreateCDATASection(
	const aData: TXmlString): IXmlCDATASection;
begin
	Result := TXmlCDATASection.Create(FNames, aData)
end;

function TXmlDocument.CreateComment(const aData: TXmlString): IXmlComment;
begin
	Result := TXmlComment.Create(FNames, aData) 
end;

function TXmlDocument.CreateElement(aNameID: Integer): IXmlElement;
begin
	Result := TXmlElement.Create(FNames, aNameID)
end;

function TXmlDocument.CreateElement(const aName: TXmlString): IXmlElement;
begin
	Result := TXmlElement.Create(FNames, FNames.GetID(aName,False));
end;

function TXmlDocument.CreateProcessingInstruction(const aTarget,
	aData: TXmlString): IXmlProcessingInstruction;
begin
	Result := TXmlProcessingInstruction.Create(FNames, FNames.GetID(aTarget,False), aData)
end;

function TXmlDocument.CreateProcessingInstruction(aTargetID: Integer;
	const aData: TXmlString): IXmlProcessingInstruction;
begin
	Result := TXmlProcessingInstruction.Create(FNames, aTargetID, aData)
end;

function TXmlDocument.CreateText(const aData: TXmlString): IXmlText;
begin
	Result := TXmlText.Create(FNames, aData)
end;

function TXmlDocument.DoCloneNode(aDeep: Boolean): IXmlNode;
var
	aClone: TXmlDocument;
	i: Integer;
begin
	aClone := TXmlDocument.Create(FNames);
	Result := aClone;
	if aDeep and Assigned(FChilds) and (FChilds.FCount > 0) then
		for i := 0 to FChilds.FCount - 1 do
			aClone.AppendChild(FChilds.FItems[i].CloneNode(True));
end;

function TXmlDocument.Get_BinaryXML: String;
var
	aWriter: TStrXmlWriter;
begin
	aWriter := TStrXmlWriter.Create(0, $10000);
	try
		FNames.SaveBinXml(aWriter);
		SaveBinXml(aWriter);
		aWriter.FlushBuf;
		Result := aWriter.FData;
	finally
		aWriter.Free
	end
end;

function TXmlDocument.Get_DocumentElement: IXmlElement;
var
	aChilds: TXmlNodeList;
	aChild: TXmlNode;
	i: Integer;
begin
	aChilds := GetChilds;
	for i := 0 to aChilds.FCount - 1 do begin
		aChild := aChilds.FItems[i];
		if aChild.Get_NodeType = NODE_ELEMENT then begin
			Result := aChild.AsElement;
			Exit
		end
	end;
	Result := nil;
end;

function TXmlDocument.Get_Encoding: string;
var
	aChilds: TXmlNodeList;
	aChild: TXmlNode;
begin
	aChilds := GetChilds;
        aChild := aChilds.FItems[0];
	Result := aChild.GetAttr('encoding',DefaultEncoding);
end;

function TXmlDocument.Get_NodeNameID: Integer;
begin
	Result := FNames.FXmlDocumentNameID
end;

function TXmlDocument.Get_NodeType: Integer;
begin
	Result := NODE_DOCUMENT
end;

function TXmlDocument.Get_PreserveWhiteSpace: Boolean;
begin
	Result := FPreserveWhiteSpace;
end;

function TXmlDocument.Get_Text: TXmlString;
var
	aChilds: TXmlNodeList;
	aChild: TXmlNode;
	aChildText: TXmlString;
	i: Integer;
begin
	Result := '';
	aChilds := GetChilds;
	for i := 0 to aChilds.FCount - 1 do begin
		aChild := aChilds.FItems[i];
		if not IgnoreChildText and (aChild.Get_NodeType=NODE_ELEMENT)
		   or (aChild.Get_NodeType in [NODE_TEXT, NODE_CDATA_SECTION]) then begin
			aChildText := aChild.Get_Text;
			if aChildText <> '' then
				if Result = '' then
					Result := aChildText
				else
					Result := Result + ' ' + aChildText
		end
	end;
end;

function TXmlDocument.Get_XML: TXmlString;
begin
	Result := GetChilds.Get_XML
end;

procedure TXmlDocument.Load(aStream: TStream);
var
	aXml: TXmlStmSource;
	aBinarySign: String;
	aReader: TBinXmlReader;
begin
	RemoveAllChilds;
	RemoveAllAttrs;
	if aStream.Size > BinXmlSignatureSize then begin
		SetLength(aBinarySign, BinXmlSignatureSize);
		aStream.ReadBuffer(aBinarySign[1], BinXmlSignatureSize);
		if aBinarySign = BinXmlSignature then begin
			FNames._Release;
			FNames := TXmlNameTable.Create(4096);
			FNames._AddRef;
			aReader := TStmXmlReader.Create(aStream, $10000);
			try
				FNames.LoadBinXml(aReader);
				LoadBinXml(aReader);
			finally
				aReader.Free
			end;
			Exit;
		end;
		aStream.Position := aStream.Position - BinXmlSignatureSize;
	end;
	aXml := TXmlStmSource.Create(aStream, 1 shl 16);
	try
		GetChilds.ParseXML(aXml, FNames, FPreserveWhiteSpace);
	finally
		aXml.Free
	end;
  if Get_DocumentElement=nil then
		raise SimpleXMLException.Create(SSimpleXmlError26);
end;

procedure TXmlDocument.Load(const aFileName: TXmlString);
var
	aFile: TFileStream;
begin
	aFile := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite);
	try
		Load(aFile);
	finally
		aFile.Free
	end
end;

procedure TXmlDocument.LoadBinaryXML(const aXML: String);
var
	aReader: TStrXmlReader;
begin
	RemoveAllChilds;
	RemoveAllAttrs;
	aReader := TStrXmlReader.Create(aXML);
	try
		FNames._Release;
		FNames := TXmlNameTable.Create(4096);
		FNames._AddRef;
		FNames.LoadBinXml(aReader);
		LoadBinXml(aReader);
	finally
		aReader.Free
	end
end;

procedure TXmlDocument.LoadResource(aType, aName: PChar);
var
	aRSRC: HRSRC;
	aGlobal: HGLOBAL;
	aSize: DWORD;
	aPointer: Pointer;
	aStream: TStringStream;
begin
	aRSRC := FindResource(HInstance, aName, aType);
	if aRSRC <> 0 then begin
		aGlobal := Windows.LoadResource(HInstance, aRSRC);
		aSize := SizeofResource(HInstance, aRSRC);
		if (aGlobal <> 0) and (aSize <> 0) then begin
			aPointer := LockResource(aGlobal);
			if Assigned(aPointer) then begin
				aStream := TStringStream.Create('');
				try
					aStream.WriteBuffer(aPointer^, aSize);
					LoadXML(aStream.DataString);
				finally
					aStream.Free;
				end;
			end;
		end;
	end;
end;

procedure TXmlDocument.LoadXML(const aXML: TXmlString);
var
	aSource: TXmlStrSource;
begin
	if XmlIsInBinaryFormat(aXML) then
		LoadBinaryXML(aXML)
	else begin
		RemoveAllChilds;
		RemoveAllAttrs;
		aSource := TXmlStrSource.Create(aXML);
		try
			GetChilds.ParseXML(aSource, FNames, FPreserveWhiteSpace);
		finally
			aSource.Free
		end
	end;
  if Get_DocumentElement=nil then
		raise SimpleXMLException.Create(SSimpleXmlError26);
end;

function TXmlDocument.NewDocument(const aVersion, anEncoding,
	aRootElementName: TXmlString): IXmlElement;
begin
	Result := NewDocument(aVersion, anEncoding, FNames.GetID(aRootElementName, False));
end;

function TXmlDocument.NewDocument(const aVersion, anEncoding: TXmlString;
	aRootElementNameID: Integer): IXmlElement;
var XMLProcessingInstruction: TXmlProcessingInstruction;
	aChilds: TXmlNodeList;
	aRoot: TXmlElement;
  e: string;
begin
        fCodePage:=0;
	aChilds := GetChilds;
	aChilds.Clear;
	if anEncoding = '' then
		e := DefaultEncoding
	else
		e := anEncoding;
  //
  XMLProcessingInstruction := TXmlProcessingInstruction.Create( FNames, FNames.FXmlID,	'' );
  XMLProcessingInstruction.SetAttr( 'version',  aVersion );
  XMLProcessingInstruction.SetAttr( 'encoding', e );
  //
  aChilds.Insert( XMLProcessingInstruction, 0 );
  //
	aRoot := TXmlElement.Create(FNames, aRootElementNameID);
	aChilds.Insert(aRoot, 1);
	Result := aRoot;
end;

procedure TXmlDocument.Save(aStream: TStream);
var
	aXml: TXmlString;
{$IFDEF XML_WIDE_CHARS}
        w: word;
        s: AnsiString;
        NewLen: Integer;
{$endif}
begin
	aXml := Get_XML;
  {$IFDEF XML_WIDE_CHARS}
	if (uppercase(Get_Encoding)='UTF-16') or (uppercase(Get_Encoding)='UTF-16LE') then begin
		w:=$feff;
		aStream.write(w,sizeof(w));
		aStream.WriteBuffer(aXml[1], sizeof(TXmlChar)*Length(aXml))
	end else begin
                SetLength(s,length(aXML)*3);
                NewLen:=WideCharToMultiByte(CodePage, 0, PWideChar(aXML), length(aXML),
                        PChar(s), length(aXML), nil, nil);
                SetLength(s,NewLen);
                if s<>'' then
                  aStream.WriteBuffer(s[1], Length(s));
	end;
  {$else}
        if length(aXml)>0 then
                aStream.WriteBuffer(aXml[1], sizeof(TXmlChar)*Length(aXml));
  {$endif}
end;

procedure TXmlDocument.Save(const aFileName: TXmlString);
var
	aFile: TFileStream;
begin
	aFile := TFileStream.Create(aFileName, fmCreate or fmShareDenyWrite);
	try
		Save(aFile);
	finally
		aFile.Free
	end
end;

procedure TXmlDocument.SaveBinary(aStream: TStream; anOptions: LongWord);
var
	aWriter: TBinXmlWriter;
begin
	aWriter := TStmXmlWriter.Create(aStream, anOptions, 65536);
	try
		FNames.SaveBinXml(aWriter);
		SaveBinXml(aWriter);
	finally
		aWriter.Free
	end
end;

procedure TXmlDocument.SaveBinary(const aFileName: TXmlString; anOptions: LongWord);
var
	aFile: TFileStream;
begin
	aFile := TFileStream.Create(aFileName, fmCreate or fmShareDenyWrite);
	try
		SaveBinary(aFile, anOptions);
	finally
		aFile.Free
	end
end;

procedure TXmlDocument.SaveWithElementBody(aStream: TStream; GetBodyCallback: TGetBodyCallback;
      TagToWriteIn:TXmlString);
var
  aXml: TXmlString;
  PrevElementToWriteIn:TXmlString;
  PrevProc:TGetBodyCallback;
begin
  PrevProc:=ToWriteInEmptyXMLDocumentProc;
  ToWriteInEmptyXMLDocumentProc:=GetBodyCallback;
  PrevElementToWriteIn:=EmptyXMLDocumentElementToWriteIn;
  EmptyXMLDocumentElementToWriteIn:=TagToWriteIn;
  try
    aXml := Get_XML;
    aStream.WriteBuffer(aXml[1], sizeof(TXmlChar)*Length(aXml));
  finally
    ToWriteInEmptyXMLDocumentProc:=PrevProc;
    EmptyXMLDocumentElementToWriteIn:=PrevElementToWriteIn;
  end;
end;

procedure TXmlDocument.Set_PreserveWhiteSpace(aValue: Boolean);
begin
	FPreserveWhiteSpace := aValue;
end;

procedure TXmlDocument.Set_Text(const aText: TXmlString);
var
	aChilds: TXmlNodeList;
begin
	aChilds := GetChilds;
	aChilds.Clear;
	aChilds.Insert(TXmlText.Create(FNames, aText), 0);
end;

{ TXmlProcessingInstruction }

function TXmlProcessingInstruction.AsProcessingInstruction: IXmlProcessingInstruction;
begin
	Result := Self
end;

constructor TXmlProcessingInstruction.Create(aNames: TXmlNameTable;
  aTargetID: Integer; const aData: TXmlString);
begin
	inherited Create(aNames);
	FTargetID := aTargetID;
	FData := aData;
end;

function TXmlProcessingInstruction.DoCloneNode(aDeep: Boolean): IXmlNode;
begin
	Result := TXmlProcessingInstruction.Create(FNames, FTargetID, FData);
end;

function TXmlProcessingInstruction.Get_NodeNameID: Integer;
begin
	Result := FTargetID
end;

function TXmlProcessingInstruction.Get_NodeType: Integer;
begin
	Result := NODE_PROCESSING_INSTRUCTION
end;

function TXmlProcessingInstruction.Get_Text: TXmlString;
begin
	Result := FData; 
end;

function TXmlProcessingInstruction.Get_XML: TXmlString;
begin
	if FData = '' then
		Result := '<?' + FNames.GetName(FTargetID) + GetAttrsXML + '?>'
	else
		Result := '<?' + FNames.GetName(FTargetID) + ' ' + FData + '?>'
end;

procedure TXmlProcessingInstruction.SetNodeNameID(aValue: Integer);
begin
	FTargetID := aValue
end;

procedure TXmlProcessingInstruction.Set_Text(const aText: TXmlString);
begin
	FData := aText
end;

{ TXmlStrSource }

constructor TXmlStrSource.Create(const aSource: TXmlString);
begin
	inherited Create;
	FSource := aSource;
	FSourcePtr := PXmlChar(FSource);
	FSourceEnd := FSourcePtr + Length(FSource);
	if FSourcePtr = FSourceEnd then
		CurChar := #0
	else 
		CurChar := FSourcePtr^;
end;

function TXmlStrSource.EOF: Boolean;
begin
	Result := FSourcePtr = FSourceEnd
end;

function TXmlStrSource.Next: Boolean;
begin
	if FSourcePtr < FSourceEnd then
		Inc(FSourcePtr);
	if FSourcePtr = FSourceEnd then begin
		Result := False;
		CurChar := #0;
	end
	else begin
		Result := True;
		CurChar := FSourcePtr^;
	end;
end;

{ TXmlSource }

procedure TXmlSource.NewToken;
begin
	Inc(FTokenStackTop);
	if FTokenStackTop < Length(FTokenStack) then begin
		FToken := FTokenStack[FTokenStackTop];
		FToken.Clear
	end
	else begin
		SetLength(FTokenStack, FTokenStackTop + 1);
		FToken := TXmlToken.Create;
		FTokenStack[FTokenStackTop] := FToken;
	end
end;

function TXmlSource.AcceptToken: TXmlString;
begin
	SetLength(Result, FToken.FValuePtr - FToken.ValueStart);
	if Length(Result) > 0 then
		Move(FToken.ValueStart^, Result[1], Length(Result)*sizeof(TXmlChar));
	DropToken;
end;

procedure TXmlSource.SkipBlanks;
begin
	while not EOF and (CurChar <= ' ') do
		Next;
end;

// �� ����� - ������ ������ �����
// �� ������ - ������ ������, ������� �� �������� ���������� ��� ����
function TXmlSource.ExpectXmlName: TXmlString;
begin
	if not NameCanBeginWith(CurChar) then
		raise SimpleXMLException.Create(SSimpleXmlError11);
	NewToken;
	AppendTokenChar(CurChar);
	while Next and NameCanContain(CurChar) do
		AppendTokenChar(CurChar);
	Result := AcceptToken;
end;

// �� ����� - ������ ������ �����
// �� ������ - ������ ������, ������� �� �������� ���������� ��� �����
function TXmlSource.ExpectDecimalInteger: Integer;
var
	s: TXmlString;
	e: Integer;
begin
	NewToken;
	while (CurChar >= '0') and (CurChar <= '9') do begin
		AppendTokenChar(CurChar);
		Next;
	end;
	s := AcceptToken;
	if Length(s) = 0 then
		raise SimpleXMLException.Create(SSimpleXmlError12);
	Val(s, Result, e);
end;

// �� ����� - ������ ������ �����
// �� ������ - ������ ������, ������� �� �������� ���������� ���
//  ����������������� �����
function TXmlSource.ExpectHexInteger: Integer;
var
	s: TXmlString;
	e: Integer;
begin
	NewToken;
	{$IFDEF XML_WIDE_CHARS}
	while (CurChar >= '0') and (CurChar <= '9') or
		(CurChar >= 'A') and (CurChar <= 'F') or
		(CurChar >= 'a') and (CurChar <= 'f') do begin
	{$ELSE}
	while CurChar in ['0'..'9', 'A'..'F', 'a'..'f'] do begin
	{$ENDIF}
		AppendTokenChar(CurChar);
		Next;
	end;
	s := '$';
	s := s + AcceptToken;
	if Length(s) = 1 then
		raise SimpleXMLException.Create(SSimpleXmlError13);
	Val(s, Result, e);
end;

// �� �����: "&"
// �� ������: ��������� �� ";"
function TXmlSource.ExpectXmlEntity: TXmlChar;
var
	s: TXmlString;
begin
	if not Next then
		raise SimpleXMLException.Create(SSimpleXmlError14);
	if CurChar = '#' then begin
		if not Next then
			raise SimpleXMLException.Create(SSimpleXmlError12);
		if CurChar = 'x' then begin
			Next;
			Result := TXmlChar(ExpectHexInteger);
		end
		else
			Result := TXmlChar(ExpectDecimalInteger);
		ExpectChar(';');
	end
	else begin
		s := ExpectXmlName;
		ExpectChar(';');
		if s = 'amp' then
			Result := '&'
		else if s = 'quot' then
			Result := '"'
		else if s = 'lt' then
			Result := '<'
		else if s = 'gt' then
			Result := '>'
		else if s = 'apos' then
			Result := ''''
		else
			raise SimpleXMLException.CreateFmt(SSimpleXmlError15,[s]);
	end
end;

procedure TXmlSource.ExpectChar(aChar: TXmlChar);
begin
	if EOF or (CurChar <> aChar) then
		raise SimpleXMLException.CreateFmt(SSimpleXmlError16, [aChar]);
	Next;
end;

procedure TXmlSource.ExpectText(aText: PXmlChar);
var StartText: PXmlChar;
begin
        StartText:=aText;
	while aText^ <> #0 do begin
		if (CurChar <> aText^) or EOF then
			raise SimpleXMLException.CreateFmt(SSimpleXmlError17, [StartText]);
		Inc(aText);
		Next;
	end;
end;

// �� �����: ����������� �������
// �� ������: ������, ��������� �� ����������� ��������
function TXmlSource.ExpectQuotedText(aQuote: TXmlChar): TXmlString;
begin
	NewToken;
	Next;
	while not EOF and (CurChar <> aQuote) do begin
		if CurChar = '&' then
			AppendTokenChar(ExpectXmlEntity)
		else if CurChar = '<' then
			raise SimpleXMLException.Create(SSimpleXmlError18)
		else begin
			AppendTokenChar(CurChar);
			Next;
		end
	end;
	if EOF then
		raise SimpleXMLException.CreateFmt(SimpleXmlError19, [aQuote]);
	Next;
	Result := AcceptToken;
end;

procedure TXmlSource.ParseAttrs(aNode: TXmlNode);
var
	aName: TXmlString;
	aValue: TXmlString;
	{$IFNDEF XML_WIDE_CHARS}
        len: cardinal;
        WS: WideString;
	{$ENDIF}
begin
	SkipBlanks;
	while not EOF and NameCanBeginWith(CurChar) do begin
		aName := ExpectXmlName;
		SkipBlanks;
		ExpectChar('=');
		SkipBlanks;
		if EOF then
			raise SimpleXMLException.Create(SSimpleXmlError20);
		if (CurChar = '''') or (CurChar = '"') then
			aValue := ExpectQuotedText(CurChar)
		else
			raise SimpleXMLException.Create(SSimpleXmlError21);
	{$IFNDEF XML_WIDE_CHARS}
                if fUTF8 then begin
                        len:=Utf8ToUnicode(nil, 0, pChar(aValue), length(aValue));
                        if len=Cardinal(-1) then
		                raise SimpleXMLException.CreateFmt(SBadUTF8, []);
                        if (len-1)=cardinal(length(aValue)) then
                                aNode.SetAttr(aName, aValue)
                        else begin
                                SetLength(WS,len-1);
                                Utf8ToUnicode(PWideChar(WS), len, pChar(aValue), length(aValue));
                                aNode.SetVarAttr(aName, WS)
                        end;
                end else
	{$ENDIF}

		aNode.SetAttr(aName, aValue);
		SkipBlanks;
	end;
end;

function StrEquals(p1, p2: PXmlChar; aLen: Integer): Boolean;
begin
	{$IFDEF XML_WIDE_CHARS}
	while aLen > 0 do
		if p1^ <> p2^ then begin
			Result := False;
			Exit
		end
		else if (p1^ = #0) or (p2^ = #0) then begin
			Result := p1^ = p2^;
			Exit
		end
		else begin
			Inc(p1);
			Inc(p2);
			Dec(aLen);
		end;
	Result := True;
	{$ELSE}
	Result := StrLComp(p1, p2, aLen) = 0
	{$ENDIF}
end;

// �� �����: ������ ������ ������
// �� ������: ������, ��������� �� ��������� �������� ������������
function TXmlSource.ParseTo(aText: PXmlChar): TXmlString;
var
	aCheck: PXmlChar;
	p: PXmlChar;
begin
	NewToken;
	aCheck := aText;
	while not EOF do begin
		if CurChar = aCheck^ then begin
			Inc(aCheck);
			Next;
			if aCheck^ = #0 then begin
				Result := AcceptToken;
				Exit;
			end;
		end
		else if aCheck = aText then begin
			AppendTokenChar(CurChar);
			Next;
		end
		else begin
			p := aText + 1;
			while (p < aCheck) and not StrEquals(p, aText, aCheck - p) do
				Inc(p);
			AppendTokenText(aText, p - aText);
			if p < aCheck then
				aCheck := p
			else
				aCheck := aText;
		end;
	end;
	raise SimpleXMLException.CreateFmt(SimpleXmlError22, [aText]);
end;

procedure TXmlSource.AppendTokenChar(aChar: TXmlChar);
begin
	FToken.AppendChar(aChar);
end;

procedure TXmlSource.AppendTokenText(aText: PXmlChar; aCount: Integer);
begin
	FToken.AppendText(aText, aCount)
end;

procedure TXmlSource.DropToken;
begin
	Dec(FTokenStackTop);
	if FTokenStackTop >= 0 then
		FToken := FTokenStack[FTokenStackTop]
	else
		FToken := nil
end;

constructor TXmlSource.Create;
begin
	inherited Create;
	FTokenStackTop := -1;
end;

destructor TXmlSource.Destroy;
var
	i: Integer;
begin
	for i := 0 to Length(FTokenStack) - 1 do
		FTokenStack[i].Free;
	inherited;
end;

{ TXmlToken }

procedure TXmlToken.AppendChar(aChar: TXmlChar);
var
	aSaveLength: Integer;
begin
	if FValuePtr >= FValueEnd then begin
		aSaveLength := FValuePtr - FValueStart;
		SetLength(FValueBuf, aSaveLength + 1);
		FValueStart := PXmlChar(FValueBuf);
		FValuePtr := FValueStart + aSaveLength;
		FValueEnd := FValueStart + System.Length(FValueBuf);
	end;
	FValuePtr^ := aChar;
	Inc(FValuePtr);
end;

procedure TXmlToken.AppendText(aText: PXmlChar; aCount: Integer);
var
	aSaveLength: Integer;
begin
	if (FValuePtr + aCount) > FValueEnd then begin
		aSaveLength := FValuePtr - FValueStart;
		SetLength(FValueBuf, aSaveLength + aCount);
		FValueStart := PXmlChar(FValueBuf);
		FValuePtr := FValueStart + aSaveLength;
		FValueEnd := FValueStart + System.Length(FValueBuf);
	end;
	Move(aText^, FValuePtr^, aCount*sizeof(TXmlChar));
	Inc(FValuePtr, aCount);
end;

procedure TXmlToken.Clear;
begin
	FValuePtr := FValueStart;
end;

constructor TXmlToken.Create;
begin
	inherited Create;
	SetLength(FValueBuf, 32);
	FValueStart := PXmlChar(FValueBuf);
	FValuePtr := FValueStart;
	FValueEnd := FValueStart + 32;
end;

function TXmlToken.Length: Integer;
begin
	Result := FValuePtr - FValueStart;
end;

{ TXmlStmSource }

constructor TXmlStmSource.Create(aStream: TStream; aBufSize: Integer);
var
	aSize: Integer;
begin
	inherited Create;
	FStream := aStream;
	FBufSize := aBufSize;
	FBufStart := AllocMem(aBufSize);
	FBufPtr := FBufStart;
	FBufEnd := FBufStart;
	FSize := aStream.Size;
	if FSize = 0 then
		CurChar := #0
	else begin
		if FSize < FBufSize then
			aSize := FSize
		else
			aSize := FBufSize;
		FStream.ReadBuffer(FBufStart^, aSize);
		FBufEnd := FBufStart + aSize;
		FBufPtr := FBufStart;
		Dec(FSize, aSize);
		{$IFDEF XML_WIDE_CHARS}
                IsUTF16 := pWord(FBufPtr)^ = $feff;
                if IsUTF16 then begin
                        InternalNext;//��������� $FEFF
                end else
                        CurChar := AnsiToUnicode(FBufPtr^);
		{$ELSE}
		CurChar := FBufPtr^;
		{$ENDIF}
	end
end;

destructor TXmlStmSource.Destroy;
begin
	FreeMem(FBufStart);
	inherited;
end;

function TXmlStmSource.EOF: Boolean;
begin
	Result := (FBufPtr = FBufEnd) and (FSize = 0)
end;

{$IFDEF XML_WIDE_CHARS}
function TXmlStmSource.AnsiToUnicode(c: AnsiChar): WideChar;
begin
	MultiByteToWideChar(fCodePage, 0, @c, 1, @Result, 1);
end;
{$ENDIF}

function TXmlStmSource.Next: Boolean;
	{$IFDEF XML_WIDE_CHARS}
var wc: Cardinal;
    c: byte;
	{$ENDIF}
begin
	{$IFDEF XML_WIDE_CHARS}
		Result := InternalNext;
		if not Result or IsUTF16 then exit;
		if fUTF8 then begin
			wc := Cardinal(FBufPtr^);
			if (wc and $80) <> 0 then begin
				Result := InternalNext;
				if not Result then exit; // incomplete multibyte char
				wc := wc and $3F;
				if (wc and $20) <> 0 then begin
					c := Byte(FBufPtr^);
					if (c and $C0) <> $80 then begin
						Result:=False;
						CurChar:=#0;
						Exit;      // malformed trail byte or out of range char
					end;
					Result := InternalNext;
					if not Result then exit; // incomplete multibyte char
                                        wc := (wc shl 6) or (c and $3F);
				end;
				c := Byte(FBufPtr^);
				if (c and $C0) <> $80 then begin
					Result:=False;
					CurChar:=#0;
					Exit;       // malformed trail byte
				end;
				CurChar := WideChar((wc shl 6) or (c and $3F));
			end;
		end else
			CurChar := AnsiToUnicode(FBufPtr^);
	{$ELSE}
		Result := InternalNext;
	{$ENDIF}
end;

function TXmlStmSource.InternalNext: Boolean;
var
	aSize: Integer;
begin
	if FBufPtr < FBufEnd then
        {$IFDEF XML_WIDE_CHARS}
                if IsUTF16 then
		        Inc(FBufPtr,2)
                else
        {$endif}
		Inc(FBufPtr);
	if FBufPtr >= FBufEnd then
		if FSize = 0 then begin
			Result := False;
			CurChar := #0;
                        exit;
		end
		else begin
			if FSize < FBufSize then
				aSize := FSize
			else
				aSize := FBufSize;
			FStream.ReadBuffer(FBufStart^, aSize);
			FBufEnd := FBufStart + aSize;
			FBufPtr := FBufStart;
			Dec(FSize, aSize);
		end;
        Result := True;
        {$IFDEF XML_WIDE_CHARS}
        if IsUTF16 then
                CurChar := pXMLChar(FBufPtr)^;
        {$else}
                CurChar := FBufPtr^;
        {$endif}
end;

{ TStmXmlReader }

constructor TStmXmlReader.Create(aStream: TStream; aBufSize: Integer);
begin
	inherited Create;
	FStream := aStream;
	FRestSize := aStream.Size - aStream.Position;
	FBufSize := aBufSize;
	FBufStart := AllocMem(aBufSize);
	FBufEnd := FBufStart;
	FBufPtr := FBufEnd;
	Read(FOptions, sizeof(FOptions));
end;

destructor TStmXmlReader.Destroy;
begin
	FreeMem(FBufStart);
	inherited;
end;

procedure TStmXmlReader.Read(var aBuf; aSize: Integer);
var
	aBufRest: Integer;
	aDst: PChar;
	aBufSize: Integer;
begin
	if aSize > FRestSize then
		raise SimpleXMLException.Create(SSimpleXmlError23);

	aBufRest := FBufEnd - FBufPtr;
	if aSize <= aBufRest then begin
		Move(FBufPtr^, aBuf, aSize);
		Inc(FBufPtr, aSize);
		Dec(FRestSize, aSize);
	end
	else begin
		aDst := @aBuf;
		Move(FBufPtr^, aDst^, aBufRest);
		Inc(aDst, aBufRest);
		FStream.ReadBuffer(aDst^, aSize - aBufRest);
		Dec(FRestSize, aSize);

		if FRestSize < FBufSize then
			aBufSize := FRestSize
		else
			aBufSize := FBufSize;
		FBufPtr := FBufStart;
		FBufEnd := FBufStart + aBufSize;
		if aBufSize > 0 then
			FStream.ReadBuffer(FBufStart^, aBufSize);
	end;
end;

{ TStrXmlReader }

constructor TStrXmlReader.Create(const aStr: String);
var
	aSig: array [1..BinXmlSignatureSize] of Char;
begin
	inherited Create;
	FString := aStr;
	FRestSize := Length(aStr);
	FPtr := PChar(FString);
	Read(aSig, BinXmlSignatureSize);
	Read(FOptions, sizeof(FOptions));
end;

procedure TStrXmlReader.Read(var aBuf; aSize: Integer);
begin
	if aSize > FRestSize then
		raise SimpleXMLException.Create(SSimpleXmlError23);
	Move(FPtr^, aBuf, aSize);
	Inc(FPtr, aSize);
	Dec(FRestSize, aSize);
end;

{ TBinXmlReader }

function TBinXmlReader.ReadAnsiString: String;
var
	aLength: LongInt;
begin
	aLength := ReadLongint;
	if aLength = 0 then
		Result := ''
	else begin
		SetLength(Result, aLength);
		Read(Result[1], aLength);
	end
end;

function TBinXmlReader.ReadLongint: Longint;
var
	b: Byte;
begin
	Result := 0;
	Read(Result, 1);
	if Result >= $80 then
		if Result = $FF then
			Read(Result, sizeof(Result))
		else begin
			Read(b, 1);
			Result := (Result and $7F) shl 8 or b;
		end
end;

procedure TBinXmlReader.ReadVariant(var v: TVarData);
var
	aDataType: Word;
{$ifndef Dos32}
	aSize: Longint;
	p: Pointer;
{$endif}
begin
	VarClear(Variant(v));
	aDataType := ReadLongint;
	case aDataType of
		varEmpty: ;
		varNull: ;
		varSmallint:
			Read(v.VSmallint, sizeof(SmallInt));
		varInteger:
			Read(v.VInteger, sizeof(Integer));
		varSingle:
			Read(v.VSingle, sizeof(Single));
		varDouble:
			Read(v.VDouble, sizeof(Double));
		varCurrency:
			Read(v.VCurrency, sizeof(Currency));
		varDate:
			Read(v.VDate, sizeof(TDateTime));
		varOleStr:
			Variant(v) := ReadWideString;
		varBoolean:
			Read(v.VBoolean, sizeof(WordBool));
		varShortInt:
			Read(ShortInt(v.VByte), sizeof(ShortInt));
		varByte:
			Read(v.VByte, sizeof(Byte));
		varWord:
			Read(Word(v.VSmallInt), sizeof(Word));
		varLongWord:
			Read(LongWord(v.VInteger), sizeof(LongWord));
		varInt64:
			Read(PInt64(@v.VInteger)^, sizeof(Int64));
		varString:
			Variant(v) := ReadAnsiString;
		varArray + varByte:
			begin
        {$ifdef Dos32}
        assert(false);
        {$else}
				aSize := ReadLongint;
				Variant(v) := VarArrayCreate([0, aSize - 1], varByte);
				p := VarArrayLock(Variant(v));
				try
					Read(p^, aSize);
				finally
					VarArrayUnlock(Variant(v))
				end
        {$endif}
			end;
		else
			raise SimpleXMLException.Create(SSimpleXmlError24);
	end;
	v.VType := aDataType;
end;

function TBinXmlReader.ReadWideString: WideString;
var
	aLength: LongInt;
begin
	aLength := ReadLongint;
	if aLength = 0 then
		Result := ''
	else begin
		SetLength(Result, aLength);
		Read(Result[1], aLength*sizeof(WideChar));
	end
end;

function TBinXmlReader.ReadXmlString: TXmlString;
begin
	if (FOptions and BINXML_USE_WIDE_CHARS) <> 0 then
		Result := ReadWideString
	else
		Result := ReadAnsiString
end;

{ TStmXmlWriter }

constructor TStmXmlWriter.Create(aStream: TStream; anOptions: LongWord;
  aBufSize: Integer);
begin
	inherited Create;
	FStream := aStream;
	FOptions := anOptions;
	FBufSize := aBufSize;
	FBufStart := AllocMem(aBufSize);
	FBufEnd := FBufStart + aBufSize;
	FBufPtr := FBufStart;
	Write(BinXmlSignature[1], BinXmlSignatureSize);
	Write(FOptions, sizeof(FOptions));
end;

destructor TStmXmlWriter.Destroy;
begin
	if FBufPtr > FBufStart then
		FStream.WriteBuffer(FBufStart^, FBufPtr - FBufStart);
	FreeMem(FBufStart);
	inherited;
end;

procedure TStmXmlWriter.Write(const aBuf; aSize: Integer);
var
	aBufRest: Integer;
begin
	aBufRest := FBufEnd - FBufPtr;
	if aSize <= aBufRest then begin
		Move(aBuf, FBufPtr^, aSize);
		Inc(FBufPtr, aSize);
	end
	else begin
		if FBufPtr > FBufStart then begin
			FStream.WriteBuffer(FBufStart^, FBufPtr - FBufStart);
			FBufPtr := FBufStart;
		end;
		FStream.WriteBuffer(aBuf, aSize);
	end
end;

{ TStrXmlWriter }

constructor TStrXmlWriter.Create(anOptions: LongWord; aBufSize: Integer);
begin
	inherited Create;
	FData := '';
	FOptions := anOptions;
	FBufSize := aBufSize;
	FBufStart := AllocMem(aBufSize);
	FBufEnd := FBufStart + aBufSize;
	FBufPtr := FBufStart;
	Write(BinXmlSignature[1], BinXmlSignatureSize);
	Write(FOptions, sizeof(FOptions));
end;

destructor TStrXmlWriter.Destroy;
begin
	FreeMem(FBufStart);
	inherited;
end;

procedure TStrXmlWriter.FlushBuf;
var
	aPrevSize: Integer;
	aSize: Integer;
begin
	aPrevSize := Length(FData);
	aSize := FBufPtr - FBufStart;
	SetLength(FData, aPrevSize + aSize);
	Move(FBufStart^, FData[aPrevSize + 1], aSize);
	FBufPtr := FBufStart;
end;

procedure TStrXmlWriter.Write(const aBuf; aSize: Integer);
var
	aBufRest: Integer;
	aPrevSize: Integer;
	aBufSize: Integer;
begin
	aBufRest := FBufEnd - FBufPtr;
	if aSize <= aBufRest then begin
		Move(aBuf, FBufPtr^, aSize);
		Inc(FBufPtr, aSize);
	end
	else begin
		aPrevSize := Length(FData);
		aBufSize := FBufPtr - FBufStart;
		SetLength(FData, aPrevSize + aBufSize + aSize);
		if aBufSize > 0 then
			Move(FBufStart^, FData[aPrevSize + 1], aBufSize);
		Move(aBuf, FData[aPrevSize + aBufSize + 1], aSize);
		FBufPtr := FBufStart;
	end
end;

{ TBinXmlWriter }

procedure TBinXmlWriter.WriteAnsiString(const aValue: String);
var
	aLength: LongInt;
begin
	aLength := Length(aValue);
	WriteLongint(aLength);
	if aLength > 0 then
		Write(aValue[1], aLength);
end;

procedure TBinXmlWriter.WriteLongint(aValue: Longint);
var
	b: array [0..1] of Byte;
begin
	if aValue < 0 then begin
		b[0] := $FF;
		Write(b[0], 1);
		Write(aValue, SizeOf(aValue));
	end
	else if aValue < $80 then
		Write(aValue, 1)
	else if aValue <= $7FFF then begin
		b[0] := (aValue shr 8) or $80;
		b[1] := aValue and $FF;
		Write(b, 2);
	end
	else begin
		b[0] := $FF;
		Write(b[0], 1);
		Write(aValue, SizeOf(aValue));
	end;
end;

procedure TBinXmlWriter.WriteVariant(const v: TVarData);
{$ifndef Dos32}
var
	aSize: Integer;
	p: Pointer;
{$endif}  
begin
	WriteLongint(v.VType);
	case v.VType of
		varEmpty: ;
		varNull: ;
		varSmallint:
			Write(v.VSmallint, sizeof(SmallInt));
		varInteger:
			Write(v.VInteger, sizeof(Integer));
		varSingle:
			Write(v.VSingle, sizeof(Single));
		varDouble:
			Write(v.VDouble, sizeof(Double));
		varCurrency:
			Write(v.VCurrency, sizeof(Currency));
		varDate:
			Write(v.VDate, sizeof(TDateTime));
		varOleStr:
			WriteWideString(Variant(v));
		varBoolean:
			Write(v.VBoolean, sizeof(WordBool));
		varShortInt:
			Write(ShortInt(v.VByte), sizeof(ShortInt));
		varByte:
			Write(v.VByte, sizeof(Byte));
		varWord:
			Write(Word(v.VSmallInt), sizeof(Word));
		varLongWord:
			Write(LongWord(v.VInteger), sizeof(LongWord));
		varInt64:
			Write(PInt64(@v.VInteger)^, sizeof(Int64));
		varString:
			WriteAnsiString(Variant(v));
		varArray + varByte:
			begin
        {$ifdef Dos32}
        assert(false);
        {$else}
				aSize := VarArrayHighBound(Variant(v), 1) - VarArrayLowBound(Variant(v), 1) + 1;
				WriteLongint(aSize);
				p := VarArrayLock(Variant(v));
				try
					Write(p^, aSize);
				finally
					VarArrayUnlock(Variant(v))
				end
        {$endif}
			end;
		else
			raise SimpleXMLException.Create(SSimpleXmlError25);
	end;
end;

procedure TBinXmlWriter.WriteWideString(const aValue: WideString);
var
	aLength: LongInt;
begin
	aLength := Length(aValue);
	WriteLongint(aLength);
	if aLength > 0 then
		Write(aValue[1], aLength*sizeof(WideChar));
end;


procedure TBinXmlWriter.WriteXmlString(const aValue: TXmlString);
begin
	if (FOptions and BINXML_USE_WIDE_CHARS) <> 0 then
		WriteWideString(aValue)
	else
		WriteAnsiString(aValue)
end;

function CreateXmlElement(const aName: TXmlString; const aNameTable: IXmlNameTable): IXmlElement;
var
	aNameTableImpl: TXmlNameTable;
begin
	if Assigned(aNameTable) then
		aNameTableImpl := aNameTable.GetObject as TXmlNameTable
	else
		aNameTableImpl := DefaultNameTableImpl;
	Result := TXmlElement.Create(aNameTableImpl, aNameTableImpl.GetID(aName, False));
end;

function CreateXmlDocument(
	const aRootElementName: String;
	const aVersion: String;
	const anEncoding: String;
	const aNames: IXmlNameTable): IXmlDocument;
var
	aNameTable: TXmlNameTable;
begin
	if Assigned(aNames) then
		aNameTable := aNames.GetObject as TXmlNameTable
	else
		aNameTable := DefaultNameTableImpl;
	Result := TXmlDocument.Create(aNameTable);
	if aRootElementName <> '' then
		Result.NewDocument(aVersion, anEncoding, aRootElementName);
end;

function LoadXmlDocumentFromXML(const aXML: TXmlString): IXmlDocument;
begin
	Result := TXmlDocument.Create(DefaultNameTableImpl);
	Result.LoadXML(aXML);
end;

function LoadXmlDocumentFromBinaryXML(const aXML: String): IXmlDocument;
begin
	Result := TXmlDocument.Create(DefaultNameTableImpl);
	Result.LoadBinaryXML(aXML);
end;

function LoadXmlDocument(aStream: TStream): IXmlDocument;
begin
	Result := TXmlDocument.Create(DefaultNameTableImpl);
	Result.Load(aStream);
end;

function LoadXmlDocument(const aFileName: TXmlString): IXmlDocument; overload;
begin
	Result := TXmlDocument.Create(DefaultNameTableImpl);
	Result.Load(aFileName);
end;

function LoadXmlDocument(aResType, aResName: PChar): IXmlDocument; overload;
begin
	Result := TXmlDocument.Create(DefaultNameTableImpl);
	Result.LoadResource(aResType, aResName);
end;

initialization
	DefaultNameTableImpl := TXmlNameTable.Create(4096);
	DefaultNameTable := DefaultNameTableImpl;
        EncodingToCodePage:=DefEncodingToCodePage;
{$ifdef Delphi7}
  GetLocaleFormatSettings(GetThreadLocale,XMLFormatSettings);
  XMLFormatSettings.DecimalSeparator:='.';
{$endif}
finalization
	DefaultNameTable := nil;
	DefaultNameTableImpl := nil;
end.
