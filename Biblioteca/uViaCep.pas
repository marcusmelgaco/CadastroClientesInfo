unit uViaCep;

interface

uses idHTTP, IdSSLOpenSSL, JSON, System.Classes, SysUtils,Dialogs;

function buscaCep(CEP: String; HTTP: TIdHttp): TJsonObject;
function ValidaCep(CEP: string): Boolean;

implementation

function ValidaCep(CEP: string): Boolean;
const
  INVALID_CHARACTER = -1;
begin
  Result := True;
  if CEP.Trim.Length <> 8 then
    Exit(False);
  if StrToIntDef(CEP, INVALID_CHARACTER) = INVALID_CHARACTER then
    Exit(False);
end;

function buscaCep(CEP: string; HTTP: TIdHttp): TJsonObject;
var
  IDSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  Response: TStringStream;
  LJsonObj: TJsonObject;
begin
  if ValidaCep(CEP) = True then
  begin
    try
      HTTP := TIdHttp.Create;
      IDSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
      HTTP.IOHandler := IDSSLHandler;
      Response := TStringStream.Create;
      HTTP.Get('http://viacep.com.br/ws/' +CEP+ '/json/', Response);
      if (HTTP.ResponseCode = 200) and
        (not(Utf8ToAnsi(Response.DataString) = '{'#$A'  "erro": true'#$A'}')) then
        Result := TJsonObject.ParseJSONValue
          (TEncoding.ASCII.GetBytes(Utf8ToAnsi(Response.DataString)), 0)
          as TJsonObject
      else
      begin
      ShowMessage('Cep Nao Encontrado!');
      Result := Nil;
      end;
    finally
      FreeAndNil(HTTP);
      FreeAndNil(IDSSLHandler);
      Response.Destroy;
    end;
  end;
end;

end.
