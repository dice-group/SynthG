## Benchmark queries used in Experiments of SynthG
  SynthG: mimicking RDF Graphs Using Tensor Factorization
  It contains three files (other than this file)
  
  (1)Benchmark_Queries gives the benchmark queries in three columns: 
   query number, query (template), query instance
   query instance column show one instance query if the query contains template  
   variable (e.g. %%var0%%).
   ===============
   (2)swfc_qps_1hr.csv is the file containing results of SWDF dataset
   while (3) dbp16_qps_1hr contains the results of 24 queries of DBpedia
  
   Result files from IGUANA have the following structure:
   suiteid: is experment no for IGUANA
   gname: graph name	
   Ts	: triplestore
   qry  : query id  starting from 0 with leading 'sparql', the number is the query no in list of queries minus 1
   qps	: number queries per secons
   qsucc: number of succedded queries
   qtotalTime: total time spent in running the query
   qtimeouts: number of queries instances that timedout
   qfailed: number of queries instances that failed
   dstype: type of graph (org: original, rec: reconstructed, rot: synthetic)
   
   