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
program NNShell;

uses
  Forms,
  uANNWorkSpace in 'lib\uANNWorkSpace.pas',
  uOpzioni in 'lib\uOpzioni.pas',
  FMain in 'gui\FMain.pas' {fmMain},
  Vcl.Themes,
  Vcl.Styles,
  uWorkSpace in 'lib\uWorkSpace.pas',
  FANNRBEditor in 'gui\ann\FANNRBEditor.pas' {fmANNRBEditor},
  FANNComEditor in 'gui\ann\FANNComEditor.pas' {fmANNComEditor},
  FANNEditor in 'gui\ann\FANNEditor.pas' {fmANNEditor},
  FANNMLPEditor in 'gui\ann\FANNMLPEditor.pas' {fmANNMLPEditor},
  FANNPLNEditor in 'gui\ann\FANNPLNEditor.pas' {fmANNPLNEditor},
  FANNPRBEditor in 'gui\ann\FANNPRBEditor.pas' {fmANNPRBEditor},
  FWorkSpace in 'gui\workspace\FWorkSpace.pas' {fmWorkSpace},
  FDataListEditor in 'gui\workspace\FDataListEditor.pas' {fmDataListEditor},
  FDataPatternEditor in 'gui\workspace\FDataPatternEditor.pas' {fmDataPatternEditor},
  FEditor in 'gui\workspace\FEditor.pas' {fmEditor},
  FErrorSetEditor in 'gui\workspace\FErrorSetEditor.pas' {fmErrorSetEditor},
  FOutput in 'gui\workspace\FOutput.pas' {fmOutput};

{$R *.res}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Aqua Light Slate');
  Application.Title := 'Neural Network Shell';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
