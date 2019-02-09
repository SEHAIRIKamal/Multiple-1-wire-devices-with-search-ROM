
_docrc8:

;DS18B20.c,62 :: 		unsigned char docrc8(unsigned char value)
;DS18B20.c,65 :: 		crc8 = dscrc_table[crc8 ^ value];    // Xor operation
	MOVF       FARG_docrc8_value+0, 0
	XORWF      _crc8+0, 0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      _dscrc_table+0
	ADDWF      R0+0, 1
	MOVLW      hi_addr(_dscrc_table+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _crc8+0
;DS18B20.c,66 :: 		return crc8;
;DS18B20.c,67 :: 		}
L_end_docrc8:
	RETURN
; end of _docrc8

_Ow_Read_Bit:

;DS18B20.c,72 :: 		unsigned short Ow_Read_Bit()
;DS18B20.c,75 :: 		TRISE.B2 = 0;                 // Set pin 2 in PORT E as output
	BCF        TRISE+0, 2
;DS18B20.c,76 :: 		PORTE.B2 = 0;               // Drive bus low   LATE.B2;   for PIC18
	BCF        PORTE+0, 2
;DS18B20.c,77 :: 		delay_us(6);                // Wait 6 usecs
	MOVLW      3
	MOVWF      R13+0
L_Ow_Read_Bit0:
	DECFSZ     R13+0, 1
	GOTO       L_Ow_Read_Bit0
	NOP
	NOP
;DS18B20.c,78 :: 		TRISE.B2 = 1;                 // Release the bus
	BSF        TRISE+0, 2
;DS18B20.c,79 :: 		delay_us(9);                // Wait 9 usecs
	MOVLW      5
	MOVWF      R13+0
L_Ow_Read_Bit1:
	DECFSZ     R13+0, 1
	GOTO       L_Ow_Read_Bit1
	NOP
	NOP
;DS18B20.c,80 :: 		BitValue = PORTE.B2;         // Read bit value on pin 2 on PORT E
	MOVLW      0
	BTFSC      PORTE+0, 2
	MOVLW      1
	MOVWF      R1+0
;DS18B20.c,81 :: 		delay_us(55);               // Wait 55 usecs
	MOVLW      36
	MOVWF      R13+0
L_Ow_Read_Bit2:
	DECFSZ     R13+0, 1
	GOTO       L_Ow_Read_Bit2
	NOP
;DS18B20.c,82 :: 		return BitValue;            // Return bit read
	MOVF       R1+0, 0
	MOVWF      R0+0
;DS18B20.c,83 :: 		}
L_end_Ow_Read_Bit:
	RETURN
; end of _Ow_Read_Bit

_Ow_Write_One:

;DS18B20.c,87 :: 		void Ow_Write_One()
;DS18B20.c,89 :: 		TRISE.B2 = 0;      // Set pin 2 in PORT E as output
	BCF        TRISE+0, 2
;DS18B20.c,90 :: 		PORTE.B2 = 0;    // Drive bus low
	BCF        PORTE+0, 2
;DS18B20.c,91 :: 		delay_us(6);     // Wait 6 usecs        (6*4)*0.25 us
	MOVLW      3
	MOVWF      R13+0
L_Ow_Write_One3:
	DECFSZ     R13+0, 1
	GOTO       L_Ow_Write_One3
	NOP
	NOP
;DS18B20.c,92 :: 		TRISE.B2 = 1;      // Release the bus
	BSF        TRISE+0, 2
;DS18B20.c,93 :: 		delay_us(64);    // Wait 64 usecs        (64*4)*0.25 us
	MOVLW      42
	MOVWF      R13+0
L_Ow_Write_One4:
	DECFSZ     R13+0, 1
	GOTO       L_Ow_Write_One4
	NOP
;DS18B20.c,94 :: 		}
L_end_Ow_Write_One:
	RETURN
; end of _Ow_Write_One

_Ow_Write_Zero:

;DS18B20.c,99 :: 		void Ow_Write_Zero()
;DS18B20.c,101 :: 		TRISE.B2 = 0;     // Set pin 2 in PORT E as output
	BCF        TRISE+0, 2
;DS18B20.c,102 :: 		PORTE.B2 = 0;   // Drive bus low
	BCF        PORTE+0, 2
;DS18B20.c,103 :: 		delay_us(60);   // Wait 60 usecs
	MOVLW      39
	MOVWF      R13+0
L_Ow_Write_Zero5:
	DECFSZ     R13+0, 1
	GOTO       L_Ow_Write_Zero5
	NOP
	NOP
;DS18B20.c,104 :: 		TRISE.B2 = 1;     // Release the bus
	BSF        TRISE+0, 2
;DS18B20.c,105 :: 		delay_us(10);   // Wait 10 usecs
	MOVLW      6
	MOVWF      R13+0
L_Ow_Write_Zero6:
	DECFSZ     R13+0, 1
	GOTO       L_Ow_Write_Zero6
	NOP
;DS18B20.c,106 :: 		}
L_end_Ow_Write_Zero:
	RETURN
; end of _Ow_Write_Zero

_Ow_Search:

