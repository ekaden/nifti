function varargout = size(obj, dim)
%SIZE Size of array in NIfTI-1 data set.
%  obj       ... NIfTI-1 data set
%  dim       ... dimension
%Output argument(s):
%  varargout ... size of array
%
%Copyright (c) 2017 Enrico Kaden & University College London

varargout = cell(nargout);
if nargin < 2
    if nargout > 1
        if iscomplex(obj)
            sz = stripdim(size(obj.mmap.Data.data));
        else
            sz = size(obj.mmap.Data.data);
        end
        if length(sz) == nargout
            for ii = 1:length(sz)
                varargout{ii} = sz(ii);
            end
        elseif length(sz) < nargout
            for ii = 1:length(sz)
                varargout{ii} = sz(ii);
            end
            for ii = length(sz)+1:nargout
                varargout{ii} = 1;
            end
        else % length(d) > nargout
            for ii = 1:nargout-1
                varargout{ii} = sz(ii);
            end
            varargout{nargout} = prod(sz(nargout:end));
        end
    else
        if iscomplex(obj)
            varargout{1} = stripdim(size(obj.mmap.Data.data));
        else
            varargout{1} = size(obj.mmap.Data.data);
        end
    end
else
    if nargout > 1
        error('Too many output arguments.');
    else
        if iscomplex(obj)
            varargout{1} = size(obj.mmap.Data.data, dim+1);
        else
            varargout{1} = size(obj.mmap.Data.data, dim);
        end
    end
end
end

function stripsz = stripdim(sz)
if length(sz) == 2
    stripsz = [sz(2) 1];
else
    stripsz = sz(1, 2:end);
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