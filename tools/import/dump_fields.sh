# iterate over all the directories in the current directory
for dir in `find . -maxdepth 1 -type d ! -name .`
do

	# what is the first dbf file in the directory?
	first_file=$(ls $dir/extracted/*.dbf | head -1)

	# what is the base name of that file? it's what dbf_dump uses as the table name
	file_name=$(echo "$first_file" | sed -re 's/\S+\/(\w+).dbf/\1/' )

	# what should the table be named? - based on the directory name, removes the leading ./ and lowercases it
	table=$(echo "$dir" | sed -re 's/\.\///' | tr '[:upper:]' '[:lower:]')

	# and finally dump the sql statement into something like place.sql, translating the table name on the way and appending a final ; to make sqlite happy
	dbf_dump --info --sql $first_file | sed -re 's/'"$file_name"'/'"$table"'/' | sed -re 's/^\)$/\);/' > $table.sql
	
	echo "Saved $table.sql"
done