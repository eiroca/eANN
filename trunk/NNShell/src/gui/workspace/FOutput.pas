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
unit FOutput;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.AppEvnts, Vcl.Controls;

type
  TfmOutput = class(TForm)
    MainMenu1: TMainMenu;
    mnEdit: TMenuItem;
    miEditCopy: TMenuItem;
    miEditCut: TMenuItem;
    miEditPaste: TMenuItem;
    miEditSelect: TMenuItem;
    miFiler2: TMenuItem;
    miEditClear: TMenuItem;
    Loadtextfile1: TMenuItem;
    Savetextfile1: TMenuItem;
    ChangeFont1: TMenuItem;
    fdFontScr: TFontDialog;
    odLoadScr: TOpenDialog;
    odSaveScr: TSaveDialog;
    meOut: TMemo;
    N2: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure CloseWindow1Click(Sender: TObject);
    procedure miEditCopyClick(Sender: TObject);
    procedure miEditCutClick(Sender: TObject);
    procedure miEditClearClick(Sender: TObject);
    procedure miEditPasteClick(Sender: TObject);
    procedure miEditSelectClick(Sender: TObject);
    procedure ChangeFont1Click(Sender: TObject);
    procedure Loadtextfile1Click(Sender: TObject);
    procedure Savetextfile1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function Output: TStrings;

implementation

{$R *.DFM}

uses
  eLibCore, uOpzioni;

var
  fmOutput: TfmOutput = nil;

procedure TfmOutput.FormCreate(Sender: TObject);
begin
  meOut.Align:= alClient;
  meOut.Clear;
end;

procedure TfmOutput.CloseWindow1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmOutput.miEditCopyClick(Sender: TObject);
begin
  meOut.CopyToClipboard;
end;

procedure TfmOutput.miEditCutClick(Sender: TObject);
begin
  meOut.CutToClipboard;
end;

procedure TfmOutput.miEditClearClick(Sender: TObject);
begin
  if MessageDlg('Are you sure?', mtConfirmation, [mbNo, mbYes], 0) = mrYes then begin
    meOut.Clear;
  end;
end;

procedure TfmOutput.miEditSelectClick(Sender: TObject);
begin
  meOut.SelectAll;
end;

procedure TfmOutput.miEditPasteClick(Sender: TObject);
begin
  meOut.PasteFromClipboard;
end;

procedure TfmOutput.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
var
  flg: boolean;
begin
  with fmOutput do begin
    flg:= meOut.SelLength <> 0;
    miEditCopy.Enabled:= flg;
    miEditCut.Enabled:= flg;
  end;
end;

procedure TfmOutput.ChangeFont1Click(Sender: TObject);
begin
  fdFontScr.Font.Assign(meOut.Font);
  if fdFontScr.Execute then begin
    meOut.Font.Assign(fdFontScr.Font);
  end;
end;

procedure TfmOutput.Loadtextfile1Click(Sender: TObject);
begin
  if odLoadScr.Execute then begin
    meOut.Clear;
    meOut.Lines.LoadFromFile(odLoadScr.FileName);
  end;
end;

procedure TfmOutput.Savetextfile1Click(Sender: TObject);
begin
  if odSaveScr.Execute then begin
    meOut.Lines.SaveToFile(odSaveScr.FileName);
  end;
end;

function Output: TStrings;
begin
  if fmOutput = nil then begin
    Application.CreateForm(TfmOutput, fmOutput);
  end;
  fmOutput.Show;
  Result:= fmOutput.meOut.Lines;
end;

procedure TfmOutput.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfmOutput.FormDestroy(Sender: TObject);
begin
  fmOutput:= nil;
end;

end.
