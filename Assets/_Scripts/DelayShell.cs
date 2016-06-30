//using UnityEngine;
//using System;
//using System.Collections;
//
//public class DelayShell : MonoBehaviour {
//
//	public string luaName;
//	public string[] sets;
//
//	// Use this for initialization
//	void Start () {
//		gameObject.SetActive (false);
//		BundleLua step = gameObject.AddComponent<BundleLua> ();
//		step.luaName = luaName;
//		if (sets == null || sets.Length == 0)
//			sets = null;
//		else {
//			String a = (string)sets.GetValue(0);
//		}
//		step.param = sets;
////		if (gameObject.transform.Find ("step") != null) {
////			Transform trans =  gameObject.transform.Find("step");
////			//trans.position = new Vector3 (0, 0, 0);
////		}
//		gameObject.SetActive (true);
//	}
//	
//	// Update is called once per frame
//	void Update () {
//	}
//}
