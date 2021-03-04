#!/bin/bash
# install
bash binder/postBuild

# exclude notebooks
rm -rf ./old_notebooks

# execute notebook to generate dataset first
i=0;
cd datasets
papermill ImportDatabase.ipynb ImportDatabase-out.ipynb -k "python3" || i=$((i+1));
cd ../

# execute notebooks
current_dir=$(pwd)
for f in $(find . -name *.ipynb | sort -n); do
    cd $(dirname $f);
    notebook=$(basename $f);
    papermill ${notebook} ${notebook%.*}-out.${notebook##*.} -k "python3" || i=$((i+1));
    cd $current_dir;
done;

# push error to next level
if [ $i -gt 0 ]; then
    exit 1;
fi;
