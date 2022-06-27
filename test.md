# Load Generator
## 1. General Description
#### This document is about a general description of load generator where a CBB model is used to generate load, configure the number of DSPs used, allocate some memory through the buffers and also use the allocated memory while the thread is running.

## 2. Modules
#### The CE tests for the bfcNrMdbfCe will set up the following modules:
- loadTor
- timingTor
- signalHandlers
- testConfig

## 3. Ports and Connections
#### Ports are created to establish a connnection between a BFC and TEST, inside CETEST. **initLoadPi.cig** file is created to define a Protocol and LOAD_GEN_IND Signal using *InOut <LoadGeneratorConfigS, void> LOAD_GEN_IND*. In **BFCNRMDBFCE_TEST_loadTor.cbc** *initLoadPort* is created. 

#### In **BFCNRMDBFCE_BFC_sc.csc** file initLoadPort is assigned with initLoadPi protocol and a connection between BFC and LoadTor is established using *initLoadPort <--> loadTor.initLoadPort*.

#### A port for TEST is created and a connection between timingTor and TEST is established using *initLoadPort <--> timingTor.timingLoadPort* in **BFCNRMDBFCE_TEST_sc.csc** and another connection is established between BFC and TEST using *bfc.initLoadPort <--> test.initLoadPort* in **BFCNRMDBFCE_CETEST_sc.csc**. ***(insert a diagram showing ports and connections)***.

## 4. BFC and LoadTor:
#### A Tor file named bBFCNRMDBFCE_TEST_loadTor.cbc is created insided BFC, where CBC stands for CBB Behavior Class (CBC). A connection is established between BFC and loadTor using a protocol *initLoadPi* and port *initLoadPort*. LOAD_GEN_IND Signal is defined and is mapped to an activity function.

#### A structure named LoadGeneratorConfigS is created in **initLoadPi.ifx** file with all parameters needed for generating load. This structure includes parameters like startTimeUs, endTimeUs, taskSize and noOfBuffers[].

### A) Signal Handler Function:
#### A signal handler function named *BFCNRMDBFCE_TEST_LOADTOR_handleLoadGenInd()* is created for loadTor. This function uses the information from Payload received from the signal helping in allocating the required number of desired buffers of sizes varying from 16 bits to 1024 bits, which is followed by performing read and write operations on allocated memory. Then the memory is freed to avoid the memoryleak issues.

#### This function takes CM Pointer (*cmThis_p*) and a received signal (*signIn_p*) as parameters. LAT function is used to trace the signal handler function in a Simulated Hardware. A structure variable loadConfiguration is created. An array of buffers, allocatedBuffers_p[] are created in CM memory. The information carried by the payload is read through the received signal using *cbb_signal_readPayLoad(signIn_p, &loadConfigiuration, payLoadSizeInWords);*

#### The variables used in the function are given below:
- **timeStampBegin** - *this variable is assigned with LPP_getBFN(); to save the current time*.
- **memReadArray[]** - *an array used to read the memory.*
- **memWriteIndex** - *a variable used in loop helping in read and write operations on allocated memory.*
- **bufferSizeIndex** - *an iterative variable in loop helping in allocating the buffersize.*
- **bufferStoreIndex** - *an iterative variable helping in running the loop according to the required number of buffers.*
- **bufferStore** - *a variable used in storing the required number of buffers.*
- **bufferSize** - *a varable used to store the value of buffer size.*
- **timeDiff** - *this varable is assigned to LPP_bfnDiff(timeStampBegin, LPPgetBFN(), uS); storing the value of time difference between current time and begining time in micro seconds.*

#### The pointer array allocatedBuffers_p[]is used in memory alloacation. athe variable bufferSizeIndex takes 7 values varying from 0 to 7, where 0 is used for allocating 16 bits of memory, 1 allocates 32 bit and so on till 7, where allocatedBuffers_p[7] allocates 1024 bits of memory. Number of buffers needed is controlled by using the array noOfBuffers[].

#### Memory allocation is done by using a while loop inside a for loop. The allocation is done by using *allocatedBuffers_p[bufferStoreIndex - 1] = LPP_allocCm(pow(2, (4 + bufferSizeIndex)));*. The operation pow(2, (4 + bufferSizeIndex)) is used to allocate the memory according to the requested buffer size. If the bufferSizeIndex is 0, then it allocates 16 bits (2 raised to the power of 4 = 16) of memory.

### Example:
#### Consider a case where 3 buffers of 16 bit size and 5 buffers of 64 bit size are needed. Then noOfBuffers[] = [3, 0, 5, 0, 0, 0, 0]. In this array 3 and 5 indicates the number of buffers needed. Zeroth position refers to 16 Bit buffer, First position refers 32 bit and similarly seventh bit refers to 1024 bits. Here the loop will be executed for three times and thus allocating a size of three 16 bit memory and 0 times for 32 bit and again 5 times for 64 bit memory and zero times for other buffer sizes.

#### Write and Read operations are performed on the allocated memory and further we will use similar loop to free the memory using *(void) LPP_freeCmMem((__cm void**) &allocatedBuffers_p[bufferStoreIndex -1]);*. this step is must to avoid crashing of program due to memory leak or memory overflow.

### B) Prepare Calculation Function:
#### *BFCNRMDBFCE_TEST_LOADTOR_prepareCalculation()* function takes CM Pointer (*cmThis_p*) and a received signal (*signIn_p*) as parameters. This function is used to set the number of DSPs used by assigning the Vector Size of activity function with taskSize value, by using BFCNRMDBFCE_TEST_LOADTOR_LoadCalcActivity_myVectorSize_set(sizeUp); where sizeUp is the value of the taskSize.

### C) Post Process Calculation:
#### After the Payload is used, it is important to free the payload to avoid the memory leak issues. *BFCNRMDBFCE_TEST_LOADTOR_postProcessCalculation()*  also takes CM Pointer (*cmThis_p*) and a received signal (*signIn_p*) as parameters. cbb_signal_freePayLoad(signIn_p); is used to free the PayLoad.

### D) Activity Function:
#### BFCNRMDBFCE_TEST_loadTor::LoadCalActivity() function belongs to the CBC BFCNRMDBFCE_TEST_loadTor. The number of DSPs used is allocated and this functions helps in executing the Signal Hadler function, Prepare Calculation functiona and Post Prepare Calculation Function.







## Abrevations:
- **CBC** - *CBB Behavior Class*
- **CSC** - *CBB Structure Class*


