__precompile__()


module Gems
using DataFrames
using CSV

gemsjl = Gems
export gemsjl


"""
    set_map(df, flag_type)

Limit GEM mapping table to a specific mapping relationship.
"""
function set_map_type(df,
        flag_type:: String)
        return df[df[Symbol(flag_type)] .== 1, :]
end


"""
    map_direction(df, map_to)

Rename GEM mapping table columns with either a backward or forward mappings schema.
"""
function map_direction(df,
                map_to:: String)
        if map_to == "icd10"
                df = rename(df, Dict(:source => :icd9, :target => :icd10))
        elseif map_to == "icd9"
                df = rename(df, Dict(:source => :icd10, :target => :icd9))
        end
        return df
end
 

function load_lookups(map_to:: String)
     if map_to == "icd10"
        file_path = join([@__DIR__, "gems9_10.csv"], "/")
        df = CSV.File(file_path) |> DataFrame
    elseif map_to == "icd9"
        file_path = join([@__DIR__, "gems10_9.csv"], "/")
        df = CSV.File(file_path) |> DataFrame
        end
        return df
end

                
function gems(icd_code:: String;
        map_to:: String = "icd10",
        flag_type:: String = "",
        show_flags:: Bool = false)
        
    df = load_lookups(map_to)
      
    if length(flag_type) > 0
        df = set_map_type(df,flag_type)
    end
        
    if show_flags
        df = df[df[:source] .== icd_code, names(df)]
        df = map_direction(df, map_to)
    else
        df = df[df[:source] .== icd_code,
            [:source,:target,:descriptions ]] 
        df = map_direction(df, map_to)              
    end
    return df
end
end
