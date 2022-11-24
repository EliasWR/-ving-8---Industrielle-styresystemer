FUNCTION_BLOCK Simulator_Halfstep
VAR_INPUT
	External : BOOL;
	CalState : BOOL;
	Ap : BOOL;
	Bp : BOOL;
	An : BOOL;
	Bn : BOOL;
END_VAR
VAR_OUTPUT
	StepPos : REAL;
	Angle : REAL;
	LimSwitch : BOOL;
END_VAR
VAR
	StepRatio : REAL := 0.3515;
	CircleDeg : REAL := 360;
	Scaling1 : Scaling;
	Step : INT;
	LastStep : INT;
	InitOk : BOOL;
	
	ModuloINT1 : Modulo;
	ModuloREAL1 : ModuloREAL;
	MinStep : INT := 0;
	MaxStep : INT := 34;
	Device : INT := 0;
	Calibration : INT := 0;
END_VAR

//----------------------------------------------

IF NOT (InitOk) THEN
	StepPos := TIME_TO_INT(TIME()) MOD 34;
	InitOk := TRUE;
END_IF

IF NOT (External) THEN
	LimSwitch := (StepPos < MinStep); // Determine if wing has reached switch
END_IF

IF External THEN
	LimSwitch := Main.switch;
END_IF

// Stepping
IF Ap AND NOT (Bp OR Bn) THEN
	step := 0;
END_IF

IF Ap AND Bp THEN
	step := 1;
END_IF

IF Bp AND NOT (Ap OR An) THEN
	step := 2;
END_IF

IF Bp AND An THEN
	step := 3;
END_IF

IF An AND NOT (Bp OR Bn) THEN
	step := 4;
END_IF

IF An AND Bn THEN
	step := 5;
END_IF

IF Bn AND NOT (Ap OR An) THEN
	step := 6;
END_IF

IF Bn AND Ap THEN
	step := 7;
END_IF

// Cases
CASE step OF
0:
	IF (LastStep = 7) THEN
		StepPos := StepPos + 0.5;
	END_IF
	IF (LastStep = 1) THEN
		StepPos := StepPos - 0.5;
	END_IF
	LastStep := 0;

1:	
	IF (LastStep = 0) THEN 
		StepPos := StepPos + 0.5;
	END_IF
	IF (LastStep = 2) THEN
		StepPos := StepPos - 0.5;
	END_IF
	LastStep := 1;
	
2:
	IF (LastStep = 1) THEN 
		StepPos := StepPos + 0.5;
	END_IF
	IF (LastStep = 3) THEN
		StepPos := StepPos - 0.5;
	END_IF
	LastStep := 2;

3:
	IF (LastStep = 2) THEN 
		StepPos := StepPos + 0.5;
	END_IF
	IF (LastStep = 4) THEN
		StepPos := StepPos - 0.5;
	END_IF
	LastStep := 3;

4:
	IF (LastStep = 3) THEN 
		StepPos := StepPos + 0.5;
	END_IF
	IF (LastStep = 5) THEN
		StepPos := StepPos - 0.5;
	END_IF
	LastStep := 4;
	
5:
	IF (LastStep = 4) THEN 
		StepPos := StepPos + 0.5;
	END_IF
	IF (LastStep = 6) THEN
		StepPos := StepPos - 0.5;
	END_IF
	LastStep := 5;
	
6:
	IF (LastStep = 5) THEN 
		StepPos := StepPos + 0.5;
	END_IF
	IF (LastStep = 7) THEN
		StepPos := StepPos - 0.5;
	END_IF
	LastStep := 6;
	
7:
	IF (LastStep = 6) THEN 
		StepPos := StepPos + 0.5;
	END_IF
	IF (LastStep = 1) THEN
		StepPos := StepPos - 0.5;
	END_IF
	LastStep := 7;
END_CASE

Scaling1 (StepIn := StepPos,
			Ratio := StepRatio,
			AngleOut => angle);
			
// For calibrating simulator with external stepper motor
CASE Calibration OF
	0:
		IF (NOT (CalState) AND Main.external) THEN
			Calibration := 1;
		END_IF
	1:	
		IF (CalState AND Main.external) THEN
			StepPos := 0;
		END_IF
		Calibration := 0;
END_CASE