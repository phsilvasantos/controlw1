unit untMain;

interface

uses
  Windows,Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,Math,
  Dialogs, ComCtrls, ActnList, Menus,ActnCtrls, ToolWin, ActnMan, ActnMenus,
  ExtCtrls, shellapi, jpeg, StdCtrls, ImgList,
  XPStyleActnCtrls, jsedit1,
   func,

  {Biblioteca P4InfoVarejo!!}
  untNFCe, System.Actions;


type
  TfrmMain = class(TForm)
    stb: TStatusBar;
    Panel1: TPanel;
    //VisualizaDOSPRINT1: TVisualizaDOSPRINT;
    mnm: TMainMenu;
    act: TActionManager;
    Image1: TImage;
    OpenDialog: TOpenDialog;
    Arquivp1: TMenuItem;
    actLogin: TAction;
    actLogoff: TAction;
    actFechar: TAction;
    actSair: TAction;
    Login1: TMenuItem;
    Logoff1: TMenuItem;
    Fechar1: TMenuItem;
    Sair1: TMenuItem;
    Rotinas: TMenuItem;
    actEmissaoCupomFiscalCFe: TAction;
    EmissodeCupomFiscalEletrnicoCFe1: TMenuItem;
    actConfiguracoes: TAction;
    N1: TMenuItem;
    Configuraes1: TMenuItem;
    actCNFeNaoEmitidas: TAction;
    N2: TMenuItem;
    CNFeNoEmitidas1: TMenuItem;
    actCancelamentoNFCe: TAction;
    CancelamentodeNFCe1: TMenuItem;
    actConsultarNFCe: TAction;
    ConsultarCupons1: TMenuItem;
    OutrasRotinas1: TMenuItem;
    EstadodoServio1: TMenuItem;
    PDV1: TMenuItem;
    ConfigurarECF1: TMenuItem;
    MenuFiscal1: TMenuItem;
    LeituraX1: TMenuItem;
    ReduoZ1: TMenuItem;
    EspelhoMFD1: TMenuItem;
    CadastrodeFormas1: TMenuItem;
    IdentificaPAFECF1: TMenuItem;
    ImpressoraFiscal1: TMenuItem;
    Aliquotas1: TMenuItem;
    LimparVendas1: TMenuItem;
    PorData1: TMenuItem;
    PorCOO1: TMenuItem;
    LeituradaMemriaFiscal1: TMenuItem;
    PorReduo1: TMenuItem;
    ImprimePorReduo1: TMenuItem;
    Sangria1: TMenuItem;
    Suprimento1: TMenuItem;
    PorReduo2: TMenuItem;
    PorData2: TMenuItem;
    LMS1: TMenuItem;
    LMFC1: TMenuItem;
    LX1: TMenuItem;
    CAT321: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure actLogoffExecute(Sender: TObject);
    procedure actFecharExecute(Sender: TObject);
    procedure actSairExecute(Sender: TObject);
    procedure actEmissaoCupomFiscalCFeExecute(Sender: TObject);
    procedure actConfiguracoesExecute(Sender: TObject);
    procedure actCNFeNaoEmitidasExecute(Sender: TObject);
    procedure actCancelamentoNFCeExecute(Sender: TObject);
    procedure actConsultarNFCeExecute(Sender: TObject);
    procedure EstadodoServio1Click(Sender: TObject);
    procedure PDV1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ConfigurarECF1Click(Sender: TObject);
    procedure LeituraX1Click(Sender: TObject);
    procedure CadastrodeFormas1Click(Sender: TObject);
    procedure IdentificaPAFECF1Click(Sender: TObject);
    procedure Aliquotas1Click(Sender: TObject);
    procedure LimparVendas1Click(Sender: TObject);
    procedure PorData1Click(Sender: TObject);
    procedure PorCOO1Click(Sender: TObject);
    procedure PorReduo1Click(Sender: TObject);
    procedure ImprimePorReduo1Click(Sender: TObject);
    procedure Sangria1Click(Sender: TObject);
    procedure Suprimento1Click(Sender: TObject);
    procedure PorReduo2Click(Sender: TObject);
    procedure ReduoZ1Click(Sender: TObject);
    procedure PorData2Click(Sender: TObject);
    procedure CAT321Click(Sender: TObject);
    procedure LX1Click(Sender: TObject);
    procedure LMS1Click(Sender: TObject);
    procedure LMFC1Click(Sender: TObject);
  private    { Private declarations }
    formatual : string;
  public     { Public declarations }
    intervaloTimer : String;
    function geraReducao() : smallint;
    procedure criaArquivoReducao();
  end;

