using UnityEngine;
using System.Collections;

public class GameCameraClass{

	public string defaultFixedDistance ;//relative distance against player
	
	public double withinYAxis;//camera following is y axis is over the very number
	public double yAxisMovingTime;//camera following time
	
	public double zAxisCrossStage1,zAxisCrossStage2;//distance of z axis crossing stage
	public double zAxis16TailingTime;//camera's tailing time triggered by z-axis forward distance over first stage  
	public string zAxis16BreakingSpeed;//camera's breaking down speed triggered by z-axis forward distance over first stage  
	public double zAxis16CatchingUpTime;//camera's catch up time triggered by z-axis forward distance over first stage  
	
	public double zAxis32TailingTime;//camera's tailing time triggered by z-axis forward distance over first stage  
	public string zAxis32BreakingSpeed;//camera's breaking down speed triggered by z-axis forward distance over first stage  
	public double zAxis32CatchingUpTime;//camera's catch up time triggered by z-axis forward distance over first stage 
	
	public double zAxis_16TailingTime;//camera's tailing time triggered by z-axis backward distance over first stage
	public string zAxis_16BreakingSpeed;//camera's breaking down speed triggered by z-axis backward distance over first stage 
	public double zAxis_16CatchingUpTime;//camera's catch up time triggered by z-axis backward distance over first stage
	
	public double zAxis_32TailingTime;//camera's tailing time triggered by z-axis backward distance over first stage
	public string zAxis_32BreakingSpeed;//camera's breaking down speed triggered by z-axis backward distance over first stage 
	public double zAxis_32CatchingUpTime;//camera's catch up time triggered by z-axis backward distance over first stage

}
