with Ada.Text_IO;

package body Sensor_Fusion.TCP is

   ------------------
   -- TCP_RESOURCE --
   ------------------

   protected body TCP_Resource is

      procedure Send(xCANMessage : in Sensor_Fusion.Shared_Types.CAN_Message) is
      begin
         Ada.Text_IO.Put_Line("TCP_Resource.Send: Sent CAN Message with ID "
                                 & Integer'Image(xCANMessage.ID)); -- for testing
      end Send;

      procedure Receive(xCANMessage : out Sensor_Fusion.Shared_Types.CAN_Message; bMessageReceived : out boolean) is
         xNewCANMessage : Sensor_Fusion.Shared_Types.CAN_Message := (ID => CAN_Message_ID);
      begin
         Ada.Text_IO.Put_Line("TCP_Resource.Recieve: Created new test CAN Message with ID "
                                 & Integer'Image(xNewCANMessage.ID)); -- for testing

         xCANMessage := xNewCANMessage;
         bMessageReceived := true;

         CAN_Message_ID := CAN_Message_ID + 7;
      end Receive;

      -- Current implementation fakes the TCP connection and creates a new
      -- CAN message each time the the recieve function is called. Each time
      -- Send is called it prints the CAN Message's ID for debugging
      -- purposes.
      -- It's in this protected object (resource) that actual calls to the drivers
      -- for the TCP connection should be made.

   end TCP_Resource;

   -----------------
   -- TASK_TCP_IN --
   -----------------

   task body TASK_TCP_IN is
      xCANMessageFromShore : Sensor_Fusion.Shared_Types.CAN_Message;
      bMessageReceived : boolean := false;
   begin
      Ada.Text_IO.Put_Line("TCP_IN: Started."); -- for testing

      loop
         TCP_Resource.Receive(xCANMessage      => xCANMessageFromShore,
                              bMessageReceived => bMessageReceived);

         if bMessageReceived and xCANMessageFromShore.ID /= 0 then
            Ada.Text_IO.Put_Line("TCP_IN: Adding new CAN message to list CAN_Messages_TCP_IN_To_Filter_TCP_IN with ID "
                                    & Integer'Image(xCANMessageFromShore.ID)); -- for testing

            Sensor_Fusion.Shared_Types.CAN_Messages_TCP_IN_To_Filter_TCP_IN.Add(xCANMessage => xCANMessageFromShore);
         end if;

         delay 5.0; -- for testing
      end loop;
   end TASK_TCP_IN;

   ------------------
   -- TASK_TCP_OUT --
   ------------------

   task body TASK_TCP_OUT is
      xCANMessageToShore : Sensor_Fusion.Shared_Types.CAN_Message;
   begin
      Ada.Text_IO.Put_Line("TCP_OUT: Started."); -- for testing

      loop

         -- Filter_CAN_IN to TCP
         if Sensor_Fusion.Shared_Types.CAN_Messages_Filter_CAN_IN_To_TCP_OUT.iCount > 0 then
            Sensor_Fusion.Shared_Types.CAN_Messages_Filter_CAN_IN_To_TCP_OUT.Remove(xCANMessage => xCANMessageToShore);
            Ada.Text_IO.Put_Line("TCP_OUT (From Filter_CAN_IN): New CAN Message recieved with ID "
                                    & Integer'Image(xCANMessageToShore.ID)); -- for testing

            TCP_Resource.Send(xCANMessage => xCANMessageToShore);
         end if;

         -- Main to TCP
         if Sensor_Fusion.Shared_Types.CAN_Messages_Main_To_TCP_OUT.iCount > 0 then
            Sensor_Fusion.Shared_Types.CAN_Messages_Main_To_TCP_OUT.Remove(xCANMessage => xCANMessageToShore);
            Ada.Text_IO.Put_Line("TCP_OUT (From Main): New CAN Message recieved with ID "
                                    & Integer'Image(xCANMessageToShore.ID)); -- for testing

            TCP_Resource.Send(xCANMessage => xCANMessageToShore);
         end if;

         delay 0.1; -- for testing
      end loop;
   end TASK_TCP_OUT;

end Sensor_Fusion.TCP;
