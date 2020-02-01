// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file

#ifndef PCH_H
#define PCH_H

// TODO: add headers that you want to pre-compile here
void MergeSort(int arr[], int aux[], int low, int high);
void InsertionSort(int arr[], int arr_size);
void quickSort(int arr[], int left, int right); 
void heapSort(int arr[], int n);
void radixsort(int arr[], int n);
void selectionSort(int arr[], int n);
void Counting_Sort(int A[], int B[], int n);
void runAll();
#endif //PCH_H