;DS18B20.c,109 :: 		int Ow_Search()
;DS18B20.c,117 :: 		id_bit_number = 1;
	MOVLW      1
	MOVWF      Ow_Search_id_bit_number_L0+0
	MOVLW      0
	MOVWF      Ow_Search_id_bit_number_L0+1
;DS18B20.c,118 :: 		last_zero = 0;
	CLRF       Ow_Search_last_zero_L0+0
	CLRF       Ow_Search_last_zero_L0+1
;DS18B20.c,119 :: 		rom_byte_number = 0;
	CLRF       Ow_Search_rom_byte_number_L0+0
	CLRF       Ow_Search_rom_byte_number_L0+1
;DS18B20.c,120 :: 		rom_byte_mask = 1;
	MOVLW      1
	MOVWF      Ow_Search_rom_byte_mask_L0+0
;DS18B20.c,121 :: 		search_result = 0;
	CLRF       Ow_Search_search_result_L0+0
	CLRF       Ow_Search_search_result_L0+1
;DS18B20.c,122 :: 		crc8 = 0;
	CLRF       _crc8+0
;DS18B20.c,125 :: 		if (!LastDeviceFlag)
	MOVF       _LastDeviceFlag+0, 0
	IORWF      _LastDeviceFlag+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Ow_Search7
;DS18B20.c,128 :: 		if (Ow_Reset(&PORTE, 2))
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Ow_Search8
;DS18B20.c,131 :: 		LastDiscrepancy = 0;
	CLRF       _LastDiscrepancy+0
	CLRF       _LastDiscrepancy+1
;DS18B20.c,132 :: 		LastDeviceFlag = 0;
	CLRF       _LastDeviceFlag+0
	CLRF       _LastDeviceFlag+1
;DS18B20.c,133 :: 		LastFamilyDiscrepancy = 0;
	CLRF       _LastFamilyDiscrepancy+0
	CLRF       _LastFamilyDiscrepancy+1
;DS18B20.c,134 :: 		return 0;
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_Ow_Search
;DS18B20.c,135 :: 		}
L_Ow_Search8:
;DS18B20.c,137 :: 		Ow_Write(&PORTE, 2, 0xF0);
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      240
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,140 :: 		do
L_Ow_Search9:
;DS18B20.c,143 :: 		id_bit = OW_Read_Bit();
	CALL       _Ow_Read_Bit+0
	MOVF       R0+0, 0
	MOVWF      Ow_Search_id_bit_L0+0
	CLRF       Ow_Search_id_bit_L0+1
;DS18B20.c,144 :: 		cmp_id_bit = OW_Read_Bit();
	CALL       _Ow_Read_Bit+0
	MOVF       R0+0, 0
	MOVWF      Ow_Search_cmp_id_bit_L0+0
	CLRF       Ow_Search_cmp_id_bit_L0+1
;DS18B20.c,149 :: 		if ((id_bit == 1) && (cmp_id_bit == 1))
	MOVLW      0
	XORWF      Ow_Search_id_bit_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Ow_Search81
	MOVLW      1
	XORWF      Ow_Search_id_bit_L0+0, 0
L__Ow_Search81:
	BTFSS      STATUS+0, 2
	GOTO       L_Ow_Search14
	MOVLW      0
	XORWF      Ow_Search_cmp_id_bit_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Ow_Search82
	MOVLW      1
	XORWF      Ow_Search_cmp_id_bit_L0+0, 0
L__Ow_Search82:
	BTFSS      STATUS+0, 2
	GOTO       L_Ow_Search14
L__Ow_Search75:
;DS18B20.c,150 :: 		break;
	GOTO       L_Ow_Search10
L_Ow_Search14:
;DS18B20.c,154 :: 		if (id_bit != cmp_id_bit)
	MOVF       Ow_Search_id_bit_L0+1, 0
	XORWF      Ow_Search_cmp_id_bit_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Ow_Search83
	MOVF       Ow_Search_cmp_id_bit_L0+0, 0
	XORWF      Ow_Search_id_bit_L0+0, 0
L__Ow_Search83:
	BTFSC      STATUS+0, 2
	GOTO       L_Ow_Search16
;DS18B20.c,155 :: 		search_direction = id_bit; // bit write value for search
	MOVF       Ow_Search_id_bit_L0+0, 0
	MOVWF      Ow_Search_search_direction_L0+0
	GOTO       L_Ow_Search17
L_Ow_Search16:
;DS18B20.c,161 :: 		if (id_bit_number < LastDiscrepancy)
	MOVLW      128
	XORWF      Ow_Search_id_bit_number_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _LastDiscrepancy+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Ow_Search84
	MOVF       _LastDiscrepancy+0, 0
	SUBWF      Ow_Search_id_bit_number_L0+0, 0
L__Ow_Search84:
	BTFSC      STATUS+0, 0
	GOTO       L_Ow_Search18
;DS18B20.c,162 :: 		search_direction = ((ROM_NO[rom_byte_number] &  rom_byte_mask) > 0);
	MOVF       Ow_Search_rom_byte_number_L0+0, 0
	ADDLW      _ROM_NO+0
	MOVWF      FSR
	MOVF       Ow_Search_rom_byte_mask_L0+0, 0
	ANDWF      INDF+0, 0
	MOVWF      Ow_Search_search_direction_L0+0
	MOVF       Ow_Search_search_direction_L0+0, 0
	SUBLW      0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      Ow_Search_search_direction_L0+0
	GOTO       L_Ow_Search19
