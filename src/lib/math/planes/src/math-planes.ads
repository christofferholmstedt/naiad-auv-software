with Math;
with Math.Vectors; use Math.Vectors;

-- Planes package for classes and functionality regarding planes. A plane object is stored in a pCPlane variable and is created with the pxCreate function.
package Math.Planes is

   type CPlane is tagged private;
   --  <summary>Class for plane.</summary>

   type pCPlane is access CPlane;
   --  <summary>Pointer type for object of type CPlane. Objects of type CPlane should always be stored in variables of this type.</summary>

   function pxCreate (pxNormalVector : in Math.Vectors.pCVector; fDistanceFromOrigin : in float) return pCPlane;
   --  <summary>Creates an object of type CPlane. Returns a pointer of type pCPlane to the object created.</summary>
   --  <parameter name="pxNormalVector">The normal vector of the plane to be created.</parameter>
   --  <parameter name="fDistanceFromOrigin">The distance from origin to plane along the normal vector.</parameter>
   --  <exception>Numeric_Error, if pxNormalVector vector length = 0.0.</exception>

   function pxGet_Normal_Vector (this : in CPlane) return Math.Vectors.pCVector;
   --  <summary>Returns a copy of the plane's normal vector.</summary>
   --  <parameter name="this">Represents the plane which the normal vector will be copied from.</parameter>

   function fGet_Distance_From_Origin (this : in CPlane) return float;
   --  <summary>Returns the distance from origin to plane along the normal vector.</summary>
   --  <parameter name="this">Represents the plane which the distance will be read from.</parameter>


   function fAngle_Between_In_Degrees (pxLeftOperandPlane : in pCPlane; pxRightOperandPlane : in pCPlane) return float;
   --  <summary>Returns the closest angle in degrees between the two planes.</summary>
   --  <parameter name="pxLeftOperandPlane">Represents the left operand plane.</parameter>
   --  <parameter name="pxRightOperandPlane">Represents the right operand plane.</parameter>

   function pxGet_Intersection_Vector_Between (pxLeftOperandPlane : in pCPlane; pxRightOperandPlane : in pCPlane) return Math.Vectors.pCVector;
   --  <summary>Creates an object of type CVector representing the vector defining the intersection line between the two planes.</summary>
   --  <parameter name="pxLeftOperandPlane">Represents the left operand plane.</parameter>
   --  <parameter name="pxRightOperandPlane">Represents the right operand plane.</parameter>
   --  <exception>Numeric_Error, if the planes are parallel.</exception>



private
   type CPlane is tagged
      record
         pxNormalVector : Math.Vectors.pCVector;
         fDistanceFromOrigin : float;
      end record;

end Math.Planes;