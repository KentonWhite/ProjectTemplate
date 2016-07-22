---
layout: page
---
Before you work through this walkthrough, you should make sure you've read (or at least understood) the contents of the [beginner's tutorial](./getting_started.html).

#### Ad Hoc File Types
In the [beginner's tutorial](./getting_started.html), we showed how ProjectTemplate automatically loads data files from the `data` and `cache` directories. If you're working with plain text files or any of the [supported binary file formats](./file_formats.html), this automatic data loading should work out of the box without any effort on your part. But if you have to retrieve data sets from more complex data sources, ProjectTemplate has advanced features that will let you set up ad hoc autoloading. In the rest of this document, we'll talk about working with SQL databases, remote resources available over HTTP and FTP, large data files stored on external drives and R files that contain code that generates data at runtime.

##### SQLite Databases
Let's start by working with a SQLite database. We'll use a database from the Analytics X competition in which contestants were trying to predict crimes that took place in Philadelphia. You can download the database file [here](./philapd.db.zip). To save on bandwidth, we've compressed the database, so you should uncompress it before going through the rest of this tutorial.

###### Autoloading the Database
The simplest way to access the database is to store the `philapd.db` file in the `data` directory of a new project. Let's set up a project using the standard ProjectTemplate invocation:

        library('ProjectTemplate')
        create.project('PhilaPD')

Then we'll shift into the relevant directory, move our database over and uncompress it:

        cd PhilaPD
        mv ~/Downloads/philapd.db.zip data
        unzip data/philapd.db.zip -d data
        rm data/philapd.db.zip 
    
Then we reload R and load the project. You'll see ProjectTemplate automatically load the two tables found in our SQLite database:

        library('ProjectTemplate')
        load.project()
        
![Autoloading](./mastering1.png)

For most users, this automatic loading procedure is probably enough. But if you need more fine-grained control, you can use the `.sql` ad hoc file type to load specific tables from a SQLite database. You can also specify an exact SQL query to run against the database. We'll go through all three cases below.

###### Load One Specific Table

First, let's move the `philapd.db` file out of the `data` directory to prevent it from being autoloaded:

        mv data/philapd.db .

After that, we'll create an `.sql` file in the `data` directory. We'll use a file called `data/philapd.sql`. Inside of this file, we need to specify (a) that we're working with a SQLite database, (b) the path to the SQLite database and (c) the specific table we want to load. We've done that below:

        type: sqlite
        dbname: philapd.db
        table: location_info

After creating the `data/philapd.sql` file, we can rerun `load.project`, which will load only the `location_info` table from our database into the variable `philapd`:

![Autoloading](./mastering2.png)

###### Load All Tables from a Specific Database
If we want to load all of the tables from a database file that we can't place inside of the `data` directory, we can use a `.sql` file to do this by replacing the name of a specific table with an asterisk:

        type: sqlite
        dbname: philapd.db
        table: *

![Autoloading](./mastering3.png)

###### Loading Data with an SQL Query
You can also load a subset of your data by specifying an SQL query instead of a table in your `.sql` file:

        type: sqlite
        dbname: philapd.db
        query: SELECT * FROM location_info WHERE zip = '19144'

![Autoloading](./mastering4.png)

##### MySQL, PostGres or ODBC Databases
Working with a MySQL, PostGres or ODBC database is exactly as easy as using a `.sql` file to access a SQLite database. All that changes is the use of the `mysql`, `postgres` or `odbc` types instead of the `sqlite` type:

        type: mysql
        user: sample_user
        password: sample_password
        host: localhost
        dbname: philapd
        table: location_info

        type: postgres
        user: sample_user
        password: sample_password
        host: localhost
        dbname: philapd
        table: location_info

        type: odbc
        user: sample_user
        password: sample_password
        host: localhost
        dbname: philapd
        table: location_info

##### URL Files
If you need to access a file that's available over HTTP or FTP, you can use a `.url` file. Inside of the file, you'll specify the URL where your data set is available and the type of data set you're accessing. Here, we'll use a `data/sample.url` file to load the standard ProjectTemplate sample data set over HTTP:

        url: http://www.johnmyleswhite.com/ProjectTemplate/sample_data.csv
        separator: ,

![Autoloading](./mastering5.png)

##### .file Files
If you need to access a file that's stored outside of the project's main directory, you use a `.file` file. Inside of the file, you'll specify the path of the data file and the extension of the data set you're accessing:

        path: /usr/share/dict/words
        extension: csv

![Autoloading](./mastering6.png)

##### R Files
Sometimes you want to generate random data for your analysis: this, after all, is the heart of Monte Carlo analyses of statistical methods. You can do this by inserting R code into a file in the `data` directory. We'll put this into the `data/d.R` file:

        set.seed(1)
        d <- rnorm(1000, 0, 1)

![Autoloading](./mastering7.png)

##### Media Files: MP3's and PPM's
Sometimes you want to work with more interesting sorts of data than a typical text file. ProjectTemplate now has basic support for loading media files into R. To load an MP3 audio file into an R object for analysis, simply place the `.mp3` file in the `data` directory. The `tuneR` package will be automatically loaded by ProjectTemplate and the MP3 file will be read into an R object in the global environment. Similarly, if you want to load a PPM image file, just place the `.ppm` file into the `data` directory. ProjectTemplate will then use the `pixmap` package to load the image file into an R object in the global environment.

#### Unit Testing Your Project
ProjectTemplate has been designed to make it easier to unit test the functions you've written for your analysis. To get started, you can call `stub.tests()`, which will generate a file at `tests/autogenerated.R` filled with sample tests for every one of the functions you defined inside of the `lib` directory. You should edit these tests, as they are expected to fail by default.

After editing your tests, you can call `test.project()` to run all of the unit tests in the `tests` directory.

![Unit Tests](./unit_tests.png)

#### Logging Your Work
If you want to log your work, ProjectTemplate will automatically load a [log4r](https://github.com/johnmyleswhite/log4r) logger object into the `logger` variable that will write to a plain text stored at the `logs/project.log`. To use this logger, you only need to change the configuration file to specify:

        logging: TRUE

After making this change, the `logger` object will be created once you call `load.project()`:

![Logging](./logging.png)

#### Data Tables
The `data.table` package allows you to create a variant of the typical R data frame that provides indices. Indices make locating and selecting subsets of your data much faster than the typical vector scan that R uses when working with data frames. To automatically convert all of the data frames loaded from the `data` directory into `data.table`s, change the configuration option in `config/global.dcf` to `data_tables: on`. After that, you can check for tables by calling the `tables()` function.
