unit JsEditCPF1;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics, Windows, Messages, Forms, contnrs,
  Dialogs, Buttons, Mask, JsEdit1;

type
  JsEditCPF = class(TMaskEdit)
   private
    valida : boolean;
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent);override;
    procedure KeyPress(var Key: Char);override;
    procedure KeyDown(var Key: Word; shift : TShiftState);override;
    function ValidaCPF() : boolean;
    function CompletaString(parcial : string) : string;
  published
    property ValidaCampo :boolean read valida write valida default false;
  end;

procedure Register;

implementation
var lista : TObjectList; primeiroCampo : TObject;

procedure Register;
begin
  RegisterComponents('JsEdit', [JsEditCPF]);
end;

constructor JsEditCPF.Create(AOwner: TComponent);
begin
  Inherited;
  JsEdit.AdicionaComponente(Self);
  Self.EditMask := '!999.999.999-99;1;_';
  lista := JsEdit.GetLista();
end;

procedure JsEditCPF.KeyPress(var Key: Char);
var ok : boolean;
begin
  //if ((Key <> #13) and (Key <> #27) and (Key <> #8)) then
     //inherited KeyPress(Key);
  {if Key = #8 then
     begin
       Text := '___.___.___-__';
       ReformatText(EditMask);
       key := #0;
     end;}
  ok := true;
  if (Key = #13) then
     begin
       if (Self.Text = '___.___.___-__') then
          begin
            //se valida campo, n�o deixa passar em branco
            if (Self.valida) then
               begin
                 ok := false;
                 ShowMessage('Campo de preenchimento obrigat�rio');
                 Self.SetFocus;
               end;
          end
        else
          if (not validaCPF) then
             begin
               ShowMessage('CPF Inv�lido, favor digitar novamente');
               Self.SelectAll;
               Self.SetFocus;
               ok := false;
               Key := #0;
             end;

       if ok then
          PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0)
  end;
  if (Self.Text = '') then Self.Text := '___.___.___-__';

  //if ((Key = #27) and (self <> lista.First) ) then
    // JsEdit.LimpaCampos(self.Owner.Name);
  inherited KeyPress(Key);   
end;

function JsEditCPF.validaCPF() : boolean;
begin
  result := True;
end;

procedure JsEditCPF.KeyDown(var Key: Word; shift : TShiftState);
begin
  inherited KeyDown(Key, shift);
    if Key = 46 then
       begin
         Text := '___.___.___-__';
         ReformatText(EditMask);
         key := 0;
       end;
    //teclas PgUp e PgDown - passam o foco para o �primeiro bot�o
    if ((Key = 33) or (Key = 34)) then
       JsEdit.SetFocusNoPrimeiroBotao;
    //seta acima - sobe at� o primeiro componente
    if (Key = 38) then
       begin
         if TEdit(lista.First).Enabled then primeiroCampo := lista.First else
            primeiroCampo := lista.Items[1];
         if (self <> primeiroCampo) then
            PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 1, 0);
       end;
    //seta abaixo - n�o passa do primeiro e nem do �ltimo para baixo
    if ((Key = 40) and (self <> lista.Last)) then
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0);
end;

function JsEditCPF.CompletaString(parcial : string) : string;
var ini : integer; atual, ret : string;
begin
   atual := datetostr(date);
   ret := '';
   for ini := 1 to length(atual) do
     begin
       if (copy(parcial, ini, 1) = ' ') then
          ret := ret + copy(atual, ini, 1)
         else
          ret := ret + copy(parcial, ini, 1);
     end;
   result := ret;
end;

end.


