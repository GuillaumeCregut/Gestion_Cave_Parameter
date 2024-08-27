unit Uppale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Win.Registry, StrUtils, System.UITypes;

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
    procedure LoadComNumber();
    procedure LoadFromRegistry();
    procedure StoreToRegistry();
    procedure FormCreate(Sender: TObject);
    procedure BValidateParamClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  const
    RegKey = 'Software\Editiel98\CellarManager\';
  private
    { Déclarations privées }
    isValidate: Boolean;

  public
    { Déclarations publiques }
  end;

var
  FPpale: TFPpale;

implementation

{$R *.dfm}

procedure TFPpale.BValidateParamClick(Sender: TObject);
begin
  StoreToRegistry();
  // Configure comport
end;

procedure TFPpale.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StoreToRegistry();
end;

procedure TFPpale.FormCreate(Sender: TObject);
begin
  isValidate := false;
  LoadComNumber();
  LoadFromRegistry();
  isValidate := CBPort.Items.Count > 0;
  BValidateParam.Enabled := isValidate;
end;

procedure TFPpale.StoreToRegistry;
var
  reg: TRegistry;
  openResult: Boolean;
begin
  reg := TRegistry.create(KEY_WRITE);
  reg.RootKey := HKEY_CURRENT_USER;
  try
    openResult := reg.OpenKey(RegKey, True);
    if not openResult then
    begin
      MessageDlg('Sauvegarde impossible', TMsgDlgType.mtWarning, mbOKCancel, 0);
      Exit;
    end;
    // Store Parity
    reg.WriteInteger('Parity', CBParity.ItemIndex);
    // Store BaudRate
    reg.WriteInteger('Baud', CBBaudRate.ItemIndex);
    // Store DataSize
    reg.WriteInteger('Datas', CBDatas.ItemIndex);
    // Store stop Bit
    reg.WriteInteger('Stop', CBStop.ItemIndex);
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
    reg.OpenKey(RegKey, false);
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

procedure TFPpale.LoadComNumber;
var
  reg: TRegistry;
  openResult: Boolean;
  arrayKeys: TStringList;
  i: integer;
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
