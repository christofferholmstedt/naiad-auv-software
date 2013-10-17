-- This code contains the main functions of the Sensor controller firmware

-- Written by: Nils Brynedal Ignell for the Naiad AUV project
-- Last changed (yyyy-mm-dd): 2013-10-17

--with Text_IO;  -- for debugging

with CAN_Defs;
with Temp_Sensor;
with Pressure_Sensor;

with Ada.Unchecked_Conversion;

package body Sensor_Controller_pack is

   pragma Suppress (All_Checks);


   function u8Readings_To_Bytes (i16Temp : Interfaces.Integer_16;
                                 u16Pressure : Interfaces.Unsigned_16;
                                 u8Salinity : Interfaces.Unsigned_8)
                                 return AVR.AT90CAN128.CAN.Byte8 is
      use Interfaces;
      function u16_From_i16 is new Ada.Unchecked_Conversion (Interfaces.Integer_16, Interfaces.Unsigned_16);

      u8Ret : AVR.AT90CAN128.CAN.Byte8;
      u16Temporary : Interfaces.Unsigned_16;
   begin

      u16Temporary :=   u16_From_i16(i16Temp);

      u8Ret(1) := Interfaces.Unsigned_8(u16Temporary / 256);
      u8Ret(2) := Interfaces.Unsigned_8(u16Temporary rem 256);
      u8Ret(3) := Interfaces.Unsigned_8(u16Pressure / 256);
      u8Ret(4) := Interfaces.Unsigned_8(u16Pressure rem 256);
      u8Ret(5) := u8Salinity;
      return u8Ret;
   end u8Readings_To_Bytes;


   procedure Handle_Can is
      use AVR.AT90CAN128.CAN;
      use Interfaces;
      received_message  : AVR.AT90CAN128.CAN.CAN_Message;
      bMessageReceived 	: Boolean;
   begin
      AVR.AT90CAN128.CAN.Can_Get(received_message, bMessageReceived, 0);
      while bMessageReceived loop
         --  Handle the message
         if received_message.ID = CAN_Defs.MSG_SIMULATION_MODE_ID then
              if received_message.Data(1) = CAN_Defs.SIMULATION_MODE_NOT_ACTIVE then
               bSimulate := false;
            elsif received_message.Data(1) = CAN_Defs.SIMULATION_MODE_ACTIVE then
               bSimulate := true;
            end if;
         end if;

         AVR.AT90CAN128.CAN.Can_Get(received_message, bMessageReceived, 0);
      end loop;
   end Handle_Can;

   procedure Handle_Sensors is
      send_message         : AVR.AT90CAN128.CAN.CAN_Message;
      i16Temp : Interfaces.Integer_16;
      u16Pressure : Interfaces.Unsigned_16;
      u8Salinity : Interfaces.Unsigned_8;
      sTemp : String := "+125.6";
   begin
      send_message.ID := CAN_Defs.MSG_SENSOR_ID;
      send_message.Len := 5;

      ----------------- FOR DEBUGGING PURPOSES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--        Text_IO.Put_Line("temperature:");
--        Text_IO.Put_Line(Temp_Sensor.i16ToStr(i16Temp));
--        return;
      ----------------- FOR DEBUGGING PURPOSES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

      i16Temp := Temp_Sensor.i16Get_Temp_Int;
      Temp_Sensor.i16ToStr(i16Temp, sTemp);
      Salinity_Sensor.Set_Temperature(sTemp);
      u8Salinity  := Salinity_Sensor.Get_Salinity;
      u16Pressure := Pressure_Sensor.u16GetPressure;

      if bSimulate = false then --send message if not simulating:
         send_message.Data := u8Readings_To_Bytes (i16Temp, u16Pressure, u8Salinity);
         AVR.AT90CAN128.CAN.Can_Send (send_message);
      end if;
   end Handle_Sensors;

   procedure Init is
      sTemp : String := "+125.6";
      i16Temp : Interfaces.Integer_16;
   begin

      Pressure_Sensor.Init(uPRESSURE_PIN);
      Temp_Sensor.Init(uTEMP_PIN);

      AVR.AT90CAN128.CAN.Can_Init (AVR.AT90CAN128.CAN.K250);

      --enable reception on only simulation messages:
      AVR.AT90CAN128.CAN.Can_Set_All_MOB_ID_MASK(CAN_Defs.MSG_SIMULATION_MODE_ID, 2047);

      --Start the salinity sensor:
      --The salinity sensor needs a temperature reading for accuracy
      i16Temp := Temp_Sensor.i16Get_Temp_Int;
      Temp_Sensor.i16ToStr(i16Temp, sTemp);
      Salinity_Sensor.Initate_Salinity_Sensor (UARTPort, sTemp(3 .. 6));
   end Init;

end Sensor_Controller_pack;