var
  frmMain: TfrmMain;

implementation

uses untDtmMain, untCupomFiscalSAT, untConfiguracoesNFCe,
  untCancelaNFCe, untVisualizaNFCe, untVendaPDV, configImp,
  cadFormaPagto, identifica, frmStatus, login,
  cadecf1, importapedido;

{$R *.dfm}

        {===============================
        |   Procedimentos de Eventos!!  |
        ================================}

function TfrmMain.geraReducao() : smallint;
var
  ini, fim : integer;
  erro : boolean;
  sim1  : String;
  arq  : TStringList;
begin
  sim1 := dialogo('generico',0,'SN',0,true,'S','Control for Windows:','Deseja Emitir a Redu��o Z, O ECF pode fechar o movimento di�rio!','N');
  if ((sim1 = '*') or (sim1 = 'N')) then exit;

  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;
  erro := false;

  mostraMensagem('Aguarde, Emitindo Redu��o Z...', true);
  dtmMain.ACBrECF1.DadosReducaoZ;

  criaArquivoReducao();
  //a funcao acima cria um arquivo com os dados de reducoes Z

  erro := true;

  dtmMain.IBQuery2.Close;
  dtmMain.IBQuery2.SQL.Text := ('update or insert into SPED_REDUCAOZ(cod, data, ecf, CONT_REINICIO, CONT_REDUCAOZ, CONT_OP, TOT_GERAL, TOT_CANC, TOT_ALIQ01, TOT_ALIQ02, TOT_ALIQ03, TOT_ALIQ04, ' +
  'TOT_ALIQ05, TOT_ALIQ06, TOT_ALIQ07, TOT_ALIQ08, TOT_DESC, TOT_FF, TOT_II, TOT_NN, VENDABRUTA) values(gen_id(SPED_REDUCAOZ, 1), '+
  ':data, :ecf, :CONT_REINICIO, :CONT_REDUCAOZ, :CONT_OP, :TOT_GERAL, :TOT_CANC, :TOT_ALIQ01, :TOT_ALIQ02, :TOT_ALIQ03, :TOT_ALIQ04, ' +
  ':TOT_ALIQ05, :TOT_ALIQ06, :TOT_ALIQ07, :TOT_ALIQ08, :TOT_DESC, :TOT_FF, :TOT_II, :TOT_NN, :VENDABRUTA)');

  try
    dtmMain.IBQuery2.ParamByName('data').AsDate   := now;
  with dtmMain.ACBrECF1.DadosReducaoZClass do
    begin
      dtmMain.IBQuery2.ParamByName('ecf').AsInteger            := StrToIntDef(dtmMain.ACBrECF1.NumECF, 0);
      dtmMain.IBQuery2.ParamByName('CONT_REINICIO').AsInteger  := CRO;
      dtmMain.IBQuery2.ParamByName('CONT_REDUCAOZ').AsInteger  := CRZ + 1;
      dtmMain.IBQuery2.ParamByName('CONT_OP').AsInteger        := COO + 1;
      dtmMain.IBQuery2.ParamByName('TOT_GERAL').AsCurrency     := ValorGrandeTotal;
      dtmMain.IBQuery2.ParamByName('TOT_CANC').AsCurrency      := CancelamentoICMS;

      ini := -1;
      fim := ICMS.Count -1;
      while true do
        begin
          ini := ini + 1;
          if ini <= fim then  dtmMain.IBQuery2.ParamByName('TOT_ALIQ0' + IntToStr(ini + 1)).AsCurrency  := ICMS[ini].Total
            else dtmMain.IBQuery2.ParamByName('TOT_ALIQ0' + IntToStr(ini + 1)).AsCurrency  := 0;

          if ini = 7 then break;
        end;

      dtmMain.IBQuery2.ParamByName('TOT_DESC').AsCurrency      := DescontoICMS;
      dtmMain.IBQuery2.ParamByName('TOT_FF').AsCurrency        := SubstituicaoTributariaICMS;
      dtmMain.IBQuery2.ParamByName('TOT_II').AsCurrency        := IsentoICMS;
      dtmMain.IBQuery2.ParamByName('TOT_NN').AsCurrency        := NaoTributadoICMS;
      dtmMain.IBQuery2.ParamByName('VENDABRUTA').AsCurrency    := ValorVendaBruta;
   end;

  dtmMain.IBQuery2.ExecSQL;
  dtmMain.IBQuery2.Transaction.Commit;


  except
    on e:exception do
      begin
        MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
        mostraMensagem('Aguarde, Emitindo Redu��o Z...', false);
      end;
  end;

  try
    dtmMain.ACBrECF1.ReducaoZ(now);
  except
    on e:exception do
      begin
        MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
      end;
  end;

  mostraMensagem('Aguarde, Emitindo Redu��o Z...', false);
  ShowMessage('Redu��o Z Executada com Sucesso');
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  indxImp, velo : integer;
  porta, porta1, usaDLL, velobal, tipobal, portabal, intervalo   : String;
