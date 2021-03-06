unit JsEditInteiro1;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics, Windows, Messages, Forms, contnrs,
  Dialogs, JsEdit1;

type
  JsEditInteiro = class(JsEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    procedure KeyPress(var Key: Char); override;
    function getValor() : integer;
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JsEdit', [JsEditInteiro]);
end;

procedure JsEditInteiro.KeyPress(var Key: Char);
begin
  Inherited KeyPress(Key);
  if ((Key = #13) and (Self = jsedit.GetPrimeiroCampo(self.Owner.Name)))then
    begin
      self.Enabled := false;
    end
   else
    if not(Key in['0'..'9',#8]) then Key:=#0;
end;

function JsEditInteiro.getValor() : integer;
begin
  result := strtoint(Text);
end;


end.
