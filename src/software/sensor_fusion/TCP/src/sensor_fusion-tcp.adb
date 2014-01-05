with Ada.Text_IO;

package body Sensor_Fusion.TCP is

   ------------------
   -- TCP_RESOURCE --
   ------------------

   protected body TCP_Resource is

      procedure Send(xCANMessage : in Sensor_Fusion.Shared_Types.CAN_Message) is
      begin
         Ada.Text_IO.Put("TCP_Resource: Sending message with ID "); -- for testing
         Int_IO.Put(xCANMessage.ID, 5);
         Ada.Text_IO.New_Line;
         Ada.Text_IO.Put_Line("TCP_Resource: FINIHSED TRANSMITTING."); -- for testing
      end Send;

      procedure Receive(xCANMessage : out Sensor_Fusion.Shared_Types.CAN_Message; bMessageReceived : out boolean) is
         xNewCANMessage : Sensor_Fusion.Shared_Types.CAN_Message := (ID => CAN_Message_ID);
      begin
         xNewCANMessage.ID := CAN_Message_ID;

         Ada.Text_IO.Put("TCP_Resource: Created TEST Message with ID "); -- for testing
         Int_IO.Put(xCANMessage.ID, 5);
         Ada.Text_IO.New_Line;

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
      bMessageReceived : boolean;
   begin
      Ada.Text_IO.Put_Line("TCP_IN: Started."); -- for testing

      loop
         TCP_Resource.Receive(xCANMessage      => xCANMessageFromShore,
                              bMessageReceived => bMessageReceived);

         if bMessageReceived then
            Ada.Text_IO.Put("TCP_IN: Adding new CAN message to list CAN_Messages_TCP_IN_To_CAN_OUT ID: "); -- for testing
            Int_IO.Put(xCANMessageFromShore.ID, 5);
            Ada.Text_IO.New_Line;

            Sensor_Fusion.Shared_Types.CAN_Messages_TCP_IN_To_CAN_OUT.Add(xCANMessage => xCANMessageFromShore);
         end if;

         delay 3.0; -- for testing
      end loop;
   end TASK_TCP_IN;

   ------------------
   -- TASK_TCP_OUT --
   ------------------

   task body TASK_TCP_OUT is
      xCANMessageToShore : Sensor_Fusion.Shared_Types.CAN_Message;
   begin
      loop

         if Sensor_Fusion.Shared_Types.CAN_Messages_CAN_IN_To_TCP_OUT.iCount > 0 then
            Ada.Text_IO.Put_Line("TCP_OUT: CAN_Messages_CAN_IN_To_TCP_OUT has items in it."); -- for testing
            Sensor_Fusion.Shared_Types.CAN_Messages_CAN_IN_To_TCP_OUT.Remove(xCANMessage => xCANMessageToShore);
            TCP_Resource.Send(xCANMessage => xCANMessageToShore);
         end if;


--         if Sensor_Fusion.Shared_Types.xCANInMessageList.iCount > 0 then
--
--            Ada.Text_IO.Put_Line("TCP_OUT: xCANInMessageList has items in it."); -- for testing
--            Sensor_Fusion.Shared_Types.xCANInMessageList.Remove(xCANMessage => xCANMessageToShore);
--            TCP_Resource.Send(xCANMessage => xCANMessageToShore);
--
--         end if;

         delay 0.5; -- for testing
      end loop;
   end TASK_TCP_OUT;

end Sensor_Fusion.TCP;
