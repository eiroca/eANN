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
  Classes, SysUtils, eANNCore, eANNUtil, eANNMsg, eDataPick;

type
  TLayer = class;

  TNeuronClass = class of TNeuron;

  (* Definition of neuron *)
  TNeuron = class(TComponent)
    private
     FState: double;
     FError: double;
     FBias : double;
     FW    : TWeights;
     FullSave: boolean;
    public
     (* Returns the name of the neuron *)
     class function Description: string; virtual;
    private
     function  GetNeuronIndex: integer;
     function  GetWeights: TData;
     function  GetWeightCount: integer;
     procedure SetWeightCount(vl: integer);
    protected
     procedure   DefineProperties(Filer: TFiler); override;
     procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    public
     (* Create a neuron structure with (wpn) weights per neuron *)
     constructor Create(AOwner: TComponent); override;
     procedure   SaveToStream(S: TStream); virtual;
     procedure   LoadFromStream(S: TStream); virtual;
     procedure   Assign(Source: TPersistent); override;
     (* Free all memory that was assigned for the specified neuron structure *)
     destructor  Destroy; override;
    public
     (* Compute output-error of then neuron according to target y *)
     procedure   CalcError(const y: double); virtual;
     (* funzione trasferimento sigmoidale *)
     function    tf(v: double): double; virtual; abstract;
     function    dtf(v: double): double; virtual; abstract;
    public
     (* The weights in this neuron *)
     property Weights: TData read GetWeights;
     (* Number of weights *)
     property NumWei: integer read GetWeightCount write SetWeightCount;
     property NeuronIndex: integer read GetNeuronIndex;
    published
     (* The output of this neuron *)
     property State: double read FState write FState;
     (* The error of this neuron *)
     property Error: double read FError write FError;
     property Bias : double read FBias  write FBias;
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

  (* Definition of a layer (set of neurons) *)
  TLayer = class(TComponent)
    protected
     LC  : double;
     MC  : double;
     Norm: boolean;
     Delta: TWeights_List;
     FullSave: boolean;
    public
     (* Returns the name of the layer *)
     class function Description: string; virtual;
    private
     function    GetNeuron(I: integer): TNeuron;
     function    GetNumNeu: integer;
     function    GetLayerIndex: integer;
     procedure   NeuronWeightCountChange(I: integer);
    protected
     procedure   DefineProperties(Filer: TFiler); override;
     procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
     procedure   SetupConnections(NeuronInPrevLayer: integer);
    public
     constructor Create(AOwner: TComponent); override;
     procedure   SaveToStream(S: TStream);
     procedure   LoadFromStream(S: TStream);
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
     (* Free all memory that was assigned for the specified layer structure *)
     destructor  Destroy; override;
    public
     property Neurons[i: integer]: TNeuron read GetNeuron;
     property NumNeu: integer read GetNumNeu;
     property LayerIndex: integer read GetLayerIndex;
  end;

  TMLPParameters = class(TANNParam)
    private
     FLC  : double;
     FMC  : double;
     FTol : double;
     FNorm: boolean;
    public
     constructor Create(AOwner: TANN); override;
    private
     procedure SetLC(vl: double);
     procedure SetMC(vl: double);
     procedure SetTol(vl: double);
     procedure SetNorm(vl: boolean);
    published
     property LC : double read FLC  write SetLC;
     property MC : double read FMC  write SetMC;
     property Tol: double read FTol write SetTol;
     property Normalize: boolean read FNorm write SetNorm;
  end;

type
  TLayerDesc = record
    Neu: integer;
    Kind: TNeuronClass;
  end;

