__precompile__()


module Gems
using DataFrames
using CSV

gems = Gems
export gems


function load_gems9_10()
        file_path = join([@__DIR__, "gems9_10.csv"], "/")
        df = CSV.File(file_path) |> DataFrame
        df = rename(df, Dict(:source => :icd9, :target => :icd10))
    return df
end
  

function load_gems10_9()
        file_path = join([@__DIR__, "gems10_9.csv"], "/")
        df = CSV.File(file_path) |> DataFrame
        df = rename(df, Dict(:source => :icd10, :target => :icd9))
    return df
end


"""
    filter_flags(df, flag_type)

Limit GEM mapping table to a specific mapping relationship.
"""
function filter_flags(df::DataFrames.DataFrame,
        flag_type:: String;)
    if length(flag_type) > 0
        return df[df[Symbol(flag_type)] .== 1, :]
    end
end

    
function include_flags(df::DataFrames.DataFrame,
                icd_code:: String,
                show_flags:: Bool;) 
        if show_flags
            df = df[df[:icd_code] .== icd_code, names(df)]
        else
        df = df[df[:icd_code] .== icd_code,
            [:source,:target,:descriptions ]]             
    end
end

    
function forward_mapping(icd_code:: String; 
                flag_type:: String = "",
                show_flags:: Bool = false)
        df = load_gems9_10()
        df = filter_flags(df, flag_type)
        df = include_flags(df, icd_code, show_flags)       
    return df
end

    
function backward_mapping(icd_code:: String;
                flag_type:: String = "",
                show_flags:: Bool = false)    
        df = load_gems10_9()
        df = filter_flags(df, flag_type)
        df = include_flags(df, icd_code, show_flags)    
    return df
end

#function gems(icd_code:: String;
#        map_to:: String = "icd10",
#        flag_type:: String = "",
#        show_flags:: Bool = false)
#        
#    df = load_lookups(map_to)
#      
#    if length(flag_type) > 0
#        df = set_map_type(df,flag_type)
#    end
#        
#    if show_flags
#        df = df[df[:source] .== icd_code, names(df)]
#        df = map_direction(df, map_to)
#    else
#        df = df[df[:source] .== icd_code,
#            [:source,:target,:descriptions ]] 
#        df = map_direction(df, map_to)              
#    end
#    return df
#end

    
end
