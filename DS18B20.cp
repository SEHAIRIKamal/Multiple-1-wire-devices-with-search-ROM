#line 1 "D:/Embeded systems courses & books/Cours SEHAIRI/Les TPs/TP6/MikroC/Two sensors test3 search ROM/DS18B20.c"




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





const unsigned short TEMP_RESOLUTION = 12;
unsigned short RES_SHIFT;
char *text = "000.0000";
unsigned temp1, temp2;
char i, tmp1[8], tmp2[8];
char SlaveROM2[8];
unsigned char SlaveROM1[8];



unsigned char ROM_NO[8];
int LastDiscrepancy;
int LastFamilyDiscrepancy;
int LastDeviceFlag;
unsigned char crc8;





 const unsigned char dscrc_table[] = {
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

 crc8 = dscrc_table[crc8 ^ value];
 return crc8;
 }




 unsigned short Ow_Read_Bit()
 {
 unsigned short BitValue;
 TRISE.B2 = 0;
 PORTE.B2 = 0;
 delay_us(6);
 TRISE.B2 = 1;
 delay_us(9);
 BitValue = PORTE.B2;
 delay_us(55);
 return BitValue;
 }



 void Ow_Write_One()
 {
 TRISE.B2 = 0;
 PORTE.B2 = 0;
 delay_us(6);
 TRISE.B2 = 1;
 delay_us(64);
 }




 void Ow_Write_Zero()
 {
 TRISE.B2 = 0;
 PORTE.B2 = 0;
 delay_us(60);
 TRISE.B2 = 1;
 delay_us(10);
 }


 int Ow_Search()
 {
 int id_bit_number;
 int last_zero, rom_byte_number, search_result;
 int id_bit, cmp_id_bit;
 unsigned char rom_byte_mask, search_direction;


 id_bit_number = 1;
 last_zero = 0;
 rom_byte_number = 0;
 rom_byte_mask = 1;
 search_result = 0;
 crc8 = 0;


 if (!LastDeviceFlag)
 {

 if (Ow_Reset(&PORTE, 2))
 {

 LastDiscrepancy = 0;
 LastDeviceFlag = 0;
 LastFamilyDiscrepancy = 0;
 return 0;
 }

 Ow_Write(&PORTE, 2, 0xF0);


 do
 {

 id_bit = OW_Read_Bit();
 cmp_id_bit = OW_Read_Bit();




 if ((id_bit == 1) && (cmp_id_bit == 1))
 break;
 else
 {

 if (id_bit != cmp_id_bit)
 search_direction = id_bit;
 else
 {



 if (id_bit_number < LastDiscrepancy)
 search_direction = ((ROM_NO[rom_byte_number] & rom_byte_mask) > 0);
 else

 search_direction = (id_bit_number == LastDiscrepancy);


 if (search_direction == 0)
 {
 last_zero = id_bit_number;

 if (last_zero < 9) LastFamilyDiscrepancy = last_zero;
 }
 }





 if (search_direction == 1)
 ROM_NO[rom_byte_number] |= rom_byte_mask;
 else
 ROM_NO[rom_byte_number] &= ~rom_byte_mask;



 if (search_direction)
 Ow_Write_One();
 else
 Ow_Write_Zero();



 id_bit_number++;
 rom_byte_mask <<= 1;




 if (rom_byte_mask == 0)
 {
 docrc8(ROM_NO[rom_byte_number]);
 rom_byte_number++;
 rom_byte_mask = 1;
 }
 }
 }
 while(rom_byte_number < 8);


 if (!((id_bit_number < 65) || (crc8 != 0)))
 {

 LastDiscrepancy = last_zero;


 if (LastDiscrepancy == 0) LastDeviceFlag = 1;
 search_result = 1;
 }
 }




 if (!search_result || !ROM_NO[0])
 {
 LastDiscrepancy = 0;
 LastDeviceFlag = 0;
 LastFamilyDiscrepancy = 0;
 search_result = 0;
 }
 return search_result;
 }



 int Ow_First()
 {
 LastDiscrepancy = 0;
 LastDeviceFlag = 0;
 LastFamilyDiscrepancy = 0;
 return Ow_Search();
 }




 int Ow_Next()
 {
 return Ow_Search();
 }



 void Ow_Target_Setup(unsigned char family_code)
 {
 int i;

 ROM_NO[0] = family_code;
 for (i = 1; i < 8; i++)
 ROM_NO[i] = 0;
 LastDiscrepancy = 64;
 LastFamilyDiscrepancy = 0;
 LastDeviceFlag = 0;
 }


 void Ow_Family_Skip_Setup()
 {

 LastDiscrepancy = LastFamilyDiscrepancy;
 LastFamilyDiscrepancy = 0;

 if (LastDiscrepancy == 0)
 LastDeviceFlag = 1;
 }
 void Display_Temperature(unsigned int temp2write,unsigned x ) {
 const unsigned short RES_SHIFT = TEMP_RESOLUTION - 8;
 char temp_whole;
 unsigned int temp_fraction;


 if (temp2write & 0x8000) {
 text[0] = '-';
 temp2write = ~temp2write + 1;

 temp_whole = temp2write >> RES_SHIFT ;
 text[1] = (temp_whole/10)%10 + 48;
 text[2] = temp_whole%10 + 48;


 temp_fraction = temp2write << (4-RES_SHIFT);
 temp_fraction &= 0x000F;
 temp_fraction *= 625;


 text[4] = temp_fraction/1000 + 48;
 text[5] = (temp_fraction/100)%10 + 48;
 text[6] = (temp_fraction/10)%10 + 48;
 text[7] = temp_fraction%10 + 48;


 Lcd_Out(x, 5, text);
 }
 else
 {

 temp_whole = temp2write >> RES_SHIFT ;


 if (temp_whole/100)
 text[0] = temp_whole/100 + 48;
 else
 text[0] = '0';

 text[1] = (temp_whole/10)%10 + 48;
 text[2] = temp_whole%10 + 48;


 temp_fraction = temp2write << (4-RES_SHIFT);
 temp_fraction &= 0x000F;
 temp_fraction *= 625;


 text[4] = temp_fraction/1000 + 48;
 text[5] = (temp_fraction/100)%10 + 48;
 text[6] = (temp_fraction/10)%10 + 48;
 text[7] = temp_fraction%10 + 48;


 Lcd_Out(x, 5, text);
 }
 }


