#include <math.h>
#include "config.h"
__device__ float sigmf( float val)
{
     return 1/(1+exp(-val));
    
}

__device__ void softmax(float *out,int l)
{
double s=0;
for( int i=0;i<l;i++)
    s=s+exp(out[i]); 
for( int i=0;i<l;i++)
{
   out[i]=expf(out[i])/s; 

if(out[i]!=out[i])
out[i]=1;
}

}


__device__ void computeNodeOut(float *out,int number,float *w,const float* Inputs)
{
int tx=threadIdx.x;
float sum=0;
if(number<InputCount)
{
out[number]=Inputs[tx*InputCount+number];
}
else
{
for(int i=0;i<number;i++)
sum=sum+w[i*n+number-i*(i+1)/2]*out[i];

sum=sum+w[number*n+number-number*(number+1)/2];
if(number>=n-TargetCount)
out[number]=sum;
  else
out[number]=sigmf(sum);
                
  }


}




__global__ void cost( float *costMatrix,const float* pop,const float* Inputs,const float* Targets)
{
    int bx = blockIdx.x;
    int tx = threadIdx.x;
float w[genome_length];
float NodeOut[n];
float out[TargetCount];

if(tx==2)
{
for(int i=0;i<genome_length;i++)
    w[i]=pop[bx*genome_length+i];


for(int i=0;i<n;i++)
{
computeNodeOut(NodeOut,i,w,Inputs);


}



float cost=0;
for(int i=0;i<TargetCount;i++)
out[TargetCount-i-1]=NodeOut[n-i-1];

softmax(out,TargetCount);

for(int i=0;i<TargetCount;i++)
{
if(out[i]<0.00000000001)
{
cost=cost-Targets[tx*TargetCount+i]*(-241.64);
}
else
{
cost=cost-Targets[tx*TargetCount+i]*(log2f(out[i]));
}
}

atomicAdd(&costMatrix[bx],cost);
}


}


