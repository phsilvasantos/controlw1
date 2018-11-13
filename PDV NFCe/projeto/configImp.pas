unit configImp;

interface

uses                                                    
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, acbrecf, func, ComCtrls, acbrbal, Buttons;

type
  TForm6 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    porta: TEdit;
    Label3: TLabel;
    velocidade: TEdit;
    CheckBox1: TCheckBox;
    Button1: TButton;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Button2: TButton;
    TipoBal: TComboBox;
    Label9: TLabel;
    VeloBal: TEdit;
    Label8: TLabel;
    portaBal: TEdit;
    Label7: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Button3: TButton;
    Edit2: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    LinhasCupons: TEdit;
    Label10: TLabel;
    sinInvertido: TCheckBox;
    corte: TCheckBox;
    BitBtn1: TBitBtn;
    balOnline: TCheckBox;
    Label11: TLabel;
    tamFonteCupomVisual: TEdit;
    ComboBox2: TComboBox;
    Label12: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private

    { Private declarations }
  public
    procedure abretudo();
    procedure gravaParametrosACBrECF();
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses untDtmMain, dmecf, StrUtils, cores;

{$R *.dfm}

procedure TForm6.gravaParametrosACBrECF();
var
  arq : TStringList;
begin
  arq := TStringList.create;
  arq.Values['indexImpressora'] := IntToStr(ComboBox1.ItemIndex);
  arq.Values['velocidade']      := velocidade.Text;
  arq.Values['porta']           := porta.Text;
  arq.Values['usarDLL']         := IfThen(CheckBox1.Checked, 'S', 'N');
  arq.Values['SinalInvertido']  := IfThen(sinInvertido.Checked, 'S', 'N');
  arq.Values['corte']           := IfThen(corte.Checked, 'S', 'N');
  arq.Values['LinhasCupons']    := LinhasCupons.Text;
  arq.Values['portabal']        := portaBal.Text;
  arq.Values['velobal']         := VeloBal.Text;
  arq.Values['tipoBal']         := IntToStr(TipoBal.ItemIndex);
  arq.Values['intervalo']       := Edit1.Text;
  arq.Values['balancaOnline']   := IfThen(balOnline.Checked, 'S', 'N');
  arq.Values['tamFontVisual']   := tamFonteCupomVisual.Text;
  arq.Values['BalArredondamento'] := LeftStr(ComboBox2.Text, 1);

  arq.SaveToFile(ExtractFileDir(ParamStr(0)) + '\ConfECF.ini');
  arq.Free;
end;

procedure TForm6.Button1Click(Sender: TObject);
begin
//  setParametrosACBrECF(dtmMain.ACBrECF1, dtmMain.ACBrBAL1, ComboBox1.ItemIndex, StrToIntDef(velocidade.Text, 9600), porta.Text, VeloBal.Text, portaBal.Text, TipoBal.Text);

  try
    //dtmMain.ACBrECF1.Ativar;
    ShowMessage('ECF obteve resposta com Sucesso');
    //dtmMain.ACBrECF1.Desativar;
  except
    on e:exception do
      begin
        ShowMessage('Ocorreu um Erro: ' + #13 + e.Message);
      end;
  end;
end;

procedure TForm6.Button2Click(Sender: TObject);
var
  usarDLL : String;
begin
  if CheckBox1.Checked then usarDLL := 'S'
    else  usarDLL := 'N';
  self.gravaParametrosACBrECF();
  ShowMessage('Configura��es salvas Com Sucesso');
end;

procedure TForm6.FormShow(Sender: TObject);
var
  indxImp, velo : integer;
  porta1, usaDLL, velobal1, tipobal1, portabal1, intervalo   : String;
  arq : TStringList;
begin
  porta1 := '';

  LerParametrosACBrECF1(arq);

  if arq.Values['porta'] <> '' then
   begin
     Edit1.Text := IfThen(trim(arq.Values['intervalo']) = '', '200', trim(arq.Values['intervalo']));
     portabal.Text := arq.Values['portabal'];
     velobal.Text  := arq.Values['velobal'];
     tamFonteCupomVisual.Text := arq.Values['tamFontVisual'];
     TipoBal.ItemIndex := StrToIntDef(arq.Values['tipoBal'], 0);
     ComboBox1.ItemIndex := StrToIntDef(arq.Values['indexImpressora'], 0);
     velocidade.Text := IfThen(trim(arq.Values['velocidade']) = '', '9600', trim(arq.Values['velocidade']));
     porta.Text      := IfThen(trim(arq.Values['porta']) = '', '9600', trim(arq.Values['porta']));
     if arq.Values['usarDLL'] = 'S' then CheckBox1.Checked := true
       else CheckBox1.Checked := false;
     if arq.Values['balancaOnline'] = 'S' then balOnline.Checked := true
       else balOnline.Checked := false;
     if arq.Values['corte'] = 'S' then corte.Checked := true
       else corte.Checked := false;

     if arq.Values['BalArredondamento'] = 'F' then ComboBox2.ItemIndex := 0
       else ComboBox2.ItemIndex := 1;

     if arq.Values['SinalInvertido'] = 'S' then sinInvertido.Checked := true
       else sinInvertido.Checked := false;
   end;
end;

procedure TForm6.Button3Click(Sender: TObject);
var
  tipo : String;
begin
  if dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Desativar;

  dtmMain.ACBrBAL1.Porta := portaBal.Text;
  dtmMain.ACBrBAL1.Device.Baud := StrToIntDef(VeloBal.Text, 9600);
  tipo := IntToStr(TipoBal.ItemIndex);

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

  try
    if not dtmMain.ACBrBAL1.Ativo then dtmMain.ACBrBAL1.Ativar;
    edit2.Text := FormatCurr('#,###,###0.000', dtmMain.ACBrBAL1.LePeso());
    ShowMessage('Leitura Efetuada com Sucesso');
  except
    on e:exception do
      begin
        ShowMessage('Erro => ' + #13 + e.Message);
      end;
  end;
end;

procedure TForm6.BitBtn1Click(Sender: TObject);
begin
  form11 := tform11.Create(self);
  form11.ShowModal;
  form11.Free;
end;

procedure TForm6.abretudo();
var
  indxImp, velo : integer;
  porta1, usaDLL, velobal1, tipobal1, portabal1, intervalo   : String;
  arq : TStringList;
begin
  porta1 := '';
  //LerParametrosACBrECF(arq);
  //porta1 := arq.Values[] '';
  LerParametrosACBrECF(indxImp, velo, porta1, usaDLL, portabal1, velobal1, tipobal1, intervalo);

  if porta1 <> '' then
   begin
     Edit1.Text := intervalo;
     portabal.Text := portabal1;
     velobal.Text  := velobal1;
     TipoBal.ItemIndex := StrToIntDef(tipobal1, 0);
     ComboBox1.ItemIndex := indxImp;
     velocidade.Text := IntToStr(velo);
     porta.Text      := porta1;
     if usaDLL = 'S' then CheckBox1.Checked := true
       else CheckBox1.Checked := false;
   end;

end;

end.
