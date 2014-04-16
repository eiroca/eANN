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
@created 04/11/1996
@lastmod 05/05/1999

Artificial Radial Basis Neural Network @br
@br
This is an implementation of Radial Basis neural network @br
@br
History: @br
 1.00 First version @br
 2.01 Sync with new ANN 2.01 @br
@br
@todo Improves matrix inversion


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
unit eANNRB;

interface

uses
  System.Classes, System.SysUtils,
  eANNCore,
  eDataPick,
  eLibCore, eLibMath, eLibStat;

type

  //Radial Basis Nerural Network
  TGenericRBNetwork = class(TANN)
    protected
     class procedure Supply(var Op: TNetOpers); override;
    public
     class function Description: string; override;
    private
     FAtt   : TActivityLogger;
     FNumNeu: integer;
    protected
    protected
     procedure SetAtt(Prm: TStatistic);
    public
     procedure Assign(Source: TPersistent); override;
    public
     constructor Create(AOwner: TComponent); override;
     destructor  Destroy; override;
    public
     procedure   Simul(const ip: TData; var op: TData); override;
     procedure   Reset; override;
     procedure   RecalcActivation; virtual;
     //Computes radial basis form input vector and neurons
     function  RadBas(const ip: TData): double;
    published
     property Activity: TActivityLogger read FAtt;
     //Number of neurons
     property NumNeu: integer read FNumNeu write FNumNeu;
    published
     Cntr: TDMatrix;
     //Bias of the first layer
     Bias: TDVector;
     //Value of the computed Radial Basis function for a input vector
     RBVl: TDVector;
     Weig: TDMatrix;
  end;

const
  defMaxErr  = 0.02;
  defMaxNeu  = 1;
  defRo      = 1.201056;
  defDelta   = 1;
  defAged    = false;
  defDecay   = 0.01;
  defSpread  = 1.0;
  defDeadAge = 0.0;
  defMaxErrElem = 1e30;
  defTotErr  = 0.01;

type
  TRBParameters = class(TStorable)
    private
     FMaxErr: double;
     FMaxNeu: integer;
     FRo    : double;
    protected
     procedure SetMaxErr(vl: double);
     procedure SetMaxNeu(vl: integer);
     procedure SetRo(vl: double);
    public
     constructor Create(AOwner: TComponent); override;
    public
     (* Deep copy of the network *)
     procedure   Assign(Source: TPersistent); override;
    published
     //Maximum error allowed in single element of Predicted output error during training
     property MaxErr: double
       read FMaxErr
       write SetMaxErr;
     //Maximum number of neurons, -1 to put as many neurons as precision needs
     property MaxNeu: integer
       read FMaxNeu
       write SetMaxNeu;
     //Modifier of gaussian radius
     property Ro    : double
       read FRo
       write SetRo;
  end;

type
  //Radial Basis Nerural Network - Chen Learning Alg.
  TRBNetwork = class(TGenericRBNetwork)
    protected
     class procedure Supply(var Op: TNetOpers); override;
    public
     class function Description: string; override;
    private
     FParameters: TRBParameters;
    protected
     procedure   SetParameters(vl: TRBParameters);
     //Solves minimizing square of the error
     procedure   SolvLin(X, Y: TDMatrix);
    public
     constructor Create(AOwner: TComponent); override;
     procedure   Assign(Source: TPersistent); override;
     procedure   Train; override;
     destructor  Destroy; override;
    published
     property Parameters: TRBParameters
       read FParameters
       write SetParameters
       stored true;
   end;

