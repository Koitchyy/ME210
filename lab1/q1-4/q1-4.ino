#define USE_TIMER_1     true
#define USE_TIMER_2     false
#define USE_TIMER_3     false
#define USE_TIMER_4     false
#define USE_TIMER_5     false

// #include <TimerInterrupt.h>

// #define PIN_ACTIVE 10
// #define POT_PIN    A1

// volatile bool pinState = false;
// float last_freq = -1.0;

// void toggle() {
//   PORTB ^= (1 << PB2); // bitwise manipulating to toggle pin10
// }

// void setup() {
//   Serial.begin(9600);
  
//   pinMode(PIN_ACTIVE, OUTPUT);
//   digitalWrite(PIN_ACTIVE, LOW);

//   ITimer1.init();
// }

// void loop() {
//   // Read Potentiometer to get frequency
//   int pot_val = analogRead(POT_PIN);
//   long freq = map(pot_val, 0, 1023, 50, 12500); // Hz

//   float timer_freq = 2*freq;

//   // hysteresis
//   if (abs(timer_freq - last_freq) > 50.0) {
//     last_freq = timer_freq;

//     ITimer1.detachInterrupt();
//     ITimer1.attachInterrupt(timer_freq, toggle);
//   }
// }


#include "TimerInterrupt.h"
#include "ISR_Timer.h"
#define OUTPUT_PIN 10
volatile bool toggleState = LOW;
void toggle(){
  toggleState = !toggleState;
  digitalWrite(OUTPUT_PIN, toggleState);
}
void setup(){
  pinMode(OUTPUT_PIN, OUTPUT);
  ITimer1.init();
  ITimer1.setFrequency(2500, toggle);
}
void loop(){
}
