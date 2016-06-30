using UnityEngine;
using System.Collections;

public class ExportBassClass {
	public string     localPosition { get; set; }
	public string     localRotation { get; set; }
	public string     localScale  { get; set; }
	public int        left_x { get; set;}

	public string     parentName { get; set;}
	public string     luaName { get; set; }
	public string     param { get; set; }

	public ExportBassClass(){
		param = "";
	}
	
	//animation path
	public class AnimPath{
		public double speed { get; set; }
		public double delay { get; set; }
		public string loopType { get; set; }
		public string easeType { get; set; }
		public string rotateAngle { get; set; }
		public string[] nodes { get; set; }
	}


}