type
  TPRBParameters = class(TStorable)
    private
     FRo     : double;
     FDelta  : double;
     FAged   : boolean;
     FDecay  : double;
     FSpread : double;
     FDeadAge: double;
     FTotErr : double;
     FMaxErr : double;
    protected
     procedure SetRo(vl: double);
     procedure SetDelta(vl: double);
     procedure SetDecay(vl: double);
     procedure SetSpread(vl: double);
     procedure SetDeadAge(vl: double);
     procedure SetTotErr(vl: double);
     procedure SetMaxErr(vl: double);
    public
     constructor Create(AOwner: TComponent); override;
    public
     (* Deep copy of the network *)
     procedure   Assign(Source: TPersistent); override;
    published
     //Modifier of gaussian radius
     property Ro     : double
       read FRo
       write SetRo;
     //Overlapping factor (0 - 1) (Default 1)
     property Delta  : double
       read FDelta
       write SetDelta;
     //Aged (default 0) set to non 0 to obtain Age updates of the neurons
     property Aged   : boolean
       read FAged
       write FAged;
     //Decay (default 0.01) decay constat of aux-neuron age
     property Decay  : double
       read FDecay
       write SetDecay;
     //Spread (defualt 1.0) Age-spread given to winner aux-neuron
     property Spread : double
       read FSpread
       write SetSpread;
     //DeadAge (default 0.0) Age under which the aux-neuron is killed
     property DeadAge: double
       read FDeadAge
       write SetDeadAge;
     //Maximum Sum of Square allowed in Predicted output error during training
     property TotErr : double
       read FTotErr
       write SetTotErr;
     //Maximum error allowed in single element of Predicted output error during training
     property MaxErr : double
       read FMaxErr
       write SetMaxErr;
  end;

type
  (* Progressive Radial Basis Network *)
  TPRBNetwork = class(TGenericRBNetwork)
    protected
     class procedure Supply(var Op: TNetOpers); override;
    public
     class function Description: string; override;
    private
     FParameters: TPRBParameters;
     FNumAux: integer;
     FKilled: integer;
     FPeak  : integer;
     FReduction: integer;
    private
     YC : TData;
     X  : TDMatrix;
     XtX: TDMatrix;
     XtY: TDMatrix;
    protected
     procedure SetParameters(vl: TPRBParameters);
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
    protected
     procedure Loaded; override;
    public
     constructor Create(AOwner: TComponent); override;
     destructor  Destroy; override;
    public
     procedure   Assign(Source: TPersistent); override;
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
    published
     (* aux input *)
     AuxInp: TDMatrix;
     (* aux output *)
     AuxOut: TDMatrix;
     Lck: TIVector;
     Age: TDVector;
    published
     property Parameters: TPRBParameters
       read FParameters
       write SetParameters
       stored true;
    published
     //Read only. Number of auxiliary neurons
     property NumAux: integer
       read FNumAux
       write FNumAux;
     //Read only. Number of new neurons not added as already present
     property Killed: integer
       read FKilled
       write FKilled;
     //Read only. Number of neurons with minimun radius
     property Peak  : integer
       read FPeak
       write FPeak;
     //Read only. Number of neurons with a radius reduction
     property Reduction: integer
       read FReduction
       write FReduction;
  end;

implementation

//--------------------------------------------------------------------------------------------------
class procedure TGenericRBNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noSimul, noReset];
  inherited;
end;

class function TGenericRBNetwork.Description;
begin
  Result:= 'Abstract Radial Basis Neural Network';
end;

constructor TGenericRBNetwork.Create(AOwner: TComponent);
begin
  inherited;
  SetNetInfos([niSuper]);
  FAtt:= TActivityLogger.Create(nil);
  Cntr:= TDMatrix.Create(nil); Cntr.Name:='Cntr';
  Bias:= TDVector.Create(nil); Bias.Name:='Bias';
  Weig:= TDMatrix.Create(nil); Weig.Name:='Weig';
  RBVl:= TDVector.Create(nil); RBVl.Name:='RBVl';
  Reset;
end;

destructor TGenericRBNetwork.Destroy;
begin
  Cntr.Free;
  Bias.Free;
  Weig.Free;
  RBVl.Free;
  Activity.Free;
  inherited;
end;

procedure TGenericRBNetwork.Assign(Source: TPersistent);
var
  N: TGenericRBNetwork;
begin
  if Source is TGenericRBNetwork then begin
    inherited;
    N:= TGenericRBNetwork(Source);
    Cntr.Assign(N.Cntr);
    Bias.Assign(N.Bias);
    RBVl.Assign(N.RBVl);
    Weig.Assign(N.Weig);
    FAtt.Assign(N.FAtt);
    FNumNeu:= N.NumNeu;
  end
  else inherited;
end;

procedure TGenericRBNetwork.SetAtt(Prm: TStatistic);
begin
  FAtt.Assign(Prm);
end;

