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
@author Enrico Croce
*)
unit Test_TANN;

interface

uses
  TestFramework, Classes, SysUtils, uEANNTestCase,
  eLibCore, eLibStat, eDataPick, eANNCore;

type

  // Test methods for class TWeights
  TC_TWeights = class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
    published
      procedure Test_ChangeSize;
      procedure Test_DeepCopy;
  end;

  // Test methods for class TWeights
  TC_TActivityLogger = class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
    published
     procedure Test_Computation;
     procedure Test_Undo;
  end;

  // Test methods for class ANNOptions
  TC_TANNOptions = class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

  // Test methods for class TWeights
  TC_TANN = class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

implementation

//--------------------------------------------------------------------------------------------------
function TC_TWeights.NewRandom: TComponent;
const
  SIZE = 10;
var
  i: integer;
begin
  Result:= TWeights.new(SIZE);
  for i:= 0 to SIZE-1 do TWeights(Result).Data[i]:= random;
end;

function TC_TWeights.NewEmpty: TComponent;
begin
  Result:= TWeights.Create(nil);
end;

procedure TC_TWeights.Test_ChangeSize;
var
  W: TWeights;
begin
  W:= TWeights.new(10);
  Assert(W.Size=10);
  W.Size:= 5;
  Check(W.Size=5);
  W.Free;
end;

procedure TC_TWeights.Test_DeepCopy;
var
  W: TWeights;
  data: TData;
  test: TData;
  i: integer;
begin
  SetLength(data, 100);
  for i:= low(data) to high(data) do data[i]:= random;
  W:= TWeights.new(0);
  Check(W.Size=0);
  W.Size:= 5;
  Check(W.Size=5);
  W.SetWeights(data);
  Check(W.Size=High(data)+1);
  test:= W.GetWeights;
  for i:= low(data) to high(data) do begin
    Check(data[i] = test[i]);
  end;
  data[0]:= data[0]-1;
  Check(data[0] <> test[0]);
  Check(data[0] <> W[0]);
  W.Free;
end;

//--------------------------------------------------------------------------------------------------
function TC_TActivityLogger.NewRandom: TComponent;
begin
  Result:= TActivityLogger.Create(nil);
  with TActivityLogger(Result) do begin
    Add( 1);
    Add(-1);
  end;
end;

function TC_TActivityLogger.NewEmpty: TComponent;
begin
  Result:= TActivityLogger.Create(nil);
end;

procedure TC_TActivityLogger.Test_Computation;
var
  AL: TActivityLogger;
begin
  AL:= TActivityLogger.Create(nil);
  AL.Add(-1);
  AL.Add( 1);
  AL.Add( 0);
  AL.Add( 0);
  CheckInteger(AL.Count, 4);
  CheckDouble(AL.Current, 0);
  CheckDouble(AL.Average, 0);
  CheckDouble(AL.Variance, 0.5);
  CheckDouble(AL.Minimum, -1);
  CheckDouble(AL.Maximum,  1);
  AL.Free;
end;

procedure TC_TActivityLogger.Test_Undo;
var
  AL: TActivityLogger;
begin
  AL:= TActivityLogger.Create(nil);
  Check(not AL.CanUndo);
  AL.Undo;
  AL.Add(5);
  Check(AL.CanUndo);
  AL.Undo;
  AL.Add(0);
  Check(AL.CanUndo);
  AL.Undo;
  Check(not AL.CanUndo);
  AL.Undo;
  AL.Add( 0);
  AL.Add( 0);
  AL.Add(-1);
  AL.Add( 1);
  AL.Add(4);
  Check(AL.CanUndo);
  AL.Undo;
  CheckInteger(AL.Count, 4);
  CheckDouble(AL.Current, 1);
  CheckDouble(AL.Average, 0);
  CheckDouble(AL.Variance, 0.5);
  CheckDouble(AL.Minimum, -1);
  CheckDouble(AL.Maximum, +1);
  AL.Free;
end;

//--------------------------------------------------------------------------------------------------
function TC_TANNOptions.NewRandom: TComponent;
var
  Options: TANNOptions;
begin
  Options:= TANNOptions.Create(nil);
  Options.Iterations:= random(1000);
  Options.ProgressStep:= random(10)+1;
  Options.ErrorMode:= imLowerThan;
  Options.ErrorParam:= random;
  Result:= Options;
end;

function TC_TANNOptions.NewEmpty: TComponent;
begin
  Result:= TANNOptions.Create(nil);
end;

//--------------------------------------------------------------------------------------------------
function TC_TANN.NewRandom: TComponent;
begin
  Result:= TANN.Create(nil);
  with TANN(Result) do begin
    DimInp:= 2;
    DimOut:= 1;
    Options.Iterations:= random(1000);
    Options.ProgressStep:= random(10);
    Options.ErrorMode:= imLowerThan;
    Options.ErrorParam:= random;
  end;
end;

function TC_TANN.NewEmpty: TComponent;
begin
  Result:= TANN.Create(nil);
end;

//--------------------------------------------------------------------------------------------------
initialization
  // Register any test cases with the test runner
  RegisterTest(TC_TWeights.Suite);
  RegisterTest(TC_TActivityLogger.Suite);
  RegisterTest(TC_TANNOptions.Suite);
  RegisterTest(TC_TANN.Suite);
end.


