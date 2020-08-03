#! /usr/bin/env nextflow

/***********************************
 Create an example demo fasta file
 ***********************************/

process demo_fasta {
  publishDir "${params.outdir}", mode: 'copy'
  
  output: file 'demo.fasta'
  
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

// /* In progress... */
// process makeblastdb {
// 
//   publishDir "${params.outdir}", mode: 'copy'
// 
//   input: val fasta from $params.fasta
//   output: file '${params.fasta}*'
//   
//   script:
//   """
//   makeblastdb -in ${fasta} -dbtype nucl
//   """
// }