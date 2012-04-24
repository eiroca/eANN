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
@created 04/11/1996
@lastmod 05/05/1999

Artificial Neural Network Library @br
@br
 This implementation of several kind of neural networks was written with the
 intention of providing a (hopefully) easy to use, and easy to modify,
 OOP source code.
@br
 You can also have several different sized networks running simultaneously,
 each functioning independently of the others, or acting as inputs to
 other networks. It should also be very easy to modify the source so that
 neurons (or even whole layers) can be created/pruned during operation
 of the network, thus allowing dynamic expansion/contraction.
@br
 History: @br
  1.00 First version @br
  1.10 Starting History's Log @br
  1.11 Adding Status Property @br
  1.12 Class reengineering (added or modified): Info, Query, SupportedOper @br
  2.00 Major class reengineering now with full Delphi support @br
  2.01 Added FindCluster, ResetTraining, ANNMsg and other minor changes @br
  2.02 Ported to Delphi XE2 @br
@br
@br
Some definition used in this documentation @br
@bold(YC[n,i]) the network output prediction, @br
@bold(Y[n,i]) the "real" output, @br
@bold(E[n,i]) = abs(YC[n,i]-Y[n,i]) the absolute error of a single vector element of a given sample, @br
@bold(Er[n,i]) = E[n,i] / Y[n,i] the relative error of a single vector element of a given sample, @br
@bold(D[n]) = Sqrt(Sum(E[n, i] * E[n, i])) / I the average Euclidean distance of vector element of a given sample, @br
@bold(Dr[n]) = Sqrt(Sum(Er[n, i] * Er[n, i])) / I the average relative Euclidean distance of vector element of a given sample, @br
@bold(n in N set), N number of samples, @br
@bold(i in I set), I number of elements in input vectors restricted to elements that have the magnitude grater then 'IgnoreIf' soil (see also 'IgnoreMode' parameter), @br
@bold(Activation) Sum of activation (gaussian function) of all neuron @br
*)
unit eANNCore;

interface

uses
  System.SysUtils, System.Classes, System.Contnrs,
  eDataPick, eLibCore, eLibMath, eLibStat;

resourcestring

  wrnAborted     = 'operation aborted';
  wrnMaxIter     = 'maximum iterations reached';
  wrnNoConv      = 'convergence not reached';

  errBadInput    = 'problem(s) with input data';
  errBadOutput   = 'problem(s) with output data';
  errBadIOCount  = 'fewer output patterns than input ones';
  errNotTrained  = 'network must be trained';
  errAbstract    = 'call to an abstract function';
  errOutOfMemory = 'memory or object allocation failed';
  errNeuronError1= 'neuron can be inserted only in layers';
  errNeuronError2= 'neuron cannot accept other components';
  errNeuronError3= 'TPLElem can be inserted only in TPLNetwork';
  errLayerError1 = 'layer can be inserted only in MLP networks';
  errLayerError2 = 'layer cannot accept nothing other neurons';
  errBadNetDef   = 'bad network definition';

const
  //A low value assumed to be 0
  Zero: double = 0.0001;

const
  defErrorMode   = imNone;
  defErrorParam  = 0;
  defIterations  = 1;
  defProgressStep= 100;

type
  //Base exception class
  ANNExceptionClass = class of EANNError;
  //Base ANN Error
  EANNError         = class(exception);
  //Base ANN Warning
   EANNWarning      = class(EANNError);
  //Training stopped
    EANNStopped     = class(EANNWarning);
  //Abstract network
   EANNAbstract     = class(EANNError);
  //Data have error(s)
   EANNDataError    = class(EANNError);
  //Generic error
   EANNGeneric      = class(EANNError);
  //Out of memory
    EANNMemory      = class(EANNGeneric);
  //Network not trained
    EANNNotTrained  = class(EANNGeneric);
  //Error in network structure
   EANNStructure    = class(EANNError);
  //Error in a network layer
    EANNLayer       = class(EANNStructure);
  //Error in a Neuron
    EANNNeuron      = class(EANNStructure);
  //Wrong network parameter
   EANNParam        = class(EANNError);

type
  TNetInfo  = (
    niSuper,
    niProgressive);
  TNetInfos = set of TNetInfo;

type
  (* Definition of network operations *)
  TNetOper  = (
    noReset,
    noTrain,
    noApply,
    noError,
    noAcquire,
    noLearn,
    noSimul,
    noFindCluster);
  TNetOpers = set of TNetOper;

