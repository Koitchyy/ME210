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
    Lab 1 - Programming Raptors on a Sparki
  ]
  #v(1.2em)
  #text(1.1em)[
    Koichi Kimoto\
  ]
]
#v(1em)

// Add some space after the title block
#set enum(numbering: "(a)")
== Q1.3 Variable Frequency Control via Potentiometers
+ Why would building a unity gain buffer for this signal (using the MCP6294) be a bad idea?
  The unity gain buffer for the signal would be a bad idea because if the potentiometer was set to the lowest resistance, then there would be a high current passing through to the analog pin of the arduino, damaging the terminal.


+ What limitation would this impose? \
  The limitation would be on potentiometer, where the wiper could only be turned to the point where up to 20mA of current can pass through.

  #figure(
    image("Q1_3Sch.png"),
    caption: "Waveform from adder_tb.v",
  )

Code \
#codly(highlights: (
  (line: 4, start: 3, end: 27, fill: red),
  (line: 11, start: 3, fill: red),
))
```C
blah blah blah
```  \\

= #underline[Part 1: The Arduino as a Controllable Signal Source]

== Q1.5 Driving an IR LED via interrupt timer
+ What resistor sizing did you choose?

== Q1.6 Captured Waveform

= #underline[Part 2: The Phototransistor]

== Q2.2 KiCAD Schematic of Phototransistor - IR LED setup

== Q2.3 Waveform of Phototransistor output

== Q2.5 KiCAD Schematic of 2.4

== Q2.6 Waveform of Phototransistor Sinking configuration

== Q2.7 Differences in Captured Waveforms
+ Explain the differences between the two captured waveforms in parts 2.3 and 2.6.

== Q2.9
+ Waveform of Phototransistor with 10kΩ Load Resistance Sourcing Configuration
+ What is the impact of changing the load resistor to 10kΩ?

== Q2.11
+ Waveform of Phototransistor with 100Ω Load Resistance Sourcing Configuration
+ What is the impact of changing the load resistor to 100Ω?

= #underline[Part 3: Op-Amps]

== Q3.1 KiCAD Schematic of non-inverting op-amp configuration with a gain of about 10

== Q3.3 Waveform of Op-amp Output


== Q3.4
- What happens to the amplitude of the signal at the output of the op-amp after reversing the Phototransistor polarity?

== Q3.5
- What is the measured gain in the previous orientation?
- Does it agree with the calculated gain for your design?

== Q3.6
- Describe the oscilloscope settings you used to make the measurements in part 3.5. Why is the
configuration you chose the best configuration for making this measurement?
If not, explain the deviation(s).

= #underline[Part 4: Trans-resistive Amplifiers]

== Q4.1 Trans-resistive Amplifier Schematic
- KiCAD Schematic of Trans-resistive Amplifier
- Based on the datasheet, why might a VCE of 2.5V not be ideal for the LTR-3208E?

== Q4.2 Expected Output Calculation
+ What would you expect to be the output of your transresistive amplifier to be at 1mW/cm² of irradiance on the phototransistor?
+ What about at 5mW/cm²?

== Q4.4 Annotated Waveform at Op-amp Output
+ Captured Waveform with annotations
+ How does this differ from the output in Part 3?
+ How could we make the signal amplitude (the difference between the minimum and maximum output voltages) larger?

= #underline[Part 5: Comparators]

== Q5.2 Comparator Schematic

== Q5.3 Trip Points
+ Empirically, what are the trip points for your circuit?

== Q5.5 Dual Waveform (Op-amp + Comparator)

= #underline[Part 6: Capturing the Output]

== Q6.2 - Q6.4 Code Listing
+ Include a listing of your code for parts 6.2 to 6.4 (CountFallingEdges, ISR, Frequency Calculation).

#codly(highlights: (
  (line: 1, start: 1, fill: red),
))
```C
// Paste your code here
```
