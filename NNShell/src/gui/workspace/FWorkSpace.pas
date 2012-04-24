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
unit FWorkSpace;

interface

uses
  System.Classes, System.SysUtils,
  eANNCore, eDataPick, uWorkSpace, uANNWorkspace,
  FEditor,
  Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ImgList, Vcl.Controls, Vcl.ExtCtrls, Vcl.ComCtrls,
  JvExExtCtrls, JvSplitter;

type
  TfmWorkSpace = class(TForm)
    ImageList1: TImageList;
    tvWorkSpace: TTreeView;
    RxSplitter1: TJvSplitter;
    mnWorkSpace: TMainMenu;
    WorkSpace1: TMenuItem;
    NewNeuralNetwork1: TMenuItem;
    MLP1: TMenuItem;
    Competitive1: TMenuItem;
    PLN1: TMenuItem;
    RBChen1: TMenuItem;
    PRB1: TMenuItem;
    NewData1: TMenuItem;
    DataPattern1: TMenuItem;
    pmWorkSpace: TPopupMenu;
    miNewNet: TMenuItem;
    PRB2: TMenuItem;
    RBChen2: TMenuItem;
    PLN2: TMenuItem;
    Competitive2: TMenuItem;
    MLP2: TMenuItem;
    miNewData: TMenuItem;
    DataPattern2: TMenuItem;
    miDelObj: TMenuItem;
    DeleteObject1: TMenuItem;
    pnWorkSpace: TPanel;
    DataList1: TMenuItem;
    DataList2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MLP1Click(Sender: TObject);
    procedure Competitive1Click(Sender: TObject);
    procedure PLN1Click(Sender: TObject);
    procedure RBChen1Click(Sender: TObject);
    procedure PRB1Click(Sender: TObject);
    procedure DataPattern1Click(Sender: TObject);
    procedure pmWorkSpacePopup(Sender: TObject);
    procedure miDelObjClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DataList1Click(Sender: TObject);
    procedure tvWorkSpaceChange(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
    FPath: string;
    FWorkSpace: TANNWorkSpace;
    Root: TTreeNode;
    NetWorks: TTreeNode;
    Data: TTreeNode;
//    Code: TTreeNode;
    Objects: TTreeNode;
  protected
    procedure SetPath(const vl: string);
    function  FindObject(Obj: TObject): TTreeNode;
    procedure CreateObjectProc(Sender: TObject);
    procedure FreeObjectProc(Sender: TObject);
    procedure NameChangeObjectProc(Sender: TObject);
  public
    { Public declarations }
    procedure DeleteSelectedObject;
  public
    property Path: string read FPath write SetPath;
    property WorkSpace: TANNWorkSpace read FWorkSpace;
  end;

implementation

{$R *.DFM}

uses
  FMain, eANNMLP, eANNCom, eANNPLN, eANNRB, FANNEditor;

const
  icHome   = 0;
  icFolderClose = 1;
  icFolderOpen = 2;
  icANN    = 3;
  icData   = 4;
  icError  = 5;

resourcestring
  sWorkspace = 'WorkSpace';
  sNetwork   = 'Network';
  sData      = 'Data';
  sObjects   = 'Objects';
  sCode      = 'Code';
  sWorkspaceCaption = 'Workspace: %s';
  sMsgAreYouSure = 'Are you sure to discard changes?';

procedure TfmWorkSpace.FormCreate(Sender: TObject);
var
  tn: TTreeNodes;
begin
  Path:= '';
  FWorkSpace:= TANNWorkSpace.Create(Self);
  WorkSpace.CreateListener.Add(CreateObjectProc);
  WorkSpace.FreeListener.Add(FreeObjectProc);
  WorkSpace.NameChangeListener.Add(NameChangeObjectProc);
  Editors.AddWorkSpace(WorkSpace, pnWorkSpace);
  pnWorkSpace.Align:= alClient;
  tn:= tvWorkSpace.Items;
  tn.Clear;
  Root:= tn.Add(nil, sWorkspace);
  Root.Data:= nil;
  Root.SelectedIndex:= icHome;
  Root.ImageIndex:= icHome;
  Networks:= tn.AddChild(Root, sNetwork);
  Networks.Data:= nil;
  Networks.SelectedIndex:= icFolderClose;
  Networks.ImageIndex:= icFolderClose;
  Data:= tn.AddChild(Root, sData);
  Data.Data:= nil;
  Data.SelectedIndex:= icFolderClose;
  Data.ImageIndex:= icFolderClose;
  Objects:= tn.AddChild(Root, sObjects);
  Objects.Data:= nil;
  Objects.SelectedIndex:= icFolderClose;
  Objects.ImageIndex:= icFolderClose;
(*
  Code:= tn.AddChild(Root, sCode);
  Code.Data:= nil;
  Code.SelectedIndex:= icFolderClose;
  Code.ImageIndex:= icFolderClose;
*)
  Root.Expand(true);
end;

procedure TfmWorkSpace.SetPath(const vl: string);
begin
  FPath:= vl;
  Caption:= Format(sWorkspaceCaption, [ExtractFileName(vl)]);
end;

procedure TfmWorkSpace.tvWorkSpaceChange(Sender: TObject; Node: TTreeNode);
begin
  Editors.Edit(WorkSpace, Node.Data);
end;

function TfmWorkSpace.FindObject(Obj: TObject): TTreeNode;
var
  TN: TTreeNodes;
  i: integer;
begin
  Result:= nil;
  TN:= tvWorkSpace.Items;
  if TN <> nil then begin
    for i:= 0 to TN.Count-1 do begin
      if TN.Item[i].Data = Obj then begin
        Result:= TN.Item[i];
        break;
      end;
    end;
  end;
end;

procedure TfmWorkSpace.FreeObjectProc(Sender: TObject);
var
  TN: TTreeNode;
begin
  TN:= FindObject(Sender);
  if TN <> nil then TN.Free;
end;

procedure TfmWorkSpace.NameChangeObjectProc(Sender: TObject);
var
  TN: TTreeNode;
begin
  TN:= FindObject(Sender);
  if TN <> nil then begin
    TN.Text:= (Sender as TComponent).Name;
  end;
end;

procedure TfmWorkSpace.CreateObjectProc(Sender: TObject);
var
  TN: TTreeNode;
  Net: TANN;
begin
  if Sender is TANN then begin
    Net:= TANN(Sender);
    TN:= tvWorkSpace.Items.AddChild(Networks, Net.Name);
    TN.Data:= pointer(Sender);
    TN.ImageIndex:= icANN;
    TN.SelectedIndex:= icANN;
    if not Assigned(Net.OnProgress) then  Net.OnProgress:= fmMain.ProgressEvent;
    Networks.Expand(true);
  end
  else if Sender is TDataPicker then begin
    TN:= tvWorkSpace.Items.AddChild(Data, TDataPicker(Sender).Name);
    TN.Data:= pointer(Sender);
    TN.ImageIndex:= icData;
    TN.SelectedIndex:= icData;
    Data.Expand(true);
  end
  else begin
    TN:= tvWorkSpace.Items.AddChild(Objects, TComponent(Sender).Name);
    TN.Data:= pointer(Sender);
    TN.ImageIndex:= icError;
    TN.SelectedIndex:= icError;
    Objects.Expand(true);
  end;
end;

procedure TfmWorkSpace.FormDestroy(Sender: TObject);
begin
  Editors.Edit(WorkSpace, nil);
  WorkSpace.CreateListener.Del(CreateObjectProc);
  WorkSpace.FreeListener.Del(FreeObjectProc);
  WorkSpace.NameChangeListener.Del(NameChangeObjectProc);
  Editors.DelWorkSpace(WorkSpace);
end;

procedure TfmWorkSpace.MLP1Click(Sender: TObject);
begin
  WorkSpace.MakeNetwork(TMLPNetwork);
end;

procedure TfmWorkSpace.Competitive1Click(Sender: TObject);
begin
  WorkSpace.MakeNetwork(TCompetitiveNetwork);
end;

procedure TfmWorkSpace.PLN1Click(Sender: TObject);
begin
  WorkSpace.MakeNetwork(TPLNetwork);
end;

procedure TfmWorkSpace.RBChen1Click(Sender: TObject);
begin
  WorkSpace.MakeNetwork(TRBNetwork);
end;

procedure TfmWorkSpace.PRB1Click(Sender: TObject);
begin
  WorkSpace.MakeNetwork(TPRBNetwork);
end;

procedure TfmWorkSpace.DataPattern1Click(Sender: TObject);
begin
  WorkSpace.MakeDataPicker(TDataPattern);
end;

procedure TfmWorkSpace.pmWorkSpacePopup(Sender: TObject);
var
  TN: TTreeNode;
  flg: boolean;
begin
  TN:= tvWorkSpace.Selected;
  flg:= (TN<>nil) and (TN.Data<>nil);
  miDelObj.Enabled:= flg;
end;

procedure TfmWorkSpace.miDelObjClick(Sender: TObject);
begin
  DeleteSelectedObject;
end;

procedure TfmWorkSpace.DeleteSelectedObject;
var
  TN: TTreeNode;
begin
  TN:= tvWorkSpace.Selected;
  if (TN<>nil) and (TN.Data<>nil) then WorkSpace.FreeObject(TN.Data);
end;

procedure TfmWorkSpace.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmWorkSpace.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose:= not WorkSpace.Changed or
    (MessageDlg(sMsgAreYouSure,mtConfirmation,[mbYes,mbNo],0)=mrYes);
end;

procedure TfmWorkSpace.DataList1Click(Sender: TObject);
begin
  WorkSpace.MakeDataPicker(TDataList);
end;

end.

