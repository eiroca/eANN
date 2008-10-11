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
 @author(Enrico Croce)
*)
unit eANNUtil;

interface

uses
  Classes, eDataPick;

const
  //A low value assumed to be 0
  Zero: double = 0.0001;

type

  PObjectPointerList = ^TObjectPointerList;
  TObjectPointerList = array[0..MaxListSize - 1] of TObject;

  TObjectList = class(TObject)
    private
     FCount: Integer;
     FCapacity: Integer;
    protected
     FList: PObjectPointerList;
    protected
     procedure Grow;
     function  Get(Index: Integer): TObject;
     procedure Put(Index: Integer; Item: TObject);
     procedure SetCapacity(NewCapacity: Integer);
     procedure SetCount(NewCount: Integer);
    public
     class procedure Error(const Msg: string; Data: Integer); virtual;
     procedure  Clear;
     function   IndexOf(Item: TObject): Integer;
     procedure  Add(Item: TObject);
     function   Remove(Item: TObject): Integer;
     procedure  Insert(Index: Integer; Item: TObject); virtual;
     procedure  Delete(Index: Integer); virtual;
     destructor Destroy; override;
    public
     property Capacity: Integer read FCapacity write SetCapacity;
     property Count: Integer read FCount write SetCount;
     property Objects[Index: Integer]: TObject read Get write Put;
     property List: PObjectPointerList read FList;
  end;

  TWeights = class(TPersistent)
    private
     FWeights: TData;
     FDim: integer;
    protected
     procedure SetDim(vl: integer);
    public
     constructor Create(aDim: integer);
     procedure   SetWeights(const p: TData);
     procedure   GetWeights(var p: TData);
     procedure   Randomize(min, max: double);
     function    SqrDist(const ip: TData): double;
     procedure   Assign(Source: TPersistent); override;
     procedure   SaveToStream(S: TStream);
     procedure   LoadFromStream(S: TStream);
     destructor  Destroy; override;
    public
     property Dim: integer read FDim write SetDim;
     property Weights: TData read FWeights;
  end;

  TWeights_List = class(TObjectList)
    protected
     function  GetWeights(Index: Integer): TWeights;
     procedure PutWeights(Index: Integer; Item: TWeights);
    public
     property Items[Index: Integer]: TWeights read GetWeights write PutWeights; default;
  end;

  TActivityLogger = class(TPersistent)
    private
     OldMin : double;
     OldMax : double;
     FMinAtt: double;
     FMaxAtt: double;
     FAveAtt: double;
     FVarAtt: double;
     FCntAtt: longint;
     FAtt   : double;
    public
     constructor Create;
     procedure   Reset;
     procedure   Add(vl: double);
     procedure   Undo;
    private
     procedure ReadData (Reader: TReader);
     procedure WriteData(Writer: TWriter);
    public
     procedure DefineProperties(Filer: TFiler); override;
     procedure Assign(Source: TPersistent); override;
    public
     property MinAtt: double  read FMinAtt;
     property MaxAtt: double  read FMaxAtt;
     property AveAtt: double  read FAveAtt;
     property VarAtt: double  read FVarAtt;
     property CntAtt: longint read FCntAtt;
     property Att   : double  read FAtt;
  end;

implementation

resourcestring
  SListIndexError = 'Out of index %d';
  SListCapacityError = 'List Capacity Error %d';
  SListCountError = 'List Count Error %d';

constructor TWeights.Create(aDim: integer);
begin
  Dim:= aDim;
end;

procedure TWeights.SetDim(vl: integer);
begin
  SetLength(FWeights, vl);
  FDim:= vl;
end;

procedure TWeights.SetWeights(const p: TData);
var
  i: integer;
begin
  for i:= 0 to Dim-1 do begin
    Weights[i]:= p[i];
  end;
end;

procedure TWeights.GetWeights(var p: TData);
var
  i: integer;
begin
  for i:= 0 to Dim-1 do begin
    p[i]:= Weights[i];
  end;
