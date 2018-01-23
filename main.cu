#include "book.h"//connects the program to the book.h file
#include <stdio.h>//import needed to use atoi
__global__ void assignIdentifier(int *r)//kernel that gets the thread ID then saves the value
{
	int c = blockIdx.x * blockDim.x + threadIdx.x;
	r[c] = c;
}
int main(int argc, char ** argv )
{   
    printf("%d\n",argc);
    int test;//gets the command line argument of how many threads a user wants to use, casts to int
    if(argc < 2)//if no command line entry is put in, defaults to 512 threads
    {
        test = 512;
    }
    else
    {
	test = atoi(argv[1]);//sets number of threads to the user input
     }
    int *dev_a;//pointer to the spot in memory we will use
    int a[test];//array we will use to store the ids before printing
    HANDLE_ERROR(cudaMalloc( (void**)&dev_a, test * sizeof(int)) );//creates memory space on the GPU
    assignIdentifier<<<1,test>>>(dev_a);//uses kernel to store ids for each thread
    HANDLE_ERROR(cudaMemcpy(a, dev_a, test * sizeof(int), cudaMemcpyDeviceToHost));//copies our array from GPU to CPU
    for(int i = 0; i< test; i++)//prints each id back to the user
    {
	        printf( "%d\n", a[i]);
    }
    cudaFree(dev_a);//frees up memory space that we used now that we are done
    return 0;
}
