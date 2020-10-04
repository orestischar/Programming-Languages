#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import warnings
import sys
import queue
import collections
from queue import Queue

with open(sys.argv[1]) as ztalloc:
    N = int(next(ztalloc))
    Lins = []
    Rins = []
    Louts = []
    Routs = []
    for line in ztalloc:
        shit = [[] for i in range(N)]
        (Lin, Rin, Lout, Rout) = line.split()
        (Lin, Rin, Lout, Rout) = (int(Lin), int(Rin), int(Lout), int(Rout))
        Lins.append(Lin)
        #print(Lin, end=' ')
        #print (Rin)
        Rins.append(Rin)
        Louts.append(Lout)
        Routs.append(Rout)

    for i in range(N):
        mydic = {}
        q=Queue()
        dasolution = 'IMPOSSIBLE'

        #IF WE HAVE ONE NUMBER
        if Rins[i] == Lins[i]:

            q.put(Lins[i])
            mydic[Lins[i]]=''

            while not q.empty():
                temp=q.get()
                #print(temp)
                if temp >= Louts[i] and temp <= Routs[i]:
                    #print('MPHKA KAI DASOLUTION IS ' + dasolution)
                    dasolution = mydic[temp]
                    break

                if (mydic.get(temp//2, -1) == -1):
                    q.put(temp//2)
                    mydic[temp//2] = mydic[temp] + 'h'

                if temp*3 + 1 < 1000000 and mydic.get(temp*3 +1, -1) == -1:
                    q.put(temp*3 + 1)
                    mydic[temp*3 + 1 ] = mydic[temp] + 't'
            
            if dasolution == '':
                print('EMPTY')
            else:
                print(dasolution)

        #IF WE HAVE A BIGGER SPACE
        else:
            #print("KOITADW ", Lins[i], " ", Rins[i])
            #print('')
            q.put((Lins[i], Rins[i]))
            mydic[(Lins[i] + Rins[i]) // 2]=(Lins[i], Rins[i], '')

            while not q.empty():
                temp=q.get()
                #print(temp[0], " ", temp[1])
                #print(temp)
                if temp[0] >= Louts[i] and temp[0] <= Routs[i] and temp[1] >= Louts[i] and temp[1] <= Routs[i]:
                    dasolution = mydic[(temp[0]+temp[1])//2][2]
                    break

                mid = (temp[0]+temp[1]) // 2

                nl = temp[0]//2
                nr =  temp[1]//2
                checker = mydic.get((nl+nr)//2, -1)

                if (checker == -1 or (checker != -1 and (nl > checker[0] or nr < checker[1])) ):
                    q.put((nl, nr))
                    mydic.update({ ((nl+nr)//2) : (nl, nr, mydic[mid][2] + 'h') })

                nl = temp[0]*3 + 1
                nr = temp[1]*3 + 1
                checker = mydic.get((nl+nr)//2, -1)

                if nl < 1000000 and nr < 1000000 and (checker == -1 or (checker != -1 and (nl > checker[0] or nr < checker[1])) ):
                    q.put((nl, nr))
                    mydic.update({(nl+nr)//2 : (nl, nr, mydic[mid][2] + 't') })
            
            if dasolution == '':
                print('EMPTY')
            else:
                print(dasolution)  