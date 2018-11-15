__precompile__()


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

# Export functions
export readfile,
       test_file,
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
    test_file(ifile::AbstractString; dir::AbstractString="./")

Check for existance of ifile. If file doesn't exist, ask for a file name until
file is found. If `default_dir` is specified, rdinp will look for `ifile` in this
directory, if `ifile` does not include a folder path.
"""
function test_file(ifile::AbstractString; dir::AbstractString="./")

  # Add default directory, if folder path in file name is missing
  fname = basename(ifile); fdir = dirname(ifile)
  if fdir == ""  fdir = dir  end
  ifile = normpath(joinpath(fdir,fname))

  # Test existance of file or ask for user input until file is found
  while !isfile(ifile)
    println("File $ifile does not exist!")
    ifile = input("Enter file (or press <ENTER> to quit): ")
    if ifile==""  exit()  end
  end

  return ifile
end #function test_file


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
    rxns = strip.([line[7:end] for line in lines[istart:iend]])
    pushfirst!(rxns, "sza")
    jvals, sza, χ = read_data(lines,rxns)
  end
  return Dict(:jvals => jvals, :deg => sza, :rad => χ)
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
function read_data(lines::Vector{String},rxns::Vector{SubString{String}})

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
