import heapsort
import insertionsort
import mergesort
import quicksort
import radixsort
import countingsort
import selectionsort
import time

# Create a list from file
def buildArrFromFile(aFileToSort):
    alist = []
    with open(aFileToSort,"r") as file:
        for line in file: 
            alist.append(int(line))
    return alist
resultsFile = open("pyResults.txt", "w")
userSelection = '1';
while (userSelection!='0'):
    alist = buildArrFromFile("array_2M_range_1000.txt")
    print ("Please select a sorting algorithm\n")
    print ("1   -   Selection sort\n")
    print ("2   -   Insertion sort\n")
    print ("3   -   Quick sort\n")
    print ("4   -   Merge sort\n")
    print ("5   -   Heap sort\n")
    print ("6   -   Counting sort\n")
    print ("7   -   Radix sort\n")
    print ("0   -   Quit\n")
    userSelection = input()

    #Run the selected algorithm
    if userSelection == '1':
        startTime = time.time()
        selectionsort.selectionSort(alist)
        endTime = time.time()
        resultsFile.write("You chose Selection sort\n")
    elif userSelection=='2':
        startTime = time.time()
        insertionsort.insertionSort(alist)
        endTime = time.time()
        resultsFile.write("You chose Insertion sort\n")
    elif userSelection == '3':
        startTime = time.time()
        alist = quicksort.quickSort(alist)
        endTime = time.time()
        resultsFile.write("You chose Quick sort\n")
    elif userSelection == '4':
        startTime = time.time()
        mergesort.mergeSort(alist)
        endTime = time.time()
        resultsFile.write("You chose Merge sort\n")
    elif userSelection == '5':
        startTime = time.time()
        heapsort.heapSort(alist)
        endTime = time.time()
        resultsFile.write("You chose Heap sort\n")
    elif userSelection == '6':
        startTime = time.time()
        countingsort.countingSort(alist)
        endTime = time.time()
        print(alist[0:20])
        resultsFile.write("You chose Counting sort\n")
    elif userSelection == '7':
        startTime = time.time()
        radixsort.radixSort(alist)
        endTime = time.time()
        resultsFile.write("You chose Radix sort\n")
    if userSelection!='0':
        resultsFile.write("The total time to run the algorithm is ")
        resultsFile.write(str(endTime-startTime))
        resultsFile.write("\n")
        resultsFile.write(str(alist[0:50]))
        resultsFile.write("\n")
resultsFile.close()