type
  TProgressKind   = (pkInit, pkIteration, pkStep, pkDone);
  TDataNotify     = (dnDataIn, dnDataOut, dnDimInp, dnDimOut);

type
  TWeights = class(TStorable)
    private
     FWeights: TData;
    protected
     procedure  SetSize(vl: integer);
     function   GetSize: integer;
     procedure  SetItem(index: integer; vl: double);
     function   GetItem(index: integer): double;
     procedure  WriteWeights(Writer: TWriter);
     procedure  ReadWeights(Reader: TReader);
    public
     class function New(aSize: integer): TWeights; static;
    public
     constructor Create(AOwner: TComponent); override;
     destructor  Destroy; override;
    protected
     procedure   DefineProperties(Filer: TFiler); override;
    public
     (* Deep copy of the network *)
     procedure   Assign(Source: TPersistent); override;
    public
     procedure   SetWeights(const p: TData);
     function    GetWeights: TData;
     procedure   Randomize(min, max: double);
     procedure   Setup(value: double);
     function    SqrDist(const ip: TData): double;
    public
     property Items[i: integer]: double
       read GetItem
       write SetItem;
       default;
     property Data: TData
       read FWeights;
    published
     property Size: integer
       read GetSize
       write SetSize
       stored true;
  end;

  TWeights_List = class(TComponentList)
    protected
     function  GetWeights(Index: Integer): TWeights;
     procedure PutWeights(Index: Integer; Item: TWeights);
    public
     property Items[Index: Integer]: TWeights
       read GetWeights
       write PutWeights;
       default;
  end;

type
  TActivityLogger = class(TStorable)
    private
     FCntAtt: integer;
     FCurAtt: double;
     FSumAtt: double;
     FSm2Att: double;
     FMinAtt: double;
     FMaxAtt: double;
     FLstAtt: double;
     FOldMin: double;
     FOldMax: double;
     FCanUnd: boolean;
    protected
     function  GetAverage: double;
     function  GetVariance: double;
     procedure WriteStatus(Writer: TWriter);
     procedure ReadStatus(Reader: TReader);
    public
     constructor Create(AOwner: TComponent); override;
    protected
     procedure   DefineProperties(Filer: TFiler); override;
    public
     procedure   Assign(Source: TPersistent); override;
    public
     procedure   Reset;
     procedure   Add(vl: double);
     procedure   Undo;
    published
     property Count   : integer
       read FCntAtt
       stored true;
     property Current : double
       read FCurAtt
       stored true;
     property SumX    : double
       read FSumAtt
       stored true;
     property SumX2   : double
       read FSm2Att
       stored true;
     property Minimum : double
       read FMinAtt
       stored true;
     property Maximum : double
       read FMaxAtt
       stored true;
     property Average : double
       read GetAverage
       stored false;
     property Variance: double
       read GetVariance
       stored false;
     property CanUndo : boolean
       read FCanUnd
       stored false;
  end;

