# Project 4: Python

First download and install python if you do not already have in on your
machine. You can download it from
[http://www.python.org/download/](http://www.python.org/download/).
Download version 2.7.6. If you already have python, type the command
“python --version” (that is a space followed by two minus signs followed
by version) to a command window to check the version you have. Any
version from 2.5 – 2.7.6 should be ok. You can also use version 3.x, but
if you do, put a large, visible comment at the head of the pages.py file
you turn in saying exactly which version you have used.

Documentation can be found at
[http://docs.python.org](http://docs.python.org/) . Read the tutorial
and skim documentation on the modules subprocess and re.

Next, download the attached file project4.zip, and unzip it to create a
folder named project4.

Finally, download and install the R system.
 [http://www.r-project.org/](http://www.r-project.org/) is the R home
page, download
from [http://lib.stat.cmu.edu/R/CRAN/](http://lib.stat.cmu.edu/R/CRAN/)
. R is a system for analyzing and visualizing data. We will use a tiny
fraction of its abilities: the ability to produce a histogram. We will
use it as a black box; you should not need to learn anything about R to
do this project.

This project is an example of using Python to tie together existing
programs. In particular, we imagine that we have printing software which
generates a log file each day, describing the printing jobs done that
day. Each print job outputs a line in the log file giving the use name
and pages printed for that job. You are to write a python program which
reads a log file, figures out the total number of pages printed for each
user, and calls on the R system to produce a pdf file containing a
histogram of this data.

## Details

Each print job on the printer causes a line like the following to appear
in the log file:

180.186.109.129 user: luis printer: core 2 pages: 32 code: k n h

The significant parts of this are user: luis and pages: 32. You can
assume that each print job produces a line that includes the string
“user:\<spaces\>\<name\>” and the string “pages:\<spaces\>\<number\>”
where \<spaces\> is one or more spaces, \<name\> is a string of lower
case letters, and \<number\> is a string of digits indicating how many
pages the user printed for this print job. There may be other lines in
the file as well, but they will not include the string “user:”, and they
should be ignored.

The folder project4 includes 2 example log files: log and logsmall.

You are to write your program in the file pages.py, which you can find
in the project3 folder. The file already has one finished function in
it, runR. If you call runR( ) from python, it will start up R and cause
R to read commands from the file commands.R. After it finishes these
commands, R will exit and runR will return.

Pages.py also has the header for the function log2hist(logfilename).
This function should read a log file, whose name is the value of
logfilename. It should produce a file named data with one line for each
user containing the total pages printed for that user. (The file
data.example in folder project4 is an example showing the format that
data should have.) Finally, log2hist should call runR, which will cause
R to produce the file pageshist.pdf with the histogram.

Note that this is due at **2 AM,****Thusday********morning** **Dec.
1****2**. (I.e. it is due very late Wednesday night.)Turn in your edited
pages.py as an attachment to this assignment.