L_Ow_Search18:
;DS18B20.c,165 :: 		search_direction = (id_bit_number == LastDiscrepancy);
	MOVF       Ow_Search_id_bit_number_L0+1, 0
	XORWF      _LastDiscrepancy+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Ow_Search85
	MOVF       _LastDiscrepancy+0, 0
	XORWF      Ow_Search_id_bit_number_L0+0, 0
L__Ow_Search85:
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      Ow_Search_search_direction_L0+0
L_Ow_Search19:
;DS18B20.c,168 :: 		if (search_direction == 0)
	MOVF       Ow_Search_search_direction_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Ow_Search20
;DS18B20.c,170 :: 		last_zero = id_bit_number;
	MOVF       Ow_Search_id_bit_number_L0+0, 0
	MOVWF      Ow_Search_last_zero_L0+0
	MOVF       Ow_Search_id_bit_number_L0+1, 0
	MOVWF      Ow_Search_last_zero_L0+1
;DS18B20.c,172 :: 		if (last_zero < 9) LastFamilyDiscrepancy = last_zero;
	MOVLW      128
	XORWF      Ow_Search_id_bit_number_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Ow_Search86
	MOVLW      9
	SUBWF      Ow_Search_id_bit_number_L0+0, 0
L__Ow_Search86:
	BTFSC      STATUS+0, 0
	GOTO       L_Ow_Search21
	MOVF       Ow_Search_last_zero_L0+0, 0
	MOVWF      _LastFamilyDiscrepancy+0
	MOVF       Ow_Search_last_zero_L0+1, 0
	MOVWF      _LastFamilyDiscrepancy+1
L_Ow_Search21:
;DS18B20.c,173 :: 		}
L_Ow_Search20:
;DS18B20.c,174 :: 		}
L_Ow_Search17:
;DS18B20.c,180 :: 		if (search_direction == 1)
	MOVF       Ow_Search_search_direction_L0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Ow_Search22
;DS18B20.c,181 :: 		ROM_NO[rom_byte_number] |= rom_byte_mask;
	MOVF       Ow_Search_rom_byte_number_L0+0, 0
	ADDLW      _ROM_NO+0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       Ow_Search_rom_byte_mask_L0+0, 0
	IORWF      INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	GOTO       L_Ow_Search23
L_Ow_Search22:
;DS18B20.c,183 :: 		ROM_NO[rom_byte_number] &= ~rom_byte_mask;
	MOVF       Ow_Search_rom_byte_number_L0+0, 0
	ADDLW      _ROM_NO+0
	MOVWF      R1+0
	COMF       Ow_Search_rom_byte_mask_L0+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	ANDWF      R0+0, 1
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
L_Ow_Search23:
;DS18B20.c,187 :: 		if (search_direction)
	MOVF       Ow_Search_search_direction_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Ow_Search24
;DS18B20.c,188 :: 		Ow_Write_One();
	CALL       _Ow_Write_One+0
	GOTO       L_Ow_Search25
L_Ow_Search24:
;DS18B20.c,190 :: 		Ow_Write_Zero();
	CALL       _Ow_Write_Zero+0
L_Ow_Search25:
;DS18B20.c,194 :: 		id_bit_number++;
	INCF       Ow_Search_id_bit_number_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       Ow_Search_id_bit_number_L0+1, 1
;DS18B20.c,195 :: 		rom_byte_mask <<= 1;
	MOVF       Ow_Search_rom_byte_mask_L0+0, 0
	MOVWF      R1+0
	RLF        R1+0, 1
	BCF        R1+0, 0
	MOVF       R1+0, 0
	MOVWF      Ow_Search_rom_byte_mask_L0+0
;DS18B20.c,200 :: 		if (rom_byte_mask == 0)
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Ow_Search26
;DS18B20.c,202 :: 		docrc8(ROM_NO[rom_byte_number]); // accumulate the CRC
	MOVF       Ow_Search_rom_byte_number_L0+0, 0
	ADDLW      _ROM_NO+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_docrc8_value+0
	CALL       _docrc8+0
;DS18B20.c,203 :: 		rom_byte_number++;
	INCF       Ow_Search_rom_byte_number_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       Ow_Search_rom_byte_number_L0+1, 1
;DS18B20.c,204 :: 		rom_byte_mask = 1;
	MOVLW      1
	MOVWF      Ow_Search_rom_byte_mask_L0+0
;DS18B20.c,205 :: 		}
L_Ow_Search26:
;DS18B20.c,208 :: 		while(rom_byte_number < 8); // loop until through all ROM bytes 0-7
	MOVLW      128
	XORWF      Ow_Search_rom_byte_number_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Ow_Search87
	MOVLW      8
	SUBWF      Ow_Search_rom_byte_number_L0+0, 0
L__Ow_Search87:
	BTFSS      STATUS+0, 0
	GOTO       L_Ow_Search9
L_Ow_Search10:
;DS18B20.c,211 :: 		if (!((id_bit_number < 65) || (crc8 != 0)))
	MOVLW      128
	XORWF      Ow_Search_id_bit_number_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Ow_Search88
	MOVLW      65
	SUBWF      Ow_Search_id_bit_number_L0+0, 0
