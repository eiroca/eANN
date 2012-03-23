(* GPL > 3.0
Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio

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
@created 04/11/1996
@lastmod 05/05/1999

Artificial Progressive Radial Neural Network @br
@br
 This is an implementation of Progressive Learning Radial Basis function artificial neural network @br
@br
History: @br
 1.00 First version @br
 1.01 Starting History's Log @br
 1.02 Sync with new ANN 1.12 @br
 2.01 Sync with new ANN 2.01 @br
@br
Some definition used in this documentation @br
"Activation" Sum of activation (gaussian function) of all neuron @br
@br
@todo  Improves matrix inversion
*)
unit eANNPRB;

interface

uses
  Classes, SysUtils, eANNCore, eANNUtil, eANNMsg, eANNRB, eDataPick, eLibMath;

type

  TCustomPRBNetwork = class;

  TPRBParameters = class(TANNParam)
    private
     FTotErr : double;
     FMaxErr : double;
     FRo     : double;
     FDelta  : double;
     FAged   : boolean;
     FDecay  : double;
     FSpread : double;
     FDeadAge: double;
    public
     constructor Create(AOwner: TANN); override;
    private
     function  GetAveErr: double;
     procedure SetTotErr(vl: double);
     procedure SetAveErr(vl: double);
     procedure SetMaxErr(vl: double);
     procedure SetRo(vl: double);
     procedure SetDelta(vl: double);
     procedure SetAged(vl: boolean);
     procedure SetDecay(vl: double);
     procedure SetSpread(vl: double);
     procedure SetDeadAge(vl: double);
    published
     //Maximum Sum of Square allowed in Predicted output error during training
     property TotErr : double  read FTotErr   write SetTotErr;
     //Maximum Average Sum of Square allowed in Predicted output error during training
     property AveErr : double  read GetAveErr write SetAveErr;
     //Maximum error allowed in single element of Predicted output error during training
     property MaxErr : double  read FMaxErr   write SetMaxErr;
     //Modifier of gaussian radius
     property Ro     : double  read FRo       write SetRo;
     //Overlapping factor (0 - 1) (Default 1)
     property Delta  : double  read FDelta    write SetDelta;
     //Aged (default 0) set to non 0 to obtain Age updates of the neurons
     property Aged   : boolean read FAged     write SetAged;
     //Decay (default 0.01) decay constat of aux-neuron age
     property Decay  : double  read FDecay    write SetDecay;
     //Spread (defualt 1.0) Age-spread given to winner aux-neuron
     property Spread : double  read FSpread   write SetSpread;
     //DeadAge (default 0.0) Age under which the aux-neuron is killed
     property DeadAge: double  read FDeadAge  write SetDeadAge;
  end;

  (* Progressive Radial Basis Network *)
  TCustomPRBNetwork = class(TCustomRBNetwork)
    protected
     class procedure Supply(var Op: TNetOpers); override;
    public
     class function Description: string; override;
    private
     FParameters: TPRBParameters;
     FNumAux: integer;
     FKilled: longint;
     FPeak  : longint;
     FReduction: longint;
    private
     YC : TData;
     X  : TDMatrix;
     XtX: TDMatrix;
     XtY: TDMatrix;
    protected
     (* aux input *)
     AuxInp: TDMatrix;
     (* aux output *)
     AuxOut: TDMatrix;
     Lck: TIVector;
     Age: TDVector;
    private
     procedure SetParameters(Prm: TPRBParameters);
     //Computes radial basis function for all aux *)
     procedure RadBasM(VAL: TDMatrix; var Input: TDMatrix);
     //Computes radial basis function for the last row of aux
     procedure RadBasR(VAL: TDMatrix; var Input: TDMatrix);
     //Computes radial basis function for the last column of aux
     procedure RadBasC(VAL: TDMatrix; var Input: TDMatrix);
     (* Solves for B2 minimizing square of the error @br
      Solve X * B2 = Ym, where X is matrix of aux-inputs and Y matrix of aux-outputs
      as X, usally is not square, the equiation is solved in minimun square sense.
      Equation is solved using a GA=U decomposition and solving "outdim" times the
      equation U^-1 * X
     *)
     procedure SolvLin;
     //Updates ages of the neurons
     procedure UpdateAge(const ip: TData);
     //Adds the first neuron of the network
     procedure AddFirstNeuron(const ip, op: TData);
     //Adjusts weights of the second layer
     procedure AdjustWeights(const ip, op: TData);
     //Adds a new neuron into the network
     procedure AddNewNeuron(const ip: TData);
     procedure ReadDataNumAux(Reader: TReader);
     procedure WriteDataNumAux(Writer: TWriter);
     procedure ReadDataNetInfo(Reader: TReader);
     procedure WriteDataNetInfo(Writer: TWriter);
     procedure ReadDataAuxData(S: TStream);
     procedure WriteDataAuxData(S: TStream);
    protected
     procedure Loaded; override;
     procedure DefineProperties(Filer: TFiler); override;
    public
     constructor Create(AOwner: TComponent); override;
     procedure   Assign(Source: TPersistent); override;
     destructor  Destroy; override;
    public
     function    BeginLearning: boolean; override;
     //Returns true if Network fails to predict the target, so more learning is required
     function    NeedLearning(const ip, op: TData): boolean; virtual;
     (* Learns a pattern @br
      @param ip Input Pattern
      @param op Output Pattern
      Learn a new pattern with the following alghorithms: @br
      1. if SS(Predicted - RealOutput) lower then soil then Stop @br
      2. ReadjustWeights with then new Input/Output vector pair @br
      3. if SS(New Predicted - RealOutput) lower then soil then Stop @br
      4. Add New Neuron @br
      5. ReadjustWeights with then new Input/Output vector pair and with new neuron @br
     *)
     procedure   Learn(const ip, op: TData); override;
     procedure   EndLearning; override;
     procedure   Reset; override;
    public
     //Read only. Number of auxiliary neurons
     property NumAux: integer read FNumAux;
     //Read only. Number of new neurons not added as already present
     property Killed: longint read FKilled;
     //Read only. Number of neurons with minimun radius
     property Peak  : longint read FPeak;
     //Read only. Number of neurons with a radius reduction
     property Reduction: longint read FReduction;
     property Parameters: TPRBParameters read FParameters write SetParameters;
  end;

  TPRBNetwork = class(TCustomPRBNetwork)
    published
     property Options;
     property DimInp;
     property DimOut;
     property DataIn;
     property DataOut;
     property Parameters;
     property OnChange;
     property OnDataChange;
     property OnProgress;
     property OnPrepare;
     property OnBeginOper;
     property OnEndOper;
  end;