type
  TANN = class;
  TANNClass = class of TANN;

  TProgressEvent  = procedure(Sender: TANN; ProgKind: TProgressKind; Info: longint) of object;
  TNetOperEvent   = function(Sender: TANN; What: TNetOper): boolean of object;
  TDataChange     = procedure(Sender: TANN; What: TDataNotify) of object;
  TNetworkChange  = procedure(Sender: TANN) of object;

  TANNOptions = class(TStorable)
    private
     // Network Options
     FErrorMode : TIgnoreMode;
     FErrorParam: double;
     FProgStep  : integer;
     FIterations: integer;
    protected
     procedure SetErrorParam(vl: double);
     procedure SetProgStep(vl: integer);
     procedure SetIterations(vl: integer);
    public
     constructor Create(AOwner: TComponent); override;
    public
     (* Deep copy of the network *)
     procedure   Assign(Source: TPersistent); override;
    published
     //IgnoreMode (default 0) errors ignoring policy 0=take all errors, 1 = ignore errors if IgnoreIf condition is true, 2 = error=0 if ErrorParam condition is true.
     property ErrorMode   : TIgnoreMode
       read FErrorMode
       write FErrorMode
       stored true
       default defErrorMode;
     //ErrorParam (default 0). Let error method to ignore elements of output vectors if its magnitude is under this value.
     property ErrorParam  : double
       read FErrorParam
       write SetErrorParam
       stored true
       nodefault;
     //Iterations (default 1) times to repeat patterns during trainings.
     property Iterations  : integer
       read FIterations
       write SetIterations
       stored true
       default defIterations;
     //Iteration(s) between progress indication
     property ProgressStep: integer
       read FProgStep
       write SetProgStep
       stored true
       default defProgressStep;
  end;

  (* Pure interface Network *)
  TANN = class(TStorable)
    protected
     (* Adds operation to supported operation set *)
     class procedure Supply(var Op: TNetOpers); virtual;
    public
     (*
     Returns the operation allowed with the network
     @returns Supported Operation set
     *)
     class function SupportedOperation: TNetOpers; virtual;
     (* Returns the name of the network *)
     class function Description: string; virtual;
    protected
     FTrained     : boolean;
     FDataIn      : TDataPicker;
     FDataOut     : TDataPicker;
     FDimInp      : integer;
     FDimOut      : integer;
     FStopOper    : boolean;
     FNetInfos    : TNetInfos;
     FOnProgress  : TProgressEvent;
     FOnPrepare   : TNetOperEvent;
     FOnBeginOper : TNetOperEvent;
     FOnEndOper   : TNetOperEvent;
     FOnChange    : TNetworkChange;
     FOnDataChange: TDataChange;
     FOptions     : TANNOptions;
     // Change status
     ChangesLock  : integer;
     NeedChange   : boolean;
    private
     procedure DataInChanged(Sender: TObject);
     procedure DataOutChanged(Sender: TObject);
    private
     procedure SetDataIn(vl: TDataPicker);
     procedure SetDataOut(vl: TDataPicker);
    protected
     procedure SetOptions(vl: TANNOptions);
     procedure SetNetInfos(vl: TNetInfos);
     procedure Notification(AComponent: TComponent; Operation: TOperation); override;
     (* Initializes the progress indicator *)
     procedure ProgressInit(AMax: integer);
     (* Reports a progress step *)
     procedure DoProgressStep;
     (* Reports a interation progress *)
     procedure ProgressIteration(ite: integer);
     (* Stops the progress indicator *)
     procedure ProgressDone;
     procedure DataChange(What: TDataNotify); virtual;
     (* Prepares the network for training, applying or computing error method *)
     function  Prepare(What: TNetOper): boolean; virtual;
     procedure ResetTraining; virtual;
    public
     (* Constructs the network *)
     constructor Create(AOwner: TComponent); override;
     (* Destroys the network *)
     destructor  Destroy; override;
    public
     (* Deep copy of the network *)
     procedure   Assign(Source: TPersistent); override;
    protected
     procedure   Loaded; override;
    public
     procedure   BeginUpdate; virtual;
     procedure   Change;
     procedure   DoChange; dynamic;
     procedure   EndUpdate; virtual;
    public
     function    BeginLearning: boolean; virtual;
     (* Learns a single sample (valid for supervisioned networks) *)
     procedure   Learn(const ip, op: TData); dynamic;
     procedure   EndLearning; virtual;
    public
     function    BeginAcquisition: boolean; virtual;
     (* Acquire a single sample (valid for non supervisioned networks) *)
     procedure   Acquire(const ip: TData); dynamic;
     procedure   EndAcquisition; virtual;
    public
     function    BeginSimulation: boolean; virtual;
     (* Computes output of a single input *)
     procedure   Simul(const ip: TData; var op: TData); dynamic;
     procedure   EndSimulation; virtual;
    public
     function    BeginClusterization: boolean; virtual;
     function    FindCluster(const ip: TData): integer; dynamic;
     procedure   EndClusterization; virtual;
    public
     (* Resets the network (loosing learning) *)
     procedure   Reset; virtual;
     (* Trains the network with a given set of samples. DataIn holds the inputs and  DataOut holds the target outputs *)
     procedure   Train; virtual;
     (* Computes network output based on a set of inputs. DataIn holds the inputs and DataOut will contains the predicted outputs *)
     procedure   Apply; virtual;
     (* Computes network errors on a given set of samples. DataIn holds the inputs and DataOut holds the real outputs *)
     procedure   Error(ES: TErrorSet); virtual;
    published
     property Options: TANNOptions
       read FOptions
       write SetOptions
       stored true;
     (* Run-Time Only *)
     property StopOper   : boolean
       read FStopOper
       write FStopOper
       stored false;
     (* Publishable *)
     (* Flag to indicate if the network is trained or not *)
     property Trained    : boolean
       read FTrained
       write FTrained
       stored true
       default false;
     (* Read Only *)
     property NetInfos   : TNetInfos
       read FNetInfos;
     (* Read Only. Input dimension *)
     property DimInp     : integer
       read FDimInp
       write FDimInp
       stored true
       default -1;
     (* Read Only. Output dimension *)
     property DimOut     : integer
       read FDimOut
       write FDimOut
       stored true
       default -1;
     (* Input data *)
     property DataIn     : TDataPicker
       read FDataIn
       write SetDataIn
       stored true;
     (* Output data *)
     property DataOut    : TDataPicker
       read FDataOut
       write SetDataOut
       stored true;
     (* Events *)
     property OnChange    : TNetworkChange
       read FOnChange
       write FOnChange;
     property OnDataChange: TDataChange
       read FOnDataChange
       write FOnDataChange;
     property OnProgress  : TProgressEvent
       read FOnProgress
       write FOnProgress;
     property OnPrepare   : TNetOperEvent
       read FOnPrepare
       write FOnPrepare;
     property OnBeginOper : TNetOperEvent
       read FOnBeginOper
       write FOnBeginOper;
     property OnEndOper   : TNetOperEvent
       read FOnEndOper
       write FOnEndOper;
  end;

