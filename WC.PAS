{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2021
  @website(https://www.gladir.com/unicos-0)
  @abstract(Target: Turbo Pascal, Free Pascal)
}

Program WC(Input,Output);

Uses DOS;

Var
 Info:SearchRec;
 Target:(_None,_Line,_Byte,_Character,_Word);
 I:LongInt;
 FRead:Text;
 FileName:String;
 CurrLine:String;

Function WordCount(S:String):Integer;
Var
 I,Count:Integer;
Begin
 If Length(S)=0Then WordCount:=0
  Else
 Begin
  If S[1]=' 'Then Count:=0
             Else Count:=1;
  For I:=1 to Length(S)do Begin
   If(S[I]=' ')and(S[I+1]<>' ')and(S[I+2]<>' ')Then Inc(Count) Else
   If(S[I]='-')and(S[I-1]<>' ')and(S[I+1]<>' ')Then Inc(Count);
  End;
  WordCount:=Count;
 End;
End;

BEGIN
 If(ParamStr(1)='/?')or(ParamStr(1)='--help')or(ParamStr(1)='-h')Then Begin
  WriteLn('WC : Cette commande permet de compter le nombre de mots, de lignes, de caracteres.');
  WriteLn;
  WriteLn('Syntaxe : WC [nomdefichier(s)] [-l] [-c] [-w]');
  WriteLn;
  WriteLn(' --byte   Ce parametre permet de compter les octets');
  WriteLn(' -c       Ce parametre permet de compter les octets');
  WriteLn(' -C       Ce parametre permet de compter les caracteres');
  WriteLn(' --chars  Ce parametre permet de compter les caracteres');
  WriteLn(' -l       Ce parametre permet de compter les lignes');
  WriteLn(' -w       Ce parametre permet de compter les mots (2 octets)');
 End
  Else
 Begin
  Target:=_None;
  FileName:='';
  For I:=1 to ParamCount do Begin
   If(ParamStr(I)='-l')or(ParamStr(I)='--lines')Then Target:=_Line Else
   If(ParamStr(I)='-C')or(ParamStr(I)='--chars')or(ParamStr(I)='-m')Then Target:=_Character Else
   If(ParamStr(I)='-c')or(ParamStr(I)='--bytes')Then Target:=_Byte Else
   If(ParamStr(I)='-w')or(ParamStr(I)='--words')Then Target:=_Word
                                                Else FileName:=ParamStr(I);
  End;
  If Target=_None Then Begin
   WriteLn('Compteur ind�fini');
   Halt;
  End;
  If FileName<>''Then Begin
   I:=0;
   FindFirst(FileName,AnyFile,Info);
   While DOSError=0 do Begin
    If Info.Attr and Directory=0 Then Begin
     Assign(FRead,Info.Name);
     Reset(FRead);
     Case Target of
      _Line:Begin
       While Not EOF(FRead) do Begin
        ReadLn(FRead,CurrLine);
        Inc(I);
       End;
      End;
      _Byte,_Character:Begin
       While Not EOF(FRead) do Begin
        ReadLn(FRead,CurrLine);
        Inc(I,Length(CurrLine)+2);
       End;
      End;
      _Word:Begin
       While Not EOF(FRead) do Begin
        ReadLn(FRead,CurrLine);
        Inc(I,WordCount(CurrLine));
       End;
      End;
     End;
     Close(FRead);
    End;
    FindNext(Info);
   End;
   WriteLn(I);
  End
   Else
  Begin
   Case Target of
    _Line:Begin
     I:=0;
     While Not EOF do Begin
      ReadLn(Input,CurrLine);
      Inc(I);
     End;
     WriteLn(I);
    End;
    _Byte,_Character:Begin
     I:=0;
     While Not EOF do Begin
       ReadLn(Input,CurrLine);
       Inc(I,Length(CurrLine)+2);
     End;
     WriteLn(I);
    End;
    _Word:Begin
     I:=0;
     While Not EOF do Begin
      ReadLn(Input,CurrLine);
      Inc(I,WordCount(CurrLine));
     End;
     WriteLn(I);
    End;
   End;
  End;
 End;
END.
