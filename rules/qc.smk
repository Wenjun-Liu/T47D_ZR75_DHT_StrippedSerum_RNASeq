rule raw_fastqc:
    input:
        "data/raw/fastq/{sample}" + tag + ext
    output:
        html="data/raw/FastQC/{sample}" + tag + "_fastqc.html",
        zip="data/raw/FastQC/{sample}" + tag + "_fastqc.zip"
    conda:
        "../envs/fastqc.yml"
    params:
        extra = config['fastqc']['params']
    log:
        "logs/FastQC/raw/{sample}.log"
    threads: 1
    shell:
        """
        # Write to a separate temp directory for each run to avoid I/O clashes
        TEMPDIR=$(mktemp -d -t fqcXXXXXXXXXX)
        fastqc \
          {params.extra} \
          -t {threads} \
          --outdir $TEMPDIR \
         "{input}" &> "{log}"

        # Move the files
        mv $TEMPDIR/*html "$(dirname "{output.html}")"
        mv $TEMPDIR/*zip "$(dirname "{output.zip}")"

        # Clean up the temp directory
        rm -rf $TEMPDIR
        """

rule trim_fastqc:
    input:
        "data/trimmed/fastq/{sample}" + tag + ext
    output:
        html="data/trimmed/FastQC/{sample}" + tag + "_fastqc.html",
        zip="data/trimmed/FastQC/{sample}" + tag + "_fastqc.zip"
    conda:
        "../envs/fastqc.yml"
    params:
        extra = config['fastqc']['params']
    log:
        "logs/FastQC/trimmed/{sample}.log"
    threads: 1
    shell:
        """
        # Write to a separate temp directory for each run to avoid I/O clashes
        TEMPDIR=$(mktemp -d -t fqcXXXXXXXXXX)
        fastqc \
          {params.extra} \
          -t {threads} \
          --outdir $TEMPDIR \
          "{input}" &> "{log}"

        # Move the files
        mv $TEMPDIR/*html "$(dirname "{output.html}")"
        mv $TEMPDIR/*zip "$(dirname "{output.zip}")"

        # Clean up the temp directory
        rm -rf $TEMPDIR
        """
