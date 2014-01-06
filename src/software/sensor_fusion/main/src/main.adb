with Sensor_Fusion.CAN; -- must be with'ed to start tasks
with Sensor_Fusion.TCP; -- must be with'ed to start tasks
with Sensor_Fusion.Filter_CAN_Messages; -- must be with'ed to start tasks

with Sensor_Fusion.Shared_Types;
with Sensor_Fusion.Object_Handling;

with Ada.Real_Time; -- measure time
with Ada.Text_IO;

-- TODO List:

-- Complete protected objects TCP_Resource (in TCP project) and
-- CAN_Resource (in CAN project) to send and receive messages.

procedure Main is
   use Ada.Real_Time;

   debugCounter : Integer := 600;
   xNewCANMessage: Sensor_Fusion.Shared_Types.CAN_Message;

begin
   -- BOOT UP STUFF HERE
   Ada.Text_IO.Put_Line("Main: Started."); -- for testing

   loop -- BOOT UP COMPLETE... NOW LOOP FOREVER

--------- Sensor Fusion Calculations starts here -----------------------------
      -- Filter_TCP_IN to Main
      if Sensor_Fusion.Shared_Types.CAN_Messages_Filter_TCP_IN_To_Main.iCount > 0 then
         Sensor_Fusion.Shared_Types.CAN_Messages_Filter_TCP_IN_To_Main.Remove(xCANMessage => xNewCANMessage);
         Ada.Text_IO.Put_Line("Main (From Filter_TCP_IN): New CAN Message recieved with ID "
                                 & Integer'Image(xNewCANMessage.ID)); -- for testing

         xNewCANMessage.ID := xNewCANMessage.ID + 1000;

         Sensor_Fusion.Shared_Types.CAN_Messages_Main_To_CAN_OUT.Add(xCANMessage => xNewCANMessage);
         Ada.Text_IO.Put_Line("Main: Adding new CAN message to list CAN_Messages_Main_To_CAN_OUT with ID "
                                 & Integer'Image(xNewCANMessage.ID)); -- for testing
      end if;

--------- Sensor Fusion Calculations ends here--------------------------------
      Ada.Text_IO.Put_Line("Main: " & Integer'Image(debugCounter));
      debugCounter := debugCounter + 1;

      delay 3.0; -- for testing
   end loop;

end Main;
