# iterate over all the sql files in the current directory
for file in *.sql
do
	# load them all into ../census.db
	sqlite3 -init $file ../census.db
done