procedure Register;

implementation

constructor TPRBParameters.Create(AOwner: TANN);
begin
  inherited Create(AOwner);
  FAged   := false;
  FDecay  := 0.01;
  FSpread := 1.0;
  FDeadAge:= 0.0;
  FRo     := 1.201056;
  FDelta  := 1;
  FMaxErr := 1e30;
  FTotErr := 0.01;
end;

function  TPRBParameters.GetAveErr: double;
var
  od: integer;
begin
  od:= Owner.DimOut;
  if od > 0 then begin
    Result:= TotErr / od;
  end
  else begin
    Result:= -1;
  end;
end;

procedure TPRBParameters.SetAveErr(vl: double);
var
  od: integer;
begin
  od:= Owner.DimOut;
  if od > 0 then begin
    if vl < 0 then vl:= 0
    else vl:= vl * od;
    TotErr:= vl;
  end;
end;

procedure TPRBParameters.SetTotErr(vl: double);
begin
  if vl < 0 then vl:= 0.01;
  if vl <> FTotErr then begin
    FTotErr:= vl;
    Owner.Change;
  end;
end;

procedure TPRBParameters.SetMaxErr(vl: double);
begin
  if vl < 0 then vl:= 1e30;
  if vl <> FMaxErr then begin
    FMaxErr:= vl;
    Owner.Change;
  end;
end;

procedure TPRBParameters.SetRo(vl: double);
begin
  if vl < 0 then vl:= 1.201056;
  if vl <> FRo then begin
    FRo:= vl;
    Owner.Change;
  end;
end;

procedure TPRBParameters.SetDelta(vl: double);
begin
  if (vl < 0) then vl:= 0
  else if (vl>1) then vl:= 1;
  if vl <> FDelta then begin
    FDelta:= vl;
    Owner.Change;
  end;