type
  (* Build a Multi Layer Network according to the layer description, in first
  layer neurons are only a input-buffer - no weights and transfer function - *)
  TCustomMLPNetwork = class(TANN)
    protected
     (* Returns operation(s) supported by the network
     @param  Op  Supported Operation set *)
     class procedure Supply(var Op: TNetOpers); override;
    public
     (* Returns the name of the network *)
     class function Description: string; override;
    private
     FParameters: TMLPParameters;
     FEpochs: longint;
    private
     procedure SetParameters(Prm: TMLPParameters);
     procedure SaveLayers(S: TStream);
     procedure LoadLayers(S: TStream);
    protected
     function    GetLayer(I: integer): TLayer;
     function    GetNumLay: integer;
     procedure   UpdateParam;
     function    GetConnections(LayerIndex: integer): integer;
     procedure   SetupConnections(LayerIndex: integer);
     procedure   DefineProperties(Filer: TFiler); override;
     procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
     procedure   DataChange(What: TDataNotify); override;
    public
     (* Create a network structure and its layers *)
     constructor Create(AOwner: TComponent); override;
     procedure   Assign(Source: TPersistent); override;
     procedure   AssignInputs(const ip: TData); virtual;
     (* fast layers builder *)
     procedure MakeLayers(NTW: array of TLayerDesc);
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
     property Parameters: TMLPParameters read FParameters write SetParameters;
     property Epochs: longint read FEpochs;
     (* Array storing the number of neurons for each layer *)
     property Layers[i: integer]: TLayer read GetLayer;
     (* Number of layers *)
     property NumLay: integer read GetNumLay;
  end;

  TMLPNetwork = class(TCustomMLPNetwork)
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

class function TNeuron.Description: string;
begin
  Result:= 'Generic neuron';
end;

constructor TNeuron.Create(AOwner: TComponent);
begin
  FW:= TWeights.Create(0);
  if (AOwner <> nil) and not (AOwner is TLayer) then begin
    TANN.DoError(EANNNeuron, errNeuronError1);
  end;
  inherited Create(AOwner);
  FullSave:= true;
  FState:= 0.0;
  FError:= 0.0;
  FBias:= random - 0.5;
end;

function TNeuron.GetWeights: TData;
begin
  Result:= FW.Weights;
end;

function TNeuron.GetWeightCount: integer;
begin
  Result:= FW.Dim;
end;

function TNeuron.GetNeuronIndex: integer;
begin
  Result:= ComponentIndex;
end;

procedure TNeuron.SetWeightCount(vl: integer);
begin
  if vl <> FW.Dim then begin
    FW.Dim:= vl;
    FW.Randomize(-0.5, +0.5);
    if Owner <> nil then begin
      TLayer(Owner).NeuronWeightCountChange(NeuronIndex);
    end;
  end;
end;

procedure TNeuron.SaveToStream(S: TStream);
begin
  if FullSave then begin
    S.Write(FState, SizeOf(FState));
    S.Write(FError, SizeOf(FError));
    S.Write(FBias,  SizeOf(FBias));
  end;
  FW.SaveToStream(S);
end;

procedure TNeuron.LoadFromStream(S: TStream);
begin
  if FullSave then begin
    S.Read(FState, SizeOf(FState));
    S.Read(FError, SizeOf(FError));
    S.Read(FBias,  SizeOf(FBias));
  end;
  FW.LoadFromStream(S);
end;

procedure TNeuron.DefineProperties(Filer: TFiler);
begin
  FullSave:= false;
  try
    Filer.DefineBinaryProperty('Weights', LoadFromStream, SaveToStream, true);
  finally
    FullSave:= true;
  end;
  inherited DefineProperties(Filer);
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
    FW.Assign(N.FW);
  end
  else inherited Assign(Source);
end;

procedure TNeuron.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if AComponent.Owner = Self then begin
    TANN.DoError(EANNNeuron, errNeuronError2);
  end;
end;

procedure TNeuron.CalcError;
begin
  Error:= y - State;
end;

destructor TNeuron.Destroy;
begin
  FW.Free;
  inherited Destroy;
end;

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

class function  TLayer.Description;
begin
  Result:= 'Normal Layer';
end;

constructor TLayer.Create(AOwner: TComponent);
begin
  if (AOwner <> nil) and not (AOwner is TCustomMLPNetwork) then begin
    TANN.DoError(EANNLayer, errLayerError1);
  end;
  inherited Create(AOwner);
  FullSave:= true;
  if (aOwner=nil) then begin
    LC:= 0.5;
    MC:= 0;
    Norm:= false;
    Delta:= nil;
  end;
  UpdateParam;
end;

procedure TLayer.SetupConnections(NeuronInPrevLayer: integer);
var
  i: integer;
begin
  for i:= 0 to NumNeu-1 do begin
    Neurons[i].NumWei:= NeuronInPrevLayer;
  end;
end;

procedure TLayer.Notification(AComponent: TComponent; Operation: TOperation);
var
  N: TNeuron;