implementation

uses
  Math;

//--------------------------------------------------------------------------------------------------
class function TWeights.New(aSize: integer): TWeights;
begin
  Result:= TWeights.Create(nil);
  Result.Size:= aSize;
end;

constructor TWeights.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TWeights.Destroy;
begin
  inherited;
end;

procedure TWeights.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('Data', ReadWeights, WriteWeights, Size>0);
end;

procedure TWeights.Assign(Source: TPersistent);
var
  W: TWeights;
  s: integer;
begin
  if Source is TWeights then begin
    W:= TWeights(Source);
    s:= W.Size;
    Size:= s;
    FWeights:= System.Copy(W.FWeights, 0, s);
  end
  else inherited;
end;

procedure TWeights.SetSize(vl: integer);
begin
  SetLength(FWeights, vl);
end;

function TWeights.GetSize: integer;
begin
  Result:= Length(FWeights);
end;

procedure  TWeights.SetItem(index: integer; vl: double);
begin
  FWeights[index]:= vl;
end;

function   TWeights.GetItem(index: integer): double;
begin
  Result:= FWeights[index];
end;

procedure TWeights.ReadWeights(Reader: TReader);
var
  i: integer;
  d: double;
begin
  Reader.ReadListBegin;
  for i:= 0 to Size-1 do begin
    d:= Reader.ReadFloat;
    FWeights[i]:= d;
  end;
  Reader.ReadListEnd;
end;

procedure TWeights.WriteWeights(Writer: TWriter);
var
  i: integer;
begin
  Writer.WriteListBegin;
  for i:= 0 to Size-1 do begin
    Writer.WriteFloat(Data[i]);
  end;
  Writer.WriteListEnd;
end;

procedure TWeights.SetWeights(const p: TData);
begin
  FWeights:= System.Copy(p, 0, Length(p))
end;

function TWeights.GetWeights: TData;
begin
  Result:= System.Copy(FWeights, 0, Length(FWeights))
end;

procedure TWeights.Randomize(min, max: double);
var
  i: integer;
  dlt: double;
begin
  dlt:= (max-min);
  for i:= 0 to Size-1 do begin
    Data[i]:= random * dlt + min;
  end;
end;

procedure TWeights.Setup(value: double);
var
  i: integer;
begin
  for i:= 0 to Size-1 do begin
    Data[i]:= value;
  end;
end;

function TWeights.SqrDist(const ip: TData): double;
var
  i: integer;
begin
  Result:= 0;
  for i:= 0 to Size-1 do begin
    Result:= Result + sqr(Data[i] - ip[i]);
  end;
end;

//--------------------------------------------------------------------------------------------------
function  TWeights_List.GetWeights(Index: Integer): TWeights;
begin
  if Index=-1 then Index:= Count-1;
  Result:= TWeights(Get(Index));
end;

procedure TWeights_List.PutWeights(Index: Integer; Item: TWeights);
begin
  Put(Index, Item);
end;

//--------------------------------------------------------------------------------------------------
constructor TActivityLogger.Create(AOwner: TComponent);
begin
  inherited;
  Reset;
end;

procedure TActivityLogger.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('Status', ReadStatus, WriteStatus, Count>0);
end;

procedure TActivityLogger.Assign(Source: TPersistent);
var
  AL: TActivityLogger;
