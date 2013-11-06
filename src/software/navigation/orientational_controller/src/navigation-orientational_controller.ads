with Math.Angles;
with Math.Vectors;
with Math.Planes;
with Math.Matrices;
with Math.Quaternions;

with Navigation.Motion_Component;
with Navigation.PID_Controller;
with Navigation.Thrusters;

--  with Ada.Text_IO;
--  with System.Address_Image;
with Ada.Finalization;
with Ada.Unchecked_Deallocation;
with System;

package Navigation.Orientational_Controller is

   type COrientationalController is new Ada.Finalization.Controlled with private;
   type pCOrientationalController is access COrientationalController;

   procedure Free(pxOrientationalControllerToDeallocate : in out pCOrientationalController);

   function pxCreate (pxCurrentAbsoluteOrientation : in Math.Matrices.pCMatrix; pxWantedAbsoluteOrientation : in Math.Matrices.pCMatrix; pxCurrentAbsoluteOrientationInverse : in Math.Matrices.pCMatrix) return pCOrientationalController;
   --  <summary>Creates an object of type COrientationalController and sets references to the current and wanted orientation</summary>
   --  <parameter name="pxCurrentAbsoluteOrientation">A reference to the current absolute orientation</parameter>
   --  <parameter name="pxWantedAbsoluteOrientation">A reference to the wanted absolute orientation</parameter>

   function xGet_Orientational_Thruster_Control_Values (this : in COrientationalController; fDeltaTime : in float) return Navigation.Thrusters.TThrusterEffects;
   --  <summary>Calculates thruster control values for all thrusters and scales them accordingly</summary>
   --  <parameter name="this">The COrientationalController to do the calculations upon.</parameter>
   --  <parameter name="fDeltaTime">The time difference since the last calculation.</parameter>


   procedure Update_Current_Errors (this : in out COrientationalController);
   --  <summary>Cascades the difference between the current orientation and the wanted orientation to all motion components</summary>
   --  <parameter name="this">The COrientationalController object that holds the objects that needs to be updated</parameter>

   procedure Set_New_PID_Component_Scalings(this : in COrientationalController; eComponentToUpdate : Navigation.Motion_Component.EMotionComponent; xNewPIDScaling : Navigation.PID_Controller.TPIDComponentScalings);
   --  <summary>Sets new component scalings on a PID controller held by the COrientationalController in question</summary>
   --  <parameter name="this">The COrientationalController object that holds the PID controller to update.</parameter>
   --  <parameter name="xNewPIDSCalings">The TPIDComponetScalings object to set for the object.</parameter>
   --  <parameter name="eComponentToChange">The index of the component to change.</parameter>

private

   procedure Update_Current_X_Rotation_Error (this : in COrientationalController);
   procedure Update_Current_Y_Rotation_Error (this : in COrientationalController);
   procedure Update_Current_Z_Rotation_Error (this : in COrientationalController);

   function xGet_X_Rotation_Thruster_Control_Value (this : in COrientationalController; fDeltaTime : in float) return Navigation.Thrusters.TThrusterEffects;
   function xGet_Y_Rotation_Thruster_Control_Value (this : in COrientationalController; fDeltaTime : in float) return Navigation.Thrusters.TThrusterEffects;
   function xGet_Z_Rotation_Thruster_Control_Value (this : in COrientationalController; fDeltaTime : in float) return Navigation.Thrusters.TThrusterEffects;

   type COrientationalController is new Ada.Finalization.Controlled with
      record
         pxCurrentAbsoluteOrientation : Math.Matrices.pCMatrix;
         pxWantedAbsoluteOrientation : Math.Matrices.pCMatrix;
         pxCurrentAbsoluteOrientationInverse : Math.Matrices.pCMatrix;

         pxXRotMotionComponent : Navigation.Motion_Component.pCMotionComponent;
         pxYRotMotionComponent : Navigation.Motion_Component.pCMotionComponent;
         pxZRotMotionComponent : Navigation.Motion_Component.pCMotionComponent;
      end record;

   procedure Finalize(this : in out COrientationalController);
end Navigation.Orientational_Controller;
