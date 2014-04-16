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
  System.SysUtils, System.Classes,
  eLibCore, eDataPick,
  eANNCore;

type
  TCompetitor = class;
  TCompetitorClass = class of TCompetitor;

  (* Competitor neuron of a Competive network *)
  TCompetitor = class(TStorable)
    public
     (* Returns the name of the competitor *)
     class function Description: string; virtual;
    private
     FHasCen: boolean;
     FCenter: TWeights;
    protected
     function  GetCenter: TWeights;
     procedure SetCenter(vl: TWeights);
     procedure DataChange(What: TDataNotify); virtual;
    public
     (* Competitive neuron *)
     constructor Create(AOwner: TComponent); override;
     (* Free memory that was assigned for the specified competitor structure *)
     destructor  Destroy; override;
    public
     procedure   Assign(Source: TPersistent); override;
    public
     (* Assign random values to input centroid *)
     procedure   Reset; virtual;
     (* Update state of the input centroid accordin to input and winning state *)
     procedure   CentroidUpdate(const ip: TData; eta: double); virtual;
     (* Compute distance between Input centroid and the given pattern *)
     function    CentroidDist(const ip: TData): double; virtual;
    published
     // Center is setted?
     property HasCenter: boolean
       read FHasCen
       write FHasCen;
     // Center of the neuron
     property Center: TWeights
       read GetCenter
       write SetCenter;
  end;

  (* Competitor neuron of a Competive network with input and output *)
  TFullCompetitor = class(TCompetitor)
    public
     (* Returns the name of the competitor *)
     class function Description: string; override;
    private
     FHasOut: boolean;
     FOutput: TWeights;
    protected
     function  GetOutput: TWeights;
     procedure SetOutput(vl: TWeights);
     procedure DataChange(What: TDataNotify); override;
    public
     (* Competitive neuron *)
     constructor Create(AOwner: TComponent); override;
     (* Free memory that was assigned for the specified competitor structure *)
     destructor  Destroy; override;
    public
     procedure   Assign(Source: TPersistent); override;
    public
     (* Assign random values to output centroid *)
     procedure   Reset; override;
     (* Update state of the output centroid accordin to input and winning state *)
     procedure   OutputUpdate(const op: TData; eta: double); virtual;
     (* Compute distance between output centroid and the given pattern *)
     function    OutputDist(const op: TData): double; virtual;
    published
     // Output is setted?
     property HasOutput: boolean
       read FHasOut
       write FHasOut;
     // Output of the neuron
     property Output: TWeights
       read GetOutput
       write SetOutput;

  end;

const
  defEta = 0.1;
  defMaxNeu = 1;

type
  TCompetitiveParameters = class(TStorable)
    private
     FEta: double;
     FMaxNeu: integer;
    protected
     procedure SetEta(vl: double);
     procedure SetMaxNeu(vl: integer);
    public
     constructor Create(AOwner: TComponent); override;
    public
     (* Deep copy of the network *)
     procedure   Assign(Source: TPersistent); override;
    published
     (* Learning constant *)
     property Eta: double
       read FEta
       write SetEta;
     (* Number of neuron(s) in the network *)
     property MaxNeu: integer
       read FMaxNeu
       write SetMaxNeu;
  end;

  (* Build a Competitive Neural Network *)
  TCompetitiveNetwork = class(TANN)
    protected
     class procedure Supply(var Op: TNetOpers); override;
    public
     (* Returns the name of the network *)
     class function Description: string; override;
    private
     (* Last winning neuron *)
     FParameters: TCompetitiveParameters;
    private
     function  GetNeuron(i: integer): TCompetitor;
     function  GetNumNeu: integer;
     procedure SetParameters(vl: TCompetitiveParameters);
    protected
     procedure MakeNeurons(aNumNeu: integer);
     function  Prepare(What: TNetOper): boolean; override;
     procedure Notification(AComponent: TComponent; Operation: TOperation); override;
     procedure DataChange(What: TDataNotify); override;
    public
     (* Create a competitve network structure and its "competitors" *)
     constructor Create(AOwner: TComponent); override;
     (* Free all memory that was assigned for the specified network structure *)
     destructor  Destroy; override;
    public
     procedure   Assign(Source: TPersistent); override;
    public
     procedure   Reset; override;
     (* Search winner neuron *)
     function    FindWinner(const p: TData): TCompetitor; virtual;
     procedure   Acquire(const ip: TData); override;
     function    BeginClusterization: boolean; override;
     function    FindCluster(const ip: TData): integer; override;
    public
     (* Neuron(s) in the network *)
     property Neurons[i: integer]: TCompetitor read GetNeuron;
     (* Number of neuron(s) in the network *)
     property NumNeu: integer read GetNumNeu;
    published
     property Parameters: TCompetitiveParameters
       read FParameters
       write SetParameters;
  end;

