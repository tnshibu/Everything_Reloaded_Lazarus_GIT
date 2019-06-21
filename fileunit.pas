unit FileUnit;

{$mode objfpc}{$H+}
interface

    type
    FileData = record
       name: String;
       size: String;
       path: String;
    end;
    TStringarray = array of string;
    TFileDataArray = array of FileData;
    function ReadFile(aFileName:String): TFileDataArray;
    function SplitString(Text: String): TStringArray;

implementation

uses Dialogs, Classes, SysUtils ;

function ReadFile(aFileName:String):TFileDataArray;
var
  F     : Text;
  Line  : String;
  Result1 : TStringArray;
  fileDataArray : TFileDataArray;
  counter : integer;
begin
  AssignFile(F,aFileName);
  Reset(F);
  counter := 1;
  while not eof(F) do
  begin
       ReadLn(F,Line);
       Result1 := SplitString(line);
       setlength(fileDataArray, counter);
       fileDataArray[counter-1].name:=Result1[0];
       fileDataArray[counter-1].size:=Result1[1];
       fileDataArray[counter-1].path:=Result1[0];
       counter:=counter+1;
       If counter>=4500 Then
          Break;
  end;
  ReadFile:=fileDataArray;
end;
function SplitString(Text: String): TStringArray;
begin
   SplitString := Text.split('|')
end;

end.

