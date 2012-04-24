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
unit Test_TANNRB;

interface

uses
  TestFramework, Classes, SysUtils, uEANNTestCase,
  eLibCore, eLibStat, eDataPick, eANNCore, eANNRB;

type

  // Test methods for class TANNRB and its derivates
  TC_TANNRBGeneric = class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

  TC_TANNRB = class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

  TC_TANNPRB = class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

implementation

//--------------------------------------------------------------------------------------------------
function TC_TANNRBGeneric.NewRandom: TComponent;
var
  N: TGenericRBNetwork;
begin
  N:= TGenericRBNetwork.Create(nil);
  N.DimInp:= 2;
  N.DimOut:= 1;
  N.Options.Iterations:= random(1000);
  N.Options.ProgressStep:= random(10);
  N.Options.ErrorMode:= imLowerThan;
  N.Options.ErrorParam:= random;
  Result:= N;
end;

function TC_TANNRBGeneric.NewEmpty: TComponent;
begin
  Result:= TGenericRBNetwork.Create(nil);
end;

//--------------------------------------------------------------------------------------------------
function TC_TANNRB.NewRandom: TComponent;
var
  N: TRBNetwork;
begin
  N:= TRBNetwork.Create(nil);
  N.DimInp:= 2;
  N.DimOut:= 1;
  N.Options.Iterations:= random(1000);
  N.Options.ProgressStep:= random(10);
  N.Options.ErrorMode:= imLowerThan;
  N.Options.ErrorParam:= Random;
  N.Parameters.MaxErr:= Random;
  N.Parameters.Ro:= Random;
  N.Parameters.MaxNeu:= Random(5);
  Result:= N;
end;

function TC_TANNRB.NewEmpty: TComponent;
begin
  Result:= TRBNetwork.Create(nil);
end;

//--------------------------------------------------------------------------------------------------
function TC_TANNPRB.NewRandom: TComponent;
var
  N: TPRBNetwork;
begin
  N:= TPRBNetwork.Create(nil);
  N.DimInp:= 2;
  N.DimOut:= 1;
  N.Options.Iterations:= random(1000);
  N.Options.ProgressStep:= random(10);
  N.Options.ErrorMode:= imLowerThan;
  N.Options.ErrorParam:= Random;
  N.Parameters.Ro:= Random;
  N.Parameters.Delta  := Random;
  N.Parameters.Aged   := true;
  N.Parameters.Decay  := Random;
  N.Parameters.Spread := Random;
  N.Parameters.DeadAge:= Random;
  Result:= N;
end;

function TC_TANNPRB.NewEmpty: TComponent;
begin
  Result:= TPRBNetwork.Create(nil);
end;

//--------------------------------------------------------------------------------------------------
initialization
  // Register any test cases with the test runner
  RegisterTest(TC_TANNRBGeneric.Suite);
  RegisterTest(TC_TANNRB.Suite);
  RegisterTest(TC_TANNPRB.Suite);
end.

