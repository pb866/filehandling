"""
    readfile(ifile::String; headerskip::Int=0, footerskip::Int=0, dir::AbstractString="./")

Read content from `ifile` and return an array with its lines.
The file directory is extracted directly from the filename or, alternatively,
taken from the keyword argument `dir`. The current folder is assumed, if no
directory is given.

Omit first `rmhead` lines and last `rmtail` lines, if keyword arguments are specified.
"""
function readfile(ifile::String; headerskip::Int=0, footerskip::Int=0, dir::AbstractString="./")

  # Add default directory, if folder path in file name is missing
  fname = basename(ifile); fdir = dirname(ifile)
  if fdir == ""  fdir = dir  end
  ifile = normpath(joinpath(fdir,fname))

  lines = []
  # Read lines from file
  open(ifile,"r") do f
    lines = readlines(f)
    # Delete header
    for i = 1:headerskip
      popfirst!(lines)
    end
    # Delete footer
    for i = 1:footerskip
      pop!(lines)
    end
  end #close file

  # Return array with lines
  return lines
end #function readfile


"""
    filetest(ifile::AbstractString; dir::AbstractString="./")

Check for existance of ifile. If file doesn't exist, ask for a file name until
file is found. If `default_dir` is specified, rdinp will look for `ifile` in this
directory, if `ifile` does not include a folder path.
"""
function filetest(ifile::AbstractString; dir::AbstractString="./")

  # Add default directory, if folder path in file name is missing
  fname = basename(ifile); fdir = dirname(ifile)
  if fdir == ""  fdir = dir  end
  ifile = normpath(joinpath(fdir,fname))

  # Test existance of file or ask for user input until file is found
  while !isfile(ifile)
    println("File $ifile does not exist!")
    print("Enter file (or press <ENTER> to quit): ")
    ifile = readline()
    if ifile==""  return ""  end
  end

  return ifile
end #function filetest


