def insertionSort(alist):

   for i in range(1,len(alist)):

       #element to be compared
       current = alist[i]

       #comparing the current element with the sorted portion and swapping
       while i>0 and alist[i-1]>current:
           alist[i] = alist[i-1]
           i -= 1
           alist[i] = current


   return alist
