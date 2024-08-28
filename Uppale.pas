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
    procedure MEGatewayChange(Sender: TObject);
    procedure MEDns1Change(Sender: TObject);
    procedure MEDns2Change(Sender: TObject);
    function CreateProg(): TStringList;
    procedure MEIpServerExit(Sender: TObject);
    procedure BWriteProgClick(Sender: TObject);

  const
    RegKey = 'Software\Editiel98\CellarManager\';
  private
    { Déclarations privées }
    isValidate: Boolean;
    mesureInterval: Integer;
    useDHCP: Boolean;
    serialHasChanged: Boolean;
    progHasChanged: Boolean;
    IPCard : String;
    SubNetCard: String;
    GatewayCard: String;
    DNS1Card: String;
    DNS2Card: String;
    IpServerCard : String;
  public
    { Déclarations publiques }
  end;

var
  FPpale: TFPpale;

implementation

{$R *.dfm}
//TODO: Change ProgHasChanged for wifi and params when values changes
function TFPpale.CreateProg(): TStringList;
var
  IpAdress, SubnetMask, DNS1, DNS2, Gateway, SSID, PassWifi, APIKey,
    IpServer, Period, DateDay, DateMonth,DateYear, DateHour,DateMinute: String;
  CurrentTime: TDateTime;
  ConfigArray: TStringList;

begin
  ConfigArray:= TStringList.create();
  IpAdress := '';
  SubnetMask := '';
  DNS1 := '';
  Gateway := '';
  DNS2 := '';
  SSID:=ESsid.Text;
  if SSID='' then
  begin
    MessageDlg('Le wifi ne doit pas être vide', TMsgDlgType.mtError,
      mbOKCancel, 0);
      raise Exception.Create('Message d''erreur');
  end;
  PassWifi:= EWifiPass.Text;
  if PassWifi='' then
  begin
    MessageDlg('Le mot de passe wifi ne doit pas être vide', TMsgDlgType.mtError,
      mbOKCancel, 0);
      raise Exception.Create('Message d''erreur');
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
    if((IpAdress='') Or (SubnetMask='') Or(Gateway='') or (DNS1='') or(DNS2='')) then
    begin
      MessageDlg('Si vous décochez la cse DHCP, tous les champs doivent être remplis', TMsgDlgType.mtError,
      mbOKCancel, 0);
      raise Exception.Create('Message d''erreur');
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
    IpServer:= IpServerCard;
    if IpServer='' then
    begin
       MessageDlg('L''adresse du serveur ne doit pas être vide', TMsgDlgType.mtError,
      mbOKCancel, 0);
      raise Exception.Create('Message d''erreur');
    end;
    ConfigArray.Add(IpServer);
    APIKey:=EAppKey.Text;
    if APIKey='' then
    begin
       MessageDlg('La clé ne doit pas être vide', TMsgDlgType.mtError,
      mbOKCancel, 0);
      raise Exception.Create('Message d''erreur');
    end;
    ConfigArray.Add(APIKey);
    Period:= EPeriod.Text;
    ConfigArray.Add(Period);
    CurrentTime:= now;
    DateDay:= FormatDateTime('dd',CurrentTime);
    DateMonth := FormatDateTime('mm',CurrentTime);
    DateYear := FormatDateTime('yyyy',CurrentTime);
    DateHour:= FormatDateTime('hh',CurrentTime);
    DateMinute:= FormatDateTime('nn',CurrentTime);
    ConfigArray.Add(DateYear);
    ConfigArray.Add(DateMonth);
    ConfigArray.Add(DateDay);
    ConfigArray.Add(DateHour);
    ConfigArray.Add(DateMinute);
    Result:= ConfigArray;

end;

procedure TFPpale.ConfigureComPort;
begin
  // TODO: Configure COM port with datas
end;

function TFPpale.validIpAdress(adress: string): string;
var
  firstDigit, secondDigit, thirdDigit, fourthDigit: Integer;
