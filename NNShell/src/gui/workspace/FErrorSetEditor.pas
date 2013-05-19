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
unit FErrorSetEditor;

interface

uses
  System.SysUtils, System.Classes,
  FEditor,
  Winapi.Windows,
  Vcl.Forms, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Controls, Vcl.StdCtrls;

type
  TfmErrorSetEditor = class(TfmEditor)
    meOut: TMemo;
    Panel1: TPanel;
    Label7: TLabel;
    iName: TEdit;
    btRename: TBitBtn;
    BitBtn1: TBitBtn;
    procedure iNameChange(Sender: TObject);
    procedure btRenameClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowEditor; override;
    procedure HideEditor; override;
  end;

implementation

{$R *.DFM}

uses
  FOutput, eLibCore, eLibMath, eLibStat;
  
procedure TfmErrorSetEditor.iNameChange(Sender: TObject);
begin
  inherited;
  btRename.Enabled:= WorkSpace.ValidRename(Obj, iName.Text);
end;

procedure TfmErrorSetEditor.btRenameClick(Sender: TObject);
begin
  inherited;
  WorkSpace.RenameObject(Obj, iName.Text);
end;

procedure TfmErrorSetEditor.ShowEditor;
begin
  inherited ;
  iName.Text:= Obj.Name;
  btRename.Enabled:= false;
  meOut.Clear;
  TErrorSet(Obj).Report(meOut.Lines);
end;

procedure TfmErrorSetEditor.HideEditor;
begin
  inherited;          
end;

procedure TfmErrorSetEditor.BitBtn1Click(Sender: TObject);
begin
  inherited;
  TErrorSet(Obj).Report(Output);
end;

initialization
  Editors.RegisterEditor(TErrorSet, TfmErrorSetEditor);
end.
