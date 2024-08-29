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
    procedure FillProg(SSID: String; WifiKey: String; DHCP: Boolean;
      IPAdress: String; Subnet: String; Gateway: String; DNS1: String;
      DNS2: String; IPServer: String; AppKey: String; Period: String);

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

function TFPpale.CreateProg(): TStringList;
var
  IPAdress, SubnetMask, DNS1, DNS2, Gateway, SSID, PassWifi, APIKey, IPServer,
    Period, DateDay, DateMonth, DateYear, DateHour, DateMinute: String;
  CurrentTime: TDateTime;
  ConfigArray: TStringList;

begin
  ConfigArray := TStringList.create();
  IPAdress := '';
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
    IPAdress := IPCard;
    SubnetMask := SubNetCard;
    DNS1 := DNS1Card;
    Gateway := GatewayCard;
    DNS2 := DNS2Card;
    if ((IPAdress = '') Or (SubnetMask = '') Or (Gateway = '') or (DNS1 = '') or
      (DNS2 = '')) then
    begin
      MessageDlg
        ('Si vous décochez la case DHCP, tous les champs doivent être remplis',
        TMsgDlgType.mtError, mbOKCancel, 0);
      raise Exception.create('Message d''erreur');
    end;
    ConfigArray.Add('1');
    ConfigArray.Add(IPAdress);
    ConfigArray.Add(SubnetMask);
    ConfigArray.Add(Gateway);
    ConfigArray.Add(DNS1);
    ConfigArray.Add(DNS2);
  end
  else
  begin
    ConfigArray.Add('0');
  end;
  IPServer := IpServerCard;
  if IPServer = '' then
  begin
    MessageDlg('L''adresse du serveur ne doit pas être vide',
      TMsgDlgType.mtError, mbOKCancel, 0);
    raise Exception.create('Message d''erreur');
  end;
  ConfigArray.Add(IPServer);
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
  progHasChanged := True;
end;

procedure TFPpale.EWifiPassChange(Sender: TObject);
begin
  progHasChanged := True;
end;

procedure TFPpale.FillProg(SSID: String; WifiKey: String; DHCP: Boolean;
  IPAdress: String; Subnet: String; Gateway: String; DNS1: String; DNS2: String;
  IPServer: String; AppKey: String; Period: String);
begin
  ESsid.Text := SSID;
  CBDHCP.Checked := DHCP;
  MEIpAdress.Text := IPAdress;
  if not(IPAdress = '') then
  begin
    IPCard := validIpAdress(IPAdress);
  end;
  MESubnet.Text := Subnet;
  if not(Subnet = '') then
  begin
    SubNetCard := validIpAdress(Subnet);
  end;
  MEGateway.Text := Gateway;
  if not(Gateway = '') then
  begin
    GatewayCard := validIpAdress(Gateway);
  end;
  MEDns1.Text := DNS1;
  if not(DNS1 = '') then
  begin
    DNS1Card := validIpAdress(DNS1);
  end;
  MEDns2.Text := DNS2;
  if not(DNS2 = '') then
  begin
    DNS2Card := validIpAdress(DNS2);
  end;
  MEIpServer.Text := IPServer;
  if not(IPServer = '') then
  begin
    IpServerCard := validIpAdress(IPServer);
  end;
  EAppKey.Text := AppKey;
  EPeriod.Text := Period;
end;

{ *
  * Read board Programmation
  * }
procedure TFPpale.BReadProdClick(Sender: TObject);
var
  serialProtocol: TSerialProtocol;
  BoardConfig: TStringList;
  rSSID, rIpAdress, rSubnet, rGateway, rDNS1, rDNS2, rIPServer, rAppKey,
    rPeriod, rWifiKey: String;
  rDHCP: Boolean;
begin
  rSSID := '';
  rIpAdress := '';
  rSubnet := '';
  rGateway := '';
  rDNS1 := '';
  rDNS2 := '';
  rIPServer := '';
  rAppKey := '';
  rPeriod := '';
  rWifiKey := '';
  rDHCP := True;
  serialProtocol := TSerialProtocol.create(self);
  BoardConfig := TStringList.create;
  if not serialProtocol.isInit then
  begin
    serialProtocol.init(PortNumber, BaudRate, BitNumber, Parity, StopBit);
  end;
  try
    // Open protocole and read datas
    BoardConfig := serialProtocol.ReadBoard;
    // TODO: Implements
    // Store Data in app
    { (   IPAdress: String; Subnet: String; Gateway: String; DNS1: String; DNS2: String;
      IPServer: String; AppKey: String; Period: String); }
    FillProg(rSSID, rWifiKey, rDHCP, rIpAdress, rSubnet, rGateway, rDNS1, rDNS2,
      rIPServer, rAppKey, rPeriod);
  except
    on Exception do
    begin
      MessageDlg('Il y a eu une erreur lors de la lecture de la programmation',
        TMsgDlgType.mtError, mbOKCancel, 0);
    end;

  end;
  serialProtocol.Free;
  BoardConfig.Free;
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
  transfertResult: Boolean;
