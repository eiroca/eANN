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
  Classes, SysUtils, eANN, eANNUtil, eANNMsg, eANNCom, eLibMath, eDataPick;

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
     FSpread: double;
    protected
     procedure   SaveToStream(S: TStream); override;
     procedure   LoadFromStream(S: TStream); override;
    public
     constructor Create(AOwner: TComponent); override;
     procedure   UpdateParam; override;
     procedure   Assign(Source: TPersistent); override;
     (* Update state of the input centroid accordin to input *)
     procedure   CentroidUpdate(const p: TData); override;
     (* Update state of the output centroid accordin to input *)
     procedure   OutputUpdate(const p: TData); override;
     (* Update Age *)
     procedure   AddSpread; virtual;
    published
     property Age: double read FAge write FAge;
     property Spread: double read FSpread write FSpread;
  end;

  TCustomPLNetwork = class;

  TPLParameters = class(TANNParam)
    private
     FRoI: double;
     FRoO: double;
     FEta: double;
     FSpr: double;
     FEps: double;
     FLmd: double;
     FWin: integer;
    public
     constructor Create(AOwner: TANN); override;
    private
     procedure SetRoI(vl: double);
     procedure SetRoO(vl: double);
     procedure SetEta(vl: double);
     procedure SetSpr(vl: double);
     procedure SetEps(vl: double);
     procedure SetLmd(vl: double);
     procedure SetWin(vl: integer);
    published
     //input space vigilance threshold
     property RoI: double  read FRoI write SetRoI;
     //output space vigilance threshold
     property RoO: double  read FRoO write SetRoO;
     //merging factor
     property lmd: double  read FLmd write SetLmd;
     //number of neuron taken in output
     property win: integer read FWin write SetWin;
     //decay constant
     property eta: double  read FEta write SetEta;
     //'Spread' (defualt 1.0) Age-spread given to winner aux-neuron
     property spr: double  read FSpr write SetSpr;
     //extinction threshold
     property eps: double  read FEps write SetEps;
  end;

  // Progressive Learning Neural Network
  TCustomPLNetwork = class(TANN)
    protected
     class procedure Supply(var Op: TNetOpers); override;
    public
     (* Returns the name of the network *)
     class function Description: string; override;
    private
     FParameters: TPLParameters;
    private
     procedure SetParameters(Prm: TPLParameters);
     function  GetNeuron(i: integer): TPLNElem;
     function  GetNumNeu: integer;
     procedure SaveNeurons(S: TStream);
     procedure LoadNeurons(S: TStream);
    protected
     procedure MakeNeuron(const ip, op: TData); virtual;
     procedure UpdateParam;
     procedure DefineProperties(Filer: TFiler); override;
     procedure Notification(AComponent: TComponent; Operation: TOperation); override;
     procedure DataChange(What: TDataNotify); override;
    public
     (* Create a PLN network structure and its "PLNElems" *)
     constructor Create(AOwner: TComponent); override;
     procedure   Assign(Source: TPersistent); override;
     (* Free all memory that was assigned for the specified network structure *)
     destructor  Destroy; override;
    public
     procedure   MergeStep(i, j: integer); virtual;
     procedure   UpdateAge; virtual;
     function    CalcDist(const ip: TData): Index; virtual;
     procedure   Reset; override;
     procedure   Learn(const ip, op: TData); override;
     procedure   Simul(const ip: TData; var op: TData); override;
     function    FindCluster(const ip: TData): integer; override;
    public
     property Parameters: TPLParameters read FParameters write SetParameters;
     property Neurons[i: integer]: TPLNElem read GetNeuron;
     property NumNeu: integer read GetNumNeu;
  end;

  TPLNetwork = class(TCustomPLNetwork)
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

class function TPLNElem.Description: string;
begin
  Result:= 'Progressive learnig element';
end;

