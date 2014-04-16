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
unit FANNPRBEditor;

interface

uses
  System.SysUtils, System.Classes,
  FEditor, FANNEditor, eANNCore, eANNRB,
  JvSpin, JvExMask, JvExStdCtrls, JvCheckBox,
  Vcl.Mask, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Controls, Vcl.Forms;
  
type                 
  TfmANNPRBEditor = class(TfmANNEditor)
    gLrnPrm: TGroupBox;
    Label21: TLabel;
    Label23: TLabel;
    iTotErr: TJvSpinEdit;
    iMaxErr: TJvSpinEdit;
    gNeuPrm: TGroupBox;
    Label24: TLabel;
    Label13: TLabel;
    Label25: TLabel;
    Label14: TLabel;
    iRo: TJvSpinEdit;
    iDelta: TJvSpinEdit;
    gDynamic: TGroupBox;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    iDeadAge: TJvSpinEdit;
    iSpread: TJvSpinEdit;
    iDecay: TJvSpinEdit;
    btRecalcAtt: TBitBtn;
    Bevel11: TGroupBox;
    Label33: TLabel;
    Label26: TLabel;
    lbNumNeu: TLabel;
    lbNumAux: TLabel;
    Bevel13: TGroupBox;
    Label37: TLabel;
    lbAttMin: TLabel;
    Label40: TLabel;
    lbAttAve: TLabel;
    lbAttVar: TLabel;
    lbAttNum: TLabel;
    Label42: TLabel;
    Label39: TLabel;
    lbAttMax: TLabel;
    Label38: TLabel;
    Label41: TLabel;
    lbAttLst: TLabel;
    Bevel12: TGroupBox;
    Label34: TLabel;
    lbKilled: TLabel;
    Label35: TLabel;
    lbPeak: TLabel;
    Label36: TLabel;
    lbReduction: TLabel;
    cbAged: TCheckBox;
    procedure iTotErrChange(Sender: TObject);
    procedure iMaxErrChange(Sender: TObject);
    procedure cbAgedClick(Sender: TObject);
    procedure iDeadAgeChange(Sender: TObject);
    procedure iSpreadChange(Sender: TObject);
    procedure iDecayChange(Sender: TObject);
    procedure iRoChange(Sender: TObject);
    procedure iDeltaChange(Sender: TObject);
    procedure btRecalcAttClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure UpdateParam; override;
    procedure UpdateAged;
    procedure UpdateInfo; override;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses
  Math;

procedure TfmANNPRBEditor.UpdateAged;
var
  flg: boolean;
begin
  flg:= cbAged.Checked;
  iDeadAge.Enabled:= flg;
  iSpread.Enabled:= flg;
  iDecay.Enabled:= flg;
end;

procedure TfmANNPRBEditor.UpdateParam;
begin
  inherited;
  with Obj as TPRBNetwork do begin
    iMaxErr.Value  := Parameters.MaxErr;
    iTotErr.Value  := Parameters.TotErr;
    iRo.Value      := Parameters.Ro;
    iDelta.Value   := Parameters.Delta;
    iDeadAge.Value := Parameters.DeadAge;
    iDecay.Value   := Parameters.Decay;
    iSpread.Value  := Parameters.Spread;
    cbAged.Checked := Parameters.Aged;
    UpdateAged;
  end;
end;

procedure TfmANNPRBEditor.iTotErrChange(Sender: TObject);
begin
  inherited;
  with TPRBNetwork(Obj) do begin
    Parameters.TotErr:= iTotErr.Value;
    iTotErr.Value:= Parameters.TotErr;
  end;
end;

procedure TfmANNPRBEditor.iMaxErrChange(Sender: TObject);
begin
  inherited;
  with TPRBNetwork(Obj) do begin
    Parameters.MaxErr:= iMaxErr.Value;
    iMaxErr.Value:= Parameters.MaxErr;
  end;
end;

procedure TfmANNPRBEditor.cbAgedClick(Sender: TObject);
begin
  inherited;
  with TPRBNetwork(Obj) do begin
    Parameters.Aged:= cbAged.Checked;
    cbAged.Checked:= Parameters.Aged;
  end;
  UpdateAged;
end;

procedure TfmANNPRBEditor.iDeadAgeChange(Sender: TObject);
begin
  inherited;
  with TPRBNetwork(Obj) do begin
    Parameters.DeadAge:= iDeadAge.Value;
    iDeadAge.Value:= Parameters.DeadAge;
  end;
end;

procedure TfmANNPRBEditor.iSpreadChange(Sender: TObject);
begin
  inherited;
  with TPRBNetwork(Obj) do begin
    Parameters.Spread:= iSpread.Value;
    iSpread.Value:= Parameters.Spread;
  end;
end;

procedure TfmANNPRBEditor.iDecayChange(Sender: TObject);
begin
  inherited;
  with TPRBNetwork(Obj) do begin
    Parameters.Decay:= iDecay.Value;
    iDecay.Value:= Parameters.Decay;
  end;
end;

procedure TfmANNPRBEditor.iRoChange(Sender: TObject);
begin
  inherited;
  with TPRBNetwork(Obj) do begin
    Parameters.Ro:= iRo.Value;
    iRo.Value:= Parameters.Ro;
  end;
end;

procedure TfmANNPRBEditor.iDeltaChange(Sender: TObject);
begin
  inherited;
  with TPRBNetwork(Obj) do begin
    Parameters.Delta:= iDelta.Value;
    iDelta.Value:= Parameters.Delta;
  end;
end;

resourcestring
  strNONE = '<none>';

procedure TfmANNPRBEditor.UpdateInfo;
begin
  inherited;
  with TPRBNetwork(Obj) do begin
    lbNumNeu.Caption   := IntToStr(NumNeu);
    lbNumAux.Caption   := IntToStr(NumAux);
    lbKilled.Caption   := IntToStr(Killed);
    lbPeak.Caption     := IntToStr(Peak);
    lbReduction.Caption:= IntToStr(Reduction);
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

procedure TfmANNPRBEditor.btRecalcAttClick(Sender: TObject);
begin
  inherited;
  TPRBNetwork(Obj).RecalcActivation;
  UpdateInfo;
end;

initialization
  Editors.RegisterEditor(TPRBNetwork, TfmANNPRBEditor);
end.

