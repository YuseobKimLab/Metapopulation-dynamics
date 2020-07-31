import string
import sys
import datetime
from datetime import timedelta

startdate = datetime.date(1, 1, 1)

filehead = sys.argv[1]
startRepl = int(sys.argv[2])
endRepl = int(sys.argv[3])
for filenum in range(startRepl, endRepl):
	length = 0
	nTry = 0
	DinY = 0
	DinM = 0
	numSeason = 0
	nDeme = 0
	infname = filehead+"_"+str(filenum)
	inf = open(infname+".out", "r")

	for line in inf:
		if line.find("nNonsy") >= 0:
			nNonsy = line.split(' ')[2].split('\n')[0]
			length += int(nNonsy)
		if line.find("nSynon") >= 0:
			nSynon = line.split(' ')[2].split('\n')[0]
			length += int(nSynon)
		if line.find("Ndeme") >=0 :
			nDeme = int(line.split(' ')[2].split('\n')[0])
		if line.find("DinY") >= 0:
			DinY = int(line.split(' ')[2].split('\n')[0])
			DinM = DinY/12
		if line.find("Tsample") >= 0:
			numSeason = int(line.split(' ')[2].split('\n')[0])/DinY
		if line.find("SamInt") >= 0:
			SamInt = int(line.split(' ')[2].split('\n')[0])
		if line.find("Ntry") >= 0:
			nTry = int(line.split(' ')[2].split('\n')[0])
		if line.find("seed") >= 0:
			break

	print "length: " + str(length)
	print "nTry: " + str(nTry)
	print "DinY: " + str(DinY) + ", DinM: " + str(DinM)
	print "numSeason: " + str(numSeason)
	print "nDeme: " + str(nDeme)

	quit = 0
	for t in range(0,51):
		prevmonth = 1
		count = 0
		foundTry = 0
		outfname = infname+"_" + str(t) + ".fasta"
		outf = open(outfname, "w")
		for line in inf:
			if line.find("Try"+str(t)) >= 0:
				prevSeason = 1
				foundTry = 1
				outf.write("+\n")
			if line.find("*") >=0 :
				break
			if line.find("g") >=0 and foundTry == 1:
				count += 1
				each = line.split(' ')
				generation = int(each[0].split('g')[1])
				
				yeardelta = generation/DinY
				daydelta = (generation%DinY)*365.0/DinY
				daysdelta = 365*yeardelta + daydelta
				today = startdate + timedelta(days = daysdelta)
				pyear = today.year
				pmonth = today.month
				pday = today.day
				pdate = str(pyear) + "/" + str(pmonth) + "/" + str(pday)

				if prevmonth >= 11 and pmonth <= 2:
					outf.write("*\n+\n")
				deme = each[1].split('d')[1]
				string1 = ">seq" + "-" + str(count) + " " + each[0]+"/"+each[1] + " " + \
					pdate + " " + each[1] + " " + str(daysdelta) + " " + " \n"
				outf.write(string1) 
				string2 = ''.join(each[5:])
				string2 = string2.replace("0", "A")
				string2 = string2.replace("1", "C")
				outf.write(string2)
				
				prevmonth = pmonth
				
		outf.write("*\n")
		outf.close()		
				
