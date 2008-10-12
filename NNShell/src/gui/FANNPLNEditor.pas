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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FANNEditor, ExtCtrls, StdCtrls, Buttons, RXSpin, ComCtrls, eANN,
  eANNPLN, Mask;

type
  TfmANNPLNEditor = class(TfmANNEditor)
    Bevel11: TBevel;
    lbNumNeu: TLabel;
    Label26: TLabel;
    Bevel8: TBevel;
    Label21: TLabel;
    Label22: TLabel;
    Label30: TLabel;
    Label15: TLabel;
    iEps: TRxSpinEdit;
    iEta: TRxSpinEdit;
    iSpr: TRxSpinEdit;
    Bevel9: TBevel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label31: TLabel;
    iLmd: TRxSpinEdit;
    iRoI: TRxSpinEdit;
    iRoO: TRxSpinEdit;
    Bevel10: TBevel;
    Label13: TLabel;
    Label14: TLabel;
    iWin: TRxSpinEdit;
    procedure pcEditorChange(Sender: TObject);
    procedure iEpsChange(Sender: TObject);
    procedure iEtaChange(Sender: TObject);
    procedure iLmdChange(Sender: TObject);
    procedure iRoIChange(Sender: TObject);
    procedure iRoOChange(Sender: TObject);
    procedure iWinChange(Sender: TObject);
    procedure iSprChange(Sender: TObject);
  private
    { Private declarations }
    procedure ShowEditor; override;
    procedure UpdateParam;
    procedure MoreInfo;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TfmANNPLNEditor.ShowEditor;
begin
  inherited ShowEditor;
  UpdateParam;
end;

procedure TfmANNPLNEditor.pcEditorChange(Sender: TObject);
begin
  inherited;
  if pcEditor.ActivePage = tsProp then begin
    UpdateParam;
  end
  else if pcEditor.ActivePage = tsInfo then begin
    MoreInfo;
  end;
end;

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

procedure TfmANNPLNEditor.MoreInfo;
begin
  with TPLNetwork(Obj) do begin
    lbNumNeu.Caption   := IntToStr(NumNeu);
  end;
end;

end.

