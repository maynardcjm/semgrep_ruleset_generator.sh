

path="/home/nar/semgrep/rulesets/";
scan_list=("DVWA" "WebGoat");

# Hardcoded - Note: can write autofill code by reading in the ruleset directory
ruleset_list=("r2c-ci.yaml" "r2c-security-audit.yaml" "A7-ruleset.yaml");


for scan in ${scan_list[@]};
do
	echo "Scan List: $scan";

	for ruleset in ${ruleset_list[@]};
	do
		echo "Running Ruleset: $ruleset";
	done
done


echo "End of Script...exiting";