implementation

//--------------------------------------------------------------------------------------------------
class function TCompetitor.Description;
begin
  Result:= 'Competitive neuron';
end;

constructor TCompetitor.Create(AOwner: TComponent);
begin
  if (AOwner <> nil) and not (AOwner is TANN) then begin
    raise EANNNeuron.Create(errNeuronError1);
  end;
  FCenter:= TWeights.Create(nil);
  Reset;
  inherited;
end;

destructor TCompetitor.Destroy;
begin
  FreeAndNil(FCenter);
  inherited;
end;

function TCompetitor.GetCenter: TWeights;
begin
  Result:= FCenter;
end;

procedure TCompetitor.SetCenter(vl: TWeights);
begin
  Center.Assign(vl);
end;

procedure TCompetitor.Reset;
begin
  HasCenter:= false;
end;

procedure TCompetitor.DataChange(What: TDataNotify);
begin
  if (What=dnDimInp) and (Owner <> nil) then begin
    Center.Size:= TANN(Owner).DimInp;
  end;
end;

procedure TCompetitor.Assign(Source: TPersistent);
var
  C: TCompetitor;
begin
  if Source is TCompetitor then begin
    C:= TCompetitor(Source);
    Center:= C.Center;
    HasCenter:= C.HasCenter;
  end
  else inherited;
end;

procedure TCompetitor.CentroidUpdate(const ip: TData; eta: double);
var
  i: integer;
begin
  with Center do begin
    if HasCenter then begin
      for i:= 0 to Size-1 do begin
        Data[i]:= Data[i] * (1-eta) + ip[i]*eta;
      end;
    end
    else begin
      SetWeights(ip);
      HasCenter:= true;
    end;
  end;
end;

function TCompetitor.CentroidDist(const ip: TData): double;
begin
  if HasCenter then begin
    Result:= Center.SqrDist(ip);
  end
  else begin
    Result:= 0;
  end;
end;

//--------------------------------------------------------------------------------------------------
class function TFullCompetitor.Description;
begin
  Result:= 'Competitive neuron with output';
end;

constructor TFullCompetitor.Create(AOwner: TComponent);
begin
  FOutput:= TWeights.Create(nil);
  inherited;
end;

destructor TFullCompetitor.Destroy;
begin
  FreeAndNil(FOutput);
  inherited;
end;

function TFullCompetitor.GetOutput: TWeights;
begin
  FOutput:= TWeights(CheckCreate(FOutput, TWeights));
  Result:= FOutput;
end;

procedure TFullCompetitor.SetOutput(vl: TWeights);
begin
  Output.Assign(vl);
end;

procedure TFullCompetitor.Reset;
begin
  inherited;
  HasOutput:= false;
end;

procedure TFullCompetitor.DataChange(What: TDataNotify);
begin
  inherited;
  if (What=dnDimOut) and (Owner <> nil) then begin
    Output.Size:= TANN(Owner).DimOut;
  end;
end;

procedure TFullCompetitor.Assign(Source: TPersistent);
var
  C: TFullCompetitor;
begin
  if Source is TFullCompetitor then begin
    inherited;
    C:= TFullCompetitor(Source);
    Output:= C.Output;
    HasOutput:= C.HasOutput;
  end
  else inherited;
end;

procedure TFullCompetitor.OutputUpdate(const op: TData; eta: double);
var
  i: integer;
begin
  with Output do begin
    if HasOutput then begin
      for i:= 0 to Size-1 do begin
        Data[i]:= Data[i] * (1-eta) + op[i]*eta;
      end;
    end
    else begin
      Output.SetWeights(op);
      HasOutput:= true;
    end;
  end;
end;

function TFullCompetitor.OutputDist(const op: TData): double;
begin
  if HasOutput then begin
    Result:= Output.SqrDist(op);
  end
  else begin
    Result:= 0;
  end;
end;

//--------------------------------------------------------------------------------------------------
constructor TCompetitiveParameters.Create(AOwner: TComponent);
begin
  inherited;
  FEta:= defEta;
  FMaxNeu:= defMaxNeu;
end;

procedure TCompetitiveParameters.Assign(Source: TPersistent);
var
  P: TCompetitiveParameters;
