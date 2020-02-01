
def countingSort(array1):
    m = maxVal(array1)+1
    count = [0] * m                
    
    for a in array1:
    # count occurences
        count[a] += 1             
    i = 0
    for a in range(m):            
        for c in range(count[a]):  
            array1[i] = a
            i += 1
    return array1

def maxVal(array1):
    m = array1[0];
    for a in array1:
        if a>m :
            m = a
    return m

