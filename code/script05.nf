#! /usr/bin/env nextflow

/*************************************
 Let's see if a process can have multi-line commands
 *************************************/

process myprocess1 {

  script:
  """
  #! /usr/bin/env bash
  echo "Process1 says hello"
  echo "Still in Process1"    
  """
}

println "Notice how above has no output"

process myprocess2 {
  output:
  stdout result2

  script:
  """
  #! /usr/bin/env bash
  echo "Process2 says hello"
  echo "Still in Process 2"   # Okay multi-line and bash-style comments work in processes
  """
}

println result2.view { it.trim() }  /* I guess this convention has to be memorized... I don't see a nice explanation yet */

/*************************************
 Processes can have python, R, other scripting languages
 *************************************/
process myprocess3 {
  output:
  stdout result3

  script:
  """
  #! /usr/bin/env Rscript
  cat("Rscript says Hello world\n")
  x=c(1:5)
  cat(x)
  """
}

println result3.view { it.trim() }