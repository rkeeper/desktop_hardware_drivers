        ��  ��                  F  D   ��
 D E V I C E C O N F I G V 0 1 X S D         0           <?xml version="1.0" encoding="utf-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:simpleType name="enum_LogLevel">
    <xs:restriction base="xs:integer">
      <xs:enumeration value="0">
        <xs:annotation>
          <xs:documentation xml:lang="en" source="captiontext">0. ERROR</xs:documentation>
          <xs:documentation xml:lang="en" source="description">0. Log only errors</xs:documentation>
        </xs:annotation>
      </xs:enumeration>
      <xs:enumeration value="1">
        <xs:annotation>
          <xs:documentation xml:lang="en" source="captiontext">1. EXP_FUNC_CALL</xs:documentation>
          <xs:documentation xml:lang="en" source="description">1. Log exported functions calls</xs:documentation>
        </xs:annotation>
      </xs:enumeration>
      <xs:enumeration value="2">
        <xs:annotation>
          <xs:documentation xml:lang="en" source="captiontext">2. DEV_FUNC_CALL</xs:documentation>
          <xs:documentation xml:lang="en" source="description">2. Log device functions calls</xs:documentation>
        </xs:annotation>
      </xs:enumeration>
      <xs:enumeration value="3">
        <xs:annotation>
          <xs:documentation xml:lang="en" source="captiontext">3. SERIAL_TRANS</xs:documentation>
          <xs:documentation xml:lang="en" source="description">3. Log low level transactions</xs:documentation>
        </xs:annotation>
      </xs:enumeration>
      <xs:enumeration value="4">
        <xs:annotation>
          <xs:documentation xml:lang="en" source="captiontext">4. PHYSIC_TRAFIC</xs:documentation>
          <xs:documentation xml:lang="en" source="description">4. Log physic level traffic</xs:documentation>
        </xs:annotation>
      </xs:enumeration>
      <xs:enumeration value="5">
        <xs:annotation>
          <xs:documentation xml:lang="en" source="captiontext">5. TALKATIVE</xs:documentation>
          <xs:documentation xml:lang="en" source="description">5. Log all</xs:documentation>
        </xs:annotation>
      </xs:enumeration>
      <xs:enumeration value="6">
        <xs:annotation>
          <xs:documentation xml:lang="en" source="captiontext">6. OSFUNC</xs:documentation>
          <xs:documentation xml:lang="en" source="description">6. Log operation system calls</xs:documentation>
        </xs:annotation>
      </xs:enumeration>
    </xs:restriction>
  </xs:simpleType>
  <!-- Config goes here -->
  <xs:element name="xmlConfig">
    <xs:complexType>
      <xs:all>
        <xs:element name="Parameters">
          <xs:complexType>
            <xs:all>
              <xs:element name="LogLevel" type="enum_LogLevel" default="3">
                <xs:annotation>
                  <xs:documentation xml:lang="en" source="captiontext">Log Level</xs:documentation>
                  <xs:documentation xml:lang="en" source="description">0-errors, 1-external function calls, 2-all function calls, 3-high level transport, 4-low level transport, 5-all</xs:documentation>
                </xs:annotation>
              </xs:element>
              <xs:element name="LogRotateSize" type="xs:integer" default="10">
                <xs:annotation>
                  <xs:documentation xml:lang="en" source="captiontext">LogRotateSize</xs:documentation>
                  <xs:documentation xml:lang="en" source="description">Size of logfile, to log rotation (MB), : 0 - disable rotation on size</xs:documentation>
                </xs:annotation>
              </xs:element>
              <xs:element name="LogRotateCount" type="xs:integer" default="2">
                <xs:annotation>
                  <xs:documentation xml:lang="en" source="captiontext">LogRotateCount</xs:documentation>
                  <xs:documentation xml:lang="en" source="description">Log rotation count : 0 - disable rotation</xs:documentation>
                </xs:annotation>
              </xs:element>
              <xs:element name="MsgLanguage" type="xs:string" default="en">
                <xs:annotation>
                  <xs:documentation xml:lang="en" source="captiontext">Language of messages</xs:documentation>
                  <xs:documentation xml:lang="en" source="description">Language of messages, the string matches with the extension of the localisation file, for example: en</xs:documentation>
                </xs:annotation>
              </xs:element>
              <xs:element name="FiscRegTypeID" type="xs:integer" default="183">
                <xs:annotation>
                  <xs:documentation xml:lang="ru" source="captiontext">Эмулируемый FiscRegTypeID. UniFR сам обрабатывает это параметр.</xs:documentation>
                </xs:annotation>
              </xs:element>
              <xs:element name="FileNameLogWithUFRInitXMLReturn" type="xs:normalizedString" default="">
                <xs:annotation>
                  <xs:documentation xml:lang="ru" source="captiontext">путь к логу драйвера, откуда читать UFRInitXMLReturn для получения опций</xs:documentation>
                  <xs:documentation xml:lang="en" source="captiontext">path the file with UFRInitXMLReturn</xs:documentation>
                </xs:annotation>
              </xs:element>
              <xs:element name="Options" type="xs:normalizedString" default="Text, ZeroReceipt, DeleteReceipt, ZReport, MoneyInOut, XReport, ZeroSale, Program, TextInReceipt, BarCodeInNotFisc, TextInLine, DrawerOpen, DrawerState, CustomerDisplay, ZWhenClosedShift, CashRegValue, DeleteReturn, AbsItemDiscount, AbsItemMarkup, ReturnReceipt, CorrectPriceToPay, CorrectionReceipt">
                <xs:annotation>
                  <xs:documentation xml:lang="ru" source="captiontext">список опций через пробел или запятую. не используется если задан FileNameLogWithUFRInitXMLReturn</xs:documentation>
                  <xs:documentation xml:lang="en" source="captiontext">options list</xs:documentation>
                </xs:annotation>
              </xs:element>
              <xs:element name="ChangeFromTypeIndexes" type="xs:normalizedString" default=""/>
            </xs:all>
          </xs:complexType>
        </xs:element>
      </xs:all>
      <xs:attribute name="ProtocolVersion" type="xs:integer"/>
    </xs:complexType>
  </xs:element>
</xs:schema>
  