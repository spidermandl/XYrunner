using UnityEngine;
using System.Collections;

//animtion item
public class PlayWallDataClass : ExportBassClass{

	public PlayWallData playerWallData_Right { get; set;}
	public PlayWallData playerWallData_Left{ get; set;}

	public class PlayWallData{
		// 可以抓几次 (-1表示可以无限抓)
		public int playWallCount { get; set; }
		// 是否可以弹跳
		public bool isCanPlayWall  { get; set; }
		// 可以停留的时间
		public double stayTime  { get; set; }
		// 加速度(向下掉落的速度)
		public double acceleration  { get; set; }
	}



}





















