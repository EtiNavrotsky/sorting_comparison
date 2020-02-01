#include<iostream>
#include "pch.h"
#include <vector>

using namespace std;


/*Method to sort the array*/
void Counting_Sort(int A[], int B[], int n)
{
	vector<int> vectKeys;
	int maxKey=0;


	for (int i = 0; i < n; i++)
		if (A[i]>maxKey)
			maxKey = A[i];


	for (int i = 0; i < maxKey + 1; i++)
	{
		/*It will initialize the vextKeys with zero*/
		vectKeys.push_back(0);
	}
	for (int j = 0; j < n; j++)
	{
		/*It will count the occurence of every element x in A
		and increment it at position x in C*/
		vectKeys[A[j]]++;
	}
	for (int i = 1; i <= maxKey; i++)
	{
		/*It will store the last
		occurence of the element i */
		vectKeys[i] += vectKeys[i - 1];
	}
	for (int j = n-1; j >= 0; j--)
	{
		/*It will place the elements at their
		respective index*/
		B[vectKeys[A[j]]-1] = A[j];
		/*It will help if an element occurs
		more than one time*/
		vectKeys[A[j]] = vectKeys[A[j]] - 1;
	}


}