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
```

or in Julia go to the Package Manager by pressing `]` and type

```julia
add "https://github.com/pb866/filehandling.git"
```

# Usage

Import package with 

```julia
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
