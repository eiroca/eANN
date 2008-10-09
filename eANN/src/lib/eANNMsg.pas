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
*)
unit eANNMsg;

interface

resourcestring

  wrnAborted     = 'operation aborted';
  wrnMaxIter     = 'maximum iterations reached';
  wrnNoConv      = 'convergence not reached';

  errBadInput    = 'problem(s) with input data';
  errBadOutput   = 'problem(s) with output data';
  errBadIOCount  = 'fewer output patterns than input ones';
  errNotTrained  = 'network is not be trained';
  errAbstract    = 'call to an abstract function';
  errOutOfMemory = 'memory or object allocation failed';
  errNeuronError1= 'neuron can be inserted only in layers';
  errNeuronError2= 'neuron cannot accept other components';
  errNeuronError3= 'TPLElem can be inserted only in TPLNetwork';
  errLayerError1 = 'layer can be inserted only in MLP networks';
  errLayerError2 = 'layer cannot accept nothing other neurons';
  errBadNetDef   = 'bad network definition';

implementation

end.