function TGenericRBNetwork.RadBas(const ip: TData): double;
var
  N, J: integer;
  tmp, DST: double;
begin
  Result:= 0;
  for N:=1 to NumNeu do begin
    DST:= 0;
    for J:=1 to DimInp do begin
      DST:= DST + sqr((Cntr[N, J] - ip[J-1]));
    end;
    tmp:= EXP(-DST*sqr(Bias[N]));
    RBVl[N+1]:= tmp;
    Result:= Result + tmp;
  end;
  RBVl[1]:=1; (* X TERMINE COSTANTE (BIAS) *)
end;

procedure TGenericRBNetwork.Simul(const ip: TData; var op: TData);
var
  I, K: integer;
  Sum: double;
begin
  Activity.Add(RadBas(ip));
  for I:=1 to DimOut do begin
    Sum:= 0;
    for K:=1 to NumNeu+1 do begin
      Sum:= Sum + Weig[K,I] * RBVl[K];
    end;
    op[I-1]:= Sum;
  end;
end;

procedure TGenericRBNetwork.Reset;
begin
  inherited;
  Activity.Reset;
  FNumNeu:= 0;
  if Cntr <> nil then Cntr.Setup(1, 0, 1, 0);
  if Bias <> nil then Bias.Setup(1, 0);
  if Weig <> nil then Weig.Setup(1, 0, 1, 0);
  if RBVl <> nil then RBVl.Setup(1, 0);
end;

procedure TGenericRBNetwork.RecalcActivation;
var
  i : integer;
  YC: TData;
begin
  Activity.Reset;
  if not Prepare(noApply) then exit;
  SetLength(yc, DimOut);
  if YC = nil then raise EANNGeneric.Create(errOutOfMemory);
  for i:= 0 to DataIn.Count-1 do Simul(DataIn[i], YC);
end;

//--------------------------------------------------------------------------------------------------
constructor TRBParameters.Create(AOwner: TComponent);
begin
  inherited;
  FMaxErr:= defMaxErr;
  FMaxNeu:= defMaxNeu;
  FRo    := defRo;
end;

procedure TRBParameters.Assign(Source: TPersistent);
var
  P: TRBParameters;
begin
  if Source is TRBParameters then begin
    P:= TRBParameters(Source);
    MaxErr:= P.MaxErr;
    MaxNeu:= P.MaxNeu;
    Ro    := P.Ro;
  end
  else inherited;
end;

procedure TRBParameters.SetMaxErr(vl: double);
begin
  if vl < 0 then vl:= defMaxErr;
  FMaxErr:= vl;
end;

procedure TRBParameters.SetMaxNeu(vl: integer);
begin
  if vl < 1 then vl:= defMaxNeu;
  FMaxNeu:= vl;
end;

procedure TRBParameters.SetRo(vl: double);
begin
  if vl < 0 then vl:= defRo;
  FRo:= vl;
end;

//--------------------------------------------------------------------------------------------------
class function TRBNetwork.Description;
begin
  Result:= 'Radial Basis Neural Network (Chen training)';
end;

class procedure TRBNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noTrain];
  inherited;
end;

constructor TRBNetwork.Create(AOwner: TComponent);
begin
  inherited;
  FParameters:= TRBParameters.Create(nil);
end;

destructor TRBNetwork.Destroy;
begin
  FParameters.Free;
  inherited;
end;

procedure TRBNetwork.Assign(Source: TPersistent);
var
  N: TRBNetwork;
begin
  if Source is TRBNetwork then begin
    inherited;
    N:= TRBNetwork(Source);
    Parameters:= N.Parameters;
  end
  else inherited;
end;

procedure TRBNetwork.SetParameters(vl: TRBParameters);
begin
  FParameters.Assign(vl);
end;