begin
try
  firstDigit := StrToInt(TrimRight(Copy(adress, 0, 3)));
  secondDigit := StrToInt(TrimRight(Copy(adress, 5, 3)));
  thirdDigit := StrToInt(TrimRight(Copy(adress, 9, 3)));
  fourthDigit := StrToInt(TrimRight(Copy(adress, 13, 3)));
  if ((firstDigit < 0) Or (firstDigit > 255) Or (secondDigit < 0) Or
    (secondDigit > 255) Or (thirdDigit < 0) Or (thirdDigit > 255) Or
    (fourthDigit < 0) Or (fourthDigit > 255)) then
  begin
    raise EArgumentException.Create('Not a valid IP address.');
  end;
  progHasChanged := True;
  Result := IntToStr(firstDigit)+'.'+IntToStr(secondDigit)+'.'+IntToStr(thirdDigit)+'.'+IntToStr(fourthDigit);
except
  raise EArgumentException.Create('Not a valid IP address.');
end;
end;

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

procedure TFPpale.BValidateParamClick(Sender: TObject);
begin
  StoreToRegistry();
  ConfigureComPort();
end;

procedure TFPpale.BWriteProgClick(Sender: TObject);
var
  prog: TStringList;
  toto: String;
  i: Integer;
begin
  prog:= TStringList.Create;
  StoreToRegistry();
  try
  try
    prog:= CreateProg();
   toto:=IntToStr(prog.Count);
   SBStatus.panels[0].Text:=toto;
   Memo1.lines.Clear;
   for i:=0 to prog.Count-1 do
   begin
     Memo1.Lines.Add('step '+IntToStr(i)+' '+prog[i]);
   end;
  except on E: Exception do
  begin
    MessageDlg('La configuration ne peut être créée', TMsgDlgType.mtWarning, mbOKCancel, 0);
  end;

  end;
  finally

  end;
  // prepare datas for protocol
  
end;

procedure TFPpale.CBDHCPClick(Sender: TObject);
begin
  EnableNetWorkPanel(CBDHCP.Checked);
  useDHCP := CBDHCP.Checked;
  progHasChanged:=True;
end;

procedure TFPpale.FormCreate(Sender: TObject);
begin
 IPCard :='';
    SubNetCard:='';
    GatewayCard:='';
    DNS1Card:='';
    DNS2Card:='';
    IpServerCard:='';
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
  end;
  reg.Free;
end;

procedure TFPpale.MEDns1Change(Sender: TObject);
begin
try
  DNS1Card := validIpAdress(MEDns1.Text);
except
   on E: EArgumentException do
   begin
      MessageDlg('L''adresse IP est invalide', TMsgDlgType.mtError,
      mbOKCancel, 0);
      MEDns1.Text:='';
   end;
end;

end;

procedure TFPpale.MEDns2Change(Sender: TObject);
begin
  try
     DNS2Card := validIpAdress(MEDns2.Text);
  except
    on E: EArgumentException do
    begin
       MessageDlg('L''adresse IP est invalide', TMsgDlgType.mtError,
      mbOKCancel, 0);
      MEDns2.Text:='';
    end;
  end;
end;

procedure TFPpale.MEGatewayChange(Sender: TObject);
begin
try
  GatewayCard := validIpAdress(MEGateway.Text);
   except
    on E: EArgumentException do
    begin
       MessageDlg('L''adresse IP est invalide', TMsgDlgType.mtError,
      mbOKCancel, 0);
      MEGateway.Text:='';
    end;
  end;
end;

procedure TFPpale.MEIpAdressExit(Sender: TObject);
begin
try
  IPCard := validIpAdress(MEIpAdress.Text);
   except
    on E: EArgumentException do
    begin
       MessageDlg('L''adresse IP est invalide', TMsgDlgType.mtError,
      mbOKCancel, 0);
      MEIpAdress.Text:='';
    end;
  end;

end;

procedure TFPpale.MEIpServerExit(Sender: TObject);
begin
try
  IpServerCard := validIpAdress(MEIpServer.Text);
  except
    on E: EArgumentException do
    begin
       MessageDlg('L''adresse IP est invalide', TMsgDlgType.mtError,
      mbOKCancel, 0);
      MEIpServer.Text:='';
    end;
  end;

end;

procedure TFPpale.MESubnetExit(Sender: TObject);
begin
try
  SubNetCard := validIpAdress(MEIpAdress.Text);
   except
    on E: EArgumentException do
    begin
       MessageDlg('L''adresse IP est invalide', TMsgDlgType.mtError,
      mbOKCancel, 0);
      MESubnet.Text:='';
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
