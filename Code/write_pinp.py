import sys
numdeme = 8
filehead = sys.argv[1]
argepi = int(sys.argv[2])
argkmax = int(sys.argv[3])
argRA = int(sys.argv[4])
argrdc = 3

def make_rmig_matrix(r_mig):
	matrix = ''
	for i in range(numdeme):
		line = ''
		for j in range(numdeme):
			if i!=j:
				line += str(r_mig) + " "
			elif i==j:
				line += str(0) + " "
			if j==(numdeme-1):
				line += "\n"
		matrix += line				
	return matrix
	
for rdc in range(argrdc, argrdc+1):
	for kmax in range(argkmax, argkmax+1):

		outf = open(filehead+str(kmax)+"_"+str(argRA)+".inp", "w")
	
		r_mig = 0
		outf.write("nNonsy "+str(20)+'\n')
		outf.write("nSynon "+str(1680)+'\n')
		outf.write("Ndeme 8"+'\n')
		outf.write("Kmax "+ str(kmax) +'\n')
		outf.write("DinY 80"+'\n')
		outf.write("Tburn 40000"+'\n')
		outf.write("Tsample 80000"+'\n')
		outf.write("r_mut 0.0001"+'\n')
		outf.write("r_mig"+'\n')
		matrix = make_rmig_matrix(r_mig)
		outf.write(matrix)
		outf.write("SamInt 8"+'\n')
		outf.write("Nsamp 5"+'\n')
		outf.write("dWin 10"+'\n')
		outf.write("vdisp 1"+'\n')
		outf.write("Ntry 1"+'\n')
		outf.write("seed 571917"+'\n')
		outf.write("bottleneckSize 0"+'\n')
		outf.write("doRecomb " + str(argRA) + '\n')
		outf.write("numEpitope "+str(argepi)+"\n")
		outf.write("sel_co 0.05\n")
		outf.write("reduced_u " + str(rdc) + "\n") 
		outf.write("sel_d 0.0\n")
		outf.close()
