
/******************************************************************************
 * Copyright (c) 2011, Duane Merrill.  All rights reserved.
 * Copyright (c) 2011-2018, NVIDIA CORPORATION.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the NVIDIA CORPORATION nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL NVIDIA CORPORATION BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 ******************************************************************************/


  // Ensure printing of CUDA runtime errors to console
#define CUB_STDERR

#include <stdio.h>
#include <algorithm>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <fstream>
#include <string>
#include <vector>
#include <chrono>

#include <cub/util_allocator.cuh>
#include <cub/device/device_radix_sort.cuh>
#include "test/test_util.h"

using namespace cub;
using namespace std;

// Caching allocator for device memory
CachingDeviceAllocator  g_allocator(true);  

vector<int> buildArrFromFile(string fileName) {
	string line;
	vector<int> vect;
	ifstream aFileToSort(fileName);
	while (getline(aFileToSort, line)) {
		vect.push_back(stoi(line));
	}
	return (vect);
}

int main(int argc, char** argv)
{
	// Initialize device
	// Choose which GPU to run on, change this on a multi-GPU system.
	cudaError_t cudaStatus = cudaSetDevice(0);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
		exit(1);
	}
	

	// Initialize the timer
	auto startTime = chrono::steady_clock::now();
	auto endTime = chrono::steady_clock::now();
	std::chrono::duration<double, std::milli> durationMs;

	// Initialize vector
	vector<int> vect;
	string fileName = "array_2M_range_1000.txt";
	vect = buildArrFromFile(fileName);
	int num_vals = vect.size();

	// Capturing the execute time
	startTime = chrono::steady_clock::now();

	// Allocate device arrays
	DoubleBuffer<int>   d_vals;
	CubDebugExit(g_allocator.DeviceAllocate((void**)&d_vals.d_buffers[0], sizeof(int) * num_vals));
	CubDebugExit(g_allocator.DeviceAllocate((void**)&d_vals.d_buffers[1], sizeof(int) * num_vals));
	
	
	// Allocate temporary storage
	size_t  temp_storage_bytes = 0;
	void    *d_temp_storage = NULL;

	CubDebugExit(DeviceRadixSort::SortKeys(d_temp_storage, temp_storage_bytes, d_vals, num_vals));
	CubDebugExit(g_allocator.DeviceAllocate(&d_temp_storage, temp_storage_bytes));

	// Initialize device arrays
	CubDebugExit(cudaMemcpy(d_vals.d_buffers[d_vals.selector], &vect[0], sizeof(int) * num_vals, cudaMemcpyHostToDevice));

	// Run
	CubDebugExit(DeviceRadixSort::SortKeys(d_temp_storage, temp_storage_bytes, d_vals, num_vals));

	// Allocate array on host
	int *h_sorted = new int[num_vals];

	// Copy data back
	cudaMemcpy(h_sorted, d_vals.Current(), sizeof(int) * num_vals, cudaMemcpyDeviceToHost);

	// Capturing the execute time
	endTime = chrono::steady_clock::now();

	durationMs = endTime - startTime;
	std::cout << "The time to run this algorithm is: " << durationMs.count() << endl;

	bool sorted = true;
	for (int i = 0; i < num_vals - 1; i++) {
		if (h_sorted[i] > h_sorted[i + 1]) {
			cout << "Not Sorted" << endl;
			sorted = false;
			break;
		}
	}
	if (sorted)
		cout << "The Array Is Sorted" << endl;

	printf("\n");

	// Cleanup
	if (h_sorted) delete[] h_sorted;
	if (d_vals.d_buffers[0]) CubDebugExit(g_allocator.DeviceFree(d_vals.d_buffers[0]));
	if (d_vals.d_buffers[1]) CubDebugExit(g_allocator.DeviceFree(d_vals.d_buffers[1]));
	if (d_temp_storage) CubDebugExit(g_allocator.DeviceFree(d_temp_storage));
	printf("\n\n");

	return 0;
}



