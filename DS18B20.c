
// the 1-wire devices are connected to pin PORT E2

// LCD module connections
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;
// End LCD module connections

//  Set TEMP_RESOLUTION to the corresponding resolution of used DS18x20 sensor:
//  18S20: 9  (default setting; can be 9,10,11,or 12)
//  18B20: 12
const unsigned short TEMP_RESOLUTION = 12;
unsigned short RES_SHIFT;
char *text = "000.0000";
unsigned temp1, temp2;
char i, tmp1[8], tmp2[8];
char SlaveROM2[8];
unsigned char SlaveROM1[8];


// global search state
unsigned char ROM_NO[8];
int LastDiscrepancy;
int LastFamilyDiscrepancy;
int LastDeviceFlag;
unsigned char crc8;


  // see Application note 27 Page 8 Table 1 to understand the algorithm
  // the final result of xor operation with the crc byte in ROM code should equal zero if the received ROM code is correct

 const unsigned char dscrc_table[] = {                                    //static
0, 94,188,226, 97, 63,221,131,194,156,126, 32,163,253, 31, 65,
157,195, 33,127,252,162, 64, 30, 95, 1,227,189, 62, 96,130,220,
35,125,159,193, 66, 28,254,160,225,191, 93, 3,128,222, 60, 98,
190,224, 2, 92,223,129, 99, 61,124, 34,192,158, 29, 67,161,255,
70, 24,250,164, 39,121,155,197,132,218, 56,102,229,187, 89, 7,
219,133,103, 57,186,228, 6, 88, 25, 71,165,251,120, 38,196,154,
101, 59,217,135, 4, 90,184,230,167,249, 27, 69,198,152,122, 36,
248,166, 68, 26,153,199, 37,123, 58,100,134,216, 91, 5,231,185,
140,210, 48,110,237,179, 81, 15, 78, 16,242,172, 47,113,147,205,
17, 79,173,243,112, 46,204,146,211,141,111, 49,178,236, 14, 80,
175,241, 19, 77,206,144,114, 44,109, 51,209,143, 12, 82,176,238,
50,108,142,208, 83, 13,239,177,240,174, 76, 18,145,207, 45,115,
202,148,118, 40,171,245, 23, 73, 8, 86,180,234,105, 55,213,139,
87, 9,235,181, 54,104,138,212,149,203, 41,119,244,170, 72, 22,
233,183, 85, 11,136,214, 52,106, 43,117,151,201, 74, 20,246,168,
116, 42,200,150, 21, 75,169,247,182,232, 10, 84,215,137,107, 53};


        unsigned char docrc8(unsigned char value)
        {

        crc8 = dscrc_table[crc8 ^ value];    // Xor operation
        return crc8;
        }


        // Reads one bit from the I/O pin  See application note 126

        unsigned short Ow_Read_Bit()
        {
             unsigned short BitValue;    // Bit to be returned
             TRISE.B2 = 0;                 // Set pin 2 in PORT E as output
             PORTE.B2 = 0;               // Drive bus low   LATE.B2;   for PIC18
             delay_us(6);                // Wait 6 usecs
             TRISE.B2 = 1;                 // Release the bus
             delay_us(9);                // Wait 9 usecs
             BitValue = PORTE.B2;         // Read bit value on pin 2 on PORT E
             delay_us(55);               // Wait 55 usecs
             return BitValue;            // Return bit read
        }

        // Sends a '1' bit to the I/O pin  See application note 126

        void Ow_Write_One()
        {
             TRISE.B2 = 0;      // Set pin 2 in PORT E as output
             PORTE.B2 = 0;    // Drive bus low
             delay_us(6);     // Wait 6 usecs        (6*4)*0.25 us
             TRISE.B2 = 1;      // Release the bus
             delay_us(64);    // Wait 64 usecs        (64*4)*0.25 us
        }


        // Sends a '0' bit to the I/O pin   See application note 126

        void Ow_Write_Zero()
        {
           TRISE.B2 = 0;     // Set pin 2 in PORT E as output
           PORTE.B2 = 0;   // Drive bus low
           delay_us(60);   // Wait 60 usecs
           TRISE.B2 = 1;     // Release the bus
           delay_us(10);   // Wait 10 usecs
        }

       //See application note 187
       int Ow_Search()
       {
         int id_bit_number;
         int last_zero, rom_byte_number, search_result;
         int id_bit, cmp_id_bit;
         unsigned char rom_byte_mask, search_direction;

         // initialize for search
         id_bit_number = 1;
         last_zero = 0;
         rom_byte_number = 0;
         rom_byte_mask = 1;
         search_result = 0;
         crc8 = 0;

          // if the last call was not the last one
          if (!LastDeviceFlag)
          {
             // check if there are 1-Wire device (s) 0 if the device(s) responded, 1 if no devices did
             if (Ow_Reset(&PORTE, 2))
             {
                // reset the search
                LastDiscrepancy = 0;
                LastDeviceFlag = 0;
                LastFamilyDiscrepancy = 0;
                return 0;
             }
             // Issue command Search_ROM
             Ow_Write(&PORTE, 2, 0xF0);

             // loop to do the search
             do
             {
               // read a bit and its complement
               id_bit = OW_Read_Bit();
               cmp_id_bit = OW_Read_Bit();

               // 11 no devices on the 1-wire

               // check for no devices on 1-wire
               if ((id_bit == 1) && (cmp_id_bit == 1))
                  break;
               else
               {
                    // all devices coupled have 0 or 1
                    if (id_bit != cmp_id_bit)
                      search_direction = id_bit; // bit write value for search
                    else
                    {
                          // if this discrepancy is before the Last Discrepancy
                         // on a previous next then pick the same as last time

                         if (id_bit_number < LastDiscrepancy)
                           search_direction = ((ROM_NO[rom_byte_number] &  rom_byte_mask) > 0);
                         else
                           // if equal to last pick 1, if not then pick 0
                           search_direction = (id_bit_number == LastDiscrepancy);

                        // if 0 was picked then record its position in LastZero
                        if (search_direction == 0)
                         {
                             last_zero = id_bit_number;
                             // check for Last discrepancy in family
                             if (last_zero < 9) LastFamilyDiscrepancy = last_zero;
                         }
                     }


                    // set or clear the bit in the ROM byte rom_byte_number
                    // with mask rom_byte_mask

                    if (search_direction == 1)
                       ROM_NO[rom_byte_number] |= rom_byte_mask;
                    else
                       ROM_NO[rom_byte_number] &= ~rom_byte_mask;


                    // serial number search direction write bit
                    if (search_direction)
                       Ow_Write_One();
                    else
                       Ow_Write_Zero();
                   // increment the byte counter id_bit_number
                  // and shift the mask rom_byte_mask

                  id_bit_number++;
                  rom_byte_mask <<= 1;

                  // if the mask is 0 then go to new SerialNum byte rom_byte_number
                  //and reset mask

                  if (rom_byte_mask == 0)
                  {
                     docrc8(ROM_NO[rom_byte_number]); // accumulate the CRC
                     rom_byte_number++;
                     rom_byte_mask = 1;
                  }
                }
              }   // End of search loop
              while(rom_byte_number < 8); // loop until through all ROM bytes 0-7

              // if the search was successful then
              if (!((id_bit_number < 65) || (crc8 != 0)))
              {
                // search successful so set LastDiscrepancy,LastDeviceFlag,search_result
                LastDiscrepancy = last_zero;

                // check for last device
                if (LastDiscrepancy == 0) LastDeviceFlag = 1;
                search_result = 1;
              }
           }

           // if no device found then reset counters so next 'search' will be
           // like a first

          if (!search_result || !ROM_NO[0])
          {
            LastDiscrepancy = 0;
            LastDeviceFlag = 0;
            LastFamilyDiscrepancy = 0;
            search_result = 0;
          }
          return search_result;
        }   // End of Ow-Search function

        // Finds the first device

      int Ow_First()
      {
         LastDiscrepancy = 0;
         LastDeviceFlag = 0;
         LastFamilyDiscrepancy = 0;
         return Ow_Search();
      }


      // Finds any other devices after the first one

      int Ow_Next()
      {
        return Ow_Search();
      }

      // Set up search to look for a certain device family code

      void Ow_Target_Setup(unsigned char family_code)
      {
         int i;
         // set the search state to find SearchFamily type devices
         ROM_NO[0] = family_code;
         for (i = 1; i < 8; i++)
         ROM_NO[i] = 0;
         LastDiscrepancy = 64;
         LastFamilyDiscrepancy = 0;
         LastDeviceFlag = 0;
      }


      void Ow_Family_Skip_Setup()
      {
      // set the Last discrepancy to last family discrepancy
      LastDiscrepancy = LastFamilyDiscrepancy;
      LastFamilyDiscrepancy = 0;
      // check for end of list
      if (LastDiscrepancy == 0)
      LastDeviceFlag = 1;
      }
              void Display_Temperature(unsigned int temp2write,unsigned x ) {
                const unsigned short RES_SHIFT = TEMP_RESOLUTION - 8;
                char temp_whole;
                unsigned int temp_fraction;

                // Check if temperature is negative
                if (temp2write & 0x8000) {
                   text[0] = '-';
                   temp2write = ~temp2write + 1;
                   // Extract temp_whole
                   temp_whole = temp2write >> RES_SHIFT ;
                   text[1] = (temp_whole/10)%10 + 48;             // Extract tens digit
                   text[2] =  temp_whole%10     + 48;             // Extract ones digit

                   // Extract temp_fraction and convert it to unsigned int
                   temp_fraction  = temp2write << (4-RES_SHIFT);
                   temp_fraction &= 0x000F;
                   temp_fraction *= 625;

                   // Convert temp_fraction to characters
                   text[4] =  temp_fraction/1000    + 48;         // Extract thousands digit
                   text[5] = (temp_fraction/100)%10 + 48;         // Extract hundreds digit
                   text[6] = (temp_fraction/10)%10  + 48;         // Extract tens digit
                   text[7] =  temp_fraction%10      + 48;         // Extract ones digit

                   // Print temperature on LCD
                   Lcd_Out(x, 5, text);
                   }
                  else
                  {
                // Extract temp_whole
                temp_whole = temp2write >> RES_SHIFT ;

                // Convert temp_whole to characters
                if (temp_whole/100)
                   text[0] = temp_whole/100  + 48;
                else
                   text[0] = '0';

                text[1] = (temp_whole/10)%10 + 48;             // Extract tens digit
                text[2] =  temp_whole%10     + 48;             // Extract ones digit

                // Extract temp_fraction and convert it to unsigned int
                temp_fraction  = temp2write << (4-RES_SHIFT);
                temp_fraction &= 0x000F;
                temp_fraction *= 625;

                // Convert temp_fraction to characters
                text[4] =  temp_fraction/1000    + 48;         // Extract thousands digit
                text[5] = (temp_fraction/100)%10 + 48;         // Extract hundreds digit
                text[6] = (temp_fraction/10)%10  + 48;         // Extract tens digit
                text[7] =  temp_fraction%10      + 48;         // Extract ones digit

                // Print temperature on LCD
                Lcd_Out(x, 5, text);
                }
              }


