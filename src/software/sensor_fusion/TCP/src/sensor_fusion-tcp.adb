package body Sensor_Fusion.TCP is

   protected body TCP_Resource is
      procedure Send(xCANMessage : in Sensor_Fusion.Shared_Types.CAN_Message) is
      begin
         --Ada.Text_IO.Put_Line("TCP_Resource: Send called."); -- for testing
         null;
      end Send;

      procedure Receive(xCANMessage : out Sensor_Fusion.Shared_Types.CAN_Message; bMessageReceived : out boolean) is
         xNewCANMessage : Sensor_Fusion.Shared_Types.CAN_Message;
      begin
         --Ada.Text_IO.Put_Line("TCP_Resource: Receive called."); -- for testing
         xCANMessage := xNewCANMessage;
         bMessageReceived := true;
      end Receive;
   end TCP_Resource;

   task body TASK_TCP_IN is
      xCANMessageFromShore : Sensor_Fusion.Shared_Types.CAN_Message;
      bMessageReceived : boolean;
   begin
      loop

         TCP_Resource.Receive(xCANMessage      => xCANMessageFromShore,
                              bMessageReceived => bMessageReceived);

         if bMessageReceived then
            Sensor_Fusion.Shared_Types.xCANSimulatedMessageList.Add(xCANMessage => xCANMessageFromShore);
         end if;

         --delay 0.5; -- for testing
      end loop;
   end TASK_TCP_IN;

   task body TASK_TCP_OUT is
      xCANMessageToShore : Sensor_Fusion.Shared_Types.CAN_Message;
   begin
      loop

         if Sensor_Fusion.Shared_Types.xCANOutMessageList.iCount > 0 then

            Sensor_Fusion.Shared_Types.xCANOutMessageList.Remove(xCANMessage => xCANMessageToShore);
            TCP_Resource.Send(xCANMessage => xCANMessageToShore);

         end if;


         if Sensor_Fusion.Shared_Types.xCANInMessageList.iCount > 0 then

            Sensor_Fusion.Shared_Types.xCANInMessageList.Remove(xCANMessage => xCANMessageToShore);
            TCP_Resource.Send(xCANMessage => xCANMessageToShore);

         end if;

         --delay 0.5; -- for testing
      end loop;
   end TASK_TCP_OUT;

end Sensor_Fusion.TCP;