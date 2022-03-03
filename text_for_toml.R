library(tidyverse)
library(dplyr)

### here we will make the bedtool and the TOML files ready ###
merged_genes <- read.delim2(file = "merged_genes.txt", header = FALSE, sep = "", dec = ",")

# write 1 gene 2 times because we need the sense and the antisense
merged_genes <- merged_genes %>% slice(rep(1:n(), each = 2)) 

#define even and odd rows
odd_indexes<-seq(1,nrow(merged_genes),2)
even_indexes<-seq(2,nrow(merged_genes),2)

#make a new column strand to indicate sense or antisense
merged_genes<-merged_genes %>% add_column(strand=NA)

#indicate sense and antisense
merged_genes$strand <- rep(c("+", "-"), length.out=nrow(merged_genes))

#voeg aanhalingstekens voor chr en na sense of antisense toe
merged_genes$V1 <- sub("^", "\"", merged_genes$V1)
merged_genes$strand <- sub("$", "\"", merged_genes$strand )

#voeg alle kolommen samen
merged_genes<-transform(merged_genes, newcol=paste(V1, V2, V3, strand,sep=","))

#selecteer enkel de samengestelde kolom
merged_genes<-merged_genes %>% select(newcol)

#collapse rows and separate them by ,
a<-paste(merged_genes$newcol,collapse = ",")

#write to csv
write.csv(x=a, file="coordinates_for_toml",quote = FALSE)





