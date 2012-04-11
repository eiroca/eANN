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
unit FANNPLNEditor;

interface

uses
  System.SysUtils, System.Classes,
  FEditor, FANNEditor, eANNCore, eANNPLN,
  JvExMask, JvSpin, JvExStdCtrls, JvCheckBox,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask, Vcl.Forms, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TfmANNPLNEditor = class(TfmANNEditor)
    Bevel9: TGroupBox;
    gTrnPrm: TGroupBox;
    Label26: TLabel;
    lbNumNeu1: TLabel;
    Bevel11: TGroupBox;
    Bevel1: TGroupBox;
    Label1: TLabel;
    Label6: TLabel;
    Label21: TLabel;
    iEps: TJvSpinEdit;
    Label22: TLabel;
    iEta: TJvSpinEdit;
    Label15: TLabel;
    iSpr: TJvSpinEdit;
    Label24: TLabel;
    iRoI: TJvSpinEdit;
    Label25: TLabel;
    iRoO: TJvSpinEdit;
    Label23: TLabel;
    iLmd: TJvSpinEdit;
    Bevel10: TGroupBox;
    Label14: TLabel;
    iWin: TJvSpinEdit;
    Label13: TLabel;
    JvSpinEdit1: TJvSpinEdit;
    Label19: TLabel;
    procedure iEpsChange(Sender: TObject);
    procedure iEtaChange(Sender: TObject);
    procedure iLmdChange(Sender: TObject);
    procedure iRoIChange(Sender: TObject);
    procedure iRoOChange(Sender: TObject);
    procedure iWinChange(Sender: TObject);
    procedure iSprChange(Sender: TObject);
  protected
    { Private declarations }
    procedure UpdateParam; override;
    procedure UpdateInfo; override;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TfmANNPLNEditor.UpdateParam;
begin
  with Obj as TPLNetwork do begin
    iEta.Value:= Parameters.Eta;
    iLmd.Value:= Parameters.Lmd;
    iEps.Value:= Parameters.Eps;
    iRoI.Value:= Parameters.RoI;
    iRoO.Value:= Parameters.RoO;
    iWin.Value:= Parameters.Win;
    iSpr.Value:= Parameters.Spr;
  end;
end;

procedure TfmANNPLNEditor.iEpsChange(Sender: TObject);
begin
  inherited;
  with TPLNetwork(Obj) do begin
    Parameters.Eps:= iEps.Value;
    iEps.Value:= Parameters.Eps;
  end;
end;

procedure TfmANNPLNEditor.iEtaChange(Sender: TObject);
begin
  inherited;
  with TPLNetwork(Obj) do begin
    Parameters.Eta:= iEta.Value;
    iEta.Value:= Parameters.Eta;
  end;
end;

procedure TfmANNPLNEditor.iLmdChange(Sender: TObject);
begin
  inherited;
  with TPLNetwork(Obj) do begin
    Parameters.Lmd:= iLmd.Value;
    iLmd.Value:= Parameters.Lmd;
  end;
end;

procedure TfmANNPLNEditor.iRoIChange(Sender: TObject);
begin
  inherited;
  with TPLNetwork(Obj) do begin
    Parameters.RoI:= iRoI.Value;
    iRoI.Value:= Parameters.RoI;
  end;
end;

procedure TfmANNPLNEditor.iRoOChange(Sender: TObject);
begin
  inherited;
  with TPLNetwork(Obj) do begin
    Parameters.RoO:= iRoO.Value;
    iRoO.Value:= Parameters.RoO;
  end;
end;

procedure TfmANNPLNEditor.iWinChange(Sender: TObject);
begin
  inherited;
  with TPLNetwork(Obj) do begin
    Parameters.Win:= trunc(iWin.Value);
    iWin.Value:= Parameters.Win;
  end;
end;

procedure TfmANNPLNEditor.iSprChange(Sender: TObject);
begin
  inherited;
  with TPLNetwork(Obj) do begin
    Parameters.Spr:= iSpr.Value;
    iSpr.Value:= Parameters.Spr;
  end;
end;

procedure TfmANNPLNEditor.UpdateInfo;
begin
  inherited;
  with TPLNetwork(Obj) do begin
    lbNumNeu1.Caption   := IntToStr(NumNeu);
  end;
end;

initialization
  Editors.RegisterEditor(TPLNetwork, TfmANNPLNEditor);
end.

