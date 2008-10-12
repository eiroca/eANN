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
unit FEditor;

interface

uses
  eDataPick, uWorkSpace, Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TfmEditorClass = class of TfmEditor;

  TfmEditor = class(TForm)
    pnMain: TPanel;
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    WorkSpace: TWorkSpace;
    Obj: TComponent;
    procedure ShowEditor; virtual;
    procedure HideEditor; virtual;
  public
    { Public declarations }
  end;

type
  (* Realizzano conversione Obj -> EditorClass *)
  TEditorClassItem = class
    public
     ObjClass: TComponentClass;
     fmEditorClass: TfmEditorClass;
    public
     constructor Create(AObjClass: TComponentClass; AfmEditorClass: TfmEditorClass);
  end;

  TEditorClassList = class
    private
     FEditorClasses: TList;
    public
     constructor Create;
     procedure   RegisterEditor(AObjClass: TComponentClass; AfmEditor: TfmEditorClass);
     function    GetEditorClass(Obj: TComponentClass): TfmEditorClass;
     destructor  Destroy; override;
  end;

  (* Realizzano conversione (WS,Obj) -> IstanzaEditor *)
  TWSEditorItem = class;

  TEditor = class
    public
     Owner: TWSEditorItem;
     ObjClass: TComponentClass;
     Form: TfmEditor;
    public
     constructor Create(AOwner: TWSEditorItem; AObjClass: TComponentClass);
     procedure Show(Obj: TComponent);
     procedure Hide;
     destructor Destroy; override;
  end;

  TWSEditorItem = class
    public
     FEditors: TList;
     WorkSpace: TWorkSpace;
     Parent: TWinControl;
     CurEditor: TEditor;
    protected
     procedure OnFreeObject(Sender: TObject);
     function  MakeEditor(Obj: TComponent): TEditor;
     function  FindEditor(Obj: TComponent): TEditor;
    public
     constructor Create(AWorkSpace: TWorkSpace; AParent: TWinControl);
     procedure   Edit(Obj: TComponent);
     destructor  Destroy; override;
  end;

  TWSEditorList = class
    private
     FWSes: TList;
     function    FindWorkSpace(AWS: TWorkSpace): TWSEditorItem;
    public
     constructor Create;
     procedure   AddWorkSpace(AWS: TWorkSpace; AParent: TWinControl);
     procedure   DelWorkSpace(AWS: TWorkSpace);
     procedure   Edit(AWS: TWorkSpace; AObj: TComponent);
     destructor  Destroy; override;
  end;

  TEditors = class
    private
     FWorkSpace: TWSEditorList;
     FEditorClassList: TEditorClassList;
    public
     constructor Create;
     procedure   RegisterEditor(AObjClass: TComponentClass; AfmEditor: TfmEditorClass);
     procedure   AddWorkSpace(AWS: TWorkSpace; AParent: TWinControl);
     procedure   DelWorkSpace(AWS: TWorkSpace);
     function    GetEditorClass(Obj: TComponentClass): TfmEditorClass;
     procedure   Edit(WS: TWorkSpace; Obj: TComponent);
     destructor  Destroy; override;
  end;

var
  Editors: TEditors = nil;

implementation

{$R *.DFM}

constructor TEditorClassItem.Create(AObjClass: TComponentClass; AfmEditorClass: TfmEditorClass);
begin
  ObjClass:= AObjClass;
  fmEditorClass:= AfmEditorClass;
end;

constructor TEditorClassList.Create;
begin
  FEditorClasses:= TList.Create;
end;

procedure TEditorClassList.RegisterEditor(AObjClass: TComponentClass; AfmEditor: TfmEditorClass);
begin
  FEditorClasses.Add(TEditorClassItem.Create(AObjClass, AfmEditor));
end;

function TEditorClassList.GetEditorClass(Obj: TComponentClass): TfmEditorClass;
var
  i: integer;
  EI: TEditorClassItem;
begin
  Result:= nil;
  if Obj <> nil then begin
    (* Prova quello specifico *)
    for i:= 0 to FEditorClasses.Count-1 do begin
      EI:= TEditorClassItem(FEditorClasses.Items[i]);
      if Obj = EI.ObjClass then begin
        Result:= EI.fmEditorClass;
        exit;
      end;
    end;
    (* Prova quelli inherited *)
    for i:= 0 to FEditorClasses.Count-1 do begin
      EI:= TEditorClassItem(FEditorClasses.Items[i]);
      if Obj.InheritsFrom(EI.ObjClass) then begin
        Result:= EI.fmEditorClass;
        exit;
      end;
    end;
  end;
end;

destructor  TEditorClassList.Destroy;
var
  i: integer;
begin
  for i:= FEditorClasses.Count-1 downto 0 do begin
    TEditorClassItem(FEditorClasses.Items[i]).Free;
  end;
  FEditorClasses.Free;
  inherited Destroy;
end;

constructor TEditor.Create(AOwner: TWSEditorItem; AObjClass: TComponentClass);
var
  EditorClass: TfmEditorClass;
begin
  inherited Create;
  ObjClass:= AObjClass;
  Owner:= AOwner;
  EditorClass:= Editors.GetEditorClass(AObjClass);
  if EditorClass <> nil then begin
    Form:= EditorClass.Create(nil);
    Form.WorkSpace:= Owner.WorkSpace;
  end
  else begin
    Form:= nil;
  end;
end;

