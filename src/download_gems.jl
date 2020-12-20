using DataFrames
using CSV

SAVE_PATH = "./data/raw_data/gems/"                                         
URL_CMS = "https://www.cms.gov/Medicare/Coding/"

URL_GEMS = string(URL_CMS, "ICD10/Downloads/2018-ICD-10-CM-General-Equivalence-Mappings.zip")
URL_ICD10  = string(URL_CMS, "ICD10/Downloads/2018-ICD-10-Code-Descriptions.zip")
URL_ICD9 =  string(URL_CMS, "ICD9ProviderDiagnosticCodes/Downloads/ICD-9-CM-v32-master-descriptions.zip")

URL_GEMS_PCS = string(URL_CMS, "ICD10/Downloads/ProcedureGEMs-2014.zip")

cd("../data/")

gems_files = download(URL_GEMS,"gems.zip")
icd10_files = download(URL_ICD10,"icd10.zip")
icd9_files = download(URL_ICD9, "icd9.zip")
gems_pcs = download(URL_GEMS_PCS, "gems_pcs.zip")

run(`unzip gems.zip`);
run(`unzip icd10.zip`);
run(`unzip icd9.zip`);
run(`unzip gems_pcs.zip`);
