using UnityEngine;
using System.Collections;
using LuaInterface;

/**
 * author Desmond
 * */
public class UILua : BundleLua
{
    
	protected void Awake()
	{
	   
	}

	protected void Update(){

	}
	
	protected void FixedUpdate(){
	}
	void OnGUI(){
        //CallMethod("OnGUI", this.gameObject.GetInstanceID());
        //if (GUI.Button(new Rect(10, 300, 50, 50), "jump"))
        //{
        //    CallMethod("DoAction", this.gameObject.GetInstanceID(), "jump");
        //}

        //if (GUI.Button(new Rect(10, 350, 50, 50), "attack"))
        //{
        //    CallMethod("DoAction", this.gameObject.GetInstanceID(), "attack");
        //}

        //if (GUI.Button(new Rect(60, 300, 50, 50), "dive"))
        //{
        //    CallMethod("DoAction", this.gameObject.GetInstanceID(), "dive");
        //}
	}
}
