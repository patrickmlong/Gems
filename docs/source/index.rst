.. gems documentation master file, created by
   sphinx-quickstart on Sun Aug 30 07:53:15 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Gems documentation
================================

A small julia utility for basic ICD-9-CM and ICD-10-CM GEMs cross-walking.

About GEMs
^^^^^^^^^^
General Equivalency Maps (GEMs) support the interoperability between ICD-9 and ICD-10 codebases and are maintained by the Centers for Medicare and Medicaid Services (CMS). Multiple mapping types may occur including one-to-one and one-to-many. GEMs provide various flags to further characterize these mapping relationships.

Map between ICD-9-CM and ICD-10-CM
 - Forward mapping: ICD-9 to ICD-10 codes
 - Backward mapping: ICD-10 to ICD-9 codes

Filter by map type
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
 - Choice list: Used with the combination flag to direct alternatives when mappings are one-to-many
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

    gems("59972", map_to = "icd10", flag_type = "approximate")

    │ Row │ source │ target │ descriptions                           │
    │     │ String │ String │ String                                 │
    ├─────┼────────┼────────┼────────────────────────────────────────┤
    │ 1   │ 59972  │ R311   │ Benign essential microscopic hematuria │
    │ 2   │ 59972  │ R3121  │ Asymptomatic microscopic hematuria     │
    │ 3   │ 59972  │ R3129  │ Other microscopic hematuria            │


Backward mapping::

    using Gems

    gems("R6521", map_to = "icd9", show_flags = true)

    │ Row │ source │ target │ approximate │ no map │ combination │ scenario │ choice list │ descriptions  │
    │     │ String │ String │ Int64       │ Int64  │ Int64       │ Int64    │ Int64       │ String        │
    ├─────┼────────┼────────┼─────────────┼────────┼─────────────┼──────────┼─────────────┼───────────────┤
    │ 1   │ R6521  │ 78552  │ 1           │ 0      │ 1           │ 1        │ 1           │ Septic shock  │
    │ 2   │ R6521  │ 99592  │ 1           │ 0      │ 1           │ 1        │ 2           │ Severe sepsis │



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
