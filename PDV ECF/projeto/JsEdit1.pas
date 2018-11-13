UNIT JsEdit1;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics, Windows, Messages, Forms, contnrs,
  Dialogs, Buttons, IBQuery, math;

//type
//JsEditInterface = interface
//  ['{37F2C629-0DF6-43FF-B1FC-4A7419DB893E}']
//  function GetValorDelimitadoSQL: String;
//end;

type
  JsEdit = class(TEdit)
  private
    FOldBackColor : TColor;
    FColorOnEnter : TColor;
    valida   : boolean;
    UsarCadastro, UsarGeneratorCad : boolean;
    property OldBackColor : TColor read FOldBackColor write FOldBackColor;
  protected
    FAlignment: TAlignment;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetAlignment(const Value: TAlignment);
  public
    func : boolean;
    num:integer;
    form:string;
    function ContaComponentesPorForm(form:string) : integer;
    constructor Create(AOwner:TComponent);override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; shift : TShiftState);override;
    function GetValorInteiro() : Integer;
    class function RetornaIndiceDoUltimoCampo(formi:string) : Integer;
    class function RetornaIndiceDoPrimeiroCampo(formi:string) : Integer;
    class function Retorna_Indice_Do_PrimeiroCampo_Ativado(formi:string) : Integer;
    //class function retornaIndice(param:integer;ulti:Integer;prim:integer):integer;
    class function GetValorInteiroDoPrimeiroCampo(formi:string) : Integer;
    class function ConteudoDelimitado(campo : TObject) : String;
    class procedure LiberaMemoria(form:tform);
    class procedure LimpaCampos(form:string);
    class procedure SetFocusNoPrimeiroCampo(comp:string);
    class procedure SetFocusNoUltimoCampo;
    class procedure AdicionaBotao(Botao : TBitBtn);
    class procedure SetFocusNoPrimeiroBotao();
    class function GetPrimeiroCampo(formi:string) : JsEdit;
    class function GetPrimeiroBotao(form:string) : TBitBtn;
    class function GetUltimoBotao(form:string) : TBitBtn;
    class function GravaNoBD(form:tform; usaGen : boolean = true) : string;
    class function SelecionaDoBD(formi:string; msg :boolean = true; condicao : String = '') : boolean;
    class function NovoCodigo(formi:string) : integer;
    class function  AchaProximo(comp:TComponent) : TComponent;
    class function  UltimoCodigoDaTabela(formi:string) : integer;
    class procedure SetTabelaDoBd(form:tform;tabela1 : string; query1 : TIBQuery; primarykey1 : String = '');
    class procedure AdicionaComponente(componente : TObject);
    class procedure RecuperaValorDoCampo(campo : TCustomEdit; query : TIBQuery);
    class function GetLista() : TObjectList;
    class function StrNum(lin : String) : String;
    class function GetValorNumericoAsString(lin : String) : String;
    class function ExcluiDoBD(formi:string; condicao:string = '') : boolean;
    class function Incrementa_Generator(Gen_name : string; valor_incremento : integer) : string;
  published
    //property Alignment : TAlignment read FAlignment write SetAlignment;
    property AddLista :boolean read func write func default true;
    property UsarCadastros :boolean read UsarCadastro write UsarCadastro default true;
    property UsarGeneratorCadastro :boolean read UsarGeneratorCad write UsarGeneratorCad default true;
    property FormularioComp: string read form write form;
    property ColorOnEnter : TColor read FColorOnEnter write FColorOnEnter default clWhite;
    property ValidaCampo : boolean read valida write valida default false;
    property Indice :integer read num write num;
  end;

procedure Register;

implementation

uses DB;
//Uma vari�vel qualquer declarada aqui � entendida como atributo da classe
var lista,botoes : TObjectList;tabelas, primarykey:Tstringlist; primeiroBotao, ultimoBotao : TBitBtn;
primeiroCampo : TObject; tabela,formulario : string; query : TIBQuery;conta,n:integer;

