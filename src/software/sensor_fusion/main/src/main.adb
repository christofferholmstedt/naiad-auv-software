with Sensor_Fusion.CAN; -- must be with'ed to start tasks
with Sensor_Fusion.TCP; -- must be with'ed to start tasks

with Sensor_Fusion.Shared_Types;
with Sensor_Fusion.Object_Handling;

with Ada.Real_Time; -- measure time
with Ada.Text_IO;

-- TODO List:

-- Complete protected objects TCP_Resource (in TCP project) and
-- CAN_Resource (in CAN project) to send and receive messages.


procedure Main is
   use Ada.Real_Time;

   package Debug_Int_IO is new Ada.Text_IO.Integer_IO(Integer);
   debugCounter : Integer := 600;

   fDeltaTime : float := 0.0;
   xTimeStart : Ada.Real_Time.Time := Ada.Real_Time.Clock;
   xTimeSpan : Ada.Real_Time.Time_Span := Ada.Real_Time.Time_Span_Zero;

   pxObject : Sensor_Fusion.Shared_Types.pTListObject;
begin

   -- BOOT UP STUFF HERE
   --Ada.Text_IO.New_Line; Ada.Text_IO.New_Line; Ada.Text_IO.New_Line; Ada.Text_IO.New_Line; -- for testing
   --Ada.Text_IO.Put_Line("Booting up main frame."); -- for testing


   loop -- BOOT UP COMPLETE... NOW LOOP FOREVER


      if Sensor_Fusion.Shared_Types.xObjectsInList.iCount > 0 then

         Sensor_Fusion.Shared_Types.xObjectsInList.Remove(pxObjectRemoved => pxObject);
         Sensor_Fusion.Object_Handling.Handle_Object(xObject => pxObject.all);
         Sensor_Fusion.Shared_Types.Dealloc(pxListObject => pxObject);

      end if;

--------- Sensor Fusion Calculations starts here---------------------------------------------------------------------------------------
      Ada.Text_IO.Put("MAIN: ");
      Debug_Int_IO.Put(debugCounter, 5);
      Ada.Text_IO.New_Line;
      debugCounter := debugCounter + 1;
--------- Sensor Fusion Calculations ends here-----------------------------------------------------------------------------------------

      delay 0.5; -- for testing
   end loop;

end Main;
