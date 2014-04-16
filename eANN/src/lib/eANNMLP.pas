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

Artificial Multi Layer Neural Network with Backpropagation @br
@br
 This is an implementation of MLP artificial neural. @br
@br
 History: @br
  1.00 First version @br
  1.01 Starting History's Log @br
  1.02 Sync with new ANN 1.12 @br
  2.00 Sync with new ANN 2.01 @br
  2.01 Simplified TLayer, TNeruon, TMLPNetwork now persistent. @br
*)
unit eANNMLP;

interface

uses
  System.Classes, System.SysUtils,
  eANNCore,
  eLibCore, eDataPick;

type
  TLayer = class;
  TNeuronClass = class of TNeuron;
  TNeuronTypes = array of TNeuronClass;

  (* Definition of neuron *)
  TNeuron = class(TStorable)
    public
     (* Returns the name of the neuron *)
     class function Description: string; virtual;
    private
     FState: double;
     FError: double;
     FBias : double;
     FWeights: TWeights;
     FDeltas : TWeights;
    protected
     function   GetHasDelta: boolean;
     procedure  SetHasDelta(vl : boolean);
     function   GetWeights: TWeights;
     procedure  SetWeights(vl: TWeights);
     function   GetDeltas: TWeights;
     procedure  SetDeltas(vl: TWeights);
     function   GetSize: integer;
     procedure  SetSize(vl: integer);
    public
     (* Create a neuron structure with (wpn) weights per neuron *)
     constructor Create(AOwner: TComponent); override;
     (* Free all memory that was assigned for the specified neuron structure *)
     destructor  Destroy; override;
    public
     procedure   Assign(Source: TPersistent); override;
    public
     (* Compute output-error of then neuron according to target y *)
     procedure   CalcError(const y: double); virtual;
     (* funzione trasferimento *)
     function    tf(v: double): double; virtual; abstract;
     function    dtf(v: double): double; virtual; abstract;
    public
     (* Number of weights *)
     property Size: integer
       read GetSize
       write SetSize;
     (* Neuron has delta? *)
     property HasDelta: boolean
       read GetHasDelta
       write SetHasDelta;
    published
      (* Weights of the neuron *)
      property Weights: TWeights
        read GetWeights
        write SetWeights;
      (* Deltas of the neuron *)
      property Deltas : TWeights
        read GetDeltas
        write SetDeltas;
    published
     (* The output of this neuron *)
     property State: double
       read FState
       write FState;
     (* The error of this neuron *)
     property Error: double
       read FError
       write FError;
     (* The bias of this neuron *)
     property Bias : double
       read FBias
       write FBias;
  end;

  (* Logistic Neuron *)
  TLogisticNeuron = class(TNeuron)
    public
     class function Description: string; override;
    public
     (* funzione trasferimento sigmoidale *)
     function tf(v: double): double; override;
     function dtf(v: double): double; override;
  end;

  (* Linear Neuron *)
  TLinearNeuron = class(TNeuron)
    public
     class function Description: string; override;
    public
     function tf(v: double): double; override;
     function dtf(v: double): double; override;
  end;

  (* Perceptron (output 1 if weighted sum of inputs is greather than 0) *)
  TPerceptron = class(TNeuron)
    public
     class function Description: string; override;
    public
     function tf(v: double): double; override;
     function dtf(v: double): double; override;
  end;

  TLayerDesc = record
    Neu: integer;
    Kind: TNeuronClass;
  end;

  (* Definition of a layer (set of neurons) *)
  TLayer = class(TStorable)
    protected
     FMC  : double;
     FNorm: boolean;
    public
     (* Returns the name of the layer *)
     class function Description: string; virtual;
    private
     function    GetLC: double;
     function    GetMC: double;
     function    GetNormalize: boolean;
     function    GetNeuron(I: integer): TNeuron;
     function    GetNumNeu: integer;
     function    GetLayerIndex: integer;
    protected
     procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
     procedure   SetupConnections(NeuronInPrevLayer: integer);
    public
     constructor Create(AOwner: TComponent); override;
     (* Free all memory that was assigned for the specified layer structure *)
     destructor  Destroy; override;
    public
     procedure   Assign(Source: TPersistent); override;
     (* Create a layer structure and its neurons
     @param npl neurons per layer
     @param wpn weights per neuron *)
     procedure   Setup(npl: integer; Knd: TNeuronClass);
     procedure   UpdateParam; virtual;
     (* Set state of each neuron according to input patttern *)
     procedure   SetState(const ip: TData); virtual;
     (* Get state of each neuron putting it to output patttern *)
     procedure   GetState(var op: TData); virtual;
     (* Compute output-error of each neuron according to input pattern *)
     procedure   CalcError(const op: TData); virtual;
     (* calculate and feedforward outputs from Prev. layer to this layer *)
     procedure   FeedForward(PL: TLayer); virtual;
     (* Calculate errors for a hidden layers *)
     procedure   BackPropagate(NL: TLayer); virtual;
     (* update weights for all of the neurons of the layer *)
     procedure   AdjustWeights(PL: TLayer); virtual;
     (* Calculate output error for this layer. Defualt sum of square of neuron errors. *)
     function    Error: double; virtual;
    public
     property Neurons[i: integer]: TNeuron read GetNeuron;
     property NumNeu: integer read GetNumNeu;
     property LayerIndex: integer read GetLayerIndex;
    public
     property LC  : double
       read GetLC;
     property MC  : double
       read GetMC;
     property Normalize: boolean
       read GetNormalize;
  end;

