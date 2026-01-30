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
    Lab 2 - Op-Amps and Comparators
  ]
  #v(1.2em)
  #text(1.1em)[
    Koichi Kimoto\
  ]
]
#v(1em)

// Add some space after the title block
#set enum(numbering: "(a)")

= #underline[Part 1: The Arduino as a Controllable Signal Source]

== Q1.3 Variable Frequency Control via Potentiometers
+ Why would building a unity gain buffer for this signal (using the MCP6294) be a bad idea? \
  *The unity gain buffer for the signal would be a bad idea because even "Rail-to-Rail" op-amps don't output a perfect 0-5V range. They have a small internal voltage drop (saturation voltage), meaning if 0V is inputted, the op-amp might only be able to go down to 0.02V, and for 5V it might only reach 4.98V, so it is just better to wire the output of the potentiometer directly.*

+ What limitation would this impose? \
  *The limitation would be a reduction in the usable signal range (lose the ability to read the absolute minimum and maximum values).*

== Q1.5 Driving an IR LED via interrupt timer
+ What resistor sizing did you choose? \ \
  $
    R = (V_(C C) - V_F)/I_F
  $
  In the worst case, this would be:
  *$ R = (5 op("V")) / (20 op("mA")) = 250 Omega => 270 Omega op("     (Including ±5% resistor tolerance)") $*

== Q1.6 Captured Waveform

#figure(
  image("q1-6.png", height: 30%),
  caption: "Signal between IR LED and load resistor",
)

= #underline[Part 2: The Phototransistor]

== Q2.2 KiCAD Schematic of Phototransistor - IR LED setup

#figure(
  image("q2-2.png"),
  caption: "KiCAD Schematic of Phototransistor - IR LED setup",
)


== Q2.3 Waveform of Phototransistor output

#figure(
  image("q2-3.png", height: 40%),
  caption: "Waveform of Phototransistor output",
)

== Q2.5 KiCAD Schematic of 2.4

#figure(
  image("q2-5.png", height: 40%),
  caption: "KiCAD Schematic of 2.4",
)

== Q2.6 Waveform of Phototransistor Sinking configuration

#figure(
  image("q2-6.png"),
  caption: "Waveform of Phototransistor Sinking configuration",
)

== Q2.7 Differences in Captured Waveforms
+ #underline[Explain the differences between the two captured waveforms in parts 2.3 and 2.6.]

  In part 2.3, the voltage signal was taken at the output of the photoresistor, before the resistance, so based on the voltage at $V_(o u t)$, the current should be around
  $
    I = V / R = (0.75 V) / (1 k Omega) = 0.75 op("mA")
  $
  and the signal we are getting matters on how much the voltage drop is over the resistance connecting the node to ground.

  In part 2.7 however, the voltage signal was taken at the output of the resistance, meaning that the signal we are getting now is dependent on
  $
    V_(op("out")) = 5V - V_R
  $

  So the full 5V minus the voltage drop over the resistance is the signal we are getting.

  If we calculate the current, this is:
  $
    I = (5V - V_R) / R = (5V - 4.3 V) / (1 k Omega) = (0.7 V) / (1 k Omega) = 0.7 op("mA")
  $

  which has similar current as the sourcing configuration, as expected.
  \ \ \
== Q2.9
+ Waveform of Phototransistor with 10kΩ Load Resistance Sourcing Configuration

  #figure(
    image("q2-9.png"),
    caption: "Waveform of Phototransistor with 10kΩ Load Resistance Sourcing Configuration",
  )

+ What is the impact of changing the load resistor to 10kΩ?

  *The current is now lower, since if the phototransistor were to output the same current, over 10kΩ, the voltage drop would be around $ V = 0.7 op("mA") times 10k Omega = 7 V $
  which is higher than the 5V limit, and so the voltage is clipped to 5V meaning the phototransistor outputs a lower current:
  $ I = (V_R) / R = (4.4 V) / (10 k Omega) = 0.44 op("mA") $*
