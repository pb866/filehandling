__precompile__()

module filehandling

# Track changes during development
using Revise

# Load Julia packages
using DataFrames

# Export functions
export readfile,
       readTUV


#########################################
###  P U B L I C   F U N C T I O N S  ###
#########################################

"""
    readfile(ifile::String; rmhead::Int=0, rmtail::Int=0)

Read content from `ifile` and return an array with its lines.

Omit first `rmhead` lines and last `rmtail` lines, if keyword arguments are specified.
"""
function readfile(ifile::String; rmhead::Int=0, rmtail::Int=0)

  lines = []
  # Read lines from file
  open(ifile,"r") do f
    lines = readlines(f)
    # Delete header
    for i = 1:rmhead
      shift!(lines)
    end
    # Delete footer
    for i = 1:rmtail
      pop!(lines)
    end
  end #close file

  # Return array with lines
  return lines
end #function readfile


"""
    readTUV(<TUV 5.2 input file>)

Read in data from TUV (version 5.2 format) output file and save
χ-dependent _j_ values to dataframe.
Return arrays of solar zenith angles in deg and rad and DataFrame with _j_ values.
"""
function readTUV(ifile)

  # Read reactions and j values from input file
  jvals = []; sza = []; χ = []
  rxns = []
  open(ifile,"r") do f
    lines = readlines(f)
    istart = findfirst(occursin.("Photolysis rate coefficients, s-1", lines)) + 1
    iend   = findfirst(occursin.("values at z", lines)) - 1
    rxns = [line[7:end] for line in lines[istart:iend]]
    pushfirst!(rxns, "sza")
    jvals, sza, χ = read_data(lines,rxns)
  end
  return jvals, sza, χ
end #function readTUV


###########################################
###  P R I V A T E   F U N C T I O N S  ###
###########################################

"""
    read_data(lines::Vector{String},rxns::Vector{String})

From the `lines` of the TUV output and a list of the reactions (`rxns`),
retrieve χ-dependent _j_ values and return a DataFrame with the _j_ values and
the `rxns` as column names as well as vectors of the solar zenith angles in
deg and rad.
"""
function read_data(lines::Vector{String},rxns::Vector{String})

  # Retrieve j values from TUV output
  istart = findfirst(occursin.("sza, deg.", lines)) + 1
  iend   = findlast(occursin.("---", lines)) - 1
  rawdata = split.(lines[istart:iend])
  rawdata = map(x->parse.(Float64,x),rawdata)

  # Arrange j values in a DataFrame with reactions as column names
  jvals = DataFrame()
  for i = 2:length(rxns)
    if rawdata[1][i] > 0.
      # Pack j values into a DataFrame
      jvals[Symbol(rxns[i])] = [rawdata[j][i] for j = 1:length(rawdata)]
    else
      # Exclude data without values above 0
      println("\033[95mReaction with no data skipped:\033[0m")
      println(rxns[i])
    end
  end
  # Save solar zenith angles in deg and rad
  sza = [rawdata[j][1] for j = 1:length(rawdata)]
  χ = deepcopy(sza).*π./180.

  # Return completed dataframe
  return jvals, sza, χ

end #function read_data

end #module filehandling
