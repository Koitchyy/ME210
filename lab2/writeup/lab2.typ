#import "@preview/diverential:0.2.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(zebra-fill: none, languages: (
  C: (name: "C", icon: "", color: rgb("#129610")),
))

#set page(
  width: 8.5in,
  height: 11in,
  margin: (left: 1in, right: 1in, top: 1in, bottom: 1in),
)

#set page(header: {
  // Create a two-column grid for left/right alignment
  grid(
    columns: (1fr, 1fr),
    [Stanford University | Mechanical Engineering], align(right)[Winter 2026],
  )
  // Add the rule below the header
  line(length: 100%, stroke: 0.4pt)
  v(1em) // Provides padding equivalent to \headsep
})
// \parskip 6pt \parindent 0in
#set par(first-line-indent: 0pt)
#set block(spacing: 6pt)

// \NewDocumentCommand{\codeword}{v}{...}
// We define a function in Typst.
// This version takes content and styles it.
#let codeword(content) = {
  text(font: "Courier New", fill: blue, content)
}

#align(center)[
  #text(1.5em, weight: "bold")[
    ME 210: Intro to Mechatronics \
    Lab 2
  ]
  #v(1.2em)
  #text(1.1em)[
    Koichi Kimoto, Julia Jiang\
  ]
]
#v(1em)

// Add some space after the title block

#set enum(numbering: "(a)")
= #underline[Part 1: Pulse Width Modulation]

== Q1 Source Code

#codly(
  highlights: (
    // (line: 1, start: 1, fill: red),
  ),
)
```C
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
```

== Q1.4 Waveform + Frequency
+ What is the frequency of the duty cycle waveform that you are generating?
490Hz 
// #figure(
//   // image("q1-4.png", height: 30%),
//   // caption: "Oscilloscope Waveform of Duty Cycle",
// )

== Q1.5 Increasing Operating Frequency
+ Can you find a way to increase the operating frequency? What are the limitations of these methods?

We can decrease resolution in order to increase operating frequency. However, this translates to coarser control over the motor speed. Also, as frequency increases, the computer spends all its time entering and exiting the ISR and has no time to run the main loop, which causes the system to lock up. 


== Q1.6 Resolution vs Frequency Trade-off
+ What happens to the upper frequency limit if we want more duty cycle resolution? Describe the trade-off between resolution and frequency of operation. 

If we want more duty cycle resolution, the upper frequency limit decreases because the hardware counter has to count higher (for more resolution) in each cycle, which takes more time and decreases the number of cycles possible in each second (frequency).


== Q1.7 Full Range Operation
+ Can your solution achieve a full range of operation? (What happens if you try to get 0% or 100% duty cycle?) Why or why not?

At 0% or 100% duty cycle, one of the on/off intervals becomes zero, which cannot be scheduled by a timer interrupt. At the limits of 0% and 100%, the waveform has very short "blips" rather than a flat line at high or low. On the oscilloscope, as we make the duty cycle approach 0%, the output blips high and when we make the duty cycle approach 100%, the output blips at low. 


== Q1.8 Sources of Error
+ For a given duty cycle, what are the sources of error in the approach you have chosen?

It takes time to execute the code inside the toggle function, which makes the output waveform wider than calculated.

== Q1.9 High PWM Frequency for Motor Control
+ With respect to motor control, why would you want a high PWM frequency? What are the tradeoffs?

A higher PWM frequency decreases ripple because there is less time for the current to drop between pulses, but this lowers the resolution and generates more heat because the components switch on and off faster. 

= #underline[Part 2: Interfacing to a DC Motor and H-Bridge]

== Q2 Circuit Schematic
+ Include a schematic of the circuit (indicating Arduino pins).

// #figure(
//   // image("q2-schematic.png", height: 40%),
//   caption: "Schematic of the circuit for Part 2",
// )

== Q2 Source Code
+ Include a listing of the source code used to drive the motor using the L298.

#codly(
  highlights: (
    // (line: 1, start: 1, fill: red),
  ),
)
```C
// paste part 2 code here
```

== Q2 Schematic
#image("schematic.png")