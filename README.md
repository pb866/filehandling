Module filehandling
===================

Current versions can read any files with the option to skip leading or
trailing lines or read TUV 5.2 files (or version with the same format)
and save j values to a DataFrame and solar zenith angles in deg/rad to
arrays.

The module is designed for Julia v0.7 and higher.

Installation
------------

Install with

```julia
using Pkg
Pkg.add("https://github.com/pb866/filehandling.git")
Pkg.instantiate()
```

or in Julia go to the Package Manager by pressing `]` and type

```julia
add "https://github.com/pb866/filehandling.git"
instantiate
```

Usage
-----

Import package with

```julia
using Pkg
Pkg.activate("path/to/Project.toml")
using filehandling
```

To read from a file use

```julia
content = readfile(ifile::String, rmhead=n, rmtail=m)
```

where n and m are the number of line numbers to be excluded at the beginning
end of the file, respectively.

To test the existance of a file use

    test_file(ifile::AbstractString; dir::AbstractString="./")

where `ifile` is the file name. A folder path (relative or absolute) can either 
be defined directly in the file name or by the keyword argument `dir`. The function
asks for user input in case of non-existent files.


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
