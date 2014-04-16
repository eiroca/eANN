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
unit FANNEditor;

interface

uses
  System.SysUtils, System.Classes,
  eDataPick,
  Winapi.Windows,
  FEditor, JvExMask, JvSpin, JvExStdCtrls, JvCheckBox,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.Controls, Vcl.Forms;

type
  TAssociated = record
    sb: TSpeedButton;
    cb: TComboBox;
  end;

type
  TfmANNEditor = class(TfmEditor)
    gErrOpt: TGroupBox;
    gNetCan: TGroupBox;
    gNetOpe: TGroupBox;
    btRename: TBitBtn;
    btReset: TBitBtn;
    cbAcquire: TJvCheckBox;
    cbApply: TJvCheckBox;
    cbErrMode: TJvCheckBox;
    cbError: TJvCheckBox;
    cbFindCluster: TJvCheckBox;
    cbLearn: TJvCheckBox;
    cbNewErrSet: TJvCheckBox;
    cbProgressive: TJvCheckBox;
    cbReset: TJvCheckBox;
    cbSimul: TJvCheckBox;
    cbSuper: TJvCheckBox;
    cbTrain: TJvCheckBox;
    cbTrained: TJvCheckBox;
    gTrnOpt: TGroupBox;
    gNetDesc: TGroupBox;
    iErrParam: TJvSpinEdit;
    iIter: TJvSpinEdit;
    iName: TEdit;
    iProgStep: TJvSpinEdit;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    gDesc: TGroupBox;
    pcEditor: TPageControl;
    sbApply: TScrollBox;
    sbError: TScrollBox;
    sbProp: TScrollBox;
    sbTrain: TScrollBox;
    tsApply: TTabSheet;
    tsError: TTabSheet;
    tsProp: TTabSheet;
    tsTrain: TTabSheet;
    btTrain: TBitBtn;
    btApply: TBitBtn;
    btError: TBitBtn;
    btStopTrn: TBitBtn;
    btStopApl: TBitBtn;
    btStopErr: TBitBtn;
    gDataSource: TGroupBox;
    Label4: TLabel;
    btTrainIn: TSpeedButton;
    lbTrainOut: TLabel;
    btTrainOut: TSpeedButton;
    cbTrainIn: TComboBox;
    cbTrainOut: TComboBox;
    gDataSourceApl: TGroupBox;
    Label7: TLabel;
    btApplyIn: TSpeedButton;
    btApplyOut: TSpeedButton;
    cbApplyIn: TComboBox;
    cbApplyOut: TComboBox;
    cbOvervriteDataList: TJvCheckBox;
    JvGroupBox1: TGroupBox;
    Label11: TLabel;
    btErrorIn: TSpeedButton;
    Label16: TLabel;
    btErrorOut: TSpeedButton;
    cbErrorIn: TComboBox;
    cbErrorOut: TComboBox;
    gSize: TGroupBox;
    lbNetDim: TLabel;
    procedure btTrainClick(Sender: TObject);
    procedure btErrorClick(Sender: TObject);
    procedure btApplyClick(Sender: TObject);
    procedure btResetClick(Sender: TObject);
    procedure btStopTrnClick(Sender: TObject);
    procedure cbErrModeClick(Sender: TObject);
    procedure iErrParamChange(Sender: TObject);
    procedure iIterChange(Sender: TObject);
    procedure iProgStepChange(Sender: TObject);
    procedure btRenameClick(Sender: TObject);
    procedure iNameChange(Sender: TObject);
    procedure pcEditorChange(Sender: TObject);
    procedure cbOvervriteDataListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btDataClear(Sender: TObject);
  private
    { Private declarations }
    association: array[0..5] of TAssociated;
    procedure UpdateDataPicker;
    function  getDataPicker(source: TComboBox): TDataPicker;
  protected
    procedure UpdateInfo; virtual;
    procedure UpdateParam; virtual;
    procedure OnCreateEvent(Sender: TObject);
    procedure ShowEditor; override;
    procedure HideEditor; override;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses
  FOutput,
  eLibCore, eLibMath, eLibStat, eANNCore;

