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
unit Test_TANNMLP;

interface

uses
  TestFramework, Classes, SysUtils, uEANNTestCase,
  eLibCore, eLibStat, eDataPick, eANNCore, eANNMLP;

type

  // Test methods for class TNeuron e its derivates
  TC_TNeuron = class(AutoTestCase)
    protected
      function GetType: TNeuronClass; virtual;
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

  TC_TLogisticNeuron = class(TC_TNeuron)
    protected
      function GetType: TNeuronClass; override;
  end;

  TC_TLinearNeuron = class(TC_TNeuron)
    protected
      function GetType: TNeuronClass; override;
  end;

  TC_TPerceptron = class(TC_TNeuron)
    protected
      function GetType: TNeuronClass; override;
  end;

  // Test methods for class TLayer
  TC_TLayer= class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

  // Test methods for class TANNMLP
  TC_TANNMLP = class(AutoTestCase)
    protected
      function NewRandom: TComponent; override;
      function NewEmpty: TComponent; override;
  end;

implementation

//--------------------------------------------------------------------------------------------------
function TC_TNeuron.GetType: TNeuronClass;
begin
  Result:= TNeuron;
end;

function TC_TNeuron.NewRandom: TComponent;
var
  N: TNeuron;
  T: TNeuronClass;
begin
  T:= GetType;
  N:= T.Create(nil);
  N.Size:= random(0)+2;
  N.Error:= random;
  N.State:= random;
  N.HasDelta:= true;
  Result:= N;
end;

function TC_TNeuron.NewEmpty: TComponent;
var
  T: TNeuronClass;
begin
  T:= GetType;
  Result:= T.Create(nil);
end;

//--------------------------------------------------------------------------------------------------
function TC_TLogisticNeuron.GetType: TNeuronClass;
begin
  Result:= TLogisticNeuron;
end;

//--------------------------------------------------------------------------------------------------
function TC_TLinearNeuron.GetType: TNeuronClass;
begin
  Result:= TLinearNeuron;
end;

//--------------------------------------------------------------------------------------------------
function TC_TPerceptron.GetType: TNeuronClass;
begin
  Result:= TPerceptron;
end;

//--------------------------------------------------------------------------------------------------
function TC_TLayer.NewRandom: TComponent;
var
  L: TLayer;
  neuType: TNeuronTypes;
  i: integer;
  N: TNeuron;
begin
  neuType:= TMLPNetwork.GetNeuronTypes;
  L:= TLayer.Create(nil);
  L.Name:= 'TestLayer';
  for i:= 0 to Random(2)+1 do begin
    N:= neuType[Random(Length(neuType))].Create(L);
    N.Size:= Random(2)+1;
    N.Error:= random;
    N.State:= random;
    N.HasDelta:= true;
  end;
  Result:= L;
end;

function TC_TLayer.NewEmpty: TComponent;
begin
  Result:= TLayer.Create(nil);
end;

//--------------------------------------------------------------------------------------------------
function TC_TANNMLP.NewRandom: TComponent;
var
  i, N, S: integer;
  L: TLayer;
  neuType: TNeuronTypes;
  MLP: TMLPNetwork;
begin
  neuType:= TMLPNetwork.GetNeuronTypes;
  MLP:= TMLPNetwork.Create(nil);
  MLP.DimInp:= 2;
  MLP.DimOut:= 1;
  MLP.Options.Iterations:= random(1000);
  MLP.Options.ProgressStep:= random(10)+1;
  MLP.Options.ErrorMode:= imLowerThan;
  MLP.Options.ErrorParam:= random;
  MLP.Parameters.LC:= random;
  MLP.Parameters.MC:= random;
  MLP.Parameters.Tol:= random;
  MLP.Parameters.Normalize:= true;
  N:= random(3)+2;
  for i:= 0 to N-1 do begin
    L:= TLayer.Create(MLP);
    S:= Random(3)+2;
    L.Setup(S, neuType[Random(Length(neuType))]);
  end;
  Result:= MLP;
end;

function TC_TANNMLP.NewEmpty: TComponent;
begin
  Result:= TMLPNetwork.Create(nil);
end;

//--------------------------------------------------------------------------------------------------
initialization
  // Register any test cases with the test runner
  RegisterTest(TC_TNeuron.Suite);
  RegisterTest(TC_TLogisticNeuron.Suite);
  RegisterTest(TC_TLinearNeuron.Suite);
  RegisterTest(TC_TPerceptron.Suite);
  RegisterTest(TC_TLayer.Suite);
  RegisterTest(TC_TANNMLP.Suite);
end.


