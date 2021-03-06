--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into Navigation.Dispatcher.Test_Data.

with AUnit.Assertions; use AUnit.Assertions;

package body Navigation.Dispatcher.Test_Data.Tests is


--  begin read only
   procedure Test_Free (Gnattest_T : in out Test);
   procedure Test_Free_5d4c1b (Gnattest_T : in out Test) renames Test_Free;
--  id:2.1/5d4c1b0dc9fef7ec/Free/1/0/
   procedure Test_Free (Gnattest_T : in out Test) is
   --  navigation-dispatcher.ads:20:4:Free
--  end read only

      pragma Unreferenced (Gnattest_T);

      pxDispatcher : pCDispatcher;
   begin

      pxDispatcher := Navigation.Dispatcher.pxCreate;

      AUnit.Assertions.Assert(Condition => pxDispatcher /= null,
                              Message   => "pxDispatcher is null after construction");

      Navigation.Dispatcher.Free(pxDispatcherToDeallocate => pxDispatcher);

      AUnit.Assertions.Assert(Condition => pxDispatcher = null,
                              Message   => "pxDispatcher is not null after deconstruction");

--  begin read only
   end Test_Free;
--  end read only


--  begin read only
   procedure Test_pxCreate (Gnattest_T : in out Test);
   procedure Test_pxCreate_63d5f9 (Gnattest_T : in out Test) renames Test_pxCreate;
--  id:2.1/63d5f95e2bbbc09f/pxCreate/1/0/
   procedure Test_pxCreate (Gnattest_T : in out Test) is
   --  navigation-dispatcher.ads:23:4:pxCreate
--  end read only

      pragma Unreferenced (Gnattest_T);

      use System;
      pxDispatcher : pCDispatcher;
   begin

      --Ada.Text_IO.Put_Line("Create test START...");
      pxDispatcher := Navigation.Dispatcher.pxCreate;
      --Ada.Text_IO.Put_Line("Create test END!");

      AUnit.Assertions.Assert        (Condition => pxDispatcher.pxThrusterConfigurator.all'Address /= System.Null_Address,
                                      Message => "Dispatcher.pxCreate failed, no thruster configurator created.");
      AUnit.Assertions.Assert        (Condition => pxDispatcher.pxOrientationalController.all'Address /= System.Null_Address,
                                      Message => "Dispatcher.pxCreate failed, no orientational controller created.");
      AUnit.Assertions.Assert        (Condition => pxDispatcher.pxPositionalController.all'Address /= System.Null_Address,
                                      Message => "Dispatcher.pxCreate failed, no positional controller created.");
      AUnit.Assertions.Assert        (Condition => pxDispatcher.pxCurrentAbsolutePosition.all'Address /= System.Null_Address,
                                      Message => "Dispatcher.pxCreate failed, no current absolute position vector created.");
      AUnit.Assertions.Assert        (Condition => pxDispatcher.pxWantedAbsolutePosition.all'Address /= System.Null_Address,
                                      Message => "Dispatcher.pxCreate failed, no wanted absolute position vector created.");
      AUnit.Assertions.Assert        (Condition => pxDispatcher.pxCurrentAbsoluteOrientation.all'Address /= System.Null_Address,
                                      Message => "Dispatcher.pxCreate failed, no current absolute orientation matrix created.");
      AUnit.Assertions.Assert        (Condition => pxDispatcher.pxWantedAbsoluteOrientation.all'Address /= System.Null_Address,
                                      Message => "Dispatcher.pxCreate failed, no wanted absolute orientation matrix created.");

--  begin read only
   end Test_pxCreate;
--  end read only


--  begin read only
   procedure Test_Scale_Thruster_Values (Gnattest_T : in out Test);
   procedure Test_Scale_Thruster_Values_6606ca (Gnattest_T : in out Test) renames Test_Scale_Thruster_Values;
--  id:2.1/6606ca72337d293d/Scale_Thruster_Values/1/0/
   procedure Test_Scale_Thruster_Values (Gnattest_T : in out Test) is
   --  navigation-dispatcher.ads:62:4:Scale_Thruster_Values
