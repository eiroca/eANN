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
program NNShell2007;

uses
  Forms,
  uANNWorkSpace in 'lib\uANNWorkSpace.pas',
  uOpzioni in 'lib\uOpzioni.pas',
  FWorkSpace in 'gui\FWorkSpace.pas' {fmWorkSpace},
  FANNComEditor in 'gui\FANNComEditor.pas' {fmANNComEditor},
  FANNEditor in 'gui\FANNEditor.pas' {fmANNEditor},
  FANNMLPEditor in 'gui\FANNMLPEditor.pas' {fmANNMLPEditor},
  FANNPLNEditor in 'gui\FANNPLNEditor.pas' {fmANNPLNEditor},
  FANNPRBEditor in 'gui\FANNPRBEditor.pas' {fmANNPRBEditor},
  FANNRBEditor in 'gui\FANNRBEditor.pas' {fmANNRBEditor},
  FDataListEditor in 'workspace\FDataListEditor.pas' {fmDataListEditor},
  FDataPatternEditor in 'workspace\FDataPatternEditor.pas' {fmDataPatternEditor},
  FEditor in 'workspace\FEditor.pas' {fmEditor},
  FMain in 'gui\FMain.pas' {fmMain},
  FOutput in 'workspace\FOutput.pas' {fmOutput},
  uWorkSpace in 'workspace\uWorkSpace.pas',
  FErrorSetEditor in 'workspace\FErrorSetEditor.pas' {fmErrorSetEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'NNShell 2007';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