const
  defLC = 0.1;
  defMC = 0.0;
  defTol = 0.01;
  defNormalize = false;

type
  TMLPParameters = class(TStorable)
    private
     FLC  : double;
     FMC  : double;
     FTol : double;
     FNorm: boolean;
    protected
     procedure SetLC(vl: double);
     procedure SetMC(vl: double);
     procedure SetTol(vl: double);
    public
     constructor Create(AOwner: TComponent); override;
    public
     (* Deep copy of the network *)
     procedure   Assign(Source: TPersistent); override;
    published
     // Network parameters
     property LC : double
       read FLC
       write SetLC;
     property MC : double
       read FMC
       write SetMC;
     property Tol: double
       read FTol
       write SetTol;
     property Normalize: boolean
       read FNorm
       write FNorm
       default defNormalize;
  end;

  (* Build a Multi Layer Network according to the layer description, in first
  layer neurons are only a input-buffer - no weights and transfer function - *)
  TMLPNetwork = class(TANN)
    protected
     (* Returns operation(s) supported by the network
     @param  Op  Supported Operation set *)
     class procedure Supply(var Op: TNetOpers); override;
    public
     (* Returns the name of the network *)
     class function Description: string; override;
     (* Returns the allowed class type for neurons *)
     class function GetNeuronTypes: TNeuronTypes;
     (* Helper method to build a new network form scratch *)
     class function BuildNetwork(const NTW: array of TLayerDesc; ip: TDataList; op: TDataList; LC: Double; MC: Double; tol: Double; Normalize: Boolean; Iterations: integer = 10000): TMLPNetwork;
    private
     FEpochs: integer;
     FParameters: TMLPParameters;
    protected
     procedure   SetParameters(vl: TMLPParameters);
     function    GetLayer(I: integer): TLayer;
     function    GetNumLay: integer;
     function    GetConnections(LayerIndex: integer): integer;
     procedure   SetupConnections(LayerIndex: integer);
     procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
     procedure   DataChange(What: TDataNotify); override;
    public
     (* Create a network structure and its layers *)
     constructor Create(AOwner: TComponent); override;
     procedure   Assign(Source: TPersistent); override;
     procedure   DoChange; override;
     function    Prepare(What: TNetOper): boolean; override;
     procedure   AssignInputs(const ip: TData); virtual;
     (* fast layers builder *)
     procedure   MakeLayers(NTW: array of TLayerDesc);
     (* Calculate and feedforward outputs from the first layer to the last *)
     procedure   FeedForward; virtual;
     procedure   CalcError(const op: TData); virtual;
     (* Backpropagate error from the output layer through to the first layer *)
     procedure   BackPropagate; virtual;
     (* Update weights for all of the neurons from the first to the last layer *)
     procedure   AdjustWeights; virtual;
     (* Train network with patterns *)
     procedure   Train; override;
     (* Calc network prediction error of patterns *)
     procedure   Simul(const ip: TData; var op: TData); override;
     (* Free all memory that was assigned for the specified network structure *)
     destructor  Destroy; override;
    public
     (* Array storing the number of neurons for each layer *)
     property Layers[i: integer]: TLayer read GetLayer;
     (* Number of layers *)
     property Epochs: integer
       read FEpochs;
     property NumLay: integer
       read GetNumLay;
    published
     property Parameters: TMLPParameters
       read FParameters
       write SetParameters
       stored true;
  end;

