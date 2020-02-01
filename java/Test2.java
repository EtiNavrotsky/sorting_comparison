/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package test2;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author idona
 */
public class Test2 {

    
     public static void main(String[] args) throws IOException {
        Integer[] arr = null;
        String fileName = "array_2M_range_1M.txt";
        
        FileWriter resultsFile = new FileWriter("javaResults.txt");
        double startTime=0, endTime=0, totalTime=0;
        Selectionsort selectionEle = new Selectionsort();
        InsertionSort insertionEle = new InsertionSort();
        Quicksort quickEle = new Quicksort();
        Mergesort mergeEle = new Mergesort();
        Heapsort heapEle = new Heapsort();
        Countingsort countingEle = new Countingsort();
        Radixsort radixEle = new Radixsort();
        int userSelection=1;
        

        while (userSelection!= 0)
        {
            arr = buildArrFromFile(fileName);
            System.out.println("Please choose a sorting algorithm:");
            System.out.println("1   -   Selection sort");
            System.out.println("2   -   Insertion sort");
            System.out.println("3   -   Quick sort");
            System.out.println("4   -   Merge sort");
            System.out.println("5   -   Heap sort");
            System.out.println("6   -   Counting sort");
            System.out.println("7   -   Radix sort");
            System.out.println("0   -   Quit");       
            BufferedReader reader = new BufferedReader(new InputStreamReader(System.in)); 
            userSelection = Integer.parseInt(reader.readLine());
            switch(userSelection){
                case 0:
                    break;                      
                case 1:
                    startTime = System.currentTimeMillis();
                    selectionEle.sort(arr);
                    endTime = System.currentTimeMillis();
                    resultsFile.append("\r\nYou chose selection sort \r\n");
                    for (int i=0; i<arr.length-1; i++){
                        if (arr[i]>arr[i+1])
                        {
                            System.out.println("The array in not sorted");
                            break;
                        }   
                    } 
                    break;
                case 2:
                    startTime = System.currentTimeMillis();
                    insertionEle.sort(arr);
                    endTime = System.currentTimeMillis();
                    resultsFile.append("\r\nYou chose Insertion sort \r\n");
                    for (int i=0; i<arr.length-1; i++){
                        if (arr[i]>arr[i+1])
                        {
                            System.out.println("The array in not sorted");
                            break;
                        }   
                    }    
                    break;
                case 3:
                    startTime = System.currentTimeMillis();
                    quickEle.sort(arr, 0, arr.length-1);
                    endTime = System.currentTimeMillis();
                    resultsFile.append("\r\nYou chose Quick sort \r\n");
                    for (int i=0; i<arr.length-1; i++){
                        if (arr[i]>arr[i+1])
                        {
                            System.out.println("The array in not sorted");
                            break;
                        }   
                    }                     break;
                case 4:
                    startTime = System.currentTimeMillis();
                    mergeEle.sort(arr, 0, arr.length-1);
                    endTime = System.currentTimeMillis();
                    resultsFile.append("\r\nYou chose Merge sort \r\n");
                    for (int i=0; i<arr.length-1; i++){
                        if (arr[i]>arr[i+1])
                        {
                            System.out.println("The array in not sorted");
                            break;
                        }   
                    } 
                    break;
                case 5:
                    startTime = System.currentTimeMillis();
                    heapEle.sort(arr);
                    endTime = System.currentTimeMillis();
                    resultsFile.append("\r\nYou chose Heap sort \r\n");
                    for (int i=0; i<arr.length-1; i++){
                        if (arr[i]>arr[i+1])
                        {
                            System.out.println("The array in not sorted");
                            break;
                        }   
                    }        
                    break;
                case 6:
                    startTime = System.currentTimeMillis();
                    countingEle.sort(arr);
                    endTime = System.currentTimeMillis();
                    resultsFile.append("\r\nYou chose Counting sort \r\n");
                    for (int i=0; i<arr.length-1; i++){
                        if (arr[i]>arr[i+1])
                        {
                            System.out.println("The array in not sorted");
                            break;
                        }   
                    }        
                    break;
                case 7:
                    startTime = System.currentTimeMillis();
                    radixEle.sort(arr, arr.length);
                    endTime = System.currentTimeMillis();
                    resultsFile.append("\r\nYou chose Radix sort \r\n");
                    for (int i=0; i<arr.length-1; i++){
                        if (arr[i]>arr[i+1])
                        {
                            System.out.println("The array in not sorted");
                            break;
                        }   
                    }        
                    break;
            }
            totalTime = endTime - startTime;
            if (userSelection!=0)
                resultsFile.append("The time to run this algorithm is " + totalTime + "\r\n");
        }

        
        resultsFile.close();
    }
     
   private static Integer[] buildArrFromFile(String fileName) throws IOException{
       
        BufferedReader aFileToSort;
        String line;
        int i = 0;
        Vector<Integer> vect = new Vector<>();
        try {
            aFileToSort = new BufferedReader(new FileReader(fileName));
            while ((line = aFileToSort.readLine()) != null){
                vect.add(Integer.parseInt(line));      
            }
            aFileToSort.close();
        } catch (IOException ex){
            System.out.println("Can't read file");
        }
        Integer[] retArr = vect.toArray(new Integer[vect.size()]);
        
        return retArr;
   }   
}
