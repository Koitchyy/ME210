#import "@preview/diverential:0.2.0": *
#show: codly-init.with()


#set page(
  width: 8.5in,
  height: 11in,
  margin: (left: 1in, right: 1in, top: 1in, bottom: 1in),
)

#set page(
  header: {
    // Create a two-column grid for left/right alignment
    grid(
      columns: (1fr, 1fr),
      [Stanford University | Mechanical Engineering],
      align(right)[Winter 2026]
    )
    // Add the rule below the header
    line(length: 100%, stroke: 0.4pt)
    v(1em) // Provides padding equivalent to \headsep
  }
)
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
    Lab 0
  ]
  #v(1.2em)
  #text(1.1em)[
    Koichi Kimoto\
  ]
]
  #v(2em)

// Add some space after the title block
#set enum(numbering: "(a)")

= 1. 
+ Q2.5 - Why doesn't the LED blink at 0.5Hz? \ \

Because in: \ \

#raw(lang: "python", numbering: true)[
def fibonacci(n):
    a, b = 0, 1
    while a < n:
        print(a, end=' ')
        a, b = b, a + b
    print()

fibonacci(100)
]

```C 
void handleMoveForward(void) {
raptor.LeftMtrSpeed(HALF_SPEED);
raptor.RightMtrSpeed(HALF_SPEED);
delay(MOTOR_TIME_INTERVAL);
state = STATE_MOVE_BACKWARD;
}
void handleMoveBackward(void) {
raptor.LeftMtrSpeed(-1*HALF_SPEED);
raptor.RightMtrSpeed(-1*HALF_SPEED);
delay(MOTOR_TIME_INTERVAL);
state = STATE_MOVE_FORWARD;
}
```  \

we can see there exists ```C delay(MOTOR_TIME_INTERVAL);``` \

is blocking the execution of the timer resetting being checked in the function \
```C checkGlobalEvents();```

= 2.
+ 2.6 - 
Thresholds:
```C
LIGHT_THRESHOLD = 
LINE_THRESHOLD = 
```

```C
void prt_light_thres(void) {
  println("Light Threshold at: %i.", LIGHT_THRESHOLD);
}

void prt_line_thres(void) {
  println("Line Threshold at: %i.", LINE_THRESHOLD);
}
```
\ \ \ \ \ \ \ \ 
```C
// PDL

Setup:
setup {
  Start in lurk mode;
}


Loop:

loop {
  If light sense above threshold {
    attack mode
  } else {
    lurk mode
  }
}

lurk mode {
  stop motor;
}

attack mode {
  motor forward full speed;
  if object has been hit:
    setTimer for 1 sec;
    then reverse motor;
    if timer has expired {
      turn right to random direction (choose random time);
    }
}
```






// #figure(
//       image(""),
//       caption: [
//         Stem plot of $x[n] = sin(Omega_0 n)$ for $Omega_0 = -pi/4$
//       ],
//     )

