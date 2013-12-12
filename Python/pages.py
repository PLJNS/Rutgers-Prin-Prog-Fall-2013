#!/usr/bin/python

import re
import subprocess

# Calls the R system specifying that commands come from file commands.R
# The commands.R provided with this assignment will read the file named
# data and will output a histogram of that data to the file pageshist,pdf
def runR( ):
    res = subprocess.call(['R', '-f', 'commands.R'])

# log2hist analyzes a log file to calculate the total number of pages
# printed by each user during the period represented by this log file,
# and uses R to produce a pdf file pageshist.pdf showing a histogram
# of these totals.  logfilename is a string which is the name of the
# log file to analyze.
#
def log2hist(logfilename):

	logFile = open(logfilename)

	users = {}

	for printJobString in logFile:

		userRegex = re.search('(\suser:\s)(.+?)(\sprinter:\s)', printJobString)

		if userRegex:
			userString = userRegex.group(2)
			pagesInt = int(re.search('(\spages:\s)(.+?)(\scode:\s)', printJobString).group(2))

			if userString not in users:
				users[userString] = pagesInt
			else:
				users[userString] += pagesInt


	data = open('data', 'w+')

	for pagesInt in users.values():
		data.write("%d\n" % pagesInt)

	data.close()

	runR()
		
    
log2hist("log")