begin
  prog := TStringList.create;
  transfertResult := false;
  StoreToRegistry();
  protocol := TSerialProtocol.create(self);
  try
    try
      prog := CreateProg();
      protocol.init(PortNumber, BaudRate, BitNumber, Parity, StopBit);
      transfertResult := protocol.sendProgram(prog);
      if transfertResult then
      begin
        MessageDlg('La programmation c''est bien déroulée.',
          TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
      end
      else
      begin
        MessageDlg('Il y a eu une erreur lors de la programmation',
          TMsgDlgType.mtError, mbOKCancel, 0);
      end;
      // Remote
      toto := IntToStr(prog.Count);
      SBStatus.panels[0].Text := toto;
      Memo1.lines.Clear;
      for i := 0 to prog.Count - 1 do
      begin
        Memo1.lines.Add('step ' + IntToStr(i) + ' ' + prog[i]);
      end;
      // end remove
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
  isValidate := false;
  serialHasChanged := false;
  progHasChanged := false;
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
      serialHasChanged := false;
    end;
    if progHasChanged then
    begin
      reg.WriteString('SSID', ESsid.Text);
      reg.WriteBool('UseDHCP', CBDHCP.Checked);
      reg.WriteString('IP_Adress', MEIpAdress.Text);
      reg.WriteString('Subnet', MESubnet.Text);
      reg.WriteString('Gateway', MEGateway.Text);
      reg.WriteString('DNS1', MEDns1.Text);
      reg.WriteString('DNS2', MEDns2.Text);
      reg.WriteString('Server_IP', MEIpServer.Text);
      reg.WriteString('App_Key', EAppKey.Text);
      reg.WriteString('Period', EPeriod.Text);
      progHasChanged := false;
    end;
  finally
    reg.Free;
  end;

end;

procedure TFPpale.LoadFromRegistry;
var
  reg: TRegistry;
  rSSID, rIpAdress, rSubnet, rGateway, rDNS1, rDNS2, rIPServer, rAppKey,
    rPeriod: String;
  rDHCP: Boolean;
begin
  reg := TRegistry.create(KEY_READ);
  reg.RootKey := HKEY_CURRENT_USER;
  if reg.KeyExists(RegKey) then
  begin
    reg.OpenKey(RegKey, false);
    // Load Parity
    CBParity.ItemIndex := reg.ReadInteger('Parity');
    // Load BaudRate
    CBBaudRate.ItemIndex := reg.ReadInteger('Baud');
    // Load DataSize
    CBDatas.ItemIndex := reg.ReadInteger('Datas');
    // Load stop Bit
    CBStop.ItemIndex := reg.ReadInteger('Stop');
    // Reading infos  for Configuration
    rSSID := reg.ReadString('SSID');
    try
      rDHCP := reg.ReadBool('UseDHCP');
    except
      on Exception do
      begin
        rDHCP := True;
      end;
    end;
    rIpAdress := reg.ReadString('IP_Adress');
    rSubnet := reg.ReadString('Subnet');
    rGateway := reg.ReadString('Gateway');
    rDNS1 := reg.ReadString('DNS1');
    rDNS2 := reg.ReadString('DNS2');
    rIPServer := reg.ReadString('Server_IP');
    rAppKey := reg.ReadString('App_Key');
    rPeriod := reg.ReadString('Period');
    FillProg(rSSID, '', rDHCP, rIpAdress, rSubnet, rGateway, rDNS1, rDNS2,
      rIPServer, rAppKey, rPeriod);
  end;
  reg.Free;
end;

procedure TFPpale.MEDns1Exit(Sender: TObject);
begin
  try
    DNS1Card := validIpAdress(MEDns1.Text);
    progHasChanged := True;
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
    progHasChanged := True;
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
    progHasChanged := True;
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
    progHasChanged := True;
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
    progHasChanged := True;
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
    progHasChanged := True;
  except
    on E: EArgumentException do
    begin
      MessageDlg('Le masque est invalide', TMsgDlgType.mtError, mbOKCancel, 0);
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
  openResult := reg.OpenKey('HARDWARE\DEVICEMAP\SERIALCOMM\', false);
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
