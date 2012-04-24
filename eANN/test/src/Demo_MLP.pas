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
unit Demo_MLP;

interface

uses
  TestFramework, Classes, SysUtils,
  uEANNTestCase,
  eDataPick, eLibMath, eLibStat,
  eANNCore, eANNMLP;

type
  MLP_Network = class(ANNTestCase)
  private
    procedure run_network(const NTW: array of TLayerDesc; iTrainPath: string; LC, MC, tol: Double; Normalize: Boolean; Iterations: integer = 10000);
  published
    procedure TestPerceptron_001;
    procedure TestPerceptron_002;
    procedure TestPerceptron_003;
  published
    procedure TestApprox_001;
    procedure TestApprox_002;
    procedure TestApprox_003;
    procedure TestApprox_004;
  published
    procedure Classifier_001;
  end;

implementation

//--------------------------------------------------------------------------------------------------
procedure MLP_Network.run_network;
var
  NW: TMLPNetwork;
  ip, op: TDataList;
  ES: TErrorSet;
  maxErr: double;
begin
  LoadPattern(iTrainPath, ip, op);
  NW:= TMLPNetwork.BuildNetwork(NTW, ip, op, LC, MC, tol, Normalize, Iterations);
  try
    NW.Train;
  except
    on EANNWarning do begin
      NW.Trained:= true;
    end;
  end;
  ES:= TErrorSet.Create(nil);
  NW.Error(ES);
  maxErr:= ES.Find(0).ErrAbs.Max;
  WriteMessage('');
  WriteMessage('Testing '+NW.Description+' on '+ip.Desc);
  WriteMessage('Max Error '+FloatToStr(maxErr)+' in '+IntToStr(NW.Epochs)+' iterations');
  WriteNetworkMLP(NW);
  WriteInfo(NW, true);
  WriteMessage('');
  Check(maxErr <= tol, 'Max error too high '+ FloatToStr(maxErr)+' > '+ FloatToStr(NW.Parameters.Tol));
  NW.Free;
  ES.Free;
  ip.Free;
  op.Free;
end;

//--------------------------------------------------------------------------------------------------
procedure MLP_Network.TestPerceptron_001;
const
  NTW: array[1..2] of TLayerDesc = (
    (Neu: 2; Kind: TNeuron),
    (Neu: 1; Kind: TPerceptron)
  );
begin
  run_network(NTW, 'data/MLP-P1.DAT', 0.25, 0, 0, false);
end;

procedure MLP_Network.TestPerceptron_002;
const
  NTW: array[1..2] of TLayerDesc = (
    (Neu: 2; Kind: TNeuron),
    (Neu: 2; Kind: TPerceptron)
  );
begin
  run_network(NTW, 'data/MLP-P2.DAT', 0.25, 0, 0, false);
end;

procedure MLP_Network.TestPerceptron_003;
const
  NTW: array[1..2] of TLayerDesc = (
    (Neu: 2; Kind: TNeuron),
    (Neu: 1; Kind: TPerceptron)
  );
begin
  run_network(NTW, 'data/MLP-P3.DAT', 0.25, 0, 0, true, 20000);
end;

//--------------------------------------------------------------------------------------------------
procedure MLP_Network.TestApprox_001;
const
  NTW: array[1..2] of TLayerDesc = (
    (Neu: 1; Kind: TNeuron),
    (Neu: 1; Kind: TLinearNeuron)
  );
begin
  run_network(NTW, 'data/MLP-F1.DAT', 0.25, 0, 0.0005, false);
end;

procedure MLP_Network.TestApprox_002;
const
  NTW: array[1..2] of TLayerDesc =
    (
    (Neu: 1; Kind: TNeuron),
    (Neu: 1; Kind: TLogisticNeuron)
    );
begin
  run_network(NTW, 'data/MLP-F2.DAT', 0.25, 0, 0.3, false);
end;

procedure MLP_Network.TestApprox_003;
const
  NTW: array[1..3] of TLayerDesc =
    (
    (Neu: 2; Kind: TNeuron),
    (Neu: 2; Kind: TLogisticNeuron),
    (Neu: 1; Kind: TLogisticNeuron)
    );
begin
  run_network(NTW, 'data/MLP-F3.DAT', 0.5, 0, 0.3, false, 50000);
end;

procedure MLP_Network.TestApprox_004;
const
  NTW: array[1..4] of TLayerDesc =
    (
    (Neu: 3; Kind: TNeuron),
    (Neu: 3; Kind: TLogisticNeuron),
    (Neu: 3; Kind: TLogisticNeuron),
    (Neu: 1; Kind: TLinearNeuron)
    );
begin
  run_network(NTW, 'data/MLP-F4.DAT', 0.25, 0, 0.01, false, 50000);
end;

//--------------------------------------------------------------------------------------------------
procedure MLP_Network.Classifier_001;
const
  NTW: array[1..3] of TLayerDesc =
    (
    (Neu: 8; Kind: TNeuron),
    (Neu: 4; Kind: TLogisticNeuron),
    (Neu: 1; Kind: TLinearNeuron)
    );
var
  NW: TMLPNetwork;
  ip, op, tp: TDataList;
begin
  LoadPattern('data/MLP-C1.DAT', ip, op);
  tp:= TDataPattern.Create(nil);
  tp.LoadFromFile('data/MLP-C1.TST');
  NW:= TMLPNetwork.BuildNetwork(NTW, ip, op, 0.25, 0, 0.4, false);
  try
    NW.Train;
  except
    on EANNWarning do ;
  end;
  NW.DataIn:= tp;
  NW.Apply;
  WriteMessage('');
  WriteMessage('Testing '+NW.Description+' on '+ip.Desc);
  WriteNetworkMLP(NW);
  WriteInfo(NW, false);
  WriteMessage('');
  NW.Free;
  ip.Free;
  op.Free;
  tp.Free;
end;

//--------------------------------------------------------------------------------------------------
initialization
  // Register any test cases with the test runner
  RegisterTest(MLP_Network.Suite);
end.


