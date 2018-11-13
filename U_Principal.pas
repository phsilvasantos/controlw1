unit U_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, StdCtrls, Buttons,
  ACBrBase, ACBrSocket, ACBrConsultaCNPJ, Mask;

{$IFDEF CONDITIONALEXPRESSIONS}
   {$IF CompilerVersion >= 20.0}
     {$DEFINE DELPHI2009_UP}
   {$IFEND}
{$ENDIF}

type
  TF_Principal = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EditTipo: TEdit;
    EditRazaoSocial: TEdit;
    EditAbertura: TEdit;
    EditEndereco: TEdit;
    EditNumero: TEdit;
    EditComplemento: TEdit;
    EditBairro: TEdit;
    EditCidade: TEdit;
    EditUF: TEdit;
    EditCEP: TEdit;
    EditSituacao: TEdit;
    Panel1: TPanel;
    Label1: TLabel;
    ButBuscar: TBitBtn;
    EditCaptcha: TEdit;
    Label14: TLabel;
    Timer1: TTimer;
    EditFantasia: TEdit;
    Label13: TLabel;
    ACBrConsultaCNPJ1: TACBrConsultaCNPJ;
    EditCNPJ: TMaskEdit;
    Panel3: TPanel;
    Image1: TImage;
    LabAtualizarCaptcha: TLabel;
    ckRemoverEspacosDuplos: TCheckBox;
    ListCNAE2: TListBox;
    Label15: TLabel;
    EditCNAE1: TEdit;
    Label16: TLabel;
    EditEmail: TEdit;
    Label17: TLabel;
    EditTelefone: TEdit;
    Label18: TLabel;
    procedure LabAtualizarCaptchaClick(Sender: TObject);
    procedure ButBuscarClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditCaptchaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Principal: TF_Principal;

implementation

uses
  JPEG
{$IFDEF DELPHI2009_UP}
  , pngimage
{$ENDIF}
  , Unit1;


{$R *.dfm}

procedure TF_Principal.ButBuscarClick(Sender: TObject);
var
  I: Integer;
