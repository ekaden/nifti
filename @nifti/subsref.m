function sref = subsref(obj, s)
%SUBSREF Subscripted reference for NIfTI-1 data set.
%Input argument(s):
%  obj  ... NIfTI-1 data set
%  s    ... subscript(s)
%Output argument(s):
%  sref ... reference
%
%Copyright (c) 2017 Enrico Kaden & University College London

if strcmp(s(1).type, '()') == 1
    if length(s) < 2
        if iscomplex(obj)
            sref_re = builtin('subsref', obj.mmap, struct('type', {'.', '.', s.type}, 'subs', {'Data', 'data', [{1}, s.subs]}));
            sref_im = builtin('subsref', obj.mmap, struct('type', {'.', '.', s.type}, 'subs', {'Data', 'data', [{2}, s.subs]}));
            sref = obj.scaling.slope*complex(shiftdim(sref_re, 1), shiftdim(sref_im, 1))+obj.scaling.offset;
        else
            sref = obj.scaling.slope*builtin('subsref', obj.mmap, struct('type', {'.', '.', s.type}, 'subs', {'Data', 'data', s.subs}))+obj.scaling.offset;
        end
    else
        error(['No appropriate method, property, or field ' , s(2).subs, ' for class nifti.']);
    end
else
    if strcmp(s(1).type, '.') == 1
        if any(strcmp(s(1).subs, {'filename', 'writable', 'datatype', 'dim', 'pixdim', 'offset', 'scaling', 'header', 'mmap', 'end', 'isempty', 'isnifti', 'length', 'ndims', 'size', 'struct'}) == 1)
            sref = builtin('subsref', obj, s);
        else
            error(['No appropriate method, property, or field ' , s(1).subs, ' for class nifti.']);
        end
    else
        sref = builtin('subsref', obj, s);
    end
end
end

% Copyright (c) 2017 Enrico Kaden & University College London
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% * Redistributions of source code must retain the above copyright notice, this
%   list of conditions and the following disclaimer.
% 
% * Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.