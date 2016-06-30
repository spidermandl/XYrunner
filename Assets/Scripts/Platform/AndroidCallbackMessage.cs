//// Platform: Android_gfan

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public class AndroidCallbackMessage : MonoBehaviour {
	public const int SUCCESS                 = 0;	//登录或支付成功
	public const int ERROR_CANCEL            = -1;	//登录或支付取消
	public const int ERROR_LOGIN_FAIL        = -2;	//登录失败
	public const int ERROR_PAY_FAIL          = -3;	//支付失败
	public const int ERROR_PAY_ORDER_SUBMIT  = -10; // 充值卡订单已经提交
	
	public const int ERROR_EXIT_GAME         = 3;   // 退出游戏(弹渠道的退出框,不弹出游戏退出框)
	public const int ERROR_EXIT_GAME_0       = 4;   // 退出游戏(弹出游戏退出框)
	public const int ERROR_CONTINUE_GAME     = 5;   // 继续游戏
	public const int ERROR_SIGNOFF           = 6;  // 注销
	
	public static int configSwitch			 = 0;	//切换换账号配置(默认为:0)
	public static int configUserAccount		 = 0;   //用户中心配置(默认为:0)
	
	
	
	//回调信息类型
	//按钮设置信息回调（主要因为部分渠道只有登录和支付接口,调用其它接口的按钮就需要隐藏）
	public const string CALL_BACK_TYPE_SET_BUTTON = "set_Button_result";
	//初始化
	public const string CALL_BACK_TYPE_INIT = "init_result";
	//注销
	public const string CALL_BACK_TYPE_SIGNOFF = "signoff_result";
	//登录
	public const string CALL_BACK_TYPE_LOGIN = "login_result";
	//支付
	public const string CALL_BACK_TYPE_PAY = "pay_result";
	//退出游戏
	public const string CALL_BACK_TYPE_EXIT_GAME = "exit_game_result";
	
	
	public void AndroidCallback (string str)
	{
		string[] msgs = str.Split(new char[]{':'} , System.StringSplitOptions.RemoveEmptyEntries );
		
		string callbackResult = msgs [0];
		Dictionary<string, string> msg_params = null;
		
		if (msgs.Length > 1)
		{
			msg_params = new Dictionary<string, string>();
			string[] strParams = msgs[1].Split(',');
			foreach (var p in strParams)
			{
				string[] kv = p.Split('=');
				msg_params.Add(kv[0], kv[1]);
			}
		}
		
		
		switch (callbackResult) {
		case CALL_BACK_TYPE_SET_BUTTON:
			OnSetButtonResult(msg_params);
			break;
		case CALL_BACK_TYPE_INIT:
			//初始化回调信息
			OnInitResult(msg_params);
			break;
		case CALL_BACK_TYPE_SIGNOFF:
			//注销回调信息
			OnSignoffResult(msg_params);
			break;
		case CALL_BACK_TYPE_LOGIN:
			//登录回调信息
			OnLoginResult(msg_params);
			break;
		case CALL_BACK_TYPE_PAY:
			//支付回调信息
			OnPayResult(msg_params);
			break;
		case CALL_BACK_TYPE_EXIT_GAME:
			//退出游戏回调查信息
			OnExitGameResult(msg_params);
			break;
		}
	}
	
	public void OnSetButtonResult(Dictionary<string, string> msg_params)
	{
		//0:显示该按钮  1:隐藏按钮		可在Android资源文件Android\res\values\j7_game_config.xml调试配置
		configSwitch = int.Parse(msg_params["switchAccountStr"]);
		configUserAccount = int.Parse(msg_params["userAccountStr"]);
		
		Debug.LogError ("OnInitResult :"+"configSwitch:"+configSwitch + "configUserAccount:"+configUserAccount);
	}
	
	public void OnInitResult(Dictionary<string, string> msg_params)
	{
		int code = int.Parse (msg_params ["error"]);
		
		Debug.LogError ("OnInitResult :"+"error:"+code);
		
		switch(code)
		{
		case ERROR_EXIT_GAME:
			//关闭游戏
			colseGame();
			break;
		case ERROR_CONTINUE_GAME:
			//继续游戏
			break;
		}
	}
	
	public void OnSignoffResult(Dictionary<string, string> msg_params)
	{
		int code = int.Parse (msg_params ["error"]);
		
		Debug.LogError ("OnSignoffResult :"+"error:"+code);
		
		switch (code) 
		{
		case ERROR_SIGNOFF:
			//从游戏内退出到登录界面
			break;
		}
	}
	
	public void OnLoginResult(Dictionary<string, string> msg_params)
	{
		int code = int.Parse (msg_params ["error"]);
		string userName = msg_params ["username"];
		int uid = int.Parse(msg_params["uid"]);
		string sessionId = msg_params["session"];
		
		Debug.LogError ("OnLoginresult :"+"error:"+code +" userName:"+userName+" uid:"+uid+" sessionId:"+sessionId);
		
		switch (code) 
		{
		case SUCCESS:
			//登录成功
			break;
		case ERROR_CANCEL:
			//取消登录
			break;
		case ERROR_LOGIN_FAIL:
			//登录失败
			break;
		default:
			//登录失败
			break;
		}
	}
	
	public void OnPayResult(Dictionary<string, string> msg_params)
	{
		int code = int.Parse(msg_params["error"]);
		string orderId = msg_params ["orderId"];
		
		Debug.LogError ("OnPayResult :"+"error:"+code +" orderId:"+orderId);
		
		switch (code) 
		{
		case SUCCESS:
			//支付成功
			break;
		case ERROR_CANCEL:
			//取消支付
			break;
		case ERROR_PAY_FAIL:
			//支付失败
			break;
		case ERROR_PAY_ORDER_SUBMIT:
			//订单已提交,请稍后查询
			break;
		default:
			//支付失败
			break;
		}
	}
	
	public void OnExitGameResult(Dictionary<string, string> msg_params)
	{
		int code = int.Parse(msg_params["error"]);
		
		Debug.LogError ("OnExitGameResult :"+"error:"+code );
		
		switch(code)
		{
		case ERROR_EXIT_GAME:
			//直接关闭游戏
			colseGame();
			break;
		case ERROR_CONTINUE_GAME:
			//继续游戏
			break;
		}
	}
	
	public void colseGame(){
		Debug.LogError ("colseGame......................." );
		Application.Quit();
	}
}
