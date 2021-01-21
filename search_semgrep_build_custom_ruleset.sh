#!/bin/bash
#fName:
# Author: Collin Maynard
# Date: 1/20/21

# Description This program generates a ruleset for semgrep based on a specific search criteria

tmp_setUP() {
    # Set up: empty files before each run
    echo -n "" > semgrep_message.txt; 
    echo -n "" > semgrep_owasp.txt; 
    echo -n "" > semgrep_languages.txt;
    echo -n "" > semgrep_$1.txt; # added
}

tmp_setUP $1; # edit 

cmd_line() {
	total_args=$1;
	# Check Command line Args
	if [[ total_args -lt 1 ]];
	then 
		echo "usage: $0 \<search term\>";
		exit;
	fi
}

cmd_line $#;

# get all rule files in semgrep-rule repo
path=/home/nar/git/semgrep-rules/; # path to git repo

# Create file containing all .yaml files from semgrep-rules repo
find $path | grep .yaml$ > semgrep_rules.txt;
rules_file=semgrep_rules.txt;

search_rules() {
	while read LINE;
	do 
		if [[ -n $(cat $LINE | grep $1:) ]];
		then
			echo $LINE >> semgrep_$1.txt;
		fi
	done < $2
}

search_words=('message' 'owasp' 'languages');

for i in ${search_words[@]};
do 
	search_rules $i $rules_file;
done

# File Check
tmp_fcheck() {
	echo "message count: $(cat semgrep_message.txt | wc)"
	echo "language count: $(cat semgrep_languages.txt | wc)";
	echo "owasp count: $(cat semgrep_owasp.txt | wc)";
}
tmp_fcheck;

cnt=0;
for i in ${search_words[@]};
do
	echo "iteration $cnt: $i";
	#search_rules $1 "semgrep_$1${i[1]}.txt";

	search_rules $1 "semgrep_$i.txt";
	let cnt=$cnt+1;

done

# Temporary output
echo -n "Before:"
cat semgrep_$1.txt |wc;
echo -n "Sorted and Unique: "
cat semgrep_$1.txt | sort | uniq |wc;
echo "$(cat semgrep_$1.txt |sort| uniq)" > semgrep_$1.txt;

echo -n "After: ";
cat semgrep_$1.txt |wc;

if [[ -z $(cat semgrep_$1.txt) ]];
then
    echo -e "NO SEARCH RESULTS WERE FOUND\nSystem exiting";
	exit;
fi

echo "rules:" > ruleset.yaml;
while read FILE;
do

	var1=$(cat $FILE | sed -n '/^  - id/='); 
    
    # Check for Errors in Each File
    if [[ -n $var1 ]];
    then
        echo "$FILE"; # prints file path
        echo "error in yaml file: line $var1";


		echo "attempting fix";
		let var2=$var1-1;

		#until=$(cat $FILE | sed -n "1,$var2 p");
		#until=$(cat $FILE |tail -n+2 | sed -n "1,$var2 p");
        after=$(cat $FILE | sed -n "$var1~1 s/^  //p");
		
        #echo $FILE;
		#echo -e "$until\n$after" >> ruleset.yaml;
		echo -e "$after" >> ruleset.yaml;
		

    else
	    # original
	    #cat $FILE | tail -n +2 >> ruleset.txt;

	    # experimental (trying to fix yaml file) - has small spacing issue with config file.
	    echo "$(cat $FILE | tail -n+2)" >> ruleset.yaml; 

	    # experimental 2
	    #echo "$(cat $FILE)" >> ruleset.yaml; 
	fi
done < semgrep_$1.txt

#################
exit; # EXIT CODE
#################

# try to remove spacing errors in yaml file
while read LINE;
do
	# something
	echo -e $LINE;

done < ruleset.yaml;


#cat ruleset.yaml;
#cat ruleset.yaml | wc;
