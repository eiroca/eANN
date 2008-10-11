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

Artificial Competitive Neural Network @br
@br
 This is an implementation of competitive artificial neural
@br
 History: @br
  1.00 First version @br
  1.01 Starting History's Log @br
  1.02 Sync with new ANN 1.12 @br
  2.00 Sync with new ANN 2.01 @br
  2.01 Simplified TCompetitor, TCompetitiveNetwork now persistent. @br
*)
unit eANNCom;

interface

uses
  SysUtils, Classes, eANN, eANNMsg, eANNUtil, eDataPick;

const
  errBadNetDef   = 'bad network definition';

type
  TCompetitor = class;
  TCustomCompetitiveNetwork = class;

  (* Competitor neuron of a Competive network *)
  TCompetitor = class(TComponent)
    public
     (* Returns the name of the competitor *)
     class function Description: string; virtual;
    private
     FCenter: TWeights;
     FEta   : double;
     FWinner: boolean;
    protected
     HasInp: boolean;
    protected
     procedure DataChange(What: TDataNotify); virtual;
     (* Store a competitor structure in a stream *)
     procedure SaveToStream(S: TStream); virtual;
     (* Load a competitor structure from a stream *)
     procedure LoadFromStream(S: TStream); virtual;
     procedure DefineProperties(Filer: TFiler); override;
    public
     (* Competitive neuron *)
     constructor Create(AOwner: TComponent); override;
     procedure   Assign(Source: TPersistent); override;
     (* Free memory that was assigned for the specified competitor structure *)
     destructor  Destroy; override;
    public
     procedure   UpdateParam; virtual;
     (* Assign random values to input centroid *)
     procedure   Reset; virtual;
     (* Update state of the input centroid accordin to input and winning state *)
     procedure   CentroidUpdate(const ip: TData); virtual;
     (* Compute distance between Input centroid and the given pattern *)
     function    CentroidDist(const ip: TData): double; virtual;
    public
     // center of the neuron
     property Center: TWeights read FCenter;
     // Eta of the neuron
     property Eta   : double   read FEta write FEta;
     // Is a winner?
     property Winner: boolean  read FWinner write FWinner;
  end;

  (* Competitor neuron of a Competive network with input and output *)
  TFullCompetitor = class(TCompetitor)
    public
     (* Returns the name of the competitor *)
     class function Description: string; override;
    private
     FOutput: TWeights;
    protected
     HasOut: boolean;
    protected
     procedure DataChange(What: TDataNotify); override;
     procedure SaveToStream(S: TStream); override;
     procedure LoadFromStream(S: TStream); override;
    public
     (* Competitive neuron *)
     constructor Create(AOwner: TComponent); override;
     procedure   Assign(Source: TPersistent); override;
     (* Free memory that was assigned for the specified competitor structure *)
     destructor  Destroy; override;
    public
     (* Assign random values to output centroid *)
     procedure   Reset; override;
     (* Update state of the output centroid accordin to input and winning state *)
     procedure   OutputUpdate(const op: TData); virtual;
     (* Compute distance between output centroid and the given pattern *)
     function    OutputDist(const op: TData): double; virtual;
    public
     property Output: TWeights read FOutput;
  end;

  TComParameters = class(TANNParam)
    public
     constructor Create(AOwner: TANN); override;
    private
     FEta: double;
     FNumNeu: integer;
    private
     procedure SetEta(vl: double);
     procedure SetNumNeu(vl: integer);
    published
     (* Learning constant *)
     property Eta: double read FEta write SetEta;
     (* Number of neuron(s) in the network *)
     property NumNeu: integer read FNumNeu write SetNumNeu;
  end;

  (* Build a Competitive Neural Network *)
  TCustomCompetitiveNetwork = class(TANN)
    protected
     class procedure Supply(var Op: TNetOpers); override;
    public
     (* Returns the name of the network *)
     class function Description: string; override;
    private
     FParameters: TComParameters;
     (* Last winning neuron *)
     OldWinner: TCompetitor;
    private
     procedure SetParameters(Prm: TComParameters);
     function  GetNeuron(i: integer): TCompetitor;
     function  GetNumNeu: integer;
     procedure SaveNeurons(S: TStream);
     procedure LoadNeurons(S: TStream);
    protected
     procedure UpdateParam;
     procedure MakeNeurons(aNumNeu: integer);
     function  Prepare(What: TNetOper): boolean; override;
     procedure DefineProperties(Filer: TFiler); override;
     procedure Notification(AComponent: TComponent; Operation: TOperation); override;
     procedure DataChange(What: TDataNotify); override;
    public
     (* Create a competitve network structure and its "competitors" *)
     constructor Create(AOwner: TComponent); override;
     procedure   Assign(Source: TPersistent); override;
     (* Free all memory that was assigned for the specified network structure *)
     destructor  Destroy; override;
    public
     procedure   Reset; override;
     (* Search winner neuron *)
     function    FindWinner(const p: TData): TCompetitor; virtual;
     procedure   Acquire(const ip: TData); override;
     function    BeginClusterization: boolean; override;
     function    FindCluster(const ip: TData): integer; override;
    public
     property Parameters: TComParameters read FParameters write SetParameters;
     (* Neuron(s) in the network *)
     property Neurons[i: integer]: TCompetitor read GetNeuron;
     (* Number of neuron(s) in the network *)
     property NumNeu: integer read GetNumNeu;
  end;

  TCompetitiveNetwork = class(TCustomCompetitiveNetwork)
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

