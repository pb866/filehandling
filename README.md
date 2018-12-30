Module filehandling
===================

Current versions can read any files with the option to skip leading or
trailing lines or read TUV 5.2 files (or version with the same format)
and save j values to a DataFrame and solar zenith angles in deg/rad to
arrays.

The module is designed for Julia v0.7 and higher.

Installation
------------

Install in the package manager with:

```
julia> ]
pkg> add https://github.com/pb866/filehandling.git
pkg> instantiate
pkg> precompile
```

Usage
-----

Import package with

```julia
using Pkg
Pkg.activate("path/to/Project.toml")
using filehandling
```
### Function test_file

To test the existence of a file use
```julia
ifile = test_file(ifile::AbstractString; dir::AbstractString="./")
```

where the directory of the file can either be specified as relative or absolute
path in the file name of `ifile` directly or in a separate keyword argument `dir`.


### Function readfile

To read from a file use

```julia
content = readfile(ifile::String, headerskip=n, footerskip=m)
```

where n and m are the number of line numbers to be excluded at the beginning
end of the file, respectively.

To test the existance of a file use

### Function read_data

More complex loading of data can be performed with `read_data`, where data is stored
in a `DataFrame` with columns from the file data. Numbers and dates are automatically
converted to their respective types, and default error values can be specified for
missing or faulty data.

The following keyword arguments are available:


- `dir` (`String = "."`): Directory of the input file `ifile`
  (can also be specified directly in `ifile`)
- `x` (`Union{Int64,Vector{Int64}} = 1`): Column index for column in `ifile`
  holding the x data (default column name in output DataFrame: `x` or `xi`, i = 1...n).
  If `x` is set to `0`, no x column is assigned and only y columns are used in the DataFrame
  (with default values `y` or `yi`, i = 1...n)).
- `SF` (default value: `1` (no scaling)): Optional scaling factor for all data.
- `SFx` (default value: `1` (no scaling)): Optional scaling factor for x data.
- `SFy` (default value: `1` (no scaling)): Optional scaling factor for y data.
- `sep` (`String`, default: `whitespace`): You can specify any column separator with the
  keyword charactar `sep`. Separators can be any unicode character (even special
  characters such as `≠` or `α`) or string series of unicode characters
  (including whitespace). The default splits using any number of whitespace, if you
  want to include empty columns, you need to specify the whitespace explicitly with
  `sep`.
- `colfill` (`String = "last"`): If the column length of the input file varies,
  the `"first"` or `"last"` columns of the file are filled with `err` (default values)
  according to the keyword. If you have a file with shorter columns to the right and the left,
  you either need to rearrange columns in the original data file or try to work
  with a specifically defined separator `sep`.
- `ncols` (`String = 0`): Defines the number of columns (x + y columns) in a file.
  If set to a `0`, the number of columns is derived from `colnames` or, if obsolete,
  from the first non-comment line of the file. You should only have to set the number
  of columns, if you have columns of different length with leading missing numbers and
  use whitespace as separator or if you want to exclude a large number of columns in
  your DataFrame.
- `header` (`Int64 = 0`): Optional line holding header names. Default values are
  used, if set to `0`, positive values indicate the line number starting at the first
  data line (non-comment line or line after `headerskip`), negative values indicate
  line number going upwards from the first data line (e.g. `-1` is line above first data line).
  Routine may fail, if comment lines are used after skipped header lines.
- `headerskip` (`Union{Int64,String,Regex} = 0`): Define how many lines to ignore
  at the beginning of a file. If a string or regex expression is used, all lines
  up to the last instance are ignored.
- `footerskip` (`Union{Int64,String,Regex} = 0`): Define how many lines to ignore
  at the end of a file. If a string or regex expression is used, all lines
  starting from the first instance are ignored.
- `comment` (`String = "#"`): String that defines in-line and line comments
- `err` (Union{Float64,String,Missing,Vector{Any}}): Specify default values for
  missing data or data that cannot be converted to a data type (can include a `Number`,
  `NaN`, `missing`). By default, `Int` and `Float` columns use `NaN` and are always
  return as `Float64`, `DateTime` uses `DateTime(0)`. If no value could be converted
  in a column a `String` vector is return, to allow text columns by default.
