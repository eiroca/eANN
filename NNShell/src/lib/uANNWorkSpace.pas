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
 @author(Enrico Croce)
*)
unit uANNWorkSpace;

interface

uses
  Classes, uWorkspace, eANNCore;

type

  TANNWorkSpace = class(TWorkSpace)
    protected
     procedure   Loaded; override;
    public
     function    MakeNetwork(NetClass: TANNClass): TComponent;
     procedure   NotifyANNChange(Sender: TANN);
  end;

implementation

procedure TANNWorkSpace.Loaded;
var
  i: integer;
begin
  inherited ;
  for i:= 0 to ComponentCount-1 do begin
    if Components[i] is TANN then begin
      TANN(Components[i]).OnChange:= NotifyANNChange;
    end;
  end;
end;

function TANNWorkSpace.MakeNetwork(NetClass: TANNClass): TComponent;
var
  Name: string;
begin
  Name:= GetUniqueName('Network%d');
  Result:= CreateObject(NetClass, Name);
  (Result as TANN).OnChange:= NotifyANNChange;
end;

procedure TANNWorkSpace.NotifyANNChange(Sender: TANN);
begin
  FChanged:= true;
end;

end.