constructor TPLNElem.Create(AOwner: TComponent);
begin
  if (AOwner <> nil) and not (AOwner is TCustomPLNetwork) then begin
    TANN.DoError(EANNNeuron, errNeuronError3);
  end;
  Eta:= 0.1;
  Spread:= 1;
  inherited Create(AOwner);
  Age:= Spread+Eta;
end;

procedure TPLNElem.UpdateParam;
var
  N: TCustomPLNetwork;
begin
  if Owner <> nil then begin
    N:= TCustomPLNetwork(Owner);
    Eta:= N.Parameters.Eta;
    Spread:= N.Parameters.Spr;
  end;
end;

procedure TPLNElem.CentroidUpdate;
var
  i: integer;
begin
  with Center do begin
    for i:= 0 to Dim-1 do begin
      Weights[i]:= (Weights[i] * Age + p[i]) / (Age+1);
    end;
  end;
end;

procedure TPLNElem.OutputUpdate;
var
  i: integer;
begin
  with Output do begin
    for i:= 0 to Dim-1 do begin
      Weights[i]:= (Weights[i] * Age + p[i]) / (Age+1);
    end;
  end;
end;

procedure TPLNElem.AddSpread;
begin
  Age:= Age + Spread + eta;
end;

procedure TPLNElem.SaveToStream(S: TStream);
begin
  inherited SaveToStream(S);
  S.Write(FAge, SizeOf(FAge));
  S.Write(FSpread, SizeOf(FSpread));
end;

procedure TPLNElem.LoadFromStream(S: TStream);
begin
  inherited LoadFromStream(S);
  S.Read(FAge, SizeOf(FAge));
  S.Read(FSpread, SizeOf(FSpread));
end;

procedure TPLNElem.Assign(Source: TPersistent);
var
  C: TPLNElem;
begin
  if Source is TPLNElem then begin
    inherited Assign(Source);
    C:= TPLNElem(Source);
    Age:= C.Age;
    Spread:= C.Spread;
  end
  else inherited Assign(Source);
end;

constructor TPLParameters.Create(AOwner: TANN);
begin
  inherited Create(AOwner);
  FRoI:= 1;
  FRoO:= 1;
  FEta:= 0.01;
  FSpr:= 1;
  FEps:= 0;
  FLmd:= 1;
  FWin:= 1;
end;

procedure TPLParameters.SetRoI(vl: double);
begin
  if vl < 0 then vl:= 1;
  if vl <> FRoI then begin
    FRoI:= vl;
    Owner.Change;
  end;
end;

procedure TPLParameters.SetRoO(vl: double);
begin
  if vl < 0 then vl:= 1;
  if vl <> FRoO then begin
    FRoO:= vl;
    Owner.Change;
  end;
end;

procedure TPLParameters.SetEta(vl: double);
begin
  if vl < 0 then vl:= 1;
  if vl <> FEta then begin
    FEta:= vl;
    TPLNetwork(Owner).UpdateParam;
    Owner.Change;
  end;
end;

procedure TPLParameters.SetSpr(vl: double);
begin
  if vl < 0 then vl:= 1;
  if vl <> FSpr then begin
    FSpr:= vl;
    TPLNetwork(Owner).UpdateParam;
    Owner.Change;
  end;
end;

procedure TPLParameters.SetEps(vl: double);
begin
  if vl < 0 then vl:= 0;
  if vl <> FEps then begin
    FEps:= vl;
    Owner.Change;
  end;
end;

procedure TPLParameters.SetLmd(vl: double);
begin
  if vl < 0 then vl:= 1;
  if vl <> FLmd then begin
    FLmd:= vl;
    Owner.Change;
  end;
end;

procedure TPLParameters.SetWin(vl: integer);
begin
  if vl < 0 then vl:= 0;
  if vl <> FWin then begin
    FWin:= vl;
    Owner.Change;
  end;
end;

class function TCustomPLNetwork.Description;
begin
  Result:= 'Progressive Learning Neural Network';
end;

