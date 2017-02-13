function raw = datatype2raw(datatype)
%DATATYPE2RAW
%
%Copyright (c) 2017 Enrico Kaden & University College London

if isempty(datatype)
    raw = [];
elseif ~ischar(datatype)
    error('Unknown NIfTI-1 data type.');
else
    switch datatype
        case 'uint8'
            raw = 2;
        case 'int16'
            raw = 4;
        case 'int32'
            raw = 8;
        case 'single'
            raw = 16;
        case 'csingle'
            raw = 32;
        case 'double'
            raw = 64;
        case 'int8'
            raw = 256;
        case 'uint16'
            raw = 512;
        case 'uint32'
            raw = 768;
        case 'int64'
            raw = 1024;
        case 'uint64'
            raw = 1280;
        case 'cdouble'
            raw = 1792;
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