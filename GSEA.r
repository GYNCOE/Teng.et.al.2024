library(xCell)
library(magrittr)
library(stringr)

# This script takes an expression matrix and gene sets and performs ssGSEA

#   1. Expression file (columns are samples, rows are genes/accessions)
#   2. Output directory
#   3. Name of output file ('.csv' WILL BE APPENDED)
#   3. Gene set csv (name of the csv must end with '_something.csv', with 'something' being the name of the gene set) 
#   4. Second gene set csv (naming convention stands)
#   5. ... (continued gene sets)


## Create gene sets for provided gene lists
args = commandArgs(trailingOnly=TRUE)

# uncomment for debugging
# args = c('/home/schaafj/Projects/admixture/data/admixture_final_imputed_t.csv',
#         '/home/schaafj/Projects/admixture/machine_learning/data',
#         'gsea',
#         '/home/schaafj/Projects/admixture/machine_learning/data/Tumor/reduced_lowest_mse_Tumor.csv', 
#         '/home/schaafj/Projects/admixture/machine_learning/data/Stroma/reduced_lowest_mse_Stroma.csv', 
#         '/home/schaafj/Projects/admixture/machine_learning/data/Lymphocyte/reduced_lowest_mse_Lymphocyte.csv')

# parse arguments
expression_file = args[1]
output_dir = args[2]
output_file_name = args[3]
gene_set_files = args[4:length(args)] # the rest of the files should be gene sets

gene_sets = as.vector(c()) # create empty vector to hold gene sets created in loop

# loop through file paths and get gene sets
for (file_path in gene_set_files) {
    # split the file name, getting the last underscore
    split = str_split(file_path, '_')
    
    # get the gene set name
    gene_set_name = sapply(split, tail, 1)
    gene_set_name = substr(gene_set_name, 1, nchar(gene_set_name)-4) # remove the last 4 characters
    
    # read in the file
    file_contents = read.csv(file = file_path)

    # make a gene set and add it to the vector of gene sets
    gene_set = GSEABase::GeneSet(geneIds=as.character(unique(file_contents$X0)), setName=gene_set_name)
    gene_sets = append(gene_sets, gene_set)

    print(paste0('Gene set `',gene_set_name, '` - ',length(unique(file_contents$X0)), ' genes ...'))
}


# make gene set collection
gsc = GSEABase::GeneSetCollection(gene_sets)

print(paste0('Reading in expression file: `', expression_file, '` ...'))

# expression file
exp = read.csv(file = expression_file, check.names = F) %>% as.data.frame() %>% t()
colnames(exp) = exp[1,]
exp = exp[-1,]
row_names_temp = rownames(exp)
exp = apply(exp,2,as.numeric)
rownames(exp) = row_names_temp
exp = t(exp)

gsea_output = GSVA::gsva(exp, gsc,
                        method = "ssgsea",
                        ssgsea.norm = FALSE)

write.csv(gsea_output, paste0(output_dir, '/', output_file_name, '.csv'))