begin
  if Source is TActivityLogger then begin
    AL:= TActivityLogger(Source);
    FCntAtt:= AL.FCntAtt;
    FCurAtt:= AL.FCurAtt;
    FSumAtt:= AL.FSumAtt;
    FSm2Att:= AL.FSm2Att;
    FMinAtt:= AL.FMinAtt;
    FMaxAtt:= AL.FMaxAtt;
    FLstAtt:= AL.FLstAtt;
    FOldMin:= AL.FOldMin;
    FOldMax:= AL.FOldMax;
    FCanUnd:= AL.FCanUnd;
  end
  else inherited;
end;

procedure TActivityLogger.ReadStatus(Reader: TReader);
begin
  Reader.ReadListBegin;
  FCntAtt:= Reader.ReadInteger;
  FCurAtt:= Reader.ReadFloat;
  FSumAtt:= Reader.ReadFloat;
  FSm2Att:= Reader.ReadFloat;
  FMinAtt:= Reader.ReadFloat;
  FMaxAtt:= Reader.ReadFloat;
  FLstAtt:= NaN;
  FOldMin:= NaN;
  FOldMax:= NaN;
  FCanUnd:= false;
  Reader.ReadListEnd;
end;

procedure TActivityLogger.WriteStatus(Writer: TWriter);
begin
  Writer.WriteListBegin;
  Writer.WriteInteger(FCntAtt);
  Writer.WriteFloat(FCurAtt);
  Writer.WriteFloat(FSumAtt);
  Writer.WriteFloat(FSm2Att);
  Writer.WriteFloat(FMinAtt);
  Writer.WriteFloat(FMaxAtt);
  Writer.WriteListEnd;
end;

function TActivityLogger.getAverage: double;
begin
  if (Count>0) then begin
    Result:= SumX / Count;
  end
  else begin
    Result:= 0;
  end;
end;

function TActivityLogger.getVariance: double;
begin
  if (Count>0) then begin
    Result:= SumX2 / Count - sqr(SumX/Count);
  end
  else begin
    Result:= 0;
  end;
end;

procedure TActivityLogger.Add(vl: double);
begin
  FCanUnd:= true;
  if Count = 0 then begin
    FCntAtt:= 1;
    FCurAtt:= vl;
    FMinAtt:= vl;
    FMaxAtt:= vl;
    FSumAtt:= vl;
    FSm2Att:= sqr(vl);
    FLstAtt:= NaN;
    FOldMin:= NaN;
    FOldMax:= NaN;
  end
  else begin
    FLstAtt:= Current;
    FCurAtt:= vl;
    if Current < Minimum then begin
      FOldMin:= Minimum;
      FMinAtt:= Current;
    end
    else if Current > Maximum then begin
      FOldMax:= Maximum;
      FMaxAtt:= Current;
    end;
    FSumAtt:= SumX + Current;
    FSm2Att:= SumX2 + sqr(Current);
    FCntAtt:= Count + 1;
  end;
end;

procedure TActivityLogger.Undo;
begin
  if not FCanUnd then exit;
  if (Count<=1) then begin
    Reset;
    exit;
  end;
  if Current = Minimum then FMinAtt:= FOldMin
  else if Current = Maximum then FMaxAtt:= FOldMax;
  FSumAtt:= SumX - Current;
  FSm2Att:= SumX2 - sqr(Current);
  FCntAtt:= Count - 1;
  FCurAtt:= FLstAtt;
  FCanUnd:= false;
end;

procedure TActivityLogger.Reset;
begin
  FCanUnd:= false;
  FCntAtt:= 0;
  FSumAtt:= 0;
  FSm2Att:= 0;
  FMinAtt:= NaN;
  FMaxAtt:= NaN;
  FCurAtt:= NaN;
  FLstAtt:= NaN;
  FOldMin:= NaN;
  FOldMax:= NaN;
end;

//--------------------------------------------------------------------------------------------------
constructor TANNOptions.Create(AOwner: TComponent);
begin
  inherited;
  FErrorParam := defErrorParam;
  FErrorMode  := defErrorMode;
  FProgStep   := defProgressStep;
  FIterations := defIterations;
end;

procedure TANNOptions.Assign(Source: TPersistent);
var
  Opts: TANNOptions;
begin
  if Source is TANNOptions then begin
    Opts:= TANNOptions(Source);
    FErrorParam:= Opts.FErrorParam;
    FErrorMode := Opts.FErrorMode;
    FProgStep  := Opts.FProgStep;
    FIterations:= Opts.FIterations;
  end
  else inherited;
end;

procedure TANNOptions.SetErrorParam(vl: double);
begin
  if vl < 0 then vl:= 0;
  FErrorParam:= vl;
