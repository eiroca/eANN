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
unit Demo_ProgressiveLearning;

interface

uses
  TestFramework, Classes, SysUtils,
  eDataPick, eLibMath, eLibStat, uEANNTestCase,
  eANNCore, eANNPLN;

type

  // Test methods for class Progressive Learning Networks
  ProgressiveLearning_Network = class(EANNTestCase)
  published
    procedure Classifier_001;
  end;

implementation

procedure ProgressiveLearning_Network.Classifier_001;
var
  NW: TPLNetwork;
  ip, op, tp: TDataList;
begin
  LoadPattern('data/PLN-C1.DAT', ip, op);
  tp:= TDataPattern.Create(nil);
  tp.LoadFromFile('data/PLN-C1.TST');
  NW:= TPLNetwork.Create(nil);
  NW.DataIn:= ip;
  NW.DataOut:= op;
  NW.Parameters.RoI:= 0.1;
  NW.Parameters.RoO:= 0.1;
  try
    NW.Train;
  except
    on EANNWarning do ;
  end;
  NW.DataIn:= tp;
  NW.Apply;
  writeln(f);
  writeln(f, 'Testing '+NW.Description+' on '+ip.Desc);
  WriteNetworkPL(NW);
  WriteInfo(NW, false);
  writeln(f);
  NW.Free;
  ip.Free;
  op.Free;
  tp.Free;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(ProgressiveLearning_Network.Suite);
end.


