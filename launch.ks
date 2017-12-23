CLEARSCREEN.

set orb to 70000.
set start_circling_time_to_apoapsis to 40.
set throttle_multiplicator_factor to 3.

set myheading to HEADING(0,90).
lock steering to myheading.

set xstep to "start". // "lift_off" "climb" "reaching_apo" "end"
until xstep = "end"
{
	print "Step: "+xstep +"           " at (0,20).
	PRINT "Throttle: "+ ROUND(THROTTLE,2) +"           " at (0,21).
	PRINT "ETA to Apoapsis: "+ ROUND(ETA:APOAPSIS,0) +"           " at (0,22).
	PRINT "Apoapsis: "+ ROUND(SHIP:APOAPSIS,0)+"           " at (0,23).
	PRINT "Periapsis: "+ ROUND(SHIP:PERIAPSIS,0)+"           " at (0,24).
	PRINT "Pitch: "+ ROUND(myheading:PITCH,2)+"           " at (0,25).
	PRINT "YAW: "+ ROUND(myheading:YAW,2)+"           " at (0,26).
	PRINT "ROLL: "+ ROUND(myheading:ROLL,2)+"           " at (0,27).
	
	if xstep = "start"
	{
		PRINT "Counting down:".
		FROM {local countdown is 3.} 
		UNTIL countdown = 0 
		STEP {SET countdown to countdown - 1.} 
		DO {
			PRINT "..." + countdown.
			WAIT 1. 
		}
		set xstep to "lift_off".
	} 
	if xstep = "lift_off"
	{
		stage.
		LOCK THROTTLE TO 1.0. 
		SET myheading TO HEADING(0,90).
		set xstep to "climb".
	}
	if xstep = "climb" 
	{
		set inclination to 90 + ( -90 * SHIP:ALTITUDE / orb).
		PRINT "Pitching to "+ inclination + " degrees"  at (0,30).
		set myheading to heading(90, inclination).
		if SHIP:APOAPSIS > orb 
		{
			set xstep to "reaching_apo".
		}
	}	
	if xstep = "reaching_apo"
	{
		LOCK THROTTLE TO 0.0.
		SET myheading TO HEADING(90,0).
		set warp to 3.
		if (eta:apoapsis < (start_circling_time_to_apoapsis+5))
		{
			set warp to 0.
			set xstep to "circling".
		}
	}
	if xstep = "circling"
	{
		SET myheading TO HEADING(90,0).
		// wait 0.1.		
		lock throttle to ((1- 1/ (1+ (start_circling_time_to_apoapsis - eta:apoapsis)/start_circling_time_to_apoapsis)))   *throttle_multiplicator_factor.
		if (SHIP:PERIAPSIS > orb)
		{
			set xstep to "end".
			print "Circling completed."  at (0,31).
		}
	}
	if xstep = "end" 
	{
		lock throttle to 0.
	}
}
