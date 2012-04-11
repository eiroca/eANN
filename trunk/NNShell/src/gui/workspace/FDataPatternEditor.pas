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
unit FDataPatternEditor;

interface

uses
  System.SysUtils, System.Classes,
  FEditor, FDataListEditor,
  JvExGrids, JvExMask, JvToolEdit, JvGrids, JvSpin,
  Vcl.StdCtrls, Vcl.Grids, Vcl.Mask, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TfmDataPatternEditor = class(TfmDataListEditor)
    Label3: TLabel;
    cbKind: TComboBox;
    cbAutoLoad: TCheckBox;
    iFileName: TJvFilenameEdit;
    Label2: TLabel;
    btLoadPattern: TBitBtn;
    lbDim: TLabel;
    procedure iFileNameChange(Sender: TObject);
    procedure cbKindChange(Sender: TObject);
    procedure cbAutoLoadClick(Sender: TObject);
    procedure btLoadPatternClick(Sender: TObject);
  private
    { Private declarations }
    procedure OnLoadEvent(Sender: TObject);
  public
    { Public declarations }
    procedure ShowEditor; override;
    procedure HideEditor; override;
  end;

var
  fmDataPatternEditor: TfmDataPatternEditor;

implementation

{$R *.DFM}

uses
  eDataPick;

procedure TfmDataPatternEditor.ShowEditor;
begin
  inherited;
  iFileName.Text:= TDataPattern(Obj).FileName;
  if TDataPattern(Obj).PAtternKind = pkInput then cbKind.ItemIndex:= 0
  else cbKind.ItemIndex:= 1;
  cbAutoLoad.Checked:= TDataPattern(Obj).AutoLoad;
  OnLoadEvent(nil);
  TDataPattern(Obj).LoadListener.Add(OnLoadEvent);
end;

procedure TfmDataPatternEditor.HideEditor;
begin
  if Obj <> nil then begin
    TDataPattern(Obj).LoadListener.Del(OnLoadEvent);
  end;
  inherited;
end;

procedure TfmDataPatternEditor.iFileNameChange(Sender: TObject);
begin
  inherited;
  TDataPattern(Obj).FileName:= iFileName.Text;
end;

procedure TfmDataPatternEditor.cbKindChange(Sender: TObject);
begin
  inherited;
  if cbKind.ItemIndex = 0 then TDataPattern(Obj).PatternKind:= pkInput
  else TDataPattern(Obj).PatternKind:= pkOutput;
end;

procedure TfmDataPatternEditor.cbAutoLoadClick(Sender: TObject);
begin
  inherited;
  TDataPattern(Obj).AutoLoad:= cbAutoLoad.Checked;
end;

procedure TfmDataPatternEditor.btLoadPatternClick(Sender: TObject);
begin
  inherited;
  TDataPattern(Obj).Load;
end;
procedure TfmDataPatternEditor.OnLoadEvent(Sender: TObject);
begin
  lbDim.Caption:= Format('%d vectors of %d element(s).',[TDataPattern(Obj).Count, TDataPattern(Obj).Dim]);
  UpdateParam;
end;

initialization
  Editors.RegisterEditor(TDataPattern, TfmDataPatternEditor);
end.

