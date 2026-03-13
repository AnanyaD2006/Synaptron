#include <Servo.h>

Servo myServo;
int angle = 90;   // start at center

void setup() {
  Serial.begin(9600);
  myServo.attach(9);
  myServo.write(angle);

  Serial.println("Enter angle between 0 and 180:");
}

void loop() {

  if (Serial.available() > 0) {

    int newAngle = Serial.parseInt();   // read number

    // clear serial buffer (important)
    while (Serial.available() > 0) {
      Serial.read();
    }

    if (newAngle >= 0 && newAngle <= 180) {

      angle = newAngle;
      myServo.write(angle);

      Serial.print("Holding at: ");
      Serial.println(angle);
    }
    else {
      Serial.println("Invalid! Enter 0 to 180");
    }
  }
}
