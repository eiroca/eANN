(* GPL > 3.0
Copyright (C) 1996-2014 eIrOcA Enrico Croce & Simona Burzio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
 @author(Enrico Croce)
*)
unit uOpzioni;

interface

uses
  INIFiles, Classes, SysUtils;

type
  TOpzioni = class
    private
      FProgPath: string;
      FINIPath: string;
    public
     constructor Create;
     function ReadString(const Section, Ident, Default: string): string;
     function ReadInteger(const Section, Ident: string; Default: integer): integer;
     procedure WriteString(const Section, Ident, Val: string);
     procedure WriteInteger(const Section, Ident: string; Val: integer);
     property ProgPath: string read FProgPath;
     property INIPath: string read FINIPath;
  end;

var
  Opzioni: TOpzioni;

implementation

constructor TOpzioni.Create;
var
  Path: string;
begin
  Path:= ParamStr(0);
  FProgPath:= ExtractFilePath(Path);
  FINIPath := ProgPath+'NNSHELL.INI';
end;

function TOpzioni.ReadString(const Section, Ident, Default: string): string;
var
  INI: TINIFile;
begin
  INI:= TINIFIle.Create(INIPath);
  try
    Result:= INI.ReadString(Section, Ident, Default);
  finally
    INI.Free;
  end;
end;

function TOpzioni.ReadInteger(const Section, Ident: string; Default: integer): integer;
var
  INI: TINIFile;
begin
  INI:= TINIFIle.Create(INIPath);
  try
    Result:= INI.ReadInteger(Section, Ident, Default);
  finally
    INI.Free;
  end;
end;

procedure TOpzioni.WriteString(const Section, Ident, Val: string);
var
  INI: TINIFile;
begin
  INI:= TINIFIle.Create(INIPath);
  try
    INI.WriteString(Section, Ident, Val);
  finally
    INI.Free;
  end;
end;

procedure TOpzioni.WriteInteger(const Section, Ident: string; Val: integer);
var
  INI: TINIFile;
begin
  INI:= TINIFIle.Create(INIPath);
  try
    INI.WriteInteger(Section, Ident, Val);
  finally
    INI.Free;
  end;
end;

initialization
  Opzioni:= TOpzioni.Create;
finalization
  Opzioni.Free;
end.
