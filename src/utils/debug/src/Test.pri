procedure Print_Integer(x : integer) is
begin
	smc("PUSHINT 2");
	smc("PUSHFP");
	smc("ADDINT");
	smc("RVALINT");
	smc("PRINTINT");
	smc("POPINT");
end Print_Integer;

procedure Print_Float(x : float) is
begin
	smc("PUSHINT 2");
	smc("PUSHFP");
	smc("ADDINT");
	smc("RVALFLOAT");
	smc("PRINTFLOAT");
	smc("POPFLOAT");
end Print_Float;

procedure Print_Boolean(x : boolean) is
begin
	smc("PUSHINT 2");
	smc("PUSHFP");
	smc("ADDINT");
	smc("RVALBOOL");
	smc("PRINTBOOL");
	smc("POPBOOL");
end Print_Boolean;

procedure Print_Matrix(x : matrix) is
begin
	smc("PUSHINT 2");
	smc("PUSHFP");
	smc("ADDINT");
	smc("RVALMAT");
	smc("PRINTMAT");
	smc("POPMAT");
end Print_Matrix;

procedure Print_Vector(x : vector) is
begin
	smc("PUSHINT 2");
	smc("PUSHFP");
	smc("ADDINT");
	smc("RVALVEC");
	smc("PRINTVEC");
	smc("POPVEC");
end Print_Vector;



function Dot_Product(LeftOperand : vector; RightOperand : vector) return float is
begin
	return (LeftOperand.X * RightOperand.X) + (LeftOperand.Y * RightOperand.Y) + (LeftOperand.Z * RightOperand.Z);
end Dot_Product;

function Length_Squared(Operand : vector) return float is
begin
	return Dot_Product(Operand, Operand);
end Length_Squared;

function Length(Operand : vector) return float is
begin
	return sqrt(Length_Squared(Operand));
end Length;

function Cross_Product(LeftOperand : vector; RightOperand : vector) return vector is
begin
	return [(LeftOperand.Y * RightOperand.Z) - (LeftOperand.Z * RightOperand.Y),
		(LeftOperand.Z * RightOperand.X) - (LeftOperand.X * RightOperand.Z),
		(LeftOperand.X * RightOperand.Y) - (LeftOperand.Y * RightOperand.X)];
end Cross_Product;





procedure Reset_Time is
begin
	smc("TIMERST");
end Reset_Time;

function Get_Time return float is
	x : float;
begin
	smc("PUSHINT -1");
	smc("PUSHFP");
	smc("ADDINT");
	smc("TIME");
	smc("ASSFLOAT");
	return x;
end Get_Time;	


procedure Delay(fTimeInSeconds : float) is
begin
	Reset_Time();
	while fTimeInSeconds - Get_Time() > 0.0 loop
		null;
	end loop;
end Delay;


primitive IntLessThan is

	iLeftOperand : in integer;
	iRightOperand : in integer;

	bResult : out boolean;

	procedure main is
	begin
		bResult := iLeftOperand < iRightOperand;
	end main;

end IntLessThan;


primitive DoubleInt is

	iOperand : in integer;
	
	iResult : out integer;

	procedure main is
	begin
		iResult := iOperand * 2;
	end main;

end DoubleInt;


primitive RemoveTenPercentInt is

	iOperand : in integer;

	iResult : out integer;

	procedure main is
	begin
		iResult := iOperand - (iOperand / 10);
	end main;

end RemoveTenPercentInt;


primitive WaitFor is

	iSeconds : in integer;

	procedure main is
	begin
		Delay(float(iSeconds));
	end main;

end WaitFor;



primitive PrintInt is

	iValue : in integer;

	procedure main is
	begin
		Print_Integer(iValue);
	end main;

end PrintInt;


procedure main is

   iOutInt : integer;
   DoubleInt_1_iResult : integer;
   IntLessThan_1_bResult : boolean;
   RemoveTenPercentInt_1_iResult : integer;
begin

   << Start >>

   << Set1 >>
   iOutInt := 2;

   << DoubleInt1 >>
   DoubleInt( iOutInt, access(iOutInt));

   << PrintInt1 >>
   PrintInt( iOutInt);

   << IntLessThan1 >>
   IntLessThan( iOutInt, 1000, access(IntLessThan_1_bResult));

   << Branch1 >>
   if IntLessThan_1_bResult then

         << WaitFor1 >>
         WaitFor( 1);
         goto DoubleInt1;
   else

         << WaitFor2 >>
         WaitFor( 3);
         goto RemoveTenPercentInt1;
   end if;

   << RemoveTenPercentInt1 >>
   RemoveTenPercentInt( iOutInt, access(iOutInt));
   goto PrintInt1;

end main;