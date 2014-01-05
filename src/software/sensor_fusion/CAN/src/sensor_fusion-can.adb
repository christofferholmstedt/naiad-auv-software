with Ada.Text_IO;

package body Sensor_Fusion.CAN is

   ------------------
   -- CAN_RESOURCE --
   ------------------

   protected body CAN_Resource is
      procedure Send(xCANMessage : in Sensor_Fusion.Shared_Types.CAN_Message) is
      begin
         Ada.Text_IO.Put_Line("CAN_Resource: Send called."); -- for testing
         --null;
      end Send;

      procedure Receive(xCANMessage : out Sensor_Fusion.Shared_Types.CAN_Message; bMessageReceived : out boolean) is
         xNewCANMessage : Sensor_Fusion.Shared_Types.CAN_Message;
      begin
         Ada.Text_IO.Put_Line("CAN_Resource: Receive called."); -- for testing
         xCANMessage := xNewCANMessage;
         bMessageReceived := true;
      end Receive;

   end CAN_Resource;

   -----------------
   -- TASK_CAN_IN --
   -----------------

   task body TASK_CAN_IN is
      bCANMessageReceived : boolean;
      xNewCANMessage : Sensor_Fusion.Shared_Types.CAN_Message;
   begin
      loop

         Ada.Text_IO.Put_Line("CAN_IN: Calling Receive."); -- for testing
         CAN_Resource.Receive(xCANMessage      => xNewCANMessage,
                              bMessageReceived => bCANMessageReceived);

         if bCANMessageReceived then
            Ada.Text_IO.Put_Line("CAN_IN: Adding new CAN message to list."); -- for testing
            Sensor_Fusion.Shared_Types.xObjectsInList.Add(xNewObject => Sensor_Fusion.Shared_Types.xGet_Object_From_CAN_Message(xNewCANMessage));
            Sensor_Fusion.Shared_Types.xCANInMessageList.Add(xCANMessage => xNewCANMessage);
         end if;

         if Sensor_Fusion.Shared_Types.xCANSimulatedMessageList.iCount > 0 then
            Ada.Text_IO.Put_Line("CAN_IN: Adding new CAN message to Simulated list."); -- for testing
            Sensor_Fusion.Shared_Types.xCANSimulatedMessageList.Remove(xCANMessage => xNewCANMessage);
            CAN_Resource.Send(xCANMessage => xNewCANMessage);
         end if;

         delay 0.5;  -- for testing
      end loop;
   end TASK_CAN_IN;

   ------------------
   -- TASK_CAN_OUT --
   ------------------

   task body TASK_CAN_OUT is
      pxObject : Sensor_Fusion.Shared_Types.pTListObject;
      xNewCANMessage : Sensor_Fusion.Shared_Types.CAN_Message;
   begin
      loop
         if Sensor_Fusion.Shared_Types.xObjectsOutList.iCount > 0 then
            Ada.Text_IO.Put_Line("CAN_OUT: xObjectsOutMessageList has items in it."); -- for testing

            Sensor_Fusion.Shared_Types.xObjectsOutList.Remove(pxObjectRemoved => pxObject);
            xNewCANMessage := pxObject.xGet_CAN_Message_From_Object;
            Sensor_Fusion.Shared_Types.Dealloc(pxObject);
            Sensor_Fusion.Shared_Types.xCANOutMessageList.Add(xNewCANMessage);

            CAN_Resource.Send(xCANMessage => xNewCANMessage);
         else
            Ada.Text_IO.Put_Line("CAN_OUT: No new item in list to be transmitted."); -- for testing
         end if;

         delay 0.5;  -- for testing
      end loop;
   end TASK_CAN_OUT;

end Sensor_Fusion.CAN;