procedure TRBNetwork.Train;
var
  kk, od, r, i, j, k: integer;
  W, mP: TDMatrix;
  wk: TDVector;
  Used: TIVector;
  ps: integer;
  err, dd, wkwk, tmp, d, Alp, te, me: double;
  X, Y: TDMatrix;
  flg: boolean;
  NeuMax: integer;
  np: integer;
  procedure CalcMP(var mP: TDMatrix);
  var
    i, j, k: integer;
    tmp, dst: double;
    P1, P2: TData;
  begin
    np:= DataIn.Count;
    mP:= TDMatrix.Create(nil);
    mP.Setup(1, np, 1, np);
    if mp = nil then exit;
    for i:= 1 to np do begin
      mP[i,i]:= 1;
      for j:= i+1 to np do begin
        dst:= 0;
        P1:= DataIn[i-1];
        P2:= DataIn[j-1];
        for K:= 0 to DimInp-1 do begin
          DST:= DST + sqr(P1[K] - P2[K]);
        end;
        tmp:= EXP(-DST/sqr(Parameters.Ro));
        mP[i,j]:= tmp;
        mP[j,i]:= tmp;
      end;
    end;
  end;
begin
  if not Prepare(noTrain) then exit;
  np:= DataIn.Count;
  if Parameters.MaxNeu < 1 then NeuMax:= np
  else NeuMax:= Parameters.MaxNeu;
  ProgressInit((NeuMax+1)*Options.ProgressStep);
  CalcMP(mp);
  W   := TDMatrix.Create(nil); W.Setup(1, np, 1, NeuMax);
  wk  := TDVector.Create(nil); wk.Setup(1, np);
  Used:= TIVector.Create(nil); Used.Setup(1, NeuMax);
  if (mP=nil) or (W=nil) or (wk=nil) or (Used=nil) then begin
    raise EANNError.create(errOutOfMemory);
    mP.Free;
    W.Free;
    wk.Free;
    Used.Free;
    exit;
  end;
  for i:= 1 to NeuMax do begin
    Used[i]:= 0;
  end;
  te:= 1;
  FNumNeu:= NeuMax;
  kk:= 1;
  for k:= 1 to NeuMax do begin
    ps:= -1;
    me:= 0;
    DoProgressStep;
    for i:= 1 to np do begin
      flg:= false;
      for r:= 1 to kk-1 do begin
        if Used[r] = i then begin
          flg:= true;
          break;
        end;
      end;
      if flg then continue;
      for r:= 1 to np do begin
        wk[r]:= mP[r, i];
      end;
      for j:= 1 to kk-1 do begin
        Alp:= 0;
        for r:= 1 to np do begin
          Alp:= Alp + W[r, j] * mP[r, i];
        end;
        tmp:= 0;
        for r:= 1 to np do begin
          tmp:= tmp + sqr(W[r, j]);
        end;
        Alp:= Alp / tmp;
        for r:= 1 to np do begin
          wk[r]:= wk[r] - Alp * W[r, j];
        end;
      end;
      wkwk:= 0;
      for r:= 1 to np do begin
        wkwk:= wkwk + sqr(wk[r]);
      end;
      od:= 1;
      dd:= 0;
      tmp:= 0;
      for r:= 1 to np do begin
        d:= DataOut[r-1][od-1];
        dd:= dd + sqr(d);
        tmp:= tmp + wk[r] * d;
      end;
      if wkwk > 1e-30 then begin
        err:= sqr(tmp) / (dd*wkwk);
        if err > me then begin
          me:= err;
          ps:= i;
          for r:= 1 to np do begin
            W[r, kk]:= wk[r];
          end;
        end;
      end;
    end;
    if ps > -1 then begin
      Used[kk]:= ps;
      te:= te - me;
      if te < -0.0001 then begin
        exit;
      end;
      if te < Parameters.MaxErr then begin
        FNumNeu:= kk;
        break;
      end;
    end
    else begin
      FNumNeu:= kk;
      break;
    end;
    inc(kk);
  end;
  DoProgressStep;
  ProgressDone;
  W.Free;
  wk.Free;
  Cntr.Setup(1, NumNeu, 1, DimInp);
  Bias.Setup(1, NumNeu);
  Weig.Setup(1, NumNeu+1, 1, DimOut);
  RBVl.Setup(1, NumNeu+1);
  X     := TDMatrix.Create(nil); X.Setup(1, NP, 1, NumNeu+1);
  Y     := TDMatrix.Create(nil); Y.Setup(1, NP, 1, DimOut);
  for i:= 1 to NumNeu do begin
    Bias[i]:= 1/Parameters.Ro;
    for r:= 1 to DimInp do begin
      Cntr[i, r]:= DataIn[Used[i]-1][r-1];
    end;
  end;
  for i:= 1 to NP do begin
    Activity.Add(RadBas(Datain[i-1]));
    for r:= 1 to NumNeu+1 do begin
      X[i, r]:= RBVl[r];
    end;
    for r:= 1 to DimOut do begin
      Y[i, r]:= DataOut[i-1][r-1];
    end;
  end;
  SolvLin(X, Y);
  Used.Free;
  X.Free;
  Y.Free;
  mP.Free;
  Trained:= true;