resourcestring
  sNETWORKMAP = 'Network maps %d -> %d';
  sNETWORKMAP_NONE = '<<unknown>>';

procedure TfmANNEditor.UpdateInfo;
var
  sizIn: integer;
  sizOut: integer;
  Net: TANN;
  vis: boolean;
begin
  if (Obj <> nil) then begin
    Net:= Obj as TANN;
    sizIn:= Net.DimInp;
    sizOut:= Net.DimOut;
    cbTrained.Checked:= TANN(Obj).Trained;
    vis:= (niSuper in Net.NetInfos);
    btTrainOut.Visible:= vis;
    cbTrainOut.Visible:= vis;
    lbTrainOut.Visible:= vis;
  end
  else begin
    sizIn:= 0;
    sizOut:= 0;
    cbTrained.Checked:= false;
    btTrainOut.Visible:= true;
    cbTrainOut.Visible:= true;
    lbTrainOut.Visible:= true;
  end;
  if ((sizIn>0) or (sizOut>0)) then begin
    if (sizIn<1) then sizIn:= 1;
    if (sizOut<1) then sizOut:= 1;
    lbNetDim.Caption:= Format(sNETWORKMAP, [sizIn, sizOut]);
  end
  else begin
    lbNetDim.Caption:= sNETWORKMAP_NONE;
  end;
end;

procedure TfmANNEditor.UpdateParam;
begin
end;

procedure TfmANNEditor.UpdateDataPicker;
var
  Net: TANN;
  ps: integer;
begin
  Net:= TANN(Obj);
  WorkSpace.GetDataPicker(cbTrainIn.Items);
  WorkSpace.GetDataPicker(cbApplyIn.Items);
  WorkSpace.GetDataPicker(cbErrorIn.Items);
  WorkSpace.GetDataPicker(cbTrainOut.Items);
  WorkSpace.GetDataPicker(cbApplyOut.Items);
  WorkSpace.GetDataPicker(cbErrorOut.Items);
  ps:= -1;
  if Net.DataIn <> nil then begin
    ps:= cbTrainIn.Items.IndexOf(Net.DataIn.Name);
  end;
  cbTrainIn.ItemIndex:= ps;
  ps:= -1;
  if Net.DataOut <> nil then begin
    ps:= cbTrainOut.Items.IndexOf(Net.DataOut.Name);
  end;
  cbTrainOut.ItemIndex:= ps;
end;

procedure TfmANNEditor.ShowEditor;
var
  OP: TNetOpers;
  Net: TANN;
  netCan: boolean;
begin
  inherited;
  pcEditor.ActivePAge:= tsProp;
  iName.Text:= Obj.Name;
  btRename.Enabled:= false;
  Net:= Obj as TANN;
  gDesc.Caption:= Net.Description;
  iName.Text:= Net.Name;
  cbSuper.Checked:= niSuper in Net.NetInfos;
  cbProgressive.Checked:= niProgressive in Net.NetInfos;
  OP:= Net.SupportedOperation;
  netCan:= (eANNCore.noReset in Op);
  begin
    cbReset.Checked:= netCan;
    btReset.Enabled:= netCan;
  end;
  netCan:= (eANNCore.noApply in Op);
  begin
    cbApply.Checked:= netCan;
    btApply.Enabled:= netCan;
    tsApply.TabVisible:= netCan;
  end;
  netCan:= (eANNCore.noTrain in Op);
  begin
    cbTrain.Checked:= netCan;
    btTrain.Enabled:= netCan;
    tsTrain.TabVisible:= netCan;
  end;
  netCan:= (eANNCore.noError in Op);
  begin
    cbError.Checked:= netCan;
    btError.Enabled:= netCan;
    tsError.TabVisible:= netCan;
  end;
  begin
    cbLearn.Checked:= eANNCore.noLearn in Op;
  end;
  begin
    cbSimul.Checked:= eANNCore.noSimul in Op;
  end;
  begin
    cbFindCluster.Checked:= eANNCore.noFindCluster in Op;
  end;
  begin
    cbAcquire.Checked:= noAcquire in Op;
  end;
  iErrParam.Value:= Net.Options.ErrorParam;
  if Net.Options.ErrorMode = imNone then begin
    cbErrMode.Checked:= false;
    iErrParam.Enabled:= false;
  end
  else begin
    cbErrMode.Checked:= true;
    iErrParam.Enabled:= true;
  end;
  iIter.Value:= Net.Options.Iterations;
  iProgStep.Value:= Net.Options.ProgressStep;
  btStopTrn.Enabled:= false;
  btStopApl.Enabled:= false;
  btStopErr.Enabled:= false;
  UpdateDataPicker;
  WorkSpace.CreateListener.Add(OnCreateEvent);
  UpdateInfo;
  UpdateParam;
