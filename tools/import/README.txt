These are quick and dirty bash scripts that you can use to get a copy of the Census data downloaded, extracted, parsed, and loaded into a SQLite database.

The following files are included, but you can easily expand upon them very quickly:
- ADDR
- ADDRFEAT
- COUNTY
- EDGES
- FACES
- FACESMIL
- MIL
- PLACE
- STATE

Make sure they are executable, move into the directory you want to download in, and kick them off one at a time:

First, download all the zip files:
$ ./tools/import/download.sh

The Census FTP server seems to limit individual downloads to about 450kb/s, so for better performance you should break these up and run multiples at a time... if you don't mind being a bit of an ass.

Since we just ran a wget --recursive, you'll have a full directory structure: ftp2.census.gov/geo/tiger/TIGER2011/. You can just use that as your base directory, or move everything down a couple of levels, whichever you like. Either way, you should be in the directory with the ADDR, ADDRFEAT, etc. directories next.

It's time to unzip all those files. You did remember to move into the TIGER2011 directory, right?
$ ~/census/tools/import/unzip.sh

This will extract all the individual zip files to an "extracted" directory under the parent, ie: ADDR/extracted, PLACE/extracted, etc.

There are going to be a ton of files in each of these directories now, but all we care about are the .dbf files - dBase-format database files that contain the tabular data we want.

We need to extract this data into a format we can easily parse. Originally CSV files were used (hence the remaining .csv extension), but they're actually pipe-separated now for two reasons. First, some of the values contain commas, making escaping an issue. Second, SQLite uses a pipe by default, so it's just easier to go with that.

This is the most intensive (and slowest) part of our process, extracting all this data. For this step you'll need to move into each individual */extracted/ directory and run the dbf_dump.sh script:
$ cd ADDR/extracted && ~/census/tools/import/dbf_dump.sh
$ cd PLACE/extracted && ~/census/tools/import/dbf_dump.sh

When you're done with all the directories, you should have a new one for each data set: ADDR/csv, PLACE/csv, etc.

Now we've got all the data pulled out into an easy-to-use format and it's time to load it into our database. First we need to parse out the schema definition to load each set into. Back in our main TIGER2011 directory:
$ ~/census/tools/import/dump_fields.sh

This script uses the dbf_dump utility again to parse out the field definitions from the first *.dbf file in each of the main ADDR, PLACE, etc. directories and writes a SQL script to an identially named file: addr.sql, place.sql, etc.

Now we'll create a new SQLite database (or, really, use one that already exists, it doesn't matter as long as there aren't already tables with the same names) and create our tables:
$ ~/census/tools/import/create_schema.sh

This takes each of the *.sql files we just generated and executes them against a new SQLite database. Once it's done, there should be a new ../census.db file that contains the empty tables.

Now the final potentially long-running step, loading the parsed data into the database. Before you run this step, edit `tools/import/pragma.sql`, as it's currently set to use 7GB of RAM during the load process. If you don't have 7GB free, this would be very very bad.
$ ~/census/tools/import/import_csv.sh

When all is said and done, your census.db file should be about 16GB and contain all the data, ready to query.

For the 2011 sets included in the download.sh script, the table totals should be somewhere in the neighborhood of:
- ADDR: 40,328,295 rows
- ADDRFEAT: 28,617,010 rows
- COUNTY: 3,234 rows
- EDGES: 72,584,376 rows
- FACES: 21,804,065 rows
- FACESMIL: 1,352,126 rows
- MIL: 722 rows
- PLACE: 29,796 rows
- STATE: 56 rows

You can now play around in your database with a simple `sqlite3 census.db` call.