{class function retornaIndice(param:integer;ulti:Integer;prim:integer):integer;
begin
if param=0 then result:= prim
 else  result:= ulti;
end;}

class function jsedit.Incrementa_Generator(Gen_name : string; valor_incremento : integer) : string;
begin
  query.Close;
  query.SQL.Clear;
  query.SQL.Add('select gen_id('+ Gen_name +','+ IntToStr(valor_incremento) +') as venda from rdb$database');
  query.Open;

  Result := '';
  Result := query.fieldbyname('venda').AsString;

  query.Close;
end;

class function jsedit.RetornaIndiceDoUltimoCampo(formi:string) : Integer;
var i : integer;
begin
  for i:=lista.Count-1 downto 0  do
   begin
      if not Assigned(lista.Items[i]) then lista.Delete(i)
      else
        begin
          if (formi = tedit(lista.Items[i]).Owner.Name)  then
            begin
              result := i;
              break ;
            end;
        end;
     end;
end;

class function jsedit.RetornaIndiceDoPrimeiroCampo(formi : string) : Integer;
var i : integer;
begin
  result := 0;
  if lista = nil then exit;
    for i := 0 to lista.Count - 1  do
      begin
        if (formi = tEdit(lista.Items[i]).Owner.Name)  then
          begin
            result := i;
            break ;
          end;
      end;
end;

class function jsedit.Retorna_Indice_Do_PrimeiroCampo_Ativado(formi:string) : Integer;
var i : integer;
begin
  result := 0;
  if lista <> nil then
    begin
      for i := 0 to lista.Count - 1  do
        begin
          if (formi = tEdit(lista.Items[i]).Owner.Name) and (tEdit(lista.Items[i]).Enabled)  then
            begin
              result := i;
              break ;
            end;
        end;
    end;
end;


procedure Register;
begin
  RegisterComponents('JsEdit', [JsEdit]);
end;

constructor JsEdit.Create(AOwner: TComponent);
begin
  Inherited;
  UsarCadastro     := true;
  UsarGeneratorCad := true;
  FColorOnEnter := clWhite;
  func := true;
  FAlignment := taLeftJustify;
  if self.ClassName = 'JsEditNumero' then FAlignment := taRightJustify;
  //if self.ClassName = 'JsEditInteiro' then text := '0';
  RecreateWnd;
  self.form := self.Owner.Name;
  Self.CharCase := ecUpperCase;
  if func then AdicionaComponente(Self);
  //Color := FColorOnEnter;
end;

function jsedit.ContaComponentesPorForm(form:string) : integer;
var i : integer;
begin
 result := 0;
 for i := 0 to lista.Count -1 do
  begin
    if form = self.form then result := Result+1;
  end;
end;

class function  JsEdit.AchaProximo(comp:TComponent) : TComponent;
var i, atual, fim: integer;
begin
  atual := 9999;
  fim := lista.Count -1;
  for i := 0 to fim do
   begin
     //se o formulario do componente atual � igual ao formulario do componente q foi passado como parametro
     if (TEdit(lista.Items[i]).Owner.Name = TEdit(comp).owner.Name) then
      begin
        //quando o contador for maior que o componente atual
        if i > atual then
         begin
          //se estiver habilitado d� o focus e para o loop
          if (TEdit(lista.Items[i]).Enabled) and (TEdit(lista.Items[i]).Visible) then
           begin
            Tedit(lista.Items[i]).SetFocus;
            break;
           end;
         end;
       //comparacao para encontrar o componente atual
       if tedit(lista.Items[i]).Name = tedit(comp).Name then
        begin
         //se o contador (i) � igual ao ultimo entao d� o focus no primeiro botao
         if i = RetornaIndiceDoUltimoCampo(jsedit(comp).owner.Name) then
          begin
           if GetPrimeiroBotao(comp.Owner.Name)<> nil then GetPrimeiroBotao(comp.Owner.Name).SetFocus;
          end;
         atual := i;
        end;
      end;
   end;
{   if (lista.Count-1=i)  then
    begin
     PostMessage((tedit(comp).Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0);
    end;
}

end;

procedure JsEdit.SetAlignment(const Value: TAlignment);
begin
//  if FAlignment <> Value then
//  begin
    FAlignment := Value;
    RecreateWnd;
//  end;
end; (*SetAlignment*)

procedure JsEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: array[TAlignment] of DWORD = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);

  with Params do
    Style := Style or Alignments[FAlignment];
