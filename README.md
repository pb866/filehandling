Module filehandling
===================

Current versions can read any files with several options to skip leading or
trailing lines and save data in columns of a `DataFrame`. Numbers can be converted
into integers or floats. Furthermore, TUV 5.2 files (or versions with the same format)
can be read and _j_ values saved to a `DataFrame` together with solar zenith angles
in deg/rad in arrays all stored in an immutable struct `TUVdata`.

The module is designed for Julia v0.7 and higher.


Installation
------------

Install in the package manager with:

```
julia> ]
pkg> add https://github.com/pb866/filehandling.git
```


Usage
-----

Import package with

```julia
using Pkg
Pkg.activate("path/to/Project.toml")
using filehandling
```

Omit the first 2 steps, if you installed `filehandling` to the main julia environment.


### Function filetest

To test the existence of a file use
```julia
ifile = filetest(ifile::AbstractString; dir::AbstractString="./")
```

where the directory of the file can either be specified as relative or absolute
path directly in the file name of `ifile` or in a separate keyword argument `dir`.

The function returns a string with the absolute file path or asks for user input, if `ifile` doesn't exist. For non-existing files, an empty string is returned.


### Function readfile

To read from a file use

```julia
content = readfile(ifile::String, headerskip=n, footerskip=m, dir::AbstractString="./")
```

where `n` and `m` are the number of lines to be excluded at the beginning
end of the file, respectively. The file directory is extracted directly from the
filename or, alternatively, taken from the keyword argument `dir` as relative or absolute path.

To test the existence of a file use function `filetest`.

### Function loadfile

More complex loading of data can be performed with `loadfile`, where data is stored
in a `DataFrame` with columns from the file data. Numbers and dates are automatically
converted to their respective types, and default error values can be specified for
missing or faulty data.

```julia
content = loadfile(ifile::String; kwargs)
```

The following keyword arguments are available:

- `dir` (`String = "."`): Directory of the input file `ifile`
  (can also be specified directly in `ifile`, the kwarg `dir` is ignored)
- `x` (`Union{Int64,Vector{Int64}} = 1`): Column index for column in `ifile`
  holding the x data (default column name in output DataFrame: `x` or `xi`, i = 1...n).
  If `x` is set to `0`, no x column is assigned and only y columns are used in the DataFrame
  (with default values `y` or `yi`, i = 1...n)).
- `SF` (default value: `1` (no scaling)): Optional scaling factor for all data.
- `SFx` (default value: `1` (no scaling)): Optional scaling factor for x data.
- `SFy` (default value: `1` (no scaling)): Optional scaling factor for y data.
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
- `sep` (`String`, default: `whitespace`): You can specify any column separator with the
  keyword charactar `sep`. Separators can be any unicode character (even special
  characters such as `≠` or `α`) or string series of unicode characters
  (including whitespace). The default splits using any number of whitespace, if you
  want to include empty columns, you need to specify the whitespace explicitly with
  `sep`.
- `escchar` (`Union{Char,String,Vector{Char},Vector{String}} = ['\"', '\'']`):
  Characters or Strings used to escape Strings (separators are ignored within matching
  escape characters). A series of escape characters can be defined as vectors, but
  each sequence must be matched by the same escape characters, e.g. `"` and `'` are used
  as default, but a sequence cannot be started with a single quote and ended with a
  double quote or vice versa.
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
- `err` (Union{Int64,Float64,String,Missing,Vector{Any}}): Specify default values for
  missing data or data that cannot be converted to a data type (can include a `Number`,
  `NaN`, `missing`). By default, `Int` and `Float` columns use `NaN` and are always
  return as `Float64`, `DateTime` uses `DateTime(0)`. If no value could be converted
  in a column a `String` vector is return, to allow text columns by default.
- `coltypes` (`Union{DataType,Vector{DataType}}`): If specified, `loadfile` tries to
  convert each column into the specified type, on failure the default or specified
  `err` values are used. Either use `Vector{DataType}` for each column or `DataType`
  for a global value. (If errors are encountered in the data, 64 bit data types will
  automatically assigned.)
- `colnames` (`Vector{String} = String[]`): Specify header names for the output
  dataframe directly as kwarg. Overwrites values, derived from the input file.


### Function readTUV

To read the contents of TUV 5.2 output files use

```julia
jvals = readTUV(ifile::String; dir::String="./", DU::Number=350, MCMversion::Int64=4)
```

where `ifile` is the name of the TUV output file with the absolute or relative folder
path given in the file name or the keyword argument `dir`. `DU` is the overlying
ozone column in Dobson units as defined in the TUV run. Data is stored in a immutable
`struct` `TUVdata`, where the fields `jval` are assigned with a DataFrame
with the _j_ values for every reaction using the TUV reaction labels as header,
solar zenith angles are stored in the fields `deg` and `rad` in the respective
units, the `order` of magnitude of each _j<sub>max</sub>_ is stored in the
field order, the reaction labels are stored in the field `rxn`, and the respective
MCM and TUV reaction numbers for `rxn` are stored in fields `mcm` and `tuv`. To
assign the correct MCM reaction numbers, the `MCMversion` needs to be and can be
inputted as:

- `2`: MCMv3.2 and older
- `3`: MCMv3.3.1
- `4`: MCM/GECKO-A

The ozone column in Dobson units is stored in a field `DU` as defined by the input parameter.

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

Function `readTUV` works for every file in the format of TUV 5.2, however, if you
customised TUV and added reactions to the input files, you will need to amend the
database files in the `data` folder. They are necessary to assign TUV and MCM
reaction numbers to the dataset.

MCM database files use a pipe (`|`) as column separator, a hash sign as comment (`#`)
and store the reaction number in the first column and the TUV reaction string
(from the I/O files) in the last column. Database files exist for 3 MCM versions:

- MCMv32.db for MCMv3.2 and older
- MCMv331.db for the most recent MCMv3.3.1
- MCM-GECKO-A.db for MCM/GECKO-A version, where the MCM is auto-generated with the help of GECKO-A

For the older MCMv3.2 files an additional column with scaling factors exist, which is ignored in this context.rxn number> | <TUV rxn number> | <TUV rxn label>

If you want to add/change reaction numbers, use the database files in the data folder
as template and add new numbers according to the above rules. Make sure, reaction numbers
are saved in the first and the TUV labels exactly as they are in the TUV input file
are saved in the last column of the database file. The first line of the file is reserved
for column headers, all other non-data lines need to be commented out with a `#`-sign.

To obtain TUV numbers, a database file need to be saved to the data folder with the
mechanism section from the TUV input file (see TUVrxns.db as template for the current TUV version).

If you add files or modify file names you need to adjust the file reading in function
`get_photlabel` for the MCM database files and `getTUVrxns` for the TUV database file
in TUV.jl.



Version history
===============

Version 1.1.0
-------------
- Prefer package `import` over `using`
- Revise kwarg `dir` in all functions to always be combined with the file name,
  even if the file name already holds folder paths. This allows the combination of
  `@__DIR__` with relative folder paths scripts.
- Add kwarg `dir` to function `readTUV`
- Bug fixes

Version 1.0.0
-------------
- Revised database files for MCM and TUV reaction numbers
- Move data folder from src to main folder
- New kwarg `MCMversion` to specify MCM version number for correct reaction numbers
- Change kwarg `O3col` to `DU`
- Use `readline` instead of `Atom.input`
- Add kwarg `dir` for directory to function `readfile`

Version 0.5.0
-------------
- Rename functions (`test_file` to `filetest` and `read_data` to `loadfile`)
- Define escape characters to ignore separators
- Bug fixes

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
