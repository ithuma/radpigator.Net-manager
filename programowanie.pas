unit programowanie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus, fun1,
  StdCtrls, fpjson, fphttpclient, jsonparser, ClipBrd, ExtCtrls, Buttons,
  ShellAPI, INIFiles, opensslsockets, StrUtils  ;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    ButtonCheckList: TButton;
    ButtonCleanCheckList: TButton;
    ButtonGetFolders: TButton;
    ButtonReadFolder2Delete: TButton;
    ButtonDeleteList: TButton;
    ButtonDeleteFolder: TButton;
    ButtonChangeFolderName: TButton;
    ButtonCleanList: TButton;
    ButtonDeleteFiles: TButton;
    ButtonSzukaj: TButton;
    Button3: TButton;
    ButtonEksportList: TButton;
    Button8: TButton;
    ButtonCopyFiles: TButton;
    ButtonAddNewFolder: TButton;
    ButtonTKN: TButton;
    ButtonFolderDocelowy: TButton;
    ButtonLoadFolder: TButton;
    ButtonZapisz: TButton;
    CheckBox1: TCheckBox;
    ComboBoxDeleteFolder: TComboBox;
    ComboBoxChangeFolderName: TComboBox;
    ComboBoxFolder: TComboBox;
    ComboBoxFolderCopy: TComboBox;
    EditTemp: TEdit;
    EditFolderChangeName: TEdit;
    EditSzukaj: TEdit;
    EditFolderNewName: TEdit;
    EditFolder: TEdit;
    EditLogin: TEdit;
    EditHaslo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Labelchecklist: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LabelHaslo: TLabel;
    LabelLogin: TLabel;
    ListBox1: TListBox;
    lb1: TListBox;
    ListBoxDeleteFiles: TListBox;
    ListBoxFolderNazwa: TListBox;
    ListBoxFolder: TListBox;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo5: TMemo;
    MemoCheckList: TMemo;
    MemoFolderZmiany: TMemo;
    MemoFolderInfo: TMemo;
    MemoTemp: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PanelUsuwanie: TPanel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    ProgressBar3: TProgressBar;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TimerCheckLink: TTimer;
    TimerTKN: TTimer;
    TimerMove: TTimer;
    TimerDelete: TTimer;
    TimerCopy: TTimer;
    TimerFiltruj: TTimer;
    TimerZapiszListe: TTimer;
    TimerPobierzListe: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonCheckListClick(Sender: TObject);
    procedure ButtonCleanCheckListClick(Sender: TObject);
    procedure ButtonGetFoldersClick(Sender: TObject);
    procedure ButtonReadFolder2DeleteClick(Sender: TObject);
    procedure ButtonChangeFolderNameClick(Sender: TObject);
    procedure ButtonCleanListClick(Sender: TObject);
    procedure ButtonDeleteFilesClick(Sender: TObject);
    procedure ButtonDeleteFolderClick(Sender: TObject);
    procedure ButtonDeleteListClick(Sender: TObject);
    procedure ButtonSzukajClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ButtonEksportListClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ButtonAddNewFolderClick(Sender: TObject);
    procedure ButtonCopyFilesClick(Sender: TObject);
    procedure ButtonFolderDocelowyClick(Sender: TObject);
    procedure ButtonLoadFolderClick(Sender: TObject);
    procedure ButtonTKNClick(Sender: TObject);
    procedure ButtonZapiszClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBoxFolderChange(Sender: TObject);
    procedure ComboBoxFolderCopyChange(Sender: TObject);
    procedure ComboBoxFolderKeyPress(Sender: TObject; var Key: char);
    procedure EditSzukajKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBoxFolderClick(Sender: TObject);
    procedure MemoTempChange(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure PanelUsuwanieClick(Sender: TObject);
    procedure TimerCheckLinkTimer(Sender: TObject);
    procedure TimerCopyTimer(Sender: TObject);
    procedure TimerDeleteTimer(Sender: TObject);
    procedure TimerFiltrujTimer(Sender: TObject);
    procedure TimerMoveTimer(Sender: TObject);
    procedure TimerPobierzListeTimer(Sender: TObject);
    procedure TimerTKNTimer(Sender: TObject);
    procedure TimerZapiszListeTimer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  i, j, inactivefile: integer;
  dir, lg, ps, tokennr, kataloginfo, tekst : string;
  calosc, wiersz : widestring;
  admin, trybszukania : boolean;
  AHTTPClient1: TFPHTTPClient;
  APostValues1: TStringList;
  AUrl1, AResult1: string;
  INI, settings : TINIFile;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

admin := false;

PanelUsuwanie.Align := AlClient;

dir := getcurrentdir;
dir := dir + '\';

if fileexists ( dir + 'fun1.pas') then admin := true;

memoTemp.Clear;

INI := TINIFile.Create(dir + 'data.ini');
settings := TINIFile.Create(dir + 'set.ini');

if settings.ReadString('base','login','') <>'' then
  begin
  editLogin.Text := settings.ReadString('base','login','');
  lg := editLogin.Text;
    editHaslo.Text := settings.ReadString('base','password','');
  ps := editHaslo.Text;
  end else showmessage('uzupełnij dane logowania oraz podaj dane do identyfikacji folderów na koncie');

ComboboxFolder.Text := settings.ReadString('base','mainfolder','');
ComboboxFolderCopy.Text := settings.ReadString('base','copyfolder','');

if admin = true then

  beGIN
    memo1.Visible := true;
    memo2.Visible := true;
    memo5.Visible := true;
    memoTemp.Visible := true;
    button1.Visible := true;
    ButtonTKN.Visible := true;
  eND;

if lg='' then showmessage('brak loginu do konta') else
   if ps='' then showmessage('brak hasła do konta') else
buttontkn.Click;
timerTKN.Enabled:=true;

pagecontrol1.ActivePage := tabsheet1;

end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin

if trybszukania = false then
if ListBox1.ItemIndex < 0 then showmessage('lista plików pusta, odśwież dane z katalogu') else
   BEGIN

   lb1.Items.Insert( 0 , 'plik ' + pliknazwa ( ( memo2.Lines.Strings[ ListBox1.ItemIndex ] ) )+' rozmiar '+ b2kb2mb2gb ( plikrozmiar ( memo2.Lines.Strings[ ListBox1.ItemIndex ] ), 2 ) );
   EditSzukaj.Text:= pliknazwa ( memo2.Lines.Strings[ ListBox1.ItemIndex ] ) ;
   if listbox1.Items.Strings[0] <> '' then
      if admin = true then
         memoFolderZmiany.Lines.Insert( 0 , 'id pliku pierwszego na liście: ' + rgid ( listbox1.Items.Strings[0] ) );
   END else
 if trybszukania = true then EditSzukaj.Text := nazwazlinku ( listbox1.Items.Strings[ listbox1.ItemIndex ], rgid (listbox1.Items.Strings[ listbox1.ItemIndex ]) );
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin

ClipBoard.AsText := listbox1.Items.Strings[ listbox1.ItemIndex ];

end;

procedure TForm1.ListBoxFolderClick(Sender: TObject);
var
  kataloginfo, linkzle : string;
begin

if ListBoxFolder.ItemIndex > -1 then
  BEGIN
  EditFolder.Text :=  ( ListBoxFolder.Items.Strings[ ListBoxFolder.ItemIndex ] );
  memoFolderZmiany.Lines.Insert( 0 , 'wybrano katalog: ' + EditFolder.Text );

  memotemp.Clear;
  AUrl1 := 'https://rapidgator.net/api/v2/folder/info?token='+ tokennr +'&folder_id='+ tylkonumerkatalogu( EditFolder.Text ) ;
  AHTTPClient1 := TFPHTTPClient.Create(nil);
  try
    AHTTPClient1.AllowRedirect := True;
      APostValues1 := TStringList.Create;
       try
        AResult1 := AHTTPClient1.SimpleGet(AUrl1);
        memoTemp.Lines.AddStrings(AResult1);
        except
        on E: exception do ShowMessage(E.Message);
        end;
        finally
        APostValues1.Free;
        AHTTPClient1.Free;
        end;

kataloginfo:='';
for i:=0 to (memoTemp.Lines.Count-1) do kataloginfo:= kataloginfo + memoTemp.Lines.Strings[i];

  if admin = true then memoTemp.Lines.SaveToFile( dir + '02 dane o katalogu z konta.txt' );

  memoFolderInfo.Lines.Clear;
  memoFolderInfo.Lines.Add( 'nazwa katalogu: ' +  ini.ReadString( EditFolder.Text, '0', '' ) );  // name
  memoFolderInfo.Lines.Add( 'ilość plików w katalogu: ' +  iloscplikow ( kataloginfo ) );
  memoFolderInfo.Lines.Add( 'wielkość plików w katalogu: ' +  b2kb2mb2gb ( wielkoscplikow ( kataloginfo ), 2 ) );
  memoFolderInfo.Lines.Add( 'ilość katalogów w katalogu: ' +  katalogilosc ( kataloginfo ) );

  linkzle := StringReplace (  kataloglink ( kataloginfo ), '\/' , '/', [rfReplaceAll, rfIgnoreCase] );
  memoFolderInfo.Lines.Add( 'link bezpośredni do katalogu: ' +  linkzle );

  if katalogwyzej ( kataloginfo ) ='null' then memoFolderInfo.Lines.Add( 'brak katalogu wyżej' ) else
  memoFolderInfo.Lines.Add( 'nazwa katalogu wyżej: ' +  katalogwyzej ( kataloginfo ) );

  END;

end;

procedure TForm1.MemoTempChange(Sender: TObject);
begin

end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin

ButtonCopyFiles.click;

end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin

if ComboBoxFolder.Text = '' then showmessage ('wybierz katalog bazowy, z którego będzie wykonane przeniesienie') else
  if ComboBoxFolderCopy.Text = '' then showmessage ('wybierz katalog do którego będą pzeniesione pliki') else
if listbox1.Items.count = 0 then showmessage ('brak plików na liście do przeniesienia') else

     BEGIN
     memotemp.Clear;
     lb1.items.Insert( 0 , 'cała lista plików/plik jest przenoszona' );
     j :=0;
     progressbar1.Position := 0;
     progressbar1.Max      := listbox1.Items.Count;
     progressbar1.Visible  := true;
     timerMove.Enabled := true;
     END;

end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  ButtonEksportList.Click;
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin

showmessage( 'Version 1.0.0.0.0.0 beta'+#13+
             'Author: web user'+#13+
             'non comerciall use');

end;

procedure TForm1.PanelUsuwanieClick(Sender: TObject);
begin

if MessageDlg('Naprawdę pragniesz dokonać usuwania plików/folderów na koncie ?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
   PanelUsuwanie.Visible:=false;
end;

procedure TForm1.TimerCheckLinkTimer(Sender: TObject);
begin

memoTemp.Lines.Clear;
AUrl1 := 'https://rapidgator.net/api/v2/file/info?token='+ tokennr +'&file_id='+ rgid ( memoCheckList.LInes.Strings[j] ) ;
AHTTPClient1 := TFPHTTPClient.Create(nil);
try
AHTTPClient1.AllowRedirect := True;
  APostValues1 := TStringList.Create;
   try
    AResult1 := AHTTPClient1.SimpleGet(AUrl1);
    memoTemp.Lines.AddStrings(AResult1);
    except
    on E: exception do ShowMessage(E.Message);
    end;
    finally
    APostValues1.Free;
    AHTTPClient1.Free;
    end;
if admin = true then memoTemp.Lines.SaveToFile( dir + 'sprawdzenie pliku online - odp api.txt');

if PosEx('Error:', memoTemp.LInes.Strings[0]) > 0 then
     begin
     memocheckList.Lines.Delete(j);
     inactivefile := inactivefile +1;
     end;

progressbar3.Position:= j;
j := j - 1;

if j=-1 then
   begin
   TimerCheckLink.Enabled:=false;
   showmessage( intTostr( inactivefile ) + ' plików jest nieaktywnych, pozostałe pliki pozostały na liście');
   end;
if TimerCheckLink.Enabled = false then progressbar3.Visible  := false;

end;

procedure TForm1.TimerCopyTimer(Sender: TObject);
begin

AUrl1 := 'https://rapidgator.net/api/v2/file/copy?token='+ tokennr +'&folder_id_dest='+ tylkonumerkatalogu (ComboBoxFolderCopy.Text) +'&file_id='+ rgid ( listbox1.Items.Strings[j] ) ;
AHTTPClient1 := TFPHTTPClient.Create(nil);
try
AHTTPClient1.AllowRedirect := True;
  APostValues1 := TStringList.Create;
   try
    AResult1 := AHTTPClient1.SimpleGet(AUrl1);
    memoTemp.Lines.AddStrings(AResult1);
    except
    on E: exception do ShowMessage(E.Message);
    end;
    finally
    APostValues1.Free;
    AHTTPClient1.Free;
    end;
progressbar1.Position:=j;
j := j + 1;

if j=listbox1.Items.Count then timerCopy.Enabled:=false;

if timerCopy.Enabled = false then progressbar1.Visible  := false;

end;

procedure TForm1.TimerDeleteTimer(Sender: TObject);
begin

AUrl1 := 'https://rapidgator.net/api/v2/file/delete?token='+ tokennr +'&file_id='+ rgid ( listboxDeleteFiles.Items.Strings[j] ) ;
AHTTPClient1 := TFPHTTPClient.Create(nil);
try
AHTTPClient1.AllowRedirect := True;
  APostValues1 := TStringList.Create;
   try
    AResult1 := AHTTPClient1.SimpleGet(AUrl1);
    memoTemp.Lines.AddStrings(AResult1);
    except
    on E: exception do ShowMessage(E.Message);
    end;
    finally
    APostValues1.Free;
    AHTTPClient1.Free;
    end;

progressbar2.Position:=j;
j := j + 1;

if j=listboxDeleteFiles.Items.Count then timerDelete.Enabled:=false;
if timerDelete.Enabled = false then progressbar2.Visible  := false;

end;

procedure TForm1.TimerFiltrujTimer(Sender: TObject);
begin

TimerFiltruj.Enabled := false;
Button1.Click;

end;

procedure TForm1.TimerMoveTimer(Sender: TObject);
begin

AUrl1 := 'https://rapidgator.net/api/v2/file/move?token='+ tokennr +'&folder_id_dest='+ tylkonumerkatalogu (ComboBoxFolderCopy.Text) +'&file_id='+ rgid ( listbox1.Items.Strings[j] ) ;
AHTTPClient1 := TFPHTTPClient.Create(nil);
try
AHTTPClient1.AllowRedirect := True;
  APostValues1 := TStringList.Create;
   try
    AResult1 := AHTTPClient1.SimpleGet(AUrl1);
    memoTemp.Lines.AddStrings(AResult1);
    except
    on E: exception do ShowMessage(E.Message);
    end;
    finally
    APostValues1.Free;
    AHTTPClient1.Free;
    end;
progressbar1.Position:=j;
j := j + 1;

if j=listbox1.Items.Count then timerMove.Enabled:=false;

if timerMove.Enabled = false then progressbar1.Visible  := false;
end;

procedure TForm1.TimerPobierzListeTimer(Sender: TObject);
begin

TimerPobierzListe.Enabled := false;

memotemp.Clear;
if ComboBoxFolder.Text = '' then
AUrl1 := 'https://rapidgator.net/api/v2/folder/content?per_page=500&token='+tokennr
else AUrl1 := 'https://rapidgator.net/api/v2/folder/content?folder_id='+ tylkonumerkatalogu (ComboBoxFolder.Text) +'&token='+tokennr;

if admin = true then if ComboBoxFolder.Text = '' then
     lb1.Items.Insert( 0 , 'szukanie bez numeru katalogu') else lb1.Items.Insert( 0 , 'szukanie w katalogu nr: ' + ComboBoxFolder.Text );

AHTTPClient1 := TFPHTTPClient.Create(nil);
try
    AHTTPClient1.AllowRedirect := True;
      APostValues1 := TStringList.Create;
       try
        AResult1 := AHTTPClient1.SimpleGet(AUrl1);
        memoTemp.Lines.AddStrings(AResult1);
        except
        on E: exception do ShowMessage(E.Message);
        end;
        finally
        APostValues1.Free;
        AHTTPClient1.Free;
        end;

TimerZapiszListe.Enabled := true;
TimerFiltruj.Enabled := true;
end;

procedure TForm1.TimerTKNTimer(Sender: TObject);
begin

timerTKN.Enabled:=false;

memotemp.Clear;
AUrl1 := 'https://rapidgator.net/api/v2/user/info?token='+ tokennr;
AHTTPClient1 := TFPHTTPClient.Create(nil);
try
  AHTTPClient1.AllowRedirect := True;
    APostValues1 := TStringList.Create;
     try
      AResult1 := AHTTPClient1.SimpleGet(AUrl1);
      memoTemp.Lines.AddStrings(AResult1);
      except
      on E: exception do ShowMessage(E.Message);
      end;
      finally
      APostValues1.Free;
      AHTTPClient1.Free;
      end;
   tekst := '';
   if admin = true then memoTemp.Lines.SaveToFile(dir + 'dane o koncie uzytkownika - odpowiedz api.txt');
   for i:=0 to (memoTemp.Lines.Count-1) do tekst := tekst + memoTemp.Lines.Strings[i];

lb1.Items.Insert( 0 , 'account: '+ czypremium(tekst)+', na koncie pozostało: ' + b2kb2mb2gb (ilezostaloGB (tekst), 2 ) );
end;

procedure TForm1.TimerZapiszListeTimer(Sender: TObject);
begin

TimerZapiszListe.Enabled := false;

if admin = true then memoTemp.Lines.SaveToFile( dir + 'dorawilk.dll' );

end;

procedure TForm1.ButtonZapiszClick(Sender: TObject);
begin

settings.WriteString('base','login', editLogin.Text);
lg :=editLogin.Text;
settings.WriteString('base','password', editHaslo.Text);
ps :=editHaslo.Text;
settings.UpdateFile;
buttonTKN.Click;

end;

procedure TForm1.Button1Click(Sender: TObject);

begin

calosc:='';
for i:=0 to (memoTemp.Lines.Count-1) do calosc:= calosc + memoTemp.Lines.Strings[i];

memo1.Lines.Clear;
for i:=0 to ( length ( calosc ) -1 ) do
  if calosc[i]='{' then memo1.Lines.Add( intTostr(i) );

memo2.Lines.Clear;

for i:=0 to (memo1.Lines.Count-2) do
   Begin

   wiersz := '';
   for j:=strtoint(memo1.Lines.Strings[i]) to strtoint(memo1.Lines.Strings[i+1]) do

      begiN
      wiersz := wiersz + calosc[j];
      enD;

   memo2.Lines.Add( wiersz );
   End;

for i := (memo2.Lines.Count-1) downto 0 do
  if PosEx ( 'file_id', memo2.Lines.strings[i] ) = 0 then memo2.Lines.Delete(i) ;

lb1.Items.Insert( 0 , 'znaleziono w bazie: ' + intToStr( memo2.Lines.Count ) +' wpisów');

lb1.Items.Insert( 0 , 'trwa analiza wpisów');

for i := 0 to (memo2.Lines.Count-1) do
     memo2.Lines.strings[i] := StringReplace (  memo2.Lines.strings[i], '\/' , '/', [rfReplaceAll, rfIgnoreCase] );

lb1.Items.Insert( 0 , 'baza danych gotowa');
if admin = true then memo2.Lines.SaveToFile( dir + 'wynik-szukania.txt' );

for i:=0 to (memo2.Lines.Count-1) do
   listbox1.Items.Add( url (memo2.Lines.Strings[i] ) );


end;

procedure TForm1.ButtonCheckListClick(Sender: TObject);
begin

inactivefile :=0;
j :=memocheckList.lines.Count-1;
progressbar3.Position := memocheckList.lines.Count;
progressbar3.Max      := memocheckList.lines.Count;
progressbar3.Visible  := true;

TimerCheckLink.Enabled := true;

end;

procedure TForm1.ButtonCleanCheckListClick(Sender: TObject);
begin

memoCheckList.clear;

end;

procedure TForm1.ButtonGetFoldersClick(Sender: TObject);
begin

memotemp.Clear;
AUrl1 := 'https://rapidgator.net/api/v2/folder/info?token='+ tokennr;
AHTTPClient1 := TFPHTTPClient.Create(nil);
try
  AHTTPClient1.AllowRedirect := True;
    APostValues1 := TStringList.Create;
     try
      AResult1 := AHTTPClient1.SimpleGet(AUrl1);
      memoTemp.Lines.AddStrings(AResult1);
      except
      on E: exception do ShowMessage(E.Message);
      end;
      finally
      APostValues1.Free;
      AHTTPClient1.Free;
      end;
   tekst := '';
   if admin = true then memoTemp.Lines.SaveToFile(dir + 'pelna lista katalogow - odpowiedz api.txt');

   calosc:='';
   for i:=0 to (memoTemp.Lines.Count-1) do calosc:= calosc + memoTemp.Lines.Strings[i];
   if admin = true then memoTemp.Lines.SaveToFile( dir + 'wszystko odpowiedz z katalogami.txt');
   memo1.Lines.Clear;
   for i:=0 to ( length ( calosc ) -1 ) do
     if calosc[i]+calosc[i+1]+calosc[i+2]='{"f' then memo1.Lines.Add( intTostr(i) );
   memo1.Lines.Add( intTostr( length (calosc) ) );
  if admin = true then memo1.Lines.SaveToFile( dir + 'wiersze z katalogami przed selekcją.txt');
   memo2.Lines.Clear;

   for i:=0 to (memo1.Lines.Count-2) do
      Begin
      wiersz := '';
      for j:=strtoint(memo1.Lines.Strings[i]) to strtoint(memo1.Lines.Strings[i+1]) do
         wiersz := wiersz + calosc[j];

      memo2.Lines.Add( wiersz );
      End;
   tekst := '';

  if admin = true then memo2.Lines.SaveToFile( dir + 'wiersze z katalogami.txt');
   for i := (memo2.Lines.Count-1) downto 0 do
     if PosEx ( 'folder_id', memo2.Lines.strings[i] ) = 0 then memo2.Lines.Delete(i) ;
  if admin = true then memo2.Lines.SaveToFile( dir + 'po usunięciu wiersze z katalogami.txt');
for i := 0 to (memo2.Lines.Count-1) do

  ini.WriteString( katalog (memo2.Lines.strings[i]), '0', pliknazwa (memo2.Lines.strings[i]) );
  ini.UpdateFile;
end;

procedure TForm1.ButtonReadFolder2DeleteClick(Sender: TObject);
begin
ComboBoxDeleteFolder.Clear;
  ini.ReadSections( ComboBoxDeleteFolder.Items );
for i := 0 to ( ComboBoxDeleteFolder.Items.Count-1 ) do
  ComboBoxDeleteFolder.Items.Strings[i] := ini.ReadString( ComboBoxDeleteFolder.Items.Strings[i], '0', '')  + ' (' + ComboBoxDeleteFolder.Items.Strings[i] + ')';

end;

procedure TForm1.ButtonChangeFolderNameClick(Sender: TObject);
var
  tekst : string;
begin

if comboboxChangeFolderName.Text = '' then showmessage('wybierz aktualny katalog do zmiany jego nazwy') else
if EditFolderChangeName.text <> '' then
  begin

  memotemp.Clear;
  AUrl1 := 'https://rapidgator.net/api/v2/folder/rename?token='+ tokennr +'&name='+ EditFolderChangeName.text + '&folder_id='+ tylkonumerkatalogu (ComboBoxChangeFolderName.Text) ;
  AHTTPClient1 := TFPHTTPClient.Create(nil);
  try
    AHTTPClient1.AllowRedirect := True;
      APostValues1 := TStringList.Create;
       try
        AResult1 := AHTTPClient1.SimpleGet(AUrl1);
        memoTemp.Lines.AddStrings(AResult1);
        except
        on E: exception do ShowMessage(E.Message);
        end;
        finally
        APostValues1.Free;
        AHTTPClient1.Free;
        end;
     tekst := '';

     for i:=0 to (memoTemp.Lines.Count-1) do tekst := tekst + memoTemp.Lines.Strings[i];

  ini.WriteString( katalog ( tekst ) , '0', EditFolderChangeName.text  );
  ini.UpdateFile;
   ComboBoxFolder.Clear;
   ini.ReadSections( ComboBoxFolder.Items );
   for i := 0 to ( ComboBoxFolder.Items.Count-1 ) do
   ComboBoxFolder.Items.Strings[i] := ini.ReadString( ComboBoxFolder.Items.Strings[i], '0', '')  + ' (' + ComboBoxFolder.Items.Strings[i] + ')';
   ComboBoxFolderCopy.Clear;
   ini.ReadSections( ComboBoxFolderCopy.Items );
   for i := 0 to ( ComboBoxFolderCopy.Items.Count-1 ) do
  ComboBoxFolderCopy.Items.Strings[i] := ini.ReadString( ComboBoxFolderCopy.Items.Strings[i], '0', '')  + ' (' + ComboBoxFolderCopy.Items.Strings[i] + ')';

  comboboxChangeFolderName.Text := '';
  EditFolderChangeName.text :='';
  end;
end;

procedure TForm1.ButtonCleanListClick(Sender: TObject);
begin

listboxDeleteFiles.Clear;

end;

procedure TForm1.ButtonDeleteFilesClick(Sender: TObject);
begin

if listboxDeleteFiles.Items.Strings[0]= '' then showmessage ('brak plików na liście do skasowania') else

     BEGIN
     memotemp.Clear;
     memoFolderZmiany.Lines.Insert( 0 , 'cała lista plików/plik są kasowane' );
     j :=0;
     progressbar2.Position := 0;
     progressbar2.Max      := listboxDeleteFiles.Items.Count;
     progressbar2.Visible  := true;
     timerDelete.Enabled := true;
     END;

end;

procedure TForm1.ButtonDeleteFolderClick(Sender: TObject);
begin

if ComboBoxDeleteFolder.Text = '' then showmessage('wybierz z listy katalog do skasowania') else
  begin
  memotemp.Clear;
  AUrl1 := 'https://rapidgator.net/api/v2/folder/delete?token='+ tokennr+ '&folder_id='+ tylkonumerkatalogu (ComboBoxDeleteFolder.Text) ;
  AHTTPClient1 := TFPHTTPClient.Create(nil);
  try
    AHTTPClient1.AllowRedirect := True;
      APostValues1 := TStringList.Create;
       try
        AResult1 := AHTTPClient1.SimpleGet(AUrl1);
        memoTemp.Lines.AddStrings(AResult1);
        except
        on E: exception do ShowMessage(E.Message);
        end;
        finally
        APostValues1.Free;
        AHTTPClient1.Free;
        end;
   ini.EraseSection ( tylkonumerkatalogu ( ComboBoxDeleteFolder.text ) );
   ini.UpdateFile;
   ComboBoxFolder.Clear;
   ini.ReadSections( ComboBoxFolder.Items );
   for i := 0 to ( ComboBoxFolder.Items.Count-1 ) do
   ComboBoxFolder.Items.Strings[i] := ini.ReadString( ComboBoxFolder.Items.Strings[i], '0', '')  + ' (' + ComboBoxFolder.Items.Strings[i] + ')';
   ComboBoxFolderCopy.Clear;
   ini.ReadSections( ComboBoxFolderCopy.Items );
   for i := 0 to ( ComboBoxFolderCopy.Items.Count-1 ) do
   ComboBoxFolderCopy.Items.Strings[i] := ini.ReadString( ComboBoxFolderCopy.Items.Strings[i], '0', '')  + ' (' + ComboBoxFolderCopy.Items.Strings[i] + ')';
   ButtonReadFolder2Delete.Click;
   showmessage('usunięto katalog z listy');
  end;
end;

procedure TForm1.ButtonDeleteListClick(Sender: TObject);
begin

if MessageDlg('Naprawdę pragniesz dodać pliki na listę do skasowania ?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
     for i:=0 to (listbox1.Items.Count-1) do
       ListBoxDeleteFiles.Items.Add( listbox1.Items.Strings[i] ) ;

end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin

trybszukania := false;

if ComboBoxFolder.Text = '' then showmessage( 'nie wybrano katalogu do ujawnienia listy plików') else

 BEGIN
  if admin = true then lb1.Items.Insert( 0 , 'token: ' + tokennr);
  listbox1.Items.Clear;

  if tokennr <> '' then
   begin
   TimerPobierzListe.Enabled := true;
   lb1.Items.Insert( 0 , 'pobrano listę plików' );
   checkbox1.Color := clGreen;
   end else
  showmessage( 'coś poszło nie tak, spróbuj później' );

 end;

end;

procedure TForm1.ButtonSzukajClick(Sender: TObject);
var
  look : integer;
begin
 look := 0;
 if listbox1.Items.Strings[0]='' then showmessage('brak danych do przeszukania, wczytaj katalog z plikami') else
  if EditSzukaj.Text = '' then showmessage('wpisz co ma być wyszukane, obecnie pole jest puste') else
       for i:= (listbox1.Items.Count-1) downto 0 do
         if posEx( EditSzukaj.Text, listbox1.Items.Strings[i])=0 then
            BEGIN
               listbox1.Items.Delete(i);
               look := look + 1;
               trybszukania := true;
            END;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin

button1.Click;

end;

procedure TForm1.ButtonEksportListClick(Sender: TObject);
begin

if listbox1.Items.Count=0 then showmessage('brak plików w wykazie/na liście, odśwież listę') else
   begin
   memo1.Clear;
    for i:=0 to (listbox1.Items.Count-1) do
    memo1.Lines.Add( listbox1.Items.Strings[i] );
    memo1.SelectAll;
    memo1.CopyToClipboard;
    ClipBoard.AsText := Memo1.Text;
   end;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin

settings.WriteString('base','login', '');
settings.WriteString('base','password', '');
settings.UpdateFile;
memoTemp.Clear;
memoTemp.Lines.SaveToFile( dir + 'data.ini');

showmessage('dane logowania i katalogi usunięte, można można podać program dalej');

end;

procedure TForm1.ButtonAddNewFolderClick(Sender: TObject);
var
  tekst : string;
begin

if EditFolderNewName.text <> '' then
  begin

  memotemp.Clear;
  AUrl1 := 'https://rapidgator.net/api/v2/folder/create?token='+ tokennr +'&name='+ EditFolderNewName.text;
  AHTTPClient1 := TFPHTTPClient.Create(nil);
  try
    AHTTPClient1.AllowRedirect := True;
      APostValues1 := TStringList.Create;
       try
        AResult1 := AHTTPClient1.SimpleGet(AUrl1);
        memoTemp.Lines.AddStrings(AResult1);
        except
        on E: exception do ShowMessage(E.Message);
        end;
        finally
        APostValues1.Free;
        AHTTPClient1.Free;
        end;
     tekst := '';
     if admin = true then memoTemp.Lines.SaveToFile(dir + 'po utworzeniu katalogu - odpowiedz api.txt');
     for i:=0 to (memoTemp.Lines.Count-1) do tekst := tekst + memoTemp.Lines.Strings[i];

  ini.WriteString( katalog ( tekst ) , '0', EditFolderNewName.text  );
  ini.UpdateFile;
  ComboBoxFolder.Items.Add( EditFolderNewName.text + ' (' +katalog ( tekst ) +')' );
  ComboBoxFolderCopy.Items.Add( EditFolderNewName.text + ' (' +katalog ( tekst ) +')' );
  memoFolderZmiany.Lines.Insert( 0 , 'dodano katalog o nazwie: ' + EditFolderNewName.text + ', który otrzymał numer: ' + katalog ( tekst ) );
  EditFolderNewName.text := '';
  end;
end;

procedure TForm1.ButtonCopyFilesClick(Sender: TObject);
begin

if ComboBoxFolder.Text = '' then showmessage ('wybierz katalog bazowy, z którego będzie wykonana kopia') else
  if ComboBoxFolderCopy.Text = '' then showmessage ('wybierz katalog do którego będą kopiowane pliki') else
if listbox1.Items.count = 0 then showmessage ('brak plików na liście do skopiowania') else

     BEGIN
     memotemp.Clear;
     lb1.items.Insert( 0 , 'cała lista plików/plik jest kopiowana/y' );
     j :=0;
     progressbar1.Position := 0;
     progressbar1.Max      := listbox1.Items.Count;
     progressbar1.Visible  := true;
     timerCopy.Enabled := true;
     END;
end;

procedure TForm1.ButtonFolderDocelowyClick(Sender: TObject);
begin

if EditFolder.Text <> '' then

  begin
  ComboBoxFolderCopy.Text := EditFolder.Text ;
  memoFolderZmiany.Lines.Insert( 0 , 'ustawiono katalog do którego będą kopiowane pliki');
  pagecontrol1.ActivePage := tabsheet1 ;
  end;

end;

procedure TForm1.ButtonLoadFolderClick(Sender: TObject);
begin

ini.ReadSections( ListBoxFolder.Items );
for i := 0 to ( ListBoxFolder.Items.Count-1 ) do
     ListBoxFolder.Items.Strings[i] := ini.ReadString( ListBoxFolder.Items.Strings[i], '0', '')  + ' (' + ListBoxFolder.Items.Strings[i] + ')';

memoFolderZmiany.Lines.Insert( 0 , 'dodano listę katalogów z konta w ilości ' + intTostr(ListBoxFolder.Items.Count));

end;

procedure TForm1.ButtonTKNClick(Sender: TObject);
begin
tokennr := '';
memotemp.Clear;
AUrl1 := 'https://rapidgator.net/api/v2/user/login?login='+lg+'&password='+ps;
AHTTPClient1 := TFPHTTPClient.Create(nil);
try
    AHTTPClient1.AllowRedirect := True;
      APostValues1 := TStringList.Create;
       try
        AResult1 := AHTTPClient1.SimpleGet(AUrl1);
        memoTemp.Lines.AddStrings(AResult1);
        except
        on E: exception do ShowMessage(E.Message);
        end;
        finally
        APostValues1.Free;
        AHTTPClient1.Free;
        end;
if admin = true then memoTemp.Lines.SaveToFile( dir + 'user login odpowiedz na zapytanie api.txt');

if posEx( 'Please wait 10 minutes' , memoTemp.Lines.Strings[0]) > 0 then
  showmessage( 'serwer rg obciążony, proszę zaloguj się za 10 minut') else
if PosEx('Wrong e-mail or password', memoTemp.Lines.Strings[0]) > 0 then
   showmessage( 'Wrong e-mail or password') else
if posEx( 'Login or password is wrong', memoTemp.Lines.Strings[0] ) > 0 then
  showmessage( 'Login or password is wrong') else
if posEx( 'token', memoTemp.Lines.Strings[0] ) > 0 then

begin

    tokennr := token ( memoTemp.Lines.Strings[0] );
    if admin = true then lb1.Items.Insert( 0 , 'token: ' + tokennr);

      ButtonGetFolders.Click;
      lb1.Items.Insert( 0 , 'list of folders updated');
      ini.ReadSections( ComboBoxFolder.Items );
      for i := 0 to ( ComboBoxFolder.Items.Count-1 ) do
      ComboBoxFolder.Items.Strings[i] := ini.ReadString( ComboBoxFolder.Items.Strings[i], '0', '')  + ' (' + ComboBoxFolder.Items.Strings[i] + ')';
    ini.ReadSections( ComboBoxFolderCopy.Items );
    for i := 0 to ( ComboBoxFolderCopy.Items.Count-1 ) do
    ComboBoxFolderCopy.Items.Strings[i] := ini.ReadString( ComboBoxFolderCopy.Items.Strings[i], '0', '')  + ' (' + ComboBoxFolderCopy.Items.Strings[i] + ')';

    ini.ReadSections( ComboBoxDeleteFolder.Items );
    for i := 0 to ( ComboBoxDeleteFolder.Items.Count-1 ) do
    ComboBoxDeleteFolder.Items.Strings[i] := ini.ReadString( ComboBoxDeleteFolder.Items.Strings[i], '0', '')  + ' (' + ComboBoxDeleteFolder.Items.Strings[i] + ')';

    ini.ReadSections( ComboBoxChangeFolderName.Items );
    for i := 0 to ( ComboBoxChangeFolderName.Items.Count-1 ) do
    ComboBoxChangeFolderName.Items.Strings[i] := ini.ReadString( ComboBoxChangeFolderName.Items.Strings[i], '0', '')  + ' (' + ComboBoxChangeFolderName.Items.Strings[i] + ')';
    lb1.Items.Insert( 0 , 'list of folders loaded');

 END;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin


end;

procedure TForm1.ComboBoxFolderChange(Sender: TObject);
begin

if ComboBoxFolder.Text ='' then showmessage('wybierz katalog') else
  lb1.items.Insert( 0 , 'wybrano katalog z listy: ' + tylkonumerkatalogu ( ComboBoxFolder.Text ) );

if ComboBoxFolder.Text <> '' then
   begin
   memotemp.Clear;
   AUrl1 := 'https://rapidgator.net/api/v2/folder/info?token='+ tokennr +'&folder_id='+ tylkonumerkatalogu( ComboBoxFolder.Text ) ;
   AHTTPClient1 := TFPHTTPClient.Create(nil);
   try
      AHTTPClient1.AllowRedirect := True;
      APostValues1 := TStringList.Create;
      try
      AResult1 := AHTTPClient1.SimpleGet(AUrl1);
      memoTemp.Lines.AddStrings(AResult1);
      except
      on E: exception do ShowMessage(E.Message);
      end;
      finally
      APostValues1.Free;
      AHTTPClient1.Free;
      end;

      kataloginfo:='';
      for i:=0 to (memoTemp.Lines.Count-1) do kataloginfo:= kataloginfo + memoTemp.Lines.Strings[i];
  end;

settings.WriteString('base','mainfolder', ComboboxFolder.Text);
settings.UpdateFile;

if admin = true then memoTemp.Lines.SaveToFile( dir + '02 dane o katalogu z konta.txt' );
lb1.items.Insert( 0 , 'katalog o nazwie: '+ ini.ReadString( tylkonumerkatalogu ( ComboBoxFolder.Text ) , '0', '' )
                 + ' zawiera plików: ' + iloscplikow ( kataloginfo ) + ' rozmiar tych plików: ' + b2kb2mb2gb ( wielkoscplikow ( kataloginfo ), 2 ) );

end;

procedure TForm1.ComboBoxFolderCopyChange(Sender: TObject);
begin

if ComboBoxFolderCopy.Text ='' then showmessage('wybierz katalog') else
     lb1.items.Insert( 0 , 'wybrano katalog do kopiowania do niego ' + tylkonumerkatalogu ( ComboBoxFolder.Text ) );
settings.WriteString('base','copyfolder', ComboboxFolderCopy.Text);
settings.UpdateFile;

end;

procedure TForm1.ComboBoxFolderKeyPress(Sender: TObject; var Key: char);
begin

if key=#13 then memoFolderZmiany.Lines.Insert( 0 , 'wybrano katalog z listy: -' + tylkonumerkatalogu ( ComboBoxFolder.Text ) + '- ');


end;

procedure TForm1.EditSzukajKeyPress(Sender: TObject; var Key: char);
begin

if key=#13 then
   if Editszukaj.Text = '' then showmessage('puste pole, nie wpisano frazy do szukania') else
       ButtonSzukaj.click;
end;

end.

