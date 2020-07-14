# Workflow tools

**Purpose:** Describe workflow tools in terms of Makefiles, Snakemake, and Nextflow

Probably the earliest workflow tool is Makefiles for compiling large c++ projects. Because compilation can be long and tedious, it was important to keep track of which files had been compiled and needed to be recompiled. [The c++ compilation dependency graphs were put into a Makefile](https://www.tutorialspoint.com/makefile/makefile_dependencies.htm) and listed as rules.

```
rule:
    echo "any bash command here, usually a g++ statement"
    
```

[Snakemake](https://snakemake.readthedocs.io/en/stable/) workflows are python scripts extended to include rules (notice how the rules look like c++ Makefile rules). Snakemake is available on bioconda, pip, and docker.

[Nextflow](https://www.nextflow.io/example1.html) place those rules inside process structures. Nextflow is also supposed to be scalable (parallizable) and containerizes the dependendencies.

# Citations

* Köster, J. and Rahmann, S., 2012. [Snakemake—a scalable bioinformatics workflow engine](https://pubmed.ncbi.nlm.nih.gov/22908215/). Bioinformatics, 28(19), pp.2520-2522.
* Di Tommaso, P., Chatzou, M., Floden, E.W., Barja, P.P., Palumbo, E. and Notredame, C., 2017. [Nextflow enables reproducible computational workflows](https://pubmed.ncbi.nlm.nih.gov/28398311/). Nature biotechnology, 35(4), pp.316-319.
* Federico, A., Karagiannis, T., Karri, K., Kishore, D., Koga, Y., Campbell, J. and Monti, S., 2019. [Pipeliner: A Nextflow-based framework for the definition of sequencing data processing pipelines](https://pubmed.ncbi.nlm.nih.gov/31316552/). Frontiers in genetics, 10, p.614.
 
