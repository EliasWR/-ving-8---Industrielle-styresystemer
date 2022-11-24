PROGRAM Main
VAR
	Stepper_Motor_Halfstep1 : Stepper_Motor_Halfstep;
	Simulator_Halfstep1 : Simulator_Halfstep;
	
	Regulator1 : Regulator;
	
	ap : BOOL;
	an : BOOL;
	bp : BOOL;
	bn : BOOL;
	
	runMotor : BOOL;
	switch : BOOL := FALSE;
	step : REAL;
	setStep : REAL;
	dir : BOOL;
	angle : REAL;
	visuAngle : REAL;
	
	calBtn : BOOL;
	stepDelay : REAL := 1;
	run : BOOL;
	external : BOOL;
	calState : BOOL;
END_VAR

//----------------------------------------------

Stepper_Motor_Halfstep1 (
				Dir := dir,
				StepDelay := stepDelay,
				Run := run,
				Ap => ap,
				Bp => bp,
				An => an,
				Bn => bn);
			
Simulator_Halfstep1 (
			CalState := calState,
			External := external,
			Ap := ap,
			Bp := bp,
			An := an,
			Bn := bn,
			Angle => angle,
			StepPos => step,
			Limswitch => switch);
			
Regulator1 (StepPos := step,
			SetPos := SetStep,
			Switch := switch,
			CalBtn := calBtn,
			RunMotor := RunMotor,
			Dir => dir,
			StepDelay => stepDelay,
			Run => run,
			CalState => calState);

visuAngle := angle * -1;
// DIR ER FALSE OPPOVER OG TRUE NEDOVER