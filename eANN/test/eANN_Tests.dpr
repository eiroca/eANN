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
  Demo_MLP in 'src\Demo_MLP.pas',
  Demo_Competitive in 'src\Demo_Competitive.pas',
  Demo_ProgressiveLearning in 'src\Demo_ProgressiveLearning.pas',
  Demo_ShapeDetector in 'src\Demo_ShapeDetector.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

