#import "@preview/diverential:0.2.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(zebra-fill: none, 
  languages: (
    C: (name: "C", icon: "", color: rgb("#129610")),
  )
)



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
    Lab 0 - Programming Raptors on a Sparki
  ]
  #v(1.2em)
  #text(1.1em)[
    Koichi Kimoto\
  ]
]
  #v(1em)

// Add some space after the title block
#set enum(numbering: "(a)")
= 1. Q2.5 - Why doesn't the LED blink at 0.5Hz? \ 

Because in these functions: \ 
#codly(highlights: (
  (line: 4, start: 3, end: 27, fill: red),
  (line: 11, start: 3, fill: red),
  )
)
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
we can see in lines 4 and 11, the 
#codly(number-format: none)
```C delay(MOTOR_TIME_INTERVAL);
``` 
\
is blocking the checking of the timer expiration in the function 
```C checkGlobalEvents();``` in the loop:

#codly(
  number-format: numbering.with("1"),
  highlights: (
  (line: 2, start: 3, fill: green),
  (line: 5, start: 7, fill: red),
  (line: 8, start: 7, fill: red),
  ),
  annotations: (
    (start: 2, content: block(
        width: 9em,
        // Rotate the element to make it look nice
        rotate(
          0deg,
          align(center, box(width: 100pt)[Timer expiration \ is checked here])
        )
      )),
    (
      start: 4,
      end: 9,
      content: block(
        width: 4em,
        // Rotate the element to make it look nice
        rotate(
          -90deg,
          align(center, box(width: 100pt)[Both states contain \ blocking code])
        )
      )
    ), 
  )
)
```C
void loop() {
  checkGlobalEvents();
  switch (state) {
    case STATE_MOVE_FORWARD:
      handleMoveForward();
      break;
    case STATE_MOVE_BACKWARD:
      handleMoveBackward();
      break;
    default: // Should never get into an unhandled state
      Serial.println("What is this I do not even...");
  }
}
```



= 2. Q2.6 - Identifying Thresholds
#v(2em)
Thresholds:
```C
LIGHT_THRESHOLD = 100;
LINE_THRESHOLD = 350;
```
\

Code to check the light and line values (which was used to determine the thresholds):

```C
void check_light_thres(void) {
  uint16_t currLightLvl = raptor.LightLevel();
  Serial.print("Current Light Level: ");
  Serial.print(currLightLvl);
  Serial.println(".");
}

void check_line_thres(void) {
  Serial.println("Current Line levels: ");

  Serial.print("Line Left: ");
  Serial.print(raptor.LineLeft());
  Serial.println(".");

  Serial.print("Edge Left: ");
  Serial.print(raptor.EdgeLeft());
  Serial.println(".");

  Serial.print("Line Center: ");
  Serial.print(raptor.LineCenter());
  Serial.println(".");

  Serial.print("Edge Right: ");
  Serial.print(raptor.EdgeRight());
  Serial.println(".");

  Serial.print("Line Right: ");
  Serial.print(raptor.LineRight());
  Serial.println(".");
}
```
#v(2em)
= 3. Q2.7 Helper Functions for Raptor
```C
uint8_t TestForLightOn(void) {
  if (raptor.LightLevel() >= LIGHT_THRESHOLD) return 1;
  else return 0;
}

void RespToLightOn(void) {
  state = ATTACK;
  raptor.LeftMtrSpeed(FULL_SPEED);
  raptor.RightMtrSpeed(FULL_SPEED);
}

uint8_t TestForLightOff(void) {
  if (raptor.LightLevel() < LIGHT_THRESHOLD) return 1;
  else return 0;
}

void RespToLightOff(void) {
  state = LURK;
  raptor.LeftMtrSpeed(0);
  raptor.RightMtrSpeed(0);
}

uint8_t TestForFence(void) {
  if (raptor.ReadTriggers(LINE_THRESHOLD)) return 1;
  return 0;
}

void RespToFence(void) {
  state = BACK;
  backingTimer.reset();
  backing = true;
  raptor.LeftMtrSpeed(-1*HALF_SPEED); // reverse at an angle 
  raptor.RightMtrSpeed(-75);
}
```
= 4. Q2.8 Simple Test Programs
```C
// turn motors on
void motor_on(void){
  raptor.LeftMtrSpeed(100);
  raptor.RightMtrSpeed(100);
}

// turn motors off
void motor_off(void) {
  raptor.LeftMtrSpeed(0);
  raptor.RightMtrSpeed(0);
}

// get char from keyboard
char get_char(void) {
  return Serial.read();
}

// prt value to serial monitor
void prt_value(void) {
  Serial.println("Hello World");
}

// read light sensor
uint16_t read_light_lvl(void) {
  return raptor.LightLevel();
}

// beep buzzer
void Beep(void) {
  raptor.Beep(100, 5000);
}

// turn on RGB LED
void turn_on_RGB(void) {
  raptor.RGB(RGB_WHITE);
}

// Test IR sensors
bool test_IR(void) {
  uint8_t triggerState = raptor.ReadTriggers(LINE_THRESHOLD);
  if (triggerState) return true;
  else return false;
}
```
\ \ \
= 4. Q3 Design & Implementation