begin
  if AComponent.Owner = Self then begin
    if not (AComponent is TNeuron) then begin
      TANN.DoError(EANNLayer, errLayerError2);
    end;
    N:= TNeuron(AComponent);
    if Operation = opInsert then begin
      if Delta <> nil then begin
        Delta.Insert(N.NeuronIndex, TWeights.Create(N.NumWei));
      end;
      if Owner <> nil then begin
        N.NumWei:= TCustomMLPNetwork(Owner).GetConnections(LayerIndex);
        TCustomMLPNetwork(Owner).SetupConnections(LayerIndex+1);
      end;
    end
    else begin
      if Delta <> nil then begin
        Delta.Delete(N.NeuronIndex);
      end;
    end;
  end;
end;

procedure TLayer.NeuronWeightCountChange(I: integer);
begin
  if Delta <> nil then begin
    Delta[i].Dim:= Neurons[i].NumWei;
  end;
end;

procedure TLayer.SaveToStream(S: TStream);
var
  i, tmp: integer;
begin
  if FullSave then begin
    S.Write(LC, SizeOf(LC));
    S.Write(MC, SizeOf(MC));
    S.Write(Norm, SizeOf(Norm));
  end;
  tmp:= NumNeu;
  S.Write(tmp, SizeOf(tmp));
  for i:= 0 to tmp-1 do begin
    S.WriteComponent(Neurons[i]);
  end;
  if Delta=nil then tmp:= 0;
  S.Write(tmp, SizeOf(tmp));
  for i:= 0 to tmp-1 do begin
    Delta[i].SaveToStream(S);
  end;
end;

procedure TLayer.LoadFromStream(S: TStream);
var
  i, tmp: integer;
  N: TComponent;
begin
  if FullSave then begin
    S.Read(LC, SizeOf(LC));
    S.Read(MC, SizeOf(MC));
    S.Read(Norm, SizeOf(Norm));
  end;
  if Delta <> nil then begin
    Delta.Free;
    Delta:= nil;
  end;
  S.Read(tmp, SizeOf(tmp));
  for i:= 0 to tmp-1 do begin
    N:= S.ReadComponent(nil);
    InsertComponent(N);
  end;
  S.Read(tmp, SizeOf(tmp));
  if tmp > 0 then begin
    Delta:= TWeights_List.Create;
    for i:= 0 to tmp-1 do begin
      Delta.Insert(i, TWeights.Create(0));
      Delta[i].LoadFromStream(S);
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
    LC  := L.LC;
    MC  := L.MC;
    Norm:= L.Norm;
    if Delta <> nil then begin
      for i:= Delta.Count-1 downto 0 do begin
        Delta[i].Free;
        Delta.Delete(i);
      end;
    end;
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
        N.NumWei:= TCustomMLPNetwork(Owner).GetConnections(ComponentIndex)
      end;
    end;
  end
  else begin
    inherited Assign(Source);
  end;
end;

procedure TLayer.DefineProperties(Filer: TFiler);
begin
  FullSave:= false;
  try
    Filer.DefineBinaryProperty('Neurons', LoadFromStream, SaveToStream, NumNeu>0);
  finally
    FullSave:= true;
  end;
  inherited DefineProperties(Filer);
end;

procedure TLayer.UpdateParam;
var
  Net: TCustomMLPNetwork;
  HasDelta : boolean;
  NeedDelta: boolean;
  i: integer;
  W: TWeights;
  NuWe: integer;
begin
  if Owner <> nil then begin
    Net:= TCustomMLPNetwork(Owner);
    LC:= Net.Parameters.LC;
    Norm:= Net.Parameters.Normalize;
    HasDelta:= Delta<>nil;
    NeedDelta:= Net.Parameters.MC<>0;
    if HasDelta and not NeedDelta then begin
      Delta.Free;
      Delta:= nil;
    end;
    if NeedDelta then begin
      if not HasDelta then begin
        Delta:= TWeights_List.Create;
      end;
      if (Delta.Count <> NumNeu) then begin
        Delta.Count:= NumNeu;
      end;
      for i:= 0 to NumNeu-1 do begin
        W:= Delta[i];
        NuWe:= Neurons[i].NumWei;
        if (W = nil) then begin
          W:= TWeights.Create(NuWe);
          Delta[i]:= W;
        end;
        W.Dim:= NuWe;
      end;
    end;
    MC:= Net.Parameters.MC;
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
    for i:= 0 to N.NumWei-1 do begin
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
  W: TWeights;
  i, j, k: integer;
  nrm: double;