begin
  if Source is TCompetitiveParameters then begin
    P:= TCompetitiveParameters(Source);
    Eta:= P.Eta;
    MaxNeu:= P.MaxNeu;
  end
  else inherited;
end;

procedure TCompetitiveParameters.SetEta(vl: double);
begin
  if vl < 0.001 then vl:= defEta;
  FEta:= vl;
end;

procedure TCompetitiveParameters.SetMaxNeu(vl: integer);
begin
  if vl < 1 then vl:= 1;
  FMaxNeu:= vl;
end;

//--------------------------------------------------------------------------------------------------
class function TCompetitiveNetwork.Description;
begin
  Result:= 'Competitive Neural Network';
end;

class procedure TCompetitiveNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noAcquire, noFindCluster, noReset];
  inherited;
end;

constructor TCompetitiveNetwork.Create;
begin
  inherited;
  FParameters:= TCompetitiveParameters.Create(nil);
  Options.Iterations:= 30;
  SetNetInfos([]);
end;

destructor TCompetitiveNetwork.Destroy;
begin
  FParameters.Free;
  inherited;
end;

procedure TCompetitiveNetwork.SetParameters(vl: TCompetitiveParameters);
begin
  FParameters.Assign(vl);
end;

function TCompetitiveNetwork.Prepare(What: TNetOper): boolean;
var
  iter: integer;
begin
  Result:= inherited;
  if Result then begin
    MakeNeurons(Parameters.MaxNeu);
  end;
  iter:= round(3/Parameters.Eta);
  if (Options.Iterations<iter) then Options.Iterations:= iter;
end;

procedure TCompetitiveNetwork.Notification(AComponent: TComponent; Operation: TOperation);
var
  C: TCompetitor;
begin
  if AComponent.Owner = Self then begin
    if not (csLoading in ComponentState) then begin
      if Operation = opInsert then begin
        if not (AComponent is TCompetitor) then begin
          EANNStructure.Create(errBadNetDef);
        end;
        C:= TCompetitor(AComponent);
        C.Center.Size:= DimInp;
        ResetTraining;
      end;
    end;
  end;
end;

procedure TCompetitiveNetwork.DataChange(What: TDataNotify);
var
  i: integer;
begin
  inherited;
  for i:= 0 to NumNeu-1 do begin
    Neurons[i].DataChange(What);
  end;
end;

procedure TCompetitiveNetwork.Assign(Source: TPersistent);
var
  i: integer;
  N: TCompetitiveNetwork;
  C: TComponent;
begin
  if Source is TCompetitiveNetwork then begin
    inherited;
    N:= TCompetitiveNetwork(Source);
    Parameters:= N.Parameters;
    for i:= NumNeu-1 downto 0 do begin
      Neurons[i].Free;
    end;
    for i:= 0 to N.NumNeu-1 do begin
      C:= TComponentClass(N.Neurons[i].ClassType).Create(Self);
      C.Assign(N.Neurons[i]);
    end;
  end
  else inherited;
end;

procedure TCompetitiveNetwork.Reset;
var
  i: integer;
begin
  inherited;
  for i:= NumNeu-1 downto 0 do begin
    Neurons[i].Free;
  end;
end;

function TCompetitiveNetwork.GetNeuron(i: integer): TCompetitor;
begin
  Result:= TCompetitor(Components[i]);
end;

function TCompetitiveNetwork.GetNumNeu: integer;
begin
  Result:= ComponentCount;
end;

function TCompetitiveNetwork.BeginClusterization: boolean;
begin
  if DimInp < 1 then raise EANNGeneric.Create(errBadNetDef);
  if NumNeu < 1 then raise EANNGeneric.Create(errBadNetDef);
  Result:= inherited;
end;

procedure TCompetitiveNetwork.MakeNeurons(aNumNeu: integer);
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

function TCompetitiveNetwork.FindWinner(const p: TData): TCompetitor;
var
  MaxDist: double;
  idist: double;
  Cnt, i: integer;
begin
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
  end;
end;

function TCompetitiveNetwork.FindCluster(const ip: TData): integer;
begin
  Result:= FindWinner(ip).ComponentIndex;
end;

procedure TCompetitiveNetwork.Acquire(const ip: TData);
begin
  FindWinner(ip).CentroidUpdate(ip, Parameters.Eta);
end;

//--------------------------------------------------------------------------------------------------
initialization
  RegisterClasses([TCompetitor, TFullCompetitor]);
  RegisterClasses([TCompetitiveParameters, TCompetitiveNetwork]);
end.

