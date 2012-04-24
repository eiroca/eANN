(* GPL > 3.0
Copyright (C) 1996-2012 eIrOcA Enrico Croce & Simona Burzio

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
@author Enrico Croce
*)
program eANN_Tests;
{
  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.
}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  uEANNTestCase in 'src\uEANNTestCase.pas',
  Test_TANN in 'src\Test_TANN.pas',
  Test_TANNCom in 'src\Test_TANNCom.pas',
  Test_TANNMLP in 'src\Test_TANNMLP.pas',
  Test_TANNPLN in 'src\Test_TANNPLN.pas',
  Test_TANNRB in 'src\Test_TANNRB.pas',
  Demo_Competitive in 'src\Demo_Competitive.pas',
  Demo_MLP in 'src\Demo_MLP.pas',
  Demo_ProgressiveLearning in 'src\Demo_ProgressiveLearning.pas',
  Demo_ShapeDetector in 'src\Demo_ShapeDetector.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

