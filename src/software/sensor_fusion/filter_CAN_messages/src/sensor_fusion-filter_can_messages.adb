with Ada.Text_IO;

package body Sensor_Fusion.Filter_CAN_Messages is

   ------------------------------------------
   -- TASK_Filter_CAN_Messages_From_TCP_IN --
   ------------------------------------------

   task body TASK_Filter_CAN_Messages_From_TCP_IN is
      xNewCANMessage: Sensor_Fusion.Shared_Types.CAN_Message;
   begin
      Ada.Text_IO.Put_Line("Filter_CAN_Messages_From_TCP_IN: Started."); -- for testing

      loop
         if Sensor_Fusion.Shared_Types.CAN_Messages_TCP_IN_To_Filter_TCP_IN.iCount > 0 then
            Sensor_Fusion.Shared_Types.CAN_Messages_TCP_IN_To_Filter_TCP_IN.Remove(xCANMessage => xNewCANMessage);
            Ada.Text_IO.Put_Line("Filter_CAN_Messages (From TCP_IN): New CAN Message recieved with ID "
                                    & Integer'Image(xNewCANMessage.ID)); -- for testing

            Sensor_Fusion.Shared_Types.CAN_Messages_Filter_TCP_IN_To_CAN_OUT.Add(xCANMessage => xNewCANMessage);
            Ada.Text_IO.Put_Line("Filter_CAN_Messages (From TCP_IN): Sent message with ID "
                                    & Integer'Image(xNewCANMessage.ID)
                                    & " to CAN_OUT."); -- for testing

            if xNewCANMessage.ID mod 5 = 0 then -- for testing, this filtering should be made more "advanced".
               Sensor_Fusion.Shared_Types.CAN_Messages_Filter_TCP_IN_To_Main.Add(xCANMessage => xNewCANMessage);
               Ada.Text_IO.Put_Line("Filter_CAN_Messages (From TCP_IN): Sent message with ID "
                                       & Integer'Image(xNewCANMessage.ID)
                                       & " to Main."); -- for testing
            end if;
         end if;

         delay 1.0; -- for testing
      end loop;
   end TASK_Filter_CAN_Messages_From_TCP_IN;

   ------------------------------------------
   -- TASK_Filter_CAN_Messages_From_CAN_IN --
   ------------------------------------------

   task body TASK_Filter_CAN_Messages_From_CAN_IN is
      xNewCANMessage: Sensor_Fusion.Shared_Types.CAN_Message;
   begin
      Ada.Text_IO.Put_Line("Filter_CAN_Messages_From_CAN_IN: Started."); -- for testing

      loop
         if Sensor_Fusion.Shared_Types.CAN_Messages_CAN_IN_To_Filter_CAN_IN.iCount > 0 then
            Sensor_Fusion.Shared_Types.CAN_Messages_CAN_IN_To_Filter_CAN_IN.Remove(xCANMessage => xNewCANMessage);
            Ada.Text_IO.Put_Line("Filter_CAN_Messages (From CAN_IN): New CAN Message recieved with ID "
                                    & Integer'Image(xNewCANMessage.ID)); -- for testing

            Sensor_Fusion.Shared_Types.CAN_Messages_Filter_CAN_IN_To_TCP_OUT.Add(xCANMessage => xNewCANMessage);
            Ada.Text_IO.Put_Line("Filter_CAN_Messages (From CAN_IN): Sent message with ID "
                                    & Integer'Image(xNewCANMessage.ID)
                                    & " to TCP_OUT."); -- for testing

            if xNewCANMessage.ID mod 5 = 0 then -- for testing, this filtering should be made more "advanced".
               Sensor_Fusion.Shared_Types.CAN_Messages_Filter_CAN_IN_To_Main.Add(xCANMessage => xNewCANMessage);
               Ada.Text_IO.Put_Line("Filter_CAN_Messages (From CAN_IN): Sent message with ID "
                                       & Integer'Image(xNewCANMessage.ID)
                                       & " to Main."); -- for testing
            end if;
         end if;

         delay 3.0; -- for testing
      end loop;
   end TASK_Filter_CAN_Messages_From_CAN_IN;

end Sensor_Fusion.Filter_CAN_Messages;