"""
    loadfile(ifile; \\*\\*kwargs)


Read data from text file `ifile`.

If columns don't have the same length, they can be filled with default values either
starting with the first or last columns.

The function uses several keyword arguments (\\*\\*kwargs) for more freedom in the
file format or the selection of data.

### \\*\\*kwargs

- `dir` (`String = "."`): Directory of the input file `ifile`
  (can also be specified directly in `ifile`, the kwarg `dir` is ignored)
- `x` (`Union{Int64,Vector{Int64}} = 1`): Column index for column in `ifile`
  holding the x data (default column name in output DataFrame: `x` or `xi`, i = 1...n).
  If `x` is set to `0`, no x column is assigned and only y columns are used in the DataFrame
  (with default values `y` or `yi`, i = 1...n)).
- `SF` (default value: `1` (no scaling)): Optional scaling factor for all data.
- `SFx` (default value: `1` (no scaling)): Optional scaling factor for x data.
- `SFy` (default value: `1` (no scaling)): Optional scaling factor for y data.
- `colfill` (`String = "last"`): If the column length of the input file varies,
  the `"first"` or `"last"` columns of the file are filled with `err` (default values)
  according to the keyword. If you have a file with shorter columns to the right and the left,
  you either need to rearrange columns in the original data file or try to work
  with a specifically defined separator `sep`.
- `ncols` (`String = 0`): Defines the number of columns (x + y columns) in a file.
  If set to a `0`, the number of columns is derived from `colnames` or, if obsolete,
  from the first non-comment line of the file. You should only have to set the number
  of columns, if you have columns of different length with leading missing numbers and
  use whitespace as separator or if you want to exclude a large number of columns in
  your DataFrame.
- `sep` (`String`, default: `whitespace`): You can specify any column separator with the
  keyword charactar `sep`. Separators can be any unicode character (even special
  characters such as `≠` or `α`) or string series of unicode characters
  (including whitespace). The default splits using any number of whitespace, if you
  want to include empty columns, you need to specify the whitespace explicitly with
  `sep`.
- `escchar` (`Union{Char,String,Vector{Char},Vector{String}} = ['\"', '\'']`):
  Characters or Strings used to escape Strings (separators are ignored within matching
  escape characters). A series of escape characters can be defined as vectors, but
  each sequence must be matched by the same escape characters, e.g. `"` and `'` are used
  as default, but a sequence cannot be started with a single quote and ended with a
  double quote or vice versa.
- `header` (`Int64 = 0`): Optional line holding header names. Default values are
  used, if set to `0`, positive values indicate the line number starting at the first
  data line (non-comment line or line after `headerskip`), negative values indicate
  line number going upwards from the first data line (e.g. `-1` is line above first data line).
  Routine may fail, if comment lines are used after skipped header lines.
- `headerskip` (`Union{Int64,String,Regex} = 0`): Define how many lines to ignore
  at the beginning of a file. If a string or regex expression is used, all lines
  up to the last instance are ignored.
- `footerskip` (`Union{Int64,String,Regex} = 0`): Define how many lines to ignore
  at the end of a file. If a string or regex expression is used, all lines
  starting from the first instance are ignored.
- `comment` (`String = "#"`): String that defines in-line and line comments
- `err` (Union{Int64,Float64,String,Missing,Vector{Any}}): Specify default values for
  missing data or data that cannot be converted to a data type (can include a `Number`,
  `NaN`, `missing`). By default, `Int` and `Float` columns use `NaN` and are always
  return as `Float64`, `DateTime` uses `DateTime(0)`. If no value could be converted
  in a column a `String` vector is return, to allow text columns by default.
- `coltypes` (`Union{DataType,Vector{DataType}}`): If specified, `loadfile` tries to
  convert each column into the specified type, on failure the default or specified
  `err` values are used. Either use `Vector{DataType}` for each column or `DataType`
  for a global value. (If errors are encountered in the data, 64 bit data types will
  automatically assigned.)
- `colnames` (`Vector{String} = String[]`): Specify header names for the output
  dataframe directly as kwarg. Overwrites values, derived from the input file.
"""
function loadfile(ifile::String; dir::String=".", x::Union{Int64,Vector{Int64}}=1,
  SF=1, SFx=1, SFy=1, colfill::String="last", ncols::Int64=0, sep::String="",
  escchar::Union{Char,String,Vector{Char},Vector{String}}=['\"', '\''],
  header::Int64 = 0, headerskip::Union{Int64,String,Regex}=0,
  footerskip::Union{Int64,String,Regex}=0, comment::String="#",
  err::Union{Int64,Float64,String,Missing,Vector{Any}}="",
  coltypes::Union{DataType,Vector{DataType}}=DataType[], colnames::Vector{String}=String[])

  # initialise
  ifile = filetest(ifile, dir = dir) # check existence of file
  if ifile == ""  return DataFrame()  end
  lines = String[]; y = Int64[]
  if x == 0  x = Int64[]  end

  # Read input file
  open(ifile,"r") do f
    # Read file
    lines = readlines(f)
    # Search for keyword for start/end of data
    if !isa(headerskip, Number) headerskip = findlast(occursin.(headerskip, lines))  end
    if !isa(footerskip, Number)
      footerskip = 1 + findfirst(occursin.(footerskip, lines)) - length(lines)
    end
    # delete leading and trailing whitespace
    lines = [replace(str, r"^[ \t]*" => "") for str in lines]
    lines = [replace(str, r"[ \t]*$" => "") for str in lines]
    # Find first non-ignored data line
    data1 = findfirst(broadcast(!, startswith.(lines, comment)) .& (lines .≠ ""))
    if data1 < headerskip  data1 = 1+headerskip  end

    # Define number of columns
    if ncols == 0
      lines[data1] = strip(replace(lines[data1], Regex("$comment.*") => ""))
      sep == "" ? ncols = length(split(lines[data1])) :
        ncols = length(split(lines[data1], sep))
    end
    # Determine y columns
    y = setdiff(collect(1:ncols), x)

    # Extract column header names, if specified
    if header ≠ 0 && isempty(colnames)
      # Find line with header names
      if header > 0  header -= 1  end
      ihead = data1 + header
      # retrieve header names
      colnames = replace(lines[ihead], Regex("^$comment") => "")
      colnames = strip(replace(colnames, Regex("$comment.*") => ""))
      sep == "" ? colnames = strip.(split(colnames)) : colnames = strip.(split(colnames, sep))
      if header ≥ 0 && ihead ≤ length(lines)-footerskip  deleteat!(lines, ihead)  end
    elseif isempty(colnames)
      colnames = Vector{String}(undef, ncols)
      if x isa Number
        colnames[x] = "x"
      else
        for (i, xi) in enumerate(x)
          colnames[xi] = "x$i"
        end
      end
      if length(y) == 1
        colnames[y[1]] = "y"
      else
        for (i, yi) in enumerate(y)
          colnames[yi] = "y$i"
        end
      end
    end

    # Check that length of colnames fits ncols
    if length(colnames) < ncols
      println("WARNING! Number of column names does not fit ncol;")
      println("colnames is appended with standard names.")
      for i = length(colnames)+1:ncols
        any(x.==i) ? push!(colnames, "x$i") : push!(colnames, "y$i")
      end
    elseif length(colnames) > ncols
      println("WARNING! Number of column names does not fit ncol.")
      println("The last $(length(colnames)-ncols) column names are ignored.")
      colnames = colnames[1:ncols]
    end

    # Skip last lines of a file, if skip_footer is set to integer > 0
    deleteat!(lines,1+length(lines)-footerskip:length(lines))
    # Skip first lines of a file, if skip_header is set to integer > 0
    deleteat!(lines,1:headerskip)
    # Find and delete comments
    lines = [replace(str, Regex("$comment.*") => "") for str in lines]
    # Find and delete empty lines
    deleteat!(lines,findall(lines.==""))
  end

  # Initilise matrix for file data
  filedata = Matrix{String}(undef, length(lines), ncols)
  # Loop over data lines
  for (i, line) in enumerate(lines)
    # Split into columns
    raw = escstrings(line, sep, escchar)
    # sep == "" ? raw = strip.(split(line)) : raw = strip.(split(line,sep))
    # Check number of current columns against maximum number of columns
    if length(raw) > ncols
      # println("WARNING! Number of columns read in greater than number of columns defined.")
      # println("The $colfill $(length(raw)-ncols) columns are ignored.")
      lowercase(colfill[1]) == "l" ? raw = raw[1:ncols] : raw = raw[length(raw)-ncols+1:end]
    elseif length(raw) < ncols && colfill == "first"
      [pushfirst!(raw, "") for i = 1+length(raw):ncols]
    elseif length(raw) < ncols && colfill == "last"
      [push!(raw, "") for i = 1+length(raw):ncols]
    end
    # Save line in matrix
    filedata[i,:] = raw

    # Convert data types, try specified column types first, otherwise:
    # Int -> Float -> Replace empty cells with NaN, try Float -> use String
  end


  # Generate output DataFrame
  output = DataFrame()
  if !isa(err, Vector)  e = []; [push!(e, err) for i = 1:ncols]; err = e  end
  if !isa(coltypes, Vector)
    ct = deepcopy(coltypes)
    coltypes = DataType[]
    for i = 1:ncols  push!(coltypes, ct) end
  end
  for i = 1:ncols
    col = filedata[:,i]
    if !isempty(coltypes)
      if coltypes[i] == String
        output[Symbol(colnames[i])] = col
        continue
      end
      try col = parse.(coltypes[i], col)
      catch
        col = convert_exceptions(col, err[i])
      end
      output[Symbol(colnames[i])] = col
    else
      try col = parse.(Int, col)
        output[Symbol(colnames[i])] = col
        continue
      catch
      end
      try col = parse.(Float64, col)
        output[Symbol(colnames[i])] = col
        continue
      catch
      end
      try col = parse.(DateTime, col)
        output[Symbol(colnames[i])] = col
        continue
      catch
        col = convert_exceptions(col, err[i])
        output[Symbol(colnames[i])] = col
      end
    end
  end
  # Scale data
  if SF isa Number
    s = []; [push!(s,SF) for i = 1:ncols]; SF = s
  end
  SFax = Vector{Any}(undef, ncols)
  for i in x
    SFx isa Vector ? SFax[i] = SFx[i] : SFax[i] = SFx
  end
  for i in y
    SFy isa Vector ? SFax[i] = SFy[i] : SFax[i] = SFy
  end
  for i = 1:ncols
    if SF[i] ≠ 1 && typeof(output[i]) ≠ Vector{DateTime}
      output[i] .*= SF[i]
    end
    if SFax[i] ≠ 1 && typeof(output[i]) ≠ Vector{DateTime}
      output[i] .*= SFax[i]
    end
  end
  # read_between Union{String, Regex}, err vector

  # Return file data as DataFrame
  return output
