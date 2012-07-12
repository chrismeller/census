# iterate over all the directories in the current directory
for dir in `find . -maxdepth 1 -type d ! -name .`
do
	# dump the fields from the first dbf file in their extracted directory into a fields.txt file
	dbf_dump --info $(ls $dir/extracted/*.dbf | head -1) > $dir/fields.txt
	
	echo "Saved $dir/fields.txt"	
done