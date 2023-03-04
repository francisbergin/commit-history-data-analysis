# commit-history-data-analysis

## About

This project contains scripts to aggregate and analyze git commit history. The `get-data.sh` script will scan a base directory for git repositories and will output their log in CSV format in the `data` directory. In the end, it will merge all results into the `data/results.csv` file. To analyze the resulting data, simply open Jupyter Notebook as indicated below and rerun the whole notebook.

An article with discussions related to this project can be found here: https://francisbergin.github.io/posts/commit-history-data-analysis/.

## Instructions

```shell
# put `git-csvlog` in a directory in your `$PATH`
ln -s git-csvlog ~/bin/

# run `get-data.sh` with the base directory and author list as a parameters
./get-data.sh ~/code/ "author 1" "author 2"

# run data analysis on data
python3 -m venv venv && . venv/bin/activate
pip install -r requirements.txt
jupyter notebook analyze_results.ipynb
```