end;

procedure TRBNetwork.SolvLin(X, Y: TDMatrix);
var
  Det: double;
  Pvt: TIVector;
  Mat: TDMatrix;
  i: integer;
  XtX: TDMatrix;
  XtY: TDMatrix;
begin
  Pvt:= nil;
  Mat:= nil;
  XtX:= TDMatrix.Create(nil); XtX.Setup(1, X.ColCnt, 1, X.ColCnt);
  XtY:= TDMatrix.Create(nil); XtY.Setup(1, X.ColCnt, 1, Y.ColCnt);
  Matrix.MulXtX(XtX, X);
  Matrix.MulXtY(XtY, X, Y);
  Matrix.FactorGAU2(XtX, Mat, Pvt, Det);
  for i:= 0 to DimOut-1 do begin
    Matrix.MSolveGAU(Mat, Pvt, XtY, Weig, i);
  end;
  XtX.Free;
  XtY.Free;
  Pvt.Free;
  Mat.Free;
end;

//--------------------------------------------------------------------------------------------------
constructor TPRBParameters.Create(AOwner: TComponent);
begin
  inherited;
  FRo     := defRo;
  FDelta  := defDelta;
  FAged   := defAged;
  FDecay  := defDecay;
  FSpread := defSpread;
  FDeadAge:= defDeadAge;
  FMaxErr := defMaxErrElem;
  FTotErr := defTotErr;
end;

procedure TPRBParameters.Assign(Source: TPersistent);
var
  P: TPRBParameters;
begin
  if Source is TPRBParameters then begin
    P:= TPRBParameters(Source);
    Ro     := P.Ro;
    Delta  := P.Delta;
    Aged   := P.Aged;
    Decay  := P.Decay;
    Spread := P.Spread;
    DeadAge:= P.DeadAge;
    MaxErr := P.MaxErr;
    TotErr := P.TotErr;
  end
  else inherited;
end;

procedure TPRBParameters.SetRo(vl: double);
begin
  if vl < 0 then vl:= defRo;
  FRo:= vl;
end;

procedure TPRBParameters.SetDelta(vl: double);
begin
  if (vl < 0) then vl:= defDelta
  else if (vl>1) then vl:= defDelta;
  FDelta:= vl;
end;

procedure TPRBParameters.SetDecay(vl: double);
begin
  if vl < 0 then vl:= defDecay;
  FDecay:= vl;
end;

procedure TPRBParameters.SetSpread(vl: double);
begin
  if vl < 0 then vl:= defSpread;
  FSpread:= vl;
end;

procedure TPRBParameters.SetDeadAge(vl: double);
begin
  if vl < 0 then vl:= defDeadAge;
  FDeadAge:= vl;
end;

procedure TPRBParameters.SetTotErr(vl: double);
begin
  if vl < 0 then vl:= defTotErr;
  FTotErr:= vl;
end;

procedure TPRBParameters.SetMaxErr(vl: double);
begin
  if vl < 0 then vl:= defMaxErrElem;
  FMaxErr:= vl;
end;

//--------------------------------------------------------------------------------------------------
class procedure TPRBNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noLearn];
  inherited;
end;

class function TPRBNetwork.Description;
begin
  Result:= 'Progressive Learning - Radial Basis Neural Network';
end;

constructor TPRBNetwork.Create(AOwner: TComponent);
begin
  inherited;
  SetNetInfos([niSuper, niProgressive]);
  FParameters:= TPRBParameters.Create(nil);
  AuxInp:= TDMatrix.Create(nil);  AuxInp.Name:= 'AuxInp';
  AuxOut:= TDMatrix.Create(nil);  AuxOut.Name:= 'AuxOut';
  Lck   := TIVector.Create(nil);  Lck.Name:= 'Lck';       Lck.RawMode:= false;
  Age   := TDVector.Create(nil);  Age.Name:= 'Age';
  X     := TDMatrix.Create(nil);  X.Name:= 'X';
  XtX   := TDMatrix.Create(nil);  XtX.Name:= 'XtX';
  XtY   := TDMatrix.Create(nil);  XtY.Name:= 'XtY';
  YC:= nil;
  Reset;
