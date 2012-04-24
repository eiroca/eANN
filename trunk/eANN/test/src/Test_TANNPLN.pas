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
unit Test_TANNPLN;

interface

uses
  TestFramework, Classes, SysUtils, uEANNTestCase,
  eLibCore, eLibStat, eDataPick, eANNCore, eANNPLN;

type

  // Test methods for class TPLNElem
  TC_TPLNElem = class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

  // Test methods for class TANNPLN
  TC_TANNPLN = class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

implementation

//--------------------------------------------------------------------------------------------------
function TC_TPLNElem.NewRandom: TComponent;
var
  C: TPLNElem;
begin
  C:= TPLNElem.Create(nil);
  C.Center.Size:= random(5)+1;
  C.Center.Randomize(0, 1);
  C.HasCenter:= true;
  C.HasOutput:= true;
  C.Output.Size:= C.Center.Size;
  C.Output.Randomize(0, 1);
  C.Age:= Random;
  Result:= C;
end;

function TC_TPLNElem.NewEmpty: TComponent;
begin
  Result:= TPLNElem.Create(nil);
end;

//--------------------------------------------------------------------------------------------------
function TC_TANNPLN.NewRandom: TComponent;
var
 i: integer;
 N: TPLNetwork;
 E: TPLNElem;
begin
  N:= TPLNetwork.Create(nil);
  N.DimInp:= 2;
  N.DimOut:= 1;
  N.Options.Iterations:= random(1000);
  N.Options.ProgressStep:= random(10);
  N.Options.ErrorMode:= imLowerThan;
  N.Options.ErrorParam:= random;
  N.Parameters.RoI:= Random;
  N.Parameters.RoO:= Random;
  N.Parameters.Eta:= Random;
  N.Parameters.Eps:= Random;
  N.Parameters.Lamda:= Random;
  N.Parameters.Spread:= Random;
  N.Parameters.Win:= Random(4)+1;
  for i:= 0 to Random(2)+1 do begin
    E:= TPLNElem.Create(N);
    E.Age:= Random;
  end;
  Result:= N;
end;

function TC_TANNPLN.NewEmpty: TComponent;
begin
  Result:= TPLNetwork.Create(nil);
end;

//--------------------------------------------------------------------------------------------------
initialization
  // Register any test cases with the test runner
  RegisterTest(TC_TPLNElem.Suite);
  RegisterTest(TC_TANNPLN.Suite);
end.