end;

procedure TPRBParameters.SetAged(vl: boolean);
begin
  if vl <> FAged then begin
    FAged:= vl;
    Owner.Change;
  end;
end;

procedure TPRBParameters.SetDecay(vl: double);
begin
  if vl < 0 then vl:= 0.01; 
  if vl <> FDecay then begin
    FDecay:= vl;
    Owner.Change;
  end;
end;

procedure TPRBParameters.SetSpread(vl: double);
begin
  if vl < 0 then vl:= 1.0;
  if vl <> FSpread then begin
    FSpread:= vl;
    Owner.Change;
  end;
end;

procedure TPRBParameters.SetDeadAge(vl: double);
begin
  if vl < 0 then vl:= 0.0;
  if vl <> FDeadAge then begin
    FDeadAge:= vl;
    Owner.Change;
  end;
end;

class function TCustomPRBNetwork.Description;
begin
  Result:= 'Progressive Learning - Radial Basis Neural Network';
end;

constructor TCustomPRBNetwork.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetNetInfos([niSuper, niProgressive]);
  FParameters:= TPRBParameters.Create(Self);
  AuxInp:= TDMatrix.Create(Self); AuxInp.Name:= 'AuxInp';
  AuxOut:= TDMatrix.Create(Self); AuxOut.Name:= 'AuxOut';
  Lck   := TIVector.Create(Self); Lck.Name:= 'Lck'; Lck.RawMode:= false;
  Age   := TDVector.Create(Self); Age.Name:= 'Age';
  X     := TDMatrix.Create(Self); X.Name:= 'X';
  XtX   := TDMatrix.Create(Self); XtX.Name:= 'XtX';
  XtY   := TDMatrix.Create(Self); XtY.Name:= 'XtY';
  YC:= nil;
  Reset;
end;

procedure TCustomPRBNetwork.Assign(Source: TPersistent);
var
  N: TCustomPRBNetwork;
begin
  if Source is TCustomPRBNetwork then begin
    inherited Assign(source);
    N:= TCustomPRBNetwork(Source);
    Parameters:= N.Parameters;
    FNumAux:= N.NumAux;
    FKilled:= N.Killed;
    FPeak  := N.Peak;
    FReduction:= N.Reduction;
    X.Assign(N.X);
    XtX.Assign(N.XtX);
    XtY.Assign(N.XtY);
    AuxInp.Assign(N.AuxInp);
    AuxOut.Assign(N.AuxOut);
    Lck.Assign(N.Lck);
    Age.Assign(N.Age);
  end
  else inherited Assign(Source);
end;

procedure TCustomPRBNetwork.RadBasM(VAL: TDMatrix; var Input: TDMatrix);
var
  N, A, J: integer;
  DST: double;
begin
  for A:=1 to NumAux do begin
    for N:=1 to NumNeu do begin
      DST:= 0;
      for J:=1 to DimInp do begin
        DST:= DST + sqr(Cntr[N, J] - Input[A,J]);
      end;
      VAL[A,N+1]:= EXP(-DST*sqr(Bias[N]));
    end;
    VAL[A,1]:=1; (* X TERMINE COSTANTE (BIAS) *)
  end;
end;

procedure TCustomPRBNetwork.RadBasR(VAL: TDMatrix; var Input: TDMatrix);
var
  N, J: integer;
  DST: double;
begin
  for N:=1 to NumNeu do begin
    DST:= 0;
    for J:=1 to DimInp do begin
      DST:= DST + sqr(Cntr[N, J] - Input[NumAux,J]);
    end;
    VAL[NumAux,N+1]:= EXP(-DST*sqr(Bias[N]));
  end;
  VAL[NumAux,1]:=1; (* X TERMINE COSTANTE (BIAS) *)
end;

procedure TCustomPRBNetwork.RadBasC(VAL: TDMatrix; var Input: TDMatrix);
var
  A, J: integer;
  DST: double;
begin
  for A:=1 to NumAux-1 do begin
    DST:= 0;
    for J:=1 to DimInp do begin
      DST:= DST + sqr(Cntr[NumNeu, J] - Input[A,J]);
    end;
    VAL[A,NumNeu+1]:= EXP(-DST*sqr(Bias[NumNeu]));
  end;
  VAL[NumAux,NumNeu+1]:= EXP(0);
