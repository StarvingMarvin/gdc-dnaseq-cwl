#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/jeremiahsavage/picard:1
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: DB_SNP
    type: File
    format: "edam:format_3016"
    inputBinding:
      prefix: DB_SNP=
      separate: false

  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: METRIC_ACCUMULATION_LEVEL=
    type: string
    default: ALL_READS
    inputBinding:
      prefix: METRIC_ACCUMULATION_LEVEL=
      separate: false

  - id: REFERENCE_SEQUENCE
    type: File
    format: "edam:format_1929"
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
      separate: false

  - id: TMP_DIR
    type: string
    default: .
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  - id: VALIDATION_STRINGENCY
    default: STRICT
    type: string
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".alignment_summary_metrics")
    secondaryFiles:
      - ^.bait_bias_detail_metrics
      - ^.bait_bias_summary_metrics
      - ^.base_distribution_by_cycle_metrics
      - ^.base_distribution_by_cycle.pdf
      - ^.gc_bias.detail_metrics
      - ^.gc_bias.pdf
      - ^.gc_bias.summary_metrics
      - ^.insert_size_histogram.pdf
      - ^.insert_size_metrics
      - ^.pre_adapter_detail_metrics
      - ^.pre_adapter_summary_metrics
      - ^.quality_by_cycle_metrics
      - ^.quality_by_cycle.pdf
      - ^.quality_distribution_metrics
      - ^.quality_distribution.pdf
      - ^.quality_yield_metrics

arguments:
  - valueFrom: "PROGRAM=CollectAlignmentSummaryMetrics"
  - valueFrom: "PROGRAM=CollectBaseDistributionByCycle"
  - valueFrom: "PROGRAM=CollectGcBiasMetrics"
  - valueFrom: "PROGRAM=CollectInsertSizeMetrics"
  - valueFrom: "PROGRAM=CollectQualityYieldMetrics"
  - valueFrom: "PROGRAM=CollectSequencingArtifactMetrics"
  - valueFrom: "PROGRAM=MeanQualityByCycle"
  - valueFrom: "PROGRAM=QualityScoreDistribution"

  - valueFrom: $(inputs.INPUT.nameroot)
    prefix: OUTPUT=
    separate: false

baseCommand: [java, -jar, /usr/local/bin/picard.jar, CollectMultipleMetrics]