begin
 stb.panels[0].Text := 'Usu�rio: '+ '';
 stb.panels[1].text := '';
 Caption := application.Title;
 //glbCFOP := LerConfiguracaoCFOP;

 porta := '';
 velo  := 0;
 //LerParametrosACBrECF(indxImp, velo, porta1, usaDLL, portabal, velobal, tipobal, intervalo);

 form1.intervaloVenda := intervalo;
 {if porta <> '' then
   begin
     //setParametrosACBrECF(dtmMain.ACBrECF1, dtmMain.ACBrBAL1, indxImp, velo, porta, velobal, portabal, tipobal);
   end;}
 //
 actEmissaoCupomFiscalCFeExecute(sender);
 //
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if MessageDlg('Tem Certeza que Deseja Finaliza Sistema ?',mtConfirmation,[MbYes,MbNo],0)=idyes then
  begin
   //CanClose := true;
   Application.Terminate;
  end else CanClose := false;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
 {Configura sistema!!}

 {ShortDateFormat := 'dd/mm/yyyy';
 ShortTimeFormat := 'hh:mm:ss';
 DateSeparator := '/';
 TimeSeparator := ':';}
 //LeRegistroSistema;
 //dtmMain.conmain.Disconnect;
 try
  //dtmMain.conmain.DatabaseName := 'D:\clientes\nfce\exe\BDHOMOLOGA.GDB';//RegConexao;
  //dtmMain.conmain.Username     := 'sysdba';//RegUsuario;
  //dtmMain.conmain.Password     := 'masterkey';//RegSenha;
  //dtmMain.conmain.Connect;
 except
   begin
    MessageDlg('Erro ao Conectar Em Banco de Dados.',mtError,[mbok],0);
   end;
 end;
 stb.Panels[1].Text := 'Usu�rio: ';
 stb.Panels[2].Text := dtmMain.bd.DatabaseName;

 if FileExists(ExtractFileDir(ParamStr(0)) + '\Principal.jpg') then Image1.Picture.LoadFromFile('Principal.jpg');
end;

procedure TfrmMain.actLogoffExecute(Sender: TObject);
begin
// if FinalizarTransacao(dtmmain.trnmain) = mrcancel then  exit;
//DesConfigurarPermissoes(self);
// FecharTodosForms;
 ///ZerarVariaveisConexao;        // zerar variaveis de conexao: usuario, computador, formulario, permissao
 //AtivarAction(act, false);     // desabilitar todas as op��es do menu disponibilizando apenas login e sair

 stb.panels[0].Text := 'Desconectado';
 formatual := '';
 Repaint;
 close;
end;

