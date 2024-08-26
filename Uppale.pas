unit Uppale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Win.Registry, StrUtils;

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
    procedure LoadComNumber();
    procedure LoadFromRegistry();
    procedure StoreToRegistry();
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FPpale: TFPpale;

implementation

{$R *.dfm}

procedure TFPpale.FormCreate(Sender: TObject);
begin
  LoadComNumber();
  LoadFromRegistry();
end;

procedure TFPpale.StoreToRegistry;
var
  reg: TRegistry;
  openResult: Boolean;
begin
         //Store Parity

      //Store BaudRate

      //Store DataSize

      //Store stop Bit
end;

procedure TFPpale.LoadFromRegistry;
var
  reg: TRegistry;
  openResult: Boolean;
begin
      //Load Parity

      //Load BaudRate

      //Load DataSize

      //Load stop Bit
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
  openResult := reg.OpenKey('HARDWARE\DEVICEMAP\SERIALCOMM\', False);
  if (not openResult) then
  begin
    MessageDlg('Key not found', TMsgDlgType.mtWarning, mbOKCancel, 0);
  end;
  try
    arrayKeys := TStringList.create();
    reg.GetValueNames(arrayKeys);
    for i := 0 to Pred(arrayKeys.Count) do
    begin
      if (AnsiContainsText(arrayKeys[i], 'USB')) then
      begin
        CBPort.items.Add(reg.ReadString(arrayKeys[i]));
      end;
    end;
  finally
    arrayKeys.Free;
    if (CBPort.items.Count = 0) then
    begin
      CBPort.Text := 'Coffret non trouvé';
    end;
  end;

end;

end.