My design mainly relies on the raptor having four states:
- *Lurk:* 
  - The raptor is in this state if the light detector is below the threshold.
  - The raptor will turn off the motors when entering this state.
- *Attack:* 
  - The raptor is in this state if the light detector is above the threshold, and the line detector is above the threshold.
  - The raptor will turn on the left and right motors at full speed when entering this state.
- *Back:* 
  - The raptor is in this state if the light detector is above the threshold, and the line detector is below the threshold, and the backing timer has not expired.
  - The raptor will turn on the left motor at negative half speed and the right motor at negative 75% speed when entering this state (i.e. reverse at an angle).
- *Rotate:* 
  - The raptor is in this state if the light detector is above the threshold, and the line detector is below the threshold, and the backing timer has expired.
  - The raptor will turn on the left motor at half speed and the right motor at negative half speed when entering this state (i.e. turn left).
\
The backing timer makes sure that the raptor backs away from the target for a certain amount of time, and the rotating timer makes sure that the raptor rotates for a certain amount of time before attacking a new part of the fence.



#figure(
      image("fsm_diagram.png", height: 45%),
      caption: [
        Finite State Machine Diagram of the Raptor 
      ],
    )


Pseudocode/PDL:
```C
// Setup:
setup {
  Start in lurk mode;
}

// Loop:
loop {
  if light below threshold {
    state = lurk;
    motor turn off;
  }
  switch(state) {
    case 1: lurk mode {
      If light detected {
        state = attack;
        put motor in fwd;
      }  
    }
    case 2: attack mode {
      If line detected {
        state = back;
        put motor in reverse (at an angle so it doesnt attack same spot);
        set a backing timer;
      }
    }
    case 3: back mode {
      if backing timer expires {
        state = rotate;
        make SPARKI turn (left motor fwd, right motor reverse);
        set a rotating timer;
      }
    }
    case 4: rotate mode {
      if rotating timer expires {
        state = attack;
        put motor in fwd;
      }
    }
  }
}
```


