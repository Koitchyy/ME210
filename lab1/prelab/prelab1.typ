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
    PreLab1
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
#underline[What are the values of resistors with the following color codes:]

+ #text(fill: red)[red red red]: *2.2 k$Omega$*
+ #text(fill: rgb("#6d1010"))[brown] #text(fill: black)[black] #text(fill: red)[red]: *1 k$Omega$*
+ #text(fill: yellow)[yellow] #text(fill: rgb("#8b1fff"))[violet] #text(fill: orange)[orange]: *47 k$Omega$*
+ #text(fill: rgb("#6d1010"))[brown] #text(fill: black)[black] #text(fill: green)[green]: *1 M$Omega$*

= Question 0.2
#v(1em)
#underline[What are the values of the capacitors with the following designations?]

+ 223: $22 times 10^3$ pF = *22 nF*
+ 476: $47 times 10^6$ pF = *47 uF*

= Question 0.3
#v(1em)
+ #underline[Draw a schematic of the configuration you will use for Part 4 using KiCad.]

#figure(
  image("q4.png", height: 43%),
  caption: "Waveform from adder_tb.v",
)





= Question 0.4
#v(1em)
#underline[Write, compile, and upload a program that outputs "Hello, World!" to the serial terminal once every second on the Arduino.]

```C
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  while(!Serial);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println("Hello, World!");
  delay(1000);
}
```
