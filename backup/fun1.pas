unit fun1;

interface



uses
  SysUtils, Classes, StrUtils;

function kreski2(txt: string): integer;
function rgid(txt: string): string;
function token(txt: string): string;  // "url":"
function iloscplikow(txt: string): string;
function wielkoscplikow(txt: string): string;
function katalogwyzej(txt: string): string;
function kataloglink(txt: string): string;
function katalogilosc(txt: string): string;
function sesjajest (txt: string): boolean;
function url(txt: string): string;
function katalog(txt: string): string;
function pliknazwa(txt: string): string;
function plikrozmiar(txt: string): string;

function tylkonumerkatalogu(txt: string): string;
function nazwazlinku(txt,tkn: string): string;
function chromepoprawka(txt: string): string;

function folderwykaz(txt: string): string;
function foldernazwa(txt: string): string;
function foldernowanazwa(txt: string): string;  // folder_id: + 2 znaki

function b2kb2mb2gb(inputdata: string; ilosc : integer): string;

function ilezostaloGB (txt: string): string;
function czypremium (txt: string): string;

var
  i : integer;
implementation

function kreski2(txt: string): integer;
var
  i:integer;
begin

result := 0;
for i:=0 to length(txt) do if txt[i]='/' then result := result + 1;

end;

function rgid(txt: string): string;
var
  i:integer;
begin

i:=PosEx('/rapidgator.net/file/',txt)+21;

repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='/';

end;

function chromepoprawka(txt: string): string;
var
  i:integer;
begin
result :='';                     // 'name':'copy2'
i:=PosEx('name',txt)+7;
//i :=0;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]=' ';

end;


function nazwazlinku(txt,tkn: string): string;
var
  i:integer;
begin
result := '';
i:=PosEx(tkn,txt)+1+length(tkn);
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='"';

end;

function token(txt: string): string;
var
  i, k:integer;
begin
result := '';
i:=PosEx('"token":"',txt)+9;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='"';

end;

function tylkonumerkatalogu(txt: string): string;
var
  i:integer;
begin
result := '';
i:=PosEx('(',txt)+1;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]=')';

end;

function iloscplikow(txt: string): string;
var
  i, k:integer;
begin
result := '';
i:=PosEx('"nb_files":',txt)+11;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]=',';

end;

function wielkoscplikow(txt: string): string;
var
  i, k:integer;
begin
result := '';
i:=PosEx('"size_files":',txt)+13;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]=',';

end;

function katalogwyzej(txt: string): string;
var
  i, k:integer;
begin
result := '';
i:=PosEx('parent_folder_id":"',txt)+19;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='"';

end;

function katalogilosc(txt: string): string;
var
  i, k:integer;
begin
result := '';
i:=PosEx('"nb_folders":',txt)+13;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]=',';

end;

function kataloglink(txt: string): string;
var
  i, k:integer;
begin
result := '';
i:=PosEx('"url":"',txt)+7;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='"';

end;

function sesjajest(txt: string): boolean;
begin
result := false;
if PosEx('Error. Session doesn',txt)=0 then result := false else
result := true
end;

function folderwykaz(txt: string): string;
var
  i, k:integer;
begin
result := '';
i:=PosEx('folders_ids[',txt)+12;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]=']';

end;

function foldernazwa(txt: string): string;
var
  i, k:integer;
begin
result := '';   // 'name':'
i:=PosEx('"name":"',txt)+8;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i+1]='}';
end;

function foldernowanazwa(txt: string): string;  // folder_id: + 2 znaki

var
  i, k:integer;
begin
result := '';   // 'name':'
i:=PosEx('"name":"',txt)+8;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i+1]='"';

end;
function url(txt: string): string;
var
  i, k:integer;
begin
result := '';
i:=PosEx('"url":"',txt)+7;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='"';

end;

function katalog (txt: string): string;
var
  i, k:integer;
begin
result := '';   // "folder_id":"
i:=PosEx('folder_id":"',txt)+12;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='"';
end;

function plikrozmiar (txt: string): string;
var
  i, k:integer;
begin
result := '';
i:=PosEx('"size":',txt)+7;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='"';

end;

function pliknazwa (txt: string): string;
var
  i, k:integer;
begin
result := '';
i:=PosEx('"name":"',txt)+8;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='"';

end;

function czypremium (txt: string): string;
var
  i:integer;
begin
result := '';
i:=PosEx('is_premium":',txt)+12;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]=',';
if result = 'true' then result :='premium' else result:= 'non premium';

end;

function ilezostaloGB (txt: string): string;
var
  i:integer;
begin
result :='';
i:=PosEx('"left":',txt)+7;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='}';
//if result = 'true' then result :='premium' else result:= 'non premium';

end;


function b2kb2mb2gb(inputdata: string; ilosc : integer): string;

// _______________________________________________________________________
//   PL info
//
//   Automatyczny konwerter jednostki: bajtów na kilo, mega i giga bajty.
//   W funkcji podaje się zmienną (inpudata: string) liczbę w bajtach
//   oraz (ilosc: integer) ilość miejsc po przecinku,
//   którą chce się uzyskać 0, 1, 2
//   inne wartości zostaną zmienione na 0 - wynik pozyskuje się jako zmienną
//   STRING
//
// _______________________________________________________________________
//   ENG info
//   Automathic converter bytes to kilo, mega and giga bytes.
//   Input data is bytes (string) with information how many digits after dot
//   should be presented as a result (0,1 or 2, other will be change to 0)
//   result is STRING
// _______________________________________________________________________
//   Example code
//   add this function to your *.pas file after { TForm1 }
//
//   add edit1 (input, bytes) and edit2 (result) to your form1
//
//   for edit1.OnChange add this code:
//   edit2.text:=b2kb2mb2gb(edit1.text,2);
//
//   that's all :) your converter is ready
//
//   input data is: 44684628285, result you get: 41,62 GB
// _______________________________________________________________________
//   Author: .........@gmail.com

var
  wsad,patatajpatataj:string;
begin

//check if input value is integer ;)
try
//wsad:=inttostr(inputdata);
wsad:=(inputdata);

// check number digits after dot, must be 0 or 1 or 2 else I set to 0
if ((ilosc<0)and(ilosc>2)) then ilosc:=0;
// transform to kB
if ((length(wsad)>3)and(length(wsad)<7)) then
  begin
  // change to MB size with proper formatting
  patatajpatataj:=floattostrf(strtofloat(wsad)/1024,ffFixed ,ilosc+2,ilosc);
  result:=patatajpatataj+' kB';
  end;

// to MB
if ((length(wsad)>6)and(length(wsad)<10)) then
  begin
  patatajpatataj:=floattostrf(strtofloat(wsad)/1048576,ffFixed ,ilosc+2,ilosc);
  result:=patatajpatataj+' MB';
  end;

// to GB
if ((length(wsad)>9)and(length(wsad)<13)) then
  begin
  patatajpatataj:=FloatToStrF((strtofloat(wsad)/1073741824),ffFixed ,ilosc+2,ilosc);
  result:=patatajpatataj+' GB';
  end;

// too small filesize

if (length(wsad)<4) then result:='~0MB';

if ((length(wsad)>12)and(length(wsad)<16)) then
  begin
  patatajpatataj:=FloatToStrF((strtofloat(wsad)/1099511627776),ffGeneral  ,ilosc+2,ilosc);
  result:=patatajpatataj+' TB';
  end

except // if input is not integer then this :)
//showmessage('Please use integer values to get good result');
result:='0';
end;


end;


end.
