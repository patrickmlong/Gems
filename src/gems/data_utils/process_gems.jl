using DataFrames
using CSV

function load_tables()

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



function make_desc_cols(df_in, code::String)

    df = copy(df_in)

    df[:code] = map(x -> split(string(x), " ")[1], df[:x1])
    df[:descriptions] = map(x -> lstrip(join(split(string(x), " ")[2:end], " ")), df[:x1])

    df =  delete!(df, :x1)

    return df
end


function join_icd_descriptions(df_gems, df_desc)

    df = join(df_gems, df_desc,
        on = :target => :code,
        kind = :inner)
    return df
end



gems9, gems10, desc9, desc10 = load_tables();

gems9 = format_icd_table(gems9);
gems10 = format_icd_table(gems10);

desc9 =  make_desc_cols(desc9, "icd9");
desc10 =  make_desc_cols(desc10, "icd10");

gems9_10 = join_icd_descriptions(gems9,desc10);
gems10_9 = join_icd_descriptions(gems10,desc9);


CSV.write("gems9_10.csv", gems9_10)
CSV.write("gems10_9.csv", gems10_9)
