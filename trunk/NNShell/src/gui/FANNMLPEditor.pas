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
unit FANNMLPEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, JvSpin, ComCtrls, Grids, JvGrids, Mask,
  FEditor, eANNCore, FANNEditor, eANNMLP, JvExGrids, JvExMask;

type
  TfmANNMLPEditor = class(TfmANNEditor)
    Bevel8: TBevel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label30: TLabel;
    iLC: TJvSpinEdit;
    iMC: TJvSpinEdit;
    iTol: TJvSpinEdit;
    tsLayers: TTabSheet;
    ScrollBox4: TScrollBox;
    Panel1: TPanel;
    dgLayers: TJvDrawGrid;
    btAddLayer: TBitBtn;
    BitBtn2: TBitBtn;
    btModifyNet: TBitBtn;
    cbNorm: TCheckBox;
    procedure pcEditorChange(Sender: TObject);
    procedure iLCChange(Sender: TObject);
    procedure iMCChange(Sender: TObject);
    procedure iTolChange(Sender: TObject);
    procedure dgLayersGetPicklist(Sender: TObject; ACol, ARow: Longint;
      PickList: TStrings);
    procedure dgLayersDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure dgLayersShowEditor(Sender: TObject; ACol, ARow: Longint;
      var AllowEdit: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure dgLayersGetEditAlign(Sender: TObject; ACol, ARow: Longint;
      var Alignment: TAlignment);
    procedure dgLayersGetEditText(Sender: TObject; ACol, ARow: Longint;
      var Value: string);
    procedure dgLayersSetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: string);
    procedure FormDestroy(Sender: TObject);
    procedure btAddLayerClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btModifyNetClick(Sender: TObject);
    procedure cbNormClick(Sender: TObject);
    procedure dgLayersGetEditStyle(Sender: TObject; ACol, ARow: Integer;
      var Style: TEditStyle);
  protected
    { Private declarations }
    NeuKind: TStrings;
    function GetText(Col, Row: Longint): string;
    procedure ShowEditor; override;
    procedure UpdateLayerDesc;
    procedure UpdateLayerGrid;
    procedure UpdateParam;
  public
    { Public declarations }
    LayerDesc: TCollection;
  end;

type
  TLayerDesc  = class(TCollectionItem)
    public
     NumNeu: integer;
     NumWei: integer;
     NeuKnd: TNeuronClass;
    public
     constructor Create(ACollection: TCollection); override;
  end;

implementation

{$R *.DFM}

uses
  eLibCore;

constructor TLayerDesc.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  NumNeu:= 1;
  NumWei:= 1;
  NeuKnd:= nil;
end;

procedure TfmANNMLPEditor.ShowEditor;
begin
  inherited ShowEditor;
  UpdateParam;
end;

procedure TfmANNMLPEditor.pcEditorChange(Sender: TObject);
begin
  inherited;
  if pcEditor.ActivePage = tsProp then begin
    UpdateParam;
  end
  else if pcEditor.ActivePage = tsLayers then begin
    UpdateLayerDesc;
    UpdateLayerGrid;
  end;
end;

procedure TfmANNMLPEditor.UpdateLayerDesc;
var
  i: integer;
  L: TLayer;
begin
  LayerDesc.Clear;
  for i:= 0 to TMLPNetwork(Obj).NumLay-1 do begin
    L:= TMLPNetwork(Obj).Layers[i];
    with LayerDesc.Add as TLayerDesc do begin
      NumNeu:= L.NumNeu;
      NumWei:= L.Neurons[0].NumWei;
      NeuKnd:= TNeuronClass(L.Neurons[0].ClassType);
    end;
  end;
end;

procedure TfmANNMLPEditor.UpdateLayerGrid;
var
  N: integer;
begin
  N:= LayerDesc.Count;
  if N<1 then N:= 1;
  dgLayers.RowCount:= N+1;
  dgLayers.Invalidate;
end;

procedure TfmANNMLPEditor.UpdateParam;
begin
  with Obj as TMLPNetwork do begin
    iTol.Value:= Parameters.Tol;
    iMC.Value := Parameters.MC;
    iLC.Value := Parameters.LC;
    cbNorm.Checked:= Parameters.Normalize;
  end;
end;

procedure TfmANNMLPEditor.iLCChange(Sender: TObject);
begin
  inherited;
  with TMLPNetwork(Obj) do begin
    Parameters.LC:= iLC.Value;
    iLC.Value:= Parameters.LC;
  end;
end;

procedure TfmANNMLPEditor.iMCChange(Sender: TObject);
begin
  inherited;
  with TMLPNetwork(Obj) do begin
    Parameters.MC:= iMC.Value;
    iMC.Value:= Parameters.MC;
  end;
end;

procedure TfmANNMLPEditor.iTolChange(Sender: TObject);
begin
  inherited;
  with TMLPNetwork(Obj) do begin
    Parameters.Tol:= iTol.Value;
    iTol.Value:= Parameters.Tol;
  end;
end;

procedure TfmANNMLPEditor.dgLayersGetPicklist(Sender: TObject; ACol,
  ARow: Longint; PickList: TStrings);
begin
  inherited;
  PickList.AddStrings(NeuKind);
end;

function TfmANNMLPEditor.GetText(Col, Row: Longint): string;
var
  L: TLayerDesc;
begin
  Result:= '';
  L:= TLayerDesc(LayerDesc.Items[Row-1]);
  case Col of
    1: Result:= IntToStr(L.NumNeu);
    2: Result:= L.NeuKnd.Description;
  end;
