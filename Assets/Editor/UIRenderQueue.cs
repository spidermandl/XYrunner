using System;
using UnityEngine;
public class UIRenderQueue : MonoBehaviour
{
	public int order = 100; // 设置的层级
	public bool isUI = false;
	void Start () 
	{
		if(isUI)
		{
			Canvas canvas = GetComponent<Canvas>();
			if( canvas == null){
				canvas = gameObject.AddComponent<Canvas>();
			}
			canvas.overrideSorting = true;
			canvas.sortingOrder = order;
		}
		else
		{
			Renderer []renders  =  GetComponentsInChildren<Renderer>();
			
			foreach(Renderer render in renders){
				render.sortingOrder = order;
			}
		}
	}
}

