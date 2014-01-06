with Ada.Text_IO;

package body Sensor_Fusion.CAN is

   -------------------------------
   -- CAN_RESOURCE with entries --
   -------------------------------

   protected body CAN_Resource is

      entry Send(xCANMessage : in Sensor_Fusion.Shared_Types.CAN_Message) when Allow_Send = true is
      begin
         Temp_CAN_Message_Storage := xCANMessage; -- for testing
         Ada.Text_IO.Put_Line("CAN_Resource.Send: CAN Message sent on CAN bus with ID "
                                 & Integer'Image(xCANMessage.ID)); -- for testing
         Allow_Send := false;
      end Send;

      procedure Receive(xCANMessage : out Sensor_Fusion.Shared_Types.CAN_Message; bMessageReceived : out boolean) is
         xNewCANMessage : Sensor_Fusion.Shared_Types.CAN_Message;
      begin
         -- Ada.Text_IO.Put_Line("CAN_Resource: Receive called."); -- for testing
         if Temp_CAN_Message_Storage.ID /= 0 and Temp_CAN_Message_Storage.ID /= Last_Message_ID then
            xCANMessage := Temp_CAN_Message_Storage;  -- for testing
            Ada.Text_IO.Put_Line("CAN_Resource.Recieve: CAN Message recieved on CAN bus with ID "
                                    & Integer'Image(xCANMessage.ID)); -- for testing
            bMessageReceived := true;
            Allow_Send := true;
            Last_Message_ID := xCANMessage.ID;
         end if;
      end Receive;

   ----------------------------------
   -- CAN_RESOURCE without entries --
   ----------------------------------

--   protected body CAN_Resource is
--
--      procedure Send(xCANMessage : in Sensor_Fusion.Shared_Types.CAN_Message) is
--      begin
--         Temp_CAN_Message_Storage := xCANMessage; -- for testing
--         Ada.Text_IO.Put_Line("CAN_Resource.Send: CAN Message sent on CAN bus with ID "
--                                 & Integer'Image(xCANMessage.ID)); -- for testing
--      end Send;
--
--      procedure Receive(xCANMessage : out Sensor_Fusion.Shared_Types.CAN_Message; bMessageReceived : out boolean) is
--         xNewCANMessage : Sensor_Fusion.Shared_Types.CAN_Message;
--      begin
--         -- Ada.Text_IO.Put_Line("CAN_Resource: Receive called."); -- for testing
--         if (Temp_CAN_Message_Storage.ID /= 0) then
--            xCANMessage := Temp_CAN_Message_Storage;  -- for testing
--            Ada.Text_IO.Put_Line("CAN_Resource.Recieve: CAN Message recieved on CAN bus with ID "
--                                    & Integer'Image(xCANMessage.ID)); -- for testing
--            bMessageReceived := true;
--         end if;
--      end Receive;

      -- Current implementation fakes the CAN Bus and recieves the same
      -- messages that it sends. This creates a loopback for testing.
      -- It's in this protected object (resource) that actual calls to the drivers
      -- for the CAN Bus should be made.

      -- During testing the protected variable
      -- Temp_CAN_Message_Storage isn't locked behind any semaphore so
      -- it could perhaps be overwritten. Though this variable is not going
      -- to be used in a real system. The problem that could arise is that
      -- data from both Filter_TCP_IN and Main tasks want to send something
      -- at the same time and the data from Filter_TCP_IN will then be
      -- overwritten if TASK_CAN_IN doesn't read the variable in between
      -- writes.
   end CAN_Resource;

   -----------------
   -- TASK_CAN_IN --
   -----------------

   task body TASK_CAN_IN is
      xNewCANMessage : Sensor_Fusion.Shared_Types.CAN_Message;
      bCANMessageReceived : boolean := false;
   begin
      Ada.Text_IO.Put_Line("CAN_IN: Started."); -- for testing

      loop
         CAN_Resource.Receive(xCANMessage      => xNewCANMessage,
                              bMessageReceived => bCANMessageReceived);

         if bCANMessageReceived and xNewCANMessage.ID /= 0 then
            Ada.Text_IO.Put_Line("CAN_IN: Adding new CAN message to list CAN_Messages_CAN_IN_To_Filter_CAN_IN with ID "
                                    & Integer'Image(xNewCANMessage.ID)); -- for testing
            Sensor_Fusion.Shared_Types.CAN_Messages_CAN_IN_To_Filter_CAN_IN.Add(xCANMessage => xNewCANMessage);
         end if;

         delay 1.0;  -- for testing
      end loop;
   end TASK_CAN_IN;

   ------------------
   -- TASK_CAN_OUT --
   ------------------

   task body TASK_CAN_OUT is
      xNewCANMessage : Sensor_Fusion.Shared_Types.CAN_Message;
   begin
      Ada.Text_IO.Put_Line("CAN_OUT: Started."); -- for testing

      loop

         -- Filter_TCP_IN to CAN
         if Sensor_Fusion.Shared_Types.CAN_Messages_Filter_TCP_IN_To_CAN_OUT.iCount > 0 then
            Sensor_Fusion.Shared_Types.CAN_Messages_Filter_TCP_IN_To_CAN_OUT.Remove(xCANMessage => xNewCANMessage);
            Ada.Text_IO.Put_Line("CAN_OUT (From Filter_TCP_IN): New CAN Message recieved with ID "
                                    & Integer'Image(xNewCANMessage.ID)); -- for testing

            CAN_Resource.Send(xCANMessage => xNewCANMessage);
         end if;

         -- Main to CAN
         if Sensor_Fusion.Shared_Types.CAN_Messages_Main_To_CAN_OUT.iCount > 0 then
            Sensor_Fusion.Shared_Types.CAN_Messages_Main_To_CAN_OUT.Remove(xCANMessage => xNewCANMessage);
            Ada.Text_IO.Put_Line("CAN_OUT (From Main): New CAN Message recieved with ID "
                                    & Integer'Image(xNewCANMessage.ID)); -- for testing

            CAN_Resource.Send(xCANMessage => xNewCANMessage);
         end if;

         delay 3.0;  -- for testing
      end loop;
   end TASK_CAN_OUT;

end Sensor_Fusion.CAN;
