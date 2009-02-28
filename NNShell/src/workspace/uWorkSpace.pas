(* GPL > 3.0
Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio

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
  eLibMath, eLibStat, eDataPick, SysUtils, Classes, Controls;

type

  TObjectClass = class of TComponent;
  TWorkSpace = class;

  TWorkSpace = class(TComponent)
    protected
     FChanged: boolean;
     FCreateListener: TListenerList;
     FFreeListener: TListenerList;
     FNameChangeListener: TListenerList;
    protected
     procedure   GetChildren(Proc: TGetChildProc; Root: TComponent); override;
     procedure   FreeAllObjects;
     procedure   Loaded; override;
    public
     constructor Create(AOwner: TComponent); override;
     function    CreateObject(Kind: TObjectClass; const aName: string): TComponent; virtual;
     procedure   FreeObject(Obj: TComponent); virtual;
     function    RenameObject(Obj: TComponent; const NewName: string): boolean;
     function    ValidRename(AComponent: TComponent; const OldName, NewName: string): boolean;
     function    GetUniqueName(aMask: string): string;
     function    GetDataPicker(aList: TStrings): string;
     function    MakeDataPicker(DPClass: TDataPickerClass): TComponent;
     function    MakeErrorSet: TErrorSet;
     procedure   Save(Path: string);
     procedure   Load(Path: string);
     destructor  Destroy; override;
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

procedure TWorkSpace.Loaded;
var
  i: integer;
begin
  for i:= 0 to ComponentCount-1 do begin
    CreateListener.Notify(Components[i]);
  end;
  FChanged:= false;
end;

procedure TWorkSpace.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: integer;
begin
  for i:= 0 to ComponentCount-1 do begin
    Proc(Components[i]);
  end;
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

function TWorkSpace.ValidRename(AComponent: TComponent; const OldName, NewName: string): boolean;
begin
  try
    ValidateRename(AComponent, OldName, NewName);
    Result:= true;
  except
    on EComponentError do Result:= false;
  end;
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
    ValidateRename(Obj, Obj.Name, NewName);
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

function TWorkSpace.MakeDataPicker(DPClass: TDataPickerClass): TComponent;
var
  Name: string;
begin
  Name:= GetUniqueName('DataSource%d');
  Result:= CreateObject(DPClass, Name);
end;

function TWorkSpace.MakeErrorSet: TErrorSet;
var
  Name: string;
begin
  Name:= GetUniqueName('ErrorSet%d');
  Result:= CreateObject(TErrorSet, Name) as TErrorSet;
end;

procedure TWorkSpace.Save(Path: string);
var
  s: TFileStream;
begin
  s:= TFileStream.Create(Path, fmCreate);
  S.WriteComponent(Self);
  S.Free;
  FChanged:= false;
end;

procedure TWorkSpace.Load(Path: string);
var
  s: TFileStream;
begin
  FreeAllObjects;
  s:= TFileStream.Create(Path, fmOpenRead);
  S.ReadComponent(Self);
  S.Free;
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

destructor  TWorkSpace.Destroy;
begin
  FreeAllObjects;
  FCreateListener.Free;
  FNameChangeListener.Free;
  FFreeListener.Free;
  inherited Destroy;
end;

end.

