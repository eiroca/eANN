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
unit Test_TANNCom;

interface

uses
  TestFramework, Classes, SysUtils, uEANNTestCase,
  eLibCore, eLibStat, eDataPick, eANNCore, eANNCom;

type

  // Test methods for class TCompetitor e its derivates
  TC_TCompetitor = class(AutoTestCase)
    protected
      function GetType: TCompetitorClass; virtual;
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

  TC_TFullCompetitor = class(TC_TCompetitor)
    protected
      function GetType: TCompetitorClass; override;
    protected
      function NewRandom: TComponent; override;
  end;

  // Test methods for class TANNCom
  TC_TANNCom = class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

implementation

//--------------------------------------------------------------------------------------------------
function TC_TCompetitor.GetType: TCompetitorClass;
begin
  Result:= TCompetitor;
end;

function TC_TCompetitor.NewRandom: TComponent;
var
  C: TCompetitor;
  T: TCompetitorClass;
begin
  T:= GetType;
  C:= T.Create(nil);
  C.Center.Size:= random(5)+1;
  C.Center.Randomize(0, 1);
  C.HasCenter:= true;
  Result:= C;
end;

function TC_TCompetitor.NewEmpty: TComponent;
var
  T: TCompetitorClass;
begin
  T:= GetType;
  Result:= T.Create(nil);
end;

//--------------------------------------------------------------------------------------------------
function TC_TFullCompetitor.GetType: TCompetitorClass;
begin
  Result:= TFullCompetitor;
end;

function TC_TFullCompetitor.NewRandom: TComponent;
var
  C: TFullCompetitor;
begin
  C:= TFullCompetitor.Create(nil);
  C.Center.Size:= random(5)+1;
  C.Center.Randomize(0, 1);
  C.HasCenter:= true;
  C.HasOutput:= true;
  C.Output.Size:= C.Center.Size;
  C.Output.Randomize(0, 1);
  Result:= C;
end;

//--------------------------------------------------------------------------------------------------
function TC_TANNCom.NewRandom: TComponent;
begin
  Result:= TCompetitiveNetwork.Create(nil);
  with TCompetitiveNetwork(Result) do begin
    DimInp:= 2;
    DimOut:= 1;
    Options.Iterations:= random(1000);
    Options.ProgressStep:= trunc(Options.Iterations/(random(10)+1))+1;
    Options.ErrorMode:= imLowerThan;
    Options.ErrorParam:= random;
    Parameters.Eta:= Random;
    Parameters.MaxNeu:= Random(5)+1;
  end;
end;

function TC_TANNCom.NewEmpty: TComponent;
begin
  Result:= TCompetitiveNetwork.Create(nil);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TC_TCompetitor.Suite);
  RegisterTest(TC_TFullCompetitor.Suite);
  RegisterTest(TC_TANNCom.Suite);
end.


