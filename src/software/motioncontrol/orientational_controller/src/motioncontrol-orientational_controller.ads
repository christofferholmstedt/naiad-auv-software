with Math.Angles;
with Math.Vectors;
with Math.Planes;
with Math.Matrices;
with Math.Quaternions;

with MotionControl;
with MotionControl.Motion_Component;
with MotionControl.PID_Controller;
with MotionControl.Thrusters;

--  with Ada.Text_IO;
--  with System.Address_Image;
with Ada.Finalization;
with Ada.Unchecked_Deallocation;
with System;


-- for tests
with Ada.Numerics;
--with Ada.Text_IO;

package MotionControl.Orientational_Controller is

   type COrientationalController is new Ada.Finalization.Controlled with private;
   type pCOrientationalController is access COrientationalController;

   type TOrientationalErrors is array (MotionControl.Motion_Component.RotationX .. MotionControl.Motion_Component.RotationZ) of float;

   procedure Free(pxOrientationalControllerToDeallocate : in out pCOrientationalController);

   function pxCreate (pxCurrentAbsoluteOrientation : in Math.Matrices.pCMatrix; pxWantedAbsoluteOrientation : in Math.Matrices.pCMatrix; pxCurrentAbsoluteOrientationInverse : in Math.Matrices.pCMatrix) return pCOrientationalController;
   --  <summary>Creates an object of type COrientationalController and sets references to the current and wanted orientation</summary>
   --  <parameter name="pxCurrentAbsoluteOrientation">A reference to the current absolute orientation</parameter>
   --  <parameter name="pxWantedAbsoluteOrientation">A reference to the wanted absolute orientation</parameter>

   procedure Get_Orientational_Thruster_Control_Values (this : in out COrientationalController; fDeltaTime : in float; tfValues : out MotionControl.Thrusters.TThrusterEffects);
   --  <summary>Calculates thruster control values for all thrusters and scales them accordingly</summary>
   --  <parameter name="this">The COrientationalController to do the calculations upon.</parameter>
   --  <parameter name="fDeltaTime">The time difference since the last calculation.</parameter>


   procedure Update_Current_Errors (this : in out COrientationalController);
   --  <summary>Cascades the difference between the current orientation and the wanted orientation to all motion components</summary>
   --  <parameter name="this">The COrientationalController object that holds the objects that needs to be updated</parameter>

   procedure Set_New_PID_Component_Scalings(this : in COrientationalController; eComponentToUpdate : MotionControl.Motion_Component.EMotionComponent; xNewPIDScaling : MotionControl.PID_Controller.TPIDComponentScalings);
   --  <summary>Sets new component scalings on a PID controller held by the COrientationalController in question</summary>
   --  <parameter name="this">The COrientationalController object that holds the PID controller to update.</parameter>
   --  <parameter name="xNewPIDSCalings">The TPIDComponetScalings object to set for the object.</parameter>
   --  <parameter name="eComponentToChange">The index of the component to change.</parameter>


   function fGetCurrentErrors(this : in COrientationalController) return TOrientationalErrors;

private

   procedure Update_Current_X_Rotation_Error (this : in out COrientationalController);
   procedure Update_Current_Y_Rotation_Error (this : in out COrientationalController);
   procedure Update_Current_Z_Rotation_Error (this : in out COrientationalController);

   function xGet_X_Rotation_Thruster_Control_Value (this : in COrientationalController; fDeltaTime : in float) return MotionControl.Thrusters.TThrusterEffects;
   function xGet_Y_Rotation_Thruster_Control_Value (this : in COrientationalController; fDeltaTime : in float) return MotionControl.Thrusters.TThrusterEffects;
   function xGet_Z_Rotation_Thruster_Control_Value (this : in COrientationalController; fDeltaTime : in float) return MotionControl.Thrusters.TThrusterEffects;

   type COrientationalController is new Ada.Finalization.Controlled with
      record
         pxCurrentAbsoluteOrientation : Math.Matrices.pCMatrix;
         pxWantedAbsoluteOrientation : Math.Matrices.pCMatrix;
         pxCurrentAbsoluteOrientationInverse : Math.Matrices.pCMatrix;

         pxXRotMotionComponent : MotionControl.Motion_Component.pCMotionComponent;
         pxYRotMotionComponent : MotionControl.Motion_Component.pCMotionComponent;
         pxZRotMotionComponent : MotionControl.Motion_Component.pCMotionComponent;

         fCurrentXRotationError : float;
         fCurrentYRotationError : float;
         fCurrentZRotationError : float;
         fSavedDeltaTime : float;

         -- temporary for testing
--           fXRotError : float;
--           fYRotError : float;
--           fZRotError : float;
      end record;

   procedure Finalize(this : in out COrientationalController);
end MotionControl.Orientational_Controller;
