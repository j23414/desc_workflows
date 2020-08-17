#! /usr/bin/env nextflow


nextflow.enable.dsl=2

println("==Implicit Variables: https://www.nextflow.io/docs/latest/script.html#implicit-variables")
println("  baseDir:\t$baseDir")
println("  launchDir:\t$launchDir")
println("  moduleDir:\t$moduleDir")
println("  nextflow:\t$nextflow")
println("  params:\t$params")
println("  projectDir:\t$projectDir")
println("  workDir:\t$workDir")
println("  workflow:\t$workflow")