end;

procedure TWeights.Randomize(min, max: double);
var
  i: integer;
  dlt: double;
begin
  dlt:= (max-min);
  for i:= 0 to Dim-1 do begin
    Weights[i]:= random * dlt + min;
  end;
end;

function TWeights.SqrDist(const ip: TData): double;
var
  i: integer;
begin
  Result:= 0;
  for i:= 0 to Dim-1 do begin
    Result:= Result + sqr(Weights[i] - ip[i]);
  end;
end;

procedure TWeights.Assign(Source: TPersistent);
var
  W: TWeights;
begin
  if Source is TWeights then begin
    W:= TWeights(Source);
    Dim:= W.Dim;
    if Dim <> 0 then begin
      FWeights:= W.FWeights;
    end;
  end
  else inherited Assign(Source);
end;

procedure TWeights.SaveToStream(S: TStream);
var
  i: integer;
begin
  S.WriteBuffer(FDim, SizeOf(FDim));
  for i:= 0 to Dim -1 do begin
    S.WriteBuffer(Weights[i], SizeOf(double));
  end;
end;

procedure TWeights.LoadFromStream(S: TStream);
var
  d: integer;
  i: integer;
begin
  S.ReadBuffer(d, SizeOf(FDim));
  Dim:= d;
  for i:= 0 to Dim -1 do begin
    S.ReadBuffer(Weights[i], SizeOf(double));
  end;
end;

destructor TWeights.Destroy;
begin
  SetLength(FWeights, 0);
  inherited Destroy;
end;

constructor TActivityLogger.Create;
begin
  inherited Create;
  Reset;
end;

procedure TActivityLogger.Add(vl: double);
begin
  FAtt:= vl;
  if FAtt < MinAtt then begin
    OldMin:= MinAtt;
    FMinAtt:= FAtt;
  end
  else if FAtt > MaxAtt then begin
    OldMax:= MaxAtt;
    FMaxAtt:= FAtt;
  end;
  FAveAtt:= (CntAtt * AveAtt + FAtt) / (CntAtt+1);
  FVarAtt:= (CntAtt * VarAtt + sqr(FAtt-AveAtt)) / (CntAtt+1);
  FCntAtt:= CntAtt + 1;
end;

procedure TActivityLogger.Undo;
begin
  if FAtt = MinAtt then FMinAtt:= OldMin
  else if FAtt = MaxAtt then FMaxAtt:= OldMax;
  FAveAtt:= (CntAtt * AveAtt - FAtt) / (CntAtt-1);
  FVarAtt:= (CntAtt * VarAtt - sqr(FAtt-AveAtt)) / (CntAtt-1);
  FCntAtt:= CntAtt - 1;
end;

procedure TActivityLogger.Reset;
begin
  FAveAtt:= 0;
  FVarAtt:= 0;
  FMinAtt:=  10e30;
  FMaxAtt:= -10e30;
  FCntAtt:= 0;
  FAtt  := 0;
  OldMin:= MinAtt;
  OldMax:= MaxAtt;
end;

procedure TActivityLogger.Assign(Source: TPersistent);
var
  AL: TActivityLogger;
begin
  if Source is TActivityLogger then begin
    AL:= TActivityLogger(Source);
    FAveAtt:= AL.AveAtt;
    FVarAtt:= AL.VarAtt;
    FMinAtt:= AL.MinAtt;
    FMaxAtt:= AL.MaxAtt;
    FCntAtt:= AL.CntAtt;
    FAtt  := AL.Att;
    OldMin:= AL.OldMin;
    OldMax:= AL.OldMax;
  end
  else inherited Assign(Source);
end;

procedure TActivityLogger.ReadData (Reader: TReader);
begin
  Reader.ReadListBegin;
  if not Reader.EndOfList then FAtt:= Reader.ReadFloat;
  if not Reader.EndOfList then FCntAtt:= Reader.ReadInteger;
  if not Reader.EndOfList then FAveAtt:= Reader.ReadFloat;
  if not Reader.EndOfList then FVarAtt:= Reader.ReadFloat;
  if not Reader.EndOfList then FMinAtt:= Reader.ReadFloat;
  if not Reader.EndOfList then FMaxAtt:= Reader.ReadFloat;
  Reader.ReadListEnd;
