import random
import sys

filehead = sys.argv[1]
startRepl = int(sys.argv[2])
endRepl = int(sys.argv[3])
seg1Len = 1700
seg2Len = 1700
segments = [filehead + '_' + str(j) + '_' + str(i)+"_pick" for j in range(startRepl, endRepl) for i in range(1, 51)]
beginy = 1
for segment in segments:
	inf= open(segment + '.fasta', "r")
	outf1 = open("seg1_"+segment + "_test1.fas", "w")
	outf2 = open("seg2_"+segment + ".fasta", "w")
	count = 0
	for line in inf:
		if line.find("*") >= 0 or line.find("+") >= 0:
			continue
		if line.find(">") >= 0:
			count += 1
			outf1.write(line.split("\n")[0]+"\n")
			outf2.write(line.split("\n")[0]+"\n")

		else:
			outf1.write(line.split("\n")[0][0:seg1Len] + '\n')
			outf2.write(line.split("\n")[0][seg1Len:seg1Len+seg2Len] + '\n')	

	outf1.close()
	outf2.close()
	inf.close()
