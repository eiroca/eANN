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

Artificial Progressive Learning Neural Network @br
@br
This is an implementation of Progressive Learning neural network
@br
History: @br
  1.00 First version @br
  1.01 Starting History's Log @br
  1.02 Sync with new ANN 1.12 @br
  2.00 Sync with new ANN 2.01 @br
  2.01 Simplified TPLElem, TPLNetwork now persistent. @br
@br
@todo  Improves sorting using heap sort
*)
unit eANNPLN;

interface

uses
  System.Classes, System.SysUtils,
  eANNCore, eANNCom,
  eLibCore, eLibMath, eDataPick;

type

  TPLNElem = class;

  IndexElem = record
    Com: TPLNElem;
    Dist: double;
  end;

  Index = array of IndexElem;

  (* Definition of Progressive Learning Network Element *)
  TPLNElem = class(TFullCompetitor)
    public
     (* Returns the name of the PLNElem *)
     class function Description: string; override;
    private
     FAge: double;
    protected
     function    GetSpread: double;
    public
     constructor Create(AOwner: TComponent); override;
     procedure   Assign(Source: TPersistent); override;
     (* Update state of the input centroid accordin to input *)
     procedure   CentroidUpdate(const p: TData; eta: double); override;
     (* Update state of the output centroid accordin to input *)
     procedure   OutputUpdate(const p: TData; eta: double); override;
     (* Update Age *)
     procedure   AddSpread(Spread: double); virtual;
    public
     property Spread: double
       read GetSpread;
    published
     property Age: double
       read FAge
       write FAge;
  end;

const
  defRoI = 1;
  defRoO = 1;
  defEta = 0.01;
  defSpread = 1;
  defEps = 0;
  defLmd = 1;
  defWin = 1;

type
  TPLParameters = class(TStorable)
    private
     FRoI: double;
     FRoO: double;
     FEta: double;
     FSpr: double;
     FEps: double;
     FLmd: double;
     FWin: integer;
    protected
     procedure SetRoI(vl: double);
     procedure SetRoO(vl: double);
     procedure SetEta(vl: double);
     procedure SetSpr(vl: double);
     procedure SetEps(vl: double);
     procedure SetLmd(vl: double);
     procedure SetWin(vl: integer);
    public
     constructor Create(AOwner: TComponent); override;
    public
     (* Deep copy of the network *)
     procedure   Assign(Source: TPersistent); override;
    published
     //input space vigilance threshold
     property RoI: double
       read FRoI
       write SetRoI;
     //output space vigilance threshold
     property RoO: double
       read FRoO
       write SetRoO;
     //merging factor
     property Lamda: double
       read FLmd
       write SetLmd;
     //number of neuron taken in output
     property Win: integer
       read FWin
       write SetWin;
     //decay constant
     property Eta: double
       read FEta
       write SetEta;
     //'Spread' (defualt 1.0) Age-spread given to winner aux-neuron
     property Spread: double
       read FSpr
       write SetSpr;
     //extinction threshold
     property Eps: double
       read FEps
       write SetEps;
  end;

  // Progressive Learning Neural Network
  TPLNetwork = class(TANN)
    private
     FParameters: TPLParameters;
    protected
     class procedure Supply(var Op: TNetOpers); override;
    public
     (* Returns the name of the network *)
     class function Description: string; override;
    protected
     function  GetNeuron(i: integer): TPLNElem;
     function  GetNumNeu: integer;
     procedure SetParameters(vl: TPLParameters);
    protected
     procedure MakeNeuron(const ip, op: TData); virtual;
     procedure Notification(AComponent: TComponent; Operation: TOperation); override;
     procedure DataChange(What: TDataNotify); override;
    public
     (* Create a PLN network structure and its "PLNElems" *)
     constructor Create(AOwner: TComponent); override;
     (* Free all memory that was assigned for the specified network structure *)
     destructor  Destroy; override;
    public
     procedure   Assign(Source: TPersistent); override;
    public
     procedure   MergeStep(i, j: integer); virtual;
     procedure   UpdateAge; virtual;
     function    CalcDist(const ip: TData): Index; virtual;
     procedure   Reset; override;
     procedure   Learn(const ip, op: TData); override;
     procedure   Simul(const ip: TData; var op: TData); override;
     function    FindCluster(const ip: TData): integer; override;
    public
     property Neurons[i: integer]: TPLNElem read GetNeuron;
     property NumNeu: integer read GetNumNeu;
    published
     property Parameters: TPLParameters
       read FParameters
       write SetParameters;
  end;