implementation

//--------------------------------------------------------------------------------------------------
class function TNeuron.Description: string;
begin
  Result:= 'Generic neuron';
end;

constructor TNeuron.Create(AOwner: TComponent);
begin
  if (AOwner <> nil) and not (AOwner is TLayer) then begin
    raise EANNNeuron.Create(errNeuronError1);
  end;
  FWeights:= TWeights(CheckCreate(FWeights, TWeights));
  FDeltas:= TWeights(CheckCreate(FDeltas, TWeights));
  FState:= 0.0;
  FError:= 0.0;
  FBias:= random - 0.5;
  inherited;
end;

destructor TNeuron.Destroy;
begin
  FreeAndNil(FWeights);
  FreeAndNil(FDeltas);
  inherited;
end;

function TNeuron.GetWeights: TWeights;
begin
  FWeights:= TWeights(CheckCreate(FWeights, TWeights));
  Result:= FWeights;
end;

procedure TNeuron.SetWeights(vl: TWeights);
begin
  Weights.Assign(vl);
end;

function TNeuron.GetDeltas: TWeights;
begin
  FDeltas:= TWeights(CheckCreate(FDeltas, TWeights));
  Result:= FDeltas;
end;

procedure TNeuron.SetDeltas(vl: TWeights);
begin
  Deltas.Assign(vl);
end;

function TNeuron.GetHasDelta: boolean;
begin
  Result:= Deltas.Size>0;
end;

procedure TNeuron.SetHasDelta(vl : boolean);
begin
  if vl then begin
    Deltas.Size:= Size;
  end
  else begin
    Deltas.Size:= 0;
  end;
end;

function TNeuron.GetSize: integer;
begin
  Result:= Weights.Size;
end;

procedure TNeuron.SetSize(vl: integer);
begin
  if vl <> Weights.Size then begin
    Weights.Size:= vl;
    Weights.Randomize(-0.5, +0.5);
    if (Deltas<>nil) then begin
      Deltas.Size:= vl;
      Deltas.Setup(0);
    end;
  end;
end;

procedure TNeuron.Assign(Source: TPersistent);
var
  N: TNeuron;
begin
  if Source is TNeuron then begin
    N:= TNeuron(Source);
    State:= N.State;
    Error:= N.Error;
    Bias := N.Bias;
    Weights:= N.Weights;
    HasDelta:= N.HasDelta;
    if (HasDelta) then begin
      Deltas.Assign(N.Deltas);
    end;
  end
  else inherited;
end;

procedure TNeuron.CalcError;
begin
  Error:= y - State;
end;

//--------------------------------------------------------------------------------------------------
class function TLogisticNeuron.Description;
begin
  Result:= 'Logistic Activation Neuron';
end;

function TLogisticNeuron.tf;
begin
  tf:= 1.0 / (1.0 + exp(-v));
end;

function TLogisticNeuron.dtf;
begin
  dtf:= State * (1.0 - State) * v;
end;

//--------------------------------------------------------------------------------------------------
class function TLinearNeuron.Description: string;
begin
  Result:= 'Linear Activation Neuron';
end;

function TLinearNeuron.tf;
begin
  tf:= v;
end;

function TLinearNeuron.dtf;
begin
  dtf:= v;
end;

//--------------------------------------------------------------------------------------------------
class function TPerceptron.Description: string;
begin
  Result:= 'Perceptron';
