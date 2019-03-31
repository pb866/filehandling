"""
# Module filehandling

Read from and write to files and manipulate file content.

## Public functions
- `loadfile`
- `readfile`
- `filetest`
- `readTUV`

## Data types
- `TUVdata`
"""
module filehandling

# Track changes during development
# using Revise

# Load Julia packages
import DataFrames.DataFrame
import Dates

# Export functions
export loadfile,
       readfile,
       filetest,
       readTUV,
       TUVdata

### NEW TYPES
"""
    struct TUVdata

`TUVdata` has the following fields:
- `jval::DataFrame`: DataFrame with _j_ values and reaction labels as headers
- `order::Vector{Float64}`: order of magnitude of the maximum _j_ value in every reaction
- `deg::Vector{Float64}`: Vector of solar zenith angles of output in deg
- `rad::Vector{Float64}`: Vector of solar zenith angles of output in rad
- `rxn::Vector{String}`: Vector of strings with reaction labels from `jval` headers
- `mcm::Vector{Int64}`: Vector with MCM photolysis reaction numbers
- `tuv::Vector{Int64}`: Vector with TUV photolysis reaction numbers
- `DU::Number`: Overlying ozone column value in DU from TUV run as defined by function `readTUV`
"""
struct TUVdata
  jval::DataFrame
  order::Vector{Int64}
  deg::Vector{Float64}
  rad::Vector{Float64}
  rxn::Vector{String}
  mcm::Vector{Int64}
  tuv::Vector{Int64}
  DU::Number
end

include("TUV.jl")
include("file.jl")

end #module filehandling
