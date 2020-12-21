using DataFrames
using CSV


# TODO REFACTOR
function load_tables()

    cols = ["source", "target", "flags"]
    
    df_icd9 = CSV.File("2018_I9gem.txt", delim = ' ',
        header = false, type=String, ignorerepeated=true) |> DataFrame
    rename!(df_icd9, cols)
    df_icd10 = CSV.File("2018_I10gem.txt", delim = ' ', header = false, type=String, ignorerepeated=true) |> DataFrame
    rename!(df_icd10, cols)
    
    df_icd9_desc = CSV.File("CMS32_DESC_LONG_DX.txt", delim = '\t', header = false, type=String) |> DataFrame                       
    df_icd10_desc = CSV.File("icd10cm_codes_2018.txt", delim = '\t', header = false, type=String) |> DataFrame
    
    df_icd9_pcs = CSV.File("gem_i9pcs.txt", delim = ' ', header = false, type=String, ignorerepeated=true) |> DataFrame
    rename!(df_icd9_pcs, cols)  
    df_icd10_pcs = CSV.File("gem_pcsi9.txt", delim = ' ', header = false, type=String, ignorerepeated=true) |> DataFrame
    rename!(df_icd10_pcs, cols)
    
    df_icd10_pcs_desc = CSV.File("icd10pcs_order_2014.txt", delim = '\t', header = false, type=String) |> DataFrame 

    return df_icd9, df_icd10, df_icd9_desc, df_icd10_desc, df_icd9_pcs, df_icd10_pcs, df_icd10_pcs_desc    
end


function make_flag_cols(df_in)
    
    df = copy(df_in)
    
    df[:flags] = map(x -> lpad(split(string(x), " ")[1], 5, "0"), df[:flags])
    
    flag_types = [ "approximate", "no map", "combination", "scenario", "choice list"]

    for (index, flag) in enumerate(flag_types)
        df[Symbol(flag_types[index])] = map(x -> string(x[index]), df[:flags])
    end

    select!(df, Not(:flags)) 

    return df
end


function make_desc_cols(df_in, code::String)
    
    df = copy(df_in)
    
    df[:code] = map(x -> split(string(x), " ")[1], df[:Column1])
    df[:descriptions] = map(x -> lstrip(join(split(string(x), " ")[2:end], " ")), df[:Column1])
    
    select!(df, Not(:Column1))
    
    return df
end


function join_icd_descriptions(df_gems, df_desc)

    df = join(df_gems, df_desc,
        on = :target => :code,
        kind = :inner)
    return df
end

function join_icd_descriptions(df_gems, df_desc_target, df_source_description)

    df = join(df_gems, df_desc_target,
        on = :target => :code,
        kind = :inner)
    rename!(df, Dict(:descriptions => :target_descriptions))

    df = join(df, df_source_description,
        on = :source => :code,
        kind = :left)
    rename!(df, Dict(:descriptions => :source_descriptions))
    
    return df
end


cd("../data/")

gems9, gems10, desc9, desc10, icd9_pcs, icd10_pcs, icd10_pcs_desc = load_tables();

gems9 = make_flag_cols(gems9);
gems10 = make_flag_cols(gems10);
desc9 =  make_desc_cols(desc9, "icd9");
desc10 =  make_desc_cols(desc10, "icd10");
gems9_10 = join_icd_descriptions(gems9,desc10, desc9);
gems10_9 = join_icd_descriptions(gems10,desc9, desc10);

icd9_pcs = make_flag_cols(icd9_pcs);
icd10_pcs = make_flag_cols(icd10_pcs);
desc10pcs = make_desc_cols(icd10_pcs_desc, "icd10_pcs");  

CSV.write("processed/gems9_10.csv", gems9_10)
CSV.write("processed/gems10_9.csv", gems10_9)
CSV.write("processed/gems_pcs_desc.csv", desc10pcs)
CSV.write("processed/gems_icd9_pcs.csv", icd9_pcs)
CSV.write("processed/gems_icd10_pcs.csv", icd10_pcs)