begin
  if EditCaptcha.Text <> '' then
  begin
    try
    if ACBrConsultaCNPJ1.Consulta(
      EditCNPJ.Text,
      EditCaptcha.Text,
      ckRemoverEspacosDuplos.Checked
    ) then
    begin
      EditTipo.Text        := ACBrConsultaCNPJ1.EmpresaTipo;
      EditRazaoSocial.Text := ACBrConsultaCNPJ1.RazaoSocial;
      EditAbertura.Text    := DateToStr( ACBrConsultaCNPJ1.Abertura );
      EditFantasia.Text    := ACBrConsultaCNPJ1.Fantasia;
      EditEndereco.Text    := ACBrConsultaCNPJ1.Endereco;
      EditNumero.Text      := ACBrConsultaCNPJ1.Numero;
      EditComplemento.Text := ACBrConsultaCNPJ1.Complemento;
      EditBairro.Text      := ACBrConsultaCNPJ1.Bairro;
      EditComplemento.Text := ACBrConsultaCNPJ1.Complemento;
      EditCidade.Text      := ACBrConsultaCNPJ1.Cidade;
      EditUF.Text          := ACBrConsultaCNPJ1.UF;
      EditCEP.Text         := ACBrConsultaCNPJ1.CEP;
      EditSituacao.Text    := ACBrConsultaCNPJ1.Situacao;
      EditCNAE1.Text       := ACBrConsultaCNPJ1.CNAE1;
      EditEmail.Text       := ACBrConsultaCNPJ1.EndEletronico;
      EditTelefone.Text    := ACBrConsultaCNPJ1.Telefone;

      ListCNAE2.Clear;
      for I := 0 to ACBrConsultaCNPJ1.CNAE2.Count - 1 do
        ListCNAE2.Items.Add(ACBrConsultaCNPJ1.CNAE2[I]);
    end;
    except
      on e:exception do begin
        ShowMessage('Erro1: ' + e.Message + #13 + 'Verifique o Captcha!');
      end;
    end;
  end
  else
  begin
    ShowMessage('� necess�rio digitar o captcha.');
    EditCaptcha.SetFocus;
  end;
end;

procedure TF_Principal.EditCaptchaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    ButBuscarClick(ButBuscar);
end;

procedure TF_Principal.FormShow(Sender: TObject);
begin
  //ACBrConsultaCNPJ1.HTTPSend.KeepAlive := true;
  //ACBrConsultaCNPJ1.HTTPSend.UserAgent := 'Mozilla/5.0 (Windows NT 5.1; rv:2.0b8) Gecko/20100101 Firefox/4.0b8';
  //ACBrConsultaCNPJ1.HTTPSend.Clear;
  //ACBrConsultaCNPJ1.HTTPSend.Protocol  := '1.1';
  //ACBrConsultaCNPJ1.HTTPSend.Cookies.Clear;

  Timer1.Enabled:= True;

end;

procedure TF_Principal.LabAtualizarCaptchaClick(Sender: TObject);
var
  Stream: TMemoryStream;
//  Jpg: TJPEGImage;
{$IFDEF DELPHI2009_UP}
  png: TPngImage;
{$ENDIF}
begin
  Stream:= TMemoryStream.Create;
  try
    ACBrConsultaCNPJ1.Captcha(Stream);

  {$IFDEF DELPHI2009_UP}
    //Use esse c�digo quando a imagem do site for do tipo PNG
    png:= TPngImage.Create;
    try
      png.LoadFromStream(Stream);
      Image1.Picture.Assign(png);

      EditCaptcha.Clear;
      EditCaptcha.SetFocus;
    finally
      png.Free;
    end;
  {$ELSE}
    ShowMessage('Aten��o: Seu Delphi n�o d� suporte nativo a imagens PNG. Queira verificar o c�digo fonte deste exemplo para saber como proceder.');
    // COMO PROCEDER:
    //
    // 1) Caso o site da receita esteja utilizando uma imagem do tipo JPG, voc� pode utilizar o c�digo comentado abaixo.
    //    * Comente ou apague o c�digo que trabalha com PNG, incluindo o IFDEF/ENDIF;
    //    * descomente a declara��o da vari�vel jpg
    //    * descomente o c�digo abaixo;
    // 2) Caso o site da receita esteja utilizando uma imagem do tipo PNG, voc� ter� que utilizar uma biblioteca de terceiros para
    //conseguir trabalhar com imagens PNG.
    //  Neste caso, recomendamos verificar o manual da biblioteca em como fazer a implementa��o. Algumas sugest�es:
    //    * Procure no F�rum do ACBr sobre os erros que estiver recebendo. Uma das maneiras mais simples est� no link abaixo:
    //      - http://www.projetoacbr.com.br/forum/topic/20087-imagem-png-delphi-7/
    //    * O exemplo acima utiliza a biblioteca GraphicEX. Mas existem outras bibliotecas, caso prefira:
    //      - http://synopse.info/forum/viewtopic.php?id=115
    //      - http://graphics32.org/wiki/
    //      - http://cc.embarcadero.com/Item/25631
    //      - V�rias outras: http://torry.net/quicksearchd.php?String=png&Title=Yes
  {$ENDIF}

    //Use esse c�digo quando a imagem do site for do tipo JPG
    //Jpg:= TJPEGImage.Create;
    //try
    //  Jpg.LoadFromStream(Stream);
    //  Image1.Picture.Assign(Jpg);
    //   //    EditCaptcha.Clear;
    //  EditCaptcha.SetFocus;
    //finally
    //  Jpg.Free;
    //end;

  finally
    Stream.Free;
  end;
end;

procedure TF_Principal.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:= False;
  LabAtualizarCaptchaClick(LabAtualizarCaptcha);
  EditCNPJ.SetFocus;
end;

end.
