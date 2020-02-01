def buildArr(fileName,sizeArr,rangeArr):
    import random    
    arrFile = open(fileName, "w+")
    for i in range (1, sizeArr):
        arrFile.write("%s\n"%str(random.randint(0, rangeArr-1)))
    arrFile.close()

buildArr ("array_5M_range_1000.txt",5000000,1000)
buildArr ("array_5M_range_1M.txt",5000000,1000000)


#buildArr ("array_100k_range_1M.txt",100000,1000000)
#buildArr ("array_2M_range_1M.txt",2000000,1000000)
