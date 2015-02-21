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
unit uWorkSpace;

interface

uses
  eLibCore, eLibMath, eLibStat, eDataPick,
  System.SysUtils, System.Classes,
  Vcl.Controls;

type

  TObjectClass = class of TComponent;
  TWorkSpace = class;

  TWorkSpace = class(TStorable)
    protected
     FChanged: boolean;
     FCreateListener: TListenerList;
     FFreeListener: TListenerList;
     FNameChangeListener: TListenerList;
    protected
     procedure   FreeAllObjects;
     procedure   Loaded; override;
     function    DecodeFormat(Path: string; defType: integer): integer;
     procedure   ExportAsDEF(Path: string);
     procedure   ImportAsDEF(Path: string);
     procedure   ExportAsNNW(Path: string);
     procedure   ImportAsNNW(Path: string);
    public
     constructor Create(AOwner: TComponent); override;
     destructor  Destroy; override;
    public
     procedure   Save(Path: string);
     procedure   Load(Path: string);
     function    CreateObject(Kind: TObjectClass; const aName: string): TComponent; virtual;
     procedure   FreeObject(Obj: TComponent); virtual;
     function    RenameObject(Obj: TComponent; const NewName: string): boolean;
     function    ValidRename(AComponent: TComponent; const NewName: string): boolean;
     function    GetUniqueName(aMask: string): string;
     function    GetDataPicker(aList: TStrings): string;
     function    MakeDataPicker(DPClass: TDataPickerClass): TDataPicker;
     function    MakeErrorSet: TErrorSet;
    public
     property Changed: boolean read FChanged;
     property CreateListener: TListenerList read FCreateListener;
     property FreeListener: TListenerList read FFreeListener;
     property NameChangeListener: TListenerList read FNameChangeListener;
  end;

implementation

constructor TWorkSpace.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCreateListener:= TListenerList.Create;
  FFreeListener:= TListenerList.Create;
  FNameChangeListener:= TListenerList.Create;
  FChanged:= false;
end;

destructor  TWorkSpace.Destroy;
begin
  FreeAllObjects;
  FCreateListener.Free;
  FNameChangeListener.Free;
  FFreeListener.Free;
  inherited Destroy;
end;

procedure TWorkSpace.Loaded;
var
  i: integer;
begin
  inherited;
  for i:= 0 to ComponentCount-1 do begin
    CreateListener.Notify(Components[i]);
  end;
  FChanged:= false;
end;

function TWorkSpace.CreateObject(Kind: TObjectClass; const aName: string): TComponent;
begin
  Result:= Kind.Create(Self);
  Result.Name:= aName;
  CreateListener.Notify(Result);
  FChanged:= true;
end;

procedure TWorkSpace.FreeObject(Obj: TComponent);
begin
  Obj:= FindComponent(Obj.Name);
  if Obj <> nil then begin
    FreeListener.Notify(Obj);
    Obj.Free;
  end;
  FChanged:= true;
end;

function TWorkSpace.ValidRename(AComponent: TComponent; const NewName: string): boolean;
var
  i: integer;
begin
  Result:= false;
  if (AComponent.Name = NewName) then exit;
  for i:= 1 to Length(NewName) do begin
    if not StrUtil.isLitteral(NewName[i]) then begin
      exit;
    end;
  end;
  if FindComponent(NewName) <> nil then exit;
  try
    ValidateRename(Self, AComponent.Name, NewName);
  except
    on EComponentError do exit;
  end;
  Result:= true;
end;

function TWorkSpace.GetUniqueName(aMask: string): string;
var
  i: integer;
begin
  i:= 1;
  repeat
    Result:= Format(aMask, [i]);
    if FindComponent(Result)=nil then break;
    inc(i);
  until false;
end;

function TWorkSpace.RenameObject(Obj: TComponent; const NewName: string): boolean;
begin
  try
    ValidateRename(Self, Obj.Name, NewName);
    Obj.Name:= NewName;
    Result:= true;
    NameChangeListener.Notify(Obj);
    FChanged:= true;
  except
    on EComponentError do Result:= false;
  end;
end;

function TWorkSpace.GetDataPicker(aList: TStrings): string;
var
  i: integer;
  Obj: TComponent;
begin
  aList.BeginUpdate;
  try
    aList.Clear;
    for i:= 0 to ComponentCount-1 do begin
      Obj:= Components[i];
      if Obj is TDataPicker then begin
        aList.AddObject(Obj.Name, Obj);
      end;
    end;
  finally
    aList.EndUpdate;
  end;
end;

function TWorkSpace.DecodeFormat(Path: string; defType: integer): integer;
var
  ext: string;
begin
  ext:= ExtractFileExt(Path);
  Result:= defType;
  if (ext='') then Result:= 0
  else if (ext='.nnw') then Result:= 0
  else if (ext='.def') then Result:= 1;
  if (Result < 0) then begin
    raise EInvalidOperation.Create('Invalid workspace format');
  end;
end;

procedure TWorkSpace.Save(Path: string);
begin
  case DecodeFormat(Path, -1) of
    0: ExportAsNNW(Path);
    1: ExportAsDEF(Path);
  end;
end;

procedure TWorkSpace.Load(Path: string);
begin
  case DecodeFormat(Path, -1) of
    0: ImportAsNNW(Path);
    1: ImportAsDEF(Path);
  end;
end;

procedure TWorkSpace.ExportAsNNW(Path: string);
var
  S: TFileStream;
begin
  S:= TFileStream.Create(Path, fmCreate);
  try
    S.WriteComponent(Self);
  finally
    S.Free;
  end;
  FChanged:= false;
end;

procedure TWorkSpace.ImportAsNNW(Path: string);
var
  S: TFileStream;
begin
  FreeAllObjects;
  S:= TFileStream.Create(Path, fmOpenRead);
  try
    S.ReadComponent(Self);
  finally
    S.Free;
  end;
  FChanged:= false;
end;

procedure TWorkSpace.ExportAsDEF(Path: string);
var
  S: TFileStream;
  M: TMemoryStream;
begin
  S:= TFileStream.Create(Path, fmCreate);
  try
    M:= TMemoryStream.Create;
    try
      M.WriteComponent(Self);
      M.Seek(0, soFromBeginning);
      ObjectBinaryToText(M, S);
    finally
      M.Free;
    end;
  finally
    S.Free;
  end;
  FChanged:= false;
end;

procedure TWorkSpace.ImportAsDEF(Path: string);
var
  S: TFileStream;
  M: TMemoryStream;
begin
  FreeAllObjects;
  S:= TFileStream.Create(Path, fmOpenRead);
  try
    M:= TMemoryStream.Create;
    try
      ObjectTextToBinary(S, M);
      M.Seek(0, soFromBeginning);
      M.ReadComponent(Self);
    finally
      M.Free;
    end;
  finally
    S.Free;
  end;
  FChanged:= false;
end;

procedure TWorkSpace.FreeAllObjects;
var
  i: integer;
begin
  for i:= ComponentCount-1 downto 0 do begin
    FreeListener.Notify(Components[i]);
    Components[i].Free;
  end;
end;

function TWorkSpace.MakeDataPicker(DPClass: TDataPickerClass): TDataPicker;
var
  Name: string;
begin
  Name:= GetUniqueName('DataSource%d');
  Result:= CreateObject(DPClass, Name) as TDataPicker;
end;

function TWorkSpace.MakeErrorSet: TErrorSet;
var
  Name: string;
begin
  Name:= GetUniqueName('ErrorSet%d');
  Result:= CreateObject(TErrorSet, Name) as TErrorSet;
end;

end.

