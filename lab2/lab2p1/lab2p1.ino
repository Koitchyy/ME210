#define USE_TIMER_1 true
#include "TimerInterrupt.h"

#define OUTPUT_PIN 10
#define POT_PIN A1

const float FREQ = 490.0;

volatile float on_freq = 980.0; 
volatile float off_freq = 980.0;
volatile int current_duty = 0;

void pulse_high();
void pulse_low();

void setup() {
  Serial.begin(9600);
  pinMode(OUTPUT_PIN, OUTPUT);

  ITimer1.init();
  pulse_high();
}

void loop() {
  int val = analogRead(POT_PIN);

  // hysteresis
  if (abs(val - current_duty) > 2) {
    current_duty = val;
    float duty_pct = current_duty / 1023.0;

    // Constrain to avoid division by zero or infinite frequencies
    if (duty_pct < 0.002) duty_pct = 0.002;
    if (duty_pct > 0.998) duty_pct = 0.998;

    noInterrupts();
    on_freq = FREQ / duty_pct;
    off_freq = FREQ / (1.0 - duty_pct);
    interrupts();
  }

  // Emergency Stop
  if (Serial.available()) {
    ITimer1.stopTimer();
    digitalWrite(OUTPUT_PIN, LOW);
    while(1); 
  }
}

void pulse_high() {
  digitalWrite(OUTPUT_PIN, HIGH);
  ITimer1.setFrequency(on_freq, pulse_low);
}

void pulse_low() {
  digitalWrite(OUTPUT_PIN, LOW);
  ITimer1.setFrequency(off_freq, pulse_high);
}




// kind of working code

// #define USE_TIMER_1 true
// #include "ISR_Timer.h"
// #include <TimerInterrupt.h>

// #define OUTPUT_PIN 10
// #define POT_PIN    A1

// #define PWM_FREQ   490.0
// #define PERIOD_US  (1000000.0 / PWM_FREQ)

// volatile bool pinState = LOW;
// volatile long on_us  = PERIOD_US * 0.5;
// volatile long off_us = PERIOD_US * 0.5;
// int last_val = -10;

// void toggle() {
//   pinState = !pinState;
//   digitalWrite(OUTPUT_PIN, pinState);
//   if (pinState == HIGH) {
//     ITimer1.attachInterruptInterval(on_us, toggle);
//   }
//   else {
//     ITimer1.attachInterruptInterval(off_us, toggle);
//   }
// }

// void setup() {
//   Serial.begin(9600);
  
//   pinMode(OUTPUT_PIN, OUTPUT);
//   ITimer1.init();
//   toggle();
// }

// void loop() {
//   // Read Potentiometer to get duty cycle
//   int val = analogRead(POT_PIN); 
//   // hysteresis

//   on_us = map(val, 0, 1023, 0.0, PERIOD_US);
//   off_us = PERIOD_US - on_us;

//   // stop if key pressed
//   if (Serial.available()) {
//     while (Serial.available()) Serial.read();
//     ITimer1.disableTimer();
//     digitalWrite(OUTPUT_PIN, LOW);
//   }
// }