implementation

//--------------------------------------------------------------------------------------------------
procedure QuickSort(Dst: Index; Num: integer);
  procedure QuickSort2(sinistra,destra: integer);
  var
    a, b: integer;
    ele1,
    ele2: IndexElem;
  begin
    a:= sinistra;
    b:= destra;
    ele1:= Dst[(sinistra+destra) shr 1];
    repeat
      while Dst[a].Dist < ele1.Dist do inc(a);
      while ele1.Dist < Dst[b].Dist do dec(b);
      if a <= b then begin
        ele2:= Dst[a];
        Dst[a]:= Dst[b];
        Dst[b]:= ele2;
        inc(a);
        dec(b);
      end;
    until a > b;
    if sinistra < b then QuickSort2(sinistra, b);
    if a < destra then QuickSort2(a, destra);
  end;
begin
  QuickSort2(0, Num-1);
end;

procedure BubbleSort(Dst: Index; Num, Win: integer);
var
  Iniz, Fine, i: integer;
  flg: boolean;
  temp: IndexElem;
begin
  Iniz:= 0;
  Fine:= Num-1;
  if Win = 0 then Win:= Num;
  repeat
    flg:= true;
    for i:= Fine downto Iniz+1 do begin
      if Dst[i].Dist < Dst[i-1].Dist then begin
        temp:= Dst[i];
        Dst[i  ]:= Dst[i-1];
        Dst[i-1]:= temp;
        flg:= false;
      end;
    end;
    inc(Iniz);
    dec(win);
  until (flg) or (Win=0);
end;

//--------------------------------------------------------------------------------------------------
class function TPLNElem.Description: string;
begin
  Result:= 'Progressive learnig element';
end;

constructor TPLNElem.Create(AOwner: TComponent);
begin
  if (AOwner <> nil) and not (AOwner is TPLNetwork) then begin
    raise EANNNeuron.Create(errNeuronError3);
  end;
  inherited;
  Age:= 0;
end;

procedure TPLNElem.CentroidUpdate;
var
  i: integer;
begin
  with Center do begin
    for i:= 0 to Size-1 do begin
      Data[i]:= (Data[i] * Age + p[i]) / (Age+1);
    end;
  end;
end;

procedure TPLNElem.OutputUpdate;
var
  i: integer;
begin
  with Output do begin
    for i:= 0 to Size-1 do begin
      Data[i]:= (Data[i] * Age + p[i]) / (Age+1);
    end;
  end;
end;

procedure TPLNElem.AddSpread(Spread: double);
begin
  Age:= Age + Spread;
end;

procedure TPLNElem.Assign(Source: TPersistent);
var
  C: TPLNElem;
begin
  if Source is TPLNElem then begin
    inherited;
    C:= TPLNElem(Source);
    Age:= C.Age;
  end
  else inherited;
end;

function TPLNElem.GetSpread: double;
begin
  if (Owner<>nil) then begin
    Result:= TPLNetwork(Owner).Parameters.Spread;
  end
  else begin
    Result:= defSpread;
  end;
end;


//--------------------------------------------------------------------------------------------------
constructor TPLParameters.Create(AOwner: TComponent);
begin
  inherited;
  FRoI:= defRoI;
  FRoO:= defRoO;
  FEta:= defEta;
  FSpr:= defSpread;
  FEps:= defEps;
  FLmd:= defLmd;
  FWin:= defWin;
end;

procedure TPLParameters.Assign(Source: TPersistent);
var
  P: TPLParameters;
begin
  if Source is TPLParameters then begin
    P:= TPLParameters(Source);
    RoI:= P.RoI;
    RoO:= P.RoO;
    Eta:= P.Eta;
    Spread:= P.Spread;
    Eps:= P.Eps;
    Lamda:= P.Lamda;
    Win:= P.Win;
  end
  else inherited;
end;

procedure TPLParameters.SetRoI(vl: double);
begin
  if vl < 0 then vl:= 1;
  FRoI:= vl;
end;

procedure TPLParameters.SetRoO(vl: double);
begin
  if vl < 0 then vl:= 1;
  FRoO:= vl;
end;

