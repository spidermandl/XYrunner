using UnityEngine;
using System.Collections;
using SimpleFramework;
using SimpleFramework.Manager;

public class ObjectFactory : MonoBehaviour {

	// Use this for initialization
	void Start () {
		GameObject dirctorObj = new GameObject();
		dirctorObj.SetActive (false);
		BundleLua coin = dirctorObj.AddComponent<BundleLua> ();
		coin.luaName = "EliminateItem";
		dirctorObj.transform.localScale = new Vector3 (0.5f, 0.025f, 0.5f);
		dirctorObj.transform.position = new Vector3 (10, 1, 0);
		dirctorObj.SetActive (true);
		dirctorObj.transform.parent = gameObject.transform;


		GameObject stepCapsule = new GameObject();
		stepCapsule.SetActive (false);
		BundleLua step = stepCapsule.AddComponent<BundleLua> ();
		step.luaName = "FlatSurface";
		stepCapsule.transform.localScale = new Vector3 (2, 0.1f, 1.5f);
		stepCapsule.transform.position = new Vector3 (15, 2, 0);
		stepCapsule.SetActive (true);
		stepCapsule.transform.parent = gameObject.transform;


//		stepCapsule = new GameObject();
//		stepCapsule.SetActive (false);
//		step = stepCapsule.AddComponent<BundleLua> ();
//		step.luaName = "MonoSurface";
//		stepCapsule.transform.localScale = new Vector3 (3f, 0.1f, 1.5f);
//		stepCapsule.transform.position = new Vector3 (7, 2, 0);
//		stepCapsule.SetActive (true);
//		stepCapsule.transform.parent = gameObject.transform;
		//GameObject.Destroy (dirctorObj);


		GameObject boxCapsule = new GameObject();
		boxCapsule.SetActive (false);
		BundleLua box = boxCapsule.AddComponent<BundleLua> ();
		box.luaName = "TreasureItem";
		boxCapsule.transform.localScale = new Vector3 (1, 1, 1);
		boxCapsule.transform.position = new Vector3 (8, 0, 0);
		boxCapsule.SetActive (true);
		boxCapsule.transform.parent = gameObject.transform;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