end;

destructor TPRBNetwork.Destroy;
begin
  FParameters.Free;
  AuxInp.Free;
  AuxOut.Free;
  Lck.Free;
  Age.Free;
  X.Free;
  XtX.Free;
  XtY.Free;
  inherited;
end;

procedure TPRBNetwork.Assign(Source: TPersistent);
var
  N: TPRBNetwork;
begin
  if Source is TPRBNetwork then begin
    inherited;
    N:= TPRBNetwork(Source);
    Parameters:= N.Parameters;
    FNumAux:= N.NumAux;
    FKilled:= N.Killed;
    FPeak  := N.Peak;
    FReduction:= N.Reduction;
    AuxInp.Assign(N.AuxInp);
    AuxOut.Assign(N.AuxOut);
    Lck.Assign(N.Lck);
    Age.Assign(N.Age);
    X.Assign(N.X);
    XtX.Assign(N.XtX);
    XtY.Assign(N.XtY);
  end
  else inherited;
end;

procedure TPRBNetwork.SetParameters(vl: TPRBParameters);
begin
  FParameters.Assign(vl);
end;

procedure TPRBNetwork.RadBasM(VAL: TDMatrix; var Input: TDMatrix);
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

procedure TPRBNetwork.RadBasR(VAL: TDMatrix; var Input: TDMatrix);
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

procedure TPRBNetwork.RadBasC(VAL: TDMatrix; var Input: TDMatrix);
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

procedure TPRBNetwork.SolvLin;
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

procedure TPRBNetwork.AddFirstNeuron(const ip, op: TData);
var
  i: integer;
begin
  (* first sample processing *)
  NumNeu:= 1;
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

procedure TPRBNetwork.AdjustWeights(const ip, op: TData);
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

procedure TPRBNetwork.AddNewNeuron(const ip: TData);
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
  NumNeu:= NumNeu+1;
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

procedure TPRBNetwork.UpdateAge(const ip: TData);
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

function TPRBNetwork.BeginLearning: boolean;
begin
  Result:= inherited;
  SetLength(yc, DimOut);
  if YC = nil then raise EANNGeneric.Create(errOutOfMemory);
end;

procedure TPRBNetwork.EndLearning;
begin
  inherited;
end;

function TPRBNetwork.NeedLearning(const ip, op: TData): boolean;
var
  SS, Mx: double;
begin
  Simul(ip, yc);
  SumSqrMax(DimOut, yc, op, SS, mx);
  NeedLearning:= (SS > Parameters.TotErr) or (Mx > Parameters.MaxErr);
end;

procedure TPRBNetwork.Learn(const ip, op: TData);
begin
  if (NumNeu = 0) then begin
    AddFirstNeuron(ip, op);
    Activity.Add(1);
  end
  else begin
    (* computes the current approximation on the processed sample *)
    if NeedLearning(ip, op) then begin
      Activity.Undo;
      AdjustWeights(ip, op);
      if NeedLearning(ip, op) then begin
        Activity.Undo;
        AddNewNeuron(ip);
        Activity.Add(1);
      end;
    end;
  end;
  if Parameters.Aged then UpdateAge(ip);
end;

procedure TPRBNetwork.Reset;
begin
  inherited;
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

procedure TPRBNetwork.Loaded;
begin
  inherited;
  X.Setup(1, NumAux, 1, NumNeu+1);
  XtX.Setup(1, NumNeu+1, 1, NumNeu+1);
  XtY.Setup(1, NumNeu+1, 1, DimOut);
  if NumNeu <> 0 then begin
    RadBasM(X, AuxInp);
    Matrix.MulXtX(XtX, X);
    Matrix.MulXtY(XtY, X, AuxOut);
  end;
end;

//--------------------------------------------------------------------------------------------------
initialization
  RegisterClasses([TGenericRBNetwork, TRBParameters, TRBNetwork, TPRBNetwork]);
end.