--  end read only

      pragma Unreferenced (Gnattest_T);

      tfThrusterValues : Navigation.Thrusters.TThrusterValuesArray;
      tfOldValues : Navigation.Thrusters.TThrusterValuesArray;
      fOldRatio : float;
      fNewRatio : float;
   begin

      tfThrusterValues := (1.0, 25.0, -330.0, 50.0, 80.0, 200.0);
      tfOldValues := tfThrusterValues;

      Navigation.Dispatcher.Scale_Thruster_Values(tfThrusterValues => tfThrusterValues);

      for i in tfThrusterValues'Range
      loop
         fOldRatio := tfOldValues(i) / tfOldValues(tfOldValues'Last);
         fNewRatio := tfThrusterValues(i) / tfThrusterValues(tfThrusterValues'Last);

      AUnit.Assertions.Assert        (Condition => abs(fOldRatio - fNewRatio) < 0.000001,
                                      Message => "Dispatcher.Scale_Thruster_Values failed, ratio was broken for index " & integer'Image(i) & ". Ratio: " & float'Image(fNewRatio) & ". Expected: " & float'Image(fOldRatio));
      AUnit.Assertions.Assert        (Condition => abs(tfThrusterValues(i)) <= 100.0,
                                      Message => "Dispatcher.Scale_Thruster_Values failed, value to high for index " & integer'Image(i) & ". Value: " & float'Image(tfThrusterValues(i)) & ". Expected: [-100.0, 100.0].");
      end loop;



--  begin read only
   end Test_Scale_Thruster_Values;
--  end read only


--  begin read only
   procedure Test_bThruster_Values_Need_Scaling (Gnattest_T : in out Test);
   procedure Test_bThruster_Values_Need_Scaling_46c697 (Gnattest_T : in out Test) renames Test_bThruster_Values_Need_Scaling;
--  id:2.1/46c697de398e29c3/bThruster_Values_Need_Scaling/1/0/
   procedure Test_bThruster_Values_Need_Scaling (Gnattest_T : in out Test) is
   --  navigation-dispatcher.ads:63:4:bThruster_Values_Need_Scaling
--  end read only

      pragma Unreferenced (Gnattest_T);

      tfV1 : Navigation.Thrusters.TThrusterValuesArray;
      tfV2 : Navigation.Thrusters.TThrusterValuesArray;
      tfV3 : Navigation.Thrusters.TThrusterValuesArray;
      tfV4 : Navigation.Thrusters.TThrusterValuesArray;

   begin

      tfV1 := (1.0, 25.0, -330.0, 50.0, 80.0, 200.0);
      tfV2 := (1.0, 25.0, -30.0, 50.0, 80.0, 101.0);
      tfV3 := (1.0, -101.0, -30.0, 50.0, 80.0, 20.0);
      tfV4 := (1.0, 25.0, -30.0, 50.0, 80.0, 90.0);



      AUnit.Assertions.Assert        (Condition => Navigation.Dispatcher.bThruster_Values_Need_Scaling(tfThrusterValues => tfV1) = True,
                                      Message => "Dispatcher.bThruster_Values_Need_Scaling failed for 1st array.");
      AUnit.Assertions.Assert        (Condition => Navigation.Dispatcher.bThruster_Values_Need_Scaling(tfThrusterValues => tfV2) = True,
                                      Message => "Dispatcher.bThruster_Values_Need_Scaling failed for 2nd array.");
      AUnit.Assertions.Assert        (Condition => Navigation.Dispatcher.bThruster_Values_Need_Scaling(tfThrusterValues => tfV3) = True,
                                      Message => "Dispatcher.bThruster_Values_Need_Scaling failed for 3rd array.");
      AUnit.Assertions.Assert        (Condition => Navigation.Dispatcher.bThruster_Values_Need_Scaling(tfThrusterValues => tfV4) = False,
                                      Message => "Dispatcher.bThruster_Values_Need_Scaling failed for 4th array.");


--  begin read only
   end Test_bThruster_Values_Need_Scaling;
--  end read only

end Navigation.Dispatcher.Test_Data.Tests;
