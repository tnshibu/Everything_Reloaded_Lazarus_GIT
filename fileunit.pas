unit FileUnit;

{$mode objfpc}{$H+}
interface

    type
    FileData = record
       name: String;
       size: String;
       path: String;
    end;
//    TArrayStr = array [integer] of String;
    TStringarray = array of string;
    TFileDataArray = array[1..45000] of FileData;
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
  oneFileData : FileData;
  counter : integer;
begin
  AssignFile(F,aFileName);
  Reset(F);
  counter := 1;
  while not eof(F) do
  begin
       ReadLn(F,Line);
       Result1 := SplitString(line);
       //setlength(fileDataArray, counter);
       fileDataArray[counter].name:=Result1[0];
       fileDataArray[counter].size:=Result1[1];
       //fileDataArray[counter]=oneFileData;
       counter:=counter+1;
       If counter>=45000 Then
          Break;
  end;
  ReadFile:=fileDataArray;
end;
function SplitString(Text: String): TStringArray;
var
   Result1 : TStringArray;
   intIdx: Integer;
   intIdxOutput: Integer;
const
   Delimiter = '|';
begin
   intIdxOutput := 0;
   SetLength(Result1, 1);
   Result1[0] := '';
   SplitString := Text.split('|')
end;

end.

