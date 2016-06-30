using UnityEngine;
using System.Collections;


public class BundleTools{
	static public Rect rectForWeb;//fjc
	static public string urlForWeb;//fjc
	//弹跳路径
	public static void BouncingMove(GameObject gameObject,Vector3 start,Vector3 end,float perLine,float delTop,float speed){
		if (perLine >= 1 || perLine <= 0)
			perLine = 0.5f;
		float top = start.y > end.y ? start.y+delTop : end.y+delTop;
		Vector3 topPoint = new Vector3((end.x-start.x)*perLine+start.x,top,(end.z-start.z)*perLine+start.z);
		Vector3[] paths = new Vector3[3];
		paths [0] = start;
		paths [1] = topPoint;
		paths [2] = end;
		if (speed <= 0)
			speed = 2.0f;
		iTween.MoveTo (gameObject, iTween.Hash ("path", paths, "speed", speed, "easeType", iTween.EaseType.linear//));
		                                      ,"oncomplete","CallMethod"
		                                        //,"oncompletetarget",gameObject.GetComponent<BundleLua>()
		                                        ,"oncompleteparams","itweenCallback"));
	}
	// 重生路径
	public static void ReviveMove(GameObject gameObject,Vector3 point1,Vector3 point2,Vector3 point3,float speed){
		Vector3[] paths = new Vector3[3];
		paths [0] = point1;
		paths [1] = point2;
		paths [2] = point3;
		if (speed <= 0)
			speed = 2.0f;
		iTween.MoveTo (gameObject, iTween.Hash ("path", paths, "speed", speed, "easeType", iTween.EaseType.linear//));
		                                        ,"oncomplete","CallMethod"
		                                        //,"oncompletetarget",gameObject.GetComponent<BundleLua>()
		                                        ,"oncompleteparams","itweenCallback"));
	}

	public static void setSlideProgress(GameObject parent,float value){
		UISlider slide = parent.transform.GetComponent<UISlider> ();
		if (slide != null)
			slide.value = value;
	}

	public static void CreateWebView(float x,float y,float w,float h,string url){
		//Vector3 wordPos = Camera.WorldToScreenPoint (x,y,-10); 
		//Debug.Log ("fjc createWeb  "+wordPos.ToString());
		//Rect tmpRect = new Rect (x-w/2,y+h/2,w,h);
		//Rect tmpRect1 = new Rect (tmpRect.x,LeftTopAxisToLeftDownAix(tmpRect.y),w,h); 
		//Debug.Log ("fjc ----------- CreateWebView  "+tmpRect.ToString()+"  "+tmpRect1.ToString());
		rectForWeb = new Rect(x,y,w,h);
		urlForWeb = url;
	}

	private static float LeftTopAxisToLeftDownAix(float h){
		float y0 = Screen.height-h;
		return y0;
	}


}