//// Platform: Android_gfan



using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;




public class AndroidAgent : MonoBehaviour {

    static AndroidJavaObject m_activity;
    static AndroidAgent m_instance;

    void Awake()
    {
        m_instance = this;

        using (AndroidJavaClass cls_UnityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
        {
            m_activity = cls_UnityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
        }

		startSetButton ();
    }

	//设置按钮是否隐藏
	public static void startSetButton()
	{
		m_activity.Call("startSetButton");
	}

	//登录
    public static void startLogin()
    {

		m_activity.Call("startLogin");

    }


	//支付
	public static void startPay(string serial,string appName,int price,string currency,string desc,string gameRoleName,string gameServerName,string gameRoleId,string gameBalance,string gamerVip,string gameLv,string gamePartyName)
    {

		m_activity.Call("startPay",serial,appName,price,currency,desc,gameRoleName,gameServerName,gameRoleId,gameBalance,gamerVip,gameLv,gamePartyName);

    }

	//切换账号
	public static void startSwitch()
	{
		//调用切换账号时,请退到游戏登录界面(因为点击切换账号按钮时,账号已经登出平台)
		m_activity.Call("startSwitch");

	}

	//用户中心
	public static void startUserAccount()
	{

		m_activity.Call("startUserAccount");

	}

	//退出游戏
	public static void startExitGame()
	{

		m_activity.Call("startExitGame");

	}

	public static void startSendGameInfoToUC(string roleId,string roleName,string roleLevel,int zoneId,string zoneName)
	{

		m_activity.Call("startSendGameInfoToUC",roleId,roleName,roleLevel,zoneId,zoneName);

	}
}