class function TCompetitor.Description;
begin
  Result:= 'Competitive neuron';
end;

constructor TCompetitor.Create(AOwner: TComponent);
begin
  if (AOwner <> nil) and not (AOwner is TANN) then begin
    TANN.DoError(EANNNeuron, errNeuronError1);
  end;
  FCenter:= TWeights.Create(0);
  if Center = nil then TANN.DoError(EANNMemory, errOutOfMemory);
  inherited Create(AOwner);
  Eta:= 0.1;
  UpdateParam;
  Reset;
end;

procedure TCompetitor.Reset;
begin
  HasInp:= false;
  FWinner:= false;
end;

procedure TCompetitor.DataChange(What: TDataNotify);
begin
  if (What=dnDimInp) and (Owner <> nil) then begin
    Center.Dim:= TANN(Owner).DimInp;
  end;
end;

procedure TCompetitor.SaveToStream(S: TStream);
begin
  S.Write(FEta, SizeOf(FEta));
  S.Write(FWinner, SizeOf(FWinner));
  S.Write(HasInp, SizeOf(HasInp));
  Center.SaveToStream(S);
end;

procedure TCompetitor.LoadFromStream(S: TStream);
begin
  S.Read(FEta, SizeOf(FEta));
  S.Read(FWinner, SizeOf(FWinner));
  S.Read(HasInp, SizeOf(HasInp));
  Center.LoadFromStream(S);
end;

procedure TCompetitor.Assign(Source: TPersistent);
var
  C: TCompetitor;
begin
  if Source is TCompetitor then begin
    C:= TCompetitor(Source);
    Center.Assign(C.Center);
    HasInp:= C.HasInp;
    Eta:= C.Eta;
    Winner:= C.Winner;
  end
  else inherited Assign(Source);
end;

procedure TCompetitor.DefineProperties(Filer: TFiler);
begin
  Filer.DefineBinaryProperty('Data', LoadFromStream, SaveToStream, true);
  inherited DefineProperties(Filer);
end;

procedure TCompetitor.UpdateParam;
begin
  if (Owner<>nil) and (Owner is TCustomCompetitiveNetwork) then begin
    Eta:= TCustomCompetitiveNetwork(Owner).Parameters.Eta;
  end;
end;

procedure TCompetitor.CentroidUpdate(const ip: TData);
var
  i: integer;
begin
  with Center do begin
    if HasInp then begin
      for i:= 0 to Dim-1 do begin
        Weights[i]:= Weights[i] * (1-eta) + ip[i]*eta;
      end;
    end
    else begin
      SetWeights(ip);
      HasInp:= true;
    end;
  end;
end;

function TCompetitor.CentroidDist(const ip: TData): double;
begin
  if HasInp then begin
    Result:= Center.SqrDist(ip);
  end
  else begin
    Result:= 0;
  end;
end;

destructor TCompetitor.Destroy;
begin
  FCenter.Free;
  inherited Destroy;
end;

class function TFullCompetitor.Description;
begin
  Result:= 'Competitive neuron with output';
end;

constructor TFullCompetitor.Create(AOwner: TComponent);
begin
  FOutput:= TWeights.Create(0);
  if Output = nil then TANN.DoError(EANNMemory, errOutOfMemory);
  inherited Create(AOwner);
end;

procedure TFullCompetitor.Reset;
begin
  inherited Reset;
  HasOut:= false;
end;

