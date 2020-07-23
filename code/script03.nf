#! /usr/bin/env nextflow

/*************************************
 Grouped data structures: Lists, Maps
 *************************************/
println("\n\n#== Grouped data structures: Lists, Maps ")
myList = [1776, -1, 33, 99, 0, 928734928763]
println "myList = " + myList
println "myList[0] = " + myList[0] + "\tList index starts at 0"
println "size = " + myList.size()

tiny = ["one", "two"]
myList = [1776, -1, tiny, 99, "a", 928734928763]
println "tiny = " + tiny
println "myList = " + myList + "\tList elements can be of mixed type! Similar to R's list"

myMap = ["gene":"FOX2", "length":100, "genbank":"MX8888"]
println "\nmyMap = " + myMap
myMap["length"] = "ten"
println "myMap = " + myMap

/* Perl-style multiple assignments! : ) */
println "\n Multiple assignments (a, b, c) = [\"one\", 2, \"three\"]"
(a, b, c) = ["one", 2, "three"]
println "a = " + a + "; b = " + b + "; c = " + c