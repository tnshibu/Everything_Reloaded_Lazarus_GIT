unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  strutils,
  LCLType,
  RegExpr,
  fphttpclient,
  TypInfo, fpjson, jsonparser,
  ComCtrls, Menus, ExtCtrls, FileUnit;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    ListView1: TListView;
    menuBar: TMainMenu;
    sysTray_Show: TMenuItem;
    sysTray_Exit: TMenuItem;
    menu_Help: TMenuItem;
    menu_About: TMenuItem;
    menu_File: TMenuItem;
    menu_Options: TMenuItem;
    menu_Exit: TMenuItem;
    sysTray_Popup_Menu: TPopupMenu;
    StatusBar1: TStatusBar;
    TrayIcon1: TTrayIcon;
    txt_Search: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure menu_ExitClick(Sender: TObject);
    procedure sysTray_ExitClick(Sender: TObject);
    procedure sysTray_ShowClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure txt_SearchChange(Sender: TObject);
    procedure txt_SearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private

  public

  end;

var
  Form1: TForm1;
  fileDataArray : TFileDataArray;

implementation

{$R *.lfm}

{ TForm1 }

function multiCriteriaMatch(aFileName:String; searchCriteria:String):boolean;
var
  i     : Integer;
  split : TStringArray;
  matchesFound : boolean;
begin

  matchesFound:=False;
  split := searchCriteria.split(' ') ;
//  showmessage(IntToStr(length(split)));
  for i:=0 to length(split)-1 do
  begin
       if( AnsiContainsText(aFileName, split[i])) then
            matchesFound:=True
       else
       begin
            matchesFound:=False;
            break;
       end;
  end;
  multiCriteriaMatch:=matchesFound;
end;

procedure TForm1.txt_SearchChange(Sender: TObject);
var
  i : integer;
  vNewItem: TListItem;
  searchText : String;
  temp : String;
  nameOnly : String;
  url : String;
  htmlString : String;
  position1 : integer;
  //regex: TRegExpr;


  jData : TJSONData;
  jItem : TJSONData;
  j: Integer;
  object_name, field_name, field_value, object_type, object_items: String;
begin
     if(Length(txt_Search.Text) >= 3) then
     begin
          searchText := uppercase(txt_Search.Text);
          if fileDataArray = nil then
          begin
               fileDataArray := FileUnit.ReadAllFilesToDataArray ('input');
          end;


          //regex := TRegExpr.Create('.*'+searchText +'.*');
          ListView1.BeginUpdate;
          ListView1.Clear;
          ListView1.ReadOnly:=True;
          for i:=0 to length(fileDataArray)-1 do
          begin
            (*
            if( multiCriteriaMatch(fileDataArray[i].path,  searchText) = True) then
            begin
                 temp := fileDataArray[i].path;
                 position1 := rpos('\',temp)+1;
                 nameOnly := ExtractSubstr(temp, position1,['\']);
                 vNewItem := ListView1.Items.Add;
                 vNewItem.Caption:=nameOnly; //first column
                 vNewItem.SubItems.Add(fileDataArray[i].size); //second column
                 vNewItem.SubItems.Add(fileDataArray[i].path); //third column
            end;
            *)
          end;
          ListView1.EndUpdate;

          With TFPHttpClient.Create(Nil) do
            try
              searchText := StringReplace(searchText, ' ', '%20', [rfReplaceAll, rfIgnoreCase]);
              url := 'http://127.0.0.1:8010/?search='+searchText+'&j=1';
              htmlString := Get(url);
              jData := GetJSON(htmlString);
              for i := 0 to jData.Count - 1 do
              begin
                   jItem := jData.Items[i];

                   object_type := GetEnumName(TypeInfo(TJSONtype), Ord(jItem.JSONType));
                   object_name := TJSONObject(jData).Names[i];
                   WriteStr(object_items, jItem.Count);

                   ShowMessage('object type: ' + object_type + '|object name: ' + object_name + '|number of fields: ' + object_items);

                   for j := 0 to jItem.Count - 1 do
                   begin
                     field_name := TJSONObject(jItem).Names[j];
                     if(field_name = 'type') then
                     begin
                         ShowMessage(field_name);
                         field_value := jItem.FindPath(TJSONObject(jItem).Names[j]).AsString;
                         ShowMessage(field_name + '|' + field_value);
                     end;
                   end;
              end;
            finally
              Free;
            end;
     end
end;

procedure TForm1.txt_SearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DOWN then
  begin
    ListView1.SetFocus;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     Caption:='Everything Reloaded';
     Application.Title:=Caption;
     Application.Icon:=Icon;

     TrayIcon1.PopUpMenu:=sysTray_Popup_Menu;
     TrayIcon1.Icon:=Icon;
     TrayIcon1.Show;

     //FileUnit.ReadAllFilesToDataArray ('input');
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if Key =  VK_ESCAPE then
    begin
         Hide;
    end
end;

procedure TForm1.FormResize(Sender: TObject);
begin
     txt_Search.Left:=5;
     txt_Search.Width:=Width - 10;
     listView1.Left:=5;
     listView1.Width:=Width - 10;
     listView1.Height:=Height - 85;

     listView1.Column[0].Width:=200;  //file name
     listView1.Column[1].Width:=40;   //file size
     listView1.column[1].Alignment:=TAlignment.TARightJustify;  //file size is right aligned
     listView1.Column[2].Width:=listView1.Width - listView1.Column[0].Width - listView1.Column[1].Width - 10;
end;

procedure TForm1.menu_ExitClick(Sender: TObject);
begin
  Destroy;
end;

procedure TForm1.sysTray_ExitClick(Sender: TObject);
begin
  Destroy;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  Show;
end;

procedure TForm1.sysTray_ShowClick(Sender: TObject);
begin
  Show;
end;

end.