end;

function TPerceptron.tf;
begin
  if v > 0 then tf:= 1 else tf:= 0;
end;

function TPerceptron.dtf;
begin
  dtf:= v;
end;

//--------------------------------------------------------------------------------------------------
class function  TLayer.Description;
begin
  Result:= 'Normal Layer';
end;

constructor TLayer.Create(AOwner: TComponent);
begin
  if (AOwner <> nil) and not (AOwner is TMLPNetwork) then begin
    raise EANNLayer.Create(errLayerError1);
  end;
  inherited;
  UpdateParam;
end;

function TLayer.GetLC: double;
begin
  if (Owner<>nil) then begin
    Result:= TMLPNetwork(Owner).Parameters.LC;
  end
  else begin
    Result:= defLC;
  end;
end;

function TLayer.GetMC: double;
begin
  if (Owner<>nil) then begin
    Result:= TMLPNetwork(Owner).Parameters.MC;
  end
  else begin
    Result:= defMC;
  end;
end;

function TLayer.GetNormalize: boolean;
begin
  if (Owner<>nil) then begin
    Result:= TMLPNetwork(Owner).Parameters.Normalize;
  end
  else begin
    Result:= defNormalize;
  end;
end;

procedure TLayer.SetupConnections(NeuronInPrevLayer: integer);
var
  i: integer;
begin
  for i:= 0 to NumNeu-1 do begin
    Neurons[i].Size:= NeuronInPrevLayer;
  end;
end;

procedure TLayer.Notification(AComponent: TComponent; Operation: TOperation);
var
  N: TNeuron;
begin
  if AComponent.Owner = Self then begin
    if not (AComponent is TNeuron) then begin
      raise EANNLayer.Create(errLayerError2);
    end;
    N:= TNeuron(AComponent);
    if Operation = opInsert then begin
      if Owner <> nil then begin
        N.Size:= TMLPNetwork(Owner).GetConnections(LayerIndex);
        TMLPNetwork(Owner).SetupConnections(LayerIndex+1);
        N.HasDelta:= MC<>0;
      end;
    end;
  end;
end;

procedure TLayer.Assign(Source: TPersistent);
var
  L: TLayer;
  i: integer;
  C: TComponent;
  N: TNeuron;
begin
  if Source is TLayer then begin
    L:= TLayer(Source);
    for i:= ComponentCount-1 downto 0 do begin
      Components[i].Free;
    end;
    for i:= 0 to L.NumNeu-1 do begin
      C:= TComponentClass(L.Neurons[i].ClassType).Create(Self);
      C.Assign(L.Neurons[i]);
    end;
    if Owner <> nil then begin
      for i:= 0 to NumNeu-1 do begin
        N:= Neurons[i];
        N.Size:= TMLPNetwork(Owner).GetConnections(ComponentIndex)
      end;
    end;
  end
  else begin
    inherited;
  end;
end;

procedure TLayer.UpdateParam;
var
  HasDelta : boolean;
  i: integer;
begin
  HasDelta:= MC<>0;
  for i:= 0 to NumNeu-1 do begin
    Neurons[i].HasDelta:= HasDelta;
  end;
end;

procedure TLayer.SetState(const ip: TData);
var
  i: integer;
begin
  for i:= 0 to NumNeu-1 do begin
    Neurons[i].State:= ip[i];
  end;
end;

procedure TLayer.GetState(var op: TData);
var
  i: integer;
begin
  for i:= 0 to NumNeu-1 do begin
    op[i]:= Neurons[i].State;
  end;
end;

procedure TLayer.CalcError(const op: TData);
var
  i: integer;
begin
  for i:= 0 to NumNeu-1 do begin
    Neurons[i].CalcError(op[i]);
  end;
end;

function TLayer.Error: double;
var
  err: double;
  i: integer;
begin
  err:= 0;
  for i:= 0 to NumNeu-1 do begin
    err:= err + sqr(Neurons[i].Error);
  end;
  Error:= err;
end;

procedure TLayer.FeedForward(PL: TLayer);
var
  N: TNeuron;
  sum: double;
  i: integer;
  j: integer;
