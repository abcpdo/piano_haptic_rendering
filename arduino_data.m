classdef arduino_data < handle
   properties (SetAccess = private)
       force_m double
       torque_m double
       fsr_reading double
       force double
       status_sol int
       status_lra int
       x int
       y int
       q queue
		 int pwmPin1 = 5; % motor
		 int dirPin1 = 8;
		 int pwmPin2 = 6; % solenoid
		 int dirPin2 = 7; 
		 int aPinFSR = 0; % FSR connected to A0 port
		 
   end
   % get arduino
   a = arduino('/dev/cu.usbserial-AL03G1P2','uno')
	configurePin(a,pwmPin2,'DigitalOutput');
	configurePin(a,dirPin2,'DigitalOutput');

	
   methods
      function fsr_reading = force_sensor()
          %function return force on the key sensor
			fsr_reading = readAnalogPin(aPinFSR);
  			%Serial.print("Analog reading = ");
  			%Serial.println(fsrReading);
      end
      function status_sol = solenoid_status(x) % 225 - on, 0 - off
          % function to turn arduino solenoid on/off
			 	writeDigitalPin(a,dirPin2,x)
				delay(3000);
				analogWrite(pwmPin,0); %  off posiion, only run once when key is pressed
      end
%      function status_lra = LRA_status(y)
%          % function to turn arduino LRA  on/off
%          if (y == 1)
%              %LRA on
%          else
%              %LRA off
%          end
      end
      function force_m = motor_force(F_motor_out)
          % function to control the motor
          force_m = F_motor_out;
          Tp = (force_m*rh*rp)/rs;
          
          if(force_m > 0) {
            digitalWrite(dirPin, HIGH);
          } else {
            digitalWrite(dirPin, LOW);
          }
      // Compute the duty cycle required to generate Tp (torque at the motor pulley)
          duty = sqrt(abs(Tp)/0.0183);
      // Make sure the duty cycle is between 0 and 100%
          if (duty > 1) {
          duty = 1;
          } else if (duty < 0) {
          duty = 0;
          }
          output = (int)(duty* 255); // convert duty cycle to output signal
          analogWrite(pwmPin,output); // output the signal
          }
          
          void setPwmFrequency(int pin, int divisor) {
               byte mode;
          if(pin == 5 || pin == 6 || pin == 9 || pin == 10) {
            switch(divisor) {
               case 1: mode = 0x01; break;
               case 8: mode = 0x02; break;
               case 64: mode = 0x03; break;
               case 256: mode = 0x04; break;
               case 1024: mode = 0x05; break;
               default: return;
            }
          if(pin == 5 || pin == 6) {
               TCCR0B = TCCR0B & 0b11111000 | mode;
            } else {
               TCCR1B = TCCR1B & 0b11111000 | mode;
            }
            } else if(pin == 3 || pin == 11) {
               switch(divisor) {
               case 1: mode = 0x01; break;
               case 8: mode = 0x02; break;
               case 32: mode = 0x03; break;
               case 64: mode = 0x04; break;
               case 128: mode = 0x05; break;
               case 256: mode = 0x06; break;
               case 1024: mode = 0x7; break;
               default: return;
            }
            TCCR2B = TCCR2B & 0b11111000 | mode;
            }
      end
   end
end