end;
procedure TfmANNMLPEditor.dgLayersDrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
begin
  inherited;
  if Row = 0 then begin
    case Col of
      0: ;
      1: dgLayers.DrawStr(Rect, 'Neurons', taCenter);
      2: dgLayers.DrawStr(Rect, 'Kind', taCenter);
    end;
  end
  else begin
    if Row<=LayerDesc.Count then begin
      case Col of
        0: dgLayers.DrawStr(Rect, 'Layer#'+IntToStr(Row), taLeftJustify);
        1: dgLayers.DrawStr(Rect, GetText(Col, Row), taRightJustify);
        2: dgLayers.DrawStr(Rect, GetText(Col, Row), taLeftJustify);
      end;
    end;
  end
end;

procedure TfmANNMLPEditor.dgLayersShowEditor(Sender: TObject; ACol,
  ARow: Longint; var AllowEdit: Boolean);
begin
  inherited;
   AllowEdit:= (ARow<>0) and (ACol<>0) and (LayerDesc.Count>0);
end;

procedure TfmANNMLPEditor.FormCreate(Sender: TObject);
begin
  inherited;
  LayerDesc:= TCollection.Create(TLayerDesc);
  NeuKind:= TStringList.Create;
  NeuKind.Add(TPerceptron.Description);
  NeuKind.Add(TLinearNeuron.Description);
  NeuKind.Add(TLogisticNeuron.Description);
end;

procedure TfmANNMLPEditor.dgLayersGetEditAlign(Sender: TObject; ACol,
  ARow: Longint; var Alignment: TAlignment);
begin
  inherited;
  if ACol<>2 then Alignment:= taRightJustify;
end;

procedure TfmANNMLPEditor.dgLayersGetEditStyle(Sender: TObject; ACol,
  ARow: Integer; var Style: TEditStyle);
begin
  inherited;
  case ACol of
    1: Style:= ieSimple;
    2: Style:= iePickList;
  end;
end;

procedure TfmANNMLPEditor.dgLayersGetEditText(Sender: TObject; ACol,
  ARow: Longint; var Value: string);
begin
  inherited;
  Value:= GetText(ACol , ARow);
end;

procedure TfmANNMLPEditor.dgLayersSetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: string);
begin
  inherited;
  if (ARow=0) or (ARow>LayerDesc.Count) then exit;
  with TLayerDesc(LayerDesc.Items[ARow-1]) do begin
    case Acol of
      1: begin
        NumNeu:= Parser.IVal(Value);
        if NumNeu < 1 then NumNeu:= 1;
        if ARow <LayerDesc.Count then begin
          TLayerDesc(LayerDesc.Items[ARow]).NumWei:= NumNeu;
          dgLayers.InvalidateRow(ARow+1);
        end;
      end;
      2: begin
        if Value = TPerceptron.Description then NeuKnd:= TPerceptron;
        if Value = TLinearNeuron.Description then NeuKnd:= TLinearNeuron;
        if Value = TLogisticNeuron.Description then NeuKnd:= TLogisticNeuron;
      end;
    end;
  end;
  dgLayers.InvalidateRow(ARow);
end;

procedure TfmANNMLPEditor.FormDestroy(Sender: TObject);
begin
  inherited;
  LayerDesc.Free;
  NeuKind.Free;
end;

procedure TfmANNMLPEditor.btAddLayerClick(Sender: TObject);
begin
  inherited;
  with LayerDesc.Add as TLayerDesc do begin
    NumNeu:= 1;
    NumWei:= 1;
    NeuKnd:= TLogisticNeuron;
    if LayerDesc.Count = 1 then begin
      if TANN(Obj).DimInp > 0 then NumNeu:= TANN(Obj).DimInp;
      NeuKnd:= TLinearNeuron;
    end
    else begin
      if TANN(Obj).DimOut > 0 then NumNeu:= TANN(Obj).DimOut;
      NumWei:= TLayerDesc(LayerDesc.Items[LayerDesc.Count-2]).NumNeu;
    end;
  end;
  UpdateLayerGrid;
end;

procedure TfmANNMLPEditor.BitBtn2Click(Sender: TObject);
begin
  inherited;
  if LayerDesc.Count>0 then begin
    if dgLayers.Row>0 then begin
      LayerDesc.Items[dgLayers.Row-1].Free;
      UpdateLayerGrid;
    end;
  end;
end;

procedure TfmANNMLPEditor.btModifyNetClick(Sender: TObject);
var
  N: TMLPNetwork;
  L: TLayer;
  i: integer;
begin
  inherited;
  N:= TMLPNetwork(Obj);
  if niTrained in N.NetInfos then N.Reset;
  for i:= N.NumLay-1 downto 0 do begin
    N.Layers[i].Free;
  end;
  for i:= 0 to LayerDesc.Count-1 do begin
    with TLayerDesc(LayerDesc.Items[i]) do begin
      L:= TLayer.Create(N);
      L.Setup(NumNeu, NeuKnd);
    end;
  end;
end;

procedure TfmANNMLPEditor.cbNormClick(Sender: TObject);
begin
  inherited;
  with TMLPNetwork(Obj) do begin
    Parameters.Normalize:= cbNorm.Checked;
  end;
end;

initialization
  Editors.RegisterEditor(TMLPNetwork, TfmANNMLPEditor);
end.

