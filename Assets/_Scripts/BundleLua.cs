using UnityEngine;
using System.Collections;
using SimpleFramework;

/**
 * Desmond
 * */
using System.Collections.Generic;
using System;


public class BundleLua : LuaBehaviour {

	protected static bool initialize = true;
	
	public string luaName = null;//Desmond lua 逻辑文件名
	public string[] param = null;//Desmond
	public ArrayList args = null;
	public Boolean isUpdate = true;//switch of lua update fixupdate

	protected void Awake(){
	    luaName = luaName == null ? "main" : luaName;
        //Debug.Log ("---------------------lua name:"+luaName+", "+this.gameObject.GetInstanceID ()+"------>>>>>>-----------------");
//		object[] args = new object[4];
//		args [0] = this.gameObject.GetInstanceID ();
//		args [1] = luaName;
//		args [2] = this.gameObject;
//		args [3] = param;
//		CallMethod ("setCore", args);
		if (param!=null && param.Length==0)
			CallMethod ("setCore", this.gameObject.GetInstanceID (), luaName, this.gameObject);
		else
			CallMethod ("setCore", this.gameObject.GetInstanceID (), luaName, this.gameObject, param);
		CallMethod("Awake");

	}

	protected void Start() {
		CallMethod("Start");
	}

	protected void OnEnable() {
		CallMethod("OnEnable");
	}

	protected void OnDisable() {
		CallMethod("OnDisable");
	}

	void Update(){
		if(isUpdate)
			CallMethod ("Update");
	}

	void LateUpdate (){
		if(isUpdate)
			CallMethod ("LateUpdate");
	}

	void FixedUpdate(){
		if(isUpdate)
			CallMethod ("FixedUpdate");
	}

	void OnDestroy(){
		CallMethod ("OnDestroy");
	}

	protected object[] CallMethod(string func) {
		return CallMethod (func, null);
	}
	/// <summary>
	/// 执行Lua方法
	/// </summary>
	protected object[] CallMethod(string func, params object[] args) {
		if (!initialize) return null;
		if (args == null||args.Length==0) {
			return Util.CallMethod("LuaShell", func, this.gameObject.GetInstanceID());
		}
		return Util.CallMethod("LuaShell", func, args);
	}

	void  OnTriggerEnter(Collider other){
		CallMethod ("OnTriggerEnter",this.gameObject.GetInstanceID (),other);
	}
	
	void OnTriggerStay(Collider other) {
		CallMethod ("OnTriggerStay",this.gameObject.GetInstanceID (),other);
	}
	
	void OnTriggerExit(Collider other) {
		CallMethod ("OnTriggerExit",this.gameObject.GetInstanceID(),other);
	}

	void OnCollisionEnter(Collision collision) {
		CallMethod ("OnCollisionEnter",this.gameObject.GetInstanceID(),collision);
	
	}

	void OnCollisionStay(Collision collision) {
		CallMethod ("OnCollisionStay",this.gameObject.GetInstanceID(),collision);
	}

	void OnCollisionExit(Collision collision) {
		CallMethod ("OnCollisionExit",this.gameObject.GetInstanceID(),collision);
	}

	void OnAnimatorIK()
	{
		CallMethod ("OnAnimatorIK");
	}
	
}
