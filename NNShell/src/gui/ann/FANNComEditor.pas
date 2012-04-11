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
unit FANNComEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, JvSpin, ComCtrls, Mask,
  eANNCore, FEditor, FANNEditor, eANNCom, JvExMask, JvExStdCtrls, JvCheckBox, JvGroupBox;

type
  TfmANNComEditor = class(TfmANNEditor)
    Bevel8: TJvGroupBox;
    Label13: TLabel;
    Label22: TLabel;
    iNumNeu: TJvSpinEdit;
    iEta: TJvSpinEdit;
    procedure iEtaChange(Sender: TObject);
    procedure iNumNeuChange(Sender: TObject);
  protected
    { Private declarations }
    procedure UpdateParam; override;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TfmANNComEditor.UpdateParam;
begin
  inherited;
  with Obj as TCompetitiveNetwork do begin
    iEta.Value   := Parameters.Eta;
    iNumNeu.Value:= Parameters.NumNeu;
  end;
end;

procedure TfmANNComEditor.iEtaChange(Sender: TObject);
begin
  inherited;
  with TCompetitiveNetwork(Obj) do begin
    Parameters.Eta:= iEta.Value;
    iEta.Value:= Parameters.Eta;
  end;
end;

procedure TfmANNComEditor.iNumNeuChange(Sender: TObject);
begin
  inherited;
  with TCompetitiveNetwork(Obj) do begin
    Parameters.NumNeu:= trunc(iNumNeu.Value);
    iNumNeu.Value:= Parameters.NumNeu;
  end;
end;

initialization
  Editors.RegisterEditor(TCompetitiveNetwork, TfmANNComEditor);
end.

