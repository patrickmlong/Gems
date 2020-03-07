using DataFrames


function read_tables()

    cols = ["source", "target", "flags"]
    
    df_icd9 = rename(CSV.readtable("2018_I9gem.txt", separator = ' ',  header = false), cols)
    df_icd10 = rename(CSV.readtable("2018_I10gem.txt", separator = ' ', header = false), cols)
    df_icd9_desc = CSV.readtable("CMS32_DESC_LONG_DX.txt", separator = '\t', header = false)
    df_icd10_desc = CSV.readtable("icd10cm_codes_2018.txt", separator = '\t', header = false)
    
    return df_icd9, df_icd10, df_icd9_desc, df_icd10_desc
    
end


function split_flags(df_in)
    
    df = copy(df_in)
    
    df[:flags] = map(x -> join(lpad(split(string(x), " ")[1], 5, "0"), ","), df[:flags]);

    return df

end


function make_flag_cols(df_in)
    
    df = copy(df_in)
    
    for (index, label) in enumerate(flags)
        df[Symbol(flag_types[index])] = label
    end
    
    df =  delete!(df, :flags)
    
    return df
    
end



function format_icd_table(df_in)
    
    df = copy(df_in)
    
    df = split_flags(df)
    df = make_flag_cols(df)

    return df

end
