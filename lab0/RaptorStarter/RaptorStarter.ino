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

#define TIMER_0                 0 

/*---------------Module Function Prototypes-----------------*/
void checkGlobalEvents(void); // for Q2.5
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
static Metro metTimer1 = Metro(MOTOR_TIME_INTERVAL);
static Metro backingTimer = Metro(BACKING_TIME);
static Metro rotateTimer = Metro(ROTATE_TIME);
uint8_t isLEDOn;
uint8_t motorIsFwd;
bool backing = false;
bool rotating = false;

/*--------------- For Q2.5 (modified starter code) ---------------------------*/
void setup() {
  Serial.begin(9600);
  while(!Serial);
  Serial.println("Raptors initialized!");
  
  state = STATE_MOVE_FORWARD;
  isLEDOn = false;
}

void loop() {
  checkGlobalEvents(); // for LED
  switch (state) {
    case STATE_MOVE_FORWARD:
      if (TestMotorTimerExpired()) RespMotorTimerExpired(); // could also 
      break;
    case STATE_MOVE_BACKWARD:
      if (TestMotorTimerExpired()) RespMotorTimerExpired();
      break;
    default: // Should never get into an unhandled state
      Serial.println("What is this I do not even...");
  }
}

/*--------------- Q3.4 Raptor Main Functions ----------------*/

// void setup() {
//   Serial.begin(9600);
//   while(!Serial);
//   Serial.println("Raptors initialized!");
  
//   state = LURK;
//   isLEDOn = false;
// }

// void loop() {
//   checkGlobalEventsRaptor();

//   Serial.println(read_light_lvl());
//   // main code
//   switch (state) {
//     case LURK:
//       if (TestForLightOn()) RespToLightOn();
//       break;

//     case ATTACK:
//        // default attack mode
//       if (TestForFence()) RespToFence();
//       break;

//     case BACK:
//       if (backingTimer.check() && backing) RespBackingTimerExpired();
//       break;

//     case ROTATE:
//       if (rotateTimer.check() && rotating) RespRotateTimerExpired();
//       break;

//     default:    // Should never get into an unhandled state
//       Serial.println("What is this I do not even...");
//   }

//   Serial.println(raptor.LineCenter());
//   Serial.println(raptor.LightLevel());
// }

// void checkGlobalEventsRaptor(void) {
//   if (TestLedTimerExpired()) RespLedTimerExpired(); // Keep for lab
//   if (TestForLightOff()) RespToLightOff();
// }

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







