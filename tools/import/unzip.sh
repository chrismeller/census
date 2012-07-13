for dir in `find . -maxdepth 1 -type d ! -name .`
do

	unzip $dir/\*.zip -d $dir/extracted/

done
