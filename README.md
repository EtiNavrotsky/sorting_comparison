The project surveys the behavior of sorting algorithms on several platforms. 
A platform is a combination between the CPU or the GPU with a programming language. 

This project proves the importance of preliminary knowledge before one starts coding. 
The differences between the performance do not leave any doubt. C++, had the best results, over other platforms and languages. 
The GPU, in this survey, did not achieve the expected results. 
In a matter of numbers, the C++, had between 50-80% better results than Java, while Java had much better performances than Python, around 95%. 


In the comparison between GPU/CUDA and CPU/C++, in small arrays, C++ had better results than GPU (around 90% better). 
While in vast arrays CUDA had better or almost the same results. 
Since GPU/CUDA requires expensive hardware, and professional peoples, the advantages of using GPU, are reduced over CPU/C++. 

THE PLATFORM

NVIDIA – GeForce 1050 TI
CPU – i5 Intel


THE ENVIRONMENT
The survey executed the algorithms in four languages/compilers:
	C++ - Microsoft C++ Compiler version 19.16.27027.1 x64
	JAVA – version 1.8.0_201
	Python – Version 3.7.2
	CUDA – Version 10.0

IMPLEMENTATION INFORMATION
For executing the algorithms, four different arrays were created. 
The arrays were built randomly, with a uniform distribution. 
Several array sizes were checked, and the selected arrays are:
1.	A1: 100K elements, zero to 1K range.
2.	A2: 100K elements, zero to 1M range.
3.	A3: 2M elements, zero to 1K range.
4.	A4: 2M elements, zero to 1M range.

Since the values of the elements are integers [4 Bytes], the difference between the ranges is mainly to survey the linear algorithms, the counting, and radix sort. 
During the survey, the execution time was recorded in milliseconds. 
The execution time in CPU included the time it took to execute the algorithm. 
In GPU it included the time to copy the memory from/to the CPU too. 
The time it took to create the array from the file, was excluded in both platforms. 
