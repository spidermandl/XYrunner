using UnityEngine;
using System.Collections;

//animtion item
public class AnimItemClass : ExportBassClass{
	
	public string  trigger_localPosition { get; set; }
	public string  trigger_localRotation { get; set; }
	public string  trigger_localScale  { get; set; }
	public string  trigger_size { get; set; }

	public AnimObject[] objects { get; set;}

	//animiton single object
	public class AnimObject{
		public string luaName { get; set; }
		public string localPosition { get; set; }
		public string localRotation { get; set; }
		public string localScale { get; set; }
		public string childLocalScale { get; set;}
		public string material_id { get; set; }
		public AnimPath[] path { get; set; }
		
	}

}





















