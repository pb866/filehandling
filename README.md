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


Version history
===============

Version 0.1.2
-------------
- readTUV return dictionary with entries `:jvals`, `:deg`/`:rad` (for solar zenith angles)
  instead of separate variables
  
Version 0.1.1
-------------
- new function `test_file` to test the existence of a file

Version 0.1.0
-------------
- Initial Julia package for simple file handling tasks with functions
  - `readfile` to read numerical data from simple text files with certain formats
  - `readTUV` to read solar zenith angles and j values from TUV files
