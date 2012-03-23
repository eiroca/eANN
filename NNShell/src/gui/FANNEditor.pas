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
unit FANNEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FEditor, StdCtrls, Buttons, ComCtrls, ExtCtrls, JvSpin, Mask, JvExMask;

type
  TfmANNEditor = class(TfmEditor)
    pcEditor: TPageControl;
    tsProp: TTabSheet;
    tsInfo: TTabSheet;
    tsActions: TTabSheet;
    ScrollBox1: TScrollBox;
    btStop: TBitBtn;
    btReset: TBitBtn;
    btApply: TBitBtn;
    btError: TBitBtn;
    btTrain: TBitBtn;
    ScrollBox2: TScrollBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    cbSuper: TCheckBox;
    cbTrained: TCheckBox;
    cbProgressive: TCheckBox;
    cbReset: TCheckBox;
    cbTrain: TCheckBox;
    cbApply: TCheckBox;
    cbError: TCheckBox;
    bNetIs: TBevel;
    Label1: TLabel;
    bNetCan: TBevel;
    Label19: TLabel;
    lbFindCluster: TLabel;
    lbLearn: TLabel;
    lbAcquire: TLabel;
    cbLearn: TCheckBox;
    cbFindCluster: TCheckBox;
    cbAcquire: TCheckBox;
    bNetOpe: TBevel;
    Label20: TLabel;
    ScrollBox3: TScrollBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbDimInp: TLabel;
    lbDimOut: TLabel;
    lbDesc: TLabel;
    Label18: TLabel;
    cbErrMode: TCheckBox;
    iErrParam: TJvSpinEdit;
    iIter: TJvSpinEdit;
    iProgStep: TJvSpinEdit;
    cbDataIn: TComboBox;
    cbDataOut: TComboBox;
    iName: TEdit;
    btRename: TBitBtn;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    cbNewErrSet: TCheckBox;
    cbSimul: TCheckBox;
    lbSimul: TLabel;
    bProp: TBevel;
    bOpts: TBevel;
    lbOptions: TLabel;
    btClearDataIn: TSpeedButton;
    btCleadDataOut: TSpeedButton;
    cbMakeNewDataList: TCheckBox;
    procedure btTrainClick(Sender: TObject);
    procedure btErrorClick(Sender: TObject);
    procedure btApplyClick(Sender: TObject);
    procedure btResetClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure cbErrModeClick(Sender: TObject);
    procedure iErrParamChange(Sender: TObject);
    procedure iIterChange(Sender: TObject);
    procedure iProgStepChange(Sender: TObject);
    procedure cbDataOutChange(Sender: TObject);
    procedure cbDataInChange(Sender: TObject);
    procedure btRenameClick(Sender: TObject);
    procedure iNameChange(Sender: TObject);
    procedure iNameKeyPress(Sender: TObject; var Key: Char);
    procedure btClearDataInClick(Sender: TObject);
    procedure btCleadDataOutClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateDataPicker;
    procedure UpdateInfo;
  protected
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
  eDataPick, eLibMath, eLibStat, eANNCore;

procedure TfmANNEditor.UpdateInfo;
begin
  cbTrained.Checked:= niTrained in TANN(Obj).NetInfos;
end;

procedure TfmANNEditor.UpdateDataPicker;
var
  Net: TANN;
  ps: integer;
begin
  Net:= TANN(Obj);
  WorkSpace.GetDataPicker(cbDataIn.Items);
  WorkSpace.GetDataPicker(cbDataOut.Items);
  ps:= -1;
  if Net.DataIn <> nil then ps:= cbDataIn.Items.IndexOf(Net.DataIn.Name);
  cbDataIn.ItemIndex:= ps;
  ps:= -1;
  if Net.DataOut <> nil then ps:= cbDataOut.Items.IndexOf(Net.DataOut.Name);
  cbDataOut.ItemIndex:= ps;
end;

procedure TfmANNEditor.ShowEditor;
var
  OP: TNetOpers;
  Net: TANN;
begin
  inherited;
  pcEditor.ActivePAge:= tsProp;
  iName.Text:= Obj.Name;
  btRename.Enabled:= false;
  Net:= Obj as TANN;
  lbDesc.Caption:= Net.Description;
  iName.Text:= Net.Name;
  cbSuper.Checked:= niSuper in Net.NetInfos;
  UpdateInfo;
  cbProgressive.Checked:= niProgressive in Net.NetInfos;
  OP:= Net.SupportedOperation;
  cbReset.Checked:= eANNCore.noReset in Op; btReset.Enabled:= eANNCore.noReset in Op;
  cbApply.Checked:= eANNCore.noApply in Op; btApply.Enabled:= eANNCore.noApply in Op;
  cbTrain.Checked:= eANNCore.noTrain in Op; btTrain.Enabled:= eANNCore.noTrain in Op;
  cbError.Checked:= eANNCore.noError in Op; btError.Enabled:= eANNCore.noError in Op;
  cbLearn.Checked:= eANNCore.noLearn in Op;
  cbSimul.Checked:= eANNCore.noSimul in Op;
  cbFindCluster.Checked:= eANNCore.noFindCluster in Op;
  cbAcquire.Checked:= noAcquire in Op;
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
  btStop.Enabled:= false;
  UpdateDataPicker;
  if Net.DimInp>=0 then lbDimInp.Caption:= 'Dim '+IntToStr(Net.DimInp)
  else lbDimInp.Caption:= '';
  if Net.DimOut>=0 then lbDimOut.Caption:= 'Dim '+IntToStr(Net.DimOut)
  else lbDimOut.Caption:= '';
  WorkSpace.CreateListener.Add(OnCreateEvent);
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

