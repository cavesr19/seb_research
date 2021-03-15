#include <stdio.h>
#include <cuda.h>
#include <string.h>

//testing commit

//ensure that your code is safeguarded against segmentstion faults etc...
__global__ void cypher_thread(char * t_input, char * t_output, int length){
    int idx = threadIdx.x;

    if(idx < length){
        char c = t_input[idx];
        t_output[idx] = c-1;
    }
}

int main(){
    //initialize test message
    const char program_input[] = "Ifmmp-!J!bn!b!tuvefou!ifsf!jo!uif!Dpnqvufs!Tdjfodf!Efqu/!J!kvtu!xboufe!up!dpohsbuvmbuf!zpv!po!zpvs!ofx!qptjujpo!bt!Dibjs!pg!uif!Efqbsunfou/!!Cftu!xjtift/";
    int length = strlen(program_input);
    int size = length * sizeof(char);
    char program_output[length];

    //declare GPU memory pointers
    char * t_input;
    char * t_output;

    //allocate memory on GPU
    cudaMalloc((void **)&t_input, size);
    cudaMalloc((void **)&t_output, size);

    //transfer info to GPU
    cudaMemcpy(t_input, program_input, size, cudaMemcpyHostToDevice);

    //kernel
    cypher_thread<<<1, length>>>(t_input, t_output, length);

    //get result from GPU
    cudaMemcpy(program_output, t_output, size, cudaMemcpyDeviceToHost);

    //print output
    for(int i = 0; i < length; i++){
        printf("%c", program_output[i]);
    }

    //free gpu memory
    cudaFree(t_input);
    cudaFree(t_output);

    return 0;
}
