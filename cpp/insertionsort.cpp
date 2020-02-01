#include "pch.h"
#include <iostream>


void InsertionSort(int arr[], int arr_size) {
	if (arr_size > 1) {
		int size = arr_size;
		for (int i = 1; i < size; ++i) {
			int j = i - 1;
			int key = arr[i];
			while (j >= 0 && arr[j] > key) {
				arr[j + 1] = arr[j];
				--j;
			}
			arr[j + 1] = key;
		}
	}
}