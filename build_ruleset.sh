#!/bin/bash
#fName:
# Author: Collin Maynard
# Date: 1/20/21

# Description This program generates a ruleset for semgrep based on a specific search criteria

##################
# Main Settings  #
debug_mode=1;        # Run program in debug mode --> outputs extra input to check validity
default_settings=1;  # Run program with default settings 
clean=1;              # clean program output files before running 

# Search Alg Settings
declare -A search_settings;
search_settings[case_sensitivity]=0; # Activates grep -i functionality of Search Alg
search_settings[enter_regX]=0  # Allows Search Alg to accept regex as input functionality
search_settings[enter_grepCmd]=0  # Allows Search Alg to accept a full grep command as an arg

# I/O File Names
declare -a file_names;
file_names=("rules_file.txt" "matching_rules.txt" "ruleset.yaml"); # helpful for cleaning files

# Output Debugging INfo
echo "search_settings[*] = ${search_setting[*]}";

#####################
# Functional Controls
t1=1 # triggers usage function if required cmdlne argument is not passed.
t2=1 # trigger for requirement 2


###########################
# Command Line Processing
while getopts ":o:p:s:" arg; do
  case $arg in
    o) ruleset_fname=$OPTARG;; 
    p) path=$OPTARG;echo "check requirement path"; t2=0;;
    s) search_term=$OPTARG; echo "check requirement search term"; t1=0;;
  esac
done

#################
# CONFIGURATION
# Output Args For Debugging Mode
if [[ $debug_mode -eq 1 ]];
then
	# Print Command Line Arguments
	echo -e "\nUser Input: $ruleset_fname  $path   $search_term\n";
fi

# For Activating Default Settings 
if [[ $default_settings -eq 1 ]];
then
	# get all rule files in semgrep-rule repo
	path=/home/nar/git/semgrep-rules/; # path to git repo
fi


###############################
# For Triggering Usage Dialogue
usage() {
	total_args=$1;
	# Check Command line Args
	if [[ total_args -lt 1 ]];
	then 
		echo "usage: $0 \<search term\> \<outfile -- ruleset\>";
        echo "-o \<output file name\>    -- choose filename for output; output is a ruleset";
		echo "-p \<local-path-to-semgrep-rules-repo\>    -- need path to semgrep rules repo";
		echo "-s \<search-term\>    -- need word to search through matching rules";
		exit;
	fi
}

#########################################
# For Triggering the Usage Functionality
if [ $t1 -eq 1 ] || [ $t2 -eq 1 ];
then
	# Trigger Usage
	usage;
fi

# Rewrites a file with nothing
wipe_files() { 
	for i in ${file_names[@]}; 
	do 
		echo -n "" > $i;
	done 
} # expects filename

# Option - clean files
if [[ clean -eq 1 ]];
then
    echo "cleaning program files";
	wipe_files ${file_names[@]};
fi

# Search 1
################################################################
# Search Through Rules Repo to extract paths to yaml-files == rule-files
# Create file containing all .yaml files from semgrep-rules repo
echo "Generating Rules File";
find $path | grep .yaml$ > rules_file.txt;


############################
# FUNCTION: Search Algorithm
search_rules() { # expects a input file and a search term. 
	
	#********************************
    # - Insert Case Statement       *
	# - Expand Search Algorithm     *
    # - Options and Capabilities    *
	#********************************

	# Case to enter a custom grep command
    # Case to enter a regX
	# Case to disregard casing

	# Basic Case: Grep for term in file 
	while read LINE;
	do 
		if [[ -n $(cat $LINE | grep $1) ]];
		then
			echo $LINE >> matching_rules.txt;
		fi
	done < $2
}

########################################
# ERROR HANDLING 1: Improper Yaml Syntax	
# Case: Double spacing before "- id" 
# Example: 
#rules: 
#  - id # Note this should not have spaces in front
# OUTPUT DEBUGGING INFO
error_handling_1() { # expects var1 as input
    echo "File path: $FILE"; # prints file path
	echo "\nerror in yaml file: line $var1\nAttempting fix\n";
	#let var2=$var1-1; # WHAT IS VAR2 DOING? Old purpose???

	last_line=$(cat $FILE| wc -l);
	echo "Last Line: $last_line";
	
	# NOTE: HAD TO ADD FIX HERE DUE TO MAC OS NOT PROCESSING THE ~ TILDE ~

	# APPY FIX
	fix=$(cat $FILE | sed -n "$var1~1 s/^  //p");
	echo -e "$fix" >> ruleset.yaml;

}

# Perform Search Algorithm To create a file with a list of paths to the rules/yaml files 
search_rules $search_term rules_file.txt;

################# ###  ###
# Builds Ruleset  ##  ##
# Parses ruleset together
echo "rules:" > ruleset.yaml;
while read FILE;
do
	var1=$(cat $FILE | sed -n '/^  - id/='); 
	
	#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Error Check 1 : Improper Syntax for Yaml file
	if [[ -n $var1 ]];
    then
		error_handling_1 $var1;
    else
        # Write Rule file (minus first line) to ruleset file
	    echo "$(cat $FILE | tail -n+2)" >> ruleset.yaml; 
	fi
done < matching_rules.txt

cp ruleset.yaml /home/nar/semgrep/rulesets/$search_term-ruleset.yaml;
exit; # EXIT CODE
