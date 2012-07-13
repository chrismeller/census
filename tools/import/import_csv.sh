# determine the path to our pragma.sql file
DIR=$(dirname "$(readlink -f "$0")")
PRAGMA="$DIR/pragma.sql"

for dir in `find . -maxdepth 1 -type d ! -name .`
do
	
	# what table should this be dumped into?
	table=$(echo "$dir" | sed -re 's/\.\///' | tr '[:upper:]' '[:lower:]')

	for file in `find $dir -type f -name *.csv`
	do
		echo "Importing $file into $table..."
		# load the file into ../census.db
		echo ".import $file $table" | sqlite3 -init $PRAGMA ../census.db
	done
done
