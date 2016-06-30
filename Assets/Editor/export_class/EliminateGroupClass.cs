using UnityEngine;
using System.Collections;

public class EliminateGroupClass : ExportBassClass {
	public EliminateItem[] items {get; set;}
	
	public class EliminateItem{
		public string localPosition { get; set; }
		public string localRotation { get; set; }
		public string localScale { get; set; }
		public string material_id { get; set; }
	}
}
