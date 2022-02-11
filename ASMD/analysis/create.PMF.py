#!/usr/bin/env python

try:
  import os,sys
  from numpy import *
  from argparse import ArgumentParser
except ImportError:
  raise ImportError("Unable to load the necessary modules")
  sys.exit()

def main():

# get CMD line Args 
  parser=ArgumentParser()

  parser.add_argument('-s', '--stages', default=None, type=int,
                    dest='stages', help='Number of ASMD stages', required=True)
  parser.add_argument('-o', '--output', default='_asmd.PMF.dat', dest='PMFfile', metavar="FILE",
                    help='Name of the PMF output file')
  Args = parser.parse_args()

#Prints the usage if no arguments are given
  if len(sys.argv) ==1:
    parser.exit(status=1, message=parser.print_help())
 
  stages=Args.stages+1

# Open the outputfile and write the new PMF
  outputfile=open(Args.PMFfile, "w")
  addval=0.0
  for stage in range(1,stages):
    rxncoord,work=loadtxt("stage%s.dat" % stage, usecols=(0,1), unpack=True)
    work=work+addval
    for coord, workval in zip(rxncoord,work):
      outputfile.write("%s %s\n" % (coord,workval))
    value=int(len(work))-1 
    addval=float(work[value])
  outputfile.close()

if __name__ == '__main__':
  main()