end;

procedure TCustomPRBNetwork.SolvLin;
var
  Det: double;
  Pvt: TIVector;
  Mat: TDMatrix;
  i: integer;
begin
  Pvt:= nil;
  Mat:= nil;
  Matrix.FactorGAU2(XtX, Mat, Pvt, Det);
  for i:= 0 to DimOut-1 do begin
    Matrix.MSolveGAU(Mat, Pvt, XtY, Weig, i);
  end;
  Pvt.Free;
  Mat.Free;
end;

procedure TCustomPRBNetwork.AddFirstNeuron(const ip, op: TData);
var
  i: integer;
begin
  (* first sample processing *)
  FNumNeu:= 1;
  FNumAux:= 1;
  AuxInp.Setup(1, NumAux, 1, DimInp);
  AuxOut.Setup(1, NumAux, 1, DimOut);
  Lck.Setup(1, NumAux);
  Age.Setup(1, NumAux);
  Cntr.Setup(1, NumNeu, 1, DimInp);
  Bias.Setup(1, NumNeu);
  Weig.Setup(1, NumNeu+1, 1, DimOut);
  RBVl.Setup(1, NumNeu+1);
  X.Setup(1, NumAux, 1, NumNeu+1);
  XtX.Setup(1, NumNeu+1, 1, NumNeu+1);
  XtY.Setup(1, NumNeu+1, 1, DimOut);
  Age[NumAux]:= Parameters.Spread;
  Lck[NumAux]:= 1;
  for I:=1 to DimInp do begin
    AuxInp[NumAux,I]:= ip[I-1];
  end;
  for I:=1 to DimOut do begin
    AuxOut[NumAux,I]:= op[I-1];
  end;
  for I:=1 to DimInp do begin
    Cntr[NumNeu,I]:= ip[I-1];
  end;
  Bias[NumNeu]:= 1/Parameters.Ro;
  for I:=1 to DimOut do begin
    Weig[NumNeu+1, I]:= op[I-1];
    Weig[1, I]:= 0;
  end;
  RadBasR(X, AuxInp);
  Matrix.MulXtX(XtX, X);
  Matrix.MulXtY(XtY, X, AuxOut);
end;

procedure TCustomPRBNetwork.AdjustWeights(const ip, op: TData);
var i: integer;
begin
  (* if the current error exceeds the assigned error
     the weights of the linear layer are computed
     and the sample is inserted in auxiliary samples list *)
  AuxInp.Realloc(NumAux+1, DimInp);
  AuxOut.Realloc(NumAux+1, DimOut);
  X.Realloc     (NumAux+1, NumNeu+1);
  Lck.Realloc   (NumAux+1);
  Age.Realloc   (NumAux+1);
  FNumAux:= FNumAux+1;
  Lck[NumAux]:= 0;
  Age[NumAux]:= Parameters.Spread;
  for I:=1 to DimInp do begin
    AuxInp[NumAux,I]:= ip[I-1];
  end;
  for I:=1 to DimOut do begin
    AuxOut[NumAux,I]:= op[I-1];
  end;
  RadBasR(X, AuxInp);
  (* versione incrementale di SMatMulXtY per aggiunta riga in X e Y *)
  Matrix.MulXtYNRR(XtY, X, AuxOut);
  (* versione incrementale di SMatMulXtX per aggiunta riga *)
  Matrix.MulXtXNR(XtX, X);
  SolvLin;
end;

procedure TCustomPRBNetwork.AddNewNeuron(const ip: TData);
var
  ps, i: integer;
  Dst, Min, ARo: double;