begin
  for j:= 0 to NumNeu-1 do begin
    N:= Neurons[j];
    sum:= N.Bias;
    // the number of neurons in the previous layer is
    // the number of weights in the neurons of this layer
    for i:= 0 to N.Size-1 do begin
      sum:= sum + N.Weights[i] * PL.Neurons[i].State;
    end;
    // transfer function
    N.State:= N.tf(sum);
  end
end;

procedure TLayer.BackPropagate(NL: TLayer);
var
  N1, N2: TNeuron;
  i, k: integer;
  ES: double;
begin
  for i:= 0 to NumNeu-1 do begin
    ES:= 0.0;
    N1:= Neurons[i];
    // use the error of the neurons in the next layer to
    // calculate the error of those in this layer
    for k:= 0 to NL.NumNeu-1 do begin
      N2:= NL.Neurons[k];
      ES:= ES + N2.Weights[i] * N2.Error;
    end;
    N1.Error:= N1.dtf(ES);
  end;
end;

procedure TLayer.AdjustWeights(PL: TLayer);
var
  N: TNeuron;
  D, W: TData;
  i, j: integer;
  nrm: double;
begin
  if Normalize then begin
  (* Normalized Layer. It is stable to "outliers"
    Outlier e' un vettore con modulo che si discota molto dagli altri,
    questo rende difficoltosa la convergenza in quanto genere una oscillazione
    dovuta al suo "modulo", rimedio e' normalizzare gli input al fine di avere
    la  sola direzione di riduzione dell'errore *)
    nrm:= 0;
    for i:= 0 to PL.NumNeu-1 do begin
      nrm:= nrm + sqr(PL.Neurons[i].State);
    end;
    nrm:= 1/sqrt(nrm+0.000001);
  end
  else begin
    Nrm:= 1;
  end;
  if MC = 0 then begin
    for j:= 0 to NumNeu-1 do begin
      N:= Neurons[j];
      W:= N.Weights.Data;
      N.Bias:= N.Bias + (LC * N.Error);
      // the number of neurons in the previous layer is
      // the number of weights in the neurons of this layer
      for i:= 0 to N.Size-1 do begin
        W[i]:= W[i] + (LC * PL.Neurons[i].State * nrm * N.Error) ;
      end;
    end;
  end
  else begin
    for j:= 0 to NumNeu-1 do begin
      N:= Neurons[j];
      D:= N.Deltas.Data;
      W:= N.Weights.Data;
      // Compute delta weights of then neurons
      for i:= 0 to N.Size-1 do begin
        D[i]:= MC * D[i] + (1-MC)*(LC * PL.Neurons[i].State * nrm * Error);
      end;
      N.Bias:= N.Bias + (LC * Error);
      for i:= 0 to N.Size-1 do begin
        W[i]:= W[i] + D[i];
      end;
    end;
  end;
end;

procedure TLayer.Setup(npl: integer; Knd: TNeuronClass);
var
  i: integer;
begin
  if (npl < 1) then raise EANNGeneric.Create(errBadNetDef);
  for i:= 0 to npl-1 do begin
    Knd.Create(Self);
  end;
end;

function TLayer.GetNeuron(I: integer): TNeuron;
begin
  Result:= TNeuron(Components[i]);
end;

function TLayer.GetNumNeu: integer;
begin
  Result:= ComponentCount;
end;

function TLayer.GetLayerIndex: integer;
begin
  Result:= ComponentIndex;
end;

destructor TLayer.Destroy;
begin
  inherited;
end;

//--------------------------------------------------------------------------------------------------
constructor TMLPParameters.Create(AOwner: TComponent);
begin
  inherited;
  FLC:= defLC;
  FMC:= defMC;
  FTol:= defTol;
  FNorm:= defNormalize;
end;

procedure TMLPParameters.Assign(Source: TPersistent);
var
  P: TMLPParameters;
begin
  if Source is TMLPParameters then begin
    P:= TMLPParameters(Source);
    LC:= P.LC;
    MC:= P.MC;
    Tol:= P.Tol;
    Normalize:= P.Normalize;
  end
  else inherited;
end;

procedure TMLPParameters.SetLC (vl: double);
begin
  if vl < 0 then vl:= 0.1;
  FLC:= vl;
end;

procedure TMLPParameters.SetMC (vl: double);
begin
  if (vl < 0) then vl:= 0
  else if (vl>1) then vl:= 1;
  FMC:= vl;
end;

procedure TMLPParameters.SetTol(vl: double);
begin
  if vl < 0 then vl:= 0.0001;
  FTol:= vl;
end;

//--------------------------------------------------------------------------------------------------
class procedure TMLPNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noTrain, noSimul];
  inherited;