\ \ \ \ \ \ \ \ \ \ \
== Q2.11
+ Waveform of Phototransistor with 100Ω Load Resistance Sourcing Configuration
  #figure(
    image("q2-11.png"),
    caption: "Waveform of Phototransistor with 100Ω Load Resistance Sourcing Configuration",
  )
+ What is the impact of changing the load resistor to 100Ω? \ \
  *Now the current outputted by the phototransistor is higher, since with a 100 $Omega$ resistance, we are seeing around 80 mV of voltage across the resistor, which makes sense given:
  $ I = V / R = (80 m V) / (100 Omega) = 0.8 op("mA") $
  and now the phototransistor is less limited by the resistance in series with it (the current limiting resistor).*

= #underline[Part 3: Op-Amps]

== Q3.1 KiCAD Schematic of non-inverting op-amp configuration with a gain of about 10
#figure(
  image("q3-1.png"),
  caption: "KiCAD Schematic of non-inverting op-amp configuration with a gain of about 10",
)

== Q3.3 Waveform of Op-amp Output
#figure(
  image("q3-3.png", height: 40%),
  caption: "Waveform of non-inverting op-amp configuration.",
)

== Q3.4
- What happens to the amplitude of the signal at the output of the op-amp after reversing the Phototransistor polarity?

  The amplitude significantly decreases (by an order of magnitude) as seen in the waveform below.
  #figure(
    image("q3-4.png", height: 40%),
    caption: "Waveform of same schematic in Q3.3, but with phototransistor polarity switched.",
  )

== Q3.5
- What is the measured gain in the previous orientation? \
  From Q2.3, we had 0.75V when the 1kΩ resistor was used. In Q3.3, we can observe this is amplified to around 5.0V, so the *gain is around $(5.0V)/(0.75V)=6.67$*.

- Does it agree with the calculated gain for your design? \
  *No this does not match the calculated gain of 10* (which would result in 0.75V). This is because the gain *hits the supply voltage rail of 5.0V* of the op-amp.

== Q3.6
- Describe the oscilloscope settings you used to make the measurements in part 3.5. Why is the configuration you chose the best configuration for making this measurement? If not, explain the deviation(s). \
  The oscilloscope was set so that the

= #underline[Part 4: Trans-resistive Amplifiers]

== Q4.1 Trans-resistive Amplifier Schematic
#figure(
  image("q4-1.png", height: 40%),
  caption: "KiCAD Schematic of Trans-resistive Amplifier",
) \
- Based on the datasheet, why might a VCE of 2.5V not be ideal for the LTR-3208E? \
  *The VCE of 2.5V is not ideal for the LTR-3208E because the datasheet states that the $V_(C E)$ test condition is at $5V$, meaning that we may not be getting the expected current from the phototransistor when only supplied with $V_(C E) = 2.5V$.*

== Q4.2 Expected Output Calculation
#figure(
  image("datasheet.png"),
  caption: "Irradiance vs collector current from LTR-3208E datasheet.",
) \
+ What would you expect to be the output of your transresistive amplifier to be at 1mW/cm² of irradiance on the phototransistor? \
  *A square wave going from 2.5V (IR LED OFF) to 1.5V (IR LED ON).*
  From the datasheet (fig. 12), at 1mW/cm², we have around 1mA of current going through the feedback resistor which we set at 1kΩ, so we would expect around 1v in amplitude (drops from $V_op("REF") = 2.5V$, when current is flowing through (when IR LED is on). \ \
+ What about at 5mW/cm²? \
  It would be *a square wave going from 2.5V (IR LED OFF) to 0V (IR LED ON) *since from Figure 12, the current would be 4.5mA at 5mW/cm², so the max voltage drop across the feedback resistor would be 4.5V, but since the $V_op("REF") = 2.5V$, this is railed. \ \ \ \ \ \ \ \ \

== Q4.4 Annotated Waveform at Op-amp Output
+ Captured Waveform with annotations
  #figure(
    image("q4-4.png"),
    caption: "Annotated waveform at op-amp output.",
  ) \