begin
  ARo:= Parameters.Ro; min:= 1e30; ps:= 0;
  for i:= 1 to NumNeu do begin
    Dst:= RBVl[i+1]; if Dst < Zero then continue;
    Dst:= sqrt(-(ln(RBVl[i+1])/sqr(Bias[i])));
    if dst < min then begin
      min:= dst;
      ps:= i;
    end;
  end;
  if min < Zero then begin
    (* Skip insertion of equal neuron *)
    inc(FKilled);
    exit;
  end
  else begin
    if ps <> 0 then begin
      Dst:= (1-Parameters.Delta)*(1/Bias[ps]+ARo);
      if Min < Dst then begin
        ARo:= Min/(1-Parameters.Delta)-1/Bias[ps];
        if ARo <= Parameters.Ro * 0.1 then begin
          ARo:= Parameters.Ro * 0.1;
          inc(FPeak);
        end
        else begin
          inc(FReduction);
        end;
      end;
    end;
  end;
  (* if the current error still exceeds the assigned error
   the sample is inserted as new hidden layer neuron
   and the weights of the linear layer are computed *)
  Cntr.Realloc(NumNeu+1, DimInp);
  Bias.Realloc(NumNeu+1);
  Weig.Realloc(NumNeu+2, DimOut);
  RBVl.Realloc(NumNeu+2);
  X.Realloc(NumAux, NumNeu+2);
  XtX.Realloc(NumNeu+2, NumNeu+2);
  XtY.Realloc(NumNeu+2, DimOut);
  FNumNeu:= FNumNeu+1;
  Lck[NumAux]:= 1;
  for I:=1 to DimInp do begin
    Cntr[NumNeu,I]:= ip[I-1];
  end;
  Bias[NumNeu]:= 1/ARo;
  RadBasC(X, AuxInp);
  (* versione incrementale di SMatMulXtY per aggiunta colonna a X *)
  Matrix.MulXtYNCx(XtY, X, AuxOut);
  Matrix.MulXtXNC(XtX, X);
  SolvLin;
end;

procedure TCustomPRBNetwork.UpdateAge(const ip: TData);
var
  A, J: integer;
  MinDst, DST: double;
  MinPos: integer;
  flg: boolean;
begin
  MinDst:= 10e30;
  MinPos:= -1;
  for A:=1 to NumAux do begin
    DST:= 0;
    for J:=1 to DimInp do begin
      DST:= DST + sqr(AuxInp[A, J] - ip[j-1]);
    end;
    if Dst < MinDst then begin
      MinDst:= Dst;
      MinPos:= A;
    end;
    Age[A]:= Age[A] - Parameters.Decay;
  end;
  Age[MinPos]:= Age[MinPos] + Parameters.Spread;
  A:= 1;
  flg:= false;
  while A<= NumAux do begin
    if (Age[A] <= Parameters.DeadAge) then begin
      if Lck[A] = 0 then begin
        if NumAux = 1 then exit;
        dec(FNumAux);
        for j:= 1 to DimInp do begin
          AuxInp[A, j]:= AuxInp[NumAux+1, j];
        end;
        AuxInp.Realloc(NumAux, DimInp);
        for j:= 1 to DimOut do begin
          AuxOut[A, j]:= AuxOut[NumAux+1, j];
        end;
        AuxOut.Realloc(NumAux, DimOut);
        Lck[A]:= Lck[NumAux+1];
        Age[A]:= Age[NumAux+1];
        Lck.Realloc(NumAux);
        Age.Realloc(NumAux);
        for j:= 1 to NumNeu+1 do begin
          X[A, j]:= X[NumAux+1, j];
        end;
        X.Realloc(NumAux, NumNeu+1);
        flg:= true;
      end
      else begin
        Age[A]:= Parameters.DeadAge;
        inc(A);
      end;
    end
    else begin
      inc(A);
    end;
  end;
  if flg then begin
    Matrix.MulXtX(XtX, X);
    Matrix.MulXtY(XtY, X, AuxOut);
    SolvLin;
  end;
end;

function TCustomPRBNetwork.BeginLearning: boolean;
begin
  Result:= inherited BeginLearning;
  SetLength(yc, DimOut);
  if YC = nil then raise EANNGeneric.Create(errOutOfMemory);
end;

procedure TCustomPRBNetwork.EndLearning;
begin
  inherited EndLearning;
end;

function TCustomPRBNetwork.NeedLearning(const ip, op: TData): boolean;
var
  SS, Mx: double;
begin
  Simul(ip, yc);
  SumSqrMax(DimOut, yc, op, SS, mx);
  NeedLearning:= (SS > Parameters.TotErr) or (Mx > Parameters.MaxErr);
end;