procedure TfrmMain.actFecharExecute(Sender: TObject);
begin
 if formAtual <> '' then
  begin
 //  if FinalizarTransacao(dtmmain.trnmain) = mrcancel then  exit;
 //  DestruirFormAtual(formatual,dtmMain.trnMain);
  end;
end;

procedure TfrmMain.actSairExecute(Sender: TObject);
begin
 if MessageDlg('Tem Certeza que Deseja Finaliza Sistema ?',mtConfirmation,[MbYes,MbNo],0)=idyes then
  begin
   Application.Terminate;
  end;
end;


procedure TfrmMain.actEmissaoCupomFiscalCFeExecute(Sender: TObject);
begin
  form3 := tform3.Create(self);
  CtrlResize(tform(form3));
  form3.ShowModal;
  try
    jsedit.LiberaMemoria(form3);
  except
  end;  
  form3.Free;
end;

procedure TfrmMain.actConfiguracoesExecute(Sender: TObject);
begin
 Configuracoes_NFCe();
end;

procedure TfrmMain.actCNFeNaoEmitidasExecute(Sender: TObject);
begin
 //dlgTransferenciaCF('');
end;

procedure TfrmMain.actCancelamentoNFCeExecute(Sender: TObject);
begin
 //dlgCancelaNFCe;
 cadECF := TcadECF.Create(self);
 cadECF.ShowModal;
 cadECF.Free;
end;

procedure TfrmMain.actConsultarNFCeExecute(Sender: TObject);
begin
 {if lowercase(formatual) = 'frmConsultaNotas'      then exit;
 if FinalizarTransacao(dtmmain.trnMain) = mrcancel then exit;
 if not ExisteFormulario('frmConsultaNotas')       then frmConsultaNotas := TfrmConsultaNotas.Create(frmMain);
 configform(frmConsultaNotas, formatual);
}

frmConsultaNotas := tfrmConsultaNotas.Create(self);
frmConsultaNotas.ShowModal;
frmConsultaNotas.Free;
end;

procedure TfrmMain.EstadodoServio1Click(Sender: TObject);
begin
  Verifica_Status_NFe;
end;

procedure TfrmMain.PDV1Click(Sender: TObject);
begin
  Form2 := tform2.Create(self);
  form2.ShowModal;
  form2.Free;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
end;

procedure TfrmMain.ConfigurarECF1Click(Sender: TObject);
begin
  form6 := tform6.Create(self);
  form6.ShowModal;
  form6.Free;
end;

procedure TfrmMain.LeituraX1Click(Sender: TObject);
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;
  try
    mostraMensagem('Aguarde, Emitindo Leitura X...', true);
    dtmMain.ACBrECF1.LeituraX;
  finally
    mostraMensagem('Aguarde, Emitindo Leitura X...', false);
  end;
end;

procedure TfrmMain.CadastrodeFormas1Click(Sender: TObject);
begin
  cadFormas := tcadFormas.Create(self);
  cadFormas.ShowModal;
  cadFormas.Free;
end;

procedure TfrmMain.IdentificaPAFECF1Click(Sender: TObject);
begin
  form8 := tform8.Create(self);
  form8.ShowModal;
  form8.Free;
end;

