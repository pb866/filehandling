"""
# Module filehandling

Read from and write to files and manipulate file content.
"""
module filehandling

# Track changes during development
# using Revise

# Load Julia packages
using DataFrames
using Juno: input
using Dates

# Export functions
export read_data,
       readfile,
       test_file,
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
- `  O3col::Number`: Overlying ozone column value in DU from TUV run as defined by function `readTUV`
"""
struct TUVdata
  jval::DataFrame
  order::Vector{Int64}
  deg::Vector{Float64}
  rad::Vector{Float64}
  rxn::Vector{String}
  mcm::Vector{Int64}
  tuv::Vector{Int64}
  O3col::Number
end

include("TUV.jl")
include("file.jl")

end #module filehandling
