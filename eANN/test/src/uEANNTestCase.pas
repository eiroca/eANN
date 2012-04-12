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
unit uEANNTestCase;

interface

uses
  TestFramework, Classes, SysUtils,
  eDataPick, eLibMath, eLibStat,
  eANNCore, eANNCom, eANNMLP, eANNPLN, eANNPRB, eANNRB;

type
  EANNTestCase = class(TTestCase)
    protected
     f: TextFile;
    public
     procedure WriteInfo(NW: TANN; estimate: Boolean);
     procedure WriteTData(const data: TData);
    protected
     procedure WriteNetworkMLP(NW: TMLPNetwork);
     procedure WriteNetworkCom(NW: TCompetitiveNetwork);
     procedure WriteNetworkPL(NW: TPLNetwork);
    public
     procedure SetUp; override;
     procedure TearDown; override;
  end;


implementation

procedure EANNTestCase.SetUp;
begin
  Randomize;
  AssignFile(f, 'output.txt');
  try
    Append(f);
  except
    Rewrite(f);
  end;
end;

procedure EANNTestCase.TearDown;
begin
  CloseFile(f);
end;

procedure EANNTestCase.WriteTData(const data: TData);
var
  i: integer;
begin
  for i:= Low(data) to High(data) do begin
    if (i>Low(data)) then write(f, ' ');
    write(f, data[i]:6:2);
  end;
end;

procedure EANNTestCase.WriteInfo(NW: TANN; estimate: Boolean);
var
  i: integer;
  ip, op, ep: TData;
begin
  for i:= 0 to NW.DataIn.Count-1 do begin
    ip:= NW.DataIn[i];
    op:= NW.DataOut[i];
    write(f, ' Input : '); WriteTData(ip);
    write(f, ' Output: '); WriteTData(op);
    if (estimate) then begin
      SetLength(ep, Length(op));
      NW.Simul(ip, ep);
      write(f, ' Estim.: '); WriteTData(ep);
    end;
    writeln(f);
  end;
end;

procedure EANNTestCase.WriteNetworkMLP(NW: TMLPNetwork);
var
  i, j, k: integer;
begin
  for i := 0 to NW.NumLay - 1 do begin
    write(f, 'Layer ',i,' ');
    with NW.Layers[i] do begin
      write(f, NumNeu, ' ');
      for j:= 0 to NumNeu - 1 do begin
        with Neurons[j] do begin
          write(f, Description, '(', Bias);
          for k := 0 to NumWei - 1 do begin
            write(f, ' ', Weights[k]);
          end;
          write(f, ') ');
        end;
      end;
    end;
    writeln(f);
  end;
end;

procedure EANNTestCase.WriteNetworkCom(NW: TCompetitiveNetwork);
var
  i, j: integer;
begin
  for i := 0 to NW.NumNeu - 1 do begin
    write(f, 'Neuron ',i,' ');
    with NW.Neurons[i] do begin
      for j:= 0 to Center.Dim - 1 do begin
        write(f, ' ', FloatToStr(Center.Weights[j]));
      end;
    end;
    if (NW.Neurons[i] is TFullCompetitor) then begin
      write(f, ' - ');
      with NW.Neurons[i] as TFullCompetitor do begin
        for j:= 0 to Output.Dim - 1 do begin
          write(f, ' ', FloatToStr(Output.Weights[j]));
        end;
      end;
    end;
    writeln(f);
  end;
end;

procedure EANNTestCase.WriteNetworkPL(NW: TPLNetwork);
var
  i, j: integer;
begin
  for i := 0 to NW.NumNeu - 1 do begin
    write(f, 'Neuron ',i,' ');
    with NW.Neurons[i] as TFullCompetitor do begin
      for j:= 0 to Center.Dim - 1 do begin
        write(f, ' ', FloatToStr(Center.Weights[j]));
      end;
      write(f, ' - ');
      for j:= 0 to Output.Dim - 1 do begin
        write(f, ' ', FloatToStr(Output.Weights[j]));
      end;
    end;
    writeln(f);
  end;
end;

end.