end;

procedure TANNOptions.SetProgStep(vl: integer);
begin
  if (vl < 0) then vl:= 0;
  FProgStep:= vl;
end;

procedure TANNOptions.SetIterations(vl: integer);
begin
  if (vl < 0) then vl:= 0;
  FIterations:= vl;
end;

//--------------------------------------------------------------------------------------------------
class procedure TANN.Supply(var Op: TNetOpers);
begin
  if noLearn in Op then Op:= Op + [noTrain];
  if noAcquire in Op then Op:= Op + [noTrain];
  if noSimul in Op then Op:= Op + [noError, noApply];
  if noFindCluster in Op then Op:= Op + [noApply];
end;

class function TANN.SupportedOperation: TNetOpers;
begin
  Result:= [];
  Supply(Result);
end;

class function TANN.Description: string;
begin
  Result:= 'Artificial Neural Network Interface';
end;

constructor TANN.Create(AOwner: TComponent);
begin
  inherited;
  FOptions:= TANNOptions.Create(nil);
  NeedChange  := false;
  ChangesLock := 0;
  StopOper    := false;
  DataIn      := nil;
  DataOut     := nil;
  FDimInp     := -1;
  FDimOut     := -1;
  FTrained    := false;
  FOnProgress := nil;
  FOnPrepare  := nil;
  FOnBeginOper:= nil;
  FOnEndOper  := nil;
  FOnChange   := nil;
  FOnDataChange:= nil;
  FNetInfos   := [];
end;

destructor TANN.Destroy;
begin
  FOptions.Free;
  inherited;
end;

procedure TANN.Assign(Source: TPersistent);
var
  N: TANN;
begin
  if Source is TANN then begin
    N:= TANN(Source);
    BeginUpdate;
    NeedChange:= true;
    FNetInfos:= N.FNetInfos;
    Trained:= N.Trained;
    DimInp:= N.DimInp;
    DimOut:= N.DimOut;
    DataIn:= N.DataIn;
    DataOut:= N.DataOut;
    Options:= N.Options;
    Change;
  end
  else inherited;
end;

procedure TANN.Loaded;
begin
  inherited;
  if NeedChange then Change;
end;

procedure TANN.DataInChanged(Sender: TObject);
begin
  if DataIn.Dim <> FDimInp then begin
    FDimInp:= DataIn.Dim;
    DataChange(dnDimInp);
  end;
end;

procedure TANN.DataOutChanged(Sender: TObject);
begin
  if DataOut.Dim <> FDimOut then begin
    FDimOut:= DataOut.Dim;
    DataChange(dnDimOut);
  end;
end;

procedure TANN.SetDataIn(vl: TDataPicker);
begin
  if vl <> FDataIn then begin
    if FDataIn <> nil then FDataIn.ChangeListener.Add(DataInChanged);
    FDataIn:= vl;
    DataChange(dnDataIn);
    if FDataIn <> nil then begin
      if FDimInp <> FDataIn.Dim then begin
        FDimInp:= FDataIn.Dim;
        DataChange(dnDimInp);
      end;
      FDataIn.ChangeListener.Add(DataInChanged);
    end;
  end;
end;

procedure TANN.SetDataOut(vl: TDataPicker);
begin
  if vl <> FDataOut then begin
    if FDataOut <> nil then FDataOut.ChangeListener.Del(DataOutChanged);
    FDataOut:= vl;
    DataChange(dnDataOut);
    if vl <> nil then begin
      if FDimOut <> FDataOut.Dim then begin
        FDimOut:= vl.Dim;
        DataChange(dnDimOut);
      end;
      FDataOut.ChangeListener.Add(DataOutChanged);
    end;
  end;
end;

procedure TANN.SetOptions(vl: TANNOptions);
begin
  FOptions.Assign(vl);
end;

procedure TANN.SetNetInfos(vl: TNetInfos);
begin
  if vl <> FNetInfos then begin
    FNetInfos:= vl;
    Change;
  end;
end;

procedure TANN.ResetTraining;
begin
  Trained:= false;
end;

procedure TANN.Reset;
begin
  ResetTraining;
end;

function TANN.Prepare(What: TNetOper): boolean;
  procedure ValidDataIn;
  begin
    if ((DataIn = nil) or (DataIn.Count=0)) then begin
      raise EANNDataError.Create(errBadInput);
    end;
  end;
  procedure ValidDataOut;
  begin
    if ((DataOut=nil) or (DataOut.Count=0)) then begin
      raise EANNDataError.Create(errBadOutput);
    end;
    if (DataOut.Count<DataIn.Count) then begin
      raise EANNDataError.Create(errBadIOCount);
    end;
  end;
  procedure CheckTrained;
  begin
    if not FTrained then begin
      raise EANNNotTrained.Create(errNotTrained);
    end;
  end;
