#!/usr/bin/env python


#import all the necessary modules

try:
  import os,sys,time
  from numpy import *
  from argparse import ArgumentParser
except ImportError:
  raise ImportError("Unable to load the necessary modules")
  sys.exit()

###################################################################
#Variables

#ASMDwork      -- array holder for all the work
#FinalWork    -- an array holder of all the final works. It used
#                to determine which of the SMD sim is closest to the JA
#Beta         -- 1/(TEMP*1.98722E-3) == 1/(T*kb)
#ASMDFileNames -- array holder of all the names of input ASMD files
#JarAvg       -- array of holder work after JA is calculated
#RxnCoord     -- array holder of the Reaction Coordinates used in the SMD sim
#workskip    -- returns the number of rows to skip to get only the final work
#sys.stdout   -- standard output file
#sys.stderr   -- standard error output file
###############################################################################


#Parse through ASMD files get the work values
def ParseASMDWorkfiles(ASMDWorkFiles):
  ASMDwork      = [] 
  FinalWork     = []
  ASMDdict      = {}
  RxnCoord      = array(loadtxt(ASMDWorkFiles[0], skiprows=1, usecols=(0,)))
  workskip      = len(RxnCoord) 
  ASMDFileNames = array(ASMDWorkFiles)
  for asmdinput in ASMDWorkFiles:
    ASMDwork.append(loadtxt(asmdinput, usecols=(3,), skiprows=1))
    FinalWork.append(loadtxt(asmdinput, usecols=(3,), skiprows=workskip))
    ASMDdict[len(FinalWork)]=asmdinput
  return ASMDwork, FinalWork, RxnCoord, workskip

#Calculate the Jarzynski Average
def CalcJA(WorkVals,TEMP):
  Beta = 1/(TEMP*1.98722E-3)
  JarAvg=-log(exp(array(WorkVals)*-Beta).mean(axis=0))/Beta
  return JarAvg

#Determine which of the SMDfiles has the work closest to the JA
def Closest_to_JA(FinalWorkVals,JarAvgWork,workskip,ASMDFiles):
  diff_Work_JA=abs(array(FinalWorkVals)-JarAvgWork[workskip-1])
  closestwork=diff_Work_JA.min() #get the work with the smallest difference
  asmdfile=where(diff_Work_JA==closestwork) #locates which work had the smallest diference
  ASMDFileNames=array(ASMDFiles)
  for i in ASMDFileNames[asmdfile]:
     filename=i
  return filename
#return ASMDFileNames[asmdfile]

#Generate the output of the Rxn Coord and JarAvg
def Write_JA_output(Filename,JarAvgWork,RxnCoords):
  output_file=open(Filename, 'w')
  for coords, jarval in zip(RxnCoords,JarAvgWork):
    output_file.write("%s %s\n" % (coords,jarval))
  output_file.close()


def main():
#open standard output/error files
  sys.stdout = os.fdopen(sys.stdout.fileno(),'w',0)
  sys.stderr = os.fdopen(sys.stderr.fileno(),'w',0)

###Parse the CMD LINE Arguments
  parser=ArgumentParser()

  parser.add_argument('-t', '--temp', default=300, type=float,
                    dest='TEMP', help='Temperature of the ASMD simulations')
  parser.add_argument('-f', '--inputfile', default=None, dest='INPUT_FILE', metavar='FILE',
                    help='Input file that contains the list of ASMD files to analyze')
  parser.add_argument('-o', '--output', default='_jar.PMF.dat', dest='JarFile', metavar="FILE",
                    help='Name of the PMF output file')
  parser.add_argument('-i', '--asmdfiles', default=None, metavar='FILES', nargs='*',
                    dest='asmdworkfiles', help='ASMD Files')
  Args = parser.parse_args()

#Prints the usage if no arguments are given
#Also check to make sure used the -f or -i flags
  if len(sys.argv) ==1:
    parser.exit(status=1, message=parser.print_help())

#Also check to make sure used the -f or -i flags
  if Args.INPUT_FILE is None and Args.asmdworkfiles is None:
    parser.exit(status=1, message="ASMD.py: error: options -i or -f required\n")

#check to determine if the "-i" or "-s" flag was used:
  if Args.INPUT_FILE is None:
    ASMDFiles=Args.asmdworkfiles
  else:
    ASMDFiles=loadtxt(Args.INPUT_FILE, dtype='str')

  ASMDwork,FinalWork,RxnCoords,workskip=ParseASMDWorkfiles(ASMDFiles)
  JarAVG=CalcJA(ASMDwork,Args.TEMP)
  asmdfile=Closest_to_JA(FinalWork,JarAVG,workskip,ASMDFiles)
  Write_JA_output(Args.JarFile,JarAVG,RxnCoords)


  print >> sys.stdout, "The file closest to the Jarzynski Average is:   %s" % asmdfile

if __name__ == '__main__':
  main()
