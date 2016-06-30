using UnityEngine;
using System.Collections;
using SimpleFramework;

public class DataCollector{

	#region singleton
	private static DataCollector instance = null;
	public static DataCollector Instance{
		get{
			if(instance == null){
				instance = new DataCollector ();
			}
			return instance;
		}
	}
	#endregion

	TDGAAccount Account{
		get { 
			return account;
		}
		set{ 
			account=value;
		}
	}
	private TDGAAccount account = null;
	private const string app_id = "34847C98B409C59DB70936DCE69279A6";
	private string channel_id = "xygame";

	public void Start () {
		Debug.Log("----DataCollector.Start----");
		TalkingDataGA.OnStart(app_id, channel_id);
	}

	public void Update () {
		
	}

	public void OnDestroy() {
		Debug.Log("----DataCollector.OnDestroy----");
		TalkingDataGA.OnEnd();
	}

	//-----------------------账户信息--------------------------
	public static void SetAccount(string account_id){
		DataCollector.Instance.Account = TDGAAccount.SetAccount(account_id);
	}

	public static void SetAccountType(int type){
		if(DataCollector.Instance.Account != null)
			DataCollector.Instance.Account.SetAccountType(AccountType.TYPE1);
	}

	public static void SetAccountName(string account_name){
		if(DataCollector.Instance.Account != null)
			DataCollector.Instance.Account.SetAccountName(account_name);
	}

	public static void SetLevel(int level){
		if(DataCollector.Instance.Account != null)
			DataCollector.Instance.Account.SetLevel(level);
	}

	public static void SetGender(int type){
		if(DataCollector.Instance.Account != null){
			switch(type){
			case 0: DataCollector.Instance.Account.SetGender(Gender.MALE);
				break;
			case 1: DataCollector.Instance.Account.SetGender(Gender.FEMALE);
				break;
			default: DataCollector.Instance.Account.SetGender(Gender.UNKNOW);
				break;
			}
		}
	}

	public static void SetGameServer(string servername){
		if(DataCollector.Instance.Account != null)
			DataCollector.Instance.Account.SetGameServer(servername);
	}

	//----------------------购买---------------------------
	public static void OnChargeRequest(string orderid, string iapid, double amountcount, string paytype){
		TDGAVirtualCurrency.OnChargeRequest(orderid,iapid, 1f, "RMB", amountcount, paytype);
	}

	public static void OnChargeSuccess(string orderid){
		TDGAVirtualCurrency.OnChargeSuccess(orderid);
	}

	//----------------------领奖---------------------------
	public static void OnRewrd(double amountcount, string reason){
		TDGAVirtualCurrency.OnReward(amountcount, reason);
	}

	//----------------------消费---------------------------
	public static void OnPurchase(string item, int itemnum, double amountcount){
		TDGAItem.OnPurchase(item, itemnum, amountcount);
	}

	public static void OnUse(string item, int itemnum){
		TDGAItem.OnUse(item, itemnum);
	}

	//----------------------游戏行为---------------------------
	public static void OnBegin(string missionid){
		TDGAMission.OnBegin(missionid);
	}

	public static void OnCompleted(string missionid){
		TDGAMission.OnCompleted(missionid);
	}

	public static void OnFailed(string missionid, string cause){
		TDGAMission.OnFailed(missionid, cause);
	}

}
