using UnityEngine;
using System.Collections;
using SimpleFramework;
 

/**
 * Desmond
 * 
 * for ik animation callback
 * */
public class IKBehaviour: BundleLua {

	public double attachID = 0;//
	
	protected void Awake(){
	}
	
	protected void Start() {
	}
	
	void Update(){
	}
	
	void FixedUpdate(){
	}
	
	
	void  OnTriggerEnter(Collider other){
		//CallMethod ("OnMsgTriggerEnter",this.gameObject,other);
	}
	
	void OnTriggerStay(Collider other) {
		//CallMethod ("OnTriggerStay",this.gameObject.GetInstanceID (),other);
	}
	
	void OnTriggerExit(Collider other) {
		//CallMethod ("OnTriggerExit",this.gameObject.GetInstanceID(),other);
	}
	
	void OnCollisionEnter(Collision collision) {
		//CallMethod ("OnCollisionEnter",this.gameObject.GetInstanceID(),collision);
		
	}
	
	void OnCollisionStay(Collision collision) {
		//CallMethod ("OnCollisionStay",this.gameObject.GetInstanceID(),collision);
	}
	
	void OnCollisionExit(Collision collision) {
		//CallMethod ("OnCollisionExit",this.gameObject.GetInstanceID(),collision);
	}
	
	void OnAnimatorIK(int layerIndex)
	{
		if (this.attachID != 0) {
			CallMethod ("OnAnimatorIK",attachID);
		}
	}

}
