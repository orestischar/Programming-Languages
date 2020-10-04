#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import queue
import collections



def floodfill(the_one_dict, water_queue, N, M): # set the water time
    while not water_queue.empty():
        
        coos = water_queue.get()
        the_values = the_one_dict[coos]

        if (the_values[0] == 'W'):
            i = coos[0]
            j = coos[1]

            if(i > 0 and the_one_dict[(i-1,j)][0] != 'W' and the_one_dict[(i-1,j)][0] != 'X'):
                the_old_values = the_one_dict[(i-1,j)]
                the_one_dict.update({(i-1,j) : ('W',the_values[1]+1,the_old_values[2],the_old_values[3],the_old_values[4],the_old_values[5],the_old_values[6]) })
                water_queue.put((i-1,j))

            if(j > 0 and the_one_dict[(i,j-1)][0] != 'W' and the_one_dict[(i,j-1)][0] != 'X'):
                the_old_values = the_one_dict[(i,j-1)]
                the_one_dict.update({(i,j-1) : ('W',the_values[1]+1,the_old_values[2],the_old_values[3],the_old_values[4],the_old_values[5],the_old_values[6]) })
                water_queue.put((i,j-1))

            if(j < M-1 and the_one_dict[(i,j+1)][0] != 'W' and the_one_dict[(i,j+1)][0] != 'X'):
                the_old_values = the_one_dict[(i,j+1)]
                the_one_dict.update({(i,j+1) : ('W',the_values[1]+1,the_old_values[2],the_old_values[3],the_old_values[4],the_old_values[5],the_old_values[6]) })
                water_queue.put((i,j+1))

            if(i < N-1 and the_one_dict[(i+1,j)][0] != 'W' and the_one_dict[(i+1,j)][0] != 'X'):
                the_old_values = the_one_dict[(i+1,j)]
                the_one_dict.update({(i+1,j) : ('W',the_values[1]+1,the_old_values[2],the_old_values[3],the_old_values[4],the_old_values[5],the_old_values[6]) })
                water_queue.put((i+1,j))



def catBFS(the_one_dict, cat_queue, N, M, resX, resY):

    maxTime = -10

    while not cat_queue.empty():
        #temp_dict = {"x": x, "y": y, "type": spot, "wt": -1, "ct": 0, "visited": False, "move": None, "prevX": -1, "prevY": -1}
        coos = cat_queue.get()
        i = coos[0]
        j = coos[1]
        the_values = the_one_dict[coos]
        wt = the_values[1]
        the_one_dict.update({coos : (the_values[0],wt,the_values[2],True,the_values[4],the_values[5],the_values[6]) })


        if((wt > maxTime) or ((wt == maxTime) and (i < resX)) or ((wt == maxTime) and (i == resX) and (j < resY))):
            maxTime = wt
            resX = i
            resY = j

        # check neighbors in D,L,R,U order

        if ((i < N-1) and (the_one_dict[i+1,j][1] > the_values[2]+1) and not (the_one_dict[i+1,j][3]) and not (the_one_dict[i+1,j][0] == "X")):
            the_new_values = the_one_dict[i+1,j]
            the_one_dict.update({(i+1,j) : (the_new_values[0],the_new_values[1],the_values[2]+1,True,"D",i,j) })                    
            cat_queue.put((i+1,j))

        if ((j > 0) and ((the_one_dict[(i,j-1)][1] > the_one_dict[(i,j)][2]+1) or (the_one_dict[(i,j-1)][1] == -1)) and not (the_one_dict[(i,j-1)][3]) and not (the_one_dict[(i,j-1)][0] == "X")):
            the_new_values = the_one_dict[i,j-1]
            the_one_dict.update({(i,j-1) : (the_new_values[0],the_new_values[1],the_values[2]+1,True,"L",i,j) })                    
            cat_queue.put((i,j-1))  


        if ((j < M-1) and (the_one_dict[i,j+1][1] > the_values[2]+1) and not (the_one_dict[i,j+1][3]) and not (the_one_dict[i,j+1][0] == "X")):
            the_new_values = the_one_dict[i,j+1]
            the_one_dict.update({(i,j+1) : (the_new_values[0],the_new_values[1],the_values[2]+1,True,"R",i,j) })                    
            cat_queue.put((i,j+1))


        if((i > 0) and ((the_one_dict[(i-1,j)][1] > the_one_dict[(i,j)][2]+1) or (the_one_dict[(i-1,j)][1] == -1)) and not (the_one_dict[(i-1,j)][3]) and not (the_one_dict[(i-1,j)][0] == "X")):
            the_new_values = the_one_dict[i-1,j]
            the_one_dict.update({(i-1,j) : (the_new_values[0],the_new_values[1],the_values[2]+1,True,"U",i,j) })                    
            cat_queue.put((i-1,j))            


    return (maxTime, resX, resY)


def print_path(the_one_dict, i, j):

    to_print = collections.deque([])

    while(the_one_dict[(i,j)][5] != -1 or the_one_dict[(i,j)][6] != -1):
        
        to_print.append(the_one_dict[(i,j)][4])
        new_i = the_one_dict[(i,j)][5]
        new_j = the_one_dict[(i,j)][6]
        i = new_i
        j = new_j

    return to_print



# python uses call by object: immutable obj -> call by values

with open(sys.argv[1]) as savethecat:

    basement = {} 
    water = queue.Queue()
    cat = queue.Queue()

    
    #read the input and initialize the queues
    x = 0
    for line in savethecat:
        y = 0
        for spot in line:
            if (spot!='\n'):
                coos = (x,y)
                
                if(spot == 'W'):
                    basement[coos] = (spot,0,0,False,None,-1,-1)
                    water.put(coos)
                
                elif (spot == 'A'):
                    basement[coos] = (spot,-1,0,False,None,-1,-1)
                    catX = x
                    catY = y
                    cat.put(coos)                    

                else:
                    basement[coos] = (spot,-1,0,False,None,-1,-1)  #temp_dict = {"type": spot, "wt": -1, "ct": 0, "visited": False, "move": None, "prevX": -1, "prevY": -1}
                
            y = y + 1

        x = x + 1

    y=y-1
    floodfill(basement, water, x, y)  # correct results

    (result,res_X, res_Y) = catBFS(basement, cat, x, y, 1010, 1010)     # change 1000 with sth max

    result = result - 1


    if(basement[(catX,catY)][1] != -1):
        if(result != -2):
            print(result)
        else:
            print(0)
    else:
        print("infinity")


    if(catX == res_X and catY == res_Y):
        print("stay")
    else:
        to_print = print_path(basement, res_X, res_Y)
        while to_print:
            print(to_print.pop(), end ='')
        print("")        