with Sensor_Fusion;
with Sensor_Fusion.Shared_Types;

--with Ada.Text_IO; -- for testing

package Sensor_Fusion.TCP is

   protected TCP_Resource is
      procedure Send(xCANMessage : in Sensor_Fusion.Shared_Types.CAN_Message);
      procedure Receive(xCANMessage : out Sensor_Fusion.Shared_Types.CAN_Message; bMessageReceived : out boolean);
   end TCP_Resource;

   task TASK_TCP_IN;
   -- Specification for TCP task "IN"

   task TASK_TCP_OUT;
   -- Specification for TCP task "OUT"

end Sensor_Fusion.TCP;