- `coltypes` (`Union{DataType,Vector{DataType}}`): If specified, `read_data` tries to
  convert each column into the specified type, on failure the default or specified
  `err` values are used. Either use `Vector{DataType}` for each column or `DataType`
  for a global value. (If errors are encountered in the data, 64 bit data types will
  automatically assigned.)
- `colnames` (`Vector{String} = String[]`): Specify header names for the output
  dataframe directly as kwarg. Overwrites values, derived from the input file.


### Function readTUV

To read the contents of TUV 5.2 output files use

```julia
jvals = readTUV(ifile::String, O3col::Number=350)
```

where `ifile` is the name of the TUV output file and O3col is the overlying
ozone column in DU as defined in the TUV run. Data is stored in a immutable
`struct` `TUVdata`, where the fields `jval` are assigned with a DataFrame
with the _j_ values for every reaction using the TUV reaction labels as header,
solar zenith angles are stored in the fields `deg` and `rad` in the respective
units, the `order` of magnitude of each _j<sub>max</sub>_ is stored in the
field order, the reaction labels are stored in the field `rxn`, and the respective
MCM and TUV reaction numbers for `rxn` are stored in fields `mcm` and `tuv`.
`O3col` is stored in a field `O3col` as defined by the input parameter.

### Data struct TUVdata

Function `readTUV` returns a immutable struct `TUVdata` with the following fields:
- jval::DataFrame
- order::Vector{Int64}
- deg::Vector{Float64}
- rad::Vector{Float64}
- rxn::Vector{String}
- mcm::Vector{Int64}
- tuv::Vector{Int64}
- O3col::Number


Customisation
-------------

Function `readTUV` works for every file in the format of TUV 5.2, however, if you customised TUV and added reactions to the input files, you will need to ammend the md file in `src/data/` by the following information:
```
<MCM rxn number> | <TUV rxn number> | <TUV rxn label>
```
TUV number must be an integer taken from the input file column 2 to 4. MCM must be an integer as used in the MCM mechanism, which can optionally be wrapped in `J(...)`, e.g.:
```
  J(11021)  |   24 | CH3CHO -> CH3 + HCO
```


Version history
===============

Version 0.4.1
-------------
- Don't use separate splitting rules for column names to allow spaces in header
  names and avoid duplicates or unwanted results in column names
- Bug fix

Version 0.4.0
-------------
- New Function `read_data` to load data from a text file into a `DataFrame` and convert numbers and dates to their respective types (taken from module pyp: https://github.com/pb866/pyp.git)
- Updated kwargs in function `readfile`: use `headerskip`/`footerskip` for `rmhead`/`rmfoot`
- Update `readfile` to Julia 1.0 standard

Version 0.3.1
-------------
- Remove test print statements in `readTUV`

Version 0.3.0
-------------
- New fields `mcm` and `tuv` in `TUVdata` with vectors of integers with the reaction numbers for the labels in `rxn`
- Relies on the md file for reaction numbers in folder src/data/

Version 0.2.3
-------------
- Field `order` in struct `TUVdata` is now a vector of integers

Version 0.2.2
-------------
- Added field `O3col` of type `Number` to `TUVdata` to specify ozone column conditions in TUV runs with a new input parameter for function `readTUV` (default: `350`)

Version 0.2.1
-------------
- Turn mutable struct `PhotData` into immutable struct `TUVdata`
- Reduce fields to TUV data only without MCMparameterisations and statistical data

Version 0.2.0
-------------
- New mutable struct `PhotData` containing TUV calculated j values, MCM photolysis parameters and related statistical data
- `readTUV` now returns `PhotData` rather than a dictionary

Version 0.1.3
-------------
- Strip reactions in DataFrame header with TUV data in function readTUV

Version 0.1.2
-------------
- `readTUV` return dictionary with entries `:jvals`, `:deg`/`:rad` (for solar zenith angles)
  instead of separate variables

Version 0.1.1
-------------
- new function `test_file` to test the existence of a file

Version 0.1.0
-------------
- Initial Julia package for simple file handling tasks with functions
  - `readfile` to read numerical data from simple text files with certain formats
  - `readTUV` to read solar zenith angles and j values from TUV files
