# Workflow tools

**Last Update:** 2020/07/15

**Purpose:** Describe workflow tools in terms of Makefiles, Snakemake, and Nextflow

Probably the earliest workflow tool is Makefiles for compiling large c++ projects. Because compilation can be long and tedious, it was important to keep track of which files had been compiled and needed to be recompiled. [The c++ compilation dependency graphs were put into a Makefile](https://www.tutorialspoint.com/makefile/makefile_dependencies.htm) and listed as rules. In case you're curious, here's a [nice tutorial on makefiles](https://makefiletutorial.com/).

```
rule:
    echo "any bash command here, usually a g++ statement"
    
```

[Snakemake](https://snakemake.readthedocs.io/en/stable/) workflows are python scripts extended to include rules (notice how the rules look like c++ Makefile rules). Snakemake is available on bioconda, pip, and docker.

[Nextflow](https://www.nextflow.io/example1.html) place those rules inside process structures. Nextflow is also supposed to be scalable (parallizable) and containerizes the dependencies.

# Citations

* Köster, J. and Rahmann, S., 2012. [Snakemake—a scalable bioinformatics workflow engine](https://pubmed.ncbi.nlm.nih.gov/22908215/). Bioinformatics, 28(19), pp.2520-2522.
* Di Tommaso, P., Chatzou, M., Floden, E.W., Barja, P.P., Palumbo, E. and Notredame, C., 2017. [Nextflow enables reproducible computational workflows](https://pubmed.ncbi.nlm.nih.gov/28398311/). Nature biotechnology, 35(4), pp.316-319.
* Federico, A., Karagiannis, T., Karri, K., Kishore, D., Koga, Y., Campbell, J. and Monti, S., 2019. [Pipeliner: A Nextflow-based framework for the definition of sequencing data processing pipelines](https://pubmed.ncbi.nlm.nih.gov/31316552/). Frontiers in genetics, 10, p.614.

## NextFlow

Each item below can be expanded, to see details

<details><summary>Install Nextflow on MacOS - <b>DONE</b></summary>

Based on [installation instructions on Nextflow](https://www.nextflow.io/), make sure Java version > 1.8

```
java -version
#> java version "1.8.0_162"
#> Java(TM) SE Runtime Environment (build 1.8.0_162-b12)
#> Java HotSpot(TM) 64-Bit Server VM (build 25.162-b12, mixed mode)
```

Install a local copy of nextflow

```
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
```

The executable `nextflow` can be called locally or moved to the `/usr/local/bin/` folder to be called from anywhere.

</details>


<details> <summary>Simple demo - <b>DONE</b></summary>

The simple example from [nextflow main page](https://www.nextflow.io/) worked.

```
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
```

</details>


<details><summary>Your first script - <b>DONE</b></summary>

Ran the [Tutorial "your first script"](https://www.nextflow.io/docs/latest/getstarted.html#your-first-script). Save the following into a file `tutorial.nf`. Notice how nextflow scripts have the `.nf` extension. Also notice the shebang of the script is not `bash` or `python` but `nextflow`.

```
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
```

Running the nf script results in :

```
nextflow run tutorial.nf 
#> N E X T F L O W  ~  version 20.04.1
#> Launching `tutorial.nf` [confident_hilbert] - revision: be42f295f4
#> executor >  local (3)
#> [e7/25735b] process > splitLetters       [100%] 1 of 1 ✔
#> [c5/fe3e83] process > convertToUpper (1) [100%] 2 of 2 ✔
#> WORLD!
#> HELLO
```

It might be a little confusing on how to read this script. Read from **bottom up**, I've annotated arrows for how my eyes move across the script.

<img src="imgs/eye_movement.png" />

Processes are executed up the dependency becaues `results` must be created for the output.

</details>

**TODO:**

* Find a nextflow script that uses a container
* See how nextflow determines dependencies
* Does it automatically create parallel processes, or does coder need to provide some config file to recommend how to parallize program.
