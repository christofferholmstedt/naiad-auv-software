with Sensor_Fusion;
with Sensor_Fusion.Shared_Types;

--with Ada.Text_IO; -- for testing

package Sensor_Fusion.Object_Handling is

   procedure Handle_Object(xObject : in Sensor_Fusion.Shared_Types.TListObject'Class);

end Sensor_Fusion.Object_Handling;
