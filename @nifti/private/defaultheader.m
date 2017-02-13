function header = defaultheader(like)
%DEFAULTHEADER
%
%Copyright (c) 2017 Enrico Kaden & University College London

if nargin < 1
    header = struct;
else
    header = like;
end

header.sizeof_hdr = int32(348);
header.data_type = zeros(1, 10, 'uint8'); % unused
header.db_name = zeros(1, 18, 'uint8'); % unused
header.extents = int32(0); % unused
header.session_error = int16(0); % unused
header.regular = uint8(0); % unused
if nargin < 1
    header.dim_info = uint8(0);
end
if nargin < 1
    header.dim = zeros(1, 8, 'int16');
else
    header.dim((1+header.dim(1)+1):end) = int16(0);
end
header.intent_p1 = single(0);
header.intent_p2 = single(0);
header.intent_p3 = single(0);
header.intent_code = int16(0);
if nargin < 1
    header.datatype = int16(0);
end
if nargin < 1
    header.bitpix = int16(0);
else
    header.bitpix = int16(8*bytesize(raw2datatype(like.datatype)));
end
if nargin < 1
    header.slice_start = int16(0);
end
if nargin < 1
    header.pixdim = [ones(1, 1, 'single') zeros(1, 7, 'single')];
else
    header.pixdim((1+header.dim(1)+1):end) = single(0);
end
header.vox_offset = single(352);
header.scl_slope = single(1);
header.scl_inter = single(0);
if nargin < 1
    header.slice_end = int16(0);
end
if nargin < 1
    header.slice_code = uint8(0);
end
if nargin < 1
    header.xyzt_units = uint8(0);
else
    header.xyzt_units = SPACE_TIME_TO_XYZT(XYZT_TO_SPACE(like.xyzt_units), uint8(0));
end
header.cal_max = single(0);
header.cal_min = single(0);
if nargin < 1
    header.slice_duration = single(0);
end
header.toffset = single(0);
header.glmax = int32(0); % unused
header.glmin = int32(0); % unused
descrip = unicode2native('NIfTI – https://ekaden.github.io');
header.descrip = [descrip zeros(1, 80-size(descrip, 2), 'uint8')];
if nargin < 1
    header.aux_file = zeros(1, 24, 'uint8');
end
if nargin < 1
    header.qform_code = int16(1);
end
if nargin < 1
    header.sform_code = int16(0);
end
if nargin < 1
    header.quatern_b = single(0);
end
if nargin < 1
    header.quatern_c = single(0);
end
if nargin < 1
    header.quatern_d = single(0);
end
if nargin < 1
    header.quatern_x = single(0);
end
if nargin < 1
    header.quatern_y = single(0);
end
if nargin < 1
    header.quatern_z = single(0);
end
if nargin < 1
    header.srow_x = zeros(1, 4, 'single');
end
if nargin < 1
    header.srow_y = zeros(1, 4, 'single');
end
if nargin < 1
    header.srow_z = zeros(1, 4, 'single');
end
if nargin < 1
    header.intent_name = zeros(1, 16, 'uint8');
end
header.magic = [unicode2native('n+1') 0];
header.extender = zeros(1, 4, 'uint8'); % TODO: Separate data structure?
end

function ss = XYZT_TO_SPACE(xyzt)
ss = bitand(xyzt, hex2dec('07'), 'uint8');
end

function xyzt = SPACE_TIME_TO_XYZT(ss, tt)
xyzt = bitor(bitand(ss, hex2dec('07'), 'uint8'), bitand(tt, hex2dec('38'), 'uint8'), 'uint8');
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