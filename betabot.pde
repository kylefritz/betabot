// we need fundamental FILE definitions and printf declarations
#include <stdio.h>
#include <Servo.h>

// create a FILE structure to reference our UART output function
static FILE uartout = {0} ;

// create a output function
// This works because Serial.write, although of type virtual, already exists.
static int uart_putchar (char c, FILE *stream)
{
    Serial.write(c) ;
    return 0 ;
}




//servo pins (pwm)
const int pin_back = 3;
const int pin_front = 5;
const int pin_turn = 6;

//servos
Servo servo_back;
Servo servo_front;
Servo servo_turn;

//led (pwm)
const int pin_mouth = 9;

//inputs
char func;
int magnitude;

void setup(){
  //enable better printing
  //Enable printf => fill in the UART file descriptor with pointer to writer.
  fdev_setup_stream (&uartout, uart_putchar, NULL, _FDEV_SETUP_WRITE);
  //The uart is the standard output device STDOUT.
  stdout = &uartout ;
  
  servo_back.attach(pin_back);
  servo_back.write(0);
  
  servo_front.attach(pin_front);
  servo_front.write(240);
  
  servo_turn.attach(pin_turn);
  servo_turn.write(255/2);
  
  Serial.begin(9600);
  printf("beta bot go!\n\r");
}

void loop(){
  if(Serial.available()>0){
    func=Serial.read();
    if(func=='m'){
      readAndMapMouth();      
    }else if(func=='f'){
      readAndMapServo(servo_front);
    }else if(func=='b'){
      readAndMapServo(servo_back);
    }else if(func=='t'){
      readAndMapServo(servo_turn);
    }else if(func=='d'){
      //dance easter egg
      printf("EASTER: let's dance!\n\r");      
      for(int i=0;i<3;i++){  
        setMouth(0);
        servo_turn.write(10);
        servo_front.write(30);
        servo_back.write(240);
        delay(300);
        
        servo_front.write(90);
        servo_back.write(90);
        servo_turn.write(240);
        setMouth(1);
        delay(450);
  
        servo_turn.write(255/2);      
        servo_front.write(120);
        servo_back.write(240);
        setMouth(0);
        delay(400);
        
        servo_turn.write(90);      
        servo_front.write(120);
        servo_back.write(0);
        delay(500);
        
      }
      
    }else{
      printf("ERR: don't know function: %c\n\r",func);
    }
    
  }
}

void readAndMapMouth(){
  while(Serial.available() < 1)
    true;//block till get what we need
    
  magnitude=int(Serial.read()-'0');
  int newValue = map(magnitude,0,9,0,255);
  printf("DEBUG: set mouth to : %d (%d)\n\r",magnitude,newValue);
  analogWrite(pin_mouth,newValue);
}

void readAndMapServo(Servo &servo){
  while(Serial.available() < 1)
    true;//block till get what we need
    
  magnitude=int(Serial.read()-'0');
  int newValue = map(magnitude,0,9,0,255);
  printf("DEBUG: set servo to : %d (%d)\n\r",magnitude,newValue);
  servo.write(newValue);
}

void setMouth(int on){
  if(on==1){
    analogWrite(pin_mouth,255);
  }else{
    analogWrite(pin_mouth,0);
  }
}

