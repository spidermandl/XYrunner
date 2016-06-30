
using UnityEngine;
using System.Collections;

public class iTweenTest : MonoBehaviour {

	public Vector3 startPoint;
	public Vector3 endPoint;
	public float cursor;
	public float overTop;
	public float moveSpeed;
	public GameObject[] objects;

	// Use this for initialization
	void Start () {
		//BoundingMove (startPoint,endPoint,cursor,overTop,moveSpeed);
		iTweenPath iPath = this.gameObject.GetComponent<iTweenPath> ();
		iTween.MoveTo (this.gameObject, iTween.Hash ("path", iPath.nodes.ToArray (), "speed", 5,
		                                           "oncomplete", "CallMethod"
		                                           //,"oncompletetarget",gameObject.GetComponent<BundleLua>()
		                                           , "oncompleteparams", "itweenCallback",
		                                           	"easeType",iTween.EaseType.linear));
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void BoundingMove(Vector3 start,Vector3 end,float perLine,float delTop,float speed){
		if (perLine >= 1 || perLine <= 0)
			perLine = 0.5f;
		float top = start.y > end.y ? start.y+delTop : end.y+delTop;
		Vector3 topPoint = new Vector3((end.x-start.x)*perLine+start.x,top,(end.z-start.z)*perLine+start.z);
		Vector3[] paths = new Vector3[3];
		paths [0] = start;
		paths [1] = topPoint;
		paths [2] = end;
		iTween.MoveTo(this.gameObject, iTween.Hash("path",paths,"speed",speed,"easeType",iTween.EaseType.linear));
	}
}
