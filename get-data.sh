#!/usr/bin/env bash

# usage: ./get-data.sh PATH [AUTHOR ...]

base_dir=$1
results_file=data/results.csv
mkdir -p data

# prepare author filter list
authors=""
for author in "${@:2}"
do
    authors="$authors --author $author"
done

# create result csv file for each repo found
create_repo_result () {
    result_file="data/$(realpath $1 | sed -e 's/^\///g' -e 's/\/.git$//g' -e 's/\//-/g').csv"
    git -C $1 csvlog $2 > $result_file 2> /dev/null
    lines=$(cat $result_file | wc -l)
    echo " -> $result_file -> $(($lines - 1))"
}
export -f create_repo_result
find $base_dir -type d -name ".git" -print0 -exec bash -c 'create_repo_result "$0" "$1"' {} "$authors" \;

# prepare new results file with csv header
rm -f $results_file
header="\"repo\",$(cat $(find data -type f -name *.csv -print -quit) | head -n 1)"
echo $header > $results_file

# merge all repo csv files into results.csv
merge_repo_result () {
    repo_name=$(basename $1 | sed -e 's/\.csv//g')
    sed -e "s/^/\"$repo_name\",/" $1 | tail -n +2 >> $2
}
export -f merge_repo_result
find data -type f -name *.csv ! -name results.csv -exec bash -c 'merge_repo_result "$0" "$1"' {} $results_file \;

# output results filename and line count
echo
lines=$(cat $results_file | wc -l)
echo "$results_file -> $(($lines - 1))"