end;

procedure TfmANNEditor.HideEditor;
begin
  WorkSpace.CreateListener.Del(OnCreateEvent);
  inherited;
end;

procedure TfmANNEditor.OnCreateEvent(Sender: TObject);
begin
  if Sender is TDataPicker then begin
    UpdateDataPicker;
  end;
end;

procedure TfmANNEditor.pcEditorChange(Sender: TObject);
begin
  inherited;
  if pcEditor.ActivePage = tsProp then begin
    UpdateInfo;
    UpdateParam;
  end
  else if pcEditor.ActivePage = tsTrain then begin
  end
  else if pcEditor.ActivePage = tsApply then begin
    if cbApplyIn.ItemIndex=-1 then cbApplyIn.ItemIndex:= cbTrainIn.ItemIndex;
    if cbApplyOut.ItemIndex=-1 then cbApplyOut.ItemIndex:= cbTrainOut.ItemIndex;
  end
  else if pcEditor.ActivePage = tsError then begin
    if cbErrorIn.ItemIndex=-1 then cbErrorIn.ItemIndex:= cbTrainIn.ItemIndex;
    if cbErrorOut.ItemIndex=-1 then cbErrorOut.ItemIndex:= cbTrainOut.ItemIndex;
  end;
end;

function TfmANNEditor.getDataPicker(source: TComboBox): TDataPicker;
var
  ps: integer;
begin
  ps:= source.ItemIndex;
  if ps <> -1 then begin
    Result:= TDataPicker(source.Items.Objects[ps]);
  end
  else begin
    Result:= nil;
  end;
end;

procedure TfmANNEditor.btTrainClick(Sender: TObject);
var
  Net: TANN;
begin
  inherited;
  Net:= Obj as TANN;
  Net.DataIn:= getDataPicker(cbTrainIn);
  Net.DataOut:= getDataPicker(cbTrainOut);
  try
    btStopTrn.Enabled:= true;
    Net.Train;
  finally
    UpdateInfo;
    btStopTrn.Enabled:= false;
  end;
end;

procedure TfmANNEditor.btApplyClick(Sender: TObject);
var
  DP: TDataList;
  sz: integer;
  Net: TANN;
begin
  inherited;
  Net:= Obj as TANN;
  Net.DataIn:= getDataPicker(cbApplyIn);
  if not cbOvervriteDataList.Checked then begin
    DP:= WorkSpace.MakeDataPicker(TDataList) as TDataList;
    DP.RawMode:= false;
    with Net do begin
      if (niSuper in NetInfos) and (DataOut<>nil) then sz:= DataOut.Dim
      else sz:= 1;
      DP.Dim:= sz;
      DataOut:= DP;
    end;
  end
  else begin
    Net.DataOut:= getDataPicker(cbApplyOut);
  end;
  try
    btStopApl.Enabled:= true;
    Net.Apply;
  finally
    UpdateInfo;
    btStopApl.Enabled:= false;
  end;
end;

procedure TfmANNEditor.btErrorClick(Sender: TObject);
var
  ES: TErrorSet;
  Net: TANN;
