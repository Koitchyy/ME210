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
    Pre Lab 2
  ]
  #v(1.2em)
  #text(1.1em)[
    Koichi Kimoto\
  ]
]
#v(1em)

// Add some space after the title block

#set enum(numbering: "(a)")
= Question 0.1
#v(1em)
#underline[Decide which Arduino ports and pins you will use to control the motors (all parts of the lab).]

== Part 1
- *5V pin* to potentiometer
- *GND pin* to potentiometer
- Potentiometer wiper to *A1* (to be fed analog voltage input)
- *D7 pin* to output our DIY PWM onto motor


== Part 2
- Same pins to potentiometer
- *D6 pin* (PWM pin) as outputting square wave with analogWrite() frequency connected to the 5V ENA pin on the L298.
- *D5 pin* going to IN1.
- *D4 pin* going to IN2.
- These set the logic low and high, determining motor spin direction on the L298, and can also "brake" the motor by setting to the same voltage.
- *GND* to GND of the L298.

#figure(
  image("arduinoPinout.png", height: 40%),
  caption: "Selected pins (boxed in red)",
)

= Question 0.2
#v(1em)
#underline[Decide what, if any, initialization is required for each pin.]
- Part 1:
  - Initialize D7 pin as an output pin

- Part 2:
  - Initialize D4 and D5 as output pins.







