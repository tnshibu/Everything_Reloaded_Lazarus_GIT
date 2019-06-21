unit FileUnit;

{$mode objfpc}{$H+}
interface
    uses Dialogs, Classes, FileUtil, SysUtils, strutils ;

    type
    FileData = record
       name: String;
       size: String;
       path: String;
    end;
    TStringarray = array of string;
    TFileDataArray = array of FileData;
    function ReadOneFileToDataArray(aFileName:String): TFileDataArray;
    function SplitString(Text: String): TStringArray;
    function ReadAllFilesToStringArray(aFolderName:String): TStringList;
    function ReadAllFilesToDataArray(aFolderName:String):TFileDataArray;


implementation

function ReadOneFileToStringArray(aFileName:String):TStringList;
var
  F     : Text;
  Line  : String;
  Result1 : TStringList;
  counter : integer;
begin
  AssignFile(F,aFileName);
  Reset(F);
  counter := 1;
  Result1:=TStringList.Create;
  while not eof(F) do
  begin
       ReadLn(F,Line);
       Result1.Add(line);
       //If counter>=450 Then
       //   Break;
  end;
  ReadOneFileToStringArray:=Result1;
end;

function ReadAllFilesToStringArray(aFolderName:String): TStringList;
var
  allFiles: TStringList;
  allResult : TStringList;
  oneResult : TStringList;
  i, j : integer;
begin
  allFiles := FindAllFiles(aFolderName, '*.*', true);
  allResult := TStringList.Create;
  for i:=0 to allFiles.Count-1 do
  begin
    oneResult := ReadOneFileToStringArray(allFiles[i]);
    for j:=0 to oneResult.Count-1 do
    begin
      allResult.add(oneResult[j]);
    end;
  end;

  ReadAllFilesToStringArray:=allResult;
end;

function ReadOneFileToDataArray(aFileName:String):TFileDataArray;
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
       //If counter>=450 Then
       //   Break;
  end;
  ReadOneFileToDataArray:=fileDataArray;
end;

function ReadAllFilesToDataArray(aFolderName:String):TFileDataArray;
var
  Result1 : TStringList;
  split : TStringArray;
  fileDataArray : TFileDataArray;
  i : integer;
begin
  Result1:=ReadAllFilesToStringArray(aFolderName);
  for i:=0 to Result1.Count-1 do
  begin
    if (AnsiContainsText(Result1[i], 'DRIVE_NAME=')) then
    begin
       continue;
    end;
    split := SplitString(Result1[i]);
    setlength(fileDataArray, i+1);
    fileDataArray[i].name:=split[0];
    fileDataArray[i].size:=split[1];
    fileDataArray[i].path:=split[0];
  end;
  ReadAllFilesToDataArray:=fileDataArray;
end;

function SplitString(Text: String): TStringArray;
begin
   SplitString := Text.split('|')
end;

end.