procedure TFullCompetitor.DataChange(What: TDataNotify);
begin
  inherited DataChange(What);
  if (What=dnDimOut) and (Owner <> nil) then begin
    Output.Dim:= TANN(Owner).DimOut;
  end;
end;

procedure TFullCompetitor.SaveToStream(S: TStream);
begin
  inherited SaveToStream(S);
  S.Write(HasOut, SizeOf(HasOut));
  Output.SaveToStream(S);
end;

procedure TFullCompetitor.LoadFromStream(S: TStream);
begin
  inherited LoadFromStream(S);
  S.Read(HasOut, SizeOf(HasOut));
  Output.LoadFromStream(S);
end;

procedure TFullCompetitor.Assign(Source: TPersistent);
var
  C: TFullCompetitor;
begin
  if Source is TFullCompetitor then begin
    inherited Assign(Source);
    C:= TFullCompetitor(Source);
    Output.Assign(C.Output);
    HasOut:= C.HasOut;
  end
  else inherited Assign(Source);
end;

procedure TFullCompetitor.OutputUpdate(const op: TData);
var
  i: integer;
begin
  with Output do begin
    if HasOut then begin
      for i:= 0 to Dim-1 do begin
        Weights[i]:= Weights[i] * (1-eta) + op[i]*eta;
      end;
    end
    else begin
      Output.SetWeights(op);
      HasOut:= true;
    end;
  end;
end;

function TFullCompetitor.OutputDist(const op: TData): double;
begin
  if HasOut then begin
    Result:= Output.SqrDist(op);
  end
  else begin
    Result:= 0;
  end;
end;

destructor TFullCompetitor.Destroy;
begin
  FOutput.Free;
  inherited Destroy;
end;

constructor TComParameters.Create(AOwner: TANN);
begin
  inherited Create(AOwner);
  FEta:= 0.1;
  FNumNeu:= 1;
  Owner.Options.Iterations:= 30;
end;

procedure TComParameters.SetEta(vl: double);
begin
  if vl < 0.001 then vl:= 0.1;
  if vl <> FEta then begin
    FEta:= vl;
    with TCompetitiveNetwork(Owner) do begin
      BeginUpdate;
      Options.Iterations:= round(3/Eta);
      UpdateParam;
      Change;
      EndUpdate;
    end;
  end;
end;

procedure TComParameters.SetNumNeu(vl: integer);
begin
  if vl < 1 then vl:= 1;
  if vl <> FNumNeu then begin
    FNumNeu:= vl;
    Owner.Change;
  end;
end;

constructor TCustomCompetitiveNetwork.Create;
begin
  inherited Create(AOwner);
  SetNetInfos([]);
  FParameters:= TComParameters.Create(Self);
  OldWinner:= nil;
end;

function TCustomCompetitiveNetwork.Prepare(What: TNetOper): boolean;
begin
  Result:= inherited Prepare(What);
  if Result then begin
    MakeNeurons(Parameters.NumNeu);
  end;
end;

procedure TCustomCompetitiveNetwork.SaveNeurons(S: TStream);
var
  i, tmp: integer;
begin
  tmp:= NumNeu;
  S.Write(tmp, SizeOf(tmp));
  for i:= 0 to tmp-1 do begin
    S.WriteComponent(Neurons[i]);
  end;
  if OldWinner = nil then tmp:= -1
  else tmp:= OldWinner.ComponentIndex;
  S.Write(tmp, SizeOf(tmp));
end;

procedure TCustomCompetitiveNetwork.LoadNeurons(S: TStream);
var
  i, tmp: integer;
  C: TComponent;
begin
  S.Read(tmp, SizeOf(tmp));
  if tmp > 0 then begin
    for i:= 0 to tmp-1 do begin
      C:= S.ReadComponent(nil);
      InsertComponent(C);
    end;
  end;
  S.Read(tmp, SizeOf(tmp));
  if tmp = -1 then OldWinner:= nil
  else OldWinner:= Neurons[tmp];
end;

procedure TCustomCompetitiveNetwork.DefineProperties(Filer: TFiler);
begin
  Filer.DefineBinaryProperty('Neurons', LoadNeurons, SaveNeurons, NumNeu>0);
  inherited DefineProperties(Filer);
end;

procedure TCustomCompetitiveNetwork.Notification(AComponent: TComponent; Operation: TOperation);
var
  C: TCompetitor;