begin
  if Norm then begin
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
    for k:= 0 to NumNeu-1 do begin
      N:= Neurons[k];
      N.Bias:= N.Bias + (LC * N.Error);
      // the number of neurons in the previous layer is
      // the number of weights in the neurons of this layer
      for i:= 0 to N.NumWei-1 do begin
        N.Weights[i]:= N.Weights[i] + (LC * PL.Neurons[i].State * nrm * N.Error) ;
      end;
    end;
  end
  else begin
    for j:= 0 to NumNeu-1 do begin
      W:= Delta[j];
      // Compute delta weights of then neurons 
      for i:= 0 to W.Dim-1 do begin
        W.Weights[i]:= MC * W.Weights[i] + (1-MC)*(LC * PL.Neurons[i].State * nrm * Error);
      end;
      N:= Neurons[j];
      N.Bias:= N.Bias + (LC * Error);
      for i:= 0 to N.NumWei-1 do begin
        N.Weights[i]:= N.Weights[i] + Delta[j].Weights[i];
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
  Delta.Free;
  inherited Destroy;
end;

constructor TMLPParameters.Create(AOwner: TANN);
begin
  inherited Create(AOwner);
  FLC:= 0.1;
  FMC:= 0.5;
  FTol:= 0.01;
  FNorm:= false;
end;

procedure TMLPParameters.SetLC (vl: double);
begin
  if vl < 0 then vl:= 0.1;
  if vl <> FLC then begin
    FLC:= vl;
    Owner.Change;
  end;
end;

procedure TMLPParameters.SetMC (vl: double);
begin
  if (vl < 0) then vl:= 0
  else if (vl>1) then vl:= 1;
  if vl <> FMC then begin
    FMC:= vl;
    TCustomMLPNetwork(Owner).UpdateParam;
    Owner.Change;
  end;
end;

procedure TMLPParameters.SetTol(vl: double);
begin
  if vl < 0 then vl:= 0.01;
  if vl <> FTol then begin
    FTol:= vl;
    TCustomMLPNetwork(Owner).UpdateParam;
    Owner.Change;
  end;
end;

procedure TMLPParameters.SetNorm(vl: boolean);
begin
  if vl <> FNorm then begin
    FNorm:= vl;
    TCustomMLPNetwork(Owner).UpdateParam;
    Owner.Change;
  end;
end;

constructor TCustomMLPNetwork.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParameters:= TMLPParameters.Create(Self);
  SetNetInfos([niSuper]);
  Options.Iterations:= 1000;
end;

class function TCustomMLPNetwork.Description;
begin
  Result:= 'Multi Layer Neural Network';
end;

class procedure TCustomMLPNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noTrain, noSimul];
  inherited Supply(Op);
end;

procedure TCustomMLPNetwork.AssignInputs(const ip: TData);
// you can change this to assign inputs specific to the function
// that you are implementing. By defualt it takes data from ip-pattern
begin
  // assign output values to the neurons in the first (input) layer
  // which will act as inputs to the next layer in the network
  Layers[0].SetState(ip);
end;

procedure TCustomMLPNetwork.MakeLayers(NTW: array of TLayerDesc);
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

procedure TCustomMLPNetwork.FeedForward;
var
  i: integer;
begin
  for i:= 1 to NumLay-1 do begin
    Layers[i].FeedForward(Layers[i-1]);
  end;
end;

procedure TCustomMLPNetwork.CalcError(const op: TData);
// you can change this to assign outputs specific to the function
// that you are implementing. By defualt it takes data from op-pattern
begin
  // calc output-error values to the neurons in the last layer which
  // will act as inputs to the previous layer in the network
  Layers[-1].CalcError(op);
end;

procedure TCustomMLPNetwork.BackPropagate;
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

procedure TCustomMLPNetwork.AdjustWeights;
var
  i: integer;
begin
  for i:= 1 to NumLay-1 do begin
    Layers[i].AdjustWeights(Layers[i-1]);
  end;
end;

procedure TCustomMLPNetwork.Train;
var
  mqe: double;
  max_it: longint;
  maxerr, err: double;
  i: integer;
  trained: boolean;