procedure TCustomPRBNetwork.Learn(const ip, op: TData); 
begin
  if (NumNeu = 0) then begin
    AddFirstNeuron(ip, op);
    Att.Add(1);
  end
  else begin
    (* computes the current approximation on the processed sample *)
    if NeedLearning(ip, op) then begin
      Att.Undo;
      AdjustWeights(ip, op);
      if NeedLearning(ip, op) then begin
        Att.Undo;
        AddNewNeuron(ip);
        Att.Add(1);
      end;
    end;
  end;
  if Parameters.Aged then UpdateAge(ip);
end;

procedure TCustomPRBNetwork.Reset;
begin
  inherited Reset;
  FNumAux:= 0;
  FKilled:= 0;
  FReduction:= 0;
  FPeak:= 0;
  if AuxInp <> nil then AuxInp.Setup(1, 0, 1, 0);
  if AuxOut <> nil then AuxOut.Setup(1, 0, 1, 0);
  if Lck    <> nil then Lck.Setup(1, 0);
  if Age    <> nil then Age.Setup(1, 0);
  if X      <> nil then X.Setup(1, 0, 1, 0);
  if XtX    <> nil then XtX.Setup(1, 0, 1, 0);
  if XtY    <> nil then XtY.Setup(1, 0, 1, 0);
end;

class procedure TCustomPRBNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noLearn];
  inherited Supply(Op);
end;

procedure TCustomPRBNetwork.SetParameters(Prm: TPRBParameters);
begin
  FParameters.Assign(Prm);
end;

procedure TCustomPRBNetwork.ReadDataNumAux(Reader: TReader);
begin
  FNumAux:= Reader.ReadInteger;
end;

procedure TCustomPRBNetwork.WriteDataNumAux(Writer: TWriter);
begin
  Writer.WriteInteger(FNumAux);
end;

procedure TCustomPRBNetwork.ReadDataNetInfo(Reader: TReader);
begin
  Reader.ReadListBegin;
  if not Reader.EndOfList then FKilled:= Reader.ReadInteger;
  if not Reader.EndOfList then FPeak  := Reader.ReadInteger;
  if not Reader.EndOfList then FReduction:= Reader.ReadInteger;
  Reader.ReadListEnd;
end;

procedure TCustomPRBNetwork.WriteDataNetInfo(Writer: TWriter);
begin
  Writer.WriteListBegin;
  Writer.WriteInteger(FKilled);
  Writer.WriteInteger(FPeak);
  Writer.WriteInteger(FReduction);
  Writer.WriteListEnd;
end;

procedure TCustomPRBNetwork.ReadDataAuxData(S: TStream);
begin
  AuxInp:= S.ReadComponent(AuxInp) as TDMatrix;
  AuxOut:= S.ReadComponent(AuxOut) as TDMatrix;
  Lck:= S.ReadComponent(Lck) as TIVector;
  Age:= S.ReadComponent(Age) as TDVector;
end;

procedure TCustomPRBNetwork.WriteDataAuxData(S: TStream);
begin
  S.WriteComponent(AuxInp);
  S.WriteComponent(AuxOut);
  S.WriteComponent(Lck);
  S.WriteComponent(Age);
end;

procedure TCustomPRBNetwork.Loaded;
begin
  inherited Loaded;
  X.Setup(1, NumAux, 1, NumNeu+1);
  XtX.Setup(1, NumNeu+1, 1, NumNeu+1);
  XtY.Setup(1, NumNeu+1, 1, DimOut);
  if NumNeu <> 0 then begin
    RadBasM(X, AuxInp);
    Matrix.MulXtX(XtX, X);
    Matrix.MulXtY(XtY, X, AuxOut);
  end;
end;

procedure TCustomPRBNetwork.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('NetInfo', ReadDataNetInfo, WriteDataNetInfo, (FKilled <> 0) or (FPeak<>0) or (FReduction<>0));
  Filer.DefineProperty('NumAux', ReadDataNumAux, WriteDataNumAux, NumAux<>0);
  Filer.DefineBinaryProperty('AuxData', ReadDataAuxData, WriteDataAuxData, NumAux<>0);
end;

destructor TCustomPRBNetwork.Destroy;
begin
  FParameters.Free;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('Eic', [TPRBNetwork]);
end;

initialization
  RegisterClass(TPRBNetwork);
end.

