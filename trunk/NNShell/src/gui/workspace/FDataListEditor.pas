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
unit FDataListEditor;

interface

uses
  System.SysUtils, System.Classes, System.Types,
  FEditor,
  JvGrids, JvExGrids, JvSpin,
  Vcl.Dialogs, Vcl.Grids, Vcl.Mask, JvExMask, Vcl.StdCtrls, Vcl.Buttons, Vcl.Controls,
  Vcl.Forms, Vcl.ComCtrls, Vcl.ExtCtrls;



type
  TfmDataListEditor = class(TfmEditor)
    pcEditor: TPageControl;
    tsProp: TTabSheet;
    tsData: TTabSheet;
    Panel1: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    iNumCif: TJvSpinEdit;
    iNumDec: TJvSpinEdit;
    dgDati: TJvDrawGrid;
    ScrollBox1: TScrollBox;
    iName: TEdit;
    btRename: TBitBtn;
    Label7: TLabel;
    Label5: TLabel;
    iDesc: TEdit;
    sdSave: TSaveDialog;
    Label1: TLabel;
    Label8: TLabel;
    iDim: TJvSpinEdit;
    iCount: TJvSpinEdit;
    btSave: TBitBtn;
    btLoad: TBitBtn;
    odOpen: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure iDescChange(Sender: TObject);
    function dgDatiAcceptEditKey(Sender: TObject;
      var Key: Char): Boolean;
    procedure dgDatiDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure dgDatiSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure dgDatiSetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: string);
    procedure iNumCifChange(Sender: TObject);
    procedure iNumDecChange(Sender: TObject);
    procedure dgDatiGetEditText(Sender: TObject; ACol, ARow: Longint;
      var Value: string);
    procedure pcEditorChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure pcEditorChange(Sender: TObject);
    procedure iNameChange(Sender: TObject);
    procedure btRenameClick(Sender: TObject);
    procedure iDimChange(Sender: TObject);
    procedure iCountChange(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure iNameKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    N, D: integer;
  protected
    procedure UpdateParam;
  protected
    procedure ShowEditor; override;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses
  eLibCore, FOutput, uWorkSpace, eDataPick;

procedure TfmDataListEditor.ShowEditor;
begin
  inherited;
  pcEditor.ActivePAge:= tsProp;
  iName.Text:= Obj.Name;
  btRename.Enabled:= false;
  UpdateParam;
end;

procedure TfmDataListEditor.UpdateParam;
var
  DL: TDataList;
begin
  DL:= Obj as TDataList;
  iDesc.Text:= DL.Desc;
  iDim.Value:= DL.Dim;
  iCount.Value:= DL.Count;
end;

procedure TfmDataListEditor.FormCreate(Sender: TObject);
begin
  inherited;
  N:= 9;
  D:= 4;
end;

procedure TfmDataListEditor.iDescChange(Sender: TObject);
begin
  inherited;
  TDataList(Obj).Desc:= iDesc.Text;
end;

function TfmDataListEditor.dgDatiAcceptEditKey(Sender: TObject;
  var Key: Char): Boolean;
begin
  inherited;
  Result:= CharInSet(Key, ['0'..'9',FormatSettings.DecimalSeparator,'+','-']);
end;

procedure TfmDataListEditor.dgDatiDrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
begin
  inherited;
  if Row = 0 then begin
    if Col = 0 then exit;
    dgDati.DrawStr(Rect, Format('Col[%d]', [Col]), taCenter);
  end
  else begin
    if Col = 0 then begin
      dgDati.DrawStr(Rect, Format('Smpl#%d', [Row]), taLeftJustify);
    end
    else begin
      if Obj <> nil then begin
        dgDati.DrawStr(Rect, Format('%*.*f', [n,d,TDataPicker(Obj)[Row-1][Col-1]]), taRightJustify);
      end;
    end;
  end;
end;

procedure TfmDataListEditor.dgDatiSelectCell(Sender: TObject; Col,
  Row: Longint; var CanSelect: Boolean);
begin
  inherited;
  CanSelect:= (Row<>0) and (Col<>0);
end;

procedure TfmDataListEditor.dgDatiSetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: string);
begin
  inherited;
  try
    TDataPicker(Obj)[ARow-1][ACol-1]:= StrToFloat(Value);
  except
    on EConvertError do ;
  end;
end;

procedure TfmDataListEditor.iNumCifChange(Sender: TObject);
begin
  inherited;
  N:= trunc(iNumCif.Value);
  dgDati.Invalidate;
end;

procedure TfmDataListEditor.iNumDecChange(Sender: TObject);
begin
  inherited;
  d:= trunc(iNumDec.Value);
  dgDati.Invalidate;
end;

procedure TfmDataListEditor.dgDatiGetEditText(Sender: TObject; ACol,
  ARow: Longint; var Value: string);
begin
  inherited;
  Value:= Format('%*.*f', [n, d, TDataPicker(Obj)[ARow-1][ACol-1]]);
end;

procedure TfmDataListEditor.pcEditorChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  inherited;
  if (pcEditor.ActivePage <> tsData) then begin
    if (Obj <> nil) and ((TDataPicker(Obj).Count<1) or (TDataPicker(Obj).Dim<1)) then AllowChange:= false;
  end;
end;

procedure TfmDataListEditor.pcEditorChange(Sender: TObject);
begin
  inherited;
  if pcEditor.ActivePAge = tsData then begin
    dgDati.RowCount:= TDataPicker(Obj).Count+1;
    dgDati.ColCount:= TDataPicker(Obj).Dim+1;
  end;
end;

procedure TfmDataListEditor.iNameChange(Sender: TObject);
begin
  inherited;
  btRename.Enabled:= WorkSpace.ValidRename(Obj, Obj.Name, iName.Text);
end;

procedure TfmDataListEditor.iNameKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not StrUtil.isLitteral(Key) then begin
    Key:= #0;
    Beep;
  end;
end;

procedure TfmDataListEditor.btRenameClick(Sender: TObject);
begin
  inherited;
  WorkSpace.RenameObject(Obj, iName.Text);
end;

procedure TfmDataListEditor.iDimChange(Sender: TObject);
begin
  inherited;
  TDataList(Obj).Dim:= trunc(iDim.Value);
end;

procedure TfmDataListEditor.iCountChange(Sender: TObject);
begin
  inherited;
  TDataList(Obj).Count:= trunc(iCount.Value);
end;

procedure TfmDataListEditor.btSaveClick(Sender: TObject);
var
  FileName: TFileName;
  S: TStream;
begin
  inherited;
  if sdSave.Execute then begin
    FileName:= sdSave.FileName;
    if ExtractFileExt(FileName) = '.dlf' then begin
      S:= TFileStream.Create(FileName, fmCreate);
      try
        TDataList(Obj).SaveToStream(S);
      finally
        S.Free;
      end;
    end
    else begin
      TDataList(Obj).SaveToFile(FileName);
    end;
  end;
end;

procedure TfmDataListEditor.btLoadClick(Sender: TObject);
var
  FileName: TFileName;
  S: TStream;
begin
  inherited;
  if odOpen.Execute then begin
    FileName:= odOpen.FileName;
    if ExtractFileExt(FileName) = '.dlf' then begin
      S:= TFileStream.Create(FileName, fmOpenRead);
      try
        TDataList(Obj).LoadFromStream(S);
      finally
        S.Free;
      end;
    end
    else begin
      TDataList(Obj).LoadFromFile(FileName);
    end;
    UpdateParam;
  end;
end;

initialization
  Editors.RegisterEditor(TDataList, TfmDataListEditor);
end.

