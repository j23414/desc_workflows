#! /usr/bin/env nextflow

/*************************************
 Execute a bash command in Nextflow
 *************************************/

/* use """ to do multi-line bash commands */
cmd_str =
  """
  echo "Hello world"
  """

result = cmd_str.execute().text
println result

/*************************************
 Link the program by full path
 A string executed can only have 1 bash command
 *************************************/

echo_program="/bin/echo"       /* full path of program */
cmd_str =
  """
  ${echo_program} "Hello again";
  echo "what is happening, why print echo" "\n"
  /* threw an error on bash comments, so can't even use bash comments in a bash block */
  /* so cmd strings cannot do multiline bash... weird */
  """
result = cmd_str.execute().text
println result
