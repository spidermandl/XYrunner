using UnityEngine;
using System.Collections;
using SimpleFramework;
using SimpleFramework.Manager;

public class MemoryTest : MonoBehaviour {

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
		GameObject obj = GameObject.Instantiate(Util.LoadPrefab ("Building/scenes_construction_alchemy01"));
		//Util.releaseMemory ();
		Destroy (obj);
	}
}
