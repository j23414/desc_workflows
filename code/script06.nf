#! /usr/bin/env nextflow

/**********************************
 Create a chain of long running processes
 This basically simulates trinity/canu/whatever pipeline
 **********************************/


println "\nPipeline = Amy -> Bob -> Cathy -> Dave -> Eve"
println " where each person runs 5 seconds to pass the baton to next person\n"

process Amy {
  output: stdout Amy_out

  script:
  """
  #! /usr/bin/env bash
  sleep 5                    # <= pause for a few seconds
  echo "Amy passes baton"
  """
}

process Bob {
  input: val baton_in from Amy_out
    
  output: stdout Bob_out

  script:
  """
  #! /usr/bin/env bash
  sleep 5                    # <= pause for a few seconds
  echo "$baton_in; Bob passes baton"
  """
}

process Cathy {
  input: val baton_in from Bob_out
    
  output: stdout Cathy_out

  script:
  """
  #! /usr/bin/env bash
  sleep 5                    # <= pause for a few seconds
  echo "$baton_in; Cathy passes baton"
  """
}

process Dave {
  input: val baton_in from Cathy_out
    
  output: stdout Dave_out

  script:
  """
  #! /usr/bin/env bash
  sleep 5                    # <= pause for a few seconds
  echo "$baton_in; Dave passes baton"
  """
}

process Eve {
  input: val baton_in from Dave_out
    
  output: stdout Eve_out

  script:
  """
  #! /usr/bin/env bash
  sleep 5                    # <= pause for a few seconds
  echo "$baton_in; Eve passes baton"
  """
}

println Eve_out.view { it.trim() }