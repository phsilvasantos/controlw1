unit untMovto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, OleCtrls, SHDocVw, StdCtrls, Grids, DBGrids, ExtCtrls,
  Buttons, DB, ACBrNFeDANFEClass, ACBrNFeDANFERave,
  pcnConversao,

  untNFCe;

type
  TfrmTransferenciaCupom = class(TForm)
    Panel1: TPanel;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    PageControl1: TPageControl;
    tbsPrincipal: TTabSheet;
    tbsResposta: TTabSheet;
    MemoResp: TMemo;
    tbsWebResposta: TTabSheet;
    WBResposta: TWebBrowser;
    stbmain: TStatusBar;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    nunotafe:string;
    { Public declarations }
  end;

   function dlgTransferenciaCF(const nota : String):Boolean;

var
  frmTransferenciaCupom: TfrmTransferenciaCupom;

implementation

uses untDtmMain, ACBrNFe, ACBrNFeConfiguracoes;

{$R *.dfm}

function dlgTransferenciaCF(const nota : String):Boolean;
begin
 Result := false;
 try
  frmTransferenciaCupom := TfrmTransferenciaCupom.Create(nil);
  frmTransferenciaCupom.nunotafe := nota;
  with frmTransferenciaCupom do
   begin
    ShowModal;
    if ModalResult = mrOk then
    Result := true;
   end;
 finally
  FreeAndNil(frmTransferenciaCupom);
 end;
end;

procedure TfrmTransferenciaCupom.FormShow(Sender: TObject);
begin
  if dtmMain.ACBrNFe.Configuracoes.Geral.FormaEmissao = teNormal        then stbmain.Panels[0].Text := 'Forma Emiss�o: Normal';
  if dtmMain.ACBrNFe.Configuracoes.Geral.FormaEmissao = teContingencia  then stbmain.Panels[0].Text := 'Forma Emiss�o: Contingencia';
  if dtmMain.ACBrNFe.Configuracoes.Geral.FormaEmissao = teSCAN          then stbmain.Panels[0].Text := 'Forma Emiss�o: SCAN';
  if dtmMain.ACBrNFe.Configuracoes.Geral.FormaEmissao = teDPEC          then stbmain.Panels[0].Text := 'Forma Emiss�o: DPEC';
  if dtmMain.ACBrNFe.Configuracoes.Geral.FormaEmissao = teFSDA          then stbmain.Panels[0].Text := 'Forma Emiss�o: NORMAL';
  if dtmMain.ACBrNFe.Configuracoes.Geral.FormaEmissao = teSVCAN         then stbmain.Panels[0].Text := 'Forma Emiss�o: FSDA';
  if dtmMain.ACBrNFe.Configuracoes.Geral.FormaEmissao = teSVCRS         then stbmain.Panels[0].Text := 'Forma Emiss�o: SVCRS';
  if dtmMain.ACBrNFe.Configuracoes.Geral.FormaEmissao = teSVCSP         then stbmain.Panels[0].Text := 'Forma Emiss�o: SVCSP';
  if dtmMain.ACBrNFe.Configuracoes.Geral.FormaEmissao = teOffLine       then stbmain.Panels[0].Text := 'Forma Emiss�o: OFF Line';


 stbmain.Panels[1].Text := 'Data: ';//+FormatDateTime(P4InfoVarejo_dtabrev, DtBanco);
 if dtmMain.ACBrNFe.Configuracoes.WebServices.Ambiente = taProducao then
 stbmain.Panels[2].Text := 'Ambiente: Produ��o'
 else stbmain.Panels[2].Text := 'Ambiente: Homologa��o';

end;

end.
