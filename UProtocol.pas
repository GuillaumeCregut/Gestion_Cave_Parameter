unit UProtocol;

interface
uses
System.SysUtils, System.Classes, OoMisc, AdPort,Forms,Vcl.ExtCtrls, Vcl.Dialogs;

type
TSerialProtocol =class (TComponent)

private
   comPort: TApdComPort;
   ACKReceived : Boolean;
   procedure sendToBoard(data : String);
   procedure OnReceiveData(CP: TObject; Count: Word);
   procedure TimeOut(Sender: TObject);
protected

public
  isInit : Boolean;
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;

   function sendProgram(datas: TStringList): boolean;
   procedure Init(Port: Integer; Baud: Integer;Datas: Integer; Parity :Integer;Stop: Integer);
end;


implementation

constructor TSerialProtocol.Create;
begin
   inherited Create(AOwner);
   comPort:= TApdComPort.create(Aowner);
   comPort.OnTriggerAvail:=OnReceiveData;
   isInit:= false;
   comPort.AutoOpen:= false;
end;


destructor TSerialProtocol.Destroy;
begin
  comPort.Free;
  inherited;
end;

procedure TSerialProtocol.Init(Port: Integer; Baud: Integer; Datas: Integer;Parity :Integer;Stop: Integer);
begin
    if not comPort.Open then
    begin
      comPort.ComNumber:=Port;
      comPort.DataBits:=Datas;
      comPort.StopBits:=Stop;
      comPort.Baud:=Baud;
      case Parity of
         0 : comPort.Parity:=pEven;
         1 : comPort.Parity:=pOdd;
         2 : comPort.Parity:=pNone;
      end;
      isInit:=true;
    end;
end;

procedure TSerialProtocol.sendToBoard(data: String);
var
  WatchDog: TTimer;
begin
  //Do something
  WatchDog:= TTImer.Create(self);
  WatchDog.Interval:=1000;
  WatchDog.OnTimer:=TimeOut;
  ACKReceived:= false;
  comPort.Open:=true;
    comPort.Output:= data;
    while not ACKReceived do
    begin
       Application.ProcessMessages;
    end;
    comPort.Open:=false;
end;

function TSerialProtocol.sendProgram(datas: TStringList): Boolean;
begin
showMessage('MEthode appelée');
   if not isInit then
  begin
     Result:= false;
     Exit;
  end;
  try

  except on Exception  do
  begin
    Result:= false;
  end;

  end;
end;

procedure TSerialProtocol.OnReceiveData(CP: TObject; Count: Word);
begin
  //
  ACKReceived:=true;
end;

procedure TSerialProtocol.TimeOut(Sender: TObject);
begin
  raise Exception.Create('Time Out');
end;

end.
