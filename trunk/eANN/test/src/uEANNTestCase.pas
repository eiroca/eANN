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
unit uEANNTestCase;

interface

uses
  TestFramework, Classes, SysUtils,
  eLibCore, eDataPick, eLibMath, eLibStat,
  eANNCore, eANNCom, eANNMLP, eANNPLN, eANNRB;

const
  ZERO = 0.00001;
  WRITEFULLINFO = false;

type
  ANNTestCase = class(TTestCase)
    public
      procedure CheckInteger(v1, v2: integer; Msg: string = '');
      procedure CheckDouble(v1, v2: double; Msg: string = '');
    public
     procedure WriteMessage(Msg: string);
    public
     procedure WriteInfo(NW: TANN; estimate: Boolean);
     procedure WriteTData(const data: TData);
    protected
     procedure WriteNetworkMLP(NW: TMLPNetwork);
     procedure WriteNetworkCom(NW: TCompetitiveNetwork);
     procedure WriteNetworkPL(NW: TPLNetwork);
    protected
    public
     procedure SetUp; override;
     procedure TearDown; override;
  end;

  AutoTestCase = class(ANNTestCase)
    private
      fullInfo: boolean;
    protected
      function NewRandom: TComponent; virtual; abstract;
      function NewEmpty: TComponent; virtual; abstract;
    public
     procedure SetUp; override;
    published
     procedure Test_Create;
     procedure Test_Assign;
     procedure Test_Serialize;
  end;

implementation
var
  f: TextFile;

procedure ANNTestCase.SetUp;
begin
  Randomize;
end;

procedure ANNTestCase.TearDown;
begin
end;

procedure ANNTestCase.CheckInteger(v1, v2: integer; Msg: string = '');
begin
  Check(v1=v2, Msg);
end;

procedure ANNTestCase.CheckDouble(v1, v2: double; Msg: string = '');
begin
  Check(Abs(v1-v2)<ZERO, Msg);
end;

procedure ANNTestCase.WriteMessage(Msg: string);
begin
  writeln(f, Msg);
end;

procedure ANNTestCase.WriteTData(const data: TData);
var
  i: integer;
begin
  for i:= Low(data) to High(data) do begin
    if (i>Low(data)) then write(f, ' ');
    write(f, data[i]:6:2);
  end;
end;

procedure ANNTestCase.WriteInfo(NW: TANN; estimate: Boolean);
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

procedure ANNTestCase.WriteNetworkMLP(NW: TMLPNetwork);
var
  i, j, k: integer;
begin
  for i := 0 to NW.NumLay - 1 do begin
    writeln(f, 'Layer ',i);
    with NW.Layers[i] do begin
      for j:= 0 to NumNeu - 1 do begin
        with Neurons[j] do begin
          write(f, '  ', Description, '(', Bias:12:8);
          for k := 0 to Size-1 do begin
            write(f, ' ', Weights[k]:12:8);
          end;
          writeln(f, ') ');
        end;
      end;
    end;
  end;
  writeln(f);
end;

procedure ANNTestCase.WriteNetworkCom(NW: TCompetitiveNetwork);
var
  i, j: integer;
begin
  for i := 0 to NW.NumNeu - 1 do begin
    write(f, 'Neuron ',i,' ');
    with NW.Neurons[i] do begin
      for j:= 0 to Center.Size - 1 do begin
        write(f, ' ', Center.Data[j]:12:8);
      end;
    end;
    if (NW.Neurons[i] is TFullCompetitor) then begin
      write(f, ' - ');
      with NW.Neurons[i] as TFullCompetitor do begin
        for j:= 0 to Output.Size - 1 do begin
          write(f, ' ', Output.Data[j]:12:8);
        end;
      end;
    end;
    writeln(f);
  end;
end;

procedure ANNTestCase.WriteNetworkPL(NW: TPLNetwork);
var
  i, j: integer;
begin
  for i := 0 to NW.NumNeu - 1 do begin
    write(f, 'Neuron ',i,' ');
    with NW.Neurons[i] as TFullCompetitor do begin
      for j:= 0 to Center.Size - 1 do begin
        write(f, ' ', Center.Data[j]:12:8);
      end;
      write(f, ' - ');
      for j:= 0 to Output.Size - 1 do begin
        write(f, ' ', Output.Data[j]:12:8);
      end;
    end;
    writeln(f);
  end;
end;

procedure AutoTestCase.SetUp;
begin
  inherited;
  fullInfo:= WRITEFULLINFO;
end;

procedure AutoTestCase.Test_Create;
var
  C: TComponent;
begin
  C:= NewEmpty;
  C.Free;
end;

procedure AutoTestCase.Test_Assign;
var
  C1, C2: TComponent;
begin
  C1:= NewRandom;
  C2:= NewEmpty;
  C2.Assign(C1);
  Check(C1.Equals(C2));
  C2.Free;
  C1.Free;
end;

procedure AutoTestCase.Test_Serialize;
var
  C1, C2: TComponent;
  S: TMemoryStream;
begin
  C1:= NewRandom;
  if (fullInfo) then WriteMessage('<<C0 '+TStorable.ComponentToString(C1));
  C2:= NewEmpty;
  C2.Assign(C1);
  S:= TMemoryStream.Create;
  S.WriteComponent(C1);
  C1.Free;
  S.Seek(0, soFromBeginning);
  C1:= S.ReadComponent(nil);
  S.Free;
  if (not C1.Equals(C2)) then begin
    WriteMessage('>>C1 '+TStorable.ComponentToString(C1));
    WriteMessage('>>C2 '+TStorable.ComponentToString(C2));
  end;
  Check(C1.Equals(C2), 'Error in binary the stream');
  C2.Free;
  C2:= TStorable.StringToComponent(TStorable.ComponentToString(C1));
  Check(C1.Equals(C2), 'Error in binary the text stream');
  C2.Free;
  C1.Free;
end;

initialization
  AssignFile(f, 'output.txt');
  Rewrite(f);
finalization
  CloseFile(f);
end.
