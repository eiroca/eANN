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

Artificial Radia Basis Neural Network @br
@br
This is an implementation of Radial Basis neural network @br
@br
History: @br
 1.00 First version @br
 2.01 Sync with new ANN 2.01 @br
@br
@todo Improves matrix inversion
*)
unit eANNRB;

interface

uses
  Classes, eAnn, eAnnUtil, eANNMsg, eDataPick, eLibMath, SysUtils;

type

  TCustomRBNetwork = class;

  TRBParameters = class(TANNParam)
    private
     FMaxErr: double;
     FMaxNeu: integer;
     FRo    : double;
    public
     constructor Create(AOwner: TANN); override;
    private
     procedure SetMaxErr(vl: double);
     procedure SetMaxNeu(vl: integer);
     procedure SetRo(vl: double);
    published
     //Maximum error allowed in single element of Predicted output error during training
     property MaxErr: double  read FMaxErr write SetMaxErr;
     //Maximum number of neurons, -1 to put as many neurons as precision needs
     property MaxNeu: integer read FMaxNeu write SetMaxNeu;
     //Modifier of gaussian radius
     property Ro    : double  read FRo     write SetRo;
  end;

  //Radial Basis Nerural Network
  TCustomRBNetwork = class(TANN)
     Cntr: TDMatrix;
     //Bias of the first layer
     Bias: TDVector;
     //Value of the computed Radial Basis function for a input vector
     RBVl: TDVector;
     Weig: TDMatrix;
    protected
     class procedure Supply(var Op: TNetOpers); override;
    public
     class function Description: string; override;
    private
     FAtt   : TActivityLogger;
    protected
     FNumNeu: integer;
    protected
    protected
     procedure SetAtt(Prm: TActivityLogger);
    public
     //Read only. Number of neurons
     property NumNeu: integer read FNumNeu;
     property Att: TActivityLogger read FAtt;
    private
     procedure ReadDataNumNeu(Reader: TReader);
     procedure WriteDataNumNeu(Writer: TWriter);
     procedure ReadDataWeights(S: TStream);
     procedure WriteDataWeights(S: TStream);
    protected
     procedure DefineProperties(Filer: TFiler); override;
    public
     constructor Create(AOwner: TComponent); override;
     procedure   Assign(Source: TPersistent); override;
     procedure   Simul(const ip: TData; var op: TData); override;
     procedure   Reset; override;
     destructor  Destroy; override;
    public
     procedure RecalcActivation; virtual;
     //Computes radial basis form input vector and neurons
     function  RadBas(const ip: TData): double;
  end;

  //Radial Basis Nerural Network - Chen Learning Alg.
  TChenRBNetwork = class(TCustomRBNetwork)
    protected
     class procedure Supply(var Op: TNetOpers); override;
    public
     class function Description: string; override;
    private
     FParameters: TRBParameters;
    private
     procedure SetParameters(Prm: TRBParameters);
    public
     property Parameters: TRBParameters read FParameters write SetParameters;
    public
     constructor Create(AOwner: TComponent); override;
     procedure   Assign(Source: TPersistent); override;
     procedure   Train; override;
     destructor  Destroy; override;
    private
     //Solves minimizing square of the error 
     procedure   SolvLin(X, Y: TDMatrix);
   end;

  TRBNetwork = class(TChenRBNetwork)
    published
     property Options;
     property DimInp;
     property DimOut;
     property DataIn;
     property DataOut;
     property OnChange;
     property OnDataChange;
     property OnProgress;
     property OnPrepare;
     property OnBeginOper;
     property OnEndOper;
     property Parameters;
  end;

procedure Register;

implementation

constructor TRBParameters.Create(AOwner: TANN);
begin
  inherited Create(AOwner);
  FMaxErr:= 0.02;
  FMaxNeu:= 0;
  FRo    := 1.201056;
end;

procedure TRBParameters.SetMaxErr(vl: double);
begin
  if vl < 0 then vl:= 0.02;
  if FMaxErr <> vl then begin
    FMaxErr:= vl;
    Owner.Change;
  end;
end;

procedure TRBParameters.SetMaxNeu(vl: integer);
begin
  if vl < 1 then vl:= 0;
  if FMaxNeu <> vl then begin
    FMaxNeu:= vl;
    Owner.Change;
  end;
end;

procedure TRBParameters.SetRo(vl: double);
begin
  if vl < 0 then vl:= 1.201056;
  if FRo <> vl then begin
    FRo:= vl;
    Owner.Change;
  end;
end;

constructor TCustomRBNetwork.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetNetInfos([niSuper]);
  FAtt:= TActivityLogger.Create;
  Cntr:= TDMatrix.Create(self); Cntr.Name:='Cntr';
  Bias:= TDVector.Create(Self); Bias.Name:='Bias';
  Weig:= TDMatrix.Create(Self); Weig.Name:='Weig';
  RBVl:= TDVector.Create(Self); RBVl.Name:='RBVl';
  Reset;