short loop_cnt;     // General purpose counter
unsigned DevicesFound; // Number of devices found
char TextBuffer[35]; // Buffer to hold the string sent to UART
int result;     // Holds result returned from search functions
char tmp[3];

void main() {
  ANSEL  = 0;                                    // Configure AN pins as digital I/O
  ANSELH = 0;
  C1ON_bit = 0;                                  // Disable comparators
  C2ON_bit = 0;

  Lcd_Init();                                    // Initialize LCD
  Lcd_Cmd(_LCD_CURSOR_OFF);
  Lcd_Cmd(_LCD_CLEAR);                            // Clear LCD
  Ow_Reset(&PORTE, 2);
  Ow_Write(&PORTE, 2, 0xF0);                   // Issue command Search_ROM

  DevicesFound = 0;  // Reset device counter
     if ( Ow_First() )    // Check for the first device
          {
             DevicesFound++;  // Increment the device found counter

                 for(i=0; i<8; i++)
                  {
                     ByteToHex(ROM_NO[i],tmp1);
                     Lcd_Out(1, 15-2*i, tmp1);
                     SlaveROM1[i]=ROM_NO[i];

                  }

          }

     //  Check to see if there are any more devices on the bus
          //  If there are, then loop until the rest of the devices
          //  have been discovered

     while ( Ow_Next() )
          {
            DevicesFound++;  // Increment the devices found counter
            //SlaveROM1=ROM_NO;
            for(i=0; i<8; i++)
                  {
                     ByteToHex(ROM_NO[i],tmp2);
                     Lcd_Out(2, 15-2*i, tmp2);
                     SlaveROM2[i]=ROM_NO[i];
                  }
            }


     if (DevicesFound == 0) Lcd_Out (1,1,"No devices found\n");
     delay_ms(1000);
     Lcd_Cmd(_Lcd_Clear);
  //--- Main loop
  do {
       // Send Match ROM command to select sensor 1 and perform temperature conversion
        Ow_Reset(&PORTE, 2);                         // Onewire reset signal
        Ow_Write(&PORTE, 2, 0x55);                   // Issue command Match_ROM

        // send DS18B20 sensor 1 ROM  0x28 E2 E6 EA 07 00 00 37
        for (i=0;i<8;i++)
        {
          Ow_Write(&PORTE, 2, SlaveROM1[i]);
        }
        Delay_ms(10);

        Ow_Write(&PORTE, 2, 0x44);                   // Issue command CONVERT_T
        Delay_ms(760);        // 760ms


    // --- send Match ROM to select sensor 1 then send command to read the result of conversion stored in scratchpad memory of sensor 1
        Ow_Reset(&PORTE, 2);                         // Onewire reset signal
        Ow_Write(&PORTE, 2, 0x55);                   // Issue command Match_ROM

        // send DS18B20 sensor 1 ROM
        for (i=0;i<8;i++)
        {
          Ow_Write(&PORTE, 2, SlaveROM1[i]);
        }

        Delay_ms(10);

        Ow_Write(&PORTE, 2, 0xBE);                   // Issue command READ_SCRATCHPAD

    temp1 =  Ow_Read(&PORTE, 2);                  // LSB (the LSB is first transferred
    temp1 = (Ow_Read(&PORTE, 2) << 8) + temp1;     // shift left to form the MSB then add the LSB

    // Display the result of sensor 1
    RES_SHIFT = TEMP_RESOLUTION - 8;
    Lcd_Chr(1,13,178);                 // Different LCD displays have different char code for degree
                                                 // If you see greek alpha letter try typing 178 instead of 223
    Lcd_Chr(1,14,'C');                              // Print degree character, 'C' for Centigrades
    Display_Temperature(temp1,1);



    // Send Match ROM command to select sensor 2 and perform temperature conversion
        Ow_Reset(&PORTE, 2);                         // Onewire reset signal
        Ow_Write(&PORTE, 2, 0x55);                   // Issue command Match_ROM

        // send DS18B20 sensor 2 ROM
        for (i=0;i<8;i++)
        {
          Ow_Write(&PORTE, 2, SlaveROM2[i]);
        }
        Delay_ms(10);

        Ow_Write(&PORTE, 2, 0x44);                   // Issue command CONVERT_T
        Delay_ms(760);        // 760ms

    // --- send Match ROM to select sensor 2 then send command to read the result of conversion stored in scratchpad memory of sensor 2
        Ow_Reset(&PORTE, 2);
        Ow_Write(&PORTE, 2, 0x55);                   // Issue command Match_ROM
        // send DS18B20 sensor 2 ROM
        for (i=0;i<8;i++)
        {
          Ow_Write(&PORTE, 2, SlaveROM2[i]);
        }
        Delay_ms(10);
        Ow_Write(&PORTE, 2, 0xBE);                   // Issue command READ_SCRATCHPAD


    temp2 =  Ow_Read(&PORTE, 2);                  // LSB (the LSB is first transferred
    temp2 = (Ow_Read(&PORTE, 2) << 8) + temp2;     // shift left to form the MSB then add the LSB

    // Display the result of sensor 2
    RES_SHIFT = TEMP_RESOLUTION - 8;
    Lcd_Chr(2,13,178);                 // Different LCD displays have different char code for degree
                                                 // If you see greek alpha letter try typing 178 instead of 223
    Lcd_Chr(2,14,'C');                              // Print degree character, 'C' for Centigrades
    Display_Temperature(temp2,2);

     } while (1);
}
