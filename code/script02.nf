#! /usr/bin/env nextflow

/*************************************
 Nextflow variables or primative data structures
 *************************************/
println("\n#== Primitive data structures")
println "x can equal: "

x = 1                      /* Integers */
println x + "\t\t\tIntegers"

x = -3.1499392             /* Floating point values */
println x + "\t\tFloat or double values"

x = false                  /* Booleans */
println String.valueOf(x) + "\t\t\tBooleans"
/* https://www.javatpoint.com/java-boolean-to-string */

x = "Hi"                   /* Strings */
println x + "\t\t\tStrings and characters"

x = new java.util.Date()   /* Literally a java date.... */
println String.valueOf(x) + "\tOr dates from java.util.Date()"
