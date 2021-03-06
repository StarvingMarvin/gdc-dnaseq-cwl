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

  - id: known_snp_vcf_path
    type: File
    inputBinding:
      prefix: --known_snp_vcf_path
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

outputs:
  - id: output_grp
    type: File
    description: "The grp file"
    outputBinding:
      glob: $(inputs.bam_path.path.split('/').slice(-1)[0].slice(0,-4) + "_bqsr.grp")

  - id: log
    type: File
    description: "python log file"
    outputBinding:
      glob: $(inputs.uuid + "_gatk_baserecalibrator.log")

  - id: output_bam
    type: File
    outputBinding:
      glob: $(inputs.bam_path.path.split('/').slice(-1)[0])
    secondaryFiles:
      - ^.bai

  - id: output_sqlite
    type: File
    description: "sqlite file"
    outputBinding:
      glob: $(inputs.uuid + ".db")
          
baseCommand: ["/home/ubuntu/.virtualenvs/p3/bin/python","/home/ubuntu/tools/cocleaning-tool/main.py", "--tool_name", "baserecalibrator"]
