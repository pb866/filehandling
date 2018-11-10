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
jvals, szadeg, szarad = readTUV(file)
```

where file is the name of the TUV output file.


Version history
===============

Version 0.1.2
-------------
- Returning dictionary from function `readTUV` with entries for j values, and solar zenith angles in deg and rad as Symbols `:jvals`, `:deg`, and `:rad`, respectively

Version 0.1.1
-------------
- New function `test_file` to test existence of a file (folder and file)
- Added package Juno to Project.toml

Version 0.1.0
-------------
- New function `readfile` to test existence of file and read contents
- New function `readTUV` to read solar zenith angles and j values from TUV files and return a DataFrame with the j values and vectors of the szas in deg and rad
