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
unit FMain;

interface

uses
  System.SysUtils, System.Classes,
  uWorkSpace, FWorkSpace, FEditor,
  eLibMath, eANNCore, eDataPick,
  JvFormPlacement, JvComponentBase, JvAppStorage, JvAppIniStorage, JvCalc,
  JvSpeedbar, JvExExtCtrls, JvExtComponent,
  Vcl.Forms, Vcl.ImgList, Vcl.Controls, Vcl.StdActns, Vcl.ActnList, Vcl.Dialogs, JvBaseDlg,
  Vcl.Menus, Vcl.Samples.Gauges, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.AppEvnts;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    mnFile: TMenuItem;
    mnHelp: TMenuItem;
    miAbout: TMenuItem;
    miFileExit: TMenuItem;
    dlgCalc: TJVCalculator;
    miToolsCalcultator: TMenuItem;
    sbStatus: TJvSpeedbar;
    lbStatus: TLabel;
    Progress: TGauge;
    sbMain: TJvSpeedbar;
    ssFile: TJvSpeedbarSection;
    siLoad: TJvSpeedItem;
    siSave: TJvSpeedItem;
    siNew: TJvSpeedItem;
    miFileNew: TMenuItem;
    miFileOpen: TMenuItem;
    miFileClose: TMenuItem;
    miFileSave: TMenuItem;
    miFileSaveAs: TMenuItem;
    N1: TMenuItem;
    miToolCalc: TMenuItem;
    siExit: TJvSpeedItem;
    sdWorkspace: TSaveDialog;
    odWorkSpace: TOpenDialog;
    miToolsToolbar: TMenuItem;
    ssWorkSpace: TJvSpeedbarSection;
    siWSDelete: TJvSpeedItem;
    ssTools: TJvSpeedbarSection;
    siCalculator: TJvSpeedItem;
    siCustomize: TJvSpeedItem;
    ActionList1: TActionList;
    aFileExit: TFileExit;
    aWindowCascade: TWindowCascade;
    aWindowTileHorizontal: TWindowTileHorizontal;
    aWindowTileVertical: TWindowTileVertical;
    aWindowMinimizeAll: TWindowMinimizeAll;
    aWindowArrangeAll: TWindowArrange;
    ilMenu: TImageList;
    Window1: TMenuItem;
    ArrangeAll1: TMenuItem;
    MinimizeAll1: TMenuItem;
    ileVertically1: TMenuItem;
    ileHorizontally1: TMenuItem;
    Cascade1: TMenuItem;
    AppStorage: TJvAppIniFileStorage;
    fp: TJvFormStorage;
    appEvt: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure miToolsCalcultatorClick(Sender: TObject);
    procedure sbStatusApplyAlign(Sender: TObject; Align: TAlign;
      var Apply: Boolean);
    procedure SetINIPath(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miFileCloseClick(Sender: TObject);
    procedure miFileNewClick(Sender: TObject);
    procedure miFileOpenClick(Sender: TObject);
    procedure miFileSaveClick(Sender: TObject);
    procedure miFileSaveAsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miToolsToolbarClick(Sender: TObject);
    procedure siWSDeleteClick(Sender: TObject);
    procedure appEvtHint(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateMenuItems(Sender: TObject);
    function  CreateWorkSpace(const Name: string): TfmWorkSpace;
    function  OpenWorkSpace(const Path: string): boolean;
  public
    { Public declarations }
    procedure ProgressEvent(Sender: TANN; ProgKind: TProgressKind; Info: Longint);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

uses
  uOpzioni, eLibCore, FOutput, FAboutGPL,
  eANNPRB, eANNRB, eANNPLN, eANNMLP, eANNCom, 
  FErrorSetEditor,
  FDataPatternEditor, FDataListEditor,
  FANNEditor, FANNMLPEditor, FANNComEditor, FANNPLNEditor, FANNPRBEditor, FANNRBEditor;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  SetINIPath(nil);
  Caption:= Application.Title;
  lbStatus.Caption:= '';
  Screen.OnActiveFormChange := UpdateMenuItems;
end;

procedure TfmMain.UpdateMenuItems(Sender: TObject);
var
  flg: boolean;
begin
  flg:= MDIChildCount > 0;
    miFileClose.Enabled:= flg;
    miFileSave.Enabled:= flg;
    miFileSaveAs.Enabled:= flg;
    siSave.Enabled:= flg;
  flg:= (ActiveMDIChild <> nil) and (ActiveMDIChild is TfmWorkSpace);
    siWSDelete.Enabled:= flg;
end;

procedure TfmMain.miAboutClick(Sender: TObject);
begin
  AboutGPL(Application.Title);
end;

procedure TfmMain.FormResize(Sender: TObject);
begin
  if Height < 112 then Height:= 112;
  if Width  < 400 then Width := 400;
end;

procedure TfmMain.miToolsCalcultatorClick(Sender: TObject);
begin
  dlgCalc.Execute;
end;

procedure TfmMain.sbStatusApplyAlign(Sender: TObject; Align: TAlign;
  var Apply: Boolean);
begin
  Apply:= (Align=alTop) or (Align=alBottom) or (Align=alNone);
end;

procedure TfmMain.SetINIPath(Sender: TObject);
begin
  AppStorage.FileName:= Opzioni.INIPath;
end;

var
  Tic: TDateTime;

procedure TfmMain.ProgressEvent(Sender: TANN; ProgKind: TProgressKind; Info: Longint);
begin
  with fmMain do begin
    case ProgKind of
      pkInit: begin
        Tic:= Now;
        Progress.MaxValue:= Info;
        Progress.Progress:= Progress.MinValue;
      end;
      pkStep: begin
        Progress.Progress:= Progress.Progress+Info;
      end;
      pkDone: begin
        Progress.Progress:= Progress.MinValue;
        Tic:= Now-Tic;
        lbStatus.Caption:= Format('Elapsed time: %10.3f"', [Tic*24*60*60]);
      end;
    end;
  end;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange:= nil;
  { Must be done backwards through the MDIChildren array }
end;

procedure TfmMain.FormShow(Sender: TObject);
var
  flg: boolean;
  i, WSCnt: integer;
  WS: string;
begin
  flg:= false;
  WSCnt:= Opzioni.ReadInteger('WorkSpace','Count',0);
  if WSCnt > 0 then begin
    flg:= false;
    for i:= 1 to WSCnt do begin
      WS:= Opzioni.ReadString('WorkSpace','WorkSpace'+IntToStr(i),'');
      if (WS <> '') and (FileExists(WS)) then begin
        if OpenWorkSpace(WS) then flg:= true;
      end;
    end;
  end;
  if not flg then miFileNewClick(Self);
end;

procedure TfmMain.miFileCloseClick(Sender: TObject);
begin
  if ActiveMDIChild <> nil then begin
    ActiveMDIChild.Close;
  end;
end;

procedure TfmMain.appEvtHint(Sender: TObject);
begin
  lbStatus.Caption:= Application.Hint;
end;

function TfmMain.CreateWorkSpace(const Name: string): TfmWorkSpace;
begin
  { create a new MDI child window }
  Result:= TfmWorkSpace.Create(Application);
  Result.Caption:= Name;
end;

procedure TfmMain.miFileNewClick(Sender: TObject);
begin
  CreateWorkSpace('WorkSpace' + IntToStr(MDIChildCount + 1));
end;

function TfmMain.OpenWorkSpace(const Path: string): boolean;
var
  Child: TfmWorkSpace;
begin
  Result:= true;
  Child:= CreateWorkSpace('WorkSpace' + IntToStr(MDIChildCount + 1));
  Child.Path:= Path;
  try
    Child.WorkSpace.Load(Path);
  except
    on EStreamError do begin
      Result:= false;
      Child.Free;
    end;
    else begin
      Child.Free;
      raise;
    end;
  end;
end;

procedure TfmMain.miFileOpenClick(Sender: TObject);
begin
  if odWorkSpace.Execute then begin
    OpenWorkSpace(odWorkSpace.FileName);
  end;
end;

procedure TfmMain.miFileSaveClick(Sender: TObject);
var
  Child: TfmWorkSpace;
begin
  if ActiveMDIChild <> nil then begin
    if ActiveMDIChild is TfmWorkSpace then begin
      Child:= TfmWorkSpace(ActiveMDIChild);
      if Child.Path = '' then miFileSaveAsClick(Sender)
      else begin
        Child.WorkSpace.Save(Child.Path);
      end;
    end;
  end;
end;

procedure TfmMain.miFileSaveAsClick(Sender: TObject);
var
  Child: TfmWorkSpace;
begin
  if ActiveMDIChild <> nil then begin
    if ActiveMDIChild is TfmWorkSpace then begin
      if sdWorkSpace.Execute then begin
        Child:= TfmWorkSpace(ActiveMDIChild);
        Child.Path:= sdWorkSpace.FileName;
        Child.WorkSpace.Save(sdWorkSpace.FileName);
      end;
    end;
  end;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: integer;
  WSForm: TfmWorkSpace;
  cnt: integer;
begin
  Cnt:= 0;
  for I:= MDIChildCount - 1 downto 0 do begin
    if MDIChildren[I] is TfmWorkSpace then begin
      WSForm:= TfmWorkSpace(MDIChildren[I]);
      if WSForm.Path <> '' then begin
        inc(Cnt);
        Opzioni.WriteString('WorkSpace','WorkSpace'+IntToStr(Cnt),WSForm.Path);
      end;
    end;
  end;
  Opzioni.WriteInteger('WorkSpace','Count', Cnt);
end;

procedure TfmMain.miToolsToolbarClick(Sender: TObject);
begin
  sbMain.Customize(0);
end;

procedure TfmMain.siWSDeleteClick(Sender: TObject);
begin
  if (ActiveMDIChild <> nil) and (ActiveMDIChild is TfmWorkSpace) then begin
    (ActiveMDIChild as TfmWorkSpace).DeleteSelectedObject;
  end;
end;

end.

