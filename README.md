NextFlow
================
Jennifer Chang
7/23/2020

Workflow tools
==============

**Last Update:** 2020/08/03

**Purpose:** Describe workflow tools in terms of Makefiles, Snakemake,
and Nextflow

Probably the earliest workflow tool is Makefiles for compiling large c++
projects. Because compilation can be long and tedious, it was important
to keep track of which files had been compiled and needed to be
recompiled. [The c++ compilation dependency graphs were put into a
Makefile](https://www.tutorialspoint.com/makefile/makefile_dependencies.htm)
and listed as rules.

    rule: dependencies...
        echo "any bash command here, usually a g++ statement"
        

In case you’re curious, here’s a [nice tutorial on
makefiles](https://makefiletutorial.com/).

[Snakemake](https://snakemake.readthedocs.io/en/stable/) workflows are
python scripts extended to include rules (notice how the rules look like
c++ Makefile rules). Snakemake is available on bioconda, pip, and
docker.

[Nextflow](https://www.nextflow.io/example1.html) place those rules
inside process structures. Nextflow is also supposed to be scalable
(parallizable) and containerizes the dependencies.

Citations
=========

-   Köster, J. and Rahmann, S., 2012. [Snakemake—a scalable
    bioinformatics workflow
    engine](https://pubmed.ncbi.nlm.nih.gov/22908215/). Bioinformatics,
    28(19), pp.2520-2522.
-   Di Tommaso, P., Chatzou, M., Floden, E.W., Barja, P.P., Palumbo, E.
    and Notredame, C., 2017. [Nextflow enables reproducible
    computational workflows](https://pubmed.ncbi.nlm.nih.gov/28398311/).
    Nature biotechnology, 35(4), pp.316-319.
-   Federico, A., Karagiannis, T., Karri, K., Kishore, D., Koga, Y.,
    Campbell, J. and Monti, S., 2019. [Pipeliner: A Nextflow-based
    framework for the definition of sequencing data processing
    pipelines](https://pubmed.ncbi.nlm.nih.gov/31316552/). Frontiers in
    genetics, 10, p.614.

NextFlow
--------

Click to expand the following items for more detail.

<details>
<summary>
Install Nextflow on MacOS - <b>DONE</b>
</summary>

Based on [installation instructions on
Nextflow](https://www.nextflow.io/), make sure Java version &gt; 1.8

    java -version
    #> java version "1.8.0_162"
    #> Java(TM) SE Runtime Environment (build 1.8.0_162-b12)
    #> Java HotSpot(TM) 64-Bit Server VM (build 25.162-b12, mixed mode)

Install a local copy of nextflow

    curl -s https://get.nextflow.io | bash
    #> CAPSULE: Downloading dependency org.slf4j:log4j-over-slf4j:jar:1.7.25
    #> CAPSULE: Downloading dependency org.multiverse:multiverse-core:jar:0.7.0
    #> CAPSULE: Downloading dependency com.fasterxml.jackson.core:jackson-databind:jar:2.6.7.2
    #> CAPSULE: Downloading dependency joda-time:joda-time:jar:2.8.1
    #> ...
    #> CAPSULE: Downloading dependency commons-codec:commons-codec:jar:1.10
    #>                                                                         
    #>       N E X T F L O W
    #>       version 20.04.1 build 5335
    #>       created 03-05-2020 19:37 UTC (14:37 CDT)
    #>       cite doi:10.1038/nbt.3820
    #>       http://nextflow.io
    #> 
    #> 
    #> Nextflow installation completed. Please note:
    #> - the executable file `nextflow` has been created in the folder: /Users/jenchang/bin/src
    #> - you may complete the installation by moving it to a directory in your $PATH
    #>

    ls -ltr
    #> -rwx--x--x  1 jenchang  staff    15K Jul 15 13:22 nextflow

The executable `nextflow` can be called locally or moved to the
`/usr/local/bin/` folder to be called from anywhere.

</details>
<details>
<summary>
Install Nextflow on Ceres HPCC - <b>worked when I tried it</b>
</summary>

After logging onto Ceres, load the java module and run the nextflow
install script

    module load java
    java -version 

    # Install Nextflow in current folder
    curl -s https://get.nextflow.io | bash

    # Test the nextflow install by running it
    ./nextflow run hello

</details>
<details>
<summary>
Simple demo - <b>DONE</b>
</summary>

The simple example from [nextflow main page](https://www.nextflow.io/)
worked.

    nextflow run hello
    #> N E X T F L O W  ~  version 20.04.1
    #> Pulling nextflow-io/hello ...
    #> downloaded from https://github.com/nextflow-io/hello.git
    #> Launching `nextflow-io/hello` [adoring_yonath] - revision: 96eb04d6a4 [master]
    #> executor >  local (4)
    #> [f0/2e6b0f] process > sayHello (3) [100%] 4 of 4 ✔
    #> Ciao world!
    #> 
    #> Hola world!
    #> 
    #> Bonjour world!
    #> 
    #> Hello world!

</details>
<details>
<summary>
Your first script - <b>DONE</b>
</summary>

Ran the [Tutorial “your first
script”](https://www.nextflow.io/docs/latest/getstarted.html#your-first-script).
Save the following into a file `tutorial.nf`. Notice how nextflow
scripts have the `.nf` extension. Also notice the shebang of the script
is not `bash` or `python` but `nextflow`.

    #!/usr/bin/env nextflow

    params.str = 'Hello world!'

    process splitLetters {

        output:
        file 'chunk_*' into letters

        """
        printf '${params.str}' | split -b 6 - chunk_
        """
    }


    process convertToUpper {

        input:
        file x from letters.flatten()

        output:
        stdout result

        """
        cat $x | tr '[a-z]' '[A-Z]'
        """
    }

    result.view { it.trim() }

Running the nf script results in :

    nextflow run tutorial.nf 
    #> N E X T F L O W  ~  version 20.04.1
    #> Launching `tutorial.nf` [confident_hilbert] - revision: be42f295f4
    #> executor >  local (3)
    #> [e7/25735b] process > splitLetters       [100%] 1 of 1 ✔
    #> [c5/fe3e83] process > convertToUpper (1) [100%] 2 of 2 ✔
    #> WORLD!
    #> HELLO

It might be a little confusing on how to read this script. Read from
**bottom up**, I’ve annotated arrows for how my eyes move across the
script.

<img src="imgs/eye_movement.png" />

Processes are executed up the dependency becaues `results` must be
created for the output.

Regardless, I’ll need a better understanding of what
`results.view {it.trim()}` is doing… and which data structures are
available in the nextflow language. This doesn’t look like standard
bash.

</details>

> For Nextflow language basics, recommend starting at this
> [sphinx-generated
> documentation](https://www.nextflow.io/docs/latest/script.html#script-page)…notice
> that the language seems to wrap bash scripts in java functions. Honest
> reaction so far is that nextflow commands seem to be aimed at java
> programmers. Despite the shebang `#! /usr/bin/env` which usually
> indicates bash/python/other scripting-style languages, the function
> names (example: `println` instead of bash’s `echo`) are from java.
> Nextflow feels like trying to “speak bash with a java accent”. Not
> saying it’s bad, but still exploring features on if the java-accent is
> worth it.

<details>
<summary>
Nextflow basics: data structures - <b>DONE</b>
</summary>

Let’s start with a hello world… this thing needs to print, putting it
into a process without generating a print statement/file doesn’t prove
it runs or even makes sense.

Let’s make a basic “Hello world” **print** to console in **script01.nf**

    #! /usr/bin/env nextflow

    /* Java-style comments */

    println "Hello world!"       /* println() is literally a Java function, not a function in bash */

The **bash** run and output works.

    nextflow run script01.nf
    #> N E X T F L O W  ~  version 20.04.1
    #> Launching `script01.nf` [gigantic_koch] - #> revision: 583e6071f6
    #> Hello world!

Moving on to defining **basic variables** and printing them in
**script02.nf**: integers, float/double, booleans, strings

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

Which gives us in **bash**:

    nextflow run script02.nf
    #> N E X T F L O W  ~  version 20.04.1
    #> Launching `script02.nf` [desperate_bell] - revision: 283effe268
    #> 
    #> #== Primitive data structures
    #> x can equal: 
    #> 1                Integers
    #> -3.1499392               Float or double values
    #> false            Booleans
    #> Hi               Strings and characters
    #> Thu Jul 23 10:56:34 CDT 2020 Or dates from java.util.Date()

Nextflow has **grouped data structures** that can have heterogeneous
types… as a comparison c++ usually has homogeneous element collections
(unless you hack it with smart pointers).

Demonstrate list, map and multi assignment in **script03.nf**:

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

Output in bash:

    nextflow run script03.nf

    #> N E X T F L O W  ~  version 20.04.1
    #> Launching `script03.nf` [kickass_shirley] - revision: 19bc7c56d2
    #>
    #> #== Grouped data structures: Lists, Maps
    #> myList = [1776, -1, 33, 99, 0, 928734928763]
    #> myList[0] = 1776     List index starts at 0
    #> size = 6
    #> tiny = [one, two]
    #> myList = [1776, -1, [one, two], 99, a, 928734928763] List elements can be of mixed type! Similar to R's list
    #>
    #> myMap = [gene:FOX2, length:100, genbank:MX8888]
    #> myMap = [gene:FOX2, length:ten, genbank:MX8888]
    #>
    #>  Multiple assignments (a, b, c) = ["one", 2, "three"]
    #> a = one; b = 2; c = three

</details>
<details>
<summary>
Nextflow execute bash/R/Python scripts via process - <b>DONE</b>
</summary>

A bash command is saved as a string and then `execute`-ed in
**script04.nf**

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

However notice how the string can only have one command as it prints out
the next `echo` in the **bash** output, instead of executing it.

    nextflow run script04.nf
    #> N E X T F L O W  ~  version 20.04.1
    #> Launching `script04.nf` [romantic_jones] - revision: 4536b402c2
    #> "Hello world"
    #> 
    #> "Hello again"; echo "what is happening, why print echo" " " /* threw an error on bash comments, so can't even use bash comments in a bash block */ /* so cmd strings cannot do multiline bash... weird */

This is fixed in the process structures, where multi-line commands seem
to work.

Still called **script05.nf** but using process structures.

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

Process 1 doesn’t have an output specified, so prints nothing. Process 2
is connected to output `result2`. Process 3 is a bunch of R commands,
basically need the shebang to specify the language.

    nextflow run script05.nf
    #> Notice how above has no output
    #> DataflowVariable(value=null)
    #> DataflowVariable(value=null)
    #> executor >  local (3)
    #> [d0/e1cf69] process > myprocess1 [100%] 1 of 1 ✔
    #> [58/f7a9bb] process > myprocess2 [100%] 1 of 1 ✔
    #> [4b/847e83] process > myprocess3 [100%] 1 of 1 ✔
    #> Process2 says hello
    #> Still in Process 2
    #> Rscript says Hello world
    #> 1 2 3 4 5

</details>
<details>
<summary>
Minimal example of a chain of processes - <b>DONE and neat : )</b>
</summary>

Instead of worrying about installing a long running program, we’ll
simulate it using the `sleep 5` command (wait 5 seconds).

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

Which looks nice in bash… as it prints progress

    N E X T F L O W  ~  version 20.04.1
    Launching `code/script06.nf` [crazy_mclean] - revision: c6a509673f

    Pipeline = Amy -> Bob -> Cathy -> Dave -> Eve
     where each person runs 5 seconds to pass the baton to next person

    DataflowVariable(value=null)
    executor >  local (2)
    [ee/41b22c] process > Amy   [100%] 1 of 1 ✔
    [cf/db02ae] process > Bob   [  0%] 0 of 1
    [-        ] process > Cathy -
    [-        ] process > Dave  -
    [-        ] process > Eve   -

Eventually looks like the following when finished:

    nextflow run script06.nf
    N E X T F L O W  ~  version 20.04.1
    Launching `code/script06.nf` [crazy_mclean] - revision: c6a509673f

    Pipeline = Amy -> Bob -> Cathy -> Dave -> Eve
     where each person runs 5 seconds to pass the baton to next person

    DataflowVariable(value=null)
    executor >  local (5)
    [ee/41b22c] process > Amy   [100%] 1 of 1 ✔
    [cf/db02ae] process > Bob   [100%] 1 of 1 ✔
    [b0/cccd94] process > Cathy [100%] 1 of 1 ✔
    [9f/a652c6] process > Dave  [100%] 1 of 1 ✔
    [ca/39a72a] process > Eve   [100%] 1 of 1 ✔
    Amy passes baton
    ; Bob passes baton
    ; Cathy passes baton
    ; Dave passes baton
    ; Eve passes baton

And if you run it with the html reports turned on:

    nextflow run script06.nf -with-timeline timeline.html

It will also generate a plot:

<img src="imgs/timeline.png" />

</details>
<details>
<summary>
Nextflow nf-core/RNAseq - <b>DONE</b>, okay I admit the HTML reports are
neat
</summary>

`nf-core` has a curated set of pipelines. We’ll run the rnaseq pipeline
([github link](https://github.com/nf-core/rnaseq)).

-   Start Docker deamon on MacOS
-   Run the nf\_core/rnaseq pipeline (will pull via docker)

<!-- -->

    nextflow run nf-core/rnaseq -profile test,docker

    #> N E X T F L O W  ~  version 20.07.1
    #> Launching `nf-core/rnaseq` [romantic_ekeblad] - revision: 3b6df9bd10 [master]
    #> Both GTF and GFF have been provided: Using GTF as priority.
    #> ----------------------------------------------------
    #>                                         ,--./,-.
    #>         ___     __   __   __   ___     /,-._.--~'
    #>   |\ | |__  __ /  ` /  \ |__) |__         }  {
    #>   | \| |       \__, \__/ |  \ |___     \`-._,-`-,
    #>                                         `._,._,'
    #>   nf-core/rnaseq v1.4.2
    #> ----------------------------------------------------
    #> Pipeline Release  : master
    #> Run Name          : romantic_ekeblad
    #> Reads             : data/*{1,2}.fastq.gz
    #> Data Type         : Single-End
    #> Strandedness      : None
    #> Trimming          : 5'R1: 0 / 5'R2: 0 / 3'R1: 0 / 3'R2: 0 / NextSeq Trim: 0
    #> Aligner           : STAR
    #> Fasta Ref         : https://github.com/nf-core/test-datasets/raw/rnaseq/reference/genome.fa
    #> GTF Annotation    : https://github.com/nf-core/test-datasets/raw/rnaseq/reference/genes.gtf
    #> GFF3 Annotation   : https://github.com/nf-core/test-datasets/raw/rnaseq/reference/genes.gff
    #> Remove Ribosomal RNA: false
    #> Biotype GTF field : gene_biotype
    #> Save prefs        : Ref Genome: No / Trimmed FastQ: No / Alignment intermediates: No
    #> Max Resources     : 6 GB memory, 2 cpus, 2d time per job
    #> Container         : docker - nfcore/rnaseq:1.4.2
    #> Output dir        : ./results
    #> Launch dir        : /Users/jenchang/Desktop/nextflow/rnaseq
    #> Working dir       : /Users/jenchang/Desktop/nextflow/rnaseq/work
    #> Script dir        : /Users/jenchang/.nextflow/assets/nf-core/rnaseq
    #> User              : jenchang
    #> Config Profile    : test,docker
    #> Config Description: Minimal test dataset to check pipeline function
    #> ----------------------------------------------------
    #> executor >  local (2)
    #> [c0/8019a5] process > get_software_versions                                                            [100%] 1 of 1 ✔
    #> [8b/cc096d] process > makeBED12 (genes.gtf)                                                            [100%] 1 of 1, cached: 1 ✔
    #> [60/7887a7] process > makeSTARindex (genome.fa)                                                        [100%] 1 of 1, cached: 1 ✔
    #> [87/f6d048] process > fastqc (SRR4238379)                                                              [100%] 4 of 4, cached: 4 ✔
    #> [d0/3e2134] process > trim_galore (SRR4238379)                                                         [100%] 4 of 4, cached: 4 ✔
    #> [73/7e1877] process > star (SRR4238351)                                                                [100%] 4 of 4, cached: 4 ✔
    #> [11/345d31] process > rseqc (SRR4238359_subsampAlignedByCoord.out)                                     [100%] 4 of 4, cached: 4 ✔
    #> [a7/86a5f3] process > preseq (SRR4238355_subsampAlignedByCoord.out)                                    [100%] 4 of 4, cached: 4 ✔
    #> [00/fb14d4] process > markDuplicates (SRR4238355_subsampAlignedByCoord.out)                            [100%] 4 of 4, cached: 4 ✔
    #> [4b/46f0d1] process > qualimap (SRR4238355_subsampAligned.sortedByCoord.out)                           [100%] 4 of 4, cached: 4 ✔
    #> [d7/c9cf11] process > dupradar (SRR4238359_subsampAligned.sortedByCoord.out.markDups)                  [100%] 4 of 4, cached: 4 ✔
    #> [4d/a7d8d3] process > featureCounts (SRR4238355_subsampAlignedByCoord.out)                             [100%] 4 of 4, cached: 4 ✔
    #> [83/d7dfa8] process > merge_featureCounts (SRR4238351_subsampAlignedByCoord.out_gene.featureCounts)    [100%] 1 of 1, cached: 1 ✔
    #> [2f/48c37b] process > stringtieFPKM (SRR4238355_subsampAlignedByCoord.out)                             [100%] 4 of 4, cached: 4 ✔
    #> [4c/f714fc] process > sample_correlation (SRR4238351_subsamp.sortedByCoord.out_gene.featureCounts.txt) [100%] 1 of 1, cached: 1 ✔
    #> [81/d24248] process > multiqc                                                                          [100%] 1 of 1 ✔
    #> [13/233996] process > output_documentation                                                             [100%] 1 of 1, cached: 1 ✔
    #> [0;35m[nf-core/rnaseq] Pipeline completed successfully
    #> Completed at: 29-Jul-2020 18:45:46
    #> Duration    : 1m 28s
    #> CPU hours   : 0.3 (87.9% cached)
    #> Succeeded   : 2
    #> Cached      : 45

This generates the following `results` folder, containing output folders

    ls -ltr results/

    #> total 0
    #> drwxr-xr-x   7 jenchang  staff   224B Jul 29 17:13 fastqc
    #> drwxr-xr-x   5 jenchang  staff   160B Jul 29 17:14 trim_galore
    #> drwxr-xr-x   3 jenchang  staff    96B Jul 29 17:14 STAR
    #> drwxr-xr-x  11 jenchang  staff   352B Jul 29 17:16 markDuplicates
    #> drwxr-xr-x   6 jenchang  staff   192B Jul 29 17:16 preseq
    #> drwxr-xr-x  13 jenchang  staff   416B Jul 29 17:16 rseqc
    #> drwxr-xr-x   9 jenchang  staff   288B Jul 29 17:17 stringtieFPKM
    #> drwxr-xr-x   6 jenchang  staff   192B Jul 29 17:17 qualimap
    #> drwxr-xr-x   8 jenchang  staff   256B Jul 29 17:17 sample_correlation
    #> drwxr-xr-x  15 jenchang  staff   480B Jul 29 17:17 dupradar
    #> drwxr-xr-x   6 jenchang  staff   192B Jul 29 17:17 featureCounts
    #> drwxr-xr-x   5 jenchang  staff   160B Jul 29 18:45 MultiQC
    #> drwxr-xr-x  14 jenchang  staff   448B Jul 29 18:45 pipeline_info

Inside of `pipeline_info` are html generated reports for runtime and
more details of pipeline

<img src="imgs/nf_core_rnaseq.png" />
<img src="imgs/nf_core_rnaseq_executionreport.png" />
<img src="imgs/nf_core_rna_executiontime.png" />

Okay, I admit that the html reports are nice. Looking at the source
code, the whole pipeline is defined in
[main.nf](https://github.com/nf-core/rnaseq/blob/master/main.nf)… if we
focus on the **fastqc** step, we can see process:

    /*
     * STEP 1 - FastQC
     */
    process fastqc {
        tag "$name"
        label 'process_medium'
        publishDir "${params.outdir}/fastqc", mode: 'copy',
            saveAs: { filename -> filename.indexOf(".zip") > 0 ? "zips/$filename" : "$filename" }

        when:
        !params.skipQC && !params.skipFastQC

        input:
        set val(name), file(reads) from raw_reads_fastqc

        output:
        file "*_fastqc.{zip,html}" into fastqc_results

        script:
        """
        fastqc --quiet --threads $task.cpus $reads
        """
    }

Notice the `publishDir "${params.outdir}/fastqc` declaration, the
`${params.outdir}` was set to ‘results’ earlier in this script, so this
is how we get a `results` directory. Each step of the pipeline can have
its own process and could organize the output similar to
`results/program_name`.

</details>
<details>
<summary>
modules and writing files - <b>DONE</b>
</summary>

Let’s create a process that creates an example fasta file. Notice how we
need a `publishDir` in the process.

    #! /usr/bin/env nextflow

    /***********************************
     Create an example demo fasta file
     ***********************************/

    process demo_fasta {
      publishDir "${params.outdir}", mode: 'copy'
      
      output: path 'demo.fasta'
      
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

    /***********************************
     Create a blastn database
     ***********************************/

    process makeblastdb {
      publishDir "${params.outdir}", mode: 'copy'

      input: path x_fasta
      output: file "${x_fasta}*"
      
      script:
      """
      makeblastdb -in ${x_fasta} -dbtype nucl -out ${x_fasta}
      """
    }

    /***********************************
     Blastn a query against the database (do this in parallel?)
     ***********************************/
    // /** in progress **/
    // process blastn {
    //   publishDir "${params.outdir}", mode: 'copy'
    //   input: path query_fasta
    //   output: file "blast_output.txt"
    //   script:
    //   """
    //   blastn -db ${somedb} -query ${query_fasta} -outfmt 6 -out blast_output.txt
    //   """
    // }

And include that process in a different nextflow script

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

Running the script results in…

    nextflow run script07.nf --outdir output_dir
    #> N E X T F L O W  ~  version 20.07.1
    #> Launching `script07.nf` [thirsty_dalembert] - revision: 997b0d2610
    #> executor >  local (2)
    #> [64/a3898f] process > demo_fasta  [100%] 1 of 1 ✔
    #> [27/bd30d1] process > makeblastdb [100%] 1 of 1 ✔

    ls -ltr output_dir/
    #> total 120
    #> -rw-r--r--  1 jenchang  staff    72B Aug  3 13:11 demo.fasta
    #> -rw-r--r--  1 jenchang  staff    20K Aug  3 13:11 demo.fasta.ndb
    #> -rw-r--r--  1 jenchang  staff    13B Aug  3 13:11 demo.fasta.nsq
    #> -rw-r--r--  1 jenchang  staff   146B Aug  3 13:11 demo.fasta.nhr
    #> -rw-r--r--  1 jenchang  staff    12B Aug  3 13:11 demo.fasta.nto
    #> -rw-r--r--  1 jenchang  staff   124B Aug  3 13:11 demo.fasta.nin
    #> -rw-r--r--  1 jenchang  staff    32B Aug  3 13:11 demo.fasta.not
    #> -rw-r--r--  1 jenchang  staff    16K Aug  3 13:11 demo.fasta.ntf

    cat output_dir/demo.fasta
    #> >Sequence_A
    #> AAAAAAAAAAAAAAAAAAAAAAA
    #> >Sequence_C
    #> CCCCCCCCCCCCCCCCCCCCCCC

</details>
<details>
<summary>
Pass parameters, or arguments to script - <b>DONE</b>
</summary>

You can pass parameters to a nextflow script

    #! /usr/bin/env nextflow

    // Give default values
    params.input = 'default.txt'
    params.outdir = 'results'

    // Use the parameters in a print statement
    println "params.input = $params.input"
    println "params.output = $params.outdir"

Running the script in three different ways below. Notice how parameters
`--input` can be changed.

    nextflow run script08.nf
    #> N E X T F L O W  ~  version 20.07.1
    #> Launching `script08.nf` [pedantic_sinoussi] - revision: fee10780ef
    #> params.input = default.txt
    #> params.output = ./results

    nextflow run script08.nf --input "something.txt"
    #> N E X T F L O W  ~  version 20.07.1
    #> Launching `script08.nf` [hopeful_magritte] - revision: fee10780ef
    #> params.input = something.txt
    #> params.output = ./results

    nextflow run script08.nf --input "something.txt" --outdir "here"
    #> N E X T F L O W  ~  version 20.07.1
    #> Launching `script08.nf` [peaceful_minsky] - revision: fee10780ef
    #> params.input = something.txt
    #> params.output = here

</details>
<details>
<summary>
SLURM - <b>in progress</b>
</summary>

You can place general params and directives in the `nextflow.config`
file.

    /***************************************
     Name: Nextflow Config File
     Auth: Jennifer Chang
     Auth: Andrew Severin
     Desc: Nextflow Configuration File must be in same folder as nf script (or in .nextflow)
     Docs: https://hpc.nih.gov/apps/nextflow.html
           https://www.nextflow.io/docs/latest/config.html

     ***************************************/

    /*****************************
     Define default param values 
     (overwrite it via --outdir diff_directory)
     *****************************/
    params {
      outdir = './results'
    //  input = './data/*'
    }


    /*****************************
     Define computing resource 
     (local/slurm/aws)
     *****************************/
    process {
      publishDir = "$params.outdir"
      
      /* comment and uncoment following for slurm */
      executor = 'slurm'
      clusterOptions = '-N 2 -t 01:00:00' //<= put all slurm settings here
    }

    /*****************************
     Generate html runtime reports
     Same as adding:
      -with-timeline timeline.html
      -with-report report.html
     *****************************/
    timeline {
      enabled = true
      file = "$params.outdir/timeline.html"
    }

    report {
      enabled = true
      file = "$params.outdir/report.html"
    }

Running a nextflow in the same folder will run via slurm

    nextflow run script06.nf --outdir output_06
    #> N E X T F L O W  ~  version 20.07.1
    #> Launching `script06.nf` [desperate_colden] - revision: 0be74525f0
    #> 
    #> Pipeline = Amy -> Bob -> Cathy -> Dave -> Eve
    #> where each person runs 5 seconds to pass the baton to next person
    #>
    #> DataflowVariable(value=null)
    #> executor >  slurm (3)                    <=======================SLURM
    #> [6e/5165fa] process > Amy   [100%] 1 of 1 ✔
    #> [d6/b741d1] process > Bob   [100%] 1 of 1 ✔
    #> [3a/583297] process > Cathy [  0%] 0 of 1
    #> [-        ] process > Dave  -
    #> [-        ] process > Eve   -

Notice how there’s a `slurm(3)` line. From a different terminal, we can
view queue, for me the `Bob` process is running as `nf-Bob`.

    squeue | grep jenchang
    #> 1076059 short_med   nf-Bob jenchang  R       0:00      2 condo[005-006] 
    #> 1076026     debug       sh jenchang  R    1:29:26      1 condodebug001 

And after the run we have the timeline information

    ls -ltr output_06/
    #> total 1390
    #> -rw-r-----. 1 jenchang its-hpc-condo-severin 2929977 Aug  5 14:30 report.html
    #> -rw-r-----. 1 jenchang its-hpc-condo-severin    6590 Aug  5 14:30 timeline.html

Looking at timeline, there are longer wait times between jobs:

<img src="imgs/timeline_slurm.png" />

</details>

**TODO:**

-   Find a nextflow script that uses a container
-   See how nextflow determines dependencies
-   Does it automatically create parallel processes, or does coder need
    to provide some config file to recommend how to parallize program.

Common Nextflow errors
----------------------

<details>
<summary>
Do not use bash-style comments
</summary>

An example bash-style comment (`# this is a bash comment`) error
message.

    nextflow run script02.nf
    #> N E X T F L O W  ~  version 20.04.1
    #> Launching `script02.nf` [adoring_mcnulty] - revision: b47fa12571
    #> Script compilation error
    #> - file : /Users/jenchang/Desktop/2020-07-23_Nextflow/nextflow/#> Notebook_Jenchang/code/script02.nf
    #> - cause: unexpected char: '#' @ line 4, column 1.
    #>   # this is a bash comment
    #>   ^
    #>
    #> 1 error

Instead use java-style comments (`/* this is a java-style comment */`).

</details>
<details>
<summary>
Convert data to a string type
</summary>

Especially when you are printing a datatype, may need to convert to
string. Showing an example error msg for printing a boolean with a
string (`x = false; println x + "\t this is a bool"`)

    nextflow run script04.nf
    N E X T F L O W  ~  version 20.04.1
    Launching `script04.nf` [modest_ptolemy] - revision: d9c9745850
    Unknown method `plus` on Boolean type

     -- Check script 'script04.nf' at line: 4 or see '.nextflow.log' file for more details

Usually can fix this by using java’s `String.valueOf()` function:

    x = false
    println String.valueOf(x) + "\t this is a bool"

</details>
