"""
    readTUV(ifile::String, O3col::Number=350)

Read in data from TUV `ifile` (version 5.2 format) and specify `O3col` (ozone column)
conditions and save χ-dependent _j_ values to dataframe.

Return immutable struct `TUVdata` with fields `jval`, `order`, `rxn`, `deg`, `rad`,
and `O3col` with _j_ values, order of magnitude, reaction labels, and solar zenith
angles in deg/rad, and ozone column, respectively.
"""
function readTUV(ifile::String, O3col::Number=350)

  # Read reactions and j values from input file
  jvals = []; order = []; sza = []; χ = []
  open(ifile,"r") do f
    lines = readlines(f)
    istart = findfirst(occursin.("Photolysis rate coefficients, s-1", lines)) + 1
    iend   = findfirst(occursin.("values at z", lines)) - 1
    rxns = strip.([line[7:end] for line in lines[istart:iend]])
    pushfirst!(rxns, "sza")
    jvals, order, sza, χ = read_jvals(lines,rxns)
  end
  mcmlabel, tuvlabel = get_photlabel(string.(names(jvals)))

  # Return immutable struct with TUV data
  return TUVdata(jvals, order, sza, χ, string.(names(jvals)),
                 mcmlabel, tuvlabel, O3col)
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
      println("\033[95mReaction with no data skipped:\033[0m")
      println(rxns[i])
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
    get_photlabel(rxns::Vector{String})

Return MCM and TUV reaction numbers for the reactions defined in the vector `rxns`
using TUV reaction labels.
"""
function get_photlabel(rxns::Vector{String})
  # Read reactions and label from wiki md file
  labels = readfile(joinpath(@__DIR__, "data/Photolysis-reaction-numbers.md"))
  tuvlabel = []; mcmlabel = []
  # Loop over current reactions and retrieve MCM and TUV labels
  for rxn in rxns
    i = findfirst(occursin.(rxn,labels))
    mcm = replace(split(labels[i], "|")[1], "J(" => "")
    mcm = replace(mcm, ")" => "")
    push!(mcmlabel, parse(Int64, mcm))
    push!(tuvlabel, parse(Int64, split(labels[i], "|")[2]))
  end

  # Return labels as integers
  return mcmlabel, tuvlabel
end #function get_photlabel