begin
  StopOper:= false;
  case What of
    noTrain, noLearn, noAcquire: begin
      ValidDataIn;
      if niSuper in NetInfos then begin
        ValidDataOut;
      end;
    end;
    noError, noSimul, noFindCluster: begin
      CheckTrained;
      ValidDataIn;
      ValidDataOut;
    end;
    noApply: begin
      ValidDataIn;
      if (DataOut<>nil) and (DataOut.Count < DataIn.Count) then begin
        if niSuper in NetInfos then begin
          DataOut.Setup(DimOut, DataIn.Count);
        end
        else begin
          DataOut.Setup(1, DataIn.Count);
        end;
      end;
    end;
  end;
  Prepare:= true;
  if Assigned(FOnPrepare) then Prepare:= OnPrepare(Self, What);
end;

procedure TANN.DoChange;
begin
  if (Assigned(FOnChange)) then OnChange(Self);
end;

procedure TANN.Change;
begin
  if (ChangesLock = 0) then begin
    if csLoading in ComponentState then begin
      NeedChange:= true;
    end
    else begin
      NeedChange:= false;
      DoChange;
    end;
  end
  else begin
    NeedChange:= true;
  end;
end;

procedure TANN.DataChange(What: TDataNotify);
begin
  if (What=dnDimInp) or ((What=dnDimOut) and (niSuper in NetInfos)) then begin
    if FTrained then ResetTraining;
  end;
  if Assigned(FOnDataChange) then OnDataChange(Self, What);
end;

procedure TANN.BeginUpdate;
begin
  inc(ChangesLock);
end;

procedure TANN.EndUpdate;
begin
  dec(ChangesLock);
  if (ChangesLock = 0) then begin
    if NeedChange then begin
      Change;
      NeedChange:= false;
    end;
  end;
end;

procedure TANN.Train;
var
  it, i: integer;
  ite: integer;
  ProgStep: integer;
  NumPat: integer;
begin
  if not Prepare(noTrain) then exit;
  if niSuper in NetInfos then begin (* supervisionata *)
    if not BeginLearning then exit;
  end
  else begin
    if not BeginAcquisition then exit;
  end;
  ite:= Options.Iterations;
  ProgStep:= Options.ProgressStep;
  if ite < 1 then ite:= 1;
  NumPat:= DataIn.Count;
  ProgressInit(NumPat*ite);
  try
    if niSuper in NetInfos then begin (* supervisionata *)
      for it:= 0 to ite-1 do begin
        ProgressIteration(it+1);
        for i:= 0 to NumPat-1 do begin
          if (ProgStep<>0) and ((i mod ProgStep) = 1) then DoProgressStep;
          if StopOper then raise EANNStopped.Create(wrnAborted);
          Learn(DataIn[i], DataOut[i]);
        end;
      end;
    end
    else begin
      for it:= 0 to ite-1 do begin
        ProgressIteration(it+1);
        for i:= 0 to NumPat-1 do begin
          if (ProgStep<>0) and ((i mod ProgStep) = 1) then DoProgressStep;
          if StopOper then raise EANNWarning.Create(wrnAborted);
          Acquire(DataIn[i]);
        end;
      end;
    end;
    FTrained:= true;
  finally
    ProgressDone;
    if niSuper in NetInfos then begin (* supervisionata *)
      EndLearning;
    end
    else begin
      EndAcquisition;
    end;
  end;
end;

procedure TANN.Error(ES: TErrorSet);
var
  i: integer;
  NumPat: integer;
  YC: TData;
  od: integer;
  ProgStep: integer;
begin
  if not(niSuper in NetInfos) then begin (* supervisionata *)
    raise EANNAbstract.Create(errAbstract);
  end;
  if not Prepare(noError) then exit;
  if not BeginSimulation then exit;
  ES.Setup(Options.ErrorMode, Options.ErrorParam);
  ProgStep:= Options.ProgressStep;
  NumPat:= DataIn.Count;
  od:= DataOut.Dim;
  setLength(YC, od);
  ProgressInit(NumPat);
  try
    ES.BeginCalc;
    for i:= 0 to NumPat-1 do begin
      if (ProgStep<>0) and ((i mod ProgStep) = 1) then DoProgressStep;
      if StopOper then raise EANNStopped.Create(wrnAborted);
      Simul(DataIn[i], YC);
      ES.Analyze(i, od, YC, DataOut[i]);
    end;
  finally
    ES.EndCalc;
    ProgressDone;
    EndSimulation;
  end;
