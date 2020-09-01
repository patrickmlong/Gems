__precompile__()


module Gems
using DataFrames
using CSV
#using DataFramesMeta


export gems


function set_map_type(df,
        flag_type:: String)
        return df[df[Symbol(flag_type)] .!= "0", :]
end


function map_direction(df,
                mapping:: String)
        if mapping == "icd10"
                rename!(df, Dict(:source => :icd9, :target => :icd10))
        elseif mapping == "icd9"
                rename!(df, Dict(:source => :icd10, :target => :icd9))
        return df
end
                
                
function gems(icd_code:: String;
        map_to:: String = "icd10",
        flag_type:: String = "",
        show_flags:: Bool = false)

    if map_to == "icd10"
        file_path = join([@__DIR__, "gems9_10.csv"], "/")
        df = CSV.File(file_path) |> DataFrame
    elseif map_to == "icd9"
        file_path = join([@__DIR__, "gems10_9.csv"], "/")
        df = CSV.File(file_path) |> DataFrame
    end
     
    if length(flag_type) > 0
        df = set_map_type(df,flag_type)
    end
        
    if show_flags
        df = df[df[:source] .== icd_code, names(df)]
        df = map_direction(df, map_to)
#         my_query = @linq df |>
#             where(:source .== icd_code) |>
#             select(names(df))
    else
        df = df[df[:source] .== icd_code,
            [:source,:target,:descriptions ]] 
        df = map_direction(df, map_to)
#         my_query = @linq df |>
#                 where(:source .== icd_code) |>
#                 select(:source,
#                     :target,
#                     :descriptions)                
    end
    return df
end
end
