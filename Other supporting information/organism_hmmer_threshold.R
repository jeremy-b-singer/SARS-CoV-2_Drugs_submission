# organism_hmmer_threshold.R
# computes kmeans based threshold for selecting targets.

library(RPostgres)

db_name='chembl_25'
user_name = 'postgres'
host='192.168.1.180'
port=5432

conn = dbConnect(drv=RPostgres::Postgres(),
                 dbname=db_name,
                 user=user_name,
                 host=host,
                 port=port)

get_kmeans_threshold<-function(conn, tax_id, clusters=2){
  q_tax_org = paste0('SELECT distinct organism ',
                     'FROM hmmer_statistics ',
                     'where tax_id=',
                     tax_id)
  q_org_score = paste0(
    'select distinct score, orf, target
     from hmmer_statistics h
              join target_dictionary td 
               on h.target = td.chembl_id 
               left outer join drug_mechanism dm 
               ON td.tid = dm.tid 
               left outer join molecule_dictionary md 
              ON dm.molregno = md.molregno 
          WHERE h.tax_id ='
    , tax_id
  )
  
  org=dbGetQuery(conn,q_tax_org)
  org_score=dbGetQuery(conn, q_org_score)
  organism=org$organism[1]
  attach(org_score)
  kmo=kmeans(score,clusters)

  thresh = min(score[ # lowest score
    kmo$cluster==which(kmo$centers==max(kmo$centers)) # in highest cluster
  ])  
  plot(score,col=kmo$cluster, main=paste('kmeans for ',organism, ', threshold=',thresh), pch=kmo$cluster, cex=1.5) 
  detach()
  return(thresh)
}

#dbDisconnect(conn)


