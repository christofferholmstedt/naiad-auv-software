with Sensor_Fusion;
with Sensor_Fusion.Shared_Types;

--with Ada.Text_IO; -- for testing

package Sensor_Fusion.CAN is

   protected CAN_Resource is
      procedure Send(xCANMessage : in Sensor_Fusion.Shared_Types.CAN_Message);
      procedure Receive(xCANMessage : out Sensor_Fusion.Shared_Types.CAN_Message; bMessageReceived : out boolean);
   end CAN_Resource;


   task TASK_CAN_IN is
   end TASK_CAN_IN;

   task TASK_CAN_OUT is
   end TASK_CAN_OUT;


end Sensor_Fusion.CAN;