L__Ow_Search88:
	BTFSS      STATUS+0, 0
	GOTO       L_Ow_Search28
	MOVF       _crc8+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Ow_Search28
	CLRF       R0+0
	GOTO       L_Ow_Search27
L_Ow_Search28:
	MOVLW      1
	MOVWF      R0+0
L_Ow_Search27:
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Ow_Search29
;DS18B20.c,214 :: 		LastDiscrepancy = last_zero;
	MOVF       Ow_Search_last_zero_L0+0, 0
	MOVWF      _LastDiscrepancy+0
	MOVF       Ow_Search_last_zero_L0+1, 0
	MOVWF      _LastDiscrepancy+1
;DS18B20.c,217 :: 		if (LastDiscrepancy == 0) LastDeviceFlag = 1;
	MOVLW      0
	XORWF      Ow_Search_last_zero_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Ow_Search89
	MOVLW      0
	XORWF      Ow_Search_last_zero_L0+0, 0
L__Ow_Search89:
	BTFSS      STATUS+0, 2
	GOTO       L_Ow_Search30
	MOVLW      1
	MOVWF      _LastDeviceFlag+0
	MOVLW      0
	MOVWF      _LastDeviceFlag+1
L_Ow_Search30:
;DS18B20.c,218 :: 		search_result = 1;
	MOVLW      1
	MOVWF      Ow_Search_search_result_L0+0
	MOVLW      0
	MOVWF      Ow_Search_search_result_L0+1
;DS18B20.c,219 :: 		}
L_Ow_Search29:
;DS18B20.c,220 :: 		}
L_Ow_Search7:
;DS18B20.c,225 :: 		if (!search_result || !ROM_NO[0])
	MOVF       Ow_Search_search_result_L0+0, 0
	IORWF      Ow_Search_search_result_L0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Ow_Search74
	MOVF       _ROM_NO+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Ow_Search74
	GOTO       L_Ow_Search33
L__Ow_Search74:
;DS18B20.c,227 :: 		LastDiscrepancy = 0;
	CLRF       _LastDiscrepancy+0
	CLRF       _LastDiscrepancy+1
;DS18B20.c,228 :: 		LastDeviceFlag = 0;
	CLRF       _LastDeviceFlag+0
	CLRF       _LastDeviceFlag+1
;DS18B20.c,229 :: 		LastFamilyDiscrepancy = 0;
	CLRF       _LastFamilyDiscrepancy+0
	CLRF       _LastFamilyDiscrepancy+1
;DS18B20.c,230 :: 		search_result = 0;
	CLRF       Ow_Search_search_result_L0+0
	CLRF       Ow_Search_search_result_L0+1
;DS18B20.c,231 :: 		}
L_Ow_Search33:
;DS18B20.c,232 :: 		return search_result;
	MOVF       Ow_Search_search_result_L0+0, 0
	MOVWF      R0+0
	MOVF       Ow_Search_search_result_L0+1, 0
	MOVWF      R0+1
;DS18B20.c,233 :: 		}   // End of Ow-Search function
L_end_Ow_Search:
	RETURN
; end of _Ow_Search

_Ow_First:

;DS18B20.c,237 :: 		int Ow_First()
;DS18B20.c,239 :: 		LastDiscrepancy = 0;
	CLRF       _LastDiscrepancy+0
	CLRF       _LastDiscrepancy+1
;DS18B20.c,240 :: 		LastDeviceFlag = 0;
	CLRF       _LastDeviceFlag+0
	CLRF       _LastDeviceFlag+1
;DS18B20.c,241 :: 		LastFamilyDiscrepancy = 0;
	CLRF       _LastFamilyDiscrepancy+0
	CLRF       _LastFamilyDiscrepancy+1
;DS18B20.c,242 :: 		return Ow_Search();
	CALL       _Ow_Search+0
;DS18B20.c,243 :: 		}
L_end_Ow_First:
	RETURN
; end of _Ow_First

_Ow_Next:

;DS18B20.c,248 :: 		int Ow_Next()
;DS18B20.c,250 :: 		return Ow_Search();
	CALL       _Ow_Search+0
;DS18B20.c,251 :: 		}
L_end_Ow_Next:
	RETURN
; end of _Ow_Next

_Ow_Target_Setup:

;DS18B20.c,255 :: 		void Ow_Target_Setup(unsigned char family_code)
;DS18B20.c,259 :: 		ROM_NO[0] = family_code;
	MOVF       FARG_Ow_Target_Setup_family_code+0, 0
	MOVWF      _ROM_NO+0
;DS18B20.c,260 :: 		for (i = 1; i < 8; i++)
	MOVLW      1
	MOVWF      R1+0
	MOVLW      0
	MOVWF      R1+1
L_Ow_Target_Setup34:
	MOVLW      128
	XORWF      R1+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Ow_Target_Setup93
	MOVLW      8
	SUBWF      R1+0, 0
L__Ow_Target_Setup93:
	BTFSC      STATUS+0, 0
	GOTO       L_Ow_Target_Setup35
;DS18B20.c,261 :: 		ROM_NO[i] = 0;
	MOVF       R1+0, 0
	ADDLW      _ROM_NO+0
	MOVWF      FSR
	CLRF       INDF+0
