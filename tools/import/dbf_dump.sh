for file in *.dbf
do
	echo $file
	dbf_dump --fs=\| $file > $file.csv
done