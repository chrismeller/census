# iterate over all the sql files in the current directory
for file in *.sql
do
	# load them all into ../census.db
	echo ".read $file" | sqlite3 foo.db
done