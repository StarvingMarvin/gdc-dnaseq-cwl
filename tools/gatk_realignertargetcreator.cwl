#!/usr/bin/env cwl-runner

cwlVersion: "cwl:draft-3"

description: |
  Usage:  cwl-runner <this-file-path> XXXX
  Options:
    --bam_path       input bam path
    --uuid           uuid

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/cocleaning-tool

class: CommandLineTool

inputs:
  - id: bam_path
    type:
      type: array
      items: File
      inputBinding:
        prefix: --bam_path
      secondaryFiles:
        - ^.bai

  - id: known_indel_vcf_path
    type: File
    inputBinding:
      prefix: --known_indel_vcf_path
    secondaryFiles:
      - .tbi

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

  - id: "#db_cred_s3url"
    type: string

  - id: "#s3cfg_path"
    type: File

outputs:
  - id: output_intervals
    type: File
    description: "The index file"
    outputBinding:
      glob: $(inputs.uuid + ".intervals")

  - id: log
    type: File
    description: "python log file"
    outputBinding:
      glob: $(inputs.uuid + "_gatk_realignertargetcreator.log")

  - id: output_sqlite
    type: File
    description: "sqlite file"
    outputBinding:
      glob: $(inputs.uuid + ".db")

baseCommand: ["/home/ubuntu/.virtualenvs/p3/bin/python","/home/ubuntu/tools/cocleaning-tool/main.py", "--tool_name", "realignertargetcreator"]
