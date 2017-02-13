# NIfTI

Memory-mapped MATLAB input/output for NIfTI-1 data sets. This software was developed and is maintained by [Enrico Kaden](https://ekaden.github.io) from University College London.

## Installation

NIfTI requires [Mathworks MATLAB](https://www.mathworks.com/products/matlab.html) (version R2012b or later). The toolbox is straightforward to install.

Clone the NIfTI repository and checkout the latest release:
```bash
git clone https://github.com/ekaden/nifti.git
cd nifti
git fetch -p
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
cd ..
```

Add the installation directory of the NIfTI toolbox to MATLAB’s search path:
```MATLAB
addpath('/path/to/nifti');
```
Alternatively, `pathtool` can be used to update the search path permanently.

## Usage

```MATLAB
input = nifti('input.nii');
output = nifti('output.nii', 'like', input);
output(:, :, :) = input(:, :, :);
```
Type `help nifti` or `doc nifti` for more information.

## Limitations

* Only uncompressed `.nii` NIfTI-1 data files can be read and written.
* The following data types are supported:
  - Integer numbers: `int8`, `uint8`, `int16`, `uint16`, `int32`, `uint32`, `int64`, `uint64`
  - Floating-point numbers: `single`, `double`, `csingle` (complex-valued `single`), `cdouble` (complex-valued `double`)

## License

NIfTI is released under the [BSD Two-Clause License](LICENSE.md).