short loop_cnt;
unsigned DevicesFound;
char TextBuffer[35];
int result;
char tmp[3];

void main() {
 ANSEL = 0;
 ANSELH = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;

 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 Ow_Reset(&PORTE, 2);
 Ow_Write(&PORTE, 2, 0xF0);

 DevicesFound = 0;
 if ( Ow_First() )
 {
 DevicesFound++;

 for(i=0; i<8; i++)
 {
 ByteToHex(ROM_NO[i],tmp1);
 Lcd_Out(1, 15-2*i, tmp1);
 SlaveROM1[i]=ROM_NO[i];

 }

 }





 while ( Ow_Next() )
 {
 DevicesFound++;

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

 do {

 Ow_Reset(&PORTE, 2);
 Ow_Write(&PORTE, 2, 0x55);


 for (i=0;i<8;i++)
 {
 Ow_Write(&PORTE, 2, SlaveROM1[i]);
 }
 Delay_ms(10);

 Ow_Write(&PORTE, 2, 0x44);
 Delay_ms(760);



 Ow_Reset(&PORTE, 2);
 Ow_Write(&PORTE, 2, 0x55);


 for (i=0;i<8;i++)
 {
 Ow_Write(&PORTE, 2, SlaveROM1[i]);
 }

 Delay_ms(10);

 Ow_Write(&PORTE, 2, 0xBE);

 temp1 = Ow_Read(&PORTE, 2);
 temp1 = (Ow_Read(&PORTE, 2) << 8) + temp1;


 RES_SHIFT = TEMP_RESOLUTION - 8;
 Lcd_Chr(1,13,178);

 Lcd_Chr(1,14,'C');
 Display_Temperature(temp1,1);




 Ow_Reset(&PORTE, 2);
 Ow_Write(&PORTE, 2, 0x55);


 for (i=0;i<8;i++)
 {
 Ow_Write(&PORTE, 2, SlaveROM2[i]);
 }
 Delay_ms(10);

 Ow_Write(&PORTE, 2, 0x44);
 Delay_ms(760);


 Ow_Reset(&PORTE, 2);
 Ow_Write(&PORTE, 2, 0x55);

 for (i=0;i<8;i++)
 {
 Ow_Write(&PORTE, 2, SlaveROM2[i]);
 }
 Delay_ms(10);
 Ow_Write(&PORTE, 2, 0xBE);


 temp2 = Ow_Read(&PORTE, 2);
 temp2 = (Ow_Read(&PORTE, 2) << 8) + temp2;


 RES_SHIFT = TEMP_RESOLUTION - 8;
 Lcd_Chr(2,13,178);

 Lcd_Chr(2,14,'C');
 Display_Temperature(temp2,2);

 } while (1);
}