end;

procedure TCustomRBNetwork.Assign(Source: TPersistent);
var
  N: TCustomRBNetwork;
begin
  if Source is TCustomRBNetwork then begin
    N:= TCustomRBNetwork(Source);
    Cntr.Assign(N.Cntr);
    Bias.Assign(N.Bias);
    RBVl.Assign(N.RBVl);
    Weig.Assign(N.Weig);
    FAtt.Assign(N.FAtt);
    FNumNeu:= N.NumNeu;
  end
  else inherited Assign(Source);
end;

class function TCustomRBNetwork.Description;
begin
  Result:= 'Abstract Radial Basis Neural Network';
end;

procedure TCustomRBNetwork.SetAtt(Prm: TActivityLogger);
begin
  FAtt.Assign(Prm);
end;

procedure TCustomRBNetwork.ReadDataNumNeu(Reader: TReader);
begin
  FNumNeu:= Reader.ReadInteger;
end;

procedure TCustomRBNetwork.WriteDataNumNeu(Writer: TWriter);
begin
  Writer.WriteInteger(FNumNeu);
end;

procedure TCustomRBNetwork.ReadDataWeights(S: TStream);
begin
  Cntr:= S.ReadComponent(Cntr) as TDMatrix;
  Bias:= S.ReadComponent(Bias) as TDVector;
  Weig:= S.ReadComponent(Weig) as TDMatrix;
  RBVl:= S.ReadComponent(RBVl) as TDVector;
end;

procedure TCustomRBNetwork.WriteDataWeights(S: TStream);
begin
  S.WriteComponent(Cntr);
  S.WriteComponent(Bias);
  S.WriteComponent(Weig);
  S.WriteComponent(RBVl);
end;

procedure TCustomRBNetwork.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Neurons', ReadDataNumNeu, WriteDataNumNeu, NumNeu<>0);
  Filer.DefineBinaryProperty('Weights', ReadDataWeights, WriteDataWeights, NumNeu<>0);
  FAtt.DefineProperties(Filer);
end;

function TCustomRBNetwork.RadBas(const ip: TData): double;
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

procedure TCustomRBNetwork.Simul(const ip: TData; var op: TData);
var
  I, K: integer;
  Sum: double;
begin
  Att.Add(RadBas(ip));
  for I:=1 to DimOut do begin
    Sum:= 0;
    for K:=1 to NumNeu+1 do begin
      Sum:= Sum + Weig[K,I] * RBVl[K];
    end;
    op[I-1]:= Sum;
  end;
end;

procedure TCustomRBNetwork.Reset;
begin
  inherited;
  Att.Reset;
  FNumNeu:= 0;
  if Cntr <> nil then Cntr.Setup(1, 0, 1, 0);
  if Bias <> nil then Bias.Setup(1, 0);
  if Weig <> nil then Weig.Setup(1, 0, 1, 0);
  if RBVl <> nil then RBVl.Setup(1, 0);
end;

procedure TCustomRBNetwork.RecalcActivation;
var
  i : integer;
  YC: TData;
begin
  Att.Reset;
  if not Prepare(noApply) then exit;
  SetLength(yc, DimOut);
  if YC = nil then raise EANNGeneric.Create(errOutOfMemory);
  for i:= 0 to DataIn.Count-1 do Simul(DataIn[i], YC);
end;

class procedure TCustomRBNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noSimul, noReset];
  inherited Supply(Op);
end;

destructor TCustomRBNetwork.Destroy;
begin
  Att.Free;
  inherited Destroy;
end;

class function TChenRBNetwork.Description;
begin
  Result:= 'Radial Basis Neural Network (Chen training)';
end;

constructor TChenRBNetwork.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParameters:= TRBParameters.Create(Self);
end;

procedure TChenRBNetwork.Assign(Source: TPersistent);
var
  N: TChenRBNetwork;
begin
  if Source is TChenRBNetwork then begin
    inherited Assign(source);
    N:= TChenRBNetwork(Source);
    Parameters:= N.Parameters;
  end
  else inherited Assign(Source);
end;

procedure TChenRBNetwork.Train;
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
    ProgressStep;
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
  ProgressStep;
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
    Att.Add(RadBas(Datain[i-1]));
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
  SetNetInfos(NetInfos + [niTrained]);
end;

procedure TChenRBNetwork.SolvLin(X, Y: TDMatrix);
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

class procedure TChenRBNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noTrain];
  inherited Supply(Op);
end;

procedure TChenRBNetwork.SetParameters(Prm: TRBParameters);
begin
  FParameters.Assign(Prm);
end;

destructor TChenRBNetwork.Destroy;
begin
  Parameters.Free;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('Eic', [TRBNetwork]);
end;

initialization
  RegisterClass(TRBNetwork);
end.

