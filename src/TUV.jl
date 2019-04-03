"""
    readTUV(ifile::String; dir::String="./", DU::Number=350, MCMversion::Int64=4)

Read in data from TUV `ifile` (version 5.2 format) in directory `dir` and specify
`DU` (ozone column Dobson unit) conditions and save χ-dependent _j_ values with
additional Information as `TUVdata`. Specify the `MCMversion` number to return
the correct MCM reaction labels.

`MCMversion` numbers:
- `2`: MCMv3.2 or older
- `3`: MCMv3.3.1
- `4`: MCM/GECKO-A

Return immutable struct `TUVdata` with fields `jval`, `order`, `deg`, `rad`, `rxn`,
`mcm`, `tuv`, and `O3col` with _j_ values, order of magnitude, solar zenith angles
in deg/rad, reaction labels, reaction numbers in the MCM and TUV, and ozone column,
respectively.

Note: The directory can also be given directly in the file name. `readTUV` combines
`dir` and `ifile` and turns it into an absolute file path.
"""
function readTUV(ifile::String; dir::String="./", DU::Number=350, MCMversion::Int64=4)

  # Test existance of file and combine directory and file name
  ifile = filetest(ifile, dir = dir)
  if ifile == ""  return  end
  # Read reactions and j values from input file
  jvals = []; order = []; sza = []; χ = []
  open(ifile,"r") do f
    lines = readlines(f)
    istart = findfirst(occursin.("Photolysis rate coefficients, s-1", lines)) + 1
    iend   = findlast(occursin.("values at z", lines)) - 1
    rxns = strip.([line[7:end] for line in lines[istart:iend]])
    pushfirst!(rxns, "sza")
    jvals, order, sza, χ = read_jvals(lines,rxns)
  end
  mcmlabel, tuvlabel = get_photlabel(string.(names(jvals)), MCMversion)

  # Return immutable struct with TUV data
  return TUVdata(jvals, order, sza, χ, string.(names(jvals)),
                 mcmlabel, tuvlabel, DU)
end #function readTUV


"""
    read_jvals(lines::Vector{String},rxns::Vector{String})

From the `lines` of the TUV output and a list of the reactions (`rxns`),
retrieve χ-dependent _j_ values and return a DataFrame with the _j_ values and
the `rxns` as column names as well as vectors of the solar zenith angles in
deg and rad.
"""
function read_jvals(lines::Vector{String},rxns::Vector{SubString{String}})

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
      @info("\033[96mReaction with no data skipped:\033[0m\n$(rxns[i])")
    end
  end
  # Save solar zenith angles in deg and rad
  sza = [rawdata[j][1] for j = 1:length(rawdata)]
  χ = deepcopy(sza).*π./180.

  # Derive order of magnitude
  order = filter(!isinf, floor.(log10.(rawdata[1])))

  # Return completed dataframe
  return jvals, order, sza, χ
end #function read_jvals


"""
    get_photlabel(rxns::Vector{String}, MCMversion::Int64)

Return MCM and TUV reaction numbers for the reactions defined in the vector `rxns`
using TUV reaction labels. The index for the `MCMversion` number is needed to assign
the correct MCM reaction numbers.
"""
function get_photlabel(rxns::Vector{String}, MCMversion::Int64)
  # Read reactions and label from wiki md file
  if MCMversion == 2
    inpfile = "MCMv32.db"
  elseif MCMversion == 3
    inpfile = "MCMv331.db"
  elseif MCMversion == 4
    inpfile = "MCM-GECKO-A.db"
  else
    throw(ArgumentError(string("Unknown option for `MCMversion`.\n",
      "\033[0mChoose integer between `2` and `4`.")))
  end
  mcm = loadfile(inpfile, dir = normpath(joinpath(@__DIR__,"../data")),
    sep = "|", headerskip = 1)
  mcm[end] = strip.(mcm[end])
  tuvlabel = []; mcmlabel = []
  # Loop over current reactions and retrieve MCM and TUV labels
  tuv = getTUVrxns()
  for rxn in rxns
    i = findfirst(rxn .== mcm[end])
    j = findfirst(rxn .== tuv[end])
    if i == nothing
      @warn("\033[93mReaction not found in MCM database.\033[0m\n$rxn")
      push!(mcmlabel, 0)
    else
      push!(mcmlabel, mcm[1][i])
    end
    if j == nothing
      @warn("\033[93mReaction not found in TUV database.\033[0m\n$rxn")
      push!(tuvlabel, 0)
    else
      push!(tuvlabel, tuv[1][j])
    end
  end

  # Return labels as integers
  return mcmlabel, tuvlabel
end #function get_photlabel


"""
    getTUVrxns()

Read TUV reactions numbers from a TUV database file saved in folder `data` with
the mechanism section from the current TUV input file.
"""
function getTUVrxns()
  # Read database file
  lines = readfile(normpath(joinpath(@__DIR__, "../data/TUVrxns.db")))
  # Initialise
  j = Int64[]; rxn = String[]
  # Extract reactions and numbers from file
  for line in lines
    push!(j, parse(Int64, line[2:4]))
    push!(rxn, strip(line[6:end]))
  end

  # Return a DataFrame with reactions and numbers
  return DataFrame(j = j, rxn = rxn)
end #function getTUVrxns
