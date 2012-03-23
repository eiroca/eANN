unit Demos;
{$M+}
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework, Classes, SysUtils,
  eDataPick, eLibMath, eLibStat,
  eANNMsg, eANNCore, eANNCom, eANNMLP, eANNPLN, eANNPRB, eANNRB, eANNUtil;

type
  // Test methods for class TPRBNetwork

  TestANNNetwork = class(TTestCase)
  private
    f: TextFile;
    procedure WriteNetworkMLP(NW: TMLPNetwork);
    procedure WriteNetworkCom(NW: TCompetitiveNetwork);
    procedure WriteNetworkPL(NW: TPLNetwork);
    procedure WriteTData(const data: TData);
    procedure run_network(const NTW: array of TLayerDesc; iTrainPath: string; LC, MC, tol: Double; Normalize: Boolean);
    procedure WriteInfo(NW: TANN; estimate: Boolean);
    procedure WriteShape(NW1, NW2: TANN);
    procedure BuildNetwork(var NW: TMLPNetwork; const NTW: array of TLayerDesc; ip: TDataList; op: TDataList; LC: Double; MC: Double; tol: Double; Normalize: Boolean);
  public
    procedure SetUp; override;
    procedure TearDown; override;
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
    procedure MLP_Classifier;
    procedure Competivice_Classifier;
    procedure PL_Classifier;
  published
    procedure ShapeDetector;
  end;

implementation

procedure TestANNNetwork.SetUp;
begin
  Randomize;
  AssignFile(f, 'output.txt');
  try
    Append(f);
  except
    Rewrite(f);
  end;
end;

procedure TestANNNetwork.TearDown;
begin
  CloseFile(f);
end;

procedure TestANNNetwork.WriteTData(const data: TData);
var
  i: integer;
begin
  for i:= 0 to High(data) do begin
    if (i>0) then write(f, ' ');
    write(f, data[i]:6:2);
  end;
end;

procedure TestANNNetwork.WriteNetworkMLP(NW: TMLPNetwork);
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

procedure TestANNNetwork.WriteNetworkCom(NW: TCompetitiveNetwork);
var
  i, j, k: integer;
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

procedure TestANNNetwork.WriteNetworkPL(NW: TPLNetwork);
var
  i, j, k: integer;
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

procedure TestANNNetwork.WriteInfo(NW: TANN; estimate: Boolean);
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

procedure TestANNNetwork.BuildNetwork(var NW: TMLPNetwork; const NTW: array of TLayerDesc; ip: TDataList; op: TDataList; LC: Double; MC: Double; tol: Double; Normalize: Boolean);
begin
  NW := TMLPNetwork.Create(nil);
  NW.DataIn := ip;
  NW.DataOut := op;
  NW.Options.Iterations := 20000;
  NW.Parameters.LC := LC;
  NW.Parameters.MC := MC;
  NW.Parameters.Tol := tol;
  NW.Parameters.Normalize := Normalize;
  NW.MakeLayers(NTW);
end;

procedure TestANNNetwork.run_network(const NTW: array of TLayerDesc; iTrainPath: string; LC, MC, tol: Double; Normalize: Boolean);
var
  NW: TMLPNetwork;
  ip, op: TDataList;
  ES: TErrorSet;
  maxErr: double;
begin
  LoadPattern(iTrainPath, ip, op);
  BuildNetwork(NW, NTW, ip, op, LC, MC, tol, Normalize);
  try
    NW.Train;
  except
    on EANNWarning do ;
  end;
  ES:= TErrorSet.Create(nil);
  NW.Error(ES);
  maxErr:= ES.Find(0).ErrAbs.Max;
  writeln(f);
  writeln(f, 'Testing '+NW.Description+' on '+ip.Desc);
  writeln(f, 'Max Error ', maxErr, ' in ', NW.Epochs,' iterations');
  WriteNetworkMLP(NW);
  WriteInfo(NW, true);
  writeln(f);
  Check(maxErr <= tol, 'Max error too high '+ FloatToStr(maxErr)+' > '+ FloatToStr(NW.Parameters.Tol));
  NW.Free;
  ES.Free;
  ip.Free;
  op.Free;
end;

procedure TestANNNetwork.TestPerceptron_001;
const
  NTW: array[1..2] of TLayerDesc = (
    (Neu: 2; Kind: TNeuron),
    (Neu: 1; Kind: TPerceptron)
  );
begin
  run_network(NTW, 'data/MLP-P1.DAT', 0.25, 0, 0, false);
end;

procedure TestANNNetwork.TestPerceptron_002;
const
  NTW: array[1..2] of TLayerDesc = (
    (Neu: 2; Kind: TNeuron),
    (Neu: 2; Kind: TPerceptron)
  );
begin
  run_network(NTW, 'data/MLP-P2.DAT', 0.25, 0, 0, false);
end;

procedure TestANNNetwork.TestPerceptron_003;
const
  NTW: array[1..2] of TLayerDesc = (
    (Neu: 2; Kind: TNeuron),
    (Neu: 1; Kind: TPerceptron)
  );
