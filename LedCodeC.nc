// libraries and headers section 
#include "Timer.h"
#include "printf.h"	

// variable declaration section

uint32_t person_code = 10000000;
uint8_t led_to_toggle = 0;
uint8_t led_status[3];
uint32_t remain= 10000000;
uint8_t i=0;

// module declaration section

module LedCodeC @safe()
{
	  uses interface Timer<TMilli> as Timer0;
	  uses interface Leds;
	  uses interface Boot;
}

// implementation section

implementation
{
  event void Boot.booted()
  {
    
    call Timer0.startPeriodic( 1000 );
    remain=person_code;
    printf("%d,%d,%d\n",led_status[0],led_status[1],led_status[2]);
    //printf("person_code: %lu \n", (unsigned long)person_code);  used for debug purposes
    //printf("remain: %lu \n", (unsigned long)remain); used for debug purposes
  }

  event void Timer0.fired()
  {
    i=i+1;
    
    // set as periodic value 60000 is not allowed and therefore to wait for a minute it's possible to repeat a second timer for 60 times with this structure
    if (i==59)
    {
		// if the remain is different than zero means that elaboration is not completed
		
		if (remain!=0)
		{
			led_to_toggle=remain%3; // operation to calculate what led must be toggled
		    if (led_to_toggle==0)  
		    {
		        call Leds.led0Toggle(); //effective led toggle command
		        // if condition to store the actual status of the led in order to make this information available to be sent over to node-red
		        if (led_status[0]==1)
		        {
		            led_status[0]=0;
		        }
		        else
		        {
		            led_status[0]=1;
		        }
		        printf("%d,%d,%d\n",led_status[0],led_status[1],led_status[2]); // command to print on the serial console the message later analyzed by node-red
		    }
		    else if (led_to_toggle == 1)
		    {
		        call Leds.led1Toggle(); //effective led toggle command
		        // if condition to store the actual status of the led in order to make this information available to be sent over to node-red
		        if (led_status[1]==1)
		        {
		            led_status[1]=0;
		        }
		        else
		        {
		            led_status[1]=1;
		        }
		        printf("%d,%d,%d\n",led_status[0],led_status[1],led_status[2]); // command to print on the serial console the message later analyzed by node-red
		    }
		    else if (led_to_toggle==2)
		    {
		        call Leds.led2Toggle(); //effective led toggle command
		        // if condition to store the actual status of the led in order to make this information available to be sent over to node-red
		        if (led_status[2]==1)
		        {
		            led_status[2]=0;
		        }
		        else
		        {
		            led_status[2]=1;
		        }
		        printf("%d,%d,%d\n",led_status[0],led_status[1],led_status[2]); // command to print on the serial console the message later analyzed by node-red
		    }
		    else
		    {
		        //printf("ERROR");used for debug purposes
		    }
		}
        if (remain == 0)
        {
            call Timer0.stop(); // command to stop the timer from being fired another time since the elaboration is finished
            //printf("FINE");used for debug purposes
        }
        remain=remain/3; //every step the remain value is updated with the result of the division by 3
		i=0; // i is wiped to restart the reset properly the timer.
	}
    
  }
  
}
