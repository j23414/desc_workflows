#! /usr/bin/env nextflow

/********* Params **********/
params.outdir = "output_dir"

/********* Modules *********/
nextflow.enable.dsl=2
include { demo_fasta } from './mod_process07.nf'
include { makeblastdb } from './mod_process07.nf'

/********* Main *********/

/* Version 1: pass output to next process */
workflow {
//  data = channel.fromPath('./${params.outdir}/demo.fasta')
  demo_fasta()
  makeblastdb(demo_fasta.out)
}

// /* Version 2: Pipe output to next process */
// workflow {
// //  data = channel.fromPath('./${params.outdir}/demo.fasta')
//   demo_fasta | makeblastdb
// }


