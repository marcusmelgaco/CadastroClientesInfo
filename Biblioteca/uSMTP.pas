unit uSMTP;

interface
uses IdSMTP, IdSSLOpenSSL, IdMessage, IdText, IdAttachmentFile,
  IdExplicitTLSClientServerBase,Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,Dialogs,Forms;

function EnviaEmail(Assunto:String;Destinatario:String;AnexoXML:String;Dados: TStringList):Boolean;
implementation
function EnviaEmail(Assunto:String;Destinatario:String;AnexoXML:String;Dados: TStringList):Boolean;
var
  // vari�veis e objetos necess�rios para o envio
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
  sAnexo: string;
begin
  // instancia��o dos objetos
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(Application);
  IdSMTP := TIdSMTP.Create(Application);
  IdMessage := TIdMessage.Create(Application);

  try
    // Configura��o do protocolo SSL (TIdSSLIOHandlerSocketOpenSSL)
    IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

    // Configura��o do servidor SMTP (TIdSMTP)
    IdSMTP.IOHandler := IdSSLIOHandlerSocket;
    IdSMTP.UseTLS := utUseImplicitTLS;
    IdSMTP.AuthType := satDefault;
    IdSMTP.Port := 465;
    IdSMTP.Host := 'smtp.gmail.com';
    IdSMTP.Username := 'cadastroinfosistemas@gmail.com';
    IdSMTP.Password := 'marcus159';

    // Configura��o da mensagem (TIdMessage)
    IdMessage.From.Address := 'cadastroinfosistemas@gmail.com';
    IdMessage.From.Name := 'Cadastro InfoSistemas - Marcus Melga�o';
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text := Destinatario;
    IdMessage.Subject := Assunto;
    IdMessage.Encoding := meMIME;

    // Configura��o do corpo do email (TIdText)
    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add('Ol�, esta � uma mensagem Autom�tica, portanto n�o � necess�rio responder!');
    IdText.Body.Add('Seguem os Dados Do Novo Cliente Cadastrado:');
    IdText.Body.Add('');
    IdText.Body.Add('*NOME: '+Dados[0]);
    IdText.Body.Add('*IDENTIDADE: '+Dados[1]);
    IdText.Body.Add('*CPF: '+Dados[2]);
    IdText.Body.Add('*TELEFONE: '+Dados[3]);
    IdText.Body.Add('*EMAIL: '+Dados[4]);
    IdText.Body.Add(' �ENDERE�O');
    IdText.Body.Add('   *CEP: '+Dados[5]);
    IdText.Body.Add('   *LOGRADOURO: '+Dados[6]);
    IdText.Body.Add('   *NUMERO: '+Dados[7]);
    IdText.Body.Add('   *COMPLEMENTO: '+Dados[8]);
    IdText.Body.Add('   *BAIRRO: '+Dados[9]);
    IdText.Body.Add('   *CIDADE: '+Dados[10]);
    IdText.Body.Add('   *ESTADO: '+Dados[11]);
    IdText.Body.Add('   *PAIS: '+Dados[12]);
    IdText.Body.Add('');
    IdText.Body.Add('Em Anexo, Se Encontra o XML Com os Dados do Cliente.');
    IdText.Body.Add('');
    IdText.Body.Add('|-| Cadastro de Clientes InfoSistemas - Marcus Melga�o |-|');

    IdText.ContentType := 'text/plain; charset=iso-8859-1';

    // Opcional - Anexo da mensagem (TIdAttachmentFile)
    sAnexo := AnexoXML;
    if FileExists(sAnexo) then
    begin
      TIdAttachmentFile.Create(IdMessage.MessageParts, sAnexo);
    end;

    // Conex�o e autentica��o
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        MessageDlg('Erro na conex�o ou autentica��o: ' +
          E.Message, mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    // Envio da mensagem
    try
      IdSMTP.Send(IdMessage);
      MessageDlg('Mensagem enviada com sucesso!', mtInformation, [mbOK], 0);
      Result:= True;
    except
      On E:Exception do
      begin
        MessageDlg('Erro ao enviar a mensagem: ' +
          E.Message, mtWarning, [mbOK], 0);
          Result:= False;
      end;
    end;
  finally
    // desconecta do servidor
    IdSMTP.Disconnect;
    // libera��o da DLL
    UnLoadOpenSSLLibrary;
    // libera��o dos objetos da mem�ria
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
    FreeAndNil(Dados);
  end;
end;
end.
