# semgrep_ruleset_generator.sh
Exploring how the open source SAST scanner, Semgrep works. Created a bashscript which scans the yaml files within the semgrep-rules repo (by returntocorp) for a keyword and combines all yaml files which match into a ruleset.

# A work in progress...

# Currently
Got the ruleset generation running. A user can enter a search word and build a ruleset which tailors to that keyword. Then the user can take the ruleset file and run semgrep with the generated ruleset.

# Prep-work
1) Clone the repo: git clone https://github.com/returntocorp/semgrep-rules.git 
2) Change the value of the variable called "path" to the path on your machine to the semgrep-rules repo downloaded in step 1.
3) Install semgrep (if you don't have it installed) so you can try out your new ruleset.

# Usage:
\# Searches Rule files for A7; A7 correlates to OWASP Top 10 number 7: Cross Site Scripting vulnerability (XSS).
./search_semgrep_build_custom_ruleset.sh A7 

\# After running this script the ruleset.yaml file will be generated to run in the following command:</br>
python3 -m semgrep --config ruleset.yaml \<repo to be scanned\> \# this may vary depending on how semgrep was installed.
