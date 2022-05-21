#define NEW_PRINTF_SEMANTICS
#include "printf.h"

configuration LedCodeAppC
{
}
implementation
{
  components MainC, LedCodeC, LedsC;
  components new TimerMilliC() as Timer0;
  components SerialPrintfC;
  components SerialStartC;


  LedCodeC -> MainC.Boot;

  LedCodeC.Timer0 -> Timer0;
  LedCodeC.Leds -> LedsC;
  
}
