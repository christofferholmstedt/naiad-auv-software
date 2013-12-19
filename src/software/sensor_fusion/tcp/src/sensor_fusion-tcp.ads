with Sensor_Fusion;
with Sensor_Fusion.Shared_Types;

--with Ada.Text_IO; -- for testing

package Sensor_Fusion.TCP is

   protected TCP_Resource is
      procedure Send(xCANMessage : in Sensor_Fusion.Shared_Types.CAN_Message);
      procedure Receive(xCANMessage : out Sensor_Fusion.Shared_Types.CAN_Message; bMessageReceived : out boolean);
   end TCP_Resource;


   task TASK_TCP_IN is
   end TASK_TCP_IN;

   task TASK_TCP_OUT is
   end TASK_TCP_OUT;



end Sensor_Fusion.TCP;
