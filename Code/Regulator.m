FUNCTION_BLOCK Regulator
VAR_INPUT
	StepPos : REAL;
	SetPos : REAL;
	Switch : BOOL;
	CalBtn : BOOL;
	RunMotor : BOOL;
END_VAR
VAR_OUTPUT
	Dir : BOOL;
	StepDelay : REAL;
	Run : BOOL := TRUE;
	CalState : BOOL;
END_VAR
VAR
	CalSpeed : REAL := 0;
	NormalSpeed : REAL := 0;
	MotorState : INT := 0;
	Scaling1 : Scaling;
	StepRatio : REAL := 0.3515;
END_VAR


//----------------------------------------------

SetPos := (SetPos + 40) * (1/StepRatio);
			
CASE MotorState OF
0:
	Dir := TRUE;
	Run := TRUE;
	MotorState := 1;
	CalState := FALSE;
1:
	IF Switch THEN
		Dir := FALSE;
		StepDelay := CalSpeed;
		MotorState := 2;
	END_IF
2:
	IF NOT (Switch) THEN
		Run := FALSE;
		CalState := TRUE;
		MotorState := 3;
	END_IF
3:
	IF StepPos < SetPos THEN
		IF RunMotor THEN
			Run := TRUE;
		END_IF
		Dir := FALSE;
	END_IF
	
	IF StepPos > SetPos THEN
		IF RunMotor THEN
			Run := TRUE;
		END_IF
		Dir := TRUE;
	END_IF
	
	IF StepPos > (SetPos-0.5) AND StepPos < (SetPos + 0.5) THEN
		Run := FALSE;
	END_IF
	
	IF (NOT(RunMotor)) THEN
		Run := FALSE;
	END_IF
	
	IF (CalBtn) THEN
		MotorState := 0;
	END_IF
END_CASE
