#define USE_TIMER_1 true
#include "ISR_Timer.h"
#include "TimerInterrupt.h"
#define OUTPUT_PIN 10
#define POT_PIN A1

// State variables
volatile bool toggleState = LOW;
float last_freq = -1.0;

// Interrupt Service Routine to toggle the pin
void toggle() {
  toggleState = !toggleState;
  digitalWrite(OUTPUT_PIN, toggleState);
}

void setup() {
  Serial.begin(9600);
  pinMode(OUTPUT_PIN, OUTPUT);
  ITimer1.init();
}

void loop() {
  // Read Potentiometer to get duty cycle resolution
  int val = analogRead(POT_PIN); // already 10 bit res

  // hysteresis
  if (abs(duty - val) > 2) {
    duty = val / 1024;
  }

  ITimer1.detachInterrupt();
  ITimer1.attachInterrupt(freq * (1 - duty), toggle);

  // If any key pressed, stop PWM
  if (Serial.available() > 0) {
    ITimer1.detachInterrupt();
  }
}