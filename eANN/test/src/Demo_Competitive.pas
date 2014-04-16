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
unit Demo_Competitive;

interface

uses
  TestFramework, Classes, SysUtils,
  eDataPick, eLibMath, eLibStat, uEANNTestCase,
  eANNCore, eANNCom;

type
  Competitive_Network = class(ANNTestCase)
  published
    procedure Classifier_001;
  end;

implementation

procedure Competitive_Network.Classifier_001;
var
  NW: TCompetitiveNetwork;
  ip, op, tp: TDataList;
begin
  LoadPattern('data/COM-C1.DAT', ip, op);
  tp:= TDataPattern.Create(nil);
  tp.LoadFromFile('data/COM-C1.TST');
  NW:= TCompetitiveNetwork.Create(nil);
  NW.DataIn:= ip;
  NW.Parameters.Eta:= 0.1;
  NW.Parameters.MaxNeu:= 4;
  NW.Options.Iterations:= 100;
  try
    NW.Train;
  except
    on EANNWarning do ;
  end;
  op.Dim:= 1;
  NW.DataIn:= tp;
  NW.DataOut:= op;
  NW.Apply;
  WriteMessage('');
  WriteMessage('Testing '+NW.Description+' on '+ip.Desc);
  WriteNetworkCom(NW);
  WriteMessage('');
  NW.Free;
  ip.Free;
  op.Free;
  tp.Free;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(Competitive_Network.Suite);
end.


