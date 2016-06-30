using UnityEngine;  
using UnityEditor;  
using System.Collections;  
using System.Text;
public class GetObjPatch : ScriptableObject  
{  
	[MenuItem ("GameObject/GetObjPatch")]  
	static void DoGetObjPatch()  
	{  
		Object[] ss = Selection.GetFiltered(typeof(Transform),SelectionMode.DeepAssets);
		
		Debug.LogError( Getpatch(ss[0] as Transform));

	}
	static string Getpatch(Transform obj)
	{
		string ret = obj.gameObject.name;
		if(obj.parent == null)
			return ret;
		else
		{
			return Getpatch(obj.parent) + "/"+ ret;
		}
			
	}
}