;DS18B20.c,260 :: 		for (i = 1; i < 8; i++)
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;DS18B20.c,261 :: 		ROM_NO[i] = 0;
	GOTO       L_Ow_Target_Setup34
L_Ow_Target_Setup35:
;DS18B20.c,262 :: 		LastDiscrepancy = 64;
	MOVLW      64
	MOVWF      _LastDiscrepancy+0
	MOVLW      0
	MOVWF      _LastDiscrepancy+1
;DS18B20.c,263 :: 		LastFamilyDiscrepancy = 0;
	CLRF       _LastFamilyDiscrepancy+0
	CLRF       _LastFamilyDiscrepancy+1
;DS18B20.c,264 :: 		LastDeviceFlag = 0;
	CLRF       _LastDeviceFlag+0
	CLRF       _LastDeviceFlag+1
;DS18B20.c,265 :: 		}
L_end_Ow_Target_Setup:
	RETURN
; end of _Ow_Target_Setup

_Ow_Family_Skip_Setup:

;DS18B20.c,268 :: 		void Ow_Family_Skip_Setup()
;DS18B20.c,271 :: 		LastDiscrepancy = LastFamilyDiscrepancy;
	MOVF       _LastFamilyDiscrepancy+0, 0
	MOVWF      _LastDiscrepancy+0
	MOVF       _LastFamilyDiscrepancy+1, 0
	MOVWF      _LastDiscrepancy+1
;DS18B20.c,272 :: 		LastFamilyDiscrepancy = 0;
	CLRF       _LastFamilyDiscrepancy+0
	CLRF       _LastFamilyDiscrepancy+1
;DS18B20.c,274 :: 		if (LastDiscrepancy == 0)
	MOVLW      0
	XORWF      _LastDiscrepancy+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Ow_Family_Skip_Setup95
	MOVLW      0
	XORWF      _LastDiscrepancy+0, 0
L__Ow_Family_Skip_Setup95:
	BTFSS      STATUS+0, 2
	GOTO       L_Ow_Family_Skip_Setup37
;DS18B20.c,275 :: 		LastDeviceFlag = 1;
	MOVLW      1
	MOVWF      _LastDeviceFlag+0
	MOVLW      0
	MOVWF      _LastDeviceFlag+1
L_Ow_Family_Skip_Setup37:
;DS18B20.c,276 :: 		}
L_end_Ow_Family_Skip_Setup:
	RETURN
; end of _Ow_Family_Skip_Setup

_Display_Temperature:

