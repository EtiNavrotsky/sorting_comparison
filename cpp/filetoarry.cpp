// filetoarry.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <chrono>

using namespace std;


vector<int> buildArrFromFile(string fileName) {
	string line;
	vector<int> vect;
	ifstream aFileToSort(fileName);
	while (getline(aFileToSort, line)) {
		vect.push_back(stoi(line));
	}

	return (vect);
}

int main()
{

	int userSelection = 1;
	vector<int> vect;
	vector<int> vectTemp; 	
	string fileName = "array_2M_range_1000.txt";
	ofstream resultsFile;
	resultsFile.open("cppResults.txt");



	
	while (userSelection !=0)
	{
		vect = buildArrFromFile(fileName);
		std::cout << "Please choose the sort you want\n";
		std::cout << "1	--	Selection sort\n";
		std::cout << "2	--	Insertion sort\n";
		std::cout << "3	--	Quick sort\n";
		std::cout << "4	--	Merge sort\n";
		std::cout << "5	--	Heap sort\n";
		std::cout << "6	--	Counting sort\n";
		std::cout << "7	--	Radix sort\n";
		std::cout << "0	--	Quit\n";
		std::cin >> userSelection;
		auto startTime = chrono::steady_clock::now();
		auto endTime = chrono::steady_clock::now();
		switch (userSelection) {
		case 0:
			break;
		case 1:
			startTime = chrono::steady_clock::now();
			selectionSort(&vect[0], vect.size());
			endTime = chrono::steady_clock::now();
			resultsFile << "You chose Selection Sort\n ";
			break;
		case 2:
			startTime = chrono::steady_clock::now();
			InsertionSort(&vect[0], vect.size());
			endTime = chrono::steady_clock::now();
			resultsFile << "You chose Insertion Sort\n ";
			break;
		case 3:
			for (int i = 0; i < vect.size(); i++)
				vect[i] = 0;
			startTime = chrono::steady_clock::now();
			quickSort(&vect[0], 0, vect.size() - 1);
			endTime = chrono::steady_clock::now();
			resultsFile << "You chose Quick Sort\n ";
			break;
		case 4:
			vectTemp = vect;
			startTime = chrono::steady_clock::now();
			MergeSort(&vect[0], &vectTemp[0], 0, vect.size() - 1);
			endTime = chrono::steady_clock::now();
			resultsFile << "You chose Merge Sort\n ";
			break;
		case 5:
			startTime = chrono::steady_clock::now();
			heapSort(&vect[0], vect.size());
			endTime = chrono::steady_clock::now();
			resultsFile << "You chose Heap Sort\n ";
			break;
		case 6:
			vectTemp = vect;
			startTime = chrono::steady_clock::now();
			Counting_Sort(&vect[0], &vectTemp[0], vect.size());
			endTime = chrono::steady_clock::now();
			vect = vectTemp;
			resultsFile << "You chose Counting Sort\n ";
			break;
		case 7:
			startTime = chrono::steady_clock::now();
			radixsort(&vect[0], vect.size());
			endTime = chrono::steady_clock::now();
			resultsFile << "You chose Radix Sort\n ";
			break;
		}
		std::chrono::duration<double, std::milli> durationMs = endTime - startTime;
		if (userSelection!=0)
			resultsFile << "The time to run this algorithm is: " << durationMs.count() << endl;
	}
	resultsFile.close();
	

}