end;

class function TMLPNetwork.Description;
begin
  Result:= 'Multi Layer Neural Network';
end;

class function TMLPNetwork.GetNeuronTypes: TNeuronTypes;
var
  types: TNeuronTypes;
begin
  SetLength(types, 4);
  types[0]:= TNeuron;
  types[1]:= TLogisticNeuron;
  types[2]:= TLinearNeuron;
  types[3]:= TPerceptron;
  Result:= types;
end;

class function TMLPNetwork.BuildNetwork(const NTW: array of TLayerDesc; ip: TDataList; op: TDataList; LC: Double; MC: Double; tol: Double; Normalize: Boolean; Iterations: integer = 10000): TMLPNetwork;
begin
  Result:= TMLPNetwork.Create(nil);
  Result.DataIn := ip;
  Result.DataOut := op;
  Result.Options.Iterations := Iterations;
  Result.Parameters.LC := LC;
  Result.Parameters.MC := MC;
  Result.Parameters.Tol := tol;
  Result.Parameters.Normalize := Normalize;
  Result.MakeLayers(NTW);
end;

constructor TMLPNetwork.Create(AOwner: TComponent);
begin
  inherited;
  FParameters:= TMLPParameters.Create(nil);
  SetNetInfos([niSuper]);
  Options.Iterations:= 1000;
end;

destructor TMLPNetwork.Destroy;
begin
  FParameters.Free;
  inherited;
end;

procedure TMLPNetwork.AssignInputs(const ip: TData);
// you can change this to assign inputs specific to the function
// that you are implementing. By defualt it takes data from ip-pattern
begin
  // assign output values to the neurons in the first (input) layer
  // which will act as inputs to the next layer in the network
  Layers[0].SetState(ip);
end;

procedure TMLPNetwork.MakeLayers(NTW: array of TLayerDesc);
var
  i: integer;
  l: TLayer;
begin
  for i:= Low(NTW) to High(NTW) do begin
    l:= TLayer.Create(Self);
    with NTW[i] do begin
      l.Setup(Neu, Kind);
    end;
  end;
end;

procedure TMLPNetwork.FeedForward;
var
  i: integer;
begin
  for i:= 1 to NumLay-1 do begin
    Layers[i].FeedForward(Layers[i-1]);
  end;
end;

procedure TMLPNetwork.CalcError(const op: TData);
// you can change this to assign outputs specific to the function
// that you are implementing. By defualt it takes data from op-pattern
begin
  // calc output-error values to the neurons in the last layer which
  // will act as inputs to the previous layer in the network
  Layers[-1].CalcError(op);
end;

procedure TMLPNetwork.BackPropagate;
var
  i: integer;
  LL: TLayer;
begin
  // while loop - calculates errors for neurons in output layer ideally this
  // should be an independent function since it can get quite complicated
  LL:= Layers[NumLay-1];
  for i:= 0 to LL.NumNeu-1 do begin
    with LL.Neurons[i] do begin
      Error:= dtf(Error);
    end;
  end;
  // calculate errors for hidden layers
  for i:= NumLay-2 downto 1 do begin
    Layers[i].BackPropagate(Layers[i+1]);
  end;
end;

procedure TMLPNetwork.AdjustWeights;
var
  i: integer;
begin
  for i:= 1 to NumLay-1 do begin
    Layers[i].AdjustWeights(Layers[i-1]);
  end;
end;