end; (*CreateParams*)

class procedure JsEdit.AdicionaComponente(componente : TObject);
begin
  if lista = nil then lista := TObjectList.Create;
  lista.Add(componente);
end;

procedure JsEdit.KeyPress(var Key: Char);
var ok : boolean;
begin
inherited KeyPress(Key);
if self.func then
 begin
  ok := true;
  //se foi pressionado enter, se � o primeiro campo, se est� em branco e se � um JsEditInteiro - preenche com 0
  if (Key = #13) and (self = lista.Items[RetornaIndiceDoPrimeiroCampo(self.Owner.Name)]) and (Self.Text = '') and (UsarCadastro) then
   //and (Self.ClassName = 'JsEditInteiro') then
     begin
       Self.Text := '0';
     end;
  //se foi pressionado enter, se � o primeiro campo, e se est� preenchido
  if (Key = #13) and (self = lista.Items[RetornaIndiceDoPrimeiroCampo(self.Owner.Name)]) and (Self.Text <> '0') and (Self.ClassName = 'JsEditInteiro') and (UsarCadastro) then
     begin
       ok := SelecionaDoBD(self.Owner.Name);
     end;
  if (Key = #13) then
     begin
       //se valida campo, n�o deixa passar em branco
       if (Self.valida) and (Self.Text = '') then
          begin
            ok := false;
            ShowMessage('Campo de preenchimento obrigat�rio');
            Self.SetFocus;
          end;
       if ok then
         begin
           if func then
             begin
              //ShowMessage(IntToStr(lista.Count));
              AchaProximo(self);
             end;
         end
         else
          Key := #0;
     end;
  try
   if ((Key = #27) and (self <> JsEdit(lista.Items[RetornaIndiceDoPrimeiroCampo(self.Owner.Name)]))) and (func) then
    begin
      LimpaCampos(self.Owner.Name);
    end;
  except
  end;
 end;
end;

procedure JsEdit.KeyDown(var Key: Word; shift : TShiftState);
begin
  inherited;
    //teclas PgUp e PgDown - passam o foco para o �primeiro bot�o
    if ((Key = 33) or (Key = 34)) then
     begin
       if GetPrimeiroBotao(self.Owner.Name)<>nil then  GetPrimeiroBotao(self.Owner.Name).SetFocus;
     end;
    //seta acima - sobe at� o primeiro componente
    if (Key = 38) then
       begin
         if TEdit(lista.Items[RetornaIndiceDoPrimeiroCampo(self.Owner.Name)]).Enabled then primeiroCampo := lista.Items[RetornaIndiceDoPrimeiroCampo(self.Owner.Name)] else
           primeiroCampo := lista.Items[Retorna_Indice_Do_PrimeiroCampo_Ativado(self.Owner.Name)];
         if (TComponent(self) <> TComponent(primeiroCampo)) then
           begin
            try
              PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 1, 0);
            except
            end;
           end;
       end;
    //seta abaixo - n�o passa do primeiro e nem do �ltimo para baixo
    if ((Key = 40) and (TComponent(self) <> TComponent(lista.Items[RetornaIndiceDoUltimoCampo(self.owner.Name)]))) then
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0);
end;

procedure JsEdit.DoEnter;
begin
  //if (Color = clWindow) then FColorOnEnter := clMoneyGreen;
  OldBackColor := Color;
  Color := FColorOnEnter;
  inherited;
end;

procedure JsEdit.DoExit;
begin
  Color := OldBackColor;
  inherited;
end;

class procedure JsEdit.LiberaMemoria(form : tform);
var i : integer;
begin
  //varre a lista de traz pra frente excluindo os componentes
  if lista <> nil then
    begin
      for i := lista.Count-1 downto 0 do
        begin
          try
            //if not Assigned(lista.Items[i])) then lista.Delete(i)
            //else
             // begin
                if tform(lista.Items[i]).Owner.Name = form.Name then
                  begin
                    lista.Delete(i);
                  end;
             // end;    
          except
        end;
    end;

  if botoes <> nil then
    begin
      for i := botoes.Count-1 downto 0 do
        begin
          if TBitBtn(botoes.Items[i]).Owner.Name = form.Name then
            begin
              botoes.Delete(i);
            end;
        end;

  if botoes.Count = 0 then
      begin
        botoes.Free;
        botoes := nil;
      end;

 end;
 if lista.Count = 0 then
  begin
   lista.Free;
   lista := nil;
  end;

 end;


end;

class procedure JsEdit.SetFocusNoPrimeiroCampo(comp:string);
var i : integer;
begin
  for i := 0 to lista.Count-1 do
   begin
      if comp = jsedit(lista.Items[i]).Owner.Name then
        begin
          if not tedit(lista.Items[i]).Visible then
            begin
              tedit(lista.Items[i + 1]).SetFocus;
              exit;
            end;
          tedit(lista.Items[i]).Enabled := true;
          tedit(lista.Items[i]).SetFocus;
          break ;
        end;
   end;

 { JsEdit(lista.First).enabled := true;
  JsEdit(lista.First).SetFocus;}
end;

class procedure JsEdit.SetFocusNoUltimoCampo;
var i : integer;
begin
  for i:=lista.Count-1 downto 0  do
   begin
      if formulario = tedit(lista.Items[i]).Owner.Name then
        begin
          tedit(lista.Items[i]).Enabled := true;
          tedit(lista.Items[i]).SetFocus;
          break ;
        end;
     end;
end;

class procedure JsEdit.SetFocusNoPrimeiroBotao();
begin
  if primeiroBotao <> nil then primeiroBotao.SetFocus;
end;

class procedure jsedit.LimpaCampos(form:string);
var ini, fim : integer; tipo : String;
begin

  fim := RetornaIndiceDoUltimoCampo(form);
  for ini := RetornaIndiceDoPrimeiroCampo(form) to fim do
    begin
      tipo := lista.Items[ini].ClassName;
      JsEdit(lista.Items[ini]).Text := '';
      if tipo = 'JsEditData' then
       JsEdit(lista.Items[ini]).Text := '__/__/____';
      if tipo = 'JsEditCPF' then
       JsEdit(lista.Items[ini]).Text := '___.___.___-__';
      if tipo = 'JsEditCNPJ' then
       JsEdit(lista.Items[ini]).Text := '__.___.___/___-___';
      if tipo = 'JsEditNumero' then
       JsEdit(lista.Items[ini]).Text := '0,00';
    end;
  SetFocusNoPrimeiroCampo(form);
end;

//procedure JsEdit.KeyUp(var Key: Word; shift : TShiftState);
//begin
//end;

class procedure JsEdit.AdicionaBotao(botao : TBitBtn);
begin
  if botoes = nil then botoes := TObjectList.Create;
   botoes.Add(Botao);
{  if primeiroBotao = nil then primeiroBotao := botao;
  ultimoBotao := botao;
}end;

class function JsEdit.GetPrimeiroBotao(form:string) : TBitBtn;
var i : Integer;
begin
  Result := nil;
  if botoes <> nil then
    begin
      for i := 0 to botoes.Count - 1 do
        begin
          if TBitBtn(botoes.Items[i]).Owner.Name = form then
            begin
              result := TBitBtn(botoes.Items[i]);
              break;
            end;
        end;
    end;
//  result := primeiroBotao;
end;

class function JsEdit.GetUltimoBotao(form:string) : TBitBtn;
var i : Integer;
begin
  if botoes <> nil then
    begin
      for i := botoes.Count - 1 downto 0 do
        begin
          if TBitBtn(botoes.Items[i]).Owner.Name = form then
            begin
              result := TBitBtn(botoes.Items[i]);
              break;
            end;
        end;
    end;
//  result := ultimoBotao;
end;

class function JsEdit.GetPrimeiroCampo(formi:string) : JsEdit;
var i :integer;
begin
  // varre a lista e retorna o primeiro componente do formulario e sai do loop
  result := nil;
if lista <> nil then
 begin
  for i:=0 to lista.Count-1 do
   begin
      if formi = jsedit(lista.Items[i]).owner.Name then
        begin
          //ShowMessage(JsEdit(lista.Items[i]).Text);
          result := JsEdit(lista.Items[i]);
          break;
        end;
   end;
 end;
end;

class function JsEdit.GravaNoBD(form:tform; usaGen : boolean = true) : string;
var ini, fim, ultCod, codAtual, tmp : integer; stringSql : String;
begin
  //ultima atualiza��o tirar verifica��o de c�digo (codatual >= 0)and(codatual<=ultcod)
  tabela := LowerCase(tabelas.Values[form.Name]);
  codAtual := GetValorInteiroDoPrimeiroCampo(form.Name);
  Result := '';
  if usaGen then
    begin
      ultCod := UltimoCodigoDaTabela(form.Name);
      if (codAtual = 0) then
        JsEdit(lista.Items[RetornaIndiceDoPrimeiroCampo(form.Name)]).Text := inttostr(JsEdit.NovoCodigo(form.Name));
    end;

    Result := JsEdit(lista.Items[RetornaIndiceDoPrimeiroCampo(form.Name)]).Text;
    stringSql := 'update or insert into ' + tabela + ' ( ';
    //fim = ao indice do ultimo campo do formulario na lista
    fim := RetornaIndiceDoUltimoCampo(form.Name);
    //pega os nomes dos campos
    tmp := RetornaIndiceDoPrimeiroCampo(form.Name);
    for ini := tmp to fim do
      begin
        if (JsEdit(lista.Items[ini]).Enabled) or (ini = tmp) then
          begin
            stringSql := stringSql + JsEdit(lista.Items[ini]).Name;
            if (ini <> fim) then stringSql := stringSql + ', ';
          end;
      end;

    stringSql := stringSql + ' ) values (';

    //pega os conte�dos dos campos
    for ini := tmp to fim do
      begin
        if (JsEdit(lista.Items[ini]).Enabled) or (ini = tmp) then
          begin
            stringSql := stringSql + JsEdit.ConteudoDelimitado(lista.Items[ini]);
            if (ini <> fim) then stringSql := stringSql + ', ';
          end;  
      end;
    stringSql := stringSql + ' )';
    if primarykey.Values[form.Name] <> '' then
      begin
        stringSql := stringSql + ' matching('+ primarykey.Values[form.Name] +')';
      end;
    query.Close;
    query.SQL.Clear;
    query.SQL.Add(stringSql);
    query.ExecSQL;
    query.Transaction.Commit;
    query.Close;
    LimpaCampos(form.Name);
end;

class function JsEdit.ConteudoDelimitado(campo : TObject) : String;
var atual : TCustomEdit;
begin
  atual := TCustomEdit(campo);
  result := #39 + atual.text + #39;
  if campo.ClassName = 'JsEditInteiro' then
     if(atual.Text = '') then result := '0' else result := atual.Text;
  if campo.ClassName = 'JsEditData' then
    begin
     if pos('_',atual.Text) > 0 then Result := #39+'01.01.1900'+#39
     else result := #39 + copy(atual.Text, 1, 2) + '.' + copy(atual.Text, 4, 2) + '.' + copy(atual.Text, 7, 4) + #39;;
    end;
  if campo.ClassName = 'JsEditNumero' then
    begin
      result := (GetValorNumericoAsString(atual.Text));
    end;
end;

class function JsEdit.GetValorNumericoAsString(lin : String) : String;
var pos, fim : integer; ret : String;
begin
  fim := length(lin);
  for pos := 1 to fim do
    begin
      if (lin[pos] in ['0'..'9', '-']) then ret := ret + lin[pos];
      if (lin[pos] = ',') then ret := ret + '.';
    end;
  result := ret;
end;

//devolve apenas d�gitos de 0 a 9 de uma string
class function JsEdit.StrNum(lin : String) : String;
var pos, fim : integer; ret : String;
begin
  fim := length(lin);
  for pos := 1 to fim do
    begin
      if (lin[pos] in ['0'..'9']) then ret := ret + lin[pos];
    end;
  result := ret;
end;


class function JsEdit.NovoCodigo(formi:string) : integer;
var novoCod : integer;
begin
  query.SQL.Clear;
  query.SQL.add('select gen_id('+LowerCase(tabelas.Values[formi])+',1) as cod from RDB$DATABASE');
  query.Open;
  Result := query.fieldbyname('cod').AsInteger;
  query.Close;
  query.SQL.Clear;

  {novoCod := 0;
  tabela := LowerCase(tabelas.Values[formi]);
  while true do
    begin
      try
        query.Transaction.Active := true;
        query.SQL.Clear;
        query.SQL.Add('update controle set codigo = codigo + 1 where tabela = :tab');
        query.ParamByName('tab').AsString := tabela;
        query.Open;

        query.SQL.Clear;
        query.SQL.Add('select codigo from controle where tabela = :tab WITH LOCK');
        query.ParamByName('tab').AsString := tabela;
        query.Open;
        novoCod := query.fieldbyname('codigo').Asinteger;
        query.ApplyUpdates;
        query.Close;
        query.Transaction.Commit;
        query.Transaction.Active := false;
        break;
      except
        query.Transaction.Rollback;
        query.Close;
        query.Transaction.Active := false;
      end;;
   end;
   result := novoCod;}
end;

class function JsEdit.ExcluiDoBD(formi:string; condicao:string = '') : boolean;
var nome : String; cod : integer; ok : boolean;
begin
   ok := false;
   tabela := LowerCase(tabelas.Values[formi]);
   nome := JsEdit(lista.Items[RetornaIndiceDoPrimeiroCampo(formi)]).Text;
   if nome = '' then  cod := 0 else cod := strtoint(nome);
   nome := JsEdit(lista.Items[RetornaIndiceDoPrimeiroCampo(formi) + 1]).Text;
   if cod <> 0 then
     begin
       if MessageDlg('Confirma Exclus�o de ' + nome + ' codigo ' + inttostr(cod) + ' da tabela ' + tabela + '?', mtInformation, [mbYes, mbNo], 0) = mrYes then
          begin
            if condicao = '' then condicao := 'cod = :codl';
            query.Close;
            query.Transaction.Active := true;
            query.SQL.Clear;
            query.SQL.Add('delete from ' + tabela + ' where '+ condicao );
            if Pos(':', condicao) > 0 then query.ParamByName('codl').AsInteger := cod;
            query.ExecSQL;
            query.Close;
            query.Transaction.Commit;
            query.Transaction.Active := false;
            LimpaCampos(formi);
            ok := true;
           end;
     end;
   if (not ok) then SetFocusNoPrimeiroCampo('');
   result := ok;
end;

class function  JsEdit.UltimoCodigoDaTabela(formi:string) : integer;
var ultCod : integer;
begin
  {query.Close;
  query.SQL.Clear;
  query.SQL.Add('select max(cod) as cod from ' + tabelas.Values[formi]);
  query.Open;
  ultCod := query.fieldbyname('cod').Asinteger;
  query.Close;}

  ultCod := StrToInt(Incrementa_Generator(tabelas.Values[formi], 0));
  result := ultCod;
end;

function JsEdit.GetValorInteiro() : Integer;
var cod : Integer;
begin
  if (self.Text = '') then cod := 0 else
     cod := strtoint(Self.Text);
  result := cod;
end;

class function JsEdit.GetValorInteiroDoPrimeiroCampo(formi:string) : Integer;
var cod : Integer;
begin
  try
    if JsEdit.GetPrimeiroCampo(formi).Text <> '' then  result := StrToInt(JsEdit.GetPrimeiroCampo(formi).Text)
     else result := 0;
  except
  end;
end;

class function JsEdit.SelecionaDoBD(formi:string; msg :boolean = true; condicao : String = '') : boolean;
var
  cod, ini, fim : integer;
begin
  cod := JsEdit.GetValorInteiroDoPrimeiroCampo(formi);
  query.SQL.Clear;
  if condicao = '' then condicao := '(cod = :codigo)';
  query.SQL.Add('select * from ' + tabelas.Values[formi] + ' where ' + condicao);
  if pos(':codigo', condicao) > 0 then query.ParamByName('codigo').AsInteger := cod;
  try
    query.Open;
  except
    on e:exception do
      begin
        ShowMessage(e.Message);
        exit;
      end;
  end;
  if query.IsEmpty then
     begin
       if msg then
         begin
           ShowMessage('C�digo n�o encontrado: ' + inttostr(cod));
           LimpaCampos(formi);
         end;
       query.close;
       result := false;
     end
   else
     begin
       fim := RetornaIndiceDoUltimoCampo(formi);
       //pega os nomes dos campos
       for ini := RetornaIndiceDoPrimeiroCampo(formi) to fim do
         begin
           RecuperaValorDoCampo(TCustomEdit(lista.Items[ini]), query);
         end;
       query.close;
       result := true;
     end;
end;

class procedure JsEdit.SetTabelaDoBd(form:tform;tabela1 : string; query1 : TIBQuery; primarykey1 : String = '');
begin
  if not Assigned(tabelas) then tabelas := TStringList.Create;
  if not Assigned(primarykey) then primarykey := TStringList.Create;
  if tabelas.Values[form.Name]='' then tabelas.Add(form.Name+'='+tabela1);
  if primarykey1 <> '' then primarykey.Values[form.Name] := primarykey1;

  query := query1;
end;


class procedure JsEdit.RecuperaValorDoCampo(campo : TCustomEdit; query : TIBQuery);
var ret, nomeDoCampo, nomeDaClasse : String;
begin
  nomeDoCampo := campo.Name;
  nomeDaClasse := campo.ClassName;
  ret := query.FieldByName(nomeDoCampo).AsString;
  if (nomeDaClasse = 'JsEditNumero') then
   begin
     ret := FormatCurr('#,###,###0.00', query.FieldByName(nomeDoCampo).AsCurrency);
//     if (query.FieldByName(nomeDoCampo).AsString = '') or (query.FieldByName(nomeDoCampo).AsString = '0')  then ret := '0,00'
//      else ret := query.FieldByName(nomeDoCampo).AsString;
   end;
   if (nomeDaClasse = 'JsEditInteiro') then
    begin
     if (query.FieldByName(nomeDoCampo).AsString = '') then ret := '0';
    end;
  if (nomeDaClasse = 'JsEditData') then
     ret := FormatDateTime('dd/mm/yyyy', query.FieldByName(nomeDoCampo).AsDateTime);

  campo.Text := ret;
end;

class function JsEdit.GetLista() : TObjectList;
begin
  result := lista;
end;


end.


