function datatype = raw2datatype(raw)
%RAW2DATATYPE
%
%Copyright (c) 2017 Enrico Kaden & University College London

if isempty(raw)
    datatype = [];
elseif ~isscalar(raw)
    error('Unknown NIfTI-1 data type.');
else
    switch raw
        case 2
            datatype = 'uint8';
        case 4
            datatype = 'int16';
        case 8
            datatype = 'int32';
        case 16
            datatype = 'single';
        case 32
            datatype = 'csingle';
        case 64
            datatype = 'double';
        case 256
            datatype = 'int8';
        case 512
            datatype = 'uint16';
        case 768
            datatype = 'uint32';
        case 1024
            datatype = 'int64';
        case 1280
            datatype = 'uint64';
        case 1792
            datatype = 'cdouble';
        otherwise
            error('Unknown NIfTI-1 data type.');
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