procedure TfmANNEditor.btTrainClick(Sender: TObject);
begin
  inherited;
  btStop.Enabled:= true;
  try
    TANN(Obj).Train;
    UpdateInfo;
  finally
    btStop.Enabled:= false;
  end;
end;

procedure TfmANNEditor.btErrorClick(Sender: TObject);
var
  ES: TErrorSet;
begin
  inherited;
  if cbNewErrSet.Checked then begin
    ES:= WorkSpace.MakeErrorSet;
  end
  else begin
    ES:= TErrorSet.Create(nil);
  end;
  btStop.Enabled:= true;
  try
    TANN(Obj).Error(ES);
    ES.Report(Output);
    UpdateInfo;
  finally
    btStop.Enabled:= false;
    if not cbNewErrSet.Checked then begin
      ES.Free;
    end
  end;
end;

procedure TfmANNEditor.btApplyClick(Sender: TObject);
var
  DP: TDataList;
  sz: integer;
begin
  inherited;
  btStop.Enabled:= true;
  if cbMakeNewDataList.Checked then begin
    DP:= WorkSpace.MakeDataPicker(TDataList) as TDataList;
    with TANN(Obj) do begin
      if (niSuper in NetInfos) and (DataOut<>nil) then sz:= DataOut.Dim
      else sz:= 1;
      DP.Dim:= sz;
      DataOut:= DP;
    end;
  end;
  try
    TANN(Obj).Apply;
  finally
    btStop.Enabled:= false;
  end;
end;

procedure TfmANNEditor.btResetClick(Sender: TObject);
begin
  inherited;
  btStop.Enabled:= true;
  try
    TANN(Obj).Reset;
    UpdateInfo;
  finally
    btStop.Enabled:= false;
  end;
end;

procedure TfmANNEditor.btStopClick(Sender: TObject);
begin
  inherited;
  TANN(Obj).StopOper:= true;
end;

procedure TfmANNEditor.cbErrModeClick(Sender: TObject);
begin
  inherited;
  iErrParam.Enabled:= cbErrMode.Checked;
  if cbErrMode.Checked then TANN(Obj).Options.ErrorMode:= imNone
  else TANN(Obj).Options.ErrorMode:= imLowerThan;
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

procedure TfmANNEditor.cbDataOutChange(Sender: TObject);
var
  ps: integer;
begin
  inherited;
  ps:= cbDataOut.ItemIndex;
  if ps <> -1 then begin
    TANN(Obj).DataOut:= TDataPicker(cbDataOut.Items.Objects[ps]);
    lbDimOut.Caption:= IntToStr(TANN(Obj).DimOut);
  end;
end;

procedure TfmANNEditor.cbDataInChange(Sender: TObject);
var
  ps: integer;
begin
  inherited;
  ps:= cbDataIn.ItemIndex;
  if ps <> -1 then begin
    TANN(Obj).DataIn:= TDataPicker(cbDataIn.Items.Objects[ps]);
    lbDimInp.Caption:= IntToStr(TANN(Obj).DimInp);
  end;
end;

procedure TfmANNEditor.btRenameClick(Sender: TObject);
begin
  inherited;
  WorkSpace.RenameObject(Obj, iName.Text);
end;

procedure TfmANNEditor.iNameChange(Sender: TObject);
begin
  inherited;
  btRename.Enabled:= WorkSpace.ValidRename(Obj, Obj.Name, iName.Text);
end;

procedure TfmANNEditor.iNameKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key>=#32) and (Key<>#127) then begin
    if not CharInSet(Key, ['A'..'Z','a'..'z','0'..'9','_']) then begin
      Key:= #0;
      Beep;
    end;
  end;
end;

procedure TfmANNEditor.btClearDataInClick(Sender: TObject);
begin
  inherited;
  TANN(Obj).DataIn:= nil;
  lbDimInp.Caption:= '';
  UpdateDataPicker;
end;

procedure TfmANNEditor.btCleadDataOutClick(Sender: TObject);
begin
  inherited;
  TANN(Obj).DataOut:= nil;
  lbDimOut.Caption:= '';
  UpdateDataPicker;
end;

initialization
  Editors.RegisterEditor(TANN, TfmANNEditor);
end.

