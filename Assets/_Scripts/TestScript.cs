using UnityEngine;
using System.Collections;
using SimpleFramework;
using SimpleFramework.Manager;


public class TestScript : MonoBehaviour {

	Animator animator;
	GameObject target;
	void Awake(){
//		animator = this.gameObject.GetComponent<Animator> ();
//		target = GameObject.Find("Sphere");//this.gameObject.transform.FindChild ("Sphere");
//		animator.Play("ride");

//		ParticleSystem s;
//		s.Stop ();
//		s.isStopped;


//		GameObject obj = GameObject.Instantiate(Resources.Load ("Prefabs/Building/scenes_construction_alchemy01", typeof(GameObject)) as GameObject);
//		//Resources.UnloadAsset (obj);
//		Destroy (obj);
		//Resources.UnloadAsset (obj);

	}
	// Use this for initialization
	void Start () {

//		Transform skin = this.gameObject.transform.Find ("player_male@skin");
//		Transform t = skin.Find ("player_male_Body");
//		SkinnedMeshRenderer rend = t.GetComponent<SkinnedMeshRenderer> ();
//		rend.material.color = Color.red;
//		//rend.material.SetColor("_RimColor",Color.red);
//		t = skin.Find ("player_male_Head");
//		rend = t.GetComponent<SkinnedMeshRenderer> ();
//		//rend.material.SetColor("_RimColor",Color.red);
//		rend.material.color = Color.red;
//		animator.SetLookAtWeight(1);
//		animator.SetLookAtPosition (target.transform.position);
		StartCoroutine (wait());
	}
	
	// Update is called once per frame
	void Update () {


	}

	public IEnumerator wait() {

		yield return new WaitForSeconds(3);

		Application.LoadLevel ("void");
	}

	void OnAnimatorIK(int layerIndex)
	{
		animator.SetLookAtWeight(1);
		animator.SetLookAtPosition (target.transform.position);
		animator.SetIKPositionWeight(AvatarIKGoal.RightFoot,1.0f);
		animator.SetIKRotationWeight(AvatarIKGoal.RightFoot,1.0f);  
		animator.SetIKPosition(AvatarIKGoal.RightFoot,target.transform.position);
		animator.SetIKRotation(AvatarIKGoal.RightFoot,target.transform.rotation);
	}
}


//public class DelayShell : MonoBehaviour {
//	
//	public string luaName;
//	public string[] sets;
//	
//	// Use this for initialization
//	void Start () {
//		gameObject.SetActive (false);
//		BundleLua step = gameObject.AddComponent<BundleLua> ();
//		step.luaName = luaName;
//		if (sets == null || sets.Length == 0)
//			sets = null;
//		else {
//			String a = (string)sets.GetValue(0);
//		}
//		step.param = sets;
//		//		if (gameObject.transform.Find ("step") != null) {
//		//			Transform trans =  gameObject.transform.Find("step");
//		//			//trans.position = new Vector3 (0, 0, 0);
//		//		}
//		gameObject.SetActive (true);
//	}
//	
//	// Update is called once per frame
//	void Update () {
//	}
//}