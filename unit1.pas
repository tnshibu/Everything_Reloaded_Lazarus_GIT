unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
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
begin
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  fileDataArray : TFileDataArray;
  i : integer;
  vNewItem: TListItem;

begin
     Caption:='Everything Reloaded';
     fileDataArray := FileUnit.ReadFile ('a.txt');

     ListView1.ViewStyle:=vsIcon;
     ListView1.ReadOnly:=True;
     ListView1.BeginUpdate;

     for i:=1 to 40000 do
     begin
       vNewItem := ListView1.Items.Add;
       vNewItem.Caption:=fileDataArray[i].name; //first column
       vNewItem.SubItems.Add(fileDataArray[i].size); //next column
     end;
     ListView1.EndUpdate;
     ListView1.ViewStyle:=vsReport;
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

