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
unit FANNRBEditor;

interface

uses
  System.SysUtils, System.Classes,
  FEditor, FANNEditor,
  JvExMask, JvSpin, JvExStdCtrls, JvCheckBox,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.ComCtrls, Vcl.Controls, Vcl.Forms;

type
  TfmANNRBEditor = class(TfmANNEditor)
    Bevel8: TGroupBox;
    Label23: TLabel;
    Label21: TLabel;
    iMaxErr: TJvSpinEdit;
    cbMaxNeu: TCheckBox;
    iMaxNeu: TJvSpinEdit;
    Bevel9: TGroupBox;
    Label24: TLabel;
    iRo: TJvSpinEdit;
    btRecalcAtt: TBitBtn;
    Bevel11: TGroupBox;
    Label26: TLabel;
    lbNumNeu: TLabel;
    Bevel13: TGroupBox;
    Label37: TLabel;
    lbAttMin: TLabel;
    Label40: TLabel;
    lbAttAve: TLabel;
    Label41: TLabel;
    lbAttLst: TLabel;
    lbAttVar: TLabel;
    Label39: TLabel;
    lbAttMax: TLabel;
    Label38: TLabel;
    Label42: TLabel;
    lbAttNum: TLabel;
    procedure cbMaxNeuClick(Sender: TObject);
    procedure iRoChange(Sender: TObject);
    procedure iMaxErrChange(Sender: TObject);
    procedure iMaxNeuChange(Sender: TObject);
    procedure btRecalcAttClick(Sender: TObject);
  protected
    { Private declarations }
    procedure UpdateParam; override;
    procedure UpdateMaxNeu;
    procedure UpdateInfo; override;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses
  Math, eANNRB;

procedure TfmANNRBEditor.UpdateMaxNeu;
begin
  iMaxNeu.Enabled:= cbMaxNeu.Checked;
  if cbMaxNeu.Checked then begin
    TRBNetwork(Obj).Parameters.MaxNeu:= trunc(iMaxNeu.Value);
    iMaxNeu.Value:= TRBNetwork(Obj).Parameters.MaxNeu;
  end;
end;

procedure TfmANNRBEditor.UpdateParam;
begin
  inherited;
  with Obj as TRBNetwork do begin
    iMaxErr.Value   := Parameters.MaxErr;
    iRo.Value       := Parameters.Ro;
    iMaxNeu.Value   := Parameters.MaxNeu;
    cbMaxNeu.Checked:= Parameters.MaxNeu>0;
    UpdateMaxNeu;
  end;
end;

procedure TfmANNRBEditor.cbMaxNeuClick(Sender: TObject);
begin
  inherited;
  UpdateMaxNeu;
end;

procedure TfmANNRBEditor.iRoChange(Sender: TObject);
begin
  inherited;
  with TRBNetwork(Obj) do begin
    Parameters.Ro:= iRo.Value;
    iRo.Value:= Parameters.Ro;
  end;
end;

procedure TfmANNRBEditor.iMaxErrChange(Sender: TObject);
begin
  inherited;
  with TRBNetwork(Obj) do begin
    Parameters.MaxErr:= iMaxErr.Value;
    iMaxErr.Value:= Parameters.MaxErr;
  end;
end;

procedure TfmANNRBEditor.iMaxNeuChange(Sender: TObject);
begin
  inherited;
  with TRBNetwork(Obj) do begin
    Parameters.MaxNeu:= trunc(iMaxNeu.Value);
    iMaxNeu.Value:= Parameters.MaxNeu;
    UpdateMaxNeu;
  end;
end;

resourcestring
  strNONE = '<none>';

procedure TfmANNRBEditor.UpdateInfo;
begin
  with TRBNetwork(Obj) do begin
    lbNumNeu.Caption   := IntToStr(NumNeu);
    if (Activity.Count>0) then begin
      lbAttMin.Caption:= Trim(Format('%11.5f',[Activity.Minimum]));
      lbAttMax.Caption:= Trim(Format('%11.5f',[Activity.Maximum]));
      lbAttAve.Caption:= Trim(Format('%11.5f', [Activity.Average]));
      lbAttVar.Caption:= Trim(Format('%11.5f', [Activity.Variance]));
      lbAttNum.Caption:= Trim(Format('%5d', [Activity.Count]));
      lbAttLst.Caption:= Trim(Format('%11.5f', [Activity.Current]));
    end
    else begin
      lbAttMin.Caption:= strNONE;
      lbAttMax.Caption:= strNONE;
      lbAttAve.Caption:= strNONE;
      lbAttVar.Caption:= strNONE;
      lbAttNum.Caption:= strNONE;
      lbAttLst.Caption:= strNONE;
    end;
  end;
end;

procedure TfmANNRBEditor.btRecalcAttClick(Sender: TObject);
begin
  inherited;
  TRBNetwork(Obj).RecalcActivation;
  UpdateInfo;
end;

initialization
  Editors.RegisterEditor(TRBNetwork, TfmANNRBEditor);
end.

