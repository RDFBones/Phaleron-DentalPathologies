#! /bin/bash

build=0
cleanup=0
dependencies=0
full=0
update=0

function usage {
    
    echo " "
    echo "usage: $0 [-b][-c][-d][-f][-u]"
    echo " "
    echo "    -b          just build Phaleron-DentalPathology ontology extension"
    echo "    -c          cleanup temporary output files"
    echo "    -d          add dependencies (i.e. required ontology extensions) to output file"
    echo "    -f          build Phaleron-Dentalpathology ontology extension and include both dependencies and the RDFBones core ontology"
    echo "    -u          initiate and update submodules if they are not up to date"
    echo "    -h -?       print this help"
    echo " "

    exit

}



while getopts "bcdfuh?" opt; do

    case "$opt" in

	b)
	    build=1
	    ;;

	c)
	    cleanup=1
	    ;;

	d)
	    dependencies=1
	    ;;

	f)
	    full=1
	    ;;

	u)
	    update=1
	    ;;

	?)
	    usage
	    ;;
	
	h)
	    usage
	    ;;

    esac

done


## SUBMODULES
#############

## Check if submodules are initialised

if [ $update -eq 1 ];then

    git submodule init
    git submodule update
    
fi

## BUILD DEPENDENCIES
#####################

if [ $build -eq 1 ] || [ $full -eq 1 ];then

    ## Clear 'results' Repository

    rm -r results/*

    ## Build RDFBones Core Ontology

    cd RDFBones-O/robot
    ./Script-Build_RDFBones-Robot.sh
    cd ../..

    ## Build Standards-Pathologies Ontology Extension

    cd Standards-Pathologies
    ./Script_StandardsPatho-Robot.sh -b -u
    cd ..

    ## Build Standards-Dental1 Ontology Extension

    cd Standards-Dental1
    ./Script_StandardsDental1-Robot.sh -b -u
    cd ..

    ## Build Phaleron-Pathologies Ontology Extension

    cd Phaleron-Pathologies
    ./Script_PhaleronPatho-Robot.sh -b -u
    cd ..

    ## Build BABAO Ontology Extension

    cd BABAO
    ./Script_BABAO-Robot.sh -b -u
    cd ..

    ## Build DentalPathology Ontology Extension

    cd DentalPathology
    ./Script_DentPath-Robot.sh -b -u
    cd ..

    ## Merge Dependencies

    robot merge --input Standards-Pathologies/results/standards-patho.owl \
	  --input Standards-Dental1/results/standards-dental1.owl \
	  --input Phaleron-Pathologies/results/phaleron-patho.owl \
	  --input BABAO/results/babao.owl \
	  --input DentalPathology/results/dentpath.owl \
	  --output results/dependencies.owl

    ## Merge Dependencies With Core Ontology

    robot merge --input RDFBones-O/robot/results/rdfbones.owl \
	  --input results/dependencies.owl \
	  --output results/core_dependencies.owl

    
    ## BUILD ONTOLOGY EXTENSION
    ###########################

    ## CATEGORY LABELS

    robot template --template Template_PhaleronDpatho-CategoryLabels.tsv \
	  --input results/core_dependencies.owl \
	  --prefix "phaleron-dpatho: http://w3id.org/rdfbones/ext/phaleron-dpatho/" \
	  --prefix "obo: http://purl.obolibrary.org/obo/" \
	  --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
	  --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-dpatho/latest/phaleron-dpatho.owl" \
	  --output results/CategoryLabels.owl

    ## VALUE SPECIFICATIONS

    ## Merge Input

    robot merge --input results/CategoryLabels.owl \
	  --input results/core_dependencies.owl \
	  --output results/merged_CategoryLabels.owl

    ## Build Value Specifications
    
    robot template --merge-before --template Template_PhaleronDpatho-ValueSpecifications.tsv \
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
	  --output results/ValueSpecifications.owl

    ## MEASUREMENT DATA

    ## Merge Input

    robot merge --input results/ValueSpecifications.owl \
	  --input results/merged_CategoryLabels.owl \
	  --output results/merged_ValueSpecifications.owl

    ## Build Measurement Data

    robot template --merge-before --template Template_PhaleronDpatho-MeasurementData.tsv \
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

    ## DATASETS

    ## Merge Input

    robot merge --input results/MeasurementData.owl \
	  --input results/merged_ValueSpecifications.owl \
	  --output results/merged_MeasurementData.owl

    ## Build Dataets

    robot template --merge-before --template Template_PhaleronDpatho-Datasets.tsv \
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

    robot merge --input results/Datasets.owl \
	  --input results/merged_MeasurementData.owl \
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

fi


## PREPARE OUTPUT
#################

## CREATE EXTENSION

if [ $build -eq 1 ] || [ $full -eq 1 ];then

    robot merge --input results/CategoryLabels.owl \
	  --input results/ValueSpecifications.owl \
	  --input results/MeasurementData.owl \
	  --input results/Datasets.owl \
	  --input results/Processes.owl \
	  --output results/phaleron-dpatho.owl

    ## Check Output

    robot reason --reasoner ELK \
	  --input results/phaleron-dpatho.owl \
	  -D results/debug_phaleron-dpatho.owl

    ## Annotate Output

    robot annotate --input results/phaleron-dpatho.owl \
      --remove-annotations \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-dpatho/latest/phaleron-dpatho.owl" \
      --version-iri "http://w3id.org/rdfbones/ext/phaleron-dpatho/v0-1/phaleron-dpatho.owl" \
      --annotation dc:creator "Felix Engel" \
      --annotation dc:creator "Stefan Schlager" \
      --annotation owl:versionInfo "0.1" \
      --language-annotation dc:description "This RDFBones extension implements the dental pathology coding routine developed and used by the Phaleron Bioarchaeological Project." en \
      --language-annotation dc:title "Dental Pathologies" en \
      --language-annotation rdfs:label "Phaleron dental pathologies" en \
      --language-annotation rdfs:comment "The RDFBones core ontology, version 0.2 or later, needs to be loaded into the same information system for this ontology extension to work. Also required are the following ontology extensions: Dental Pathologies (version 0.1), BABAO (version 0.1), Phaleron-Pathologies (version 0.1), Standards-Dental1 (version 0.1) and Standards-Pathologies (version 0.1)." en \
      --output results/phaleron-dpatho.owl

    if [ $cleanup -eq 1 ];then

	## Remove Unneeded Files

	rm results/CategoryLabels.owl
	rm results/ValueSpecifications.owl
	rm results/MeasurementData.owl
	rm results/Datasets.owl
	rm results/Processes.owl
	rm results/core_dependencies.owl
	rm results/merged_CategoryLabels.owl
	rm results/merged_Datasets.owl
	rm results/merged_MeasurementData.owl
	rm results/merged_ValueSpecifications.owl
	

    fi
    
    
fi

if [ $dependencies -eq 1 ] || [ $full -eq 1 ];then

    ## Merge Extension With Dependencies

    robot merge --input results/phaleron-dpatho.owl \
	  --input results/dependencies.owl \
	  --output phaleron-dpatho_ext_dep.owl

    if [ $cleanup -eq 1 ];then

	## Remove Unneeded Files

	rm results/phaleron-dpatho.owl
	rm results/dependencies.owl

    fi

else

    if [ $cleanup -eq 1 ];then

	## Remove Unneeded Files

	rm results/dependencies.owl

    fi

fi

if [ $full -eq 1 ];then

    ## Merge Extension and Dependencies with Core Ontology

    robot merge --input results/phaleron-dpatho_ext_dep.owl \
	  --input RDFBones-O/robot/results/rdfbones.owl \
	  --output phaleron-dpatho_ext_dep_core.owl

    if [ $cleanup -eq 1 ];then

	## Remove Unneeded Files

	rm results/phaleron-dpatho_ext_dep.owl

    fi

fi