begin
  if not Prepare(noTrain) then exit;
  mqe:= Parameters.tol;
  max_it:= Options.Iterations;
  FEpochs:= 0;
  mqe:= sqr(mqe);
  trained:= false;
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
      trained:= true;
      break;
    end
  until (FEpochs > Max_it);
  SetNetInfos(NetInfos + [niTrained]);
  if not trained then begin
    raise EANNWarning.Create(wrnMaxIter);
  end
end;

procedure TCustomMLPNetwork.Simul(const ip: TData; var op: TData);
begin
  AssignInputs(ip);
  FeedForward;
  Layers[-1].GetState(op);
end;

procedure TCustomMLPNetwork.SetParameters(Prm: TMLPParameters);
begin
  FParameters.Assign(Prm);
end;

procedure TCustomMLPNetwork.UpdateParam;
var
  i: integer;
begin
  for i:= 0 to NumLay-1 do begin
    Layers[i].UpdateParam;
  end;
end;

procedure TCustomMLPNetwork.Assign(Source: TPersistent);
var
  i: integer;
  N: TCustomMLPNetwork;
  L: TComponent;
begin
  if Source is TCustomMLPNetwork then begin
    inherited Assign(Source);
    N:= TCustomMLPNetwork(Source);
    Parameters:= N.Parameters;
    FEpochs:= N.Epochs;
    for i:= NumLay-1 downto 0 do begin
      Layers[i].Free;
    end;
    for i:= 0 to N.NumLay-1 do begin
      L:= TComponentClass(N.Layers[i].ClassType).Create(Self);
      L.Assign(N.Layers[i]);
    end;
  end
  else inherited Assign(Source);
end;

procedure TCustomMLPNetwork.SaveLayers(S: TStream);
var
  i, tmp: integer;
begin
  tmp:= NumLay;
  S.Write(tmp, SizeOf(tmp));
  for i:= 0 to tmp-1 do begin
    S.WriteComponent(Layers[i]);
  end;
end;

procedure TCustomMLPNetwork.LoadLayers(S: TStream);
var
  i, tmp: integer;
  L: TComponent;
begin
  S.Read(tmp, SizeOf(tmp));
  if tmp > 0 then begin
    for i:= 0 to tmp-1 do begin
      L:= S.ReadComponent(nil);
      InsertComponent(L);
    end;
  end;
end;

procedure TCustomMLPNetwork.DefineProperties(Filer: TFiler);
begin
  Filer.DefineBinaryProperty('Layers', LoadLayers, SaveLayers, NumLay>0);
  inherited DefineProperties(Filer);
end;

procedure TCustomMLPNetwork.Notification(AComponent: TComponent; Operation: TOperation);
var
  i: integer;
begin
  if AComponent.Owner = Self then begin
    if not (csLoading in ComponentState) then begin
      if not (AComponent is TLayer) then begin
        DoError(EANNStructure, errBadNetDef);
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

procedure TCustomMLPNetwork.DataChange(What: TDataNotify);
begin
  inherited DataChange(What);
  if What = dnDimInp then begin
    if NumLay > 0 then SetupConnections(0);
  end;
end;

procedure TCustomMLPNetwork.SetupConnections(LayerIndex: integer);
begin
  if (LayerIndex>=0) and (LayerIndex<NumLay) then begin
    Layers[LayerIndex].SetupConnections(GetConnections(LayerIndex));
    ResetTraining;
  end;
end;

function TCustomMLPNetwork.GetConnections(LayerIndex: integer): integer;
begin
  if (LayerIndex>0) and (LayerIndex < NumLay) then begin
    Result:= Layers[LayerIndex-1].NumNeu;
  end
  else begin
    Result:= 0;
  end;
end;

function TCustomMLPNetwork.GetLayer(I: integer): TLayer;
begin
  if i < 0 then i:= ComponentCount + i;
  Result:= TLayer(Components[I]);
end;

function TCustomMLPNetwork.GetNumLay: integer;
begin
  Result:= ComponentCount;
end;

destructor TCustomMLPNetwork.Destroy;
begin
  FParameters.Free;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents(COMPONENT_PALETTE, [TMLPNetwork]);
end;

initialization
  RegisterClass(TNeuron);
  RegisterClass(TLogisticNeuron);
  RegisterClass(TLinearNeuron);
  RegisterClass(TPerceptron);
  RegisterClass(TLayer);
  RegisterClass(TMLPNetwork);
end.