Final Code:
```C
#include <Raptor.h>
#include <SPI.h>
#include <Metro.h>

/*---------------Module Defines-----------------------------*/
#define LIGHT_THRESHOLD         100   // *Choose your own thresholds*
                                    // (this will be smaller at night)
#define LINE_THRESHOLD          350   // *Choose your own thresholds*

#define LED_TIME_INTERVAL       2000
#define MOTOR_TIME_INTERVAL     2000
#define BACKING_TIME            3000
#define ROTATE_TIME             2000

#define HALF_SPEED              50
#define FULL_SPEED              100

/*---------------Module Function Prototypes-----------------*/
void checkGlobalEventsRaptor(void); // for Q3
void handleMoveForward(void);
void handleMoveBackward(void);
unsigned char TestForKey(void);
void RespToKey(void);
unsigned char TestForLightOn(void);


/*---------------Raptor Function Prototypes-----------------*/
void RespToLightOn(void);
unsigned char TestForLightOff(void);
void RespToLightOff(void);
unsigned char TestForFence(void);
void RespToFence(void);
unsigned char TestTimer0Expired(void);
void RespTimer0Expired(void);
void RespBackingTimerExpired(void);
void RespRotateTimerExpired(void);

/*--------------- Simple Test Functions --------------------*/
void motor_on(void);
void motor_off(void);
char get_char(void);
void prt_value(void);
uint16_t read_light_lvl(void);
void Beep(void);
void turn_on_RGB(void);
bool test_IR(void);
void prt_light_thres(void);
void prt_line_thres(void);

/*---------------State Definitions--------------------------*/
typedef enum {
  STATE_MOVE_FORWARD, STATE_MOVE_BACKWARD,
  LURK, ATTACK, BACK, ROTATE
} States_t;

/*---------------Module Variables---------------------------*/
States_t state;
static Metro metTimer0 = Metro(LED_TIME_INTERVAL);
static Metro backingTimer = Metro(BACKING_TIME);
static Metro rotateTimer = Metro(ROTATE_TIME);
uint8_t isLEDOn;
uint8_t motorIsFwd;
bool backing = false;
bool rotating = false;

/*--------------- Q3.4 Raptor Main Functions ----------------*/

void setup() {
  Serial.begin(9600);
  while(!Serial);
  Serial.println("Raptors initialized!");
  
  state = LURK;
  isLEDOn = false;
}

void loop() {
  checkGlobalEventsRaptor();
  Serial.println(read_light_lvl());
  switch (state) {
    case LURK:
      if (TestForLightOn()) RespToLightOn();
      break;

    case ATTACK:
       // default attack mode
      if (TestForFence()) RespToFence();
      break;

    case BACK:
      if (backingTimer.check() && backing) RespBackingTimerExpired();
      break;

    case ROTATE:
      if (rotateTimer.check() && rotating) RespRotateTimerExpired();
      break;

    default:    // Should never get into an unhandled state
      Serial.println("What is this I do not even...");
  }

  Serial.println(raptor.LineCenter());
  Serial.println(raptor.LightLevel());
}

void checkGlobalEventsRaptor(void) {
  if (TestLedTimerExpired()) RespLedTimerExpired(); // Keep for lab
  if (TestForLightOff()) RespToLightOff();
}

/*---------------- Module Functions --------------------------*/

void checkGlobalEvents(void) {
  if (TestLedTimerExpired()) RespLedTimerExpired();
  if (TestMotorTimerExpired()) RespMotorTimerExpired();
}

void handleMoveForward(void) {
  raptor.LeftMtrSpeed(HALF_SPEED);
  raptor.RightMtrSpeed(HALF_SPEED);
}

void handleMoveBackward(void) {
  raptor.LeftMtrSpeed(-1 * HALF_SPEED);
  raptor.RightMtrSpeed(-1 * HALF_SPEED);
}

uint8_t TestLedTimerExpired(void) {
  return (uint8_t) metTimer0.check();
}

void RespLedTimerExpired(void) {
  metTimer0.reset();
  if (isLEDOn) {
    isLEDOn = false;
    raptor.RGB(RGB_OFF);
  } else {
    isLEDOn = true;
    raptor.RGB(RGB_WHITE);
  }
}

uint8_t TestMotorTimerExpired(void) {
  return (uint8_t) metTimer1.check();
}

void RespMotorTimerExpired(void) {
  metTimer1.reset();
  if (state == STATE_MOVE_FORWARD) {
    handleMoveBackward();
    state = STATE_MOVE_BACKWARD;
  }
  else {
    handleMoveForward();
    state = STATE_MOVE_FORWARD;
  }
}

uint8_t TestForKey(void) {
  uint8_t KeyEventOccurred;
  KeyEventOccurred = Serial.available();
  return KeyEventOccurred;
}

void RespToKey(void) {
  uint8_t theKey;
  theKey = Serial.read();
  Serial.print(theKey);
  Serial.print(", ASCII=");
  Serial.println(theKey, HEX);
}

/* ---------------- For Q2.6 (estimating thresholds) ----------------------*/ 

void check_light_thres(void) {
  uint16_t currLightLvl = raptor.LightLevel();
  Serial.print("Current Light Level: ");
  Serial.print(currLightLvl);
  Serial.println(".");
}

void check_line_thres(void) {
  Serial.println("Current Line levels: ");

  Serial.print("Line Left: ");
  Serial.print(raptor.LineLeft());
  Serial.println(".");

  Serial.print("Edge Left: ");
  Serial.print(raptor.EdgeLeft());
  Serial.println(".");

  Serial.print("Line Center: ");
  Serial.print(raptor.LineCenter());
  Serial.println(".");

  Serial.print("Edge Right: ");
  Serial.print(raptor.EdgeRight());
  Serial.println(".");

  Serial.print("Line Right: ");
  Serial.print(raptor.LineRight());
  Serial.println(".");
}

/* ---------------- For Q2.7 (implementation of functions) ----------------------*/ 

uint8_t TestForLightOn(void) {
  if (raptor.LightLevel() >= LIGHT_THRESHOLD) return 1;
  else return 0;
}

void RespToLightOn(void) {
  state = ATTACK;
  raptor.LeftMtrSpeed(FULL_SPEED);
  raptor.RightMtrSpeed(FULL_SPEED);
}

uint8_t TestForLightOff(void) {
  if (raptor.LightLevel() < LIGHT_THRESHOLD) return 1;
  else return 0;
}

void RespToLightOff(void) {
  state = LURK;
  raptor.LeftMtrSpeed(0);
  raptor.RightMtrSpeed(0);
}

uint8_t TestForFence(void) {
  if (raptor.ReadTriggers(LINE_THRESHOLD)) return 1;
  return 0;
}

void RespToFence(void) {
  state = BACK;
  backingTimer.reset();
  backing = true;
  raptor.LeftMtrSpeed(-1*HALF_SPEED); // reverse at an angle (avoid attacking same fence part)
  raptor.RightMtrSpeed(-75);
}

void RespBackingTimerExpired(void) {
  backing = false;
  rotating = true;
  rotateTimer.reset();
  raptor.LeftMtrSpeed(HALF_SPEED);
  raptor.RightMtrSpeed(-HALF_SPEED);
  state = ROTATE;
}

void RespRotateTimerExpired(void) {
  rotating = false;
  raptor.LeftMtrSpeed(FULL_SPEED);
  raptor.RightMtrSpeed(FULL_SPEED);
  state = ATTACK;
}

/* ---------------- For Q2.8 (Simple test functions) ----------------------*/ 

// turn motors on
void motor_on(void){
  raptor.LeftMtrSpeed(100);
  raptor.RightMtrSpeed(100);
}

// turn motors off
void motor_off(void) {
  raptor.LeftMtrSpeed(0);
  raptor.RightMtrSpeed(0);
}

// get char from keyboard
char get_char(void) {
  return Serial.read();
}

// prt value to serial monitor
void prt_value(void) {
  Serial.println("Hello World");
}

// read light sensor
uint16_t read_light_lvl(void) {
  return raptor.LightLevel();
}

// beep buzzer
void Beep(void) {
  raptor.Beep(100, 5000);
}

// turn on RGB LED
void turn_on_RGB(void) {
  raptor.RGB(RGB_WHITE);
}

// Test IR sensors
bool test_IR(void) {
  uint8_t triggerState = raptor.ReadTriggers(LINE_THRESHOLD);
  if (triggerState) return true;
  else return false;
}
```





// #figure(
//       image(""),
//       caption: [
//         Stem plot of $x[n] = sin(Omega_0 n)$ for $Omega_0 = -pi/4$
//       ],
//     )

