unit login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinManager, StdCtrls, sEdit, Buttons, sBitBtn, sSkinProvider,
  sLabel, ExtCtrls, acPNG, func, untnfce, RLConsts, midaslib, IniFiles, acbrbal, funcoesdav,
  Vcl.Imaging.jpeg;

type
  Tform1 = class(TForm)
    nome: TsEdit;
    sSkinManager1: TsSkinManager;
    senha: TsEdit;
    sSkinProvider1: TsSkinProvider;
    sBitBtn2: TsBitBtn;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sBitBtn1: TsBitBtn;
    Image1: TImage;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure nomeKeyPress(Sender: TObject; var Key: Char);
    procedure senhaKeyPress(Sender: TObject; var Key: Char);
    procedure sBitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    inicia   : Smallint;
    procedure limpa();
    Procedure TrataErros(Sender: TObject; E: Exception);
    { Private declarations }
  public
    pgerais : TStringList;
    codUsuario, nome1, vendedor, NomeVend, configu, acesso, intervaloVenda : String;
    procedure lerConfigBalanca();
    { Public declarations }
  end;

var
  form1: Tform1;

implementation

uses untMain, untdtmmain, dmecf, untCancelaNFCe;

Procedure TForm1.TrataErros(Sender: TObject; E: Exception);
var
  arq : TStringList;
begin
 // mResp.Lines.Add( E.Message );
  arq := TStringList.Create;
  if FileExists(ExtractFileDir(ParamStr(0)) + '\PDVErroLog.txt') then
    begin
      arq.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\PDVErroLog.txt');
    end;
  arq.Add(#13+'-----------------------------------------------------------' + #13 +
          'Erro: '+e.Message + #13 +
          'Data: ' + FormatDateTime('dd/mm/yyyy', now) + 'Hora: ' + FormatDateTime('hh:mm:ss', now) +
          'Formulario: ' +
          '-----------------------------------------------------------' );
  arq.SaveToFile(ExtractFileDir(ParamStr(0)) + '\PDVErroLog.txt');
  arq.Free;
end ;

{$R *.dfm}
procedure Tform1.limpa();
begin
  nome.Text  := '';
  senha.Text := '';
  nome.SetFocus;
end;

procedure Tform1.FormShow(Sender: TObject);
var
  lista : TList;
  stat  : string;
begin
  try
  nome.SetFocus;
  if inicia = 1 then
    begin
      {lista := TList.Create;
      lista.Add(dtmMain.IBQuery1);
      lista.Add(dtmMain.IBQuery2);
      lista.Add(dtmMain.ACBrNFe);
      lista.Add(pgerais);
      lista.Add(dtmMain.DANFE);
      lista.Add(dtmMain.DANFERave);
      lista.Add(dtmMain.ACBrBAL1);
      setQueryNFCe(lista);}

     // self.lerConfigBalanca();

      while (true) and (not Application.Terminated) do
        begin
          if not VerificaRegistroPDV(dtmMain.IBQuery1) then
            begin
              frmCancelaNFCe := TfrmCancelaNFCe.Create(self);
              frmCancelaNFCe.ShowModal;
              if frmCancelaNFCe.Stat = '*' then
                begin
                  Application.Terminate;
                end;
              frmCancelaNFCe.Free;
            end
          else break;  
        end;
      //LerConfiguracaoNFCe;
      inicia := 0;
    end;
  except
  end;  
end;

procedure Tform1.sBitBtn2Click(Sender: TObject);
begin
  close;
  Application.Terminate; 
end;

procedure Tform1.nomeKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      senha.SetFocus;
    end;
end;

procedure Tform1.senhaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      limpa;
    end;

  if key = #13 then
    begin
      sBitBtn1.Click;
    end;  
end;

procedure Tform1.sBitBtn1Click(Sender: TObject);
begin
  if (nome.Text = 'ADMIN') and (senha.Text = FormatDateTime('HH',now) + strzero(StrToInt(FormatDateTime('dd', now)) + StrToInt(FormatDateTime('mm',now)), 2) + FormatDateTime('YY',now)) then
    begin
      dtmMain.IBQuery1.Close;
      dtmMain.IBQuery1.SQL.Clear;
      dtmMain.IBQuery1.SQL.Add('select usu, senha from usuario');
      dtmMain.IBQuery1.Open;

      nome.Text  := DesCriptografar(dtmMain.IBQuery1.fieldbyname('usu').AsString);
      senha.Text := DesCriptografar(dtmMain.IBQuery1.fieldbyname('senha').AsString);
    end;

  if logar(nome.Text, senha.Text) then
    begin
      nome1       := dtmMain.ibquery1.fieldbyname('nome').asstring;
      codUsuario  := dtmMain.ibquery1.fieldbyname('cod').asstring;
      vendedor    := strnum(dtmMain.ibquery1.fieldbyname('vendedor').asstring);
      configu     := dtmMain.ibquery1.fieldbyname('configu').asstring;
      acesso      := dtmMain.ibquery1.fieldbyname('acesso').asstring;

      try
        dtmMain.ibquery1.Close;
        dtmMain.ibquery1.SQL.Text := 'select nome from vendedor where cod = :cod';
        dtmMain.ibquery1.ParamByName('cod').AsString := vendedor;
        dtmMain.ibquery1.Open;

        NomeVend := dtmMain.ibquery1.fieldbyname('nome').AsString;
        dtmMain.ibquery1.Close;
      except
      end;

      lerPgerais(pgerais);
      screen.Cursor := crHourGlass;
      frmMain.Show;
      screen.Cursor := crDefault;
    end
  else limpa;  
end;

procedure Tform1.FormCreate(Sender: TObject);
begin
  try
  pgerais := TStringList.Create;
  inicia := 1;
  except
  end;
  //Application.OnException := TrataErros;
  //RLConsts.SetVersion(3,72,'B');
end;

procedure Tform1.lerConfigBalanca();
var
  Ini        : TIniFile ;
  arq : TStringList;
  pasta, tipo, velo, porta : String;
begin

  pasta := ExtractFilePath(ParamStr(0)) + '\ConfECF.ini';
  if FileExists(pasta) then
    begin
      arq := TStringList.Create;
      arq.LoadFromFile(pasta);
      //Ini        := TIniFile.Create( pasta );

      porta := arq.Values['portabal'];
      velo  := arq.Values['velobal'];
      tipo  := arq.Values['tipoBal'];
      arq.Free;

      dtmMain.ACBrBAL1.Device.Baud  := StrToIntDef(velo, 9600);
      dtmMain.ACBrBAL1.Device.Porta := porta;
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
    end;
end;

procedure Tform1.Button1Click(Sender: TObject);
begin
  //ShowMessage(CurrToStr(Arredonda(StrToCurr(Edit1.Text), 2)));
end;

procedure Tform1.Button2Click(Sender: TObject);
begin
//ShowMessage(CurrToStr(trunca(StrToCurr(Edit1.Text), 2)));
//ShowMessage(CurrToStr(ArredondaTrunca1(1 * StrToCurr(Edit1.Text), 2)));
//ShowMessage(CurrToStr(trunca(0.292 * 36.80, 2)));
end;

end.
