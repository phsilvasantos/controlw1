unit untVendaPDV;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sEdit, func, ExtCtrls, sPanel, jpeg, JsEdit1,
  JsEditNumero1, JsEditInteiro1, Grids, DBGrids, DB, ComCtrls, ACBrBase, ACBrBAL, formas, acbrecf, ACBrDevice,
  classes1, ACBrLCB, login, Datasnap.DBClient, funcoesdav;
  
type
  TForm3 = class(TForm)
    Image1: TImage;
    PainelProduto: TPanel;
    codbar: JsEdit;
    LabelCodBar: TLabel;
    LabelQuantidade: TLabel;
    quant: JsEditNumero;
    labelpreco: TLabel;
    preco: JsEditNumero;
    LabelTotal: TLabel;
    total: JsEditNumero;
    Panel2: TPanel;
    DataSource1: TDataSource;
    RichEdit1: TListBox;
    Timer1: TTimer;
    PainelTotal: TPanel;
    IBClientDataSet1: TClientDataSet;
    IBClientDataSet1cod: TIntegerField;
    IBClientDataSet1codbar: TStringField;
    IBClientDataSet1nome: TStringField;
    IBClientDataSet1quant: TCurrencyField;
    IBClientDataSet1preco: TCurrencyField;
    IBClientDataSet1p_total: TAggregateField;
    Panel4: TPanel;
    IBClientDataSet1aliq: TCurrencyField;
    IBClientDataSet1contador: TIntegerField;
    TimerVenda: TTimer;
    ACBrLCB1: TACBrLCB;
    NomesAjuda: TLabel;
    Button1: TButton;
    IBClientDataSet1precoOrigi: TCurrencyField;
    IBClientDataSet1p_compra: TCurrencyField;
    IBClientDataSet1total: TCurrencyField;
    IBClientDataSet1totalOrigi: TCurrencyField;
    Button2: TButton;
    PainelCaixa1: TPanel;
    Timer2: TTimer;
    PainelCaixa: TLabel;
    procedure FormShow(Sender: TObject);
    procedure codbarKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RichEdit1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure codbarKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure quantKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure TimerVendaTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    dav, TeclaEnter : boolean;
    recebido, troco, entrada, utiLeituraBalanca : currency;
    nota_venda, codhis, receb, obs, crc, corte, codTemp, balArredonda : String;
    formasP, formaPagtoImpressora : TStringList;
    dadosEmpresa : TStringList;
    inicio : smallint;
    TotTributos : currency;
    indice, vendedor, CodVendedorTemp, NomeVendedorTemp, tipoArredondaVenda,
    codECF, vendCaption, clienteOBS : string;
    formasPagamento : TClientDataSet;
    cupomAberto, vendendoECF, cupomAberto1, vendeuf2 : boolean;
    arq : TStringList;
    function VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false : boolean;
    function confirmaPrecoProduto(cod : String;var qtd , valor : String; opcao : smallint; servico : boolean = false) : string;
    procedure identificaCliente(var codcli : String);
    function criaListaDeItens(desconto1 : currency; var lista1 : TList) : TList;
    FUNCTION VE_IMPOSTO(_PC, _PV, _qtd : currency) : currency;
    function calculaVlrAproxImpostos(var lista1 : TList) : currency;
    procedure aguardaECF();
    procedure aguardaRespostaECF(const intervalo : integer = 100);
    function somaTotalOriginal(somaValorReal : boolean = false) : Currency;
    procedure setaConfigBalanca();
    procedure setaCoresPDV();
    procedure alinhaComponentes();
    procedure vendeItem();
    procedure vendeItemFila(const codbar1 : string);
    procedure vendeVISUAL();
    function lerPesoBalanca() : currency;
    procedure encerrarVenda(dialogo : boolean = true);
    function gravaVenda() : boolean;
    procedure verProdutos();
    procedure limpaVenda();
    procedure mostraTroco();
    procedure atualizaCRC(var nota, crc : String);
    function emiteDAV(const pergunta : boolean = false) : boolean;
    procedure fechaDav();
    function lerReceido() : boolean;
    procedure lerFormasParaGravarAVendaPreencheEntrada();
    procedure descarregaFormasDePagamentoImpressora();
    procedure criaDataSetFormas();
    procedure cancelaVenda();
    function verificaValoresNulosFormaDePagamentosOK(total_geral1 : currency) : boolean;
    { Private declarations }
  public
    ECF     : TACBrECF;
    acessoUsuVenda, configu, usaDLL : string;
    balOnline, abreLocalizaPesagem : boolean;
    tot_ge, desconto, descontoItens, tot1 : currency;
    procedure lancaDesconto(var desc1, tot_g : currency; ConfigUsuario, tipoDesc, acessoUsu : String; precoDefault : currency = 0; CalcularMinimoPrecoTotalOriginal : currency = 0);
    procedure cancelaItemVisual(const num : smallint;const tot_item : currency);
    { Public declarations }
  end;

var
  Form3: TForm3;
Const
  sLineBreak = #13#10;
  maxTroco : integer = 5000;

implementation

uses untDtmMain, ibquery, StrUtils, login1,
  MenuFiscal, consultaProduto, Math, dmecf, configImp, dialog, mens,
  importapedido, cadCli;

{$R *.dfm}
procedure TForm3.setaCoresPDV();
var
 cor, cor1, cor2 : string;
  bs : TStream;
  fig : TJPEGImage;
begin

  cor := '-1- #000000 -2- #EEEED1 -';
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select nome, papel from CONFIG_TEMA where top = 1';
  dtmMain.IBQuery1.Open;

  if not dtmMain.IBQuery1.IsEmpty then
    begin
      cor := dtmMain.IBQuery1.fieldbyname('nome').AsString;
      fig := TJPEGImage.Create;
      bs := TStream.Create;
      bs := dtmMain.IBQuery1.CreateBlobStream(dtmMain.IBQuery1.FieldByName('papel'),bmRead);

      if bs.Size > 0 then
        Begin
          fig.LoadFromStream(bs);
          self.Image1.Picture.Assign(fig);
        end;

      dtmMain.IBQuery1.Close;
      if cor = '' then exit;
    end
  else
    begin
      exit;
      if dtmMain.IBQuery1.fieldbyname('nome').AsString = '' then exit;
      dtmMain.IBQuery1.Close;
      dtmMain.IBQuery1.SQL.Text := 'update CONFIG_TEMA set nome = :nome';
      dtmMain.IBQuery1.ParamByName('nome').AsString := cor;
      dtmMain.IBQuery1.ExecSQL;
      dtmMain.IBQuery1.Transaction.Commit;
    end;
  dtmMain.IBQuery1.Close;

  //cor2 := StringReplace(LerConfig(cor, 2), '#', '', [rfReplaceAll]);
  //cor1 := StringReplace(LerConfig(cor, 1), '#', '', [rfReplaceAll]);
  cor2 := LerConfig(cor, 2); //painel
  cor1 := LerConfig(cor, 1); //fonte

  //ShowMessage(cor + #13 + cor1 + #13 + cor2);

  PainelProduto.Color      := StringToColor(cor2);
  PainelProduto.Font.Color := StringToColor(cor1);

  RichEdit1.Color      := StringToColor(cor2);
  RichEdit1.Font.Color := StringToColor(cor1);

  Panel2.Color      := StringToColor(cor2);
  Panel2.Font.Color := StringToColor(cor1);

  codbar.Color        := StringToColor(cor2);
  codbar.ColorOnEnter := StringToColor(cor2);
  codbar.Font.Color   := StringToColor(cor1);

  quant.Color        := StringToColor(cor2);
  quant.ColorOnEnter := StringToColor(cor2);
  quant.Font.Color   := StringToColor(cor1);

  preco.Color        := StringToColor(cor2);
  preco.ColorOnEnter := StringToColor(cor2);
  preco.Font.Color   := StringToColor(cor1);

  total.Color        := StringToColor(cor2);
  total.ColorOnEnter := StringToColor(cor2);
  total.Font.Color   := StringToColor(cor1);

  Panel4.Color          := StringToColor(cor2);
  Panel4.Font.Color     := StringToColor(cor1);
  NomesAjuda.Font.Color := StringToColor(cor1);
  {PainelProduto.Color      := HexToTColor(cor2);
  PainelProduto.Font.Color := HexToTColor(cor1);

  RichEdit1.Color      := HexToTColor(cor2);
  RichEdit1.Font.Color := HexToTColor(cor1);

  Panel2.Color      := HexToTColor(cor2);
  Panel2.Font.Color := HexToTColor(cor1);

  codbar.Color        := HexToTColor(cor2);
  codbar.ColorOnEnter := HexToTColor(cor2);
  codbar.Font.Color   := HexToTColor(cor1);

  quant.Color        := HexToTColor(cor2);
  quant.ColorOnEnter := HexToTColor(cor2);
  quant.Font.Color   := HexToTColor(cor1);

  preco.Color        := HexToTColor(cor2);
  preco.ColorOnEnter := HexToTColor(cor2);
  preco.Font.Color   := HexToTColor(cor1);

  total.Color        := HexToTColor(cor2);
  total.ColorOnEnter := HexToTColor(cor2);
  total.Font.Color   := HexToTColor(cor1);

  Panel4.Color          := HexToTColor(cor2);
  Panel4.Font.Color     := HexToTColor(cor2);
  NomesAjuda.Font.Color := HexToTColor(cor1);}
end;

procedure TForm3.atualizaCRC(var nota, crc : String);
begin
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'update venda set ok = ''S'', crc = :crc, ENTREGA = ''C'' where nota = :nota' ;
  dtmMain.IBQuery1.ParamByName('nota').AsInteger := StrToIntDef(nota, 0);
  dtmMain.IBQuery1.ParamByName('crc').AsString   := copy(crc, 1, 9);
  dtmMain.IBQuery1.ExecSQL;
  dtmMain.IBQuery1.Transaction.Commit;
end;

function TForm3.emiteDAV(const pergunta : boolean = false) : boolean;
var
 cnpj, aliq, cod_aliq : String;
 erro : boolean;
