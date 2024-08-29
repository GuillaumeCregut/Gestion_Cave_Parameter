unit Uppale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Types,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Win.Registry, StrUtils, System.UITypes, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.Samples.Spin;

type
  TFPpale = class(TForm)
    PageControl1: TPageControl;
    TSConfig: TTabSheet;
    TSProgrammation: TTabSheet;
    GBParamsCom: TGroupBox;
    Label1: TLabel;
    CBPort: TComboBox;
    Label2: TLabel;
    CBBaudRate: TComboBox;
    Label3: TLabel;
    CBParity: TComboBox;
    Label4: TLabel;
    CBDatas: TComboBox;
    Label5: TLabel;
    CBStop: TComboBox;
    BValidateParam: TButton;
    SBStatus: TStatusBar;
    GBProg: TGroupBox;
    Label6: TLabel;
    ESsid: TEdit;
    Label7: TLabel;
    EWifiPass: TEdit;
    CBDHCP: TCheckBox;
    PNetwork: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    GBAppli: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    BReadProd: TButton;
    BWriteProg: TButton;
    MEIpAdress: TMaskEdit;
    MESubnet: TMaskEdit;
    MEGateway: TMaskEdit;
    MEDns1: TMaskEdit;
    MEDns2: TMaskEdit;
    MEIpServer: TMaskEdit;
    EAppKey: TEdit;
    EPeriod: TEdit;
    SpinButton1: TSpinButton;
    Memo1: TMemo;
    procedure LoadComNumber();
    procedure LoadFromRegistry();
    procedure StoreToRegistry();
    procedure EnableNetWorkPanel(state: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure BValidateParamClick(Sender: TObject);
    procedure CBDHCPClick(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure ConfigureComPort();
    function validIpAdress(adress: String): string;
    procedure MEIpAdressExit(Sender: TObject);
    procedure MESubnetExit(Sender: TObject);
    procedure MEGatewayExit(Sender: TObject);
    procedure MEDns1Exit(Sender: TObject);
    procedure MEDns2Exit(Sender: TObject);
    function CreateProg(): TStringList;
    procedure MEIpServerExit(Sender: TObject);
    procedure BWriteProgClick(Sender: TObject);
    procedure BReadProdClick(Sender: TObject);
    procedure ESsidChange(Sender: TObject);
    procedure EWifiPassChange(Sender: TObject);

  const
    RegKey = 'Software\Editiel98\CellarManager\';
  private
    { Déclarations privées }
    isValidate: Boolean;
    mesureInterval: Integer;
    useDHCP: Boolean;
    serialHasChanged: Boolean;
    progHasChanged: Boolean;
    // Board Parameters
    IPCard: String;
    SubNetCard: String;
    GatewayCard: String;
    DNS1Card: String;
    DNS2Card: String;
    IpServerCard: String;
    // Com Port Parameters
    BaudRate: Integer;
    PortNumber: Integer;
    Parity: Integer;
    StopBit: Integer;
    BitNumber: Integer;
  public
    { Déclarations publiques }
  end;

var
  FPpale: TFPpale;

implementation

uses UProtocol;

{$R *.dfm}

// TODO: Change ProgHasChanged for wifi and params when values changes
function TFPpale.CreateProg(): TStringList;
var
  IpAdress, SubnetMask, DNS1, DNS2, Gateway, SSID, PassWifi, APIKey, IpServer,
    Period, DateDay, DateMonth, DateYear, DateHour, DateMinute: String;
  CurrentTime: TDateTime;
  ConfigArray: TStringList;

begin
  ConfigArray := TStringList.create();
  IpAdress := '';
  SubnetMask := '';
  DNS1 := '';
  Gateway := '';
  DNS2 := '';
  SSID := ESsid.Text;
  if SSID = '' then
  begin
    MessageDlg('Le wifi ne doit pas être vide', TMsgDlgType.mtError,
      mbOKCancel, 0);
    raise Exception.create('Message d''erreur');
  end;
  PassWifi := EWifiPass.Text;
  if PassWifi = '' then
  begin
    MessageDlg('Le mot de passe wifi ne doit pas être vide',
      TMsgDlgType.mtError, mbOKCancel, 0);
    raise Exception.create('Message d''erreur');
  end;
  ConfigArray.Add(SSID);
  ConfigArray.Add(PassWifi);

  if not useDHCP then
  begin
    IpAdress := IPCard;
    SubnetMask := SubNetCard;
    DNS1 := DNS1Card;
    Gateway := GatewayCard;
    DNS2 := DNS2Card;
    if ((IpAdress = '') Or (SubnetMask = '') Or (Gateway = '') or (DNS1 = '') or
      (DNS2 = '')) then
    begin
      MessageDlg
        ('Si vous décochez la case DHCP, tous les champs doivent être remplis',
        TMsgDlgType.mtError, mbOKCancel, 0);
      raise Exception.create('Message d''erreur');
    end;
    ConfigArray.Add('1');
    ConfigArray.Add(IpAdress);
    ConfigArray.Add(SubnetMask);
    ConfigArray.Add(Gateway);
    ConfigArray.Add(DNS1);
    ConfigArray.Add(DNS2);
  end
  else
  begin
    ConfigArray.Add('0');
  end;
  IpServer := IpServerCard;
  if IpServer = '' then
  begin
    MessageDlg('L''adresse du serveur ne doit pas être vide',
      TMsgDlgType.mtError, mbOKCancel, 0);
    raise Exception.create('Message d''erreur');
  end;
  ConfigArray.Add(IpServer);
  APIKey := EAppKey.Text;
  if APIKey = '' then
  begin
    MessageDlg('La clé ne doit pas être vide', TMsgDlgType.mtError,
      mbOKCancel, 0);
    raise Exception.create('Message d''erreur');
  end;
  ConfigArray.Add(APIKey);
  Period := EPeriod.Text;
  ConfigArray.Add(Period);
  CurrentTime := now;
  DateDay := FormatDateTime('dd', CurrentTime);
  DateMonth := FormatDateTime('mm', CurrentTime);
  DateYear := FormatDateTime('yyyy', CurrentTime);
  DateHour := FormatDateTime('hh', CurrentTime);
  DateMinute := FormatDateTime('nn', CurrentTime);
  ConfigArray.Add(DateYear);
  ConfigArray.Add(DateMonth);
  ConfigArray.Add(DateDay);
  ConfigArray.Add(DateHour);
  ConfigArray.Add(DateMinute);
  Result := ConfigArray;

end;

{ *
  * Configure values for comPort Protocol
  * }
procedure TFPpale.ConfigureComPort;
var
  PortName: String;
begin
  //
  PortName := CBPort.Items[CBPort.ItemIndex];
  try
    PortNumber := StrToInt(copy(PortName, PortName.Length, 1));
  except
    on Exception do
    begin
      PortNumber := -1;
    end;
  end;
  case CBBaudRate.ItemIndex of
    0:
      BaudRate := 4800;
    1:
      BaudRate := 9600;
    2:
      BaudRate := 19200;
  end;

  Parity := CBParity.ItemIndex;
  StopBit := CBStop.ItemIndex + 1;
  BitNumber := CBDatas.ItemIndex + 4;
end;

{ *
  * Validate IP Adress Format
  * }
function TFPpale.validIpAdress(adress: string): string;
var
  firstDigit, secondDigit, thirdDigit, fourthDigit: Integer;
begin
  try
    firstDigit := StrToInt(TrimRight(copy(adress, 0, 3)));
    secondDigit := StrToInt(TrimRight(copy(adress, 5, 3)));
    thirdDigit := StrToInt(TrimRight(copy(adress, 9, 3)));
    fourthDigit := StrToInt(TrimRight(copy(adress, 13, 3)));
    if ((firstDigit < 0) Or (firstDigit > 255) Or (secondDigit < 0) Or
      (secondDigit > 255) Or (thirdDigit < 0) Or (thirdDigit > 255) Or
      (fourthDigit < 0) Or (fourthDigit > 255)) then
    begin
      raise EArgumentException.create('Not a valid IP address.');
    end;
    progHasChanged := True;
    Result := IntToStr(firstDigit) + '.' + IntToStr(secondDigit) + '.' +
      IntToStr(thirdDigit) + '.' + IntToStr(fourthDigit);
  except
    raise EArgumentException.create('Not a valid IP address.');
  end;
end;

{ *
  * Enable IP Config Panel
  * }
procedure TFPpale.EnableNetWorkPanel(state: Boolean);
begin
  PNetwork.Enabled := not state;
  MEIpAdress.Enabled := not state;
  MESubnet.Enabled := not state;
  MEDns1.Enabled := not state;
  MEDns2.Enabled := not state;
  MEGateway.Enabled := not state;
  if state then
  begin
    PNetwork.Color := clInactiveCaption;
  end
  else
  begin
    PNetwork.Color := clBtnFace;
  end;
end;

procedure TFPpale.ESsidChange(Sender: TObject);
begin
  ProgHasChanged:=True;
end;

procedure TFPpale.EWifiPassChange(Sender: TObject);
begin
  ProgHasChanged:=true;
end;

{ *
  * Read board Programmation
  * }
procedure TFPpale.BReadProdClick(Sender: TObject);
var
  test: TSerialProtocol;
begin
  // For tests
  test := TSerialProtocol.create(self);
  if not test.isInit then
  begin
    test.init(5, 9600, 8, 2, 1);
  end;


end;

{ *
  * Store Datas for Comport
  * }
procedure TFPpale.BValidateParamClick(Sender: TObject);
begin
  StoreToRegistry();
  ConfigureComPort();
end;

{ *
  * Launch board Programmation
  * }
procedure TFPpale.BWriteProgClick(Sender: TObject);
var
  prog: TStringList;
  toto: String;
  i: Integer;
  protocol: TSerialProtocol;
  transfertResult : Boolean;
begin
  prog := TStringList.create;
  TransfertResult:= false;
  StoreToRegistry();
  protocol:=TSerialProtocol.create(self);
  try
    try
      prog := CreateProg();
      protocol.Init(PortNumber,baudRate,BitNumber,Parity,StopBit);
      transfertResult:=protocol.sendProgram(prog);
      if transfertResult then
      begin
         MessageDlg('La programmation c''est bien déroulée.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK],0);
      end
      else
      begin
        MessageDlg('Il y a eu une erreur lors de la programmation', TMsgDlgType.mtError,
          mbOKCancel, 0);
      end;
      //Remote
      toto := IntToStr(prog.Count);
      SBStatus.panels[0].Text := toto;
      Memo1.lines.Clear;
      for i := 0 to prog.Count - 1 do
      begin
        Memo1.lines.Add('step ' + IntToStr(i) + ' ' + prog[i]);
      end;
      //end remove
    except
      on E: Exception do
      begin
        MessageDlg('La configuration ne peut être créée', TMsgDlgType.mtWarning,
          mbOKCancel, 0);
      end;

    end;
  finally
    protocol.Destroy;
    prog.Free;
  end;
end;

{ *
  * Use DHCP or not
  * }
procedure TFPpale.CBDHCPClick(Sender: TObject);
begin
  EnableNetWorkPanel(CBDHCP.Checked);
  useDHCP := CBDHCP.Checked;
  progHasChanged := True;
end;

{ *
  * Start App
  * }
procedure TFPpale.FormCreate(Sender: TObject);
begin
  IPCard := '';
  SubNetCard := '';
  GatewayCard := '';
  DNS1Card := '';
  DNS2Card := '';
  IpServerCard := '';
  isValidate := False;
  serialHasChanged := False;
  progHasChanged := False;
  useDHCP := True;
  LoadComNumber();
  LoadFromRegistry();
  isValidate := CBPort.Items.Count > 0;
  BValidateParam.Enabled := isValidate;
  BReadProd.Enabled := isValidate;
  BWriteProg.Enabled := isValidate;
  mesureInterval := 1;
  EPeriod.Text := IntToStr(mesureInterval);
  CBDHCP.Checked := useDHCP;
  EnableNetWorkPanel(useDHCP);
  if isValidate then
  begin
    ConfigureComPort();
  end;
end;

procedure TFPpale.SpinButton1DownClick(Sender: TObject);
begin
  if mesureInterval > 1 then
  begin
    dec(mesureInterval);
    EPeriod.Text := IntToStr(mesureInterval);
  end;
end;

procedure TFPpale.SpinButton1UpClick(Sender: TObject);
begin
  if mesureInterval < 24 then
  begin
    inc(mesureInterval);
    EPeriod.Text := IntToStr(mesureInterval);
  end;
end;

procedure TFPpale.StoreToRegistry;
var
  reg: TRegistry;
  openResult: Boolean;
begin
  if (not serialHasChanged) and (not progHasChanged) then
    Exit;
  reg := TRegistry.create(KEY_WRITE);
  reg.RootKey := HKEY_CURRENT_USER;
  try
    openResult := reg.OpenKey(RegKey, True);
    if not openResult then
    begin
      MessageDlg('Sauvegarde impossible', TMsgDlgType.mtWarning, mbOKCancel, 0);
      Exit;
    end;
    if serialHasChanged then
    begin
      // Store Parity
      reg.WriteInteger('Parity', CBParity.ItemIndex);
      // Store BaudRate
      reg.WriteInteger('Baud', CBBaudRate.ItemIndex);
      // Store DataSize
      reg.WriteInteger('Datas', CBDatas.ItemIndex);
      // Store stop Bit
      reg.WriteInteger('Stop', CBStop.ItemIndex);
      serialHasChanged := False;
    end;
    if progHasChanged then
    begin
      // TODO: Add config infos, without Wifi pass
      reg.WriteString('SSID',ESsid.Text);
      reg.WriteBool('UseDHCP',CBDHCP.Checked);
      reg.WriteString('IP_Adress',MEIpAdress.Text);
      reg.WriteString('Subnet',MESubnet.Text);
      reg.WriteString('Gateway',MEGateway.Text);
      reg.WriteString('DNS1',MEDns1.Text);
      reg.WriteString('DNS2',MEDns2.Text);
      reg.WriteString('Server_IP',MEIpServer.Text);
      reg.WriteString('App_Key',EAppKey.Text);
      reg.WriteString('Period',EPeriod.Text);
      progHasChanged := False;
    end;
  finally
    reg.Free;
  end;

end;

procedure TFPpale.LoadFromRegistry;
var
  reg: TRegistry;
begin
  reg := TRegistry.create(KEY_READ);
  reg.RootKey := HKEY_CURRENT_USER;
  if reg.KeyExists(RegKey) then
  begin
    reg.OpenKey(RegKey, False);
    // Load Parity
    CBParity.ItemIndex := reg.ReadInteger('Parity');
    // Load BaudRate
    CBBaudRate.ItemIndex := reg.ReadInteger('Baud');
    // Load DataSize
    CBDatas.ItemIndex := reg.ReadInteger('Datas');
    // Load stop Bit
    CBStop.ItemIndex := reg.ReadInteger('Stop');
    //Reading infos  for Configuration
    ESsid.Text:=reg.ReadString('SSID');
    try
       CBDHCP.Checked:=reg.ReadBool('UseDHCP');
    except on Exception do
    begin
       CBDHCP.Checked:=true;
    end;
    end;
      MEIpAdress.Text:=reg.ReadString('IP_Adress');
      if not (MEIpAdress.Text ='') then
      begin
        IPCard:=validIpAdress(MEIpAdress.Text);
      end;
      MESubnet.Text:=reg.ReadString('Subnet');
      if not (MESubnet.Text='') then
      begin
        SubNetCard:=validIpAdress(MESubnet.Text);
      end;
      MEGateway.Text:=reg.ReadString('Gateway');
       if not (MEGateway.Text='') then
      begin
        GatewayCard:=validIpAdress(MEGateway.Text);
      end;
      MEDns1.Text:=reg.ReadString('DNS1');
       if not (MEDns1.Text='') then
      begin
        DNS1Card:=validIpAdress(MEDns1.Text);
      end;
      MEDns2.Text:=reg.ReadString('DNS2');
       if not (MEDns2.Text='') then
      begin
        DNS2Card:=validIpAdress(MEDns2.Text);
      end;
      MEIpServer.Text:=reg.ReadString('Server_IP');
       if not (MEIpServer.Text='') then
      begin
        IpServerCard:=validIpAdress(MEIpServer.Text);
      end;
      EAppKey.Text:=reg.ReadString('App_Key');
      EPeriod.Text:=reg.ReadString('Period');
  end;
  reg.Free;
end;

procedure TFPpale.MEDns1Exit(Sender: TObject);
begin
  try
    DNS1Card := validIpAdress(MEDns1.Text);
    ProgHasChanged:=true;
  except
    on E: EArgumentException do
    begin
      MessageDlg('L''adresse IP est invalide', TMsgDlgType.mtError,
        mbOKCancel, 0);
      MEDns1.Text := '';
    end;
  end;

end;

procedure TFPpale.MEDns2Exit(Sender: TObject);
begin
  try
    DNS2Card := validIpAdress(MEDns2.Text);
    ProgHasChanged:=true;
  except
    on E: EArgumentException do
    begin
      MessageDlg('L''adresse IP est invalide', TMsgDlgType.mtError,
        mbOKCancel, 0);
      MEDns2.Text := '';
    end;
  end;
end;

procedure TFPpale.MEGatewayExit(Sender: TObject);
begin
  try
    GatewayCard := validIpAdress(MEGateway.Text);
    ProgHasChanged:=true;
  except
    on E: EArgumentException do
    begin
      MessageDlg('L''adresse IP est invalide', TMsgDlgType.mtError,
        mbOKCancel, 0);
      MEGateway.Text := '';
    end;
  end;
end;

procedure TFPpale.MEIpAdressExit(Sender: TObject);
begin
  try
    IPCard := validIpAdress(MEIpAdress.Text);
    ProgHasChanged:=true;
  except
    on E: EArgumentException do
    begin
      MessageDlg('L''adresse IP est invalide', TMsgDlgType.mtError,
        mbOKCancel, 0);
      MEIpAdress.Text := '';
    end;
  end;

end;

procedure TFPpale.MEIpServerExit(Sender: TObject);
begin
  try
    IpServerCard := validIpAdress(MEIpServer.Text);
    ProgHasChanged:=true;
  except
    on E: EArgumentException do
    begin
      MessageDlg('L''adresse IP est invalide', TMsgDlgType.mtError,
        mbOKCancel, 0);
      MEIpServer.Text := '';
    end;
  end;

end;

procedure TFPpale.MESubnetExit(Sender: TObject);
begin
  try
    SubNetCard := validIpAdress(MEIpAdress.Text);
    ProgHasChanged:=true;
  except
    on E: EArgumentException do
    begin
      MessageDlg('Le masque est invalide', TMsgDlgType.mtError,
        mbOKCancel, 0);
      MESubnet.Text := '';
    end;
  end;
end;

procedure TFPpale.LoadComNumber;
var
  reg: TRegistry;
  openResult: Boolean;
  arrayKeys: TStringList;
  i: Integer;
begin
  reg := TRegistry.create(KEY_READ);
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if (not reg.KeyExists('HARDWARE\DEVICEMAP\SERIALCOMM\')) then
  begin
    MessageDlg('Key not found', TMsgDlgType.mtWarning, mbOKCancel, 0);
  end;
  openResult := reg.OpenKey('HARDWARE\DEVICEMAP\SERIALCOMM\', False);
  if (not openResult) then
  begin
    MessageDlg('Key not found', TMsgDlgType.mtWarning, mbOKCancel, 0);
  end;
  arrayKeys := TStringList.create();
  try

    reg.GetValueNames(arrayKeys);
    for i := 0 to Pred(arrayKeys.Count) do
    begin
      if (AnsiContainsText(arrayKeys[i], 'USB')) then
      begin
        CBPort.Items.Add(reg.ReadString(arrayKeys[i]));
      end;
    end;
  finally

    if (CBPort.Items.Count = 0) then
    begin
      CBPort.Text := 'Coffret non trouvé';
    end
    else
    begin
      CBPort.ItemIndex := 0;
    end;
    arrayKeys.Free;
    reg.Free;
  end;

end;

end.
