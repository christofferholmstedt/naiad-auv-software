package body MissionControl.TCP is

   protected body TCP_Resource is
      procedure Send(xCANMessage : in MissionControl.SharedTypes.CAN_Message) is
      begin
         --Ada.Text_IO.Put_Line("TCP_Resource: Send called."); -- for testing
         null;
      end Send;

      procedure Receive(xCANMessage : out MissionControl.SharedTypes.CAN_Message; bMessageReceived : out boolean) is
         xNewCANMessage : MissionControl.SharedTypes.CAN_Message;
      begin
         --Ada.Text_IO.Put_Line("TCP_Resource: Receive called."); -- for testing
         xCANMessage := xNewCANMessage;
         bMessageReceived := true;
      end Receive;
   end TCP_Resource;

   task body TASK_TCP_IN is
      xCANMessageFromShore : MissionControl.SharedTypes.CAN_Message;
      bMessageReceived : boolean;
   begin
      loop

         TCP_Resource.Receive(xCANMessage      => xCANMessageFromShore,
                              bMessageReceived => bMessageReceived);

         if bMessageReceived then
            MissionControl.SharedTypes.xCANSimulatedMessageList.Add(xCANMessage => xCANMessageFromShore);
         end if;

         --delay 0.5; -- for testing
      end loop;
   end TASK_TCP_IN;


end MissionControl.TCP;
