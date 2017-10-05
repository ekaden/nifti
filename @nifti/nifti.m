classdef nifti
    %NIFTI Memory-mapped MATLAB input/output for NIfTI-1 data sets.
    %
    %Copyright (c) 2017 Enrico Kaden & University College London
    
    properties (SetAccess = private)
        filename
        writable
        datatype
        dim
        pixdim
    end
    
    properties (GetAccess = private, SetAccess = private)
        offset
        scaling
        header % TODO: mmapped?
        % TODO: extender (mmapped)?
        % TODO: extension (mmapped, jsonencode/jsondecode)?
        mmap
    end
    
    methods
        function str = get.datatype(obj)
            str = raw2datatype(obj.datatype);
        end
        
        function obj = nifti(filename, varargin)
            %NIFTI Create memory-mapped MATLAB input/output for NIfTI-1 data set.
            %Input argument(s):
            %  filename   ... file name
            %  'cal'      ... minimum/maximum display intensity
            %  'datatype' ... data type
            %  'dim'      ... array size
            %  'like'     ... reference NIfTI-1 data set
            %  'pixdim'   ... pixel size
            %  'writable' ... writable
            %Output argument(s):
            %  obj        ... NIfTI-1 data set
            %
            %Copyright (c) 2017 Enrico Kaden & University College London
            
            if nargin < 1
                error('Not enough input arguments.');
            end
            
            [pathstr, name, ext] = fileparts(filename);
            if isempty(pathstr)
                pathstr = '.';
            end
            if ~strcmpi(ext, '.nii')
                error('Only uncompressed .nii NIfTI-1 data sets are supported');
            end
            obj.filename = fullfile(pathstr, [name ext]);
            
            if exist(obj.filename, 'file') == 2
                obj.writable = false;
                
                if rem(nargin-1, 2) ~= 0
                    error('Param/value pairs must come in pairs.');
                end
                for ii = 1:2:length(varargin)
                    switch varargin{ii}
                        case 'cal'
                            error('NIfTI file already exists');
                        case 'datatype'
                            error('NIfTI file already exists');
                        case 'dim'
                            error('NIfTI file already exists');
                        case 'like'
                            error('NIfTI file already exists');
                        case 'pixdim'
                            error('NIfTI file already exists');
                        case 'writable'
                            obj.writable = varargin{ii+1};
                        otherwise
                            error('Unknown param/value pair.');
                    end
                end
                
                [fid, msg] = fopen(obj.filename, 'r');
                if fid < 0
                    error(msg);
                end
                raw = fread(fid, 352, 'uint8=>uint8');
                if size(raw, 1) < 352
                    error('File is not large enough.');
                end
                fseek(fid, 0, 'eof');
                filesize = ftell(fid);
                fclose(fid);
                
                obj.header = raw2header(raw.');
                if ~(0 <= obj.header.dim(1) && obj.header.dim(1) <= 7)
                    error('Change of endianness is not supported.')
                end
                if any(obj.header.dim(2:obj.header.dim(1)+1) < 0)
                    error('Dimensions are out of range.');
                end
                obj.dim = cast(obj.header.dim(2:obj.header.dim(1)+1), 'double');
                if isempty(raw2datatype(obj.header.datatype))
                    error('Unknown datatype.');
                end
                obj.datatype = cast(obj.header.datatype, 'double');
                obj.pixdim = cast(obj.header.pixdim(2:obj.header.dim(1)+1), 'double');
                obj.offset = cast(obj.header.vox_offset, 'double');
                if (obj.header.scl_slope ~= 0 && obj.header.scl_slope ~= 1) || obj.header.scl_inter ~= 0
                    if obj.writable
                        error('Data scaling is not supported.');
                    else
                        obj.scaling.slope = cast(obj.header.scl_slope, 'double');
                        obj.scaling.offset = cast(obj.header.scl_inter, 'double');
                    end
                else
                    obj.scaling.slope = 1;
                    obj.scaling.offset = 0;
                end
                if obj.header.magic(2) ~= '+'
                    error('Only one-file scheme is supported.')
                elseif obj.offset < 352
                    error('Offset is out of range.');
                end
                if filesize < obj.offset+bytesize(obj.datatype)*prod(obj.dim)
                    error('File is not large enough.');
                end
            else
                obj.writable = true;
                
                cal = [];
                if rem(nargin-1, 2) ~= 0
                    error('Param/value pairs must come in pairs.');
                end
                for ii = 1:2:length(varargin)
                    switch varargin{ii}
                        case 'cal'
                            cal = varargin{ii+1};
                        case 'datatype'
                            obj.datatype = datatype2raw(varargin{ii+1});
                        case 'dim'
                            obj.dim = varargin{ii+1};
                            if numel(obj.dim) < 1 || numel(obj.dim) > 7
                                error('Number of dimensions is out of range.');
                            end
                        case 'like'
                            if isa(varargin{ii+1}, 'nifti')
                                like = varargin{ii+1};
                            elseif isa(varargin{ii+1}, 'char')
                                like = nifti(varargin{ii+1});
                            else
                                error('Like parameter is unknown.');
                            end
                            obj.header = defaultheader(like.header);
                        case 'pixdim'
                            obj.pixdim = varargin{ii+1};
                            if numel(obj.dim) < 1 || numel(obj.dim) > 7
                                error('Number of pixel dimensions is out of range.');
                            end
                        case 'writable'
                            obj.writable = varargin{ii+1};
                            if varargin{ii+1} ~= true
                                error('Writable parameter is not true.');
                            end
                        otherwise
                            error('Unknown param/value pair.');
                    end
                end
                if isempty(obj.datatype) && isempty(obj.header)
                    error('Datatype is not provided.');
                end
                if isempty(obj.dim) && isempty(obj.header)
                    error('Dimension is not provided.');
                end
                if isempty(obj.pixdim) && isempty(obj.header)
                    error('Pixel dimension is not provided.');
                end
                obj.offset = 352;
                
                if isempty(obj.header)
                    obj.header = defaultheader();
                end
                if isempty(obj.dim)
                    if ~(0 <= obj.header.dim(1) && obj.header.dim(1) <= 7)
                        error('Change of endianness is not supported.')
                    end
                    if any(obj.header.dim(2:obj.header.dim(1)+1) < 0)
                        error('Dimensions are out of range.');
                    end
                    obj.dim = cast(obj.header.dim(2:obj.header.dim(1)+1), 'double');
                else
                    obj.header.dim(1) = cast(numel(obj.dim), 'int16');
                    obj.header.dim(2:numel(obj.dim)+1) = cast(obj.dim, 'int16');
                    obj.header.dim(numel(obj.dim)+2:end) = int16(0);
                end
                if isempty(obj.datatype)
                    obj.datatype = cast(obj.header.datatype, 'double');
                else
                    obj.header.datatype = cast(datatype2raw(obj.datatype), 'int16');
                    obj.header.bitpix = cast(8*bytesize(obj.datatype), 'int16');
                end
                if isempty(obj.pixdim)
                    obj.pixdim = cast(obj.header.pixdim(2:obj.header.dim(1)+1), 'double');
                else
                    obj.header.pixdim(1) = single(1);
                    obj.header.pixdim(2:numel(obj.dim)+1) = cast(obj.pixdim, 'single');
                    obj.header.pixdim(numel(obj.dim)+2:end) = single(0);
                end
                if numel(obj.dim) ~= numel(obj.pixdim)
                    error('Number of dimensions does not equal number of pixel dimensions.');
                end
                obj.header.vox_offset = cast(obj.offset, 'single');
                obj.header.scl_slope = single(1);
                obj.header.scl_inter = single(0);
                obj.scaling.slope = 1;
                obj.scaling.offset = 0;
                if ~isempty(cal)
                    obj.header.cal_min = cast(cal(1), 'single');
                    obj.header.cal_max = cast(cal(2), 'single');
                end
                
                [fid, msg] = fopen(obj.filename, 'w');
                if fid < 0
                    error(msg);
                end
                raw = header2raw(obj.header).';
                count = fwrite(fid, raw, 'uint8');
                if count ~= size(raw, 1)
                    error('Unknown write error.');
                end
                if numel(obj.dim) == 1
                    count = fwrite(fid, zeros(obj.dim(1), 1, obj.datatype), obj.datatype);
                    if count ~= obj.dim(1)
                        error('Unknown write error.');
                    end
                else
                    for ii = 1:prod(obj.dim(3:end))
                        count = fwrite(fid, zeros(obj.dim(1)*obj.dim(2), 1, obj.datatype), obj.datatype);
                        if count ~= obj.dim(1)*obj.dim(2)
                            error('Unknown write error.');
                        end
                    end
                end
                fclose(fid);
            end
            
            switch obj.datatype
                case 'csingle'
                    obj.mmap = memmapfile(obj.filename, 'Format',  {'single', [2, obj.dim], 'data'}, 'Offset', obj.offset, 'Repeat', 1, 'Writable', obj.writable);
                case 'cdouble'
                    obj.mmap = memmapfile(obj.filename, 'Format',  {'double', [2, obj.dim], 'data'}, 'Offset', obj.offset, 'Repeat', 1, 'Writable', obj.writable);
                otherwise
                    obj.mmap = memmapfile(obj.filename, 'Format',  {obj.datatype, obj.dim, 'data'}, 'Offset', obj.offset, 'Repeat', 1, 'Writable', obj.writable);
            end
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