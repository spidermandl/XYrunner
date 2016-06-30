using UnityEngine;
using System.Collections;
using LuaInterface;

public class UIGameCtrl : BundleLua
{
    public UILabel JiangbeiLabel;
    public UILabel CoinLabel;
    public Transform TargetBlood;
    public Transform TargetBloodH;
	// Use this for initialization
    protected void Awake()
    {

    }

	protected void Start()
	{

	}
//    protected void Update(){
//    }
	
//    protected void FixedUpdate(){
//        System.DateTime a;
//    }

//    private bool m_isClick = false;//记录是否长按
//    private void LongPress()//长按事件部分
//    {
//        CallMethod("DoAction", gameObject.GetInstanceID(), "dive");
//        m_isClick = false;
//    }

//    public void SetBlood(float blood)
//    {
//        TargetBlood.localScale = new Vector3(blood, 1, 1);
//    }

//    public void OnClick(GameObject button)
//    {
//        switch (button.name)
//        {
//            //case "BtnJump":
//            //    CallMethod("DoAction", gameObject.GetInstanceID(), "jump");
//            //    break;
//            case "BtnSpeedUp":
//                Debug.Log("BtnSpeedUp");
//                CallMethod("DoAction", gameObject.GetInstanceID(), "sprint");
//                break;
//            case "BtnAttack":
//                Debug.Log("BtnAttack");
//                CallMethod("DoAction", gameObject.GetInstanceID(), "attack");
//                break;
//            case "BtnPause":
//                Debug.Log("BtnPause");
//                break;
//        }
//    }

//    public void OnPress(GameObject button)
//    {
//        m_isClick = true;
//        switch (button.name) {
//        case "BtnJump":
//            CallMethod("DoAction", gameObject.GetInstanceID(), "jump");
//            InvokeRepeating("LongPress",0.1f,0.02f);
//            break;
////		case "BtnSpeedUp":
////			Debug.Log("BtnSpeedUp");
////			CallMethod("DoAction", gameObject.GetInstanceID(), "sprint");
////			break;
////		case "BtnAttack":
////			Debug.Log("BtnAttack");
////			CallMethod("DoAction", gameObject.GetInstanceID(), "attack");
////			break;
//        }
//    }

//    public void OnRelease(GameObject button)
//    {
//        CancelInvoke("LongPress");
//        if (m_isClick)
//        {
            
//        }
//        CallMethod("DoAction", gameObject.GetInstanceID(), "drop");
//    }
}
