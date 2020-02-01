/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package test2;

/**
 *
 * @author idona
 */
public class Countingsort {
    public static void sort(Integer[] input) { 

        int k = getMax(input,input.length);

        // create buckets 
        int counter[] = new int[k + 1]; 
        
        // fill buckets 
        for (int i : input) { 
            counter[i]++;
        }
     
        // sort array 
        int ndx = 0; 
        for (int i = 0; i < counter.length; i++) { 
            while (0 < counter[i]) { 
                input[ndx++] = i; 
                counter[i]--; 
            } 
        }
    }
    static int getMax(Integer arr[], int n) 
    { 
        int mx = arr[0]; 
        for (int i = 1; i < n; i++) 
            if (arr[i] > mx) 
                mx = arr[i]; 
        return mx; 
    } 


}