begin
  TeclaEnter := false;

  try
  erro := false;
  if pergunta  = false then
   begin
     form2 := tform2.Create(self);
     form2.ShowModal;
     nota_venda := form2.nota;
     form2.Venda.Close;
     form2.itens.Close;
     form2.Free;
   end
 else
   begin
     nota_venda := dialogo('generico',200,'1234567890,.'+#8,200,false,'ok','Control for Windows:','Qual o Numero de Venda?','');
     if nota_venda = '*' then exit;
   end;


  if nota_venda = '' then exit;

  try
  mostraMensagem('Aguarde, Emitindo Cupom...', true);

  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select cliente, total, desconto, codhis, vendedor from venda where nota = :nota';
  dtmMain.IBQuery1.ParamByName('nota').AsString := nota_venda;
  dtmMain.IBQuery1.Open;

  if dtmMain.IBQuery1.IsEmpty then
    begin
      mostraMensagem('Aguarde, Emitindo Cupom...', false);
      dtmMain.IBQuery1.Close;
      ShowMessage('Nota '+ nota_venda +' n�o encontrada');
      exit;
    end;

  dtmMain.IBQuery2.Close;
  dtmMain.IBQuery2.SQL.Text := 'select nome from vendedor where cod = :cod';
  dtmMain.IBQuery2.ParamByName('cod').AsString := dtmMain.IBQuery1.fieldbyname('vendedor').AsString;
  dtmMain.IBQuery2.Open;

  if not dtmMain.IBQuery2.IsEmpty then
    begin
      vendedor    := dtmMain.IBQuery1.fieldbyname('vendedor').AsString + ' - ' + dtmMain.IBQuery2.fieldbyname('nome').AsString;
      vendCaption := LeftStr(vendedor, 16);
    end
  else vendedor := '';  

  dtmMain.IBQuery2.Close;
  dtmMain.IBQuery2.SQL.Text := 'select nome, cnpj, ende from cliente where cod = :cod';
  dtmMain.IBQuery2.ParamByName('cod').AsString := dtmMain.IBQuery1.fieldbyname('cliente').AsString;
  dtmMain.IBQuery2.Open;

  try
    if not ecf.Device.Ativo then ecf.Ativar;
  except
    on e:exception do
      begin
        GravaLog(e.Message, 'LIN: 309', 'if not ecf.Device.Ativo then ecf.Ativar;');
        ShowMessage('Ocorreu um Erro:' + #13 + e.Message);
        exit;
      end;
  end;

  if dtmMain.IBQuery2.IsEmpty then
    begin
      ecf.TestaPodeAbrirCupom;
      ecf.AbreCupom('000.000.000-00', 'VENDA AO CONSUMIDOR', '');
    end
  else
    begin
      cnpj := dtmMain.IBQuery2.fieldbyname('cnpj').AsString;
      if StrNum(cnpj) = '0' then cnpj := '000.000.000-00';

      ecf.TestaPodeAbrirCupom;
      ecf.AbreCupom(cnpj, dtmMain.IBQuery2.fieldbyname('nome').AsString, dtmMain.IBQuery2.fieldbyname('ende').AsString);
    end;

  //aqui ja abriu cupom com ou sem os dados do cliente  

  dtmMain.IBQuery2.close;
  dtmMain.IBQuery2.SQL.Text := 'select i.unid,i.cod, iif(trim(i.codbar) = '''', ''112244'',i.codbar) as codbar, i.quant, i.p_venda, p.p_compra as compra, p.p_venda as venda, i.total, p.nome, a.aliq, a.cod as cod_aliq from item_venda i ' +
  '  left join produto p on (p.cod = i.cod) left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer)))' +
  ' where nota = :nota';
  dtmMain.IBQuery2.ParamByName('nota').AsString := nota_venda;
  dtmMain.IBQuery2.Open;

  tot_ge      := 0;
  TotTributos := 0;
  IBClientDataSet1.EmptyDataSet;
  dav := true;

  while not dtmMain.IBQuery2.Eof do
    begin
      Application.ProcessMessages;

      cod_aliq := dtmMain.IBQuery2.fieldbyname('cod_aliq').AsString;
      aliq     := Trim(dtmMain.IBQuery2.fieldbyname('aliq').AsString);
      if aliq = '' then aliq := '17,00';

      if cod_aliq = '10' then      aliq := 'FF'
      else if cod_aliq = '11' then aliq := 'II'
      else if cod_aliq = '12' then aliq := 'NN';

      try
        ecf.VendeItem(dtmMain.IBQuery2.fieldbyname('codbar').AsString, dtmMain.IBQuery2.FieldByName('nome').AsString, aliq, dtmMain.IBQuery2.FieldByName('quant').AsCurrency,
        dtmMain.IBQuery2.FieldByName('p_venda').AsCurrency, 0, dtmMain.IBQuery2.FieldByName('unid').AsString, '%');
      except
        on e:exception do begin
          GravaLog(e.Message, 'LIN: 360', 'ecf.VendeItem(');
          ShowMessage('Ocorreu um Erro:' + #13 + e.Message);
          exit;
        end;
      end;

      quant.setValor(dtmMain.IBQuery2.FieldByName('quant').AsCurrency);
      preco.setValor(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency);
      total.setValor(ArredondaPDV(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency * quant.getValor, 2));

      //TotTributos := TotTributos + (dtmMain.IBQuery2.FieldByName('total').AsCurrency * (StrToCurrDef(aliq, 0) / 100));
      //TotTributos := TotTributos + (((dtmMain.IBQuery2.FieldByName('venda').AsCurrency - dtmMain.IBQuery2.FieldByName('compra').AsCurrency) * dtmMain.IBQuery2.FieldByName('quant').AsCurrency) * (StrToCurrDef(form1.pgerais.Values['40'], 100) / 100));
      TotTributos := TotTributos + (((dtmMain.IBQuery2.FieldByName('venda').AsCurrency - dtmMain.IBQuery2.FieldByName('compra').AsCurrency) * dtmMain.IBQuery2.FieldByName('quant').AsCurrency) * (StrToCurrDef(form1.pgerais.Values['40'], 100) / 100));

      //ShowMessage(CurrToStr(dtmMain.IBQuery2.FieldByName('venda').AsCurrency)+#13 + CurrToStr(dtmMain.IBQuery2.FieldByName('compra').AsCurrency)+#13
      //+CurrToStr(dtmMain.IBQuery2.FieldByName('venda').AsCurrency - dtmMain.IBQuery2.FieldByName('compra').AsCurrency) + CurrToStr(TotTributos));

      PainelProduto.Caption := dtmMain.IBQuery2.fieldbyname('nome').AsString;


      tot_ge := tot_ge + ArredondaPDV(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency * dtmMain.IBQuery2.FieldByName('quant').AsCurrency, 2);
      //totalOrigi
      IBClientDataSet1.Append;
      IBClientDataSet1.FieldByName('codbar').AsString  := dtmMain.IBQuery2.fieldbyname('codbar').AsString;
      IBClientDataSet1.FieldByName('cod').AsString     := dtmMain.IBQuery2.fieldbyname('cod').AsString;
      IBClientDataSet1.FieldByName('nome').AsString    := copy(dtmMain.IBQuery2.fieldbyname('nome').AsString, 1, 40);
      IBClientDataSet1.FieldByName('preco').AsCurrency := dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency;
      IBClientDataSet1.FieldByName('quant').AsCurrency := quant.getValor;
      IBClientDataSet1.FieldByName('total').AsCurrency := ArredondaPDV(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency * dtmMain.IBQuery2.FieldByName('quant').AsCurrency, 2);
      IBClientDataSet1.FieldByName('totalOrigi').AsCurrency := IBClientDataSet1.FieldByName('total').AsCurrency;
      IBClientDataSet1.Post;
      IBClientDataSet1.Last;

      vendeVISUAL();

      PainelTotal.Caption := formataCurrency(tot_ge);

      dtmMain.IBQuery2.Next;
    end;


  //tot_ge   := tot_ge dtmMain.IBQuery1.fieldbyname('total').AsCurrency;
  recebido := 0;
  desconto := dtmMain.IBQuery1.fieldbyname('desconto').AsCurrency;
  tot_ge   := tot_ge + desconto;
  except
    on e:exception do
      begin
        GravaLog(e.Message, 'LIN: 408', 'ecf.VendeItem(');
        mostraMensagem('Aguarde, Emitindo Cupom...', false);
        MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
        exit;
      end;
  end;

  mostraMensagem('Aguarde, Emitindo Cupom...', false);
  fechaDav();
  finally
    TeclaEnter := true;
  end;


  {while true do
    begin
      receb := dialogoG('numero', 0, '', 2, false, '', 'PDV - ControlW', 'Informe o Valor Pago:', formataCurrency(tot_ge), true);
      if receb = '*' then exit;

      recebido := StrToCurr(receb);

      if recebido >= tot_ge then Break
       else ShowMessage('O valor n�o pode ser menor que o total da venda');
    end;

  codhis := lerFormasDePagamento(dtmmain.ibquery1, '', true, formaPagtoImpressora, indice);
  if codhis = '*' then exit;

  obs := 'Vlr Aprox. Tributos R$ ' + formataCurrency(TotTributos);

  ecf.SubtotalizaCupom(desconto, '');

  if (recebido + abs(desconto)) < ecf.Subtotal then recebido := ecf.Subtotal + (desconto);

  ecf.EfetuaPagamento(formaPagtoImpressora.Values[lerForma(codhis, 0)], recebido, '');
  ecf.FechaCupom(obs);

  try
   ecf.AbreGaveta;
  except
  end;


  mostraTroco();
  limpaVenda;

  codbar.Text := '';
  quant.Text := '1,000';

  crc := CompletaOuRepete('', ecf.NumCCF, '0', 6) + CompletaOuRepete('', IntToStr(StrToIntDef(ecf.NumECF, 1)), '0', 3);

  atualizaCRC(nota_venda, crc);}
end;

procedure TForm3.mostraTroco();
var
  troc : currency;
begin
 { formasPagamento.First;
  troc := 0;
  while not formasPagamento.Eof do
    begin
      troc := troc + formasPagamento.fieldbyname('total').AsCurrency;
      formasPagamento.Next;
    end;}

  PainelTotal.Caption := formataCurrency(recebido - tot_ge);
  Panel4.Caption      := 'TROCO';
end;

procedure TForm3.lancaDesconto(var desc1, tot_g : currency; ConfigUsuario, tipoDesc, acessoUsu : String; precoDefault : currency = 0; CalcularMinimoPrecoTotalOriginal : currency = 0);
var
  temp2, temp1, total31, minimo : currency;
  fim,desc : string;
begin
  minimo := IfThen(CalcularMinimoPrecoTotalOriginal <> 0, CalcularMinimoPrecoTotalOriginal, tot_g)
   - ArredondaPDV(((IfThen(CalcularMinimoPrecoTotalOriginal <> 0, CalcularMinimoPrecoTotalOriginal, tot_g) * StrToCurr(LerConfig(ConfigUsuario,0)))/100),2);
  ///desc1  := 0;

  if tipoDesc = 'S' then
    begin
      fim := '-999999';
      while true do// ((StrToCurr(fim) < minimo) or not(StrToCurr(fim) > tot_g)) do
        begin
          //dialogoG('numero', 0, '', 2, false, '', 'PDV - ControlW', 'Informe o Valor do Desconto:', '0,00', true);
          fim := dialogoG('numero',0,'', 2,false,'','Control for Windows:','Confirme o Valor Total (M�nimo '+FormatCurr('#,###,###0.00',minimo)+'):', FormatCurr('###,##0.00', IfThen(precoDefault <> 0,precoDefault, tot_g)), true);
          if fim = '*' then
            begin
              fim := CurrToStr(tot_g);
              break;
            end;

          temp1 := StrToCurrDef(fim, 0);
          if (ArredondaPDV(tot_g, 2) = ArredondaPDV(temp1, 2)) then
            begin
              break;
            end;

          if (((temp1 >= minimo) and (temp1 <= tot_g)) or (tot_g = temp1)) then
            begin
              break;
            end;

          if ((temp1 < minimo) and (length(acessoUsu) = 0)) then  break;
        end;

    desc1  := tot_g - StrToCurr(fim);
    tot_g := StrToCurr(fim);

    exit;
  end
 else if tipoDesc = 'N' then
   begin
     //verifica se foi dado desconto por item
     temp1 := StrToCurrDef(LerConfig(ConfigUsuario,0), 0);

     desc := '99999999';
     while StrToCurr(desc) > temp1 do
       begin
         desc := dialogoG('numero',0,'',2,false,'','Control for Windows:','Qual o Percentual de Desconto (M�ximo='+ FormatCurr('#,###,###0.00', temp1) +'%) (%)?:','0,00', true);
         if desc = '*' then
           begin
             desc := '0';
             break;
           end;

         if (StrToCurrDef(desc, 0) = temp1) then break;
         if ((StrToCurr(desc) > StrToCurr(LerConfig(ConfigUsuario,0))) and (length(acessoUsu) = 0)) then break;
    end;

  desc1 := ArredondaPDV((tot_g * StrToCurr(desc))/100,2);
  tot_g := tot_g - desc1;
  end;
{ else if ConfParamGerais.Strings[2] = 'X' then
   begin
     temp1 := StrToCurrDef(funcoes.LerConfig(form22.Pgerais.Values['configu'],0), 0);
     desc := '99999999';

     while StrToCurr(desc) > temp1 do
       begin
         desc := funcoes.ConverteNumerico(funcoes.dialogo('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Qual o Percentual de Desconto (M�ximo='+ FormatCurr('#,###,###0.00', temp1) +'%) (%)?:','0,00'));
         if desc = '*' then
            begin
              desc := '0';
              Break;
            end;
         if (StrToCurrDef(desc, 0) = temp1) then break;
         if ((StrToCurr(desc) = StrToCurr(funcoes.LerConfig(form22.Pgerais.Values['configu'],0))) or (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then break;
       end;

      desconto := Arredonda((total1 * StrToCurr(desc))/100,2);
      total1 := total1 - desconto;
      if StrToCurrDef(desc, 0) <> 0 then
        begin
          fim := '-999999';
          while true do //((StrToCurr(fim) < minimo) or not(StrToCurr(fim) > total1)) do
            begin
              fim := funcoes.ConverteNumerico(funcoes.dialogo('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Confirme o Valor Total (M�nimo '+FormatCurr('#,###,###0.00',minimo)+'):',FormatCurr('###,##0.00',total1)));

              if fim = '*' then
                begin
                  fim := CurrToStr(total1);
                  break;
                end;
              temp1 := StrToCurrDef(fim, 1);
              if ((temp1 >= minimo) and (temp1 <= total1)) then break;
              if ((StrToCurr(fim) < minimo) or (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then  break;
            end;
        end
      else fim := CurrToStr(total1);

      desconto := desconto + (total1 - StrToCurr(fim));
      total1 := StrToCurr(fim);
      desco.Caption := iif(desconto < 0, 'Acres', 'Desc')+' R$ '+FormatCurr('#,###,###0.00',desconto)+' R$ '+FormatCurr('#,###,###0.00', total1);

      mostraDesconto(total31, desconto, true);
    exit;
 end;
}
end;


procedure TForm3.limpaVenda();
begin
  RichEdit1.Clear;
  IBClientDataSet1.EmptyDataSet;
  quant.Text := '1,000';
  preco.Text := '0,00';
  total.Text := '0,00';
  codbar.Text := '';
  codbar.SetFocus;
  tot_ge   := 0;
  TotTributos := 0;
  desconto := 0;
  descontoItens := 0;
  recebido := 0;
  entrada  := 0;
  cupomAberto1 := false;
  clienteOBS  := '';

  configu        := form1.configu;
  acessoUsuVenda := form1.acesso;

  try
    formasP.Clear;
  except
  end;
end;

procedure TForm3.verProdutos();
begin
  busca(tibquery(IBClientDataSet1), '', 'RET01', '', '');
end;

function TForm3.gravaVenda() : boolean;
begin
  Result := false;
  //if dtmMain.IBQuery1.Transaction.InTransaction then dtmMain.IBQuery1.Transaction.Commit;
  //dtmMain.IBQuery1.Transaction.StartTransaction;

  crc := CompletaOuRepete('', ecf.NumCCF, '0', 6) + CompletaOuRepete('', IntToStr(StrToIntDef(codECF, 1)), '0', 3);
  nota_venda := Incrementa_Generator('venda', 1);

  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Clear;
  dtmMain.IBQuery1.SQL.Add('insert into venda(crc,ok,hora,vendedor,cliente,nota,data,total,codhis,desconto,prazo,entrada, EXPORTADO, USUARIO)'+
  ' values(:crc,:ok,:hora,:vend,:cliente,:nota,:data,:total,:pagto,:desc,:prazo,:entrada, :exportado, :USUARIO)');
  dtmMain.IBQuery1.ParamByName('crc').AsString         := crc;
  dtmMain.IBQuery1.ParamByName('ok').AsString          := 'S';
  dtmMain.IBQuery1.ParamByName('hora').AsTime          := now;
  dtmMain.IBQuery1.ParamByName('vend').AsString        := CodVendedorTemp;
  dtmMain.IBQuery1.ParamByName('cliente').AsInteger    := 0;
  dtmMain.IBQuery1.ParamByName('nota').AsString        := nota_venda;
  dtmMain.IBQuery1.ParamByName('data').AsDateTime      := now;
  dtmMain.IBQuery1.ParamByName('total').AsCurrency     := tot_ge;
  dtmMain.IBQuery1.ParamByName('pagto').AsString       := codhis;
  dtmMain.IBQuery1.ParamByName('desc').AsCurrency      := desconto;                                                                             //'+codhis+'
  dtmMain.IBQuery1.ParamByName('prazo').AsInteger      := 0;
  dtmMain.IBQuery1.ParamByName('entrada').AsCurrency   := entrada;
  dtmMain.IBQuery1.ParamByName('exportado').AsInteger  := 0;
  dtmMain.IBQuery1.ParamByName('USUARIO').AsString := form1.codUsuario;
  try
    dtmMain.IBQuery1.ExecSQL;
  Except
    on e : exception do
      begin
        MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
        dtmMain.IBQuery1.Transaction.Rollback;
        exit;
      end;
  end;

  IBClientDataSet1.First;
  while not IBClientDataSet1.Eof do
    begin
      //cod := ClientDataSet1CODIGO.AsString;

      if not Contido('** CANCELADO **', IBClientDataSet1nome.AsString) then
        begin
          dtmMain.IBQuery1.Close;
          dtmMain.IBQuery1.SQL.Clear;
          dtmMain.IBQuery1.SQL.Add('insert into item_venda(data,nota,COD, QUANT, p_venda,total,origem,p_compra,codbar,aliquota, unid) values(:data,'+nota_venda+',:cod, :quant, :p_venda,:total,1,:p_compra, :codbar,:aliq, :unid)');
          dtmMain.IBQuery1.ParamByName('data').AsDateTime    := now;
          dtmMain.IBQuery1.ParamByName('cod').AsString       := IBClientDataSet1cod.AsString;
          dtmMain.IBQuery1.ParamByName('quant').AsCurrency   := StrToCurr(IBClientDataSet1quant.AsString);
          dtmMain.IBQuery1.ParamByName('p_venda').AsCurrency := StrToCurr(IBClientDataSet1preco.AsString);
          dtmMain.IBQuery1.ParamByName('total').AsCurrency   := StrToCurr(IBClientDataSet1total.AsString);

          dtmMain.IBQuery2.Close;
          dtmMain.IBQuery2.SQL.Clear;
          dtmMain.IBQuery2.SQL.Add('select p_compra, aliquota, unid, codbar from produto where cod = '+IBClientDataSet1cod.AsString);
          dtmMain.IBQuery2.Open;

          dtmMain.IBQuery1.ParamByName('p_compra').AsCurrency := ArredondaPDV(StrToCurr(IBClientDataSet1quant.AsString) * dtmMain.IBQuery2.fieldbyname('p_compra').AsCurrency,2);
          dtmMain.IBQuery1.ParamByName('codbar').AsString     := dtmMain.IBQuery2.fieldbyname('codbar').AsString;
          dtmMain.IBQuery1.ParamByName('aliq').AsString       := copy(dtmMain.IBQuery2.fieldbyname('aliquota').AsString,1 ,2);
          dtmMain.IBQuery1.ParamByName('unid').AsString       := copy(dtmMain.IBQuery2.fieldbyname('unid').AsString,1,6);
          dtmMain.IBQuery2.Close;

          dtmMain.IBQuery1.ExecSQL;

          dtmMain.IBQuery1.SQL.Text := 'update produto set quant = quant - :quant where cod = :cod';
          dtmMain.IBQuery1.ParamByName('quant').AsCurrency := StrToCurr(IBClientDataSet1quant.AsString);
          dtmMain.IBQuery1.ParamByName('cod').AsString     := IBClientDataSet1cod.AsString;
          dtmMain.IBQuery1.ExecSQL;
        end;
        
      IBClientDataSet1.Next;
    end;

  //if dtmMain.IBQuery1.Transaction.InTransaction then dtmMain.IBQuery1.Transaction.Commit;
  try
    dtmMain.IBQuery1.Transaction.Commit;
  except
  end;
  Result := true;
end;

procedure TForm3.encerrarVenda(dialogo : boolean = true);
var
  sim, indx, timeout  : integer;
  desc, receb, statu, moti, obs, crc : String;
  totalTemp : currency;
  lista1 : TList;
begin
  if IBClientDataSet1.IsEmpty then exit;
  if dialogo then
    begin
      sim := MessageBox(Handle, 'Deseja Finalizar a Venda?', 'PDV - ControlW' ,MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON1);
      if sim = idno then exit;
    end;

  tot_ge   := somaTotalOriginal(true);
  tot1     := tot_ge;
  desconto := 0;

  if form1.pgerais.Values['37'] = 'S' then
    begin
      totalTemp := somaTotalOriginal();
      lancaDesconto(desconto, tot_ge, configu, form1.pgerais.Values['2'], acessoUsuVenda, 0, totalTemp);
      desconto := - desconto;
    end;


  desconto := desconto + descontoItens;
  //tot_ge := tot_ge + desconto;

  if lerReceido() = false then exit;
  {aki leu as formas de pagamento e preencheu o clientdataset com as formas
  de pagamento e totais}

  if formasPagamento.IsEmpty then exit;

  mostraMensagem('Aguarde, Finalizando Venda...', true);

  lerFormasParaGravarAVendaPreencheEntrada();
  {aki vai procura se tem a vista para preencher a variavel entrada e procura
  uma forma de pagamento que nao seja a vista e preenche codhis}


 if verificaValoresNulosFormaDePagamentosOK(tot_ge) = false then exit;

 if FileExists(ExtractFileDir(ParamStr(0)) + '\IBPT.csv') then
   begin
     criaListaDeItens(desconto, lista1);
     TotTributos := calculaVlrAproxImpostos(lista1);
   end;

  //ShowMessage(CurrToStr(TotTributos) + #13 + CurrToStr(tot_ge) + #13 + CurrToStr(TotTributos / tot_ge) + #13 + formataCurrency((TotTributos / tot_ge) * 100));
  obs := trim('Total Impostos Pagos R$' + formataCurrency(TotTributos) + '('+ formataCurrency((TotTributos / tot1) * 100) +'%)Fonte IBPT');
  //obs := 'Vlr Aprox. Tributos R$ ' + formataCurrency(TotTributos);
  mostraTroco();
  //mostraMensagem('Aguarde, Finalizando Venda...', true);

  aguardaECF();

  try
    ecf.SubtotalizaCupom(desconto, '');
  except
    on e:exception do
      begin
        MessageDlg('Erro1: ' + e.Message, mtError, [mbOK], 1);
        mostraMensagem('Aguarde, Finalizando Venda...', false);
      end;
  end;

  aguardaECF();

  try
   descarregaFormasDePagamentoImpressora();
  except
  end;

  {aqui vai imprimir as formas de pagamento na impressora pegando as formas do clientdataset}

  dtmMain.IBQuery2.Close;
  dtmMain.IBQuery2.SQL.Text := 'select cod,nome from vendedor where cod = :cod';
  dtmMain.IBQuery2.ParamByName('cod').AsString := CodVendedorTemp;
  dtmMain.IBQuery2.Open;

  if not dtmMain.IBQuery2.IsEmpty then
    begin
      vendedor := dtmMain.IBQuery2.fieldbyname('cod').AsString + ' - ' + dtmMain.IBQuery2.fieldbyname('nome').AsString;
    end
  else vendedor := '';
  dtmMain.IBQuery2.Close;

  aguardaECF();
  try
    //ecf.FechaCupom(obs + sLineBreak + 'PEDIDO: ' + trim(StrNum(nota_venda)) + sLineBreak + 'VENDEDOR: ' + copy(form1.vendedor + '-' + form1.NomeVend,1, 30));
    ecf.FechaCupom(obs + sLineBreak + 'VENDEDOR: ' + copy(vendedor,1, 30) + IfThen(clienteOBS <> '', sLineBreak + clienteOBS, ''));
  except
    on e:exception do
      begin
        MessageDlg('Erro2: ' + e.Message, mtError, [mbOK], 1);
        mostraMensagem('Aguarde, Finalizando Venda...', false);
        //exit;
      end;
  end;

  try
  if gravaVenda() then
    begin
      {FECHA NO CUPOM}

      //crc := CompletaOuRepete('', ecf.NumCCF, '0', 6) + CompletaOuRepete('', IntToStr(StrToIntDef(ecf.NumECF, 1)), '0', 3);
      //atualizaCRC(nota_venda, crc);

      {FECHA NO CUPOM}
    end
  else
    begin
      ecf.CancelaCupom;
      limpaVenda;
      exit;
    end;

  aguardaECF();
     
  if corte <> 'N' then
    begin
      try
        ecf.AbreGaveta;
      except
      end;
    end;

  finally
    mostraMensagem('Aguarde, Finalizando Venda...', false);
    limpaVenda;
  end;
end;

function TForm3.lerPesoBalanca() : currency;
var
  pastaControlw : String;
begin
  pastaControlw := ExtractFileDir(ParamStr(0)) + '\';
  try
    mostraMensagem('Aguarde, Lendo Balan�a...', true);
    dtmMain.ACBrBAL1.ArqLOG := pastaControlw + 'LOG_BAL.TXT';
    Result := 0;
    try
      if dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Desativar;
      dtmMain.ACBrBAL1.Device.Baud := 2400;
      dtmMain.ACBrBAL1.Porta := 'COM3';
      dtmMain.ACBrBAL1.Ativar;
      Result := dtmMain.ACBrBAL1.LePeso();
    except
      on e:exception do
        begin
          ShowMessage('Erro: ' + e.Message);
        end;
    end;
    if Result > 0 then
      begin
        quant.Text := FormatCurr('#,###,###0.000', Result);
        mostraMensagem('Aguarde, Lendo Balan�a...', false);
        pastaControlw := 'OFF';

        if codbar.Text = '' then
          begin
            codbar.Text := localizar2('Localizar Produto','produto p','p.codbar, P.COD, p.nome,p.quant, p.p_venda as preco ','codbar','cod','nome','nome',false,false,false, ' where (p.codbar like ' + QuotedStr('2%') + ' )', IBClientDataSet1cod.AsString,600 , codbar);
            {if codbar.Text <> '' then
              begin
                dtmMain.IBQuery1.Close;
                dtmMain.IBQuery1.SQL.Text := 'select codbar from produto where cod = :cod';
                dtmMain.IBQuery1.ParamByName('cod').AsInteger := StrToIntDef(codbar.Text, 0);
                dtmMain.IBQuery1.Open;
                codbar.Text := dtmMain.IBQuery1.fieldbyname('codbar').AsString;
                dtmMain.IBQuery1.Close;
              end;}
          end;
      end;
  finally
    if pastaControlw <> 'OFF' then mostraMensagem('Aguarde, Lendo Balan�a...', false);
  end;
end;


procedure TForm3.vendeVISUAL();
var
  i, fim : integer;
begin
  //IBClientDataSet1.Last;

  if RichEdit1.Items.Count = 0 then
    begin
      RichEdit1.Items.Add(CompletaOuRepete('', '', '-', 50));
      RichEdit1.Items.Add(centraliza(trim(form1.pgerais.Values['empresa']), ' ', 50));
      RichEdit1.Items.Add(CompletaOuRepete('', '', '-', 50));

      Panel4.Caption := 'TOTAL';
    end;

  RichEdit1.Items.Add(CompletaOuRepete('', IntToStr(IBClientDataSet1.RecNo), '0', 3) + '-' + CompletaOuRepete(IBClientDataSet1codbar.AsString, '', ' ', 15) + '  ' +CompletaOuRepete(copy(IBClientDataSet1nome.AsString, 1, 30), '', ' ', 30));
  RichEdit1.Items.Add(CompletaOuRepete('QTD => '+FormatCurr('#,###,###0.000',IBClientDataSet1.fieldbyname('quant').AsCurrency), '', ' ', 16) + CompletaOuRepete(' R$ '+formatacurrency(IBClientDataSet1preco.AsCurrency), '', ' ', 16) + CompletaOuRepete(' Total => '+formatacurrency(IBClientDataSet1total.AsCurrency), '', ' ', 20));

  SendMessage(RichEdit1.Handle, WM_VSCROLL, SB_BOTTOM, 0);

  i := RichEdit1.Items.Count -1;
  RichEdit1.Selected[i]    := true;
  RichEdit1.Selected[i -1] := true;

  RichEdit1.Selected[i - 3] := false;
  RichEdit1.Selected[i - 2] := false;

  //RichEdit1.SelectAll;
end;

procedure TForm3.vendeItem();
var
  aliq, cod_aliq : string;
  cont : integer;
  prodcodbar : TprodutoVendaCodBar;
  pesquisaCodbar : boolean;
begin
  if codbar.Text = '' then exit;

  //a variavel abaixo diz se vai pesquisa por codbar
  //se estiver false pesquisa pelo codigo
  pesquisaCodbar := true;

  if IBClientDataSet1.RecordCount = 0 then
    begin
      try
        if not ecf.Device.Ativo then ecf.Ativar;
      except
        on e:exception do
          begin
            ShowMessage('Ocorreu um Erro:' + #13 + e.Message);
            exit;
          end;
      end;

        ecf.TestaPodeAbrirCupom;
        //ecf.AbreCupom(dadosEmpresa.Values['cnpj'], dadosEmpresa.Values['empresa'], dadosEmpresa.Values['ende']);
        //ecf.AbreCupom('000.000.000-00', 'VENDA AO CONSUMIDOR', '');
        ecf.AbreCupom();
    end;

  if ((LeftStr(codbar.Text, 1) = '2') and (Length(codbar.Text) = 13)) then
    begin
      //prodcodbar     := le_codbar(dtmMain.IBQuery1, codbar.Text, form1.pgerais.Values['38'], balArredonda);
      prodcodbar     := le_codbar(dtmMain.IBQuery1, codbar.Text, form1.pgerais.Values['38'], form1.pgerais.Values['0']);
      if prodcodbar.codbar = '*' then
        begin
          ShowMessage('Produto n�o Encontrado');
          codbar.Text := '';
          prodcodbar.Free;
          exit;
        end;

      pesquisaCodbar := false;
    end;

  if pesquisaCodbar then
    begin
      dtmMain.IBQuery1.Close;
      dtmMain.IBQuery1.SQL.Text := ('select p.cod, p.nome, p.p_venda, p.codbar, a.aliq, a.cod as cod1 from produto p left join codbarras c on (c.cod = p.cod)'+
      ' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where  (p.codbar like '+QuotedStr( codbar.Text )+') or (c.codbar = '+QuotedStr( codbar.Text )+')');
      dtmMain.IBQuery1.Open;
    end
  else
    begin
      dtmMain.IBQuery1.Close;
      dtmMain.IBQuery1.SQL.Text := ('select p.cod, p.nome, p.p_venda, p.codbar, a.aliq, a.cod as cod1 from produto p left join codbarras c on (c.cod = p.cod)'+
      //' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where (p.codbar = '+ prodcodbar.codbar+')');
      ' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where (p.codbar = :cod)');
      dtmMain.IBQuery1.ParamByName('cod').AsString := prodcodbar.codbar;
      dtmMain.IBQuery1.Open;

      quant.Text := FormatCurr('#,###,###0.000', prodcodbar.quant);
      prodcodbar.Free;
    end;

  if dtmMain.IBQuery1.IsEmpty then
    begin
      dtmMain.IBQuery1.Close;
      ShowMessage('Produto N�o Encontrado');
      codbar.Text := '';
      exit;
    end;

  preco.setValor(dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency);
  total.setValor(ArredondaPDV(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency * quant.getValor, 2));

  cont := IBClientDataSet1.RecordCount + 1;
  IBClientDataSet1.Append;
  IBClientDataSet1.FieldByName('contador').AsInteger := cont;
  IBClientDataSet1.FieldByName('codbar').AsString    := codbar.Text;
  IBClientDataSet1.FieldByName('cod').AsString       := dtmMain.IBQuery1.fieldbyname('cod').AsString;
  IBClientDataSet1.FieldByName('nome').AsString      := copy(dtmMain.IBQuery1.fieldbyname('nome').AsString, 1, 40);
  IBClientDataSet1.FieldByName('preco').AsCurrency   := dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency;
  IBClientDataSet1.FieldByName('precoOrigi').AsCurrency   := dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency;
  IBClientDataSet1.FieldByName('quant').AsCurrency   := quant.getValor;
  IBClientDataSet1.FieldByName('total').AsCurrency   := ArredondaPDV(dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency * quant.getValor, 2);
  IBClientDataSet1.FieldByName('totalOrigi').AsCurrency := IBClientDataSet1.FieldByName('total').AsCurrency;
  IBClientDataSet1.Post;
  IBClientDataSet1.Last;

  tot_ge := tot_ge + IBClientDataSet1total.AsCurrency;

  PainelProduto.Caption := dtmMain.IBQuery1.fieldbyname('nome').AsString;

  cod_aliq := dtmMain.IBQuery1.fieldbyname('cod1').AsString;
  aliq     := Trim(dtmMain.IBQuery1.fieldbyname('aliq').AsString);
  if aliq = '' then aliq := '17,00';

  if cod_aliq = '10' then aliq := 'FF'
  else if cod_aliq = '11' then aliq := 'II'
  else if cod_aliq = '12' then aliq := 'NN';

  try
    ecf.VendeItem(IBClientDataSet1.FieldByName('codbar').AsString, IBClientDataSet1.FieldByName('nome').AsString, aliq, IBClientDataSet1.FieldByName('quant').AsCurrency,
    IBClientDataSet1.FieldByName('preco').AsCurrency, 0, 'UN', '%');
  except
    on e:exception do
      begin
        MessageDlg(e.Message, mtError, [mbOK], 0);
        IBClientDataSet1.Delete;
        exit;
      end;
  end;

  TotTributos := TotTributos + (IBClientDataSet1.FieldByName('total').AsCurrency * (StrToCurrDef(aliq, 0) / 100));

  vendeVISUAL();

  dtmMain.IBQuery1.Close;

  PainelTotal.Caption := FormatCurr('#,###,###0.00', tot_ge); //FormatCurr('#,###,###0.00', StrToCurr(IBClientDataSet1p_total.AsString));

  codbar.Text := '';
  quant.Text := '1,000';
end;

procedure TForm3.vendeItemFila(const codbar1 : string);
var
  aliq, cod_aliq, cbar, VEND, preco1, qutd : string;
  cont : integer;
  prec : currency;
  prodcodbar : TprodutoVendaCodBar;
  pesquisaCodbar : boolean;
begin
  if quant.getValor > 999 then
    begin
      MessageDlg('Quantidade Inv�lida!', mtError, [mbOK], 1);
      quant.SetFocus;
      exit;
    end;

  try
  vendendoECF := true;
  cbar := codbar1;
  if cbar = '' then exit;
  //a variavel abaixo diz se vai pesquisa por codbar
  //se estiver false pesquisa pelo codigo
  pesquisaCodbar := true;

  if IBClientDataSet1.RecordCount = 0 then
    begin
      try
        if not ecf.Device.Ativo then ecf.Ativar;
      except
        on e:exception do
          begin
            ShowMessage('Ocorreu um Erro:' + #13 + e.Message);
            exit;
          end;
      end;

      //if ecf.Estado = estLivre then
      //  begin
          if not cupomAberto1 then
            begin
              if form1.vendedor = '0' then
                begin
                  while true do
                    begin
                      VEND := '';
                      IF Length(trim(CodVendedorTemp)) > 0 then
                        begin
                          VEND := 'cod';
                        end;

                      //localizar1('Localizar Produto','produto','cod, nome,quant, p_venda as preco ','cod','','nome','nome',false,false,false, 'cod', IBClientDataSet1cod.AsString,600 ,sender);
                      CodVendedorTemp := localizar1('Localizar Vendedor','vendedor','cod,nome','cod','','nome','nome',false,false,false,vend, IfThen(StrNum(CodVendedorTemp) = '0', '', StrNum(CodVendedorTemp)), 300,nil);
                      if CodVendedorTemp = '*' then exit;
                      if StrNum(CodVendedorTemp) <> '0' then Break;
                    end;
                end;

              dtmMain.IBQuery1.Close;
              dtmMain.IBQuery1.SQL.Text := 'select nome from vendedor where cod =:cod';
              dtmMain.IBQuery1.ParamByName('cod').AsString := StrNum(CodVendedorTemp);
              dtmMain.IBQuery1.Open;

              NomeVendedorTemp := dtmMain.IBQuery1.fieldbyname('nome').AsString;

              vendCaption := CodVendedorTemp + '-' + NomeVendedorTemp;
              vendCaption := LeftStr(vendCaption, 15);
              dtmMain.IBQuery1.Close;

              ecf.TestaPodeAbrirCupom;
              ecf.AbreCupom();
              cupomAberto1 := true;
            end;  
      //  end;
    end;

  if ((LeftStr(cbar, 1) = '2') and (Length(cbar) = 5) and (balOnline) and (vendeuf2 = false)) then
    begin
      abreLocalizaPesagem := false;
      Button1Click(self);
      if utiLeituraBalanca < 0  then exit;
    end;

  //if ((LeftStr(cbar, 1) = '2') and (Length(cbar) = 13) and (dtmMain.ACBrBAL1.Modelo <> balnenhum)) then
  if ((LeftStr(cbar, 1) = '2') and (Length(cbar) = 13) and (balOnline)) then
    begin
      prodcodbar     := le_codbar(dtmMain.IBQuery2, cbar, form1.pgerais.Values['38']);
      if prodcodbar.codbar = '*' then
        begin
          ShowMessage('Produto n�o Encontrado1');
          prodcodbar.Free;
          exit;
        end;

      pesquisaCodbar := false;
    end;

  if pesquisaCodbar then
    begin
      dtmMain.IBQuery2.Close;
      dtmMain.IBQuery2.SQL.Text := ('select p.cod, p.nome, p.p_compra, p.p_venda, p.codbar, a.aliq, a.cod as cod1 from produto p '+
      ' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where  (p.codbar = '+QuotedStr( cbar )+') ');
      dtmMain.IBQuery2.Open;
    end
  else
    begin
      dtmMain.IBQuery2.Close;
      dtmMain.IBQuery2.SQL.Text := ('select p.cod, p.p_compra, p.nome, p.p_venda, p.codbar, a.aliq, a.cod as cod1 from produto p left join codbarras c on (c.cod = p.cod)'+
      //' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where (p.codbar = '+ prodcodbar.codbar+')');
      ' left join aliq a on (a.cod = iif(trim(p.aliquota) = '''', 2, cast(p.aliquota as integer))) where (p.codbar like :cod)');
      dtmMain.IBQuery2.ParamByName('cod').AsString := prodcodbar.codbar + '%';
      dtmMain.IBQuery2.Open;

      quant.Text := FormatCurr('#,###,###0.000', prodcodbar.quant);
    end;

  if dtmMain.IBQuery2.IsEmpty then
    begin
      dtmMain.IBQuery2.Close;
      ShowMessage('Produto N�o Encontrado');
      exit;
    end;
    
  if dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency = 0 then
    begin
      vendendoECF := false;
      MessageDlg('O Pre�o do Produto '+ copy(dtmMain.IBQuery2.fieldbyname('nome').AsString, 1, 40) +' pode ser 0', mtError, [mbOK], 1);
      exit;
    end;

  PainelProduto.Caption := dtmMain.IBQuery2.fieldbyname('nome').AsString;

  //prec := buscaPreco(dtmMain.IBQuery2.fieldbyname('cod').AsInteger, quant.getValor);
  prec := dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency;
  qutd := currtostr(quant.getValor);
  preco.setValor(prec);
  preco1 := CurrToStr(prec);
  preco1 := confirmaPrecoProduto(dtmMain.IBQuery2.fieldbyname('cod').Asstring, qutd, preco1, 1, false);
  if preco1 = '*' then exit;

  prec := strtocurr(preco1);

  preco.setValor(prec);
  total.setValor(ArredondaPDV(prec * quant.getValor, 2));

  //preco.setValor(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency);
  //total.setValor(ArredondaPDV(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency * quant.getValor, 2));

  cont := IBClientDataSet1.RecordCount + 1;
  IBClientDataSet1.Append;
  IBClientDataSet1.FieldByName('contador').AsInteger := cont;
  IBClientDataSet1.FieldByName('codbar').AsString    := cbar;
  IBClientDataSet1.FieldByName('cod').AsString       := dtmMain.IBQuery2.fieldbyname('cod').AsString;
  IBClientDataSet1.FieldByName('nome').AsString      := copy(dtmMain.IBQuery2.fieldbyname('nome').AsString, 1, 40);
  IBClientDataSet1.FieldByName('preco').AsCurrency   := prec;
  IBClientDataSet1.FieldByName('precoOrigi').AsCurrency   := dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency;
  IBClientDataSet1.FieldByName('quant').AsCurrency   := quant.getValor;
  //IBClientDataSet1.FieldByName('total').AsCurrency   := IfThen(pesquisaCodbar = false ,prodcodbar.precoTemp, arredonda(dtmMain.IBQuery2.fieldbyname('p_venda').AsCurrency * quant.getValor, 2));
  IBClientDataSet1.FieldByName('total').AsCurrency   := total.getValor;
  IBClientDataSet1.FieldByName('totalOrigi').AsCurrency := IBClientDataSet1.FieldByName('total').AsCurrency;
  IBClientDataSet1.Post;
  IBClientDataSet1.Last;

  tot_ge := tot_ge + IBClientDataSet1total.AsCurrency;
  if not pesquisaCodbar then
    begin
      prodcodbar.Free;
    end;

  //PainelProduto.Caption := dtmMain.IBQuery2.fieldbyname('nome').AsString;

  cod_aliq := dtmMain.IBQuery2.fieldbyname('cod1').AsString;
  aliq     := Trim(dtmMain.IBQuery2.fieldbyname('aliq').AsString);
  if aliq = '' then aliq := '17,00';

  if cod_aliq = '10' then aliq := 'FF'
  else if cod_aliq = '11' then aliq := 'II'
  else if cod_aliq = '12' then aliq := 'NN';

  try
    ecf.VendeItem(IBClientDataSet1.FieldByName('codbar').AsString, IBClientDataSet1.FieldByName('nome').AsString, aliq, IBClientDataSet1.FieldByName('quant').AsCurrency,
    IBClientDataSet1.FieldByName('preco').AsCurrency, 0, 'UN', '%');
  except
    on e:exception do
      begin
        MessageDlg(e.Message, mtError, [mbOK], 0);
        IBClientDataSet1.Delete;
        exit;
      end;
  end;

  TotTributos := TotTributos + (((dtmMain.IBQuery2.FieldByName('p_venda').AsCurrency - dtmMain.IBQuery2.FieldByName('p_compra').AsCurrency) * IBClientDataSet1.FieldByName('quant').AsCurrency) * (StrToCurrDef(form1.pgerais.Values['40'], 100) / 100));

  vendeVISUAL();
  vendeuf2 := false;

  dtmMain.IBQuery2.Close;

  PainelTotal.Caption := FormatCurr('#,###,###0.00', tot_ge); //FormatCurr('#,###,###0.00', StrToCurr(IBClientDataSet1p_total.AsString));

  quant.Text := '1,000';
  finally
    vendendoECF := false;
  end;
end;

procedure tform3.alinhaComponentes();
var
  wi, he, tmp1 : integer;
begin
  wi := Screen.Width;
  he := Screen.Height;

  { if (wi >= 800) and (wi <= 1024) then
    begin
      PainelProduto.Font.Size := 20;
    end;}
  //PainelProduto.Left := trunc((wi/2) - (PainelProduto.Width /2));
  tmp1 := trunc( wi * 0.1);
  PainelProduto.Width := wi - tmp1;
  tmp1 := trunc(tmp1 / 2);
  PainelProduto.Left := tmp1;

  PainelTotal.Left := quant.Left;

  PainelTotal.Top   := he - PainelTotal.Height - 20;
  PainelTotal.Width := quant.Width;


  Panel2.Top      := he - Panel2.Height - 20;

  Panel2.Left  := (PainelTotal.Left + PainelTotal.Width) + 10;
  Panel2.Width := (wi - Panel2.Left) - 20;

  RichEdit1.Left := (wi - RichEdit1.Width) - 30;
      if RichEdit1.Left < (codbar.Left + codbar.Width) then
        begin
          tmp1 := wi - (codbar.Left + codbar.Width) -30;
          RichEdit1.Width := tmp1;
          RichEdit1.Left := (wi - RichEdit1.Width) - 15;
          RichEdit1.Font.Size := RichEdit1.Font.Size - 3;
        end;

      if Panel2.Top < (RichEdit1.Top + RichEdit1.Height) then
        begin
          RichEdit1.Height := (Panel2.Top - RichEdit1.Top) - 15;
        end;

      if PainelTotal.Top < (total.Top + total.Height) then
        begin
          LabelCodBar.Top := PainelProduto.Top + PainelProduto.Height + 7;
          codbar.Top      := LabelCodBar.Top + LabelCodBar.Height + 3;

          LabelQuantidade.Top := codbar.Top + codbar.Height + 7;
          quant.Top := LabelQuantidade.Top + LabelQuantidade.Height + 3;

          labelpreco.Top := quant.Top + quant.Height + 7;
          preco.Top      := labelpreco.Top + labelpreco.Height + 3;

          LabelTotal.Top := preco.Top + preco.Height + 7;
          total.Top      := LabelTotal.Top + LabelTotal.Height + 3;

          PainelTotal.Top := he - PainelTotal.Height - 5;
          PainelTotal.Font.Size := PainelTotal.Font.Size - 8;
        end;

  PainelTotal.Font.Size := PainelTotal.Font.Size - 8;

  Panel4.Width := PainelTotal.Width;
  Panel4.Top := PainelTotal.Top - Panel4.Height;
  Panel4.Left := PainelTotal.Left;

  codbar.Top  := LabelCodBar.Top + LabelCodBar.Height;
  codbar.Left := LabelCodBar.Left;
  codbar.Width := quant.Width;

  RichEdit1.Top := PainelProduto.Top + PainelProduto.Height + 20;

  PainelCaixa1.Top    := RichEdit1.Top + RichEdit1.Height;
  PainelCaixa1.Left   := RichEdit1.Left;
  PainelCaixa1.Width  := RichEdit1.Width;
  PainelCaixa1.Height := Panel2.Top - (RichEdit1.Top + RichEdit1.Height);
  if wi >= 1024 then
    begin
      PainelCaixa.Font.Size := 20;
    end;

  if (wi = 1024) then
    begin
      RichEdit1.Font.Size := 12;
    end;

  ///PainelCaixa.Caption := 'VENDEDOR: ' + CompletaOuRepete('', CodVendedorTemp, '0', 2) + '-'  NomeVendedorTemp;

  self.Repaint;
  self.Refresh;
end;

procedure TForm3.FormShow(Sender: TObject);
var
  indxImp, velo : integer;
  erro : boolean;
  //porta, porta1, velobal, tipobal, portabal, intervalo   : String;
begin
 PainelCaixa.Caption := '';
 erro := false;
 mostraMensagem('Aguarde, Conectando ECF...', true);

 vendeuf2 := false;

 cupomAberto1 := false;
 setaCoresPDV();
 screen.Cursor := crHourGlass;
 acessoUsuVenda := form1.acesso;
 configu        := form1.configu;
 alinhaComponentes();
 ecf := dtmMain.ACBrECF1;

 ecf.AguardaImpressao := true;
 ecf.ComandoLOG       := ExtractFileDir(ParamStr(0)) + '\logECF.txt';

 if ecf.Device.Ativo then ecf.Desativar;

 setParametrosACBrECF1(dtmMain.ACBrECF1, dtmMain.ACBrBAL1, arq);
 corte := arq.Values['usarDLL'];
 balArredonda := arq.Values['BalArredondamento'];
 if balArredonda = '' then balArredonda := 'T';

 if arq.Values['balancaOnline'] = 'S' then balOnline := true
   else balOnline := false;

 abreLocalizaPesagem := true;

  TimerVenda.Interval := StrToIntDef(form1.intervaloVenda, 200);
  try
    if inicio = 1 then
      begin
        criaDataSetFormas;
        inicio := 0;
        TotTributos := 0;
        if (ecf.Modelo <> ecfNenhum)  then begin
          if not ecf.Device.Ativo then ecf.Ativar;
        end;

        try
          if ecf.Device.Ativo then begin
            codECF := ecf.NumECF;
            indice := ecf.FormasPagamento[0].Indice;
            if ecf.Estado = estVenda then ecf.CancelaCupom;
            ecf.IdentificaPAF('AUTOCOM ECF V.1.0.0', '1D6697113DDAF45B34F0394278024901');
          end;
        except
          screen.Cursor := crDefault;
          exit;
        end;
      end;
  except
    on e:exception do
      begin
        erro := true;
        ShowMessage('ERRO: ' + e.Message);
        mostraMensagem('Aguarde, Conectando ECF...', false);
        screen.Cursor := crDefault;
      end;
  end;

  if screen.width = 800 then nomesajuda.Caption := 'F2-Ler Balan�a/F3-Cancela Item/F4-Troca Usu�rio/F5-Consulta Por Nome'+ #13 +
                                                   'F6-Cancelar Venda/F7-Gaveta/F8-Ind. Cliente/F9-DAV/F11-Menu Fiscal/F12-Consultar Por C�d. Barras'+#13+'/Vendedor: ' + form1.vendedor + '-' + form1.NomeVend
  else  nomesajuda.Caption := 'F2-Ler Balan�a/F3-Cancela Item/F4-Troca Usu�rio/F5-Consulta Por Nome/F6-Cancelar/F7-Gaveta'+#13+'/F8-Ind. Cliente/F9-DAV/F11-Menu Fiscal/F12-Consultar Por C�d. Barras/Vendedor: ' + form1.vendedor + '-' + form1.NomeVend ;
  RichEdit1.Clear;

  panel2.Caption := '';
  IBClientDataSet1.CreateDataSet;
  limpaVenda();
  screen.Cursor := crDefault;
  quant.Text := '1,000';
  if StrToIntDef(arq.Values['tamFontVisual'], 0) > 0 then RichEdit1.Font.Size := StrToIntDef(arq.Values['tamFontVisual'], 0);
  if erro = false then mostraMensagem('Aguarde, Conectando ECF...', false);

end;

procedure TForm3.codbarKeyPress(Sender: TObject; var Key: Char);
var
 cbar : String;
 sim  : integer;
begin
  if key = #13 then begin
    if TeclaEnter = false then begin
      exit;
    end;
  end;

  if key = '*' then
    begin
      key := #0;
      quant.SetFocus;
      exit;
    end;

  Timer1.Enabled := false;
  Timer1.Enabled := true;

  if key = #13 then
    begin
      if codbar.Text = '' then
        begin
          //aguardaECF;
          if TimerVenda.Enabled = true then
            begin
              ShowMessage('Aguarde, ECF ocupado');
              exit;
            end;

          key := #0;
          if IBClientDataSet1.IsEmpty then
            begin
              exit;
            end;

          sim := MessageDlg('Deseja Finalizar a Venda?', mtConfirmation, [mbYes, mbNo], 1);
          if sim = idno then exit;

          if IBClientDataSet1.IsEmpty then
            begin
              ShowMessage('N�o existe produtos para gravar');
              exit;
            end;

          if dav then
            begin
              fechaDav();
              exit;
            end;

          encerrarVenda(false);
        end;

      ACBrLCB1.Fila.Add(codbar.Text);
      codbar.Text := '';
      codbar.SetFocus;
      TimerVenda.Enabled := true;
      //vendeItem();
      Abort;
      exit;
    end;

  if key = #27 then
    begin
      if IBClientDataSet1.IsEmpty then
        begin
          close;
          exit;
        end;
    end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  try
  TeclaEnter := true;
  inicio := 1;
  tot_ge := 0;
  ECF := dtmMain.ACBrECF1;

  dadosEmpresa := TStringList.Create;
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select cnpj, empresa, ende from registro';
  dtmMain.IBQuery1.Open;

  dadosEmpresa.Values['cnpj']    := dtmMain.IBQuery1.fieldbyname('cnpj').AsString;
  dadosEmpresa.Values['empresa'] := dtmMain.IBQuery1.fieldbyname('empresa').AsString;
  dadosEmpresa.Values['ende']    := dtmMain.IBQuery1.fieldbyname('ende').AsString;
  dtmMain.IBQuery1.Close;

  formasP       := TStringList.Create;
  desconto      := 0;
  descontoItens := 0;
  CodVendedorTemp := form1.vendedor;
  except
  end;
  //criaDataSetFormas;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  if not IBClientDataSet1.IsEmpty then
    begin
      exit;
    end;

  protecaoDeTela;
  Timer1.Enabled := true;
end;

procedure TForm3.RichEdit1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  RichEdit1.Canvas.Brush.Color := clRed;
end;

procedure TForm3.codbarKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  log : boolean;
  acessoUsu, codbar, cod : String;
begin
  if (Key = 114) then //F3
    begin
      verProdutos();
      exit;
    end;

  if (Key = 119) then //F7
    begin
       identificaCliente(clienteOBS);
    end;

  if (Key = 115) then //F4
    begin
      form53.login_muda_as_variaveis_de_usuario(log, acessoUsu, codbar, configu);
      if log then
        begin
          if length(acessoUsu) > 3 then cod := 'Acesso Negado Por Login de Usu�rio com Bloqueios: ' + codbar
            else
              begin
                cod := 'Acesso Permitido de: ' + codbar;
                acessoUsuVenda := acessoUsu;
              end;
          ShowMessage(cod);
        end;

      exit;
    end;

  if (Key = 113) then //F2
    begin
      vendeuf2 := true;
      Button1Click(sender);
      vendeuf2 := false;
      //lerPesoBalanca();
      exit;
    end;

  if (Key = 120) then //F9
    begin
      emiteDAV();
    end;

  if (Key = 121) then //F10'
    begin
      emiteDAV(true);
    end;

  if (Key = 122) then //F11
    begin
      form9 := tform9.Create(self);
      form9.ShowModal;
      form9.Free;
    end;

  if (Key = 123) then //F12
    begin
      form10 := tform10.Create(self);
      form10.ShowModal;
      form10.Free;
    end;

  if (Key = 118) then //F7
    begin
      //MessageDlg('Usu�rio bloqueado para Cancelamento de Venda', mtError, [mbOK], 1);
      if Length(acessoUsuVenda) > 2 then
        begin
          MessageDlg('Usu�rio bloqueado para Cancelamento de Venda', mtError, [mbOK], 1);
          exit;
        end;

      ecf.AbreGaveta;
      configu        := form1.configu;
      acessoUsuVenda := form1.acesso;
    end;    

  if (Key = 117) then //F6
    begin

      if Length(acessoUsuVenda) > 2 then
        begin
          MessageDlg('Usu�rio bloqueado para Cancelamento de Venda', mtError, [mbOK], 1);
          exit;
        end;

      if MessageBox(Handle, 'Deseja Cancelar esta Venda?', 'PDV - ControlW' ,MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 ) = idyes then
        begin
          cancelaVenda();
        end;
      exit;
    end;

  if (Key = 116) then //F5
    begin
      tedit(sender).Text := localizar1('Localizar Produto','produto','cod, nome,quant, p_venda as preco ','cod','','nome','nome',false,false,false, 'cod', IBClientDataSet1cod.AsString,600 ,sender);
      if tedit(sender).Text <> '' then
        begin
          dtmMain.IBQuery1.Close;
          dtmMain.IBQuery1.SQL.Text := 'select codbar from produto where cod = :cod';
          dtmMain.IBQuery1.ParamByName('cod').AsInteger := StrToIntDef(tedit(sender).Text, 0);
          dtmMain.IBQuery1.Open;
          tedit(sender).Text := dtmMain.IBQuery1.fieldbyname('codbar').AsString;
          dtmMain.IBQuery1.Close;
        end;
      exit;  
    end;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not IBClientDataSet1.IsEmpty then
    begin
      if MessageBox(Handle, 'Existe uma Venda Aberta, Deseja Cancelar esta Venda e Sair?', 'PDV - ControlW' ,MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 ) = idno then abort
        else
          begin
            dtmMain.ACBrECF1.CancelaCupom;
            IBClientDataSet1.EmptyDataSet;
            RichEdit1.Clear;
            //JsEdit.LiberaMemoria(self);
          end;
    end;
  //else  ;;JsEdit.LiberaMemoria(self);

//  formasPagamento.Free;
end;

procedure TForm3.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if quant.Focused then exit;
  if not codbar.Focused then codbar.SetFocus;
end;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if quant.Focused then exit;
  if not codbar.Focused then codbar.SetFocus;
end;

procedure TForm3.fechaDav();
var
  fechou : boolean;
begin
  fechou := false;
  {a funcao ler os valores recebido por forma de pagamento e preenche o clientdataset}
  if not lerReceido() then exit;

  mostraMensagem('Aguarde, Finalizando Venda...', true);

  obs := trim('Total Impostos Pagos R$' + formataCurrency(TotTributos) + '('+ formataCurrency((TotTributos / tot_ge) * 100) +'%)Fonte IBPT');
  mostraTroco();

  aguardaECF();

  try
    ecf.SubtotalizaCupom(desconto, '');
  except
    on e:exception do
      begin
        GravaLog(e.Message, 'LIN: 1679', 'ecf.SubtotalizaCupom(desconto, );');
        mostraMensagem('Aguarde, Emitindo Cupom...', false);
        MessageDlg('Erro: ' + e.Message, mtError, [mbOK], 1);
        exit;
      end;
  end;

  aguardaECF();

  descarregaFormasDePagamentoImpressora();
  {aqui vai imprimir as formas de pagamento na impressora pegando as formas do clientdataset}

  aguardaECF();
 try
  ecf.FechaCupom(obs + sLineBreak + 'PEDIDO: ' + trim(StrNum(nota_venda)) + sLineBreak + 'VENDEDOR: ' + vendedor);
 except
   mostraMensagem('Aguarde, Finalizando Venda...', false);
   fechou := true;
 end;

  if corte <> 'N' then
    begin
      try
        aguardaECF();
        ecf.AbreGaveta;
      except
      end;
    end;

  //mostraTroco();
  limpaVenda;

  codbar.Text := '';
  quant.Text := '1,000';

  crc := CompletaOuRepete('', ecf.NumCCF, '0', 6) + CompletaOuRepete('', IntToStr(StrToIntDef(codECF, 1)), '0', 3);

  atualizaCRC(nota_venda, crc);
  dav := false;

  aguardaECF();

  if not fechou then mostraMensagem('Aguarde, Finalizando Venda...', false);
end;

procedure TForm3.quantKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then codbar.SetFocus;
end;

procedure TForm3.Button1Click(Sender: TObject);
var
  key : char;
  erro1 : smallint;
  nomeTemp : String;
begin
  if dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Desativar;
  dtmMain.ACBrBAL1.Modelo := balToledo;
  //dtmMain.ACBrBAL1.Device.Baud := 2400;
  dtmMain.ACBrBAL1.Device.Baud := 2400;
  dtmMain.ACBrBAL1.Porta := arq.Values['portabal'];
  dtmMain.ACBrBAL1.Ativar;

  dtmMain.IBQuery3.Close;
  dtmMain.IBQuery3.SQL.Text := 'select nome from produto where codbar = :cod';
  dtmMain.IBQuery3.ParamByName('cod').AsString := codTemp;
  dtmMain.IBQuery3.Open;
  nomeTemp := dtmMain.IBQuery3.fieldbyname('nome').AsString;
  dtmMain.IBQuery3.Close;
  erro1 := 0;

  PainelProduto.Caption := 'Lendo Balan�a...';
  codbar.Enabled := false;

  mostraMensagem(nomeTemp + #13 + 'Peso Balan�a: 0,000', true);
  try
  while true do
    begin
      if erro1 > 25 then
        begin
          MessageDlg('Comunica��o com a Balan�a Inst�vel', mtError, [mbOK], 1);
          quant.Text := '1,000';
          utiLeituraBalanca := -1;
          codbar.Enabled := true;
          //mostraMensagem('Peso Balan�a: 0,000', false);
          exit;
        end;

      quant.Text := FormatCurr('#,###,###0.000', dtmMain.ACBrBAL1.LePeso());

      if quant.getValor = -9 then
        begin
          quant.Text := '1,000';
          utiLeituraBalanca := -9;
          MessageDlg('Comunica��o com a Balan�a n�o dispon�vel', mtError, [mbOK], 1);
          quant.SetFocus;
          codbar.Enabled := true;
          //mostraMensagem('Peso Balan�a: 0,000', false);
          exit;
        end;

      if quant.getValor > 0 then
        begin
          utiLeituraBalanca := quant.getValor;
          mensagem.Label1.Caption := nomeTemp + #13 + 'Peso Balan�a: ' + quant.Text;
          mensagem.Label1.Refresh;
          mensagem.Label1.Repaint;
          sleep(1000);
          codbar.Enabled := true;
          Break;
        end;

      {if quant.getValor < 0 then
        begin
          quant.Text := '1,000';
          exit;
        end;}

      Sleep(200);
      erro1 := erro1 + 1;  
    end;
  finally
    codbar.Enabled := true;
    PainelProduto.Caption := '';
    mostraMensagem('Peso Balan�a: ' + quant.Text, false);
  end;

 if not abreLocalizaPesagem then
   begin
     abreLocalizaPesagem := true;
     exit;
   end;

  if codbar.Text = '' then
    begin
      codbar.Text := localizar2('Localizar Produto','produto p','p.codbar, P.COD, p.nome,p.quant, p.p_venda as preco ','codbar','cod','nome','nome',false,false,false, ' where (p.codbar like ' + QuotedStr('2%') + ' )', IBClientDataSet1cod.AsString,600 , codbar);
    end
  else
    begin
      key := #13;
      codbarKeyPress(sender, key);
    end;

  exit;
  codbar.Text := '2006900005808';
  key := #13;
  codbarKeyPress(sender, key);
end;

function TForm3.lerReceido() :boolean;
var
  totTemp1, totTemp2 : currency;
begin
  mostraMensagem('Aguarde...', true);
  recebido := 0;
  Result := false;
  formasPagamento.EmptyDataSet;
  {totTemp2 := ecf.Subtotal + desconto;

  {if tot_ge < totTemp2 then
    begin
      totTemp1 := totTemp2;
    end
  else totTemp1 := tot_ge;}
  totTemp1 := tot_ge;

  mostraMensagem('Aguarde...', false);

  while true do
    begin
      receb := dialogoG('numero', 0, '', 2, false, '', 'PDV - ControlW', 'Informe o Valor Pago:', formataCurrency(totTemp1 - recebido), true);
      if receb = '*' then
        begin
          formasPagamento.EmptyDataSet;
          exit;
        end;  

      recebido := recebido + StrToCurr(receb);

      codhis := lerFormasDePagamento(dtmmain.ibquery1, '', true, formaPagtoImpressora, indice);
      if codhis = '*' then
        begin
          formasPagamento.EmptyDataSet;
          exit;
        end;

      codhis := lerForma(codhis, 0);
      if formasPagamento.FindKey([codhis]) then
        begin
          formasPagamento.Edit;
          formasPagamento.FieldByName('total').AsCurrency := formasPagamento.FieldByName('total').AsCurrency + StrToCurr(receb);
          formasPagamento.Post;
        end
      else
        begin
          formasPagamento.Insert;
          formasPagamento.FieldByName('cod').AsString     := codhis;
          formasPagamento.FieldByName('indImp').AsString  := formaPagtoImpressora.Values[codhis];
          formasPagamento.FieldByName('total').AsCurrency := StrToCurr(receb);
          formasPagamento.Post;
        end;

      if ((recebido >= totTemp1) or (ArredondaPDV(totTemp1 - recebido, 2) <= 0)) then
        begin
          Result := true;
          break;
        end;
    end;

  if recebido - totTemp1 > 10000 then
    begin
      Result := false;
      ShowMessage('Valor de Troco Inv�lido! Troco: R$ ' + formataCurrency(recebido - totTemp1));
    end;
end;

procedure TForm3.lerFormasParaGravarAVendaPreencheEntrada();
begin
  formasPagamento.First;
  entrada := 0;
  if formasPagamento.RecordCount = 1 then
    begin
      codhis := formasPagamento.FieldByName('cod').AsString;
      exit;
    end;

  while not formasPagamento.Eof do
    begin
      codhis := formasPagamento.FieldByName('cod').AsString;
      if formasPagamento.FieldByName('cod').AsInteger = 1 then
        begin
          entrada := entrada + formasPagamento.FieldByName('total').AsCurrency;
        end
      else
        begin
          codhis := formasPagamento.FieldByName('cod').AsString;
        end;
      formasPagamento.Next;
    end;
end;

procedure TForm3.descarregaFormasDePagamentoImpressora();
begin
  formasPagamento.First;
  while not formasPagamento.Eof do
    begin
      ecf.EfetuaPagamento(formasPagamento.FieldByName('indImp').AsString, formasPagamento.FieldByName('total').AsCurrency, '');
      formasPagamento.Next;
    end;
end;

procedure TForm3.criaDataSetFormas();
begin
  formasPagamento := TClientDataSet.Create(self);
  formasPagamento.FieldDefs.Add('cod'   , ftSmallint);
  formasPagamento.FieldDefs.Add('total' , ftCurrency);
  formasPagamento.FieldDefs.Add('indImp', ftString, 3);
  formasPagamento.IndexFieldNames := 'cod';
  formasPagamento.CreateDataSet;
end;

procedure TForm3.cancelaItemVisual(const num : smallint;const tot_item : currency);
var
  ini, fim : integer;
  num1 : String;
begin
  ECF.CancelaItemVendido(num);
  tot_ge := tot_ge - tot_item;
  PainelTotal.Caption := formataCurrency(tot_ge);
  num1 := CompletaOuRepete('', IntToStr(num), '0', 3);
  fim := RichEdit1.Count -1;
  for ini := 0 to fim do
    begin
      if copy(RichEdit1.Items[ini], 1, 3) = num1 then
        begin
          RichEdit1.Items[ini]     := '** CANCELADO **' + RichEdit1.Items[ini];
          RichEdit1.Items[ini + 1] := '** CANCELADO **' + RichEdit1.Items[ini + 1];
        end;
    end;
end;

procedure TForm3.TimerVendaTimer(Sender: TObject);
begin
  TimerVenda.Enabled := false;
  try
    if not ((vendendoECF) or (dtmMain.ACBrECF1.AguardandoResposta)) then
      begin
        codTemp := ACBrLCB1.LerFila;
        codTemp := trim(codTemp);
        vendeItemFila(codTemp);
      end;
  finally
    TimerVenda.Enabled := (ACBrLCB1.FilaCount > 0);
  end;
end;

procedure TForm3.setaConfigBalanca();
var
  arq : TStringList;
  tipo : String;
begin
  arq := TStringList.Create;
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini') then exit;
  arq.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini');

  if dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Desativar;
  tipo  := arq.Values['tipoBal'];

  //dtmMain.ACBrBAL1.Porta := trim(arq.Values['portabal']);
  //dtmMain.ACBrBAL1.Device.Baud := StrToIntDef(trim(arq.Values['velobal']), 9600);

  if tipo = '0' then dtmMain.ACBrBAL1.Modelo := balNenhum
  else if tipo = '1' then dtmMain.ACBrBAL1.Modelo := balDigitron
  else if tipo = '2' then dtmMain.ACBrBAL1.Modelo := balFilizola
  else if tipo = '3' then dtmMain.ACBrBAL1.Modelo := balLucasTec
  else if tipo = '4' then dtmMain.ACBrBAL1.Modelo := balMagellan
  else if tipo = '5' then dtmMain.ACBrBAL1.Modelo := balMagna
  else if tipo = '6' then dtmMain.ACBrBAL1.Modelo := balToledo
  else if tipo = '7' then dtmMain.ACBrBAL1.Modelo := balToledo2180
  else if tipo = '8' then dtmMain.ACBrBAL1.Modelo := balUrano
  else if tipo = '8' then dtmMain.ACBrBAL1.Modelo := balUranoPOP;

  arq.Free;
  try
    //dtmMain.ACBrBAL1.MonitorarBalanca := true;
    if not dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Ativar;
    //if not dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Ativar;
    //ShowMessage(FormatCurr('#,###,###0.000', dtmMain.ACBrBAL1.LePeso()));
    //if dtmMain.ACBrBAL1.Ativo then ShowMessage('ativo' + #13 + dtmMain.ACBrBAL1.ModeloStr);
  except
    on e:exception do
      begin
        ShowMessage('erro: ' + e.Message);
      end;
  end;
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  key : char;
begin
  codbar.Text := '7898924902011';
  key := #13;
  codbarKeyPress(sender, key);
{  if dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Desativar;
  dtmMain.ACBrBAL1.MonitorarBalanca := true;
  quant.Text := FormatCurr('#,###,###0.000', dtmMain.ACBrBAL1.LePeso());}
end;

function TForm3.somaTotalOriginal(somaValorReal : boolean = false) : Currency;
begin
  IBClientDataSet1.First;
  Result := 0;
  while not IBClientDataSet1.Eof do
    begin
      if not Contido('** CANCELADO **', IBClientDataSet1nome.AsString) then
        begin
          //Result := Result + Arredonda(IBClientDataSet1.fieldbyname('quant').AsCurrency * IBClientDataSet1.fieldbyname(IfThen(somaValorReal, 'preco', 'precoOrigi')).AsCurrency, 2, tipoArredondaVenda);
          if somaValorReal then Result := Result + IBClientDataSet1.fieldbyname('total').AsCurrency
           else Result := Result + IBClientDataSet1.fieldbyname('totalOrigi').AsCurrency;
        end;  
      IBClientDataSet1.Next;
    end;
end;

procedure TForm3.cancelaVenda();
var
  crc : String;
begin
  if IBClientDataSet1.IsEmpty then
    begin
      crc := CompletaOuRepete('', ecf.NumCCF, '0', 6) + CompletaOuRepete('', IntToStr(StrToIntDef(ecf.NumECF, 1)), '0', 3);
      if crc <> '' then begin
        {dtmMain.IBQuery1.Close;
        dtmMain.IBQuery1.SQL.Text := 'update venda set cancelado = :canc where crc = :crc';
        dtmMain.IBQuery1.ParamByName('canc').AsString := form1.codUsuario;
        dtmMain.IBQuery1.ParamByName('crc').AsString  := crc;
        dtmMain.IBQuery1.ExecSQL;
        dtmMain.IBQuery1.Transaction.Commit;}
      end;
    end;

  ecf.CancelaCupom;
  limpaVenda;
end;

procedure TForm3.aguardaRespostaECF(const intervalo : integer = 100);
begin
  while true do
    begin
      if not ecf.AguardandoResposta then break;
      sleep(intervalo);
    end;
end;


function TForm3.verificaValoresNulosFormaDePagamentosOK(total_geral1 : currency) : boolean;
var
  tot2 : currency;
begin
  Result := true;
  formasPagamento.First;
  tot2 := 0;

  while not formasPagamento.Eof do
    begin
      tot2 := tot2 + formasPagamento.FieldByName('total').AsCurrency;
      formasPagamento.Next;
    end;

  if tot2 - total_geral1 > maxTroco then
    begin
      ShowMessage('Valor Recebido Inv�lido! Recebido: R$ ' + formataCurrency(tot2));
    end
  else Result := true;

  formasPagamento.First;
end;

procedure TForm3.aguardaECF();
var
  timeout : integer;
begin
  timeout := 0;
  while true do
    begin
      if timeout > 15 then break;
      if not ecf.AguardandoResposta then break;
      timeout := timeout + 1;
      sleep(200);
    end;
end;


function TForm3.calculaVlrAproxImpostos(var lista1 : TList) : currency;
var
  ex, descricao, ncm: String;
  tabela: Integer;
  aliqFedNac, aliqFedImp, aliqEst, aliqMun: double;
  ini  : integer;
  item : Item_venda;
  arqExiste : Smallint;
begin
  Result := 0;
  arqExiste := 0;
  if FileExists(ExtractFileDir(ParamStr(0)) + '\IBPT.csv') then
    begin
      dtmMain.ACBrIBPTax1.AbrirTabela(ExtractFileDir(ParamStr(0)) + '\IBPT.csv');
    end;

  for ini := 0 to lista1.count -1 do
   begin
     item := lista1.Items[ini];

     if dtmMain.ACBrIBPTax1.Procurar(trim(item.Ncm),ex, descricao, tabela, aliqFedNac, aliqFedImp, aliqEst, aliqMun, true) then
       begin
         item.vlr_imposto := (abs(item.total) - abs(item.Desconto)) * (aliqFedNac + aliqEst) / 100;
         Result := Result + item.vlr_imposto;
       end
     else
       begin
         item.vlr_imposto := VE_IMPOSTO(item.p_compra, item.p_venda, item.quant);
         Result := Result + item.vlr_imposto;
       end;

   end;
end;

function TForm3.criaListaDeItens(desconto1 : currency; var lista1 : TList) : TList;
var
  item1 : Item_venda;
  ncm   : String;
  i     : integer;
  temp  : currency;
begin
  IBClientDataSet1.First;
  lista1 := TList.Create;
  while not IBClientDataSet1.Eof do
    begin
      dtmMain.IBQuery1.Close;
      dtmMain.IBQuery1.SQL.Text := 'select classif, p_compra, p_venda from produto where cod = :cod';
      dtmMain.IBQuery1.ParamByName('cod').AsString := IBClientDataSet1cod.AsString;
      dtmMain.IBQuery1.Open;

      ncm := trim(dtmMain.IBQuery1.fieldbyname('classif').AsString);
      if ncm = '' then ncm := '96089989';

      item1 := Item_venda.Create;
      item1.cod      := IBClientDataSet1cod.AsInteger;
      item1.total    := IBClientDataSet1total.AsCurrency;
      item1.p_venda  := dtmMain.IBQuery1.fieldbyname('p_venda').AsCurrency;
      item1.p_compra := dtmMain.IBQuery1.fieldbyname('p_compra').AsCurrency;
      item1.Ncm   := ncm;
      item1.vlr_imposto := 0;
      item1.Desconto    := 0;

      lista1.Add(item1);
      IBClientDataSet1.Next;
    end;

  if desconto1 > 0 then
     begin
       for i := 0 to lista1.Count - 1 do
         begin
           item1 := lista1.Items[i];
           if i = lista1.Count - 1 then
             begin
               item1.Desconto := ArredondaPDV(desconto1, 2);
             end
           else
             begin
               temp := ArredondaPDV((item1.total / tot_ge) * desconto1, 2);
               item1.Desconto := temp;
               desconto1 := desconto1 - temp;
             end;
         end;
     end;
end;

FUNCTION TForm3.VE_IMPOSTO(_PC, _PV, _qtd : currency) : currency;
var
  PERC, LUC, APLICA_PERC : currency;
begin
  _PC := _PC * _qtd;
  _PV := _PV * _qtd;

  PERC   := StrToCurrDef(form1.pgerais.Values['40'], 100);
  Result := 0;

  //LIMITA OS PERCENTUAIS
  PERC := IfThen(PERC <= 5, 40, PERC);
  PERC := IfThen(PERC >= 500, 70, PERC);

  //SE APLICA O PERCENTUAL SOBRE O LUCRO BRUTO OU SOBRE PRE? DE VENDA
  //APLICA_PERC := VAL(SUBSTR(CONFIG1, 162, 1))
  if _PV - _PC = 0 then
    begin
      Result := (_PV * PERC) / 100;
      exit;
    end;

  Result := (((_PV - _PC) * _qtd) * (PERC / 100));
end;

{function ArredondaTrunca(Value: Extended;decimais:integer): Extended;
begin
  if decimais = 2 then Result := trunc(value * 100)/100
     else Result := trunc(value * 1000)/1000;
end;}

procedure TForm3.Timer2Timer(Sender: TObject);
begin
  PainelCaixa.Caption := 'HORA: '+FormatDateTime('hh:mm:ss', now) + ' / VEND: ' + vendCaption;
end;

procedure TForm3.identificaCliente(var codcli : String);
begin
  form12 := TForm12.Create(self);
  form12.ShowModal;

  if (form12.nome.Text + form12.cnpj.Text  <> '') then
    begin
      codcli := 'Cliente:  ' + CompletaOuRepete(copy(form12.nome.Text, 1, 29), '', ' ', 29) + sLineBreak +
                'CPF/CNPJ: ' + CompletaOuRepete(copy(form12.cnpj.Text, 1, 29), '', ' ', 29) + sLineBreak +
                'End: ' + CompletaOuRepete(copy(form12.ende.Text, 1, 34), '', ' ', 34) + sLineBreak +
                'Bairro: ' + CompletaOuRepete(copy(form12.bairro.Text, 1, 30), '', ' ', 30) + sLineBreak;
    end
  else codcli := '';

  //codCliente := form12.codCliente;
  jsedit.LiberaMemoria(form12);
  form12.Free;
end;

function TForm3.confirmaPrecoProduto(cod : String;var qtd , valor : String; opcao : smallint; servico : boolean = false) : string;
var
  porcDesc, p_venda,temp1, p_vendatemp, minimo : currency;
  tipoDesconto, podeDarAcrescimo, campo, fim, desc : String;
  atacado : boolean;
begin
  Result := valor;

  if form1.pgerais.Values['37'] <> 'P' then exit;

  tipoDesconto     := LerConfig(configu, 2);
  if contido(tipoDesconto, 'SP') = false then exit;

  valor  := '0';
  Result := '0';
  atacado := false;

  if opcao = 0 then
    begin
      qtd := dialogo('numero',3,'SN',3,false,'S','Control for Windows:','Quantidade:','0,000');
      if ((qtd = '*') or (StrToCurrDef(qtd,0) = 0)) then
        begin
          valor  := '*';
          Result := valor;
          exit;
        end;
    end;

  campo := 'p_venda';
  if atacado then campo := 'p_venda1 as p_venda';

  query.Close;
  query.SQL.Clear;
  query.SQL.Add('select desconto, '+campo+'  from produto where cod = :cod');
  query.ParamByName('cod').AsString := cod;
  query.Open;

  porcDesc    := StrToCurrDef(LerConfig(configu,0), 0);
  p_venda     := query.fieldbyname('p_venda').AsCurrency;
  p_vendatemp := p_venda;


  {if p(55, 'N') = 'S' then
    begin
      if dm.IBselect.fieldbyname('desconto').AsCurrency > 0 then
        begin
           porcDesc := dm.IBselect.fieldbyname('desconto').AsCurrency;
        end;
    end;   }

  //calcula o minimo a partir do preco com o desconto maximo configurado na conta do usuario
  minimo := ArredondaPDV(p_venda - ((p_venda * porcDesc)/100), 2);

  query.Close;
  if trim(tipoDesconto) = '' then tipoDesconto := 'S';
  //podeDarAcrescimo := LerConfig(configu, 8);
  podeDarAcrescimo := 'S';

  if servico then
    begin
      tipoDesconto     := 'S';
      podeDarAcrescimo := 'S';
    end;


  if tipoDesconto = 'S' then
    begin
      fim := '-999999';
      while true do
        begin
          fim := dialogoG('numero',3,'1234567890,.'+#8,3,false,'ok','Control for Windows:','Confirme o Pre�o(Minimo: R$ '+ FormatCurr('#,###,###0.00',minimo) + ':',FormatCurr('###,##0.000',p_venda), true);
          if fim = '*' then
            begin
              Result := fim;
              exit;
            end;

          temp1 := StrToCurrDef(fim, 0);

          if ((podeDarAcrescimo = 'S') and (temp1 > p_venda) )then
            begin
              break;
            end;

          if (((temp1 >= minimo) and (temp1 <= p_venda)) or ((temp1 > p_venda) and VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then
            begin
              break;
            end;

          if ((temp1 < minimo) and (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then
            begin
              break;
            end;
        end;

    Result := CurrToStr(temp1);
    valor  := CurrToStr(temp1);
    exit;
  end
 else if tipoDesconto = 'P' then
   begin
     desc := '99999999';
     while true do
       begin
         desc := dialogoG('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Qual o Percentual de Desconto (M�ximo='+ FormatCurr('#,###,###0.000', porcDesc) + '%) (%)?:','0,000', true);
         if desc = '*' then
           begin
             Result := desc;
             exit;
           end;

         if (StrToCurrDef(desc, 0) = porcDesc) then break;
         //if ((StrToCurr(desc) > porcDesc) and (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then break;

         if (StrToCurr(desc) <= porcDesc)then break;
       end;

    temp1 := StrToCurrDef(desc, 0);
    Result := CurrToStr(ArredondaPDV(p_venda-(p_venda * temp1 /100), 2));
    valor := Result;
    exit;
  end
 else if tipoDesconto = 'X' then
   begin
     desc := '99999999';
     while true do
       begin
         desc := dialogoG('numero',0,'1234567890,.'+#8,0,false,'ok','Control for Windows:','Qual o Percentual de Desconto (M�ximo='+ FormatCurr('#,###,###0.000', porcDesc) + '%) (%)?:','0,000', true);
         if desc = '*' then
           begin
             Result := desc;
             exit;
           end;

         if (StrToCurrDef(desc, 0) = porcDesc) then break;
         //if ((StrToCurr(desc) > porcDesc) and (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then break;

         if (StrToCurr(desc) <= porcDesc)then break;
       end;

    temp1 := StrToCurrDef(desc, 0);
    if temp1 = 0 then p_vendatemp := p_vendatemp
      else p_vendatemp := ArredondaPDV(p_venda-(p_venda * temp1 /100), 2);

    fim := '-999999';
      while true do
        begin
          //funcoes.dialogo('numero',3,'1234567890,.'+#8,3,false,'ok','Control for Windows:','Confirme o Pre�o(Minimo: R$ '+ FormatCurr('#,###,###0.00',minimo) + ':',FormatCurr('###,##0.000',p_venda));
          fim := dialogoG('numero',3,'1234567890,.'+#8,3,false,'ok','Control for Windows:','Confirme o Pre�o(Minimo: R$ '+ FormatCurr('#,###,###0.000',minimo) + ':',FormatCurr('###,##0.000',p_vendatemp), true);
          if fim = '*' then
            begin
              Result := fim;
              exit;
            end;

          temp1 := StrToCurrDef(fim, 0);

//          ShowMessage('minimo=' + CurrToStr(minimo) + #13 + 'p_vendatemp=' +  CurrToStr(p_vendatemp) + 'p_venda=' + CurrToStr(p_venda) +
//          #13 + 'temp1=' + CurrToStr(temp1));

          if ((podeDarAcrescimo = 'S') and (temp1 > p_venda) )then break;
          {if (((temp1 >= minimo) and (temp1 <= p_venda)) or ((temp1 > p_venda) and VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false), true) then
            begin
              break;
            end;}
          //if ((temp1 < minimo) and (VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false)) then  break;

        end;

    Result := CurrToStr(temp1);
    valor := Result;
    exit;
 end
else
  begin
    Result := '*';
    exit;
  end;

  Result := valor;
end;

function TForm3.VerificaAcesso_Se_Nao_tiver_Nenhum_bloqueio_true_senao_false : boolean;
begin
  if Length(acessoUsuVenda) > 0 then Result := false
    else Result := true;
end;


end.
