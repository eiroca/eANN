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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FANNEditor, ExtCtrls, StdCtrls, Buttons, RXSpin, ComCtrls, Mask;

type
  TfmANNRBEditor = class(TfmANNEditor)
    Bevel11: TBevel;
    Label26: TLabel;
    lbNumNeu: TLabel;
    btRecalcAtt: TBitBtn;
    Bevel13: TBevel;
    lbAttMin: TLabel;
    lbAttMax: TLabel;
    lbAttLst: TLabel;
    lbAttNum: TLabel;
    lbAttVar: TLabel;
    lbAttAve: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Bevel9: TBevel;
    Bevel8: TBevel;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    iMaxNeu: TRxSpinEdit;
    iMaxErr: TRxSpinEdit;
    iRo: TRxSpinEdit;
    cbMaxNeu: TCheckBox;
    procedure pcEditorChange(Sender: TObject);
    procedure cbMaxNeuClick(Sender: TObject);
    procedure iRoChange(Sender: TObject);
    procedure iMaxErrChange(Sender: TObject);
    procedure iMaxNeuChange(Sender: TObject);
    procedure btRecalcAttClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowEditor; override;
    procedure UpdateParam;
    procedure UpdateMaxNeu;
    procedure MoreInfo;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses
  eANNRB;

procedure TfmANNRBEditor.ShowEditor;
begin
  inherited ShowEditor;
  UpdateParam;
end;

procedure TfmANNRBEditor.pcEditorChange(Sender: TObject);
begin
  inherited;
  if pcEditor.ActivePage = tsProp then begin
    UpdateParam;
  end
  else if pcEditor.ActivePage = tsInfo then begin
    MoreInfo;
  end;
end;

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

procedure TfmANNRBEditor.MoreInfo;
begin
  with TRBNetwork(Obj) do begin
    lbNumNeu.Caption   := IntToStr(NumNeu);
    if Att.MinAtt < 1e19 then lbAttMin.Caption:= Trim(Format('%11.5f',[Att.MinAtt]))
    else lbAttMin.Caption:= '<none>';
    if Att.MaxAtt > 0 then lbAttMax.Caption:= Trim(Format('%11.5f',[Att.MaxAtt]))
    else lbAttMax.Caption:= '<none>';
    lbAttAve.Caption:= Trim(Format('%11.5f', [Att.AveAtt]));
    lbAttVar.Caption:= Trim(Format('%11.5f', [Att.VarAtt]));
    lbAttNum.Caption:= Trim(Format('%5d', [Att.CntAtt]));
    lbAttLst.Caption:= Trim(Format('%11.5f', [Att.Att]));
  end;
end;

procedure TfmANNRBEditor.btRecalcAttClick(Sender: TObject);
begin
  inherited;
  TRBNetwork(Obj).RecalcActivation;
  MoreInfo;
end;

end.

