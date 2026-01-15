#include <Raptor.h>
#include <SPI.h>

#include <Metro.h>


/*---------------Module Defines-----------------------------*/

#define LIGHT_THRESHOLD         0   // *Choose your own thresholds*
                                    // (this will be smaller at night)
#define LINE_THRESHOLD          100   // *Choose your own thresholds*

#define LED_TIME_INTERVAL       2000
#define MOTOR_TIME_INTERVAL     2000
#define BACKING_TIME            4000
#define ROTATE_TIME             2000

#define HALF_SPEED              50
#define FULL_SPEED              100

#define TIMER_0                 0 

#define LEFT_TRIGGER 0x01
#define EDGE_LEFT_TRIGGER 0x02
#define CENTER_TRIGGER 0x04
#define EDGE_RIGHT_TRIGGER 0x08
#define RIGHT_TRIGGER 0x10
/*---------------Module Function Prototypes-----------------*/
void checkGlobalEvents(void);
void handleMoveForward(void);
void handleMoveBackward(void);
unsigned char TestForKey(void);
void RespToKey(void);
unsigned char TestForLightOn(void);
void RespToLightOn(void);
unsigned char TestForLightOff(void);
void RespToLightOff(void);
unsigned char TestForFence(void);
void RespToFence(void);
unsigned char TestTimer0Expired(void);
void RespTimer0Expired(void);
void prt_light_thres(void);
void prt_line_thres(void);

void RespBackingTimerExpired(void);
void RespRotateTimerExpired(void);

/*--------------- Simple Test Functions --------------------*/
void motor_on(void);
void motor_off(void);
void get_char(char);
void prt_value();
uint16_t read_light_lvl(void);
void Beep(void);
void turn_on_RGB(void);
bool test_IR(void);


/*---------------State Definitions--------------------------*/
typedef enum {
  LURK, ATTACK, BACK, ROTATE
} States_t;

/*---------------Module Variables---------------------------*/
States_t state;
static Metro metTimer0 = Metro(LED_TIME_INTERVAL);
static Metro backingTimer = Metro(BACKING_TIME);
static Metro rotateTimer = Metro(ROTATE_TIME);
bool backing = false;
bool rotating = false;
uint8_t isLEDOn;

/*---------------Raptor Main Functions----------------*/

void setup() {
  // put your setup code here, to run once:
  
  /* Open the serial port for communication using the Serial
     C++ class. On the Leonardo, you must explicitly wait for
   the class to report ready before commanding a println.
  */
  Serial.begin(9600);
  while(!Serial);
  Serial.println("Raptors initialized!");
  
  state = LURK;
  isLEDOn = false;
}

void loop() {
  // put your main code here, to run repeatedly:
  // motor_on();
  // if (test_IR()) {
  //   RespToFence();
  //   motor_off();
  //   delay(1000);
  //   RespToFence();
  //   delay(1000);
  // } 

  checkGlobalEvents();

  Serial.println(read_light_lvl());
  // main code
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
}

/*----------------Module Functions--------------------------*/

void handleMoveForward(void) {
  raptor.LeftMtrSpeed(HALF_SPEED);
  raptor.RightMtrSpeed(HALF_SPEED);
  // delay(MOTOR_TIME_INTERVAL);
  // state = STATE_MOVE_BACKWARD;
}

void handleMoveBackward(void) {
  raptor.LeftMtrSpeed(-1 * HALF_SPEED);
  raptor.RightMtrSpeed(-1 * HALF_SPEED);
  // delay(MOTOR_TIME_INTERVAL);
  // state = STATE_MOVE_FORWARD;
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

void checkGlobalEvents(void) {
  if (TestLedTimerExpired()) RespLedTimerExpired(); // Keep for lab
  if (TestForLightOff()) RespToLightOff();


  // if (TestMotorTimerExpired()) RespMotorTimerExpired();
  // if (TestForKey()) RespToKey();
}



// Implementation of functions

uint8_t TestForLightOn(void) {
  // check sensor for light on
  if (raptor.LightLevel() >= LIGHT_THRESHOLD) return 1;
  else return 0;
}

void RespToLightOn(void) {
  // start attacking
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
  if (test_IR()) return 1;
  return 0;
}

void RespToFence(void) {
  // To be written in Part 2
  state = BACK;
  backingTimer.reset();
  backing = true;
  raptor.LeftMtrSpeed(-1*HALF_SPEED);
  raptor.RightMtrSpeed(-1*HALF_SPEED);
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


void prt_light_thres(void) {
  Serial.print("Light Threshold at: ");
  Serial.print(LIGHT_THRESHOLD);
  Serial.println(".");
}

void prt_line_thres(void) {
  Serial.print("Line Threshold at: ");
  Serial.print(LINE_THRESHOLD);
  Serial.println(".");
}

/* ---------------- Simple test functions ----------------------*/ 

// turn motors on/off
void motor_on(void){
  raptor.LeftMtrSpeed(100);
  raptor.RightMtrSpeed(100);
}

void motor_off(void) {
  raptor.LeftMtrSpeed(0);
  raptor.RightMtrSpeed(0);
}

// get char from keyboard
char get_char() {
  return Serial.read();
}

// prt value to serial monitor
void prt_value() {
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



