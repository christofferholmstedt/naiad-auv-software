with Sensor_Fusion;
with Sensor_Fusion.Shared_Types;

with Ada.Text_IO; -- for testing

package Sensor_Fusion.Filter_CAN_Messages is

   package Int_IO is new Ada.Text_IO.Integer_IO(Integer);

   task TASK_Filter_CAN_Messages_From_TCP_IN;
   -- Specification for TCP task "Filter_CAN_Messages_From_TCP_IN"

   task TASK_Filter_CAN_Messages_From_CAN_IN;
   -- Specification for TCP task "Filter_CAN_Messages_From_CAN_IN"

end Sensor_Fusion.Filter_CAN_Messages;