begin
  run_network(NTW, 'data/MLP-P3.DAT', 0.25, 0, 0, true);
end;

procedure TestANNNetwork.TestApprox_001;
const
  NTW: array[1..2] of TLayerDesc = (
    (Neu: 1; Kind: TNeuron),
    (Neu: 1; Kind: TLinearNeuron)
  );
begin
  run_network(NTW, 'data/MLP-F1.DAT', 0.25, 0, 0.0005, false);
end;

procedure TestANNNetwork.TestApprox_002;
const
  NTW: array[1..2] of TLayerDesc =
    (
    (Neu: 1; Kind: TNeuron),
    (Neu: 1; Kind: TLogisticNeuron)
    );
begin
  run_network(NTW, 'data/MLP-F2.DAT', 0.25, 0, 0.3, false);
end;

procedure TestANNNetwork.TestApprox_003;
const
  NTW: array[1..3] of TLayerDesc =
    (
    (Neu: 2; Kind: TNeuron),
    (Neu: 2; Kind: TLogisticNeuron),
    (Neu: 1; Kind: TLogisticNeuron)
    );
begin
  run_network(NTW, 'data/MLP-F3.DAT', 0.5, 0, 0.3, false);
end;

procedure TestANNNetwork.TestApprox_004;
const
  NTW: array[1..4] of TLayerDesc =
    (
    (Neu: 3; Kind: TNeuron),
    (Neu: 3; Kind: TLogisticNeuron),
    (Neu: 3; Kind: TLogisticNeuron),
    (Neu: 1; Kind: TLinearNeuron)
    );
begin
  run_network(NTW, 'data/MLP-F4.DAT', 0.25, 0, 0.01, false);
end;

procedure TestANNNetwork.MLP_Classifier;
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
  BuildNetwork(NW, NTW, ip, op, 0.25, 0, 0.4, false);
  try
    NW.Train;
  except
    on EANNWarning do ;
  end;
  NW.DataIn:= tp;
  NW.Apply;
  writeln(f);
  writeln(f, 'Testing '+NW.Description+' on '+ip.Desc);
  WriteNetworkMLP(NW);
  WriteInfo(NW, false);
  writeln(f);
  NW.Free;
  ip.Free;
  op.Free;
  tp.Free;
end;

procedure TestANNNetwork.Competivice_Classifier;
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
  NW.Parameters.NumNeu:= 4;
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
  writeln(f);
  writeln(f, 'Testing '+NW.Description+' on '+ip.Desc);
  WriteNetworkCom(NW);

  writeln(f);
  NW.Free;
  ip.Free;
  op.Free;
  tp.Free;
end;

procedure TestANNNetwork.PL_Classifier;
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

procedure TestANNNetwork.WriteShape(NW1, NW2: TANN);
var
  i, j: integer;
  ip, p1, p2: TData;
begin
  SetLength(p1, NW1.DimOut);
  SetLength(p2, NW2.DimOut);
  for i:= 0 to NW1.DataIn.Count-1 do begin
    ip:= NW1.DataIn[i];
    NW1.Simul(ip, p1);
    NW2.Simul(ip, p2);
    Writeln(f, '(',findPosMax(p1)+1,',',findPosMax(p2)+1,')');
    for j := 0 to 24 do begin
      if ((j>0) and ((j mod 5) = 0)) then writeln(f);
      if (ip[j]>0.001) then write(f,'*')
      else write(f,'.');
    end;
    Writeln(f);
  end;
end;

procedure TestANNNetwork.ShapeDetector;
const
  NTW: array[1..3] of TLayerDesc =
    (
    (Neu: 25; Kind: TNeuron),
    (Neu: 18; Kind: TLogisticNeuron),
    (Neu:  9; Kind: TLogisticNeuron)
    );
var
  NW_what, NW_where: TMLPNetwork;
  pShape, pWhat, pWhere: TDataList;
begin
  pShape:= TDataPattern.Create(nil);
  pShape.LoadFromFile('data/NN-SHAPE.DAT');
  pWhat:= TDataPattern.Create(nil);
  pWhat.LoadFromFile('data/NN-WHAT.DAT');
  pWhere:= TDataPattern.Create(nil);
  pWhere.LoadFromFile('data/NN-WHERE.DAT');
  BuildNetwork(NW_what,  NTW, pShape, pWhat,  0.25, 0, 0, false);
  NW_what.Options.Iterations:= 200;
  BuildNetwork(NW_where, NTW, pShape, pWhere, 0.25, 0, 0, false);
  NW_where.Options.Iterations:= 200;
  try
    NW_What.Train;
  except
    on EANNWarning do ;
  end;
  try
    NW_Where.Train;
  except
    on EANNWarning do ;
  end;

  writeln(f);
  writeln(f, 'Testing '+pShape.Desc);
  WriteNetworkMLP(NW_What);
  WriteNetworkMLP(NW_Where);
  WriteShape(NW_What, NW_where);

  writeln(f);
  NW_What.Free;
  NW_Where.Free;
  pShape.Free;
  pWhat.Free;
  pWhere.Free;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestANNNetwork.Suite);
end.


