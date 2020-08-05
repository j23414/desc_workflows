#! /usr/bin/env nextflow

// Give default values
params.input = 'default.txt'
params.outdir = 'results'

// Use the parameters in a print statement
println "params.input = $params.input"
println "params.output = $params.outdir"