end;

procedure TActivityLogger.WriteData(Writer: TWriter);
begin
  Writer.WriteListBegin;
  Writer.WriteFloat(FAtt);
  Writer.WriteInteger(FCntAtt);
  Writer.WriteFloat(FAveAtt);
  Writer.WriteFloat(FVarAtt);
  Writer.WriteFloat(FMinAtt);
  Writer.WriteFloat(FMaxAtt);
  Writer.WriteListEnd;
end;

procedure TActivityLogger.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('ActivationInfo', ReadData, WriteData, CntAtt<>0);
  inherited DefineProperties(Filer);
end;

procedure TObjectList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then Error(SListCapacityError, NewCapacity);
  if NewCapacity <> FCapacity then begin
    ReallocMem(FList, NewCapacity * SizeOf(TObject));
    FCapacity:= NewCapacity;
  end;
end;

procedure TObjectList.SetCount(NewCount: Integer);
begin
  if (NewCount < 0) or (NewCount > MaxListSize) then Error(SListCountError, NewCount);
  if NewCount > FCapacity then SetCapacity(NewCount);
  if NewCount > FCount then FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(TObject), 0);
  FCount:= NewCount;
end;

class procedure TObjectList.Error(const Msg: string; Data: Integer);
  function ReturnAddr: Pointer;
  asm
    MOV EAX,[EBP+4]
  end;
begin
  raise EListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

function TObjectList.Get(Index: Integer): TObject;
begin
  {$IFDEF R+}
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  {$ENDIF}
  Result:= FList^[Index];
end;

procedure TObjectList.Put(Index: Integer; Item: TObject);
begin
  {$IFDEF R+}
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  {$ENDIF}
  FList^[Index]:= Item;
end;

procedure TObjectList.Grow;
begin
  SetCapacity(FCapacity + 256);
end;

procedure TObjectList.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

function TObjectList.IndexOf(Item: TObject): Integer;
begin
  Result:= 0;
  while (Result < FCount) and (FList^[Result] <> Item) do Inc(Result);
  if Result = FCount then Result:= -1;
end;

procedure TObjectList.Add(Item: TObject);
begin
  Insert(Count, Item);
end;

function TObjectList.Remove(Item: TObject): Integer;
begin
  Result:= IndexOf(Item);
  if Result <> -1 then Delete(Result);
end;

procedure TObjectList.Delete(Index: Integer);
begin
  {$IFDEF R+}
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  {$ENDIF}
  Dec(FCount);
  if Index < FCount then System.Move(FList^[Index + 1], FList^[Index], (FCount - Index) * SizeOf(TObject));
end;

procedure TObjectList.Insert(Index: Integer; Item: TObject);
begin
  {$IFDEF R+}
  if (Index < 0) or (Index > FCount) then Error(SListIndexError, Index);
  {$ENDIF}
  if FCount = FCapacity then Grow;
  if Index < FCount then System.Move(FList^[Index], FList^[Index + 1], (FCount - Index) * SizeOf(TObject));
  FList^[Index]:= Item;
  Inc(FCount);
end;

destructor TObjectList.Destroy;
var
  i: integer;
begin
  for i:= 0 to Count-1 do Objects[i].Free;
  Clear;
end;

function  TWeights_List.GetWeights(Index: Integer): TWeights;
begin
  if Index=-1 then Index:= Count-1;
  {$IFDEF R+}
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  {$ENDIF}
  Result:= TWeights(FList^[Index]);
end;

procedure TWeights_List.PutWeights(Index: Integer; Item: TWeights);
begin
  {$IFDEF R+}
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  {$ENDIF}
  FList^[Index]:= Item;
end;

end.