end #function loadfile


"""
    escstrings(dataline, sep, escchar)

Split `dataline` by `sep`, but ensure everything enclosed by `escchar` is treated
as one cell and `sep` within `escchar` is ignored.

Several `escchar` can be defined in a `Vector`, but each escape sequence must have
matching escape characters.
"""
function escstrings(dataline, sep, escchar)
  # Transform arrays with more than one separator into regex expression
  if escchar isa Vector  e = "("*join(escchar,"|")*")"  end

  # Return data using normal split rules, if no escape character is found
  if !occursin(Regex(e), dataline) && sep == ""
    return split(dataline)
  elseif !occursin(Regex(e), dataline)
    return split(dataline, sep)
  end

  # Search for escape characters in first cell
  escstart = findfirst(Regex("^[ \t]*$e"),dataline)
  # Initialise end of escaped string and index for start of search for escape characters
  escend = nothing; nsearch = 1
  # Initialise array with cell data
  returndata = []
  # Find first escape character, if first cell wasn't escaped
  if escstart == nothing
      escstart = findfirst(Regex("$sep[ \t]*$e"),dataline)
  end
  # Find matching escape character
  if escstart[end] < length(dataline)
    # Try to find matching character in line
    escend = findnext(Regex("$(dataline[escstart[end]])[ \t]*$sep"),
      dataline, escstart[end]+1)
    if escend == nothing
      # Try the end of the line, if match wasn't found in-line
      escend = findnext(Regex("$(dataline[escstart[end]])[ \t]*\$"),
        dataline, escstart[end]+1)
    end
    # If matching escape character wasn't found, set start to nothing
    if escend == nothing  escstart = nothing  end
  else
    # If last character is an opening escape character, set start and end to nothing
    escstart = escend = nothing
  end

  # If no matching escape characters were found, return array with cells
  # according to normal split rules
  if escstart == nothing && sep == ""
    return split(dataline)
  elseif escstart == nothing
    return split(dataline, sep)
  else
    # If matches were found, loop over line for more matching escape characters
    while escstart != nothing
      # In current section of line, split line before escaped section and save
      # together with escaped section to return data
      sep == "" ?
        returndata = vcat(returndata, strip.(split(dataline[nsearch:escstart[1]-1])),
        strip(dataline[escstart[end]+1:escend[1]-1])) :
        returndata = vcat(returndata, strip.(split(dataline[nsearch:escstart[1]-1], sep)),
        strip(dataline[escstart[end]+1:escend[1]-1]))
      # After saving of current section find start of next section of the data line
      nsearch = escend[end] + 1
      # Find the next escape character
      escstart = findnext(Regex("$sep[ \t]*$e"), dataline, nsearch)
      # Find matching escape character
      if escstart == nothing
        escend = nothing
      elseif escstart[end] < length(dataline)
        # Try finding in-line
        escend = findnext(Regex("$(dataline[escstart[end]])[ \t]*$sep"),
          dataline, escstart[end]+1)
        if escend == nothing
          # Try finding at the end of the line
          escend = findnext(Regex("$(dataline[escstart[end]])[ \t]*\$"),
            dataline, escstart[end]+1)
        end
        # Set start to nothing, if no matching escape character not found
        if escend == nothing  escstart = nothing  end
      else
        # No further escape characters
        escstart = escend = nothing
      end
    end
    # Write the remaining cell to line data, after the last escape characters are foundsep == "" ?
    sep == "" ?
      returndata = vcat(returndata, strip.(split(dataline[nsearch:end]))) :
      returndata = vcat(returndata, strip.(split(dataline[nsearch:end], sep)))
  end

  # Return data split into cells
  return returndata
end #function escstrings


"""
    convert_exceptions(col, err)

From vector `col` with current column data and default value `err` for data
that cannot be converted into a `DataType` `Int64`, `Float64`, or `DateTime`,
return the revised vector `col` with conversion failures replaced by `err`.
"""
function convert_exceptions(col, err)
  # Loop over data types
  for type in [Int, Float64, DateTime]
    revcol = Vector{Any}(undef, length(col)); count = 0
    # Loop over data
    for (i, dat) in enumerate(col)
      # Convert data or use default error data
      try elem = parse(type, strip(dat))
        revcol[i] = elem
      catch
        # Use different default values for different data types, if err is not defined
        if err == "" && type == Float64
          revcol[i] = NaN
        elseif err == "" && type == DateTime
          revcol[i] = DateTime(0)
        else
          revcol[i] = err
        end
        count += 1
      end
    end
    # Check whether conversion was successful
    # or the next data type has to be tested
    if count < length(col)  try col = convert(Vector{type}, revcol)
      break
    catch
      continue
    end
  end  end

  return col
end #function convert_exceptions
