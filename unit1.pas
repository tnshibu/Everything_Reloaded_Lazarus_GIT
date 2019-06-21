unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  strutils,
  ComCtrls, FileUnit;

type

  { TForm1 }

  TForm1 = class(TForm)
    ListView1: TListView;
    txt_Search: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
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
begin
     searchText := uppercase(txt_Search.Text);
     if(Length(txt_Search.Text) > 3) then
     begin
          fileDataArray := FileUnit.ReadFile ('a.txt');
          ListView1.BeginUpdate;
          ListView1.Clear;
          ListView1.ReadOnly:=True;
          for i:=1 to 400 do
          begin
            if( AnsiContainsText(fileDataArray[i].name, searchText)) then
            begin
                 temp := fileDataArray[i].name;
                 position1 := rpos('\',temp)+1;
                 nameOnly := ExtractSubstr(temp, position1,[' ']);
                 vNewItem := ListView1.Items.Add;
                 vNewItem.Caption:=nameOnly; //first column
                 vNewItem.SubItems.Add(fileDataArray[i].size); //second column
                 vNewItem.SubItems.Add(fileDataArray[i].name); //third column
            end;
          end;
          ListView1.EndUpdate;
     end
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : integer;
begin
     Caption:='Everything Reloaded';
end;

procedure TForm1.FormResize(Sender: TObject);
begin
     txt_Search.Left:=5;
     txt_Search.Width:=Width - 10;
     listView1.Left:=5;
     listView1.Width:=Width - 10;
     listView1.Height:=Height - 45;

     listView1.Column[0].Width:=200;
     listView1.Column[1].Width:=200;
     listView1.Column[2].Width:=listView1.Width - listView1.Column[0].Width - listView1.Column[1].Width - 5;
end;
end.

