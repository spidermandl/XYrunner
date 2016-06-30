using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;


public class AnimTool{
	
	
	[MenuItem("AnimationClip/GetFilteredtoAnim",true)]
	static bool NotGetFiltered()
	{
		return Selection.activeObject;
	}
	
	
	[MenuItem("AnimationClip/GetFilteredtoAnim")]
	static void GetFiltered()
	{
		string targetPath = Application.dataPath + "/AnimationClip";
		if(!Directory.Exists(targetPath))
		{
			Directory.CreateDirectory(targetPath);
		}
		Object[] SelectionAsset = Selection.GetFiltered(typeof(Object),SelectionMode.Unfiltered);
		Debug.Log(SelectionAsset.Length);
		foreach(Object Asset in SelectionAsset)
		{
			AnimationClip newClip = new AnimationClip();
			EditorUtility.CopySerialized(Asset,newClip);
			AssetDatabase.CreateAsset(newClip,"Assets/AnimationClip/"+Asset.name+".anim");
		}
		AssetDatabase.Refresh();
	}
}
