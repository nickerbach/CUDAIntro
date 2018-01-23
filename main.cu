#include "book.h"
#include <stdio.h>
__global__ void assignIdentifier(int *r)
{
	int c = blockIdx.x * blockDim.x + threadIdx.x;
	r[c] = c;
}
int main(int argc, char ** argv )
{   
    int test = atoi(argv[1]);
    if(argc == 1)
    {
        test = 512;
    }
    int *dev_a;
    int a[test];
    HANDLE_ERROR(cudaMalloc( (void**)&dev_a, test * sizeof(int)) );
    assignIdentifier<<<1,test>>>(dev_a);
    HANDLE_ERROR(cudaMemcpy(a, dev_a, test * sizeof(int), cudaMemcpyDeviceToHost));
    for(int i = 0; i< test; i++)
    {
	        printf( "%d\n", a[i]);
    }
    cudaFree(dev_a);
    return 0;
}
