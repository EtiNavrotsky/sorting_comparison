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
public class Selectionsort {
    public Integer[] sort(Integer[] arr) {
        if (arr.length == 1) {
            return arr;
        }
        for(int i = 0; i < arr.length; i++){
            int z = i;
            for(int m = i + 1; m < arr.length; m++){
                if(arr[z] > arr[m]){
                    z = m;
                }
            }
            swap(arr, i, z);
        }
        return arr;
    }
    public Integer[] swap(Integer[] arr, int firstPosition, int swapper){
        //int buffer_firstPosition = firstPosition;
        int buffer_firstValue = arr[firstPosition];
        arr[firstPosition] = arr[swapper];
        arr[swapper] = buffer_firstValue;
        return arr;
    }
   
}
