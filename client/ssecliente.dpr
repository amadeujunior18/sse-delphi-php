program ssecliente;
{$APPTYPE CONSOLE}
uses
  System.SysUtils,
  IdHTTP,
  IdSSLOpenSSL,
  IdGlobal;

type
  TIndySSEClient = class
  private
    IdHTTP: TIdHTTP;
    SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
    EventStream: TIdEventStream;
    procedure MyOnWrite(const ABuffer: TIdBytes; AOffset, ACount: Longint; var VResult: Longint);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect(const AURL: string);
  end;

constructor TIndySSEClient.Create;
begin
  inherited Create;

  EventStream := TIdEventStream.Create;
  EventStream.OnWrite := MyOnWrite;

  // Configurar SSL Handler
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSLHandler.SSLOptions.Method := sslvTLSv1_2;  // TLS 1.2
  SSLHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];  // TLS 1.2 e 1.3
  SSLHandler.SSLOptions.Mode := sslmClient;
  SSLHandler.SSLOptions.VerifyMode := [];  // Não verificar certificado (use com cuidado!)
  SSLHandler.SSLOptions.VerifyDepth := 0;

  // Configurar HTTP Client
  IdHTTP := TIdHTTP.Create(nil);
  IdHTTP.IOHandler := SSLHandler;  // Atribuir o SSL Handler
  IdHTTP.Request.Accept := 'text/event-stream';
  IdHTTP.Request.CacheControl := 'no-store';
  IdHTTP.HandleRedirects := True;
  IdHTTP.Request.UserAgent := 'Mozilla/5.0 (compatible; IndySSEClient/1.0)';
end;

procedure TIndySSEClient.MyOnWrite(const ABuffer: TIdBytes; AOffset, ACount: Longint; var VResult: Longint);
var
  EventData: string;
begin
  EventData := IndyTextEncoding_UTF8.GetString(ABuffer, AOffset, ACount);
  WriteLn('==========================================');
  WriteLn('Evento recebido (' + IntToStr(ACount) + ' bytes):');
  WriteLn(EventData);
  WriteLn('==========================================');

  VResult := ACount;
end;

procedure TIndySSEClient.Connect(const AURL: string);
begin
  try
    WriteLn('Conectando a: ' + AURL);
    IdHTTP.Get(AURL, EventStream);
  except
    on E: Exception do
      WriteLn('Erro ao conectar: ' + E.Message);
  end;
end;

destructor TIndySSEClient.Destroy;
begin
  EventStream.Free;
  IdHTTP.Free;
  SSLHandler.Free;
  inherited;
end;

var
  Client: TIndySSEClient;
begin
  try
    Client := TIndySSEClient.Create;
    try
      // Conectar ao servidor SSE (funciona com HTTP e HTTPS)
      Client.Connect('http://localhost/sse.php');

      WriteLn('Pressione ENTER para sair');
      ReadLn;
    finally
      Client.Free;
    end;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end.
