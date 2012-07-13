# iterate over all the sql files in the current directory
for file in *.sql
do
	# load them all into ../census.db
<<<<<<< HEAD
	echo ".read $file" | sqlite3 ../census.db
=======
	sqlite3 -init $file ../census.db
>>>>>>> dfff79e704146c0f504e41787d6f3a94ea7fcbbb
done