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

public class InsertionSort  {
    public Integer[] sort(Integer[] arr){
        if (arr.length == 1) {
            return arr;
        }
        for(int i = 1; i < arr.length; i++ ){
            int swapperIndex = i;
            int swapperValue = arr[i];
            while(arr[swapperIndex] < arr[swapperIndex - 1]){
                arr[swapperIndex] = arr[swapperIndex - 1];
                arr[swapperIndex - 1] = swapperValue;
                if(swapperIndex > 1){
                    swapperIndex--;
                }
            }
        }
        return arr;
    }
}
    