class procedure TCustomPLNetwork.Supply(var Op: TNetOpers);
begin
  Op:= Op + [noLearn, noSimul, noFindCluster, noReset];
  inherited Supply(Op);
end;

constructor TCustomPLNetwork.Create;
begin
  inherited Create(AOwner);
  FParameters:= TPLParameters.Create(Self);
  SetNetInfos([niSuper, niProgressive]);
end;

procedure TCustomPLNetwork.DataChange(What: TDataNotify);
var
  i: integer;
begin
  inherited DataChange(What);
  for i:= 0 to NumNeu-1 do begin
    Neurons[i].DataChange(What);
  end;
end;

procedure TCustomPLNetwork.SaveNeurons(S: TStream);
var
  i, tmp: integer;
begin
  tmp:= NumNeu;
  S.Write(tmp, SizeOf(tmp));
  for i:= 0 to tmp-1 do begin
    S.WriteComponent(Neurons[i]);
  end;
end;

procedure TCustomPLNetwork.LoadNeurons(S: TStream);
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
end;

procedure TCustomPLNetwork.DefineProperties(Filer: TFiler);
begin
  Filer.DefineBinaryProperty('Neurons', LoadNeurons, SaveNeurons, NumNeu>0);
  inherited DefineProperties(Filer);
end;

procedure TCustomPLNetwork.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if AComponent.Owner = Self then begin
    if not (csLoading in ComponentState) then begin
      if Operation = opInsert then begin
        if not (AComponent is TPLNElem) then begin
          DoError(EANNStructure, errBadNetDef);
        end;
        with TPLNElem(AComponent) do begin
          Center.Dim:= DimInp;
          Output.Dim:= DimOut;
          UpdateParam;
        end;
        ResetTraining;
      end;
    end;
  end;
end;

procedure TCustomPLNetwork.Assign(Source: TPersistent);
var
  i: integer;
  N: TCustomPLNetwork;
  C: TComponent;
begin
  if Source is TCustomPLNetwork then begin
    inherited Assign(Source);
    N:= TCustomPLNetwork(Source);
    Parameters:= N.Parameters;
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

procedure TCustomPLNetwork.SetParameters(Prm: TPLParameters);
begin
  FParameters.Assign(Prm);
end;

function TCustomPlNetwork.GetNeuron(i: integer): TPLNElem;
begin
  Result:= TPLNElem(Components[i]);
end;

function TCustomPlNetwork.GetNumNeu: integer;
begin
  Result:= ComponentCount;
end;

procedure TCustomPLNetwork.UpdateParam;
var
  i: integer;
begin
  for i:= 0 to NumNeu-1 do begin
    Neurons[i].UpdateParam;
  end;
end;

procedure TCustomPLNetwork.Reset;
var
  i: integer;
begin
  inherited Reset;
  for i:= NumNeu-1 downto 0 do begin
    Neurons[i].Free;
  end;
end;

procedure TCustomPLNetwork.MakeNeuron(const ip, op: TData);
var
  N: TPLNElem;
begin
  N:= TPLNElem.Create(Self);
  with N do begin
    Eta:= Parameters.Eta;
    Spread:= Parameters.Spr;
    Age:= Spread+Eta;
    Center.SetWeights(ip);
    Output.SetWeights(op);
    HasInp:= true;
    HasOut:= true;
  end;
end;

procedure TCustomPLNetwork.UpdateAge;
var
  i: integer;
  N: TPLNElem;
begin
  for i:= NumNeu-1 downto 0 do begin
    N:= Neurons[i];
    with N do begin
      Age:= Age - Parameters.eta;
      if Age < Parameters.eps then begin
        N.Free;
      end;
    end;
  end;
end;

function TCustomPLNetwork.CalcDist(const ip: TData): Index;
var
  i: integer;
  N: TPLNElem;