begin
  if AComponent.Owner = Self then begin
    if not (csLoading in ComponentState) then begin
      if Operation = opInsert then begin
        if not (AComponent is TCompetitor) then begin
          DoError(EANNStructure, errBadNetDef);
        end;
        C:= TCompetitor(AComponent);
        C.Center.Dim:= DimInp;
        C.UpdateParam;
        ResetTraining;
      end;
    end;
  end;
end;

procedure TCustomCompetitiveNetwork.DataChange(What: TDataNotify);
var
  i: integer;
begin
  inherited DataChange(What);
  for i:= 0 to NumNeu-1 do begin
    Neurons[i].DataChange(What);
  end;
end;

procedure TCustomCompetitiveNetwork.Assign(Source: TPersistent);
var
  i: integer;
  N: TCustomCompetitiveNetwork;
  C: TComponent;
begin
  if Source is TCustomCompetitiveNetwork then begin
    inherited Assign(Source);
    N:= TCustomCompetitiveNetwork(Source);
    Parameters:= N.Parameters;
    OldWinner:= N.OldWinner;
    for i:= NumNeu-1 downto 0 do begin
      Neurons[i].Free;
    end;
    for i:= 0 to N.NumNeu-1 do begin
      C:= TComponentClass(N.Neurons[i].ClassType).Create(Self);
      C.Assign(N.Neurons[i]);
    end;
  end
  else inherited Assign(Source);
end;

procedure TCustomCompetitiveNetwork.Reset;
var
  i: integer;
begin
  inherited Reset;
  for i:= NumNeu-1 downto 0 do begin
    Neurons[i].Free;
  end;
end;

function TCustomCompetitiveNetwork.GetNeuron(i: integer): TCompetitor;
begin
  Result:= TCompetitor(Components[i]);
end;

function TCustomCompetitiveNetwork.GetNumNeu: integer;
begin
  Result:= ComponentCount;
end;

procedure TCustomCompetitiveNetwork.UpdateParam;
var
  i: integer;
begin
  for i:= 0 to NumNeu-1 do begin
    Neurons[i].UpdateParam;
  end;
end;

function TCustomCompetitiveNetwork.BeginClusterization: boolean;
begin
  if DimInp < 1 then DoError(EANNGeneric, errBadNetDef);
  if NumNeu < 1 then DoError(EANNGeneric, errBadNetDef);
  Result:= inherited BeginClusterization;
end;

procedure TCustomCompetitiveNetwork.MakeNeurons(aNumNeu: integer);
var
  i: integer;
begin
  if aNumNeu > NumNeu then begin
    for i:= NumNeu to aNumNeu-1 do begin
      TCompetitor.Create(Self);
    end;
    ResetTraining;
  end
  else if aNumNeu < NumNeu then begin
    for i:= NumNeu-1 downto aNumNeu do begin
      Neurons[i].Free;
    end;
    ResetTraining;
  end;
end;

class function TCustomCompetitiveNetwork.Description;
begin
  Result:= 'Competitive Neural Network';
end;

class procedure TCustomCompetitiveNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noAcquire, noFindCluster, noReset];
  inherited Supply(Op);
end;

function TCustomCompetitiveNetwork.FindWinner(const p: TData): TCompetitor;
var
  MaxDist: double;
  idist: double;
  Cnt, i: integer;
begin
  if OldWinner <> nil then OldWinner.Winner:= false;
  Result:= nil;
  Cnt:= NumNeu;
  if Cnt > 0 then begin
    Result:= Neurons[0];
    if Cnt > 1 then begin
      MaxDist:= Result.CentroidDist(p);
      for i:= 1 to Cnt-1 do begin
        idist:= Neurons[i].CentroidDist(p);
        if idist < MaxDist then begin
          MaxDist:= idist;
          Result:= Neurons[i];
        end;
      end;
    end;
    Result.Winner:= true;
  end;
  OldWinner:= Result;
end;

function TCustomCompetitiveNetwork.FindCluster(const ip: TData): integer;
begin
  Result:= FindWinner(ip).ComponentIndex;
end;

procedure TCustomCompetitiveNetwork.Acquire(const ip: TData);
begin
  FindWinner(ip).CentroidUpdate(ip);
end;

procedure TCustomCompetitiveNetwork.SetParameters(Prm: TComParameters);
begin
  FParameters.Assign(Prm);
end;

destructor TCustomCompetitiveNetwork.Destroy;
begin
  FParameters.Free;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('Eic', [TCompetitiveNetwork]);
end;

initialization
  RegisterClass(TCompetitor);
  RegisterClass(TFullCompetitor);
  RegisterClass(TCompetitiveNetwork);
end.

