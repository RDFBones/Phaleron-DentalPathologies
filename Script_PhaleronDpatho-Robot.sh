#! /bin/bash

## BUILD DEPENDENCIES
#####################

## BABAO

robot template --template Template_Babao.tsv \
      --input ../RDFBones-O/robot/results/rdfbones.owl \
      --prefix "babao: http://w3id.org/rdfbones/ext/babao/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --ontology-iri "http://w3id.org/rdfbones/ext/babao/latest/babao.owl" \
      --output results/babao.owl

## DENTPATH

robot template --template Template_DentPath.tsv \
      --input ../RDFBones-O/robot/results/rdfbones.owl \
      --prefix "dentpath: http://w3id.org/rdfbones/ext/dentpath/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --ontology-iri "http://w3id.org/rdfbones/ext/dentpath/latest/dentpath.owl" \
      --output results/dentpath.owl


## BUILD ONTOLOGY EXTENSION
###########################

## CATEGORY LABELS

## Build Category Labels

robot template --template Template_PhaleronDpatho-CategoryLabels.tsv \
      --input ../RDFBones-O/robot/results/rdfbones.owl \
      --prefix "phaleron-dpatho: http://w3id.org/rdfbones/ext/phaleron-dpatho/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-dpatho/latest/phaleron-dpatho.owl" \
      --output results/CategoryLabels.owl


## VALUE SPECIFICATIONS

## Merge Input

robot merge --input ../RDFBones-O/robot/results/rdfbones.owl \
      --input ../Phaleron-Pathologies/results/phaleron-patho.owl \
      --input ../Standards-Dental1/results/standards-dental1.owl \
      --input ../Standards-Pathologies/results/standards-patho.owl \
      --input results/babao.owl \
      --input results/dentpath.owl \
      --input results/CategoryLabels.owl \
      --output results/merged_CategoryLabels.owl

## Build Value Specifications

robot template --template Template_PhaleronDpatho-ValueSpecifications.tsv \
      --input results/merged_CategoryLabels.owl \
      --prefix "babao: http://w3id.org/rdfbones/ext/babao/" \
      --prefix "dentpath: http://w3id.org/rdfbones/ext/dentpath/" \
      --prefix "phaleron-dpatho: http://w3id.org/rdfbones/ext/phaleron-dpatho/" \
      --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --prefix "standards-dental1: http://w3id.org/rdfbones/ext/standards-dental1/" \
      --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
      --prefix "xsd: http://www.w3.org/2001/XMLSchema#" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-dpatho/latest/phaleron-dpatho.owl" \
      --output results/Value_Specifications.owl


## MEASUREMENT DATA

## Merge Input

robot merge --input results/merged_CategoryLabels.owl \
      --input results/dentpath.owl \
      --input results/Value_Specifications.owl \
      --output results/merged_ValueSpecifications.owl

## Build Measurement Data

robot template --template Template_PhaleronDpatho-MeasurementData.tsv \
      --input results/merged_ValueSpecifications.owl \
      --prefix "babao: http://w3id.org/rdfbones/ext/babao/" \
      --prefix "dentpath: http://w3id.org/rdfbones/ext/dentpath/" \
      --prefix "phaleron-dpatho: http://w3id.org/rdfbones/ext/phaleron-dpatho/" \
      --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --prefix "standards-dental1: http://w3id.org/rdfbones/ext/standards-dental1/" \
      --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
      --prefix "xsd: http://www.w3.org/2001/XMLSchema#" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-dpatho/latest/phaleron-dpatho.owl" \
      --output results/MeasurementData.owl

## DATA SETS

## Merge Input

robot merge --input results/merged_ValueSpecifications.owl \
      --input results/MeasurementData.owl \
      --output results/merged_MeasurementData.owl

## Build Datasets

robot template --template Template_PhaleronDpatho-Datasets.tsv \
      --input results/merged_MeasurementData.owl \
      --prefix "babao: http://w3id.org/rdfbones/ext/babao/" \
      --prefix "dentpath: http://w3id.org/rdfbones/ext/dentpath/" \
      --prefix "phaleron-dpatho: http://w3id.org/rdfbones/ext/phaleron-dpatho/" \
      --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --prefix "standards-dental1: http://w3id.org/rdfbones/ext/standards-dental1/" \
      --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
      --prefix "xsd: http://www.w3.org/2001/XMLSchema#" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-dpatho/latest/phaleron-dpatho.owl" \
      --output results/Datasets.owl


## PROCESSES

## Merge Input

robot merge --input results/merged_MeasurementData.owl \
      --input results/Datasets.owl \
      --output results/merged_Datasets.owl

## Build Processes

robot template --template Template_PhaleronDpatho-ProcessesRoles.tsv \
      --input results/merged_Datasets.owl \
      --prefix "babao: http://w3id.org/rdfbones/ext/babao/" \
      --prefix "dentpath: http://w3id.org/rdfbones/ext/dentpath/" \
      --prefix "phaleron-dpatho: http://w3id.org/rdfbones/ext/phaleron-dpatho/" \
      --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --prefix "standards-dental1: http://w3id.org/rdfbones/ext/standards-dental1/" \
      --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
      --prefix "xsd: http://www.w3.org/2001/XMLSchema#" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-dpatho/latest/phaleron-dpatho.owl" \
      --output results/Processes.owl


## PREPARE OUTPUT
#################

robot merge --input results/CategoryLabels.owl \
      --input results/Value_Specifications.owl \
      --input results/MeasurementData.owl \
      --input results/Datasets.owl \
      --input results/Processes.owl \
      --output results/phaleron-dpatho.owl

robot reason --reasoner ELK \
      --input results/phaleron-dpatho.owl \
      -D results/debug_phaleron-dpatho.owl

robot merge --input ../Phaleron-AppOntology/results/phaleron-app_ext_dep_core.owl \
      --input results/phaleron-dpatho.owl \
      --output results/phaleron-app_ext_dep_core.owl