begin
  SetLength(Result, NumNeu);
  for i:= 0 to NumNeu-1 do begin
    N:= Neurons[i];
    with Result[i], N do begin
      Com:= N;
      Dist:= CentroidDist(ip);
    end;
  end;
end;

procedure TCustomPLNetwork.Learn(const ip, op: TData);
var
  i: integer;
  Dst: Index;
  flg: boolean;
  RoI, RoO: double;
begin
  if NumNeu = 0 then MakeNeuron(ip, op)
  else begin
    Dst:= CalcDist(ip);
    QuickSort(Dst, NumNeu);
    flg:= true;
    RoI:= sqr(Parameters.RoI);
    RoO:= sqr(Parameters.RoO);
    for i:= 0 to NumNeu-1 do begin
      if Dst[i].Dist <= RoI then begin
        with Dst[i].Com do begin
          if OutputDist(op) <= RoO then begin
           CentroidUpdate(ip);
           OutputUpdate(op);
           AddSpread;
          end;
          flg:= false;
          break;
        end;
      end
      else break;
    end;
    if flg then MakeNeuron(ip, op);
    if Parameters.eta > 0 then begin
      UpdateAge;
    end;
  end;
end;

function TCustomPLNetwork.FindCluster(const ip: TData): integer;
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

procedure TCustomPLNetwork.Simul(const ip: TData; var op: TData);
var
  Dst: Index;
  win, i, j: integer;
  tmp: double;
  sum: double;
begin
  Sum:= 0;
  win:= Parameters.Win;
  if (win>NumNeu) or (win<1) then win:= NumNeu;
  Dst:= CalcDist(ip);
  if win < 5 then BubbleSort(Dst, NumNeu, Win)
  else QuickSort(Dst, NumNeu);
  if Dst[0].Dist <= sqr(Zero) then begin
    Dst[0].Com.Output.GetWeights(op);
    Sum:= 1;
    i:= 1;
    while (i < win) do begin
      if Dst[i].Dist > sqr(Zero) then break;
      with Dst[i].Com do begin
        for j:= 0 to DimOut-1 do begin
          op[j]:= op[j] + Output.Weights[j];
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
    for i:= 0 to win-1 do begin
      tmp:= 1/sqrt(Dst[i].Dist);
      with Dst[i].Com do begin
        for j:= 0 to DimOut-1 do begin
          op[j]:= op[j] + Output.Weights[j] * tmp;
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

procedure TCustomPLNetwork.MergeStep(i, j: integer);
var
  Dst: double;
  p: TData;
  si, sj, ss: double;
  ip, jp: TData;
  z: integer;
begin
  setLength(p, DimInp);
  Neurons[j].Center.GetWeights(p);
  Dst:= Neurons[i].CentroidDist(p);
  if Dst <= Parameters.lmd * sqr(Parameters.RoI) then begin
    SetLength(p, DimOut);
    Neurons[j].Output.GetWeights(p);
    Dst:= Neurons[i].OutputDist(p);
    if Dst <= Parameters.lmd * sqr(Parameters.RoO) then begin
      sj:= Neurons[i].Age;
      si:= Neurons[j].Age;
      ss:= 1/(si + sj);
      ip:= Neurons[i].Center.Weights;
      jp:= Neurons[j].Center.Weights;
      for z:= 0 to DimInp-1 do begin
        ip[z]:= (ip[z]*si + jp[z]*sj) * ss;
      end;
      ip:= Neurons[i].Output.Weights;
      jp:= Neurons[j].Output.Weights;
      for z:= 0 to DimOut-1 do begin
        ip[z]:= (ip[z]*si + jp[z]*sj) * ss;
      end;
      Neurons[i].Age:= si + sj;
      Neurons[j].Free;
    end;
  end;
end;

destructor TCustomPLNetwork.Destroy;
begin
  FParameters.Free;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('Eic', [TPLNetwork]);
end;

initialization
  RegisterClass(TPLNElem);
  RegisterClass(TPLNetwork);
end.

