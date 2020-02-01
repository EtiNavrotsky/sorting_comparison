#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>

#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <algorithm>
#include <iterator>
#include <chrono>

using namespace std;

/**
 * mergesort.cu
 * a one-file c++ / cuda program for performing mergesort on the GPU
 * While the program execution is fairly slow, most of its runnning time
 *  is spent allocating memory on the GPU.
 * For a more complex program that performs many calculations,
 *  running on the GPU may provide a significant boost in performance
 */

vector<int> buildArrFromFile(string fileName);


// data[], size, threads, blocks, 
void mergesort(int*, int, dim3, dim3);

// A[]. B[], size, width, slices, nThreads
__global__ void gpu_mergesort(long*, long*, long, long, long, dim3*, dim3*);
__device__ void gpu_bottomUpMerge(long*, long*, long, long, long);



#define min(a, b) (a < b ? a : b)


bool verbose;
int main(int argc, char** argv) {

	dim3 threadsPerBlock;
	dim3 blocksPerGrid;

	threadsPerBlock.x = 32;
	threadsPerBlock.y = 1;
	threadsPerBlock.z = 1;

	blocksPerGrid.x = 24;
	blocksPerGrid.y = 1;
	blocksPerGrid.z = 1;

	auto startTime = chrono::steady_clock::now();
	auto endTime = chrono::steady_clock::now();
	std::chrono::duration<double, std::milli> durationMs;

	// Read numbers from file
	string fileName = "array_2M_range_1000.txt";
	vector<int> data = buildArrFromFile(fileName);
	int size = data.size();

	// merge-sort the data
	startTime = chrono::steady_clock::now();
	mergesort(&data[0], size, threadsPerBlock, blocksPerGrid);
	endTime = chrono::steady_clock::now();


	durationMs = endTime - startTime;
	std::cout << "The time to run this algorithm is: " << durationMs.count();

	
	for (int i = 0; i < size-1; i++) {
		if (data[i] > data[i + 1]) {
			cout << "Not Sorted" << endl;
			break;
		}
	}
}

void mergesort(int* data, int size, dim3 threadsPerBlock, dim3 blocksPerGrid) {

	// Allocate two arrays on the GPU
	// we switch back and forth between them during the sort
	long* D_data;
	long* D_swp;
	dim3* D_threads;
	dim3* D_blocks;
	cudaError_t cudaStatus;
		// Actually allocate the two arrays

	cudaStatus = cudaSetDevice(0);
	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
		exit(1);
	}

	int megabytesToUse = 160;

	size_t newHeapSize = 1024 * 1000 * megabytesToUse;
	cudaStatus = cudaDeviceSetLimit(cudaLimitMallocHeapSize, 
		newHeapSize);
	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "cudaDeviceSetLimit failed!");
		exit(1);
	}
	//printf("Adjusted heap size to be %d\n", (int)newHeapSize);



	cudaStatus = cudaMalloc((void**)&D_data, size * sizeof(long) * 2);
	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
		exit(1);
	}
	cudaStatus = cudaMalloc((void**)&D_swp, size * sizeof(long) * 2);
	if (cudaStatus != cudaSuccess) {
//        fprintf(stderr, "cudadevicesynchronize returned error code %d after launching addkernel!\n", cudastatus);
        exit(1);
    }

	// Copy from our input list into the first array
	cudaStatus = cudaMemcpy(D_data, data, size * sizeof(long), cudaMemcpyHostToDevice);

	//
	// Copy the thread / block info to the GPU as well
	//
	cudaStatus = cudaMalloc((void**)&D_threads, sizeof(dim3));
	cudaStatus = cudaMalloc((void**)&D_blocks, sizeof(dim3));

	cudaStatus = cudaMemcpy(D_threads, &threadsPerBlock, sizeof(dim3), cudaMemcpyHostToDevice);
	cudaStatus = cudaMemcpy(D_blocks, &blocksPerGrid, sizeof(dim3), cudaMemcpyHostToDevice);


	long* A = D_data;
	long* B = D_swp;

	long nThreads = threadsPerBlock.x * threadsPerBlock.y * threadsPerBlock.z *
		blocksPerGrid.x * blocksPerGrid.y * blocksPerGrid.z;

	auto startTime = chrono::steady_clock::now();
	auto endTime = chrono::steady_clock::now();
	std::chrono::duration<double, std::milli> durationMs;
	//
	// Slice up the list and give pieces of it to each thread, letting the pieces grow
	// bigger and bigger until the whole list is sorted
	//

	startTime = chrono::steady_clock::now();
	for (int width = 2; width < (size << 1); width <<= 1) {
		long slices = size / ((nThreads)* width) + 1;

		// Actually call the kernel
		gpu_mergesort << <blocksPerGrid, threadsPerBlock >> > (A, B, size, width, slices, D_threads, D_blocks);
		cudaStatus = cudaDeviceSynchronize();
		if (cudaStatus != cudaSuccess) {
			exit(1);
		}

		// Switch the input / output arrays instead of copying them around
		A = A == D_data ? D_swp : D_data;
		B = B == D_data ? D_swp : D_data;
	}
	endTime = chrono::steady_clock::now();
	durationMs = endTime - startTime;
	std::cout << "The time to run the GPU is: " << durationMs.count() << endl;
	//
	// Get the list back from the GPU
 	cudaStatus = cudaMemcpy(data, A, size * sizeof(long), cudaMemcpyDeviceToHost);

	// Free the GPU memory
	cudaStatus = cudaFree(A);
	cudaStatus = cudaFree(B);

	// cudaDeviceReset must be called before exiting in order for profiling and
// tracing tools such as Nsight and Visual Profiler to show complete traces.
	cudaStatus = cudaDeviceReset();
	if (cudaStatus != cudaSuccess) {
		exit(1);
	}

}

// GPU helper function
// calculate the id of the current thread
__device__ unsigned int getIdx(dim3* threads, dim3* blocks) {
	int x;
	return threadIdx.x +
		threadIdx.y * (x = threads->x) +
		threadIdx.z * (x *= threads->y) +
		blockIdx.x  * (x *= threads->z) +
		blockIdx.y  * (x *= blocks->z) +
		blockIdx.z  * (x *= blocks->y);
}

//
// Perform a full mergesort on our section of the data.
//
__global__ void gpu_mergesort(long* source, long* dest, long size, long width, long slices, dim3* threads, dim3* blocks) {
	unsigned int idx = getIdx(threads, blocks);
	long start = width * idx*slices,
		middle,
		end;

	for (long slice = 0; slice < slices; slice++) {
		if (start >= size)
			break;

		middle = min(start + (width >> 1), size);
		end = min(start + width, size);
		
		gpu_bottomUpMerge(source, dest, start, middle, end);
		start += width;
	}
}

// Finally, sort something
// gets called by gpu_mergesort() for each slice
__device__ void gpu_bottomUpMerge(long* source, long* dest, long start, long middle, long end) {
	long i = start;
	long j = middle;
	for (long k = start; k < end; k++) {
		if (i < middle && (j >= end || source[i] < source[j])) {
			dest[k] = source[i];
			i++;
		}
		else {
			dest[k] = source[j];
			j++;
		}
	}
}



vector<int> buildArrFromFile(string fileName) {
	string line;
	vector<int> vect;
	ifstream aFileToSort(fileName);
	while (getline(aFileToSort, line)) {
		vect.push_back(stoi(line));
	}

	return (vect);
}

