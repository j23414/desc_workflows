#! /usr/bin/env nextflow

/***********************************
 Create an example demo fasta file
 ***********************************/

process demo_fasta {
  publishDir "${params.outdir}", mode: 'copy'
  
  output: path 'demo.fasta'
  
  script:
  """
  cat << '_EOF' > demo.fasta
  >Sequence_A
  AAAAAAAAAAAAAAAAAAAAAAA
  >Sequence_C
  CCCCCCCCCCCCCCCCCCCCCCC
  _EOF
  """
}

/***********************************
 Create a blastn database
 ***********************************/

process makeblastdb {
  publishDir "${params.outdir}", mode: 'copy'

  input: path x_fasta
  output: file "${x_fasta}*"
  
  script:
  """
  makeblastdb -in ${x_fasta} -dbtype nucl -out ${x_fasta}
  """
}

/***********************************
 Blastn a query against the database (do this in parallel?)
 ***********************************/
// /** in progress **/
// process blastn {
//   publishDir "${params.outdir}", mode: 'copy'
//   input: path query_fasta
//   output: file "blast_output.txt"
//   script:
//   """
//   blastn -db ${somedb} -query ${query_fasta} -outfmt 6 -out blast_output.txt
//   """
// }