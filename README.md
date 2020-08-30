[![Documentation Status](https://readthedocs.org/projects/docs/badge/?version=latest)](https://gemsjl.readthedocs.io/en/latest/) Check out the [Gems.jl documentation on ReadTheDocs](https://gemsjl.readthedocs.io/en/latest/).

# Gems.jl
Julia package for ICD GEMs mapping


## Toolkit
<b>Convert between ICD-9-CM and ICD-10-CM using General Equivalency Maps (GEMs)</b>
- Forward and backward ICD mapping
- Filter by GEMs flag type

<b>Lexical ICD-9-CM and ICD-10-CM querying</b>
- Search ICD-9 or ICD-10 codes by clinical keyword 

## About GEMs
<b>GEMs</b><br>
General Equivalency Maps (GEMs) support the interoperability between ICD-9 and ICD-10 codebases and are maintained by the Centers for Medicare and Medicaid Services (CMS). Multiple mapping types may occur including one-to-one and one-to-many. GEMs provide various flags to further characterize these mapping relationships.<br>

<b>Forward mapping</b><br> Mapping from ICD-9 to ICD-10 codes.<br>

<b>Backward mapping</b><br> Mapping from ICD-10 to ICD-9 codes.<br>

<b>Flag types</b><br>
* <i>__Approximate__</i>: Mappings with imperfect correspondence (approximate = 1) or a perfect correspondence (approximate = 0).<br>
* <i>__No__ __Map__</i>: No acceptable GEMs mapping exisits (no map = 1) or one or greater mappings exist (no map = 0).<br>
* <i>__Combination__</i>: Mapping is one-to-many (combination = 1) or one-to-one (combination = 0). <br>
* <i>__Scenario__</i>: Multiple target codes are required to complete mapping (scenario = 1) or multiple target codes are not required (scenario = 0)<br>
* <i>__Choice__ __list__</i>: Used on conjuction with the combination flag to direct alternatives when mappings are one-to-many. If a single combination mapping exists: choice list = 1, if more than one combination mapping exists: choice list = 2, if no combination mapping exists: choice list = 0 <br>

# Example

<i>Installation</i>

```julia
using Pkg

pkg"add https://github.com/pkmklong/Gems.jl"
```
<i>Forward mapping</i>
```julia
using Gems

gems("59972", map_to = "icd10", flag_type = "approximate")

│ Row │ source │ target │ descriptions                           │
│     │ String │ String │ String                                 │
├─────┼────────┼────────┼────────────────────────────────────────┤
│ 1   │ 59972  │ R311   │ Benign essential microscopic hematuria │
│ 2   │ 59972  │ R3121  │ Asymptomatic microscopic hematuria     │
│ 3   │ 59972  │ R3129  │ Other microscopic hematuria            │
```
<i>Backward mapping</i>
```julia
using Gems

gems("R6521", map_to = "icd9", show_flags = true)

│ Row │ source │ target │ approximate │ no map │ combination │ scenario │ choice list │ descriptions  │
│     │ String │ String │ Int64       │ Int64  │ Int64       │ Int64    │ Int64       │ String        │
├─────┼────────┼────────┼─────────────┼────────┼─────────────┼──────────┼─────────────┼───────────────┤
│ 1   │ R6521  │ 78552  │ 1           │ 0      │ 1           │ 1        │ 1           │ Septic shock  │
│ 2   │ R6521  │ 99592  │ 1           │ 0      │ 1           │ 1        │ 2           │ Severe sepsis │
```

## Notice of Non-Affiliation and Disclaimer 
The author of this library is not affiliated, associated, authorized, endorsed by, or in any way officially connected with Centers for Medicare and Medicaid Services (CMS), or any of its subsidiaries or its affiliates.



