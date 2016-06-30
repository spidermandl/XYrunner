using UnityEngine;
using System.Collections;
using SimpleFramework;
using SimpleFramework.Manager;

public class InitApp : MonoBehaviour {


	void Awake(){
		AppFacade.Instance.StartUp ();
	}

	void Start () {
		GameManager gM = AppFacade.Instance.GetManager<GameManager> (ManagerName.Game);
		gM.setEnterGame (enterGame);
	}
	
	// Update is called once per frame
	void Update () {

	}


	void enterGame(){
		StartCoroutine (Loading());
	}

	IEnumerator Loading()
	{
		yield return new WaitForEndOfFrame();
		AsyncOperation async = Application.LoadLevelAsync("transation_scene");
		async.allowSceneActivation = false;
		//yield return async;
		while (!async.isDone&& async.progress < 0.89f)
		{
			yield return 1;
		}

		async.allowSceneActivation = true;
		//yield return async;
	}
}