function TMLPNetwork.Prepare(What: TNetOper): boolean;
begin
  Result:= inherited;
  DoChange;
end;

procedure TMLPNetwork.Train;
var
  mqe: double;
  max_it: integer;
  maxerr, err: double;
  i: integer;
begin
  if not Prepare(noTrain) then exit;
  mqe:=  Parameters.Tol;
  max_it:= Options.Iterations;
  FEpochs:= 0;
  mqe:= sqr(mqe);
  Trained:= false;
  repeat
    inc(FEpochs);
    maxerr:= 0;
    for i:= 0 to DataIn.Count-1 do begin
      AssignInputs(DataIn[i]);
      FeedForward;
      CalcError(DataOut[i]);
      err:= Layers[-1].Error;
      if err > mqe then begin
        BackPropagate;
        AdjustWeights;
      end;
      if err > maxerr then maxerr:= err;
    end;
    if maxerr <= mqe then begin
      Trained:= true;
      break;
    end
  until (FEpochs > Max_it);
  if not Trained then begin
    raise EANNWarning.Create(wrnMaxIter);
  end
end;

procedure TMLPNetwork.Simul(const ip: TData; var op: TData);
begin
  AssignInputs(ip);
  FeedForward;
  Layers[-1].GetState(op);
end;

procedure TMLPNetwork.DoChange;
var
  i: integer;
begin
  for i:= 0 to NumLay-1 do begin
    Layers[i].UpdateParam;
  end;
  inherited;
end;

procedure TMLPNetwork.Assign(Source: TPersistent);
var
  i: integer;
  N: TMLPNetwork;
  L: TComponent;
begin
  if Source is TMLPNetwork then begin
    inherited;
    N:= TMLPNetwork(Source);
    Parameters.Assign(N.Parameters);
    FEpochs:= N.Epochs;
    for i:= NumLay-1 downto 0 do begin
      Layers[i].Free;
    end;
    for i:= 0 to N.NumLay-1 do begin
      L:= TComponentClass(N.Layers[i].ClassType).Create(Self);
      L.Assign(N.Layers[i]);
    end;
  end
  else inherited;
end;

procedure TMLPNetwork.Notification(AComponent: TComponent; Operation: TOperation);
var
  i: integer;
begin
  if AComponent.Owner = Self then begin
    if not (csLoading in ComponentState) then begin
      if not (AComponent is TLayer) then begin
        raise EANNStructure.Create(errBadNetDef);
      end;
      for i:= 0 to NumLay-1 do begin
        SetupConnections(i);
      end;
      if Operation = opInsert then begin
        TLayer(AComponent).UpdateParam;
      end;
    end;
  end;
end;

procedure TMLPNetwork.DataChange(What: TDataNotify);
begin
  inherited;
  if What = dnDimInp then begin
    if NumLay > 0 then SetupConnections(0);
  end;
end;

procedure TMLPNetwork.SetupConnections(LayerIndex: integer);
begin
  if (LayerIndex>=0) and (LayerIndex<NumLay) then begin
    Layers[LayerIndex].SetupConnections(GetConnections(LayerIndex));
    ResetTraining;
  end;
end;

function TMLPNetwork.GetConnections(LayerIndex: integer): integer;
begin
  if (LayerIndex>0) and (LayerIndex < NumLay) then begin
    Result:= Layers[LayerIndex-1].NumNeu;
  end
  else begin
    Result:= 0;
  end;
end;

procedure TMLPNetwork.SetParameters(vl: TMLPParameters);
begin
  FParameters.Assign(vl);
end;

function TMLPNetwork.GetLayer(I: integer): TLayer;
begin
  if i < 0 then i:= ComponentCount + i;
  Result:= TLayer(Components[I]);
end;

function TMLPNetwork.GetNumLay: integer;
begin
  Result:= ComponentCount;
end;

//--------------------------------------------------------------------------------------------------
initialization
  RegisterClasses([TNeuron, TLogisticNeuron, TLinearNeuron, TPerceptron]);
  RegisterClasses([TLayer]);
  RegisterClasses([TMLPParameters, TMLPNetwork]);
end.

