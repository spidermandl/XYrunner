using UnityEngine;
using System.Collections;
using SimpleFramework;

public class UIButtonCtrl :BundleLua
{
	public double attachID = 0;//
	public string luaName = null;//Desmond lua 逻辑文件名 

	protected void Awake(){}

    protected void Start(){}


    protected void OnClickEvent(GameObject go){}

    protected void Update(){}

    protected void FixedUpdate(){}

    public void OnDoubleClick(GameObject button)
    {
        base.CallMethod("DoUIButton", gameObject.GetInstanceID(), "OnDoubleClick", button);
    }
    public void OnClick(GameObject button)
    {
		base.CallMethod("DoUIButton", gameObject.GetInstanceID(), "OnClick", button);
    }

    public void OnPress(GameObject button)
    {
		base.CallMethod("DoUIButton", gameObject.GetInstanceID(), "OnPress", button);
    }

    public void OnRelease(GameObject button)
    {
		base.CallMethod("DoUIButton", gameObject.GetInstanceID(), "OnRelease", button);
    }
}
