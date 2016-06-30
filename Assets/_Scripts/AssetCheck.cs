using UnityEngine;
using System.Collections;

// the func is runned before resource copied to sdcard,so it can
// not be implimented by lua
public class AssetCheck : MonoBehaviour {

	public UILabel loadInfo;
	public UILabel versionInfo;
	public UISlider progress;

	private SimpleFramework.Manager.ResourceManager resourceMgr;
	void Awake(){
	}
	// Use this for initialization
	void Start () {
		this.versionInfo.text = "version" + Application.version;
		resourceMgr = AppFacade.Instance.GetManager<SimpleFramework.Manager.ResourceManager>(SimpleFramework.ManagerName.Resource);
	}
	
	// Update is called once per frame
	void Update () {
		string msg = resourceMgr.message;
		float prog = resourceMgr.Progress;
		float aggreate = resourceMgr.Aggreagate;

		if (msg.Contains ("error:")) {
			return;
		}

		loadInfo.text = msg;
		if (aggreate > 0) {
			progress.value = prog/aggreate;
			progress.gameObject.SetActive(true);
		} else {
			progress.gameObject.SetActive(false);
		}
	}
}
