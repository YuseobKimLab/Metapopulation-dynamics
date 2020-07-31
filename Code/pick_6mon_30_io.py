import random
import sys

filehead = sys.argv[1]
startRepl = int(sys.argv[2])
endRepl = int(sys.argv[3])

segments = [filehead + "_" + str(j) + '_' + str(i) for j in range(startRepl, endRepl) for i in range(1, 51)]
beginy = 1
for segment in segments:
	inf= open(segment + '.fasta', "r")
	outf = open(segment + "_pick.fasta", "w")
	years = [[] for i in range(20)]
	for line in inf:
		if line.find("*") >= 0 or line.find("+") >= 0:
			continue
		if line.find(">") >= 0:
			ymd = line.split(" ")[2].split("/")
			year= int(ymd[0])
			monIdx = int(ymd[1])/7
			virus = line
		else:
			virus += line
			years[(year-beginy)*2 + monIdx].append((year, virus))
	
	for y in range(len(years)):
		numsamp = 10
		samps = random.sample(years[y], numsamp)
		count = 0
		for samp in samps:
			count += 1
			seq = samp[1].split("\n")[1] + "\n"
			head = ">" + str(samp[1].split(" ")[4]) + "_" + str(samp[1].split(" ")[3]) + "\n"
			outf.write(head+seq)
	outf.close()
	inf.close()
