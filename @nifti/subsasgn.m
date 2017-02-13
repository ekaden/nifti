function obj = subsasgn(obj, s, val)
%SUBSASGN Subscripted assignment to NIfTI-1 data set.
%Input argument(s):
%  obj ... NIfTI-1 data set
%  s   ... subscript(s)
%  val ... value(s)
%Output argument(s):
%  obj ... NIfTI-1 data set
%
%Copyright (c) 2017 Enrico Kaden & University College London

if strcmp(s(1).type, '()') == 1
    if length(s) < 2
        if iscomplex(obj)
            obj.mmap.Data.data = builtin('subsasgn', obj.mmap.Data.data, struct('type', {s.type}, 'subs', {[{1}, s.subs]}), shiftdim(real(val), -1));
            obj.mmap.Data.data = builtin('subsasgn', obj.mmap.Data.data, struct('type', {s.type}, 'subs', {[{2}, s.subs]}), shiftdim(imag(val), -1));
        else
            obj.mmap.Data.data = builtin('subsasgn', obj.mmap.Data.data, s, val);
        end
    else
        error(['No appropriate method, property, or field ' , s(2).subs, ' for class nifti.']);
    end
else
    if strcmp(s(1).type, '.') == 1
        error(['No appropriate method, property, or field ' , s(1).subs, ' for class nifti.']);
    else
        obj = builtin('subsasgn', obj, s, val);
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