using LuaInterface;
using UnityEngine;
using System.Collections;

public class LoadingCtrl : BundleLua
{
    public string SceneName = "level_demo_des";
	// Use this for initialization
	void Start ()
	{
        StartCoroutine(Loading());
	}

    IEnumerator Loading()
    {
        float tarTime1 = Time.time;
         while (true)
        {
            if (Time.time - tarTime1 > 0.1f)
            {
                base.CallMethod("DoAction", this.gameObject.GetInstanceID(), "start"); 
                break;
            }
            yield return 1;
        }
        float tarTime = Time.time;
        AsyncOperation async = Application.LoadLevelAsync(SceneName);
        async.allowSceneActivation = false;
        //yield return async;
        while (!async .isDone&& async.progress < 0.89f)
        {
            Debug.Log("QQQJIND:" + async.progress);
            yield return 1;
        }
        while (true)
        {
            if (Time.time - tarTime > 4.9f)
            {
                async.allowSceneActivation = true;
            }
            if (Time.time - tarTime > 5)
            {
                Debug.Log("加载完成！！！" + (Time.time - tarTime));
                base.CallMethod("DoAction", this.gameObject.GetInstanceID(), "end"); 
                //Destroy(this);
                break;
            }
            yield return 1;
        }
    }
}
