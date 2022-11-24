FUNCTION_BLOCK Stepper_Motor_Halfstep
VAR_INPUT
	Dir : BOOL;
	StepDelay : REAL;
	Run : BOOL;
END_VAR
VAR_OUTPUT
	Ap : BOOL;
	Bp : BOOL;
	An : BOOL;
	Bn : BOOL;
END_VAR
VAR
	Timer1 : Timer;
	Modulo1 : Modulo;
	currentSpool : INT;
	reset : BOOL;
	timerOut : BOOL;
	timerOn : BOOL;
	State : INT := 0;
END_VAR

//----------------------------------------------

CASE State OF
0:
	IF NOT(timerOn) THEN
		timerOn := TRUE;
	END_IF
	
	IF timerOut THEN
		State := 1;
		timerOn := FALSE;
	END_IF
	
	Timer1 (On := timerOn,
	Reset := reset,
	Timer := StepDelay,
	TimerOut => timerOut);
		
	IF reset THEN
		reset := FALSE;
	END_IF

1:
	IF Run THEN
		IF (NOT(Dir)) THEN
			currentSpool := currentSpool + 1;
		END_IF
		
		IF (Dir) THEN
			currentSpool := currentSpool - 1;
		END_IF
		reset := TRUE;
		State := 2;
	END_IF

2:
	Modulo1 (	Num1 := currentSpool,
				MinLim := 0,
				MaxLim := 8,
				Output => currentSpool);
	
	Case currentSpool OF
		0: // A+
			Ap := TRUE;
			Bp := FALSE;
			An := FALSE;
			Bn := FALSE;
		1: // A+, B+
			Ap := TRUE;
			Bp := TRUE;
			An := FALSE;
			Bn := FALSE;
		2: // B+
			Ap := FALSE;
			Bp := TRUE;
			An := FALSE;
			Bn := FALSE;
		3: // B+, A-
			Ap := FALSE;
			Bp := TRUE;
			An := TRUE;
			Bn := FALSE;
		4: // A-
			Ap := FALSE;
			Bp := FALSE;
			An := TRUE;
			Bn := FALSE;
		5: // A-, B-
			Ap := FALSE;
			Bp := FALSE;
			An := TRUE;
			Bn := TRUE;
		6: // B-
			Ap := FALSE;
			Bp := FALSE;
			An := FALSE;
			Bn := TRUE;
		7: // B-, A+
			Ap := TRUE;
			Bp := FALSE;
			An := FALSE;
			Bn := TRUE;
	END_CASE
	State := 0;
END_CASE