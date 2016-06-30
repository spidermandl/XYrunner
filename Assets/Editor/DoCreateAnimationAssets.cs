using UnityEngine;
using System.Collections;
using UnityEditor;
using UnityEditor.Animations;

public class DoCreateAnimationAssets:Editor  {

	//[MenuItem("CreateAnimation/Test")]
	public static void DoCreateAnimationAsset() 
	{
		//创建animationController文件，保存在Assets路径下
		AnimatorController animatorController = AnimatorController.CreateAnimatorControllerAtPath("Assets/Resources/animation.controller");
		//得到它的Layer， 默认layer为base 你可以去拓展
		AnimatorControllerLayer layer = animatorController.layers[0];
		//把动画文件保存在我们创建的AnimationController中
		AddStateTransition("Assets/Resources/Models/Player/Player_male/Anima/player_male@run01.FBX",layer);
		//AddStateTransition("Assets/Resources/Animations/desmond_generic/jump02",layer);
		//AddStateTransition("Assets/Resources/Animations/desmond_generic/jump03",layer);
	}
	
	private static void AddStateTransition(string path, AnimatorControllerLayer layer)
	{
		AnimatorStateMachine sm = layer.stateMachine;
		//根据动画文件读取它的AnimationClip对象
		AnimationClip newClip = AssetDatabase.LoadAssetAtPath(path, typeof(AnimationClip)) as AnimationClip;
		if (newClip == null) {
			Debug.LogError("clip is null");
			return;
		}
		//取出动画名子 添加到state里面
		AnimatorState  state = sm.AddState(newClip.name);
		state.motion = newClip;
		//把state添加在layer里面
		AnimatorStateTransition trans = sm.AddAnyStateTransition(state);
		//把默认的时间条件删除
		//trans.RemoveCondition(0);
	}
	/*
	void OnPostprocessModel(GameObject go)
	{
		List<AnimationClip> clips = new List<AnimationClip>();
		UnityEngine.Object[] objects = AssetDatabase.LoadAllAssetsAtPath(assetPath);
		Debug.Log(objects.Length);
		foreach (var obj in objects) {
			AnimationClip clip = obj as AnimationClip;
			if (clip != null && clip.name.IndexOf("__preview__") == -1) {
				clips.Add(clip);
			}
		}
		
		CreateAnimationController(assetPath, clips);
	}
	
	static void CreateAnimationController(string path, List<AnimationClip> clips)
	{
		path = path.Replace("\\", "/").Replace(".FBX", ".fbx");
		string acPath = path.Replace(".fbx", ".controller");
		string prefabPath = path.Replace(".fbx", ".prefab");
		
		// 创建动画控制器
		AnimatorController animatorController = AnimatorController.CreateAnimatorControllerAtPath(acPath);
		AnimatorControllerLayer layer = animatorController.GetLayer(0);
		UnityEditorInternal.StateMachine sm = layer.stateMachine;
		Vector3 anyStatePosition = sm.anyStatePosition;
		float OFFSET_X = 220;
		float OFFSET_Y = 60;
		float ITEM_PER_LINE = 4;
		float originX = anyStatePosition.x - OFFSET_X * (ITEM_PER_LINE / 2.5f);
		float originY = anyStatePosition.y + OFFSET_Y;
		float x = originX;
		float y = originY;
		foreach (AnimationClip newClip in clips) {
			State state = sm.AddState(newClip.name.ToLower());
			state.SetAnimationClip(newClip, layer);
			state.position = new Vector3(x, y, 0);
			x += OFFSET_X;
			if (x >= originX + OFFSET_X * ITEM_PER_LINE) {
				x = originX;
				y += OFFSET_Y;
			}
		}
		
		// 创建prefab
		string name = path.Substring(path.LastIndexOf("/") + 1).Replace(".fbx", "");
		prefabPath = "Assets/Resources/" + name + ".prefab";
		GameObject go = AssetDatabase.LoadAssetAtPath(path, typeof(GameObject)) as GameObject;
		go.name = name;
		Animator animator = go.GetComponent<Animator>();
		if (animator == null) {
			animator = go.AddComponent<Animator>();
		}
		animator.applyRootMotion = false;
		animator.runtimeAnimatorController = animatorController;
		//AssetDatabase.CreateAsset(go, prefabPath);
		PrefabUtility.CreatePrefab(prefabPath, go);
		GameObject.DestroyImmediate(go, true);
		
		AssetDatabase.SaveAssets();*/
}