;DS18B20.c,277 :: 		void Display_Temperature(unsigned int temp2write,unsigned x ) {
;DS18B20.c,283 :: 		if (temp2write & 0x8000) {
	BTFSS      FARG_Display_Temperature_temp2write+1, 7
	GOTO       L_Display_Temperature38
;DS18B20.c,284 :: 		text[0] = '-';
	MOVF       _text+0, 0
	MOVWF      FSR
	MOVLW      45
	MOVWF      INDF+0
;DS18B20.c,285 :: 		temp2write = ~temp2write + 1;
	COMF       FARG_Display_Temperature_temp2write+0, 0
	MOVWF      R0+0
	COMF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      1
	MOVWF      R3+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      R3+1
	MOVF       R3+0, 0
	MOVWF      FARG_Display_Temperature_temp2write+0
	MOVF       R3+1, 0
	MOVWF      FARG_Display_Temperature_temp2write+1
;DS18B20.c,287 :: 		temp_whole = temp2write >> RES_SHIFT ;
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_whole_L0+0
;DS18B20.c,288 :: 		text[1] = (temp_whole/10)%10 + 48;             // Extract tens digit
	INCF       _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Div_8X8_U+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,289 :: 		text[2] =  temp_whole%10     + 48;             // Extract ones digit
	MOVLW      2
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       Display_Temperature_temp_whole_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,292 :: 		temp_fraction  = temp2write << (4-RES_SHIFT);
	MOVF       FARG_Display_Temperature_temp2write+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;DS18B20.c,293 :: 		temp_fraction &= 0x000F;
	MOVLW      15
	ANDWF      FARG_Display_Temperature_temp2write+0, 0
	MOVWF      R0+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      R0+1
	MOVLW      0
	ANDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       R0+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;DS18B20.c,294 :: 		temp_fraction *= 625;
	MOVLW      113
	MOVWF      R4+0
	MOVLW      2
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       R0+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;DS18B20.c,297 :: 		text[4] =  temp_fraction/1000    + 48;         // Extract thousands digit
	MOVLW      4
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,298 :: 		text[5] = (temp_fraction/100)%10 + 48;         // Extract hundreds digit
	MOVLW      5
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,299 :: 		text[6] = (temp_fraction/10)%10  + 48;         // Extract tens digit
	MOVLW      6
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,300 :: 		text[7] =  temp_fraction%10      + 48;         // Extract ones digit
	MOVLW      7
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,303 :: 		Lcd_Out(x, 5, text);
	MOVF       FARG_Display_Temperature_x+0, 0
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DS18B20.c,304 :: 		}
	GOTO       L_Display_Temperature39
L_Display_Temperature38:
;DS18B20.c,308 :: 		temp_whole = temp2write >> RES_SHIFT ;
	MOVF       FARG_Display_Temperature_temp2write+0, 0
	MOVWF      R0+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_whole_L0+0
;DS18B20.c,311 :: 		if (temp_whole/100)
	MOVLW      100
	MOVWF      R4+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Display_Temperature40
;DS18B20.c,312 :: 		text[0] = temp_whole/100  + 48;
	MOVLW      100
	MOVWF      R4+0
	MOVF       Display_Temperature_temp_whole_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       _text+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	GOTO       L_Display_Temperature41
L_Display_Temperature40:
;DS18B20.c,314 :: 		text[0] = '0';
	MOVF       _text+0, 0
	MOVWF      FSR
	MOVLW      48
	MOVWF      INDF+0
L_Display_Temperature41:
;DS18B20.c,316 :: 		text[1] = (temp_whole/10)%10 + 48;             // Extract tens digit
	INCF       _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       Display_Temperature_temp_whole_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,317 :: 		text[2] =  temp_whole%10     + 48;             // Extract ones digit
	MOVLW      2
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       Display_Temperature_temp_whole_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,320 :: 		temp_fraction  = temp2write << (4-RES_SHIFT);
	MOVF       FARG_Display_Temperature_temp2write+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;DS18B20.c,321 :: 		temp_fraction &= 0x000F;
	MOVLW      15
	ANDWF      FARG_Display_Temperature_temp2write+0, 0
	MOVWF      R0+0
	MOVF       FARG_Display_Temperature_temp2write+1, 0
	MOVWF      R0+1
	MOVLW      0
	ANDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       R0+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;DS18B20.c,322 :: 		temp_fraction *= 625;
	MOVLW      113
	MOVWF      R4+0
	MOVLW      2
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      Display_Temperature_temp_fraction_L0+0
	MOVF       R0+1, 0
	MOVWF      Display_Temperature_temp_fraction_L0+1
;DS18B20.c,325 :: 		text[4] =  temp_fraction/1000    + 48;         // Extract thousands digit
	MOVLW      4
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,326 :: 		text[5] = (temp_fraction/100)%10 + 48;         // Extract hundreds digit
	MOVLW      5
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,327 :: 		text[6] = (temp_fraction/10)%10  + 48;         // Extract tens digit
	MOVLW      6
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,328 :: 		text[7] =  temp_fraction%10      + 48;         // Extract ones digit
	MOVLW      7
	ADDWF      _text+0, 0
	MOVWF      FLOC__Display_Temperature+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       Display_Temperature_temp_fraction_L0+0, 0
	MOVWF      R0+0
	MOVF       Display_Temperature_temp_fraction_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__Display_Temperature+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,331 :: 		Lcd_Out(x, 5, text);
	MOVF       FARG_Display_Temperature_x+0, 0
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DS18B20.c,332 :: 		}
L_Display_Temperature39:
;DS18B20.c,333 :: 		}
L_end_Display_Temperature:
	RETURN
; end of _Display_Temperature

_main:

;DS18B20.c,342 :: 		void main() {
;DS18B20.c,343 :: 		ANSEL  = 0;                                    // Configure AN pins as digital I/O
	CLRF       ANSEL+0
;DS18B20.c,344 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;DS18B20.c,345 :: 		C1ON_bit = 0;                                  // Disable comparators
	BCF        C1ON_bit+0, BitPos(C1ON_bit+0)
;DS18B20.c,346 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, BitPos(C2ON_bit+0)
;DS18B20.c,348 :: 		Lcd_Init();                                    // Initialize LCD
	CALL       _Lcd_Init+0
;DS18B20.c,349 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DS18B20.c,350 :: 		Lcd_Cmd(_LCD_CLEAR);                            // Clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DS18B20.c,351 :: 		Ow_Reset(&PORTE, 2);
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;DS18B20.c,352 :: 		Ow_Write(&PORTE, 2, 0xF0);                   // Issue command Search_ROM
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      240
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,354 :: 		DevicesFound = 0;  // Reset device counter
	CLRF       _DevicesFound+0
	CLRF       _DevicesFound+1
;DS18B20.c,355 :: 		if ( Ow_First() )    // Check for the first device
	CALL       _Ow_First+0
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main42
;DS18B20.c,357 :: 		DevicesFound++;  // Increment the device found counter
	INCF       _DevicesFound+0, 1
	BTFSC      STATUS+0, 2
	INCF       _DevicesFound+1, 1
;DS18B20.c,359 :: 		for(i=0; i<8; i++)
	CLRF       _i+0
L_main43:
	MOVLW      8
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main44
;DS18B20.c,361 :: 		ByteToHex(ROM_NO[i],tmp1);
	MOVF       _i+0, 0
	ADDLW      _ROM_NO+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _tmp1+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;DS18B20.c,362 :: 		Lcd_Out(1, 15-2*i, tmp1);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVF       _i+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	SUBLW      15
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _tmp1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DS18B20.c,363 :: 		SlaveROM1[i]=ROM_NO[i];
	MOVF       _i+0, 0
	ADDLW      _SlaveROM1+0
	MOVWF      R1+0
	MOVF       _i+0, 0
	ADDLW      _ROM_NO+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,359 :: 		for(i=0; i<8; i++)
	INCF       _i+0, 1
;DS18B20.c,365 :: 		}
	GOTO       L_main43