procedure TEditor.Show(Obj: TComponent);
begin
  if Form<>nil then begin
    Form.pnMain.Parent:= Owner.Parent;
    Form.Obj:= Obj;
    Form.ShowEditor;
  end;
end;

procedure TEditor.Hide;
begin
  if Form<>nil then begin
    Form.HideEditor;
    Form.pnMain.Parent:= Form;
    Form.Obj:= nil;
  end;
end;

destructor TEditor.Destroy;
begin
  if Form <> nil then Form.Free;
  inherited Destroy;
end;

constructor TWSEditorItem.Create(AWorkSpace: TWorkSpace; AParent: TWinControl);
begin
  FEditors:= TList.Create;
  WorkSpace:= AWorkSpace;
  Parent:= AParent;
  CurEditor:= nil;
  WorkSpace.FreeListener.Add(OnFreeObject);
end;

procedure TWSEditorItem.OnFreeObject(Sender: TObject);
begin
  if CurEditor <> nil then begin
    if CurEditor.Form.Obj = Sender then begin // chiude editor
      Editors.Edit(WorkSpace, nil);
    end;
  end;
end;

function TWSEditorItem.MakeEditor(Obj: TComponent): TEditor;
begin
  Result:= TEditor.Create(Self, TComponentClass(Obj.ClassType));
  FEditors.Add(Result);
end;

function TWSEditorItem.FindEditor(Obj: TComponent): TEditor;
var
  i: integer;
begin
  Result:= nil;
  for i:= 0 to FEditors.Count-1 do begin
    if TEditor(FEditors[i]).ObjClass = Obj.ClassType then begin
      Result:= TEditor(FEditors[i]);
      break;
    end;
  end;
end;

procedure TWSEditorItem.Edit(Obj: TComponent);
var
  E: TEditor;
begin
  if CurEditor <> nil then CurEditor.Hide;
  if Obj <> nil then begin
    E:= FindEditor(Obj);
    if E = nil then E:= MakeEditor(Obj);
    CurEditor:= E;
    E.Show(Obj);
  end;
end;

destructor TWSEditorItem.Destroy;
var
  i: integer;
begin
  WorkSpace.FreeListener.Del(OnFreeObject);
  for i:= FEditors.Count-1 downto 0 do begin
    TEditor(FEditors[i]).Free;
  end;
  FEditors.Free;
  inherited Destroy;
end;

constructor TWSEditorList.Create;
begin
  inherited Create;
  FWSes:= TList.Create;
end;

function TWSEditorList.FindWorkSpace(AWS: TWorkSpace): TWSEditorItem;
var
  i: integer;
begin
  Result:= nil;
  for i:= 0 to FWSes.Count-1 do begin
    if TWSEditorItem(FWSes[i]).WorkSpace = AWS then begin
      Result:= TWSEditorItem(FWSes[i]);
      break;
    end;
  end;
end;

procedure   TWSEditorList.AddWorkSpace(AWS: TWorkSpace; AParent: TWinControl);
begin
  FWSes.Add(TWSEditorItem.Create(AWS, AParent));
end;

procedure   TWSEditorList.DelWorkSpace(AWS: TWorkSpace);
var
  i: integer;
begin
  for i:= 0 to FWSes.Count-1 do begin
    if TWSEditorItem(FWSes[i]).WorkSpace = AWS then begin
      TWSEditorItem(FWSes.Items[i]).Free;
      FWSes.Delete(i);
      FWSes.Pack;
      break;
    end;
  end;
end;

procedure   TWSEditorList.Edit(AWS: TWorkSpace; AObj: TComponent);
begin
  FindWorkSpace(AWS).Edit(AObj);
end;

destructor  TWSEditorList.Destroy;
var
  i: integer;
begin
  for i:= FWSes.Count-1 downto 0 do begin
    TWSEditorItem(FWSes.Items[i]).Free;
  end;
  FWSes.Free;
  inherited Destroy;
end;

constructor TEditors.Create;
begin
  FWorkSpace:= TWSEditorList.Create;
  FEditorClassList:= TEditorClassList.Create;
end;

procedure TEditors.RegisterEditor(AObjClass: TComponentClass; AfmEditor: TfmEditorClass);
begin
  FEditorClassList.RegisterEditor(AObjClass, AfmEditor);
end;

procedure TEditors.AddWorkSpace(AWS: TWorkSpace; AParent: TWinControl);
begin
  FWorkSpace.AddWorkSpace(AWS, AParent);
end;

procedure TEditors.DelWorkSpace(AWS: TWorkSpace);
begin
  FWorkSpace.DelWorkSpace(AWS);
end;

function TEditors.GetEditorClass(Obj: TComponentClass): TfmEditorClass;
begin
  Result:= FEditorClassList.GetEditorClass(Obj);
end;

procedure   TEditors.Edit(WS: TWorkSpace; Obj: TComponent);
begin
  FWorkSpace.Edit(WS, Obj);
end;

destructor  TEditors.Destroy;
begin
  FWorkSpace.Free;
  FEditorClassList.Free;
  inherited Destroy;
end;

procedure TfmEditor.FormDestroy(Sender: TObject);
begin
  pnMain.Parent:= Self;
end;

procedure TfmEditor.ShowEditor;
begin
end;

procedure TfmEditor.HideEditor;
begin
end;

initialization
  Editors:= TEditors.Create;
finalization
  Editors.Free;
end.

