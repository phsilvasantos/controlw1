unit P4InfoVarejo_Constantes;

interface

resourcestring
  mensagem_01 = 'N�o existem registros com este crit�rio.';
  mensagem_02 = 'Impress�o do cheque n�o foi poss�vel. '+chr(10)+chr(13)+
                'C�digo do movimento banc�rio est� vazio.';
  mensagem_03 = 'Impress�o do cheque n�o foi poss�vel. '+chr(10)+chr(13)+
                 'Nenhum registro foi encontrado com o c�digo do movimento banc�rio.';
  mensagem_04 = 'Impress�o do cheque n�o foi poss�vel. '+chr(10)+chr(13)+
                 'Impress�o do cheque n�o est� configurado para este banco.';
  mensagem_05 = 'N�o existem contatos para esta transportadora.';
  mensagem_06 = 'N�o existem contatos para este representante.';
  mensagem_07 = 'Impress�o n�o foi poss�vel.'+chr(10)+chr(13)+
                 'Duplicata inexistente no banco de dados';
  mensagem_08 = 'N�o existem clientes atendidos para esta transportadora.';
  mensagem_09 = 'N�o existem clientes para este representante.';
  mensagem_10 = 'N�o existe produ��o com o crit�rio especificado.';
  mensagem_11 = 'Produto inexistente!';

const
  P4InfoVarejo_moeda   = '###,###,##0.00';
  P4InfoVarejo_decimal4= '###,###,##0.0000';
  P4InfoVarejo_decimal3= '###,###,##0.000';
  P4InfoVarejo_decimal2= '###,###,##0.00';
  P4InfoVarejo_decimal1= '###,###,##0.0';
  P4InfoVarejo_integer = '###,###,##0';
  P4InfoVarejo_dtbanco = 'mm/dd/yyyy';
  P4InfoVarejo_hrbanco = 'hh:mm:ss';
  P4InfoVarejo_dtabrev = 'dd/mm/yyyy';
  P4InfoVarejo_Sintegra = '###,###,##0000';
  P4InfoVarejo_KeySearch = 121;
  P4InfoVarejo_keymove   = 117;
  P4InfoVarejo_KeyExibeInformacao = 123;
  ad_control_mora_diaria = 6.00;

 //Cript   = '~%()*ẹ�_񪬽�ܫ�-./:;<=>?{|}���~"�#����@%>�!�$+�����`&�����';
 Cript   = 'ABCDEFGHIJKLMNOPQRSTUVXYWZabcdefghijklmnopqrstuvxywz1234567890';
 Decript = '0123456789abcdefghijklmnopqrstuvxywzABCDEFGHIJKLMNOPQRSTUVXYWZ';


implementation

end.