begin
  inherited;
  Net:= Obj as TANN;
  Net.DataIn:= getDataPicker(cbErrorIn);
  Net.DataOut:= getDataPicker(cbErrorOut);
  if cbNewErrSet.Checked then begin
    ES:= WorkSpace.MakeErrorSet;
  end
  else begin
    ES:= TErrorSet.Create(nil);
  end;
  try
    btStopErr.Enabled:= true;
    TANN(Obj).Error(ES);
    ES.Report(Output);
  finally
    UpdateInfo;
    btStopErr.Enabled:= false;
    if not cbNewErrSet.Checked then begin
      ES.Free;
    end
  end;
end;

procedure TfmANNEditor.btResetClick(Sender: TObject);
begin
  inherited;
  try
    TANN(Obj).Reset;
  finally
    UpdateInfo;
  end;
end;

procedure TfmANNEditor.btDataClear(Sender: TObject);
var
  sb: TSpeedButton;
  i: integer;
begin
  inherited;
  sb:= Sender as TSpeedButton;
  for i:= low(association) to high(association) do begin
    if association[i].sb = sb then begin
      association[i].cb.ItemIndex:= -1;
      break;
    end;
  end;
end;

procedure TfmANNEditor.btStopTrnClick(Sender: TObject);
begin
  inherited;
  TANN(Obj).StopOper:= true;
end;

procedure TfmANNEditor.cbErrModeClick(Sender: TObject);
begin
  inherited;
  iErrParam.Enabled:= cbErrMode.Checked;
  if cbErrMode.Checked then begin
    TANN(Obj).Options.ErrorMode:= imLowerThan
  end
  else begin
    TANN(Obj).Options.ErrorMode:= imNone;
  end;
end;

procedure TfmANNEditor.cbOvervriteDataListClick(Sender: TObject);
begin
  inherited;
  cbApplyOut.Enabled:= cbOvervriteDataList.Checked;
  btApplyOut.Enabled:= cbOvervriteDataList.Checked;
end;

procedure TfmANNEditor.iErrParamChange(Sender: TObject);
begin
  inherited;
  TANN(Obj).Options.ErrorParam:= iErrParam.Value;
  iErrParam.Value:= TANN(Obj).Options.ErrorParam;
end;

procedure TfmANNEditor.iIterChange(Sender: TObject);
begin
  inherited;
  TANN(Obj).Options.Iterations:= trunc(iIter.Value);
  iIter.Value:= TANN(Obj).Options.Iterations;
end;

procedure TfmANNEditor.iProgStepChange(Sender: TObject);
begin
  inherited;
  TANN(Obj).Options.ProgressStep:= trunc(iProgStep.Value);
  iProgStep.Value:= TANN(Obj).Options.ProgressStep;
end;

procedure TfmANNEditor.FormActivate(Sender: TObject);
begin
  inherited;
  UpdateInfo;
  UpdateParam;
end;

procedure TfmANNEditor.FormCreate(Sender: TObject);
begin
  inherited;
  btRename.Enabled:= false;
  cbApplyOut.Enabled:= cbOvervriteDataList.Checked;
  btApplyOut.Enabled:= cbOvervriteDataList.Checked;
  with association[0] do begin sb:= btTrainIn;  cb:= cbTrainIn;  end;
  with association[1] do begin sb:= btTrainOut; cb:= cbTrainOut; end;
  with association[2] do begin sb:= btApplyIn;  cb:= cbApplyIn;  end;
  with association[3] do begin sb:= btApplyOut; cb:= cbApplyOut; end;
  with association[4] do begin sb:= btErrorIn;  cb:= cbErrorIn;  end;
  with association[5] do begin sb:= btErrorOut; cb:= cbErrorOut; end;
end;

procedure TfmANNEditor.btRenameClick(Sender: TObject);
begin
  inherited;
  WorkSpace.RenameObject(Obj, iName.Text);
end;

procedure TfmANNEditor.iNameChange(Sender: TObject);
begin
  inherited;
  btRename.Enabled:= WorkSpace.ValidRename(Obj, iName.Text);
end;

initialization
  Editors.RegisterEditor(TANN, TfmANNEditor);
end.

