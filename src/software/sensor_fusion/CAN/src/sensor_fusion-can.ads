with Sensor_Fusion;
with Sensor_Fusion.Shared_Types;

--with Ada.Text_IO; -- for testing

package Sensor_Fusion.CAN is

   protected CAN_Resource is
      procedure Send(xCANMessage : in Sensor_Fusion.Shared_Types.CAN_Message);
      procedure Receive(xCANMessage : out Sensor_Fusion.Shared_Types.CAN_Message; bMessageReceived : out boolean);
   private
      Temp_CAN_Message_Storage: Sensor_Fusion.Shared_Types.CAN_Message; -- testing
   end CAN_Resource;

   task TASK_CAN_IN;
   -- Specification for CAN task "IN"

   task TASK_CAN_OUT;
   -- Specification for CAN task "OUT"

end Sensor_Fusion.CAN;
