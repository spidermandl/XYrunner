using UnityEngine;
using System.Collections;

public class SameUpdata : MonoBehaviour {

	public TweenAlpha mMaintar;
	public TweenAlpha tTar1;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void LateUpdate () {
		if(mMaintar != null && tTar1 != null && tTar1.gameObject.activeSelf)
		{
			//tTar1.enabled = false;
			tTar1.value = mMaintar.value;
		}
	}
}
