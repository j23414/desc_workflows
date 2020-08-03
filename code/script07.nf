#! /usr/bin/env nextflow

/********* Params **********/
params.outdir = "output_dir"

/********* Modules *********/
nextflow.enable.dsl=2
include { demo_fasta } from './mod_process07.nf'
// include { makeblastdb } from './mod_process07.nf'

/********* Main *********/
workflow {
//  data = channel.fromPath('./*.nf')
  demo_fasta()
//  makeblastdb()
}
println "output in ${params.outdir}"