procedure TfrmMain.Aliquotas1Click(Sender: TObject);
var
  aliq     : string;
  ini, fim : integer;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;

  fim  := dtmMain.ACBrECF1.Aliquotas.Count -1;
  aliq := '';
  for ini := 0 to fim do
    begin
      if dtmMain.ACBrECF1.Aliquotas[ini].Indice[1] = 'T' then
      aliq := aliq + dtmMain.ACBrECF1.Aliquotas[ini].Indice + ' -' + CompletaOuRepete('', formataCurrency(dtmMain.ACBrECF1.Aliquotas[ini].Aliquota), '0', 5) + #13;
    end;

  ShowMessage('Aliquotas' + #13 + #13 + aliq);
end;

procedure TfrmMain.LimparVendas1Click(Sender: TObject);
begin
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'update venda set ok = ''S''';

  try
    dtmMain.IBQuery1.ExecSQL;
    dtmMain.IBQuery1.Transaction.Commit;
    ShowMessage('Comando Executado com Sucesso');
  except
    on e:exception do
      begin
        ShowMessage('Erro:' + #13 + e.Message);
      end;
  end;


end;

procedure TfrmMain.PorData1Click(Sender: TObject);
var
  dini, dfim : string;
  linhas : TStringList;
  ini    : integer;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;
  dini := dialogo('data',0,'',0,true,'','Control for Windows:','Qual a Data Inicial','');
  if dini = '*' then exit;

  dfim := dialogo('data',0,'',0,true,'','Control for Windows:','Qual a Data Final','');
  if dfim = '*' then exit;

  try
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', true);
    mfd := tmfd.Create(self);
    linhas := TStringList.Create;
    dtmMain.ACBrECF1.LeituraMFDSerial(StrToDate(dini), StrToDate(dfim), linhas);
    mfd.RichEdit1.Clear;
    for ini := 0 to linhas.Count -1 do
      begin
        mfd.RichEdit1.Lines.Add(linhas[ini]);
      end;
    mfd.ShowModal;
  finally
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', false);
    linhas.Free;
    mfd.Free;
  end;

end;

procedure TfrmMain.PorCOO1Click(Sender: TObject);
var
  dini, dfim : string;
  linhas : TStringList;
  ini    : integer;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;
  dini := dialogo('generico',0,'1234567890,.'+#8,0,true,'','Control for Windows:','Qual o COO Inicial','');
  if dini = '*' then exit;

  dfim := dialogo('generico',0,'1234567890,.'+#8,0,true,'','Control for Windows:','Qual o COO Final','');
  if dfim = '*' then exit;

  try
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', true);
    mfd := tmfd.Create(self);
    linhas := TStringList.Create;
    dtmMain.ACBrECF1.LeituraMFDSerial(StrToIntDef(dini, 1), StrToIntDef(dfim, 1), linhas);
    mfd.RichEdit1.Clear;
    for ini := 0 to linhas.Count -1 do
      begin
        mfd.RichEdit1.Lines.Add(linhas[ini]);
      end;
    mfd.ShowModal;
  finally
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', false);
    linhas.Free;
    mfd.Free;
  end;
end;

procedure TfrmMain.PorReduo1Click(Sender: TObject);
var
  dini, dfim : string;
  linhas : TStringList;
  ini    : integer;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;
  dini := dialogo('generico',0,'1234567890,.'+#8,0,true,'','Control for Windows:','Qual a Redu��o Inicial','');
  if dini = '*' then exit;

  dfim := dialogo('generico',0,'1234567890,.'+#8,0,true,'','Control for Windows:','Qual a Redu��o Final','');
  if dfim = '*' then exit;

  try
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', true);
    mfd := tmfd.Create(self);
    linhas := TStringList.Create;
    dtmMain.ACBrECF1.LeituraMemoriaFiscalSerial(StrToIntDef(dini, 1), StrToIntDef(dfim, 1), linhas);
    mfd.RichEdit1.Clear;
    for ini := 0 to linhas.Count -1 do
      begin
        mfd.RichEdit1.Lines.Add(linhas[ini]);
      end;
    mfd.ShowModal;
  finally
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', false);
    linhas.Free;
    mfd.Free;
  end;
end;

procedure TfrmMain.ImprimePorReduo1Click(Sender: TObject);
var
  dini, dfim : string;
  linhas : TStringList;
  ini    : integer;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;
  dini := dialogo('generico',0,'1234567890,.'+#8,0,true,'','Control for Windows:','Qual a Redu��o Inicial','');
  if dini = '*' then exit;

  dfim := dialogo('generico',0,'1234567890,.'+#8,0,true,'','Control for Windows:','Qual a Redu��o Final','');
  if dfim = '*' then exit;

  try
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', true);
    mfd := tmfd.Create(self);
    linhas := TStringList.Create;
    dtmMain.ACBrECF1.LeituraMemoriaFiscal(StrToIntDef(dini, 1), StrToIntDef(dfim, 1));
    mfd.RichEdit1.Clear;
    for ini := 0 to linhas.Count -1 do
      begin
        mfd.RichEdit1.Lines.Add(linhas[ini]);
      end;
    mfd.ShowModal;
  finally
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', false);
    linhas.Free;
    mfd.Free;
  end;
end;

procedure TfrmMain.Sangria1Click(Sender: TObject);
var
  cValor, cdesc : String;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;

  cValor := dialogo('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Qual o Valor de Sangria ?','0,01');
  if cValor = '*' then exit;

  cdesc := dialogo('normal',200,'',200,false,'','Control for Windows:','Informe uma Observa��o para esta Sangria ?','');
  if cValor = '*' then exit;

  dtmMain.ACBrECF1.Sangria(StrToCurr(cValor), cdesc);
end;

procedure TfrmMain.Suprimento1Click(Sender: TObject);
var
  cValor, cdesc : String;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;

  cValor := dialogo('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Qual o Valor de Sangria ?','0,01');
  if cValor = '*' then exit;

  cdesc := dialogo('normal',200,'',200,false,'','Control for Windows:','Informe uma Observa��o para esta Sangria ?','');
  if cValor = '*' then exit;

  dtmMain.ACBrECF1.Suprimento(StrToCurr(cValor), cdesc);
end;

procedure TfrmMain.PorReduo2Click(Sender: TObject);
var
  dini, dfim : string;
  linhas : TStringList;
  ini    : integer;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;

  dini := localizar1('Localizar Redu��o', 'SPED_REDUCAOZ', '*', 'CONT_OP', '', '', 'DATA', FALSE, FALSE, FALSE, '', '', 400, nil);
  if dini = '' then exit;

  try
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', true);
    mfd := tmfd.Create(self);
    linhas := TStringList.Create;
    dtmMain.ACBrECF1.LeituraMFDSerial(StrToIntDef(dini, 1), StrToIntDef(dini, 1), linhas);
    mfd.RichEdit1.Clear;
    for ini := 0 to linhas.Count -1 do
      begin
        mfd.RichEdit1.Lines.Add(linhas[ini]);
      end;
    mfd.ShowModal;
  finally
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', false);
    linhas.Free;
    mfd.Free;
  end;
end;

procedure TfrmMain.ReduoZ1Click(Sender: TObject);
begin
  geraReducao();
end;

procedure TfrmMain.PorData2Click(Sender: TObject);
var
  dini, dfim : string;
  ini    : integer;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;
  dini := dialogo('data',0,'',0,true,'','Control for Windows:','Qual a Data Inicial','');
  if dini = '*' then exit;

  dfim := dialogo('data',0,'',0,true,'','Control for Windows:','Qual a Data Final','');
  if dfim = '*' then exit;

  try
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', true);
    dtmMain.ACBrECF1.LeituraMemoriaFiscal(StrToDate(dini), StrToDate(dfim));
  finally
    mostraMensagem('Aguarde, Lendo Mem�ria Fiscal...', false);
  end;

end;

procedure TfrmMain.CAT321Click(Sender: TObject);
var
  DirArquivos: string;
  dini, dfim : string;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;
  dini := dialogo('data',0,'',0,true,'','Control for Windows:','Qual a Data Inicial','');
  if dini = '*' then exit;

  dfim := dialogo('data',0,'',0,true,'','Control for Windows:','Qual a Data Final','');
  if dfim = '*' then exit;

  DirArquivos := ExtractFilePath(ParamStr(0)) + 'CAT52';
  if not DirectoryExists(DirArquivos) then
    ForceDirectories(DirArquivos);

  dtmMain.ACBrECF1.PafMF_GerarCAT52(StrToDate(dini), StrToDate(dfim), DirArquivos);

  ShowMessage(Format('Arquivos gerados com sucesso em:'#13#10' "%s"', [DirArquivos]));
end;

procedure TfrmMain.LX1Click(Sender: TObject);
begin
  dtmMain.ACBrECF1.PafMF_LX_Impressao;
end;

procedure TfrmMain.LMS1Click(Sender: TObject);
var
  DirArquivos: string;
  dini, dfim : string;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;
  dini := dialogo('data',0,'',0,true,'','Control for Windows:','Qual a Data Inicial','');
  if dini = '*' then exit;

  dfim := dialogo('data',0,'',0,true,'','Control for Windows:','Qual a Data Final','');
  if dfim = '*' then exit;

  DirArquivos := ExtractFilePath(ParamStr(0)) + 'arq1.tmp';
  dtmMain.ACBrECF1.PafMF_LMFS_Espelho(StrToDate(dini), StrToDate(dfim), DirArquivos);

  mfd := Tmfd.Create(self);
  mfd.RichEdit1.Clear;
  mfd.RichEdit1.Lines.LoadFromFile(DirArquivos);
  mfd.ShowModal;
  mfd.Free;

  //ShowMessage(Format('Arquivos gerados com sucesso em:'#13#10' "%s"', [DirArquivos]));
end;

procedure TfrmMain.LMFC1Click(Sender: TObject);
var
  DirArquivos: string;
  dini, dfim : string;
begin
  if not dtmMain.ACBrECF1.Device.Ativo then dtmMain.ACBrECF1.Ativar;
  dini := dialogo('data',0,'',0,true,'','Control for Windows:','Qual a Data Inicial','');
  if dini = '*' then exit;

  dfim := dialogo('data',0,'',0,true,'','Control for Windows:','Qual a Data Final','');
  if dfim = '*' then exit;

  DirArquivos := ExtractFilePath(ParamStr(0)) + 'arq1.tmp';
  dtmMain.ACBrECF1.PafMF_LMFC_Espelho(StrToDate(dini), StrToDate(dfim), DirArquivos);

  mfd := Tmfd.Create(self);
  mfd.RichEdit1.Clear;
  mfd.RichEdit1.Lines.LoadFromFile(DirArquivos);
  mfd.ShowModal;
  mfd.Free;
end;

procedure TfrmMain.criaArquivoReducao();
var
  arq : TStringList;
  ini, fim : integer;
  pasta    : String;
begin
  arq := TStringList.Create;
  arq.Values['ReducaoZdia'] := FormatDateTime('dd/mm/yyyy', now);

  with dtmMain.ACBrECF1.DadosReducaoZClass do
    begin
      arq.Values['ecf'] := dtmMain.ACBrECF1.NumECF;
      arq.Values['CONT_REINICIO'] := IntToStr(CRO);
      arq.Values['CONT_REDUCAOZ'] := IntToStr(CRZ + 1);
      arq.Values['CONT_OP'] := IntToStr(COO + 1);
      arq.Values['TOT_GERAL'] := CurrToStr(ValorGrandeTotal);
      arq.Values['TOT_CANC'] := CurrToStr(CancelamentoICMS);

      ini := -1;
      fim := ICMS.Count -1;
      while true do
        begin
          ini := ini + 1;

          if ini <= fim then  arq.Values['TOT_ALIQ0' + IntToStr(ini + 1)]      := CurrToStr(ICMS[ini].Total)
            else arq.Values['TOT_ALIQ0' + IntToStr(ini + 1)]      := '0';

          if ini = 7 then break;
        end;

      arq.Values['TOT_DESC']   := CurrToStr(DescontoICMS);
      arq.Values['TOT_FF']     := CurrToStr(SubstituicaoTributariaICMS);
      arq.Values['TOT_II']     := CurrToStr(IsentoICMS);
      arq.Values['TOT_NN']     := CurrToStr(NaoTributadoICMS);
      arq.Values['VENDABRUTA'] := CurrToStr(ValorVendaBruta);

      pasta := ExtractFileDir(ParamStr(0)) + '\';
      if not DirectoryExists(pasta + 'ReducoesZ\') then ForceDirectories(pasta + 'ReducoesZ\');

      arq.SaveToFile(pasta + 'ReducoesZ\' + 'ReducaoZ-' + FormatDateTime('dd', now) +
      FormatDateTime('mm', now) + FormatDateTime('yy', now) + '-' + IntToStr(CRZ + 1) + '.txt');
      //arq.SaveToFile(pasta + 'ReducoesZ\' + 'ReducaoZ-' + IntToStr(CRZ + 1) + '.txt');
      arq.Free;
    end;
end;

end.