L_main44:
;DS18B20.c,367 :: 		}
L_main42:
;DS18B20.c,373 :: 		while ( Ow_Next() )
L_main46:
	CALL       _Ow_Next+0
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main47
;DS18B20.c,375 :: 		DevicesFound++;  // Increment the devices found counter
	INCF       _DevicesFound+0, 1
	BTFSC      STATUS+0, 2
	INCF       _DevicesFound+1, 1
;DS18B20.c,377 :: 		for(i=0; i<8; i++)
	CLRF       _i+0
L_main48:
	MOVLW      8
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main49
;DS18B20.c,379 :: 		ByteToHex(ROM_NO[i],tmp2);
	MOVF       _i+0, 0
	ADDLW      _ROM_NO+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _tmp2+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;DS18B20.c,380 :: 		Lcd_Out(2, 15-2*i, tmp2);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVF       _i+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	SUBLW      15
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _tmp2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DS18B20.c,381 :: 		SlaveROM2[i]=ROM_NO[i];
	MOVF       _i+0, 0
	ADDLW      _SlaveROM2+0
	MOVWF      R1+0
	MOVF       _i+0, 0
	ADDLW      _ROM_NO+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;DS18B20.c,377 :: 		for(i=0; i<8; i++)
	INCF       _i+0, 1
;DS18B20.c,382 :: 		}
	GOTO       L_main48
L_main49:
;DS18B20.c,383 :: 		}
	GOTO       L_main46
L_main47:
;DS18B20.c,386 :: 		if (DevicesFound == 0) Lcd_Out (1,1,"No devices found\n");
	MOVLW      0
	XORWF      _DevicesFound+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVLW      0
	XORWF      _DevicesFound+0, 0
L__main98:
	BTFSS      STATUS+0, 2
	GOTO       L_main51
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_DS18B20+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_main51:
;DS18B20.c,387 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main52:
	DECFSZ     R13+0, 1
	GOTO       L_main52
	DECFSZ     R12+0, 1
	GOTO       L_main52
	DECFSZ     R11+0, 1
	GOTO       L_main52
	NOP
	NOP
;DS18B20.c,388 :: 		Lcd_Cmd(_Lcd_Clear);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DS18B20.c,390 :: 		do {
L_main53:
;DS18B20.c,392 :: 		Ow_Reset(&PORTE, 2);                         // Onewire reset signal
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;DS18B20.c,393 :: 		Ow_Write(&PORTE, 2, 0x55);                   // Issue command Match_ROM
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      85
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,396 :: 		for (i=0;i<8;i++)
	CLRF       _i+0
L_main56:
	MOVLW      8
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main57
;DS18B20.c,398 :: 		Ow_Write(&PORTE, 2, SlaveROM1[i]);
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVF       _i+0, 0
	ADDLW      _SlaveROM1+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,396 :: 		for (i=0;i<8;i++)
	INCF       _i+0, 1
;DS18B20.c,399 :: 		}
	GOTO       L_main56
L_main57:
;DS18B20.c,400 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_main59:
	DECFSZ     R13+0, 1
	GOTO       L_main59
	DECFSZ     R12+0, 1
	GOTO       L_main59
	NOP
;DS18B20.c,402 :: 		Ow_Write(&PORTE, 2, 0x44);                   // Issue command CONVERT_T
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      68
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,403 :: 		Delay_ms(760);        // 760ms
	MOVLW      8
	MOVWF      R11+0
	MOVLW      182
	MOVWF      R12+0
	MOVLW      255
	MOVWF      R13+0
L_main60:
	DECFSZ     R13+0, 1
	GOTO       L_main60
	DECFSZ     R12+0, 1
	GOTO       L_main60
	DECFSZ     R11+0, 1
	GOTO       L_main60
	NOP
	NOP
;DS18B20.c,407 :: 		Ow_Reset(&PORTE, 2);                         // Onewire reset signal
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;DS18B20.c,408 :: 		Ow_Write(&PORTE, 2, 0x55);                   // Issue command Match_ROM
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      85
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,411 :: 		for (i=0;i<8;i++)
	CLRF       _i+0
L_main61:
	MOVLW      8
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main62
;DS18B20.c,413 :: 		Ow_Write(&PORTE, 2, SlaveROM1[i]);
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVF       _i+0, 0
	ADDLW      _SlaveROM1+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,411 :: 		for (i=0;i<8;i++)
	INCF       _i+0, 1
;DS18B20.c,414 :: 		}
	GOTO       L_main61
L_main62:
;DS18B20.c,416 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_main64:
	DECFSZ     R13+0, 1
	GOTO       L_main64
	DECFSZ     R12+0, 1
	GOTO       L_main64
	NOP
;DS18B20.c,418 :: 		Ow_Write(&PORTE, 2, 0xBE);                   // Issue command READ_SCRATCHPAD
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      190
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,420 :: 		temp1 =  Ow_Read(&PORTE, 2);                  // LSB (the LSB is first transferred
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp1+0
	CLRF       _temp1+1
;DS18B20.c,421 :: 		temp1 = (Ow_Read(&PORTE, 2) << 8) + temp1;     // shift left to form the MSB then add the LSB
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      R1+1
	CLRF       R1+0
	MOVF       R1+0, 0
	ADDWF      _temp1+0, 1
	MOVF       R1+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp1+1, 1
