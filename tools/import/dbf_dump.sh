for file in *.dbf
do
	echo $file
	mkdir -p ../csv/
	dbf_dump --fs=\| $file > ../csv/$file.csv
done