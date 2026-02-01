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
// paste code here
```

== Q1.4 Waveform + Frequency
+ What is the frequency of the duty cycle waveform that you are generating?

  #figure(
    // image("q1-4.png", height: 30%),
    caption: "Oscilloscope Waveform of Duty Cycle",
  )

== Q1.5 Increasing Operating Frequency
+ Can you find a way to increase the operating frequency? What are the limitations of these methods?

== Q1.6 Resolution vs Frequency Trade-off
+ What happens to the upper frequency limit if we want more duty cycle resolution? Describe the trade-off between resolution and frequency of operation.

== Q1.7 Full Range Operation
+ Can your solution achieve a full range of operation? (What happens if you try to get 0% or 100% duty cycle?) Why or why not?

== Q1.8 Sources of Error
+ For a given duty cycle, what are the sources of error in the approach you have chosen?

== Q1.9 High PWM Frequency for Motor Control
+ With respect to motor control, why would you want a high PWM frequency? What are the tradeoffs?

= #underline[Part 2: Interfacing to a DC Motor and H-Bridge]

== Q2 Circuit Schematic
+ Include a schematic of the circuit (indicating Arduino pins).

  #figure(
    // image("q2-schematic.png", height: 40%),
    caption: "Schematic of the circuit for Part 2",
  )

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
