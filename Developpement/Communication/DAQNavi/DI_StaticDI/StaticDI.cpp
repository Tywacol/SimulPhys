/*******************************************************************************
Copyright (c) 1983-2016 Advantech Co., Ltd.
********************************************************************************
THIS IS AN UNPUBLISHED WORK CONTAINING CONFIDENTIAL AND PROPRIETARY INFORMATION
WHICH IS THE PROPERTY OF ADVANTECH CORP., ANY DISCLOSURE, USE, OR REPRODUCTION,
WITHOUT WRITTEN AUTHORIZATION FROM ADVANTECH CORP., IS STRICTLY PROHIBITED. 

================================================================================
REVISION HISTORY
--------------------------------------------------------------------------------
$Log:  $

--------------------------------------------------------------------------------
$NoKeywords:  $
*/
/******************************************************************************
*
* Windows Example:
*    StaticDI.cpp
*
* Example Category:
*    DIO
*
* Description:
*    This example demonstrates how to use Static DI function.
*
* Instructions for Running:
*    1. Set the 'deviceDescription' for opening the device. 
*	  2. Set the 'profilePath' to save the profile path of being initialized device. 
*    3. Set the 'startPort' as the first port for Di scanning.
*    4. Set the 'portCount' to decide how many sequential ports to operate Di scanning.
*
* I/O Connections Overview:
*    Please refer to your hardware reference manual.
*
******************************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../inc/bdaqctrl.h"
#include "../inc/compatibility.h"
using namespace Automation::BDaq;
//-----------------------------------------------------------------------------------
// Configure the following parameters before running the demo
//-----------------------------------------------------------------------------------
typedef unsigned char byte;
#define  deviceDescription  L"USB-4750,BID#0"
const wchar_t* profilePath = L"../../profile/CortoFirstTestProfile_HalfChecked.xml";
int32    startPort = 0;
int32    portCount = 2;

inline void waitAnyKey()
{
   do{SLEEP(1);} while(!kbhit());
} 

int main(int argc, char* argv[])
{
   ErrorCode        ret = Success;
   // Step 1: Create a 'InstantDiCtrl' for DI function.
   InstantDiCtrl * instantDiCtrl = InstantDiCtrl::Create();
   do
   {
      // Step 2: select a device by device number or device description and specify the access mode.
      // in this example we use ModeWrite mode so that we can fully control the device, including configuring, sampling, etc.
      DeviceInformation devInfo(deviceDescription);
      ret = instantDiCtrl->setSelectedDevice(devInfo);
      CHK_RESULT(ret);
      ret = instantDiCtrl->LoadProfile(profilePath);//Loads a profile to initialize the device.
      CHK_RESULT(ret);

      // Step 3: Read DI ports' status and show.
      //set port dircetion
      //Array<DioPort>* dioPort = instantDiCtrl->getPorts();
      //ret = dioPort->getItem(0).setDirectionMask(Input); //Set port0 direction
      //CHK_RESULT(ret);

      printf(" Reading ports' status is in progress, any key to quit !\n\n");
      byte  bufferForReading[64] = {0};//the first element of this array is used for start port
      int8 data = 0;//data is used to the 'ReadBit'.
      //int  bit = 0;//bit is used to the 'ReadBit'.
      do
      {
         ret = instantDiCtrl->Read(startPort, portCount, bufferForReading);
         /************************************************************************/
			//ret = instantDiCtrl->ReadBit(startPort, bit, &data);
         //NOTE:
         //argument1:which port you want to contrl? For example, startPort is 0.
         //argument2:which bit you want to control? You can write 0--7, any number you want.
         //argument3:data is used to save the result.   
         /************************************************************************/
         CHK_RESULT(ret);  
         //Show ports' status
         for ( int32 i = startPort;i < startPort+portCount; ++i)
         {
            printf(" DI port %d status is: 0x%X\n\n", i, bufferForReading[i-startPort]);
            printf("DI port %d status is: 0x%X  [ReadBit] \n\n", i, data);// for 'ReadBit'
			SLEEP(1);
         }
         SLEEP(1);
      }while(!kbhit());
   }while(false);

	// Step 4: Close device and release any allocated resource.
	instantDiCtrl->Dispose();

	// If something wrong in this execution, print the error code on screen for tracking.
   if(BioFailed(ret))
   {
      printf(" Some error occurred. And the last error code is 0x%X.\n", ret);
      waitAnyKey();
   }
   return 0;
}
