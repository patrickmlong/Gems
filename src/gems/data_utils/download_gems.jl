using DataFrames
using CSV

SAVE_PATH = "./data/raw_data/gems/"                                         
URL_CMS = "https://www.cms.gov/Medicare/Coding/"

URL_GEMS = string(URL_CMS, "ICD10/Downloads/2018-ICD-10-CM-General-Equivalence-Mappings.zip")
URL_ICD10  = string(URL_CMS, "ICD10/Downloads/2018-ICD-10-Code-Descriptions.zip")
URL_ICD9 =  string(URL_CMS, "ICD9ProviderDiagnosticCodes/Downloads/ICD-9-CM-v32-master-descriptions.zip")

cd("../../../data/")

gems_files = download(URL_GEMS,"gems.zip")
icd10_files = download(URL_ICD10,"icd10.zip")
icd9_files = download(URL_ICD9, "icd9.zip")


run(`unzip gems.zip`);
run(`unzip icd10.zip`);
run(`unzip icd9.zip`);


function read_tables()

    df_icd9 = CSV.read_csv("2018_I9gem.csv")
    df_icd10 = CSV.read_csv("2018_I10gem.csv")
    df_icd9_desc = CSV.read_csv("CMS32_DESC_LONG_DX.csv")
    df_icd10_desc = CSV.read_csv("icd10cm_codes_2018.csv")

    return df_icd9, df_icd9_desc, df_icd10, df_icd10_desc
end


function join_icd_desc(df_icd, df_desc, key)

    df = join(df_icd, df_desc,
                 on = :target => :key)
    return df
end

function save_icd_desc_tables(df, df_name)

    df.to_csv(df_name, index = False)
end


function add_icd_desc(df_icd9, df_icd9_desc, df_icd10, df_icd10_desc):

    df9_lookup = join_icd_desc(df_icd9,
                        df_icd10_desc,
                        key = "icd10")

    df10_lookup = join_icd_desc(df_icd10,
                         df_icd9_desc,
                         key = "icd9")

    save_icd_desc_tables(df9_lookup, "icd9_gems_lookup.csv")
    save_icd_desc_tables(df10_lookup, "icd10_gems_lookup.csv")
end
