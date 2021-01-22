documentation() {
echo '\n#######################################'
echo 'DOCUMENTATION'
echo '#######################################'


echo '\n\n#####################################################'
echo '# USAGE:' 
echo '         ./build_ruleset.sh<repo-path> <search-term>'
echo '#####################################################'
echo '\n# [ Options ]'
echo '# -o <output-filename>    -- choose filename for output; output is a ruleset";'
echo '# -p <repo-path>      -- need path to semgrep rules repo";'
echo '# -s <search-term>    -- need word to search through matching rules";'


echo '\n\n#####################'
echo '# Functional Controls'
echo 't1=1 # triggers usage function if required cmdlne argument is not passed.'
echo 't2=1 # trigger for requirement 2'


echo '#\n\n_____________________'
echo '# Commands Cheat Sheet #'
echo '#----------------------------------------------------------------------------------'
echo '# ${entire_array/dictionary[*]}       # output all values assigned to an array'
echo '# ${#files[@]}                        # output size of an array'
echo '# ${!get_all_dict_keys[*]}            # output all keys for dictionary'
echo '#----------------------------------------------------------------------------------\nThank you\n'

}
