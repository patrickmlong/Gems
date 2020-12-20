.. gems documentation master file, created by
   sphinx-quickstart on Sun Aug 30 07:53:15 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Gems.jl documentation
================================

A small julia utility for basic ICD-9-CM and ICD-10-CM GEMs cross-walking.

About GEMs
^^^^^^^^^^
General Equivalency Maps (GEMs) support the interoperability between ICD-9 and ICD-10 codebases and are maintained by the Centers for Medicare and Medicaid Services (CMS). Multiple mapping types may occur including one-to-one and one-to-many. GEMs provide various flags to further characterize these mapping relationships.

Map between ICD-9-CM and ICD-10-CM
 - Forward mapping: ICD-9 to ICD-10 codes
 - Backward mapping: ICD-10 to ICD-9 codes

Relationships
 - Approximate:
     - Imperfect correspondence: approximate = 1
     - Perfect correspondence: approximate = 0
 - No Map:
     - No acceptable GEMs mapping exists: no map = 1
     - One or greater mappings exist: no map = 0
 - Combination:
     - Mapping is one-to-many: combination = 1
     - One-to-one: combination = 0
 - Scenario:
     - Multiple target codes are required to complete mapping: scenario = 1
     - Multiple target codes are not required: scenario = 0
 - Choice list: Used with the combination flag to direct one-to-many mappings
     - A single combination mapping exists: choice list = 1
     - More than one combination mapping exists: choice list = 2
     - No combination mapping exists: choice list = 0

Examples
^^^^^^^^

Installation::

    using Pkg

    pkg"add https://github.com/pkmklong/Gems.jl"


Forward mapping::

    using Gems

    Gems.forward_mapping("59972", flag_type = "approximate")

    │ Row │ icd9   │ icd10  │ target_descriptions                    │ source_descriptions   │
    │     │ String │ String │ String                                 │ String                │
    ├─────┼────────┼────────┼────────────────────────────────────────┼───────────────────────┤
    │ 1   │ 59972  │ R311   │ Benign essential microscopic hematuria │ Microscopic hematuria │
    │ 2   │ 59972  │ R3121  │ Asymptomatic microscopic hematuria     │ Microscopic hematuria │
    │ 3   │ 59972  │ R3129  │ Other microscopic hematuria            │ Microscopic hematuria │


Backward mapping::

    using Gems

    Gems.backward_mapping("R6521", hide_flags = false)
    
    │ Row │ icd10  │ icd9   │ approximate │ no map │ combination │ scenario │ choice list │ target_descriptions │ source_descriptions             │
    │     │ String │ String │ Int64       │ Int64  │ Int64       │ Int64    │ Int64       │ String              │ String                          │
    ├─────┼────────┼────────┼─────────────┼────────┼─────────────┼──────────┼─────────────┼─────────────────────┼─────────────────────────────────┤
    │ 1   │ R6521  │ 78552  │ 1           │ 0      │ 1           │ 1        │ 1           │ Septic shock        │ Severe sepsis with septic shock │
    │ 2   │ R6521  │ 99592  │ 1           │ 0      │ 1           │ 1        │ 2           │ Severe sepsis       │ Severe sepsis with septic shock │



Retrieve GEMs tables::

   using Gems

   first(Gems.load_gems9_10(), 5)

   5×8 DataFrame. Omitted printing of 1 columns
   │ Row │ icd9   │ icd10  │ approximate │ no map │ combination │ scenario │ choice list │
   │     │ String │ String │ Int64       │ Int64  │ Int64       │ Int64    │ Int64       │
   ├─────┼────────┼────────┼─────────────┼────────┼─────────────┼──────────┼─────────────┤
   │ 1   │ 0010   │ A000   │ 0           │ 0      │ 0           │ 0        │ 0           │
   │ 2   │ 0011   │ A001   │ 0           │ 0      │ 0           │ 0        │ 0           │
   │ 3   │ 0019   │ A009   │ 0           │ 0      │ 0           │ 0        │ 0           │
   │ 4   │ 0020   │ A0100  │ 1           │ 0      │ 0           │ 0        │ 0           │
   │ 5   │ 0021   │ A011   │ 0           │ 0      │ 0           │ 0        │ 0           │


   first(Gems.load_gems10_9(), 5)
   
   │ Row │ icd9   │ icd10  │ approximate │ no map │ combination │ scenario │ choice list │ target_descriptions                                │ source_descriptions                   │
   │     │ String │ String │ Int64       │ Int64  │ Int64       │ Int64    │ Int64       │ String                                             │ String                                │
   ├─────┼────────┼────────┼─────────────┼────────┼─────────────┼──────────┼─────────────┼────────────────────────────────────────────────────┼───────────────────────────────────────┤
   │ 1   │ 0010   │ A000   │ 0           │ 0      │ 0           │ 0        │ 0           │ Cholera due to Vibrio cholerae 01, biovar cholerae │ Cholera due to vibrio cholerae        │
   │ 2   │ 0011   │ A001   │ 0           │ 0      │ 0           │ 0        │ 0           │ Cholera due to Vibrio cholerae 01, biovar eltor    │ Cholera due to vibrio cholerae el tor │
   │ 3   │ 0019   │ A009   │ 0           │ 0      │ 0           │ 0        │ 0           │ Cholera, unspecified                               │ Cholera, unspecified                  │
   │ 4   │ 0020   │ A0100  │ 1           │ 0      │ 0           │ 0        │ 0           │ Typhoid fever, unspecified                         │ Typhoid fever                         │
   │ 5   │ 0021   │ A011   │ 0           │ 0      │ 0           │ 0        │ 0           │ Paratyphoid fever A                                │ Paratyphoid fever A                   │


.. note::
    The author of this library is not affiliated, associated, authorized, endorsed by, or in any way officially connected with Centers for Medicare and Medicaid Services (CMS), or any of its subsidiaries or its affiliates.

.. toctree::
   :maxdepth: 3
   :caption: Contents:

   license


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
