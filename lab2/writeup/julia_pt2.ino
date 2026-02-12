// julia's pt 2 

// output pin definitions 
#define IN_1 5 //IN1 and IN2 are terminals on the L298 
#define IN_2 4
#define PWM_PIN 6 //to A_enable on L298 
#define POT_PIN A1

volatile bool in1_state = LOW;
volatile bool in2_state = HIGH; 

void setup(){
    Serial.begin(9600);

    pinMode(IN_1, OUTPUT); 
    pinMode(IN_2, OUTPUT); 
    pinMode(PWM_PIN, OUTPUT);
}

void loop(){
    int val = analogRead(POT_PIN);
    int duty_cycle = map(val, 0, 1023, 0, 255); 
    analogWrite(PWM_PIN, duty_cycle); 

    //direction of motor 
    digitalWrite(IN_1, in1_state);
    digitalWrite(IN_2, in2_state);

    //key press changes rotation direction 
    if (Serial.available()){ //something in the serial monitor 
        clear_serial(); //clear serial for next time
        change_direction();  // change rotation direction 
    }
}

void change_direction(){
    // change motor direction by toggling states 
    in1_state = !in1_state;
    in2_state = !in2_state;
}

void clear_serial(){
    // clears serial buffer
    while (Serial.available()){
        Serial.read();
    }
}