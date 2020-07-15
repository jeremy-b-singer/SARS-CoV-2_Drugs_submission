\copy (select h.score,td.tax_id as original_tax_id,td.organism as original_organism,h.target,h.orf,md.pref_name,md.chembl_id,dm.mechanism_of_action,md.max_phase,md.first_approval FROM hmmer_statistics h join target_dictionary td on h.target=td.chembl_id left outer join drug_mechanism dm ON td.tid = dm.tid left outer join molecule_dictionary md ON dm.molregno = md.molregno WHERE h.score >=4350 and h.tax_id = 2697049 order by orf) to 'C:/Users/Jeremy-satellite/Documents/SARS-CoV-2_Drugs_submission/Supporting information/target_SARS-CoV-2_drugs.txt' CSV HEADER delimiter '	'
