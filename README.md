# Module filehandling

Current versions can read any files with the option to skip leading or
trailing lines or read TUV 5.2 files (or version with the same format)
and save j values to a DataFrame and solar zenith angles in deg/rad to
arrays.

The module is designed for Julia v0.7 and higher.

# Installation

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

# Usage

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


To read the contents of TUV 5.2 output files use

```julia
jvals = readTUV(file)
```

where file is the name of the TUV output file. Data is stored in a `mutable struct` `PhotData`, where the fields `jval` are assigned with a DataFrame with the _j_ values for every reaction using the TUV reaction labels as header, solar zenith angles are stored in the fields `deg` and `rad` in the respective units, the `order` of magnitude of each _j<sub>max</sub>_ is stored in the field order and the reaction labels are stored in the field `rxn`.


Version history
===============

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