end;

procedure TANN.Apply;
var
  ProgStep, NumPat: integer;
  i: integer;
  op: TData;
begin
  if not Prepare(noApply) then exit;
  if niSuper in NetInfos then begin (* supervisionata *)
    if not BeginSimulation then exit;
  end
  else begin
    if not BeginClusterization then exit;
  end;
  ProgStep:= Options.ProgressStep;
  NumPat:= DataIn.Count;
  ProgressInit(NumPat);
  try
    for i:= 0 to NumPat-1 do begin
      if (ProgStep<>0) and ((i mod ProgStep) = 1) then DoProgressStep;
      if StopOper then raise EANNStopped.Create(wrnAborted);
      if niSuper in NetInfos then begin (* supervisionata *)
        op:= FDataOut[i];
        Simul(DataIn[i], op);
      end
      else begin
        DataOut[i][0]:= FindCluster(DataIn[i]);
      end;
    end;
  finally
    ProgressDone;
    if niSuper in NetInfos then begin (* supervisionata *)
      EndSimulation;
    end
    else begin
      EndClusterization;
    end;
  end;
end;

function TANN.BeginLearning: boolean;
begin
  Result:= Prepare(noLearn);
  if not Result then exit;
  if Assigned(FOnBeginOper) then OnBeginOper(Self, noLearn);
end;

function TANN.BeginAcquisition: boolean;
begin
  Result:= Prepare(noAcquire);
  if not Result then exit;
  if Assigned(FOnBeginOper) then OnBeginOper(Self, noAcquire);
end;

function TANN.BeginSimulation: boolean;
begin
  Result:= Prepare(noSimul);
  if not Result then exit;
  if Assigned(FOnBeginOper) then OnBeginOper(Self, noSimul);
end;

function TANN.BeginClusterization: boolean;
begin
  Result:= Prepare(noFindCluster);
  if not Result then exit;
  if Assigned(FOnBeginOper) then OnBeginOper(Self, noFindCluster);
end;

procedure TANN.EndLearning;
begin
  if Assigned(FOnEndOper) then OnEndOper(Self, noLearn);
end;

procedure TANN.EndAcquisition;
begin
  if Assigned(FOnEndOper) then OnBeginOper(Self, noAcquire);
end;

procedure TANN.EndSimulation;
begin
  if Assigned(FOnEndOper) then OnEndOper(Self, noSimul);
end;

procedure TANN.EndClusterization;
begin
  if Assigned(FOnEndOper) then OnEndOper(Self, noFindCluster);
end;

procedure TANN.Acquire(const ip: TData);
begin
  raise EANNAbstract.Create(errAbstract);
end;

procedure TANN.Learn(const ip, op: TData);
begin
  raise EANNAbstract.Create(errAbstract);
end;

procedure TANN.Simul(const ip: TData; var op: TData);
begin
  raise EANNAbstract.Create(errAbstract);
end;

function TANN.FindCluster(const ip: TData): integer;
begin
  raise EANNAbstract.Create(errAbstract);
end;

procedure TANN.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if Operation = opRemove then begin
    if AComponent = DataIn then begin
      FDataIn:= nil;
      FDimInp:= 0;
      DataChange(dnDataIn);
    end
    else if AComponent = DataOut then begin
      FDataOut:= nil;
      FDimOut:= 0;
      DataChange(dnDataOut);
    end;
  end;
  inherited;
end;

procedure TANN.ProgressInit(AMax: integer);
begin
  if Assigned(FOnProgress) then OnProgress(Self, pkInit, AMax);
end;

procedure TANN.ProgressIteration(ite: integer);
begin
  if Assigned(FOnProgress) then OnProgress(Self, pkIteration, ite);
end;

procedure TANN.DoProgressStep;
begin
  if Assigned(FOnProgress) then OnProgress(Self, pkStep, Options.ProgressStep);
end;

procedure TANN.ProgressDone;
begin
  if Assigned(FOnProgress) then OnProgress(Self, pkDone, 0);
end;

//--------------------------------------------------------------------------------------------------
initialization
  RegisterClasses([TWeights, TActivityLogger]);
  RegisterClasses([TANNOptions, TANN]);
end.
