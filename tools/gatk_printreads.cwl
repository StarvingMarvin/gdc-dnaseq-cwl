#!/usr/bin/env cwl-runner

cwlVersion: "cwl:draft-3"

description: |
  Usage:  cwl-runner <this-file-path> XXXX
  Options:
    --bam_path       XXXX
    --uuid           XXXX

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/cocleaning-tool

class: CommandLineTool

inputs:
  - id: bam_path
    type: File
    inputBinding:
      prefix: --bam_path
    secondaryFiles:
      - ^.bai

  - id: bqsr_grp_path
    type: File
    inputBinding:
      prefix: --bqsr_table_path

  - id: reference_fasta_path
    type: File
    inputBinding:
      prefix: --reference_fasta_path
    secondaryFiles:
      - .fai
      - ^.dict

  - id: thread_count
    type: int
    inputBinding:
      prefix: --thread_count

  - id: uuid
    type: string
    inputBinding:
      prefix: --uuid

outputs:
  - id: output_bam
    type: File
    description: "The BAM file"
    outputBinding:
      glob: $(inputs.bam_path.path.split('/').slice(-1)[0])
    secondaryFiles:
      - ^.bai
          
  - id: log
    type: File
    description: "python log file"
    outputBinding:
      glob: $(inputs.uuid + "_gatk_printreads.log")

  - id: output_sqlite
    type: File
    description: "sqlite file"
    outputBinding:
      glob: $(inputs.uuid + ".db")
          
baseCommand: ["/home/ubuntu/.virtualenvs/p3/bin/python","/home/ubuntu/tools/cocleaning-tool/main.py", "--tool_name", "printreads"]
