// we need fundamental FILE definitions and printf declarations
#include <stdio.h>

// create a FILE structure to reference our UART output function
static FILE uartout = {0} ;

// create a output function
// This works because Serial.write, although of type virtual, already exists.
static int uart_putchar (char c, FILE *stream)
{
    Serial.write(c) ;
    return 0 ;
}


#include <Servo.h>

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
int magnitude=0;

void setup(){
  //enable better printing
  //Enable printf => fill in the UART file descriptor with pointer to writer.
  fdev_setup_stream (&uartout, uart_putchar, NULL, _FDEV_SETUP_WRITE);
  //The uart is the standard output device STDOUT.
  stdout = &uartout ;
  
  servo_back.attach(pin_back);
  servo_back.write(0);
  
  servo_front.attach(pin_front);
  servo_front.write(0);
  
  servo_turn.attach(pin_turn);
  servo_turn.write(255/2);
  
  Serial.begin(9600);
  printf("beta bot go!\n\r");
}

void loop(){
  if(Serial.availible()>0){
    func=Serial.read();
    if(func=='m'){
      
    }else if(func=='f'){
      readAndMapServo(servo_front);
    }else if(func=='b'){
      readAndMapServo(servo_back);
    }else if(func=='t'){
      readAndMapServo(servo_turn);
    }else if(func=='m'){
      //mouth
      readAndMapMouth();
    }else if(func=='d'){
      //dance easter egg
      
    }else{
      printf("ERR: don't know function: %c\n\r",func);
    }
    
  }
}

void readAndMapMouth(){
  magnitude=Serial.read();
  int newValue = map(magnitue,0,9,0,255);
  digitalWrite(pin_mouth,newValue);
}

void readAndMapServo(Servo &servo){
  magnitude=Serial.read();
  int newValue = map(magnitue,0,9,0,255);
  servo.write(newValue);
}