;DS18B20.c,424 :: 		RES_SHIFT = TEMP_RESOLUTION - 8;
	MOVLW      4
	MOVWF      _RES_SHIFT+0
;DS18B20.c,425 :: 		Lcd_Chr(1,13,178);                 // Different LCD displays have different char code for degree
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      178
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;DS18B20.c,427 :: 		Lcd_Chr(1,14,'C');                              // Print degree character, 'C' for Centigrades
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      67
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;DS18B20.c,428 :: 		Display_Temperature(temp1,1);
	MOVF       _temp1+0, 0
	MOVWF      FARG_Display_Temperature_temp2write+0
	MOVF       _temp1+1, 0
	MOVWF      FARG_Display_Temperature_temp2write+1
	MOVLW      1
	MOVWF      FARG_Display_Temperature_x+0
	MOVLW      0
	MOVWF      FARG_Display_Temperature_x+1
	CALL       _Display_Temperature+0
;DS18B20.c,433 :: 		Ow_Reset(&PORTE, 2);                         // Onewire reset signal
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;DS18B20.c,434 :: 		Ow_Write(&PORTE, 2, 0x55);                   // Issue command Match_ROM
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      85
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,437 :: 		for (i=0;i<8;i++)
	CLRF       _i+0
L_main65:
	MOVLW      8
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main66
;DS18B20.c,439 :: 		Ow_Write(&PORTE, 2, SlaveROM2[i]);
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVF       _i+0, 0
	ADDLW      _SlaveROM2+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,437 :: 		for (i=0;i<8;i++)
	INCF       _i+0, 1
;DS18B20.c,440 :: 		}
	GOTO       L_main65
L_main66:
;DS18B20.c,441 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_main68:
	DECFSZ     R13+0, 1
	GOTO       L_main68
	DECFSZ     R12+0, 1
	GOTO       L_main68
	NOP
;DS18B20.c,443 :: 		Ow_Write(&PORTE, 2, 0x44);                   // Issue command CONVERT_T
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      68
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,444 :: 		Delay_ms(760);        // 760ms
	MOVLW      8
	MOVWF      R11+0
	MOVLW      182
	MOVWF      R12+0
	MOVLW      255
	MOVWF      R13+0
L_main69:
	DECFSZ     R13+0, 1
	GOTO       L_main69
	DECFSZ     R12+0, 1
	GOTO       L_main69
	DECFSZ     R11+0, 1
	GOTO       L_main69
	NOP
	NOP
;DS18B20.c,447 :: 		Ow_Reset(&PORTE, 2);
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;DS18B20.c,448 :: 		Ow_Write(&PORTE, 2, 0x55);                   // Issue command Match_ROM
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      85
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,450 :: 		for (i=0;i<8;i++)
	CLRF       _i+0
L_main70:
	MOVLW      8
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main71
;DS18B20.c,452 :: 		Ow_Write(&PORTE, 2, SlaveROM2[i]);
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVF       _i+0, 0
	ADDLW      _SlaveROM2+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,450 :: 		for (i=0;i<8;i++)
	INCF       _i+0, 1
;DS18B20.c,453 :: 		}
	GOTO       L_main70
L_main71:
;DS18B20.c,454 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_main73:
	DECFSZ     R13+0, 1
	GOTO       L_main73
	DECFSZ     R12+0, 1
	GOTO       L_main73
	NOP
;DS18B20.c,455 :: 		Ow_Write(&PORTE, 2, 0xBE);                   // Issue command READ_SCRATCHPAD
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      190
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;DS18B20.c,458 :: 		temp2 =  Ow_Read(&PORTE, 2);                  // LSB (the LSB is first transferred
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp2+0
	CLRF       _temp2+1
;DS18B20.c,459 :: 		temp2 = (Ow_Read(&PORTE, 2) << 8) + temp2;     // shift left to form the MSB then add the LSB
	MOVLW      PORTE+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      2
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      R1+1
	CLRF       R1+0
	MOVF       R1+0, 0
	ADDWF      _temp2+0, 1
	MOVF       R1+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp2+1, 1
;DS18B20.c,462 :: 		RES_SHIFT = TEMP_RESOLUTION - 8;
	MOVLW      4
	MOVWF      _RES_SHIFT+0
;DS18B20.c,463 :: 		Lcd_Chr(2,13,178);                 // Different LCD displays have different char code for degree
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      178
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;DS18B20.c,465 :: 		Lcd_Chr(2,14,'C');                              // Print degree character, 'C' for Centigrades
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      67
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;DS18B20.c,466 :: 		Display_Temperature(temp2,2);
	MOVF       _temp2+0, 0
	MOVWF      FARG_Display_Temperature_temp2write+0
	MOVF       _temp2+1, 0
	MOVWF      FARG_Display_Temperature_temp2write+1
	MOVLW      2
	MOVWF      FARG_Display_Temperature_x+0
	MOVLW      0
	MOVWF      FARG_Display_Temperature_x+1
	CALL       _Display_Temperature+0
;DS18B20.c,468 :: 		} while (1);
	GOTO       L_main53
;DS18B20.c,469 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
