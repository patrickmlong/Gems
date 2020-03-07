SAVE_PATH = "./data/raw_data/gems/"                                         
URL_CMS = "https://www.cms.gov/Medicare/Coding/"

URL_GEMS = string(URL_CMS, "ICD10/Downloads/2018-ICD-10-CM-General-Equivalence-Mappings.zip")
URL_ICD10  = string(URL_CMS, "ICD10/Downloads/2018-ICD-10-Code-Descriptions.zip")
URL_ICD9 =  string(URL_CMS, "ICD9ProviderDiagnosticCodes/Downloads/ICD-9-CM-v32-master-descriptions.zip")

set_path = "../../../data/"

gems_files = download(URL_GEMS, string(set_path,"gems.zip"))
icd10_files = download(URL_ICD10, string(set_path,"icd10.zip"))
icd9_files = download(URL_ICD9, string(set_path,"icd9.zip"))


run(`unzip ../../../data/gems.zip`);
run(`unzip ../../../data/icd10.zip`);
run(`unzip ../../../data/icd9.zip`);
