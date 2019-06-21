unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  strutils,
  LCLType,
  RegExpr,
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
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.txt_SearchChange(Sender: TObject);
var
  fileDataArray : TFileDataArray;
  i : integer;
  vNewItem: TListItem;
  searchText : String;
  temp : String;
  nameOnly : String;
  position1 : integer;
  //regex: TRegExpr;
begin
     if(Length(txt_Search.Text) > 3) then
     begin
          searchText := uppercase(txt_Search.Text);
          fileDataArray := FileUnit.ReadFile ('a.txt');
          //regex := TRegExpr.Create('.*'+searchText +'.*');
          ListView1.BeginUpdate;
          ListView1.Clear;
          ListView1.ReadOnly:=True;
          for i:=0 to length(fileDataArray) do
          begin
            if( AnsiContainsText(fileDataArray[i].path, searchText)) then
            begin
                 temp := fileDataArray[i].path;
                 position1 := rpos('\',temp)+1;
                 nameOnly := ExtractSubstr(temp, position1,[' ']);
                 vNewItem := ListView1.Items.Add;
                 vNewItem.Caption:=nameOnly; //first column
                 vNewItem.SubItems.Add(fileDataArray[i].size); //second column
                 vNewItem.SubItems.Add(fileDataArray[i].path); //third column
            end;
          end;
          ListView1.EndUpdate;
     end
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     Caption:='Everything Reloaded';
     Application.Title:=Caption;
     Application.Icon:=Icon;

     TrayIcon1.PopUpMenu:=sysTray_Popup_Menu;
     TrayIcon1.Icon:=Icon;
     TrayIcon1.Show;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if Key =  VK_ESCAPE then
    begin
         Hide;
    end
    else if Key = VK_DOWN then
    begin
      //showmessage('down');
    end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
     txt_Search.Left:=5;
     txt_Search.Width:=Width - 10;
     listView1.Left:=5;
     listView1.Width:=Width - 10;
     listView1.Height:=Height - 85;

     listView1.Column[0].Width:=200;  //file name
     listView1.Column[1].Width:=50;   //file size
     listView1.Column[2].Width:=listView1.Width - listView1.Column[0].Width - listView1.Column[1].Width - 5;
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