+ How does this differ from the output in Part 3? \
  The output in part 3 has an signal that is amplified when there is current going through the phototransistor, so the peaks are when the phototransistor is on, and it goes to 0V when the phototransistor is off. However, in this configuration, the phototransistor turning on actually brings down the voltage at $V_op("OUT")$, so the peaks are when the phototransistor is OFF, and the 0V is when the phototransistor is ON.\
+ How could we make the signal amplitude (the difference between the minimum and maximum output voltages) larger?
  Since we are limited by the railing, we should increase the voltage at the non-inverting input of the op-amp by adjusting the resistors in Figure 11 such that the voltage divider gives a higher $V_op("REF")$.

= #underline[Part 5: Comparators]

== Q5.2 Comparator Schematic
#figure(
  image("q5-2.png", height: 30%),
  caption: "Comparator Schematic from part 5.",
) \

== Q5.3 Trip Points
+ Empirically, what are the trip points for your circuit? \
  *The trip points are at 2.37V and 2.62V.*

== Q5.5 Dual Waveform (Op-amp + Comparator)
#figure(
  image("q5-5.png", height: 40%),
  caption: "Dual Waveform with the Green as the Op-amp output and Yellow as the Comparator output. ",
)

= #underline[Part 6: Capturing the Output]

== Q6.2 - Q6.4 Code Listing
+ Include a listing of your code for parts 6.2 to 6.4 (CountFallingEdges, ISR, Frequency Calculation).

#codly(
  highlights: (
    // (line: 1, start: 1, fill: red),
  ),
)
```C
#define USE_TIMER_1     true
#include "TimerInterrupt.h"
#include "ISR_Timer.h"
#define OUTPUT_PIN 10
#define PIN_SIGNAL_IN 2
#define POT_PIN    A1

volatile bool toggleState = LOW;
volatile uint16_t counter = 0;
unsigned long last_printed_time = 0;
float last_freq = -1.0;

void toggle(){
  toggleState = !toggleState;
  digitalWrite(OUTPUT_PIN, toggleState);
}

// ISR
void CountFallingEdges(){
  counter++;
}

float calc_freq(uint16_t edge_counts, uint16_t time_ms) {
  if (time_ms==0) return 0;
  return edge_counts / (time_ms / 1000.0);
}
void setup(){
  Serial.begin(9600);
  // Setting the timer for frequency
  pinMode(OUTPUT_PIN, OUTPUT);
  ITimer1.init();
  // ITimer1.setFrequency(2500, toggle);

  // Counting falling edges
  pinMode(PIN_SIGNAL_IN, INPUT);
  attachInterrupt(digitalPinToInterrupt(PIN_SIGNAL_IN), CountFallingEdges, FALLING);
}

void loop(){
  // Count edges
  if (millis() - last_printed_time > 1000) {
    // want no interrupts when resetting counter and time
    noInterrupts();
    unsigned long counter_copy = counter;
    unsigned long current_time = millis();
    counter=0;
    interrupts();

    unsigned long elapsed_time = current_time - last_printed_time;
    float freq = calc_freq(counter_copy, elapsed_time);

    Serial.print("Frequency (Hz): ");
    Serial.println(freq);
    counter = 0;
    last_printed_time = current_time;
  }

  // Read Potentiometer to get frequency
  int pot_val = analogRead(POT_PIN);
  float freq = map(pot_val, 0, 1023, 50, 12500); // Hz
  float timer_freq = 2*freq;
  // hysteresis
  if (abs(timer_freq - last_freq) > 50.0) {
    last_freq = timer_freq;
    ITimer1.detachInterrupt();
    ITimer1.attachInterrupt(timer_freq, toggle);
  }
}
```