procedure TPLParameters.SetEta(vl: double);
begin
  if vl < 0 then vl:= 1;
  FEta:= vl;
end;

procedure TPLParameters.SetSpr(vl: double);
begin
  if vl < 0 then vl:= 1;
  FSpr:= vl;
end;

procedure TPLParameters.SetEps(vl: double);
begin
  if vl < 0 then vl:= 0;
  FEps:= vl;
end;

procedure TPLParameters.SetLmd(vl: double);
begin
  if vl < 0 then vl:= 1;
  FLmd:= vl;
end;

procedure TPLParameters.SetWin(vl: integer);
begin
  if vl < 0 then vl:= 0;
  FWin:= vl;
end;

//--------------------------------------------------------------------------------------------------
class function TPLNetwork.Description;
begin
  Result:= 'Progressive Learning Neural Network';
end;

class procedure TPLNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noLearn, noSimul, noFindCluster, noReset];
  inherited;
end;

constructor TPLNetwork.Create(AOwner: TComponent);
begin
  inherited;
  FParameters:= TPLParameters.Create(nil);
  SetNetInfos([niSuper, niProgressive]);
end;

destructor TPLNetwork.Destroy;
begin
  FParameters.Free;
  inherited;
end;

procedure TPLNetwork.SetParameters(vl: TPLParameters);
begin
  FParameters.Assign(vl);
end;

procedure TPLNetwork.DataChange(What: TDataNotify);
var
  i: integer;
begin
  inherited;
  for i:= 0 to NumNeu-1 do begin
    Neurons[i].DataChange(What);
  end;
end;

procedure TPLNetwork.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if AComponent.Owner = Self then begin
    if not (csLoading in ComponentState) then begin
      if Operation = opInsert then begin
        if not (AComponent is TPLNElem) then begin
          raise EANNStructure.Create(errBadNetDef);
        end;
        with TPLNElem(AComponent) do begin
          Center.Size:= DimInp;
          Output.Size:= DimOut;
        end;
        ResetTraining;
      end;
    end;
  end;
end;

procedure TPLNetwork.Assign(Source: TPersistent);
var
  i: integer;
  N: TPLNetwork;
  C: TComponent;
begin
  if Source is TPLNetwork then begin
    inherited;
    N:= TPLNetwork(Source);
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

function TPLNetwork.GetNeuron(i: integer): TPLNElem;
begin
  Result:= TPLNElem(Components[i]);
end;

function TPLNetwork.GetNumNeu: integer;
begin
  Result:= ComponentCount;
end;

procedure TPLNetwork.Reset;
var
  i: integer;
begin
  inherited;
  for i:= NumNeu-1 downto 0 do begin
    Neurons[i].Free;
  end;
end;

procedure TPLNetwork.MakeNeuron(const ip, op: TData);
var
  N: TPLNElem;
begin
  N:= TPLNElem.Create(Self);
  N.Age:= Parameters.Spread+Parameters.Eta;
  N.HasCenter:= true;
  N.Center.SetWeights(ip);
  N.HasOutput:= true;
  N.Output.SetWeights(op);
end;

procedure TPLNetwork.UpdateAge;
var
  i: integer;
  N: TPLNElem;
begin
  for i:= NumNeu-1 downto 0 do begin
    N:= Neurons[i];
    N.Age:= N.Age - Parameters.Eta;
    if N.Age < Parameters.Eps then begin
      N.Free;
    end;
  end;
end;

function TPLNetwork.CalcDist(const ip: TData): Index;
var
  i: integer;
  N: TPLNElem;
begin
  SetLength(Result, NumNeu);
  for i:= 0 to NumNeu-1 do begin
    N:= Neurons[i];
    with Result[i] do begin
      Com:= N;
      Dist:= N.CentroidDist(ip);
    end;
  end;
end;

procedure TPLNetwork.Learn(const ip, op: TData);
var
  i: integer;
  Dst: Index;
  flg: boolean;
  tRoI, tRoO: double;
begin
  if NumNeu = 0 then MakeNeuron(ip, op)
  else begin
    Dst:= CalcDist(ip);
    QuickSort(Dst, NumNeu);
    flg:= true;
    tRoI:= sqr(Parameters.RoI);
    tRoO:= sqr(Parameters.RoO);
    for i:= 0 to NumNeu-1 do begin
      if Dst[i].Dist <= tRoI then begin
        with Dst[i].Com do begin
          if OutputDist(op) <= tRoO then begin
           CentroidUpdate(ip, Parameters.Eta);
           OutputUpdate(op, Parameters.Eta);
           AddSpread(Parameters.Spread+Parameters.Eta);
          end;
          flg:= false;
          break;
        end;
      end
      else break;
    end;
    if flg then MakeNeuron(ip, op);
    if Parameters.Eta > 0 then begin
      UpdateAge;
    end;
  end;
end;

function TPLNetwork.FindCluster(const ip: TData): integer;
var
  MaxDist: double;
  idist: double;
  Cnt, i: integer;
  Winner: TPLNElem;
begin
  Winner:= nil;
  Result:= -1;
  Cnt:= NumNeu;
  if Cnt > 0 then begin
    Winner:= Neurons[0];
    if Cnt > 1 then begin
      MaxDist:= Winner.CentroidDist(ip);
      for i:= 1 to Cnt-1 do begin
        idist:= Neurons[i].CentroidDist(ip);
        if idist < MaxDist then begin
          MaxDist:= idist;
          Winner:= Neurons[i];
        end;
      end;
    end;
  end;
  if Winner <> nil then Result:= Winner.Tag;
end;

procedure TPLNetwork.Simul(const ip: TData; var op: TData);
var
  Dst: Index;
  tWin, i, j: integer;
  tmp: double;
  sum: double;
begin
  Sum:= 0;
  tWin:= Parameters.Win;
  if (tWin>NumNeu) or (tWin<1) then tWin:= NumNeu;
  Dst:= CalcDist(ip);
  if tWin < 5 then BubbleSort(Dst, NumNeu, tWin)
  else QuickSort(Dst, NumNeu);
  if Dst[0].Dist <= sqr(Zero) then begin
    op:= Dst[0].Com.Output.GetWeights;
    Sum:= 1;
    i:= 1;
    while (i < tWin) do begin
      if Dst[i].Dist > sqr(Zero) then break;
      with Dst[i].Com do begin
        for j:= 0 to DimOut-1 do begin
          op[j]:= op[j] + Output.Data[j];
        end;
      end;
      Sum:= Sum + 1;
      inc(i);
    end;
  end
  else begin
    for j:= 0 to DimOut-1 do begin
      op[j]:= 0;
    end;
    for i:= 0 to tWin-1 do begin
      tmp:= 1/sqrt(Dst[i].Dist);
      with Dst[i].Com do begin
        for j:= 0 to DimOut-1 do begin
          op[j]:= op[j] + Output.Data[j] * tmp;
        end;
      end;
      Sum:= Sum + tmp;
    end;
  end;
  if Sum <> 1 then begin
    Sum:= 1/Sum;
    for j:= 0 to DimOut-1 do begin
      op[j]:= op[j] * Sum;
    end;
  end;
end;

procedure TPLNetwork.MergeStep(i, j: integer);
var
  Dst: double;
  p: TData;
  si, sj, ss: double;
  ip, jp: TData;
  z: integer;
begin
  setLength(p, DimInp);
  p:= Neurons[j].Center.GetWeights;
  Dst:= Neurons[i].CentroidDist(p);
  if Dst <= Parameters.Lamda * sqr(Parameters.RoI) then begin
    SetLength(p, DimOut);
    p:= Neurons[j].Output.GetWeights;
    Dst:= Neurons[i].OutputDist(p);
    if Dst <= Parameters.Lamda * sqr(Parameters.RoO) then begin
      sj:= Neurons[i].Age;
      si:= Neurons[j].Age;
      ss:= 1/(si + sj);
      ip:= Neurons[i].Center.Data;
      jp:= Neurons[j].Center.Data;
      for z:= 0 to DimInp-1 do begin
        ip[z]:= (ip[z]*si + jp[z]*sj) * ss;
      end;
      ip:= Neurons[i].Output.Data;
      jp:= Neurons[j].Output.Data;
      for z:= 0 to DimOut-1 do begin
        ip[z]:= (ip[z]*si + jp[z]*sj) * ss;
      end;
      Neurons[i].Age:= si + sj;
      Neurons[j].Free;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------
initialization
  RegisterClass(TPLNElem);
  RegisterClasses([TPLParameters, TPLNetwork]);
end.

