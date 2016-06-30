using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using UnityEditor;
using System.IO;
using System.Text;
using LitJson;

/**
 * game editor tool
 * */
public class RunnerTool{

	[MenuItem("Desmond/GetFilteredtoAnim",true)]
	static bool NotGetFiltered()
	{
		return Selection.activeObject;
	}
	
	
	[MenuItem("Desmond/GetFilteredtoAnim")]
	static void GetFiltered()
	{
		string targetPath = Application.dataPath + "/AnimationClip";
		if(!Directory.Exists(targetPath))
		{
			Directory.CreateDirectory(targetPath);
		}
		UnityEngine.Object[] SelectionAsset = Selection.GetFiltered(typeof(UnityEngine.Object),SelectionMode.Unfiltered);
		Debug.Log(SelectionAsset.Length);
		foreach(UnityEngine.Object Asset in SelectionAsset)
		{
			AnimationClip newClip = new AnimationClip();
			EditorUtility.CopySerialized(Asset,newClip);
			AssetDatabase.CreateAsset(newClip,"Assets/AnimationClip/"+Asset.name+".anim");
		}
		AssetDatabase.Refresh();
	}

	/***************************************************************************************************************************************
	 ****************************************************************************************************************************************
	 ****************************************************************************************************************************************
	 ****************************************************************************************************************************************
	 */
	/**检测台阶碰撞*/
	[MenuItem("Desmond/Surface Check", false, 11)]
	static public void checkSurfaceIso()
	{
		Debug.Log("Create map ");
		// AssetDatabase.CreateAsset();
		ArrayList surfaces = new ArrayList();
		int colNum = 0;
		
		GameObject gMan = GameObject.Find ("Objects");
		if (gMan == null) {
			return;
		}
		Transform collider = gMan.transform.Find ("collider");
		if (collider == null) {
			return;
		}

		for (int i=0;i<collider.childCount;i++)
		{
			GameObject o= collider.GetChild(i).gameObject;
			BundleLua bLua = o.GetComponent<BundleLua>();
			if (bLua!=null){
				if(bLua.luaName.Equals("FlatSurface") || bLua.luaName.Equals("HangingSurface")){
					surfaces.Add(o);
				}
			}
		}
		
		for (int i=0; i<surfaces.Count; i++) {
			for(int j=0;j<surfaces.Count;j++){
				if (j==i)
					continue;
				if (isObjRectIntersect(surfaces[i] as GameObject,surfaces[j] as GameObject)){
					colNum ++;
				}
				//Debug.Log (".......................................");
			}
		}
		
		if (colNum == 0)
			Debug.Log ("没有碰撞的地面台阶");
		else
			Debug.Log ("有碰撞的地面台阶");
	}
	//判断cube是否有相交
	static public bool isObjRectIntersect(GameObject a,GameObject b){
		int colNum = 0;
		Vector3 center1 = a.transform.position;
		Vector3 size1 = //a.transform.Find ("step").localScale;//GetComponent<BoxCollider> ().size;
			a.transform.localScale;
		Vector3 center2 = b.transform.position;
		Vector3 size2 = //b.transform.Find ("step").localScale;//GetComponent<BoxCollider> ().size;
			b.transform.localScale;
		
		if (isRectIntersect (
			new Rectangle (center1.x - size1.x / 2, center1.x + size1.x / 2, center1.y - size1.y / 2, center1.y + size1.y / 2),
			new Rectangle (center2.x - size2.x / 2, center2.x + size2.x / 2, center2.y - size2.y / 2, center2.y + size2.y / 2))) {
			colNum++;
		}
		
		if (isRectIntersect (
			new Rectangle (center1.x - size1.x / 2, center1.x + size1.x / 2, center1.z - size1.z / 2, center1.z + size1.z / 2),
			new Rectangle (center2.x - size2.x / 2, center2.x + size2.x / 2, center2.z - size2.z / 2, center2.z + size2.z / 2))) {
			colNum++;
		}
		
		if (isRectIntersect (
			new Rectangle (center1.z - size1.z / 2, center1.z + size1.z / 2, center1.y - size1.y / 2, center1.y + size1.y / 2),
			new Rectangle (center2.z - size2.z / 2, center2.z + size2.z / 2, center2.y - size2.y / 2, center2.y + size2.y / 2))) {
			colNum++;
		}
		//Rectangle one = a.c 
		if (colNum >= 2) {
			//Debug.Log("name: "+ a.name+" x: "+center1.x+" y: "+center1.y+" z: "+center1.z+" "+b.name);
			Debug.Log("name: "+ a.name+" "+b.name);
			return true;
		}
		
		
		return false;
	}
	static public bool isRectIntersect(Rectangle a, Rectangle b) {  
		// 需要排除特殊情况：一个矩形在另一个矩形内  
		//		if ((a.top < b.top && a.bottom > b.bottom && a.right < b.right && a.left > b.left) || (b.top < a.top && b.bottom > a.bottom && b.right < a.right && b.left > a.left)) {  
		//			return false;  
		//		}  
		
		if (a.top < b.bottom || a.bottom > b.top || a.right < b.left || a.left > b.right)
			return false;
		return true;  
	}
	
	/***************************************************************************************************************************************
	 ****************************************************************************************************************************************
	 ****************************************************************************************************************************************
	 ****************************************************************************************************************************************
	 */
	static public void createSceneLayout(string savingPath,GameObject root,LuaScriptMgr luaMgr){
		ArrayList exports = new ArrayList();
		
		GameObject gMan = null;
		if (root != null)
		    gMan = root.transform.Find("Objects").gameObject;
		if (gMan == null) {
			gMan = GameObject.Find ("Objects");
		}
		if (gMan == null) {
			return;
		}
		//collider配置
		Transform surfaces = gMan.transform.Find ("collider");
		for (int i=0;i<surfaces.childCount;i++)
		{
			GameObject o= surfaces.GetChild(i).gameObject;
			BundleLua bLua = o.GetComponent<BundleLua>();
			//PrefabUtility.GetPrefabType(o)  == PrefabType.PrefabInstance && 
			if (bLua!=null){
				exports.Add(o);
			}
			
		}
		
		//item配置
		Transform items = gMan.transform.Find ("item");
		for (int i=0;i<items.childCount;i++)
		{
			GameObject o= items.GetChild(i).gameObject;
			BundleLua [] luaScripts = o.GetComponentsInChildren<BundleLua>();
			if (luaScripts.Length <= 1){ //single item
				BundleLua bLua = o.GetComponent<BundleLua>();
				if (bLua!=null){
					exports.Add(o);
				}
				continue;
			}
			BundleLua b = o.GetComponent<BundleLua>();
			if (b==null){
				b = o.AddComponent<BundleLua>();
			}

			b.luaName="EliminateItemGroup";

			exports.Add(o);
		}
		
		//复活模块
		Transform revives = gMan.transform.Find ("revive");
		for (int i=0;i<revives.childCount;i++)
		{

			GameObject o= revives.GetChild(i).gameObject;
			BundleLua bLua = o.GetComponent<BundleLua>();
			if (bLua!=null){
				exports.Add(o);
			}
			
		}
		
		//弹跳模块
		Transform bouncings = gMan.transform.Find ("bouncing");
		for (int i=0;i<bouncings.childCount;i++)
		{
			GameObject o= bouncings.GetChild(i).gameObject;
			BundleLua bLua = o.GetComponent<BundleLua>();
			if (bLua!=null){
				exports.Add(o);
			}
			
		}
		//敌人配置
		Transform monsters = gMan.transform.Find ("monster");
		for (int i=0;i<monsters.childCount;i++)
		{
			//Debug.Log("monsters.childCount==============" + monsters.childCount);
			GameObject o= monsters.GetChild(i).gameObject;
			BundleLua bLua = o.GetComponent<BundleLua>();
			if (bLua!=null){
				exports.Add(o);
			}
			
		}
		
		//弹跳墙配置
		Transform walls = gMan.transform.Find ("wall");
		for (int i=0;i<walls.childCount;i++)
		{
			GameObject o= walls.GetChild(i).gameObject;
			BundleLua bLua = o.GetComponent<BundleLua>();
			if (//PrefabUtility.GetPrefabType(o)  == PrefabType.PrefabInstance && 
			    bLua!=null){
				exports.Add(o);
			}
			
		}

//		if (luaMgr == null) {
//			luaMgr = new LuaScriptMgr ();
//		}
//		LuaState l = luaMgr.lua;
//
//		l.DoString(luaSource);
//		//========================================================================================================
//		//c# array to lua table
//		LuaFunction f = l.GetFunction("addConfig");
		ArrayList datas = new ArrayList();//class mapping with json foramt
		ExportBassClass[] arrayDatas = null;//class mapping with json foramt with array type
		for (int i=0; i<exports.Count; i++) {
			GameObject o= exports[i] as GameObject;
			
			BundleLua bLua = o.GetComponent<BundleLua>();
			Debug.Log(bLua==null?"":bLua.luaName+" ; "+
			          o.transform.parent.name+
			          o.transform.position.x+","+o.transform.position.y+","+o.transform.position.z+" ; "+
			          o.transform.localRotation.eulerAngles.x+","+o.transform.localRotation.eulerAngles.y+","+o.transform.localRotation.eulerAngles.z+" ; "+
			          o.transform.localScale.x+","+o.transform.localScale.y+","+o.transform.localScale.z);
			bLua = o.GetComponent<BundleLua>();
			
			ExportBassClass data = null;//class mapping with json foramt
			string param = "";

			if (bLua.luaName.Equals("EliminateItemGroup")){
				BundleLua [] luaScripts = o.GetComponentsInChildren<BundleLua>();
				EliminateGroupClass s_data = new EliminateGroupClass();
				data = s_data;
				s_data.items = new EliminateGroupClass.EliminateItem[luaScripts.Length-1];
				int index = 0;
				foreach(BundleLua lua in luaScripts)
				{
					if (lua.luaName != "EliminateItemGroup"){
						GameObject obj = lua.gameObject;
						EliminateGroupClass.EliminateItem item = new EliminateGroupClass.EliminateItem();
						s_data.items[index] = item;
						item.localPosition = obj.transform.localPosition.x+","+obj.transform.localPosition.y+","+obj.transform.localPosition.z;
						item.localRotation = obj.transform.localRotation.eulerAngles.x+","+obj.transform.localRotation.eulerAngles.y+","+obj.transform.localRotation.eulerAngles.z;
						item.localScale = obj.transform.localScale.x+","+obj.transform.localScale.y+","+obj.transform.localScale.z;
						item.material_id = lua.param[0];
						index++;
					}
				}
			}

			if (bLua.luaName.Equals("BouncingSurface")){
				Transform t = o.transform.Find("step");
				bouncingSetting setting = o.GetComponent<bouncingSetting>();
				BouncingSurfaceClass s_data = new BouncingSurfaceClass();
				data = s_data;
				s_data.step_localPosition = t.localPosition.x+","+t.localPosition.y+','+t.localPosition.z;//collider local position
				s_data.step_localScale = t.localScale.x+","+t.localScale.y+','+t.localScale.z;//collider scale
				t = o.transform.Find("bouncing");
				s_data.bouncing_model_name = t.gameObject.tag;//model prefab name
				s_data.bouncing_model_localPosition=t.localPosition.x+","+t.localPosition.y+","+t.localPosition.z;//model local position
				s_data.bouncing_model_localRotation = t.localRotation.eulerAngles.x+","+t.localRotation.eulerAngles.y+","+t.localRotation.eulerAngles.z;//model local rotation
				s_data.bouncing_model_localScale = t.localScale.x+","+t.localScale.y+','+t.localScale.z;//model local scale
				
				iTweenPath[] paths = o.GetComponents<iTweenPath>();
				if (paths == null || paths.Length ==0){
					t = o.transform.Find("target");
					s_data.target_localPosition = t.localPosition.x+","+t.localPosition.y+','+t.localPosition.z;//target position
				}else{
					s_data.target_localPosition = "";
					s_data.bouncing_path = new ExportBassClass.AnimPath[paths.Length];
					addAnimPath(s_data.bouncing_path,paths);

				}
				if (setting != null)
				{
					s_data.m_TargetZ = setting.m_TargetZ;
					s_data.m_isReplaceAction = setting.m_isReplaceAction == true?1.0f:0f;
					s_data.m_Direction = setting.m_Direction;
					s_data.m_ActionSpeed = setting.m_ActionSpeed;
					s_data.m_ActionDelayTime = setting.m_ActionDelayTime;
				}else
				{
					s_data.m_TargetZ = 0.0f;
					s_data.m_isReplaceAction = 1.0f;
					s_data.m_Direction = 1.0f;
					s_data.m_ActionSpeed = 1.0f;
					s_data.m_ActionDelayTime = 0.0f;
				}

							
			}


			if(bLua.luaName.Equals("RedCoinItem")){

				Transform t = o.transform.Find("turnOnItem");    
				param+=";"+t.position.x+","+t.position.y+','+t.position.z;//collider position
				param+=";"+t.localScale.x+","+t.localScale.y+','+t.localScale.z;//collider scale
				Transform tb = o.transform.Find("treasureBox");
				param+=";"+tb.position.x+","+tb.position.y+','+tb.position.z;//collider position
				GameObject redCoinItem = t.transform.parent.gameObject;
				BundleLua [] bundlelua = redCoinItem.transform.GetComponentsInChildren<BundleLua>();
				foreach(BundleLua lua in bundlelua)
				{
					if (lua.luaName =="EliminateItemGroup")
					{
						//Debug.Log (lua.gameObject.name);
						for (int u = 0; u < lua.gameObject.transform.childCount; u++)
						{
							param+=";"+lua.gameObject.transform.GetChild(u).transform.position.x+","+lua.gameObject.transform.GetChild(u).transform.position.y+','+lua.gameObject.transform.GetChild(u).transform.position.z;
						}

					}
				}
			}
			
			if(bLua.luaName.Equals("ElizabethPet")){
				Transform t = o.transform.Find("Elizabeth");
				param+=";"+t.position.x+","+t.position.y+','+t.position.z;//collider position
				param+=";"+t.localScale.x+","+t.localScale.y+','+t.localScale.z;//collider scale
				//遍历Coin
				BundleLua [] bundlelua = o.transform.GetComponentsInChildren<BundleLua>();
				string o_childLuaParm = "noTreasureItem";
				foreach(BundleLua lua in bundlelua)
				{
					if (lua.luaName =="EliminateItem") 
					{
						param+=";"+lua.gameObject.transform.position.x+","+lua.gameObject.transform.position.y+','+lua.gameObject.transform.position.z 
							+","+lua.gameObject.transform.localScale.x+","+ lua.param[0];
//							o_childLuaParm = lua.param[0];

					}
					if (lua.luaName =="TreasureItem")
					{
						param+=";"+lua.gameObject.transform.position.x+","+lua.gameObject.transform.position.y+','+lua.gameObject.transform.position.z 
							+","+lua.gameObject.transform.localScale.x+","+ lua.luaName;
						o_childLuaParm = lua.luaName;
					}

				}
				param+=";"+ o_childLuaParm;

			}

			if(bLua.luaName.Equals("ReviveSurface")){
				Transform t = o.transform.Find("surface");
				//Transform target = o.transform.Find("target");
				BundleLua bundlelua = o.GetComponent<BundleLua>();
				if (bundlelua == null){
					Debug.Log("no target or bundlelua in revivesurface");
					return;
				}

				ReviveSurfaceClass s_data = new ReviveSurfaceClass();
				data = s_data;
				s_data.surface_localScale = t.localScale.x+","+t.localScale.y+','+t.localScale.z;//collider scale
				//s_data.target_localPosition = target.localPosition.x+","+target.localPosition.y+","+target.localPosition.z;//target position

//					param+=";"+t.localScale.x+","+t.localScale.y+','+t.localScale.z;//collider scale
//					param+=";"+target.localPosition.x+","+target.localPosition.y+","+target.localPosition.z;//target position
			}


			if(bLua.luaName.Equals("AnimTriggerItem")){
				Transform trigger = o.transform.Find("trigger");
				BundleLua[] luaObjects = o.transform.Find("objects").GetComponentsInChildren<BundleLua>();

				AnimItemClass s_data = new AnimItemClass();
				data = s_data;
				s_data.trigger_localPosition = trigger.localPosition.x+","+trigger.localPosition.y+","+trigger.localPosition.z;
				s_data.trigger_localRotation = trigger.localRotation.eulerAngles.x+","+trigger.localRotation.eulerAngles.y+","+trigger.localRotation.eulerAngles.z;
				s_data.trigger_localScale = trigger.localScale.x+","+trigger.localScale.y+","+trigger.localScale.z;
				BoxCollider box = trigger.GetComponent<BoxCollider>();
				s_data.trigger_size = box.size.x+","+box.size.y+","+box.size.z;
				s_data.objects = new AnimItemClass.AnimObject[luaObjects.Length];
				int index = 0;
				foreach(BundleLua lua in luaObjects){
					AnimItemClass.AnimObject objAnim = new AnimItemClass.AnimObject();
					s_data.objects[index]= objAnim;
					objAnim.luaName = lua.luaName;
					objAnim.localPosition = lua.transform.localPosition.x+","+lua.transform.localPosition.y+","+lua.transform.localPosition.z;
					objAnim.localRotation = lua.transform.localRotation.eulerAngles.x+","+lua.transform.localRotation.eulerAngles.y+","+lua.transform.localRotation.eulerAngles.z;
					objAnim.localScale = lua.transform.localScale.x+","+lua.transform.localScale.y+","+lua.transform.localScale.z;
					Transform child = lua.gameObject.transform.GetChild(0);
					objAnim.childLocalScale = child.localScale.x+","+child.localScale.y+","+child.localScale.z;
					if (lua.param.Length == 0){
						objAnim.material_id = child.gameObject.name;
					}else{
						objAnim.material_id = lua.param[0];
					}
					iTweenPath[] paths = lua.transform.GetComponents<iTweenPath>();
					objAnim.path = new ExportBassClass.AnimPath[paths.Length];
					addAnimPath(objAnim.path,paths);
					index ++;
				}

			}

			// 弹墙
			if(bLua.luaName.Equals("FlatSurface")){
				iTweenPlayWall playWallInfo = o.GetComponent<iTweenPlayWall>();
				PlayWallDataClass s_data = new PlayWallDataClass();
				data = s_data;
				//Debug.Log("我来了  你在哪里");
				if (playWallInfo != null)
				{


					PlayWallDataClass.PlayWallData rightData = new PlayWallDataClass.PlayWallData();

					rightData.playWallCount = playWallInfo.playWallCount_Right;
					rightData.isCanPlayWall = playWallInfo.isCanPlayWall_Right;
					rightData.stayTime = playWallInfo.stayTime_Right;
					rightData.acceleration = playWallInfo.acceleration_Right;
					s_data.playerWallData_Right = rightData;

					PlayWallDataClass.PlayWallData leftData = new PlayWallDataClass.PlayWallData();
					leftData.playWallCount = playWallInfo.playWallCount_Left;
					leftData.isCanPlayWall = playWallInfo.isCanPlayWall_Left;
					leftData.stayTime = playWallInfo.stayTime_Left;
					leftData.acceleration = playWallInfo.acceleration_Left;
					s_data.playerWallData_Left = leftData;
				}

			}
			if (bLua.luaName.Contains("Enemy"))
			{
				monsterClass s_data = new monsterClass();
				data = s_data;
				CapsuleCollider boxc = o.gameObject.GetComponent<CapsuleCollider>();
				if (boxc != null) 
				{
					s_data.collider_center = boxc.center.x+","+boxc.center.y+","+boxc.center.z;
					s_data.collider_radius = boxc.radius.ToString();
					s_data.collider_height = boxc.height.ToString();
				}
			}


		    if(data == null)
			    data = new ExportBassClass();
			data.luaName = bLua.luaName;
			data.parentName = o.transform.parent.name;
			data.localPosition = o.transform.localPosition.x+","+o.transform.localPosition.y+","+o.transform.localPosition.z;
			data.localRotation =  o.transform.localRotation.eulerAngles.x+","+o.transform.localRotation.eulerAngles.y+","+o.transform.localRotation.eulerAngles.z;
			data.localScale = o.transform.localScale.x+","+o.transform.localScale.y+","+o.transform.localScale.z;

		    data.left_x = getLeft_X(o);
			if (bLua!=null && (bLua.param!=null&&bLua.param.Length>0)){
				//recucively add lua param
				for(int k=0;k<bLua.param.Length;k++){
					param+=bLua.param[k];
					if(k!=bLua.param.Length-1){
						param+=";";
					}
				}
				data.param = param;
			}
		    datas.Add(data);
			//datas[i] = data;

			//				//path animation
//				iTweenPath[] paths = o.transform.GetComponents<iTweenPath>();
//				string itweenPath = "";
//				if (paths!=null&&paths.Length>0){
//					for(int k = 0; k < paths.Length;k++){
//						iTweenPath p = paths[k];
//						itweenPath += (k==0?"":";") + 
//							p.delay + "-"+
//							p.loopType + "-"+
//							p.easeType + "-"+
//							p.rotateAngle.x + "," + p.rotateAngle.y + "," + p.rotateAngle.z + "-";
//						int length = p.nodes.ToArray().Length;
//						for(int j=0;j < length;j++){
//							Vector3 v = p.nodes.ToArray()[j];
//							if(j==length -1)
//								itweenPath += v.x + "," + v.y + "," + v.z;
//							else
//								itweenPath += v.x + "," + v.y + "," + v.z + ":";
//						}
//					}
//				}

			Debug.Log ("-------------------------====================--------------------------"+param);

//				//generate config code
//				f.Call( AssetDatabase.GetAssetPath(o), 
//				       o.transform.parent.name,
//				       bLua==null?"":bLua.luaName,
//				       o.transform.position.x-o.transform.localScale.x/2,
//				       o.transform.position.x+","+o.transform.position.y+","+o.transform.position.z,
//				       o.transform.rotation.x+","+o.transform.rotation.y+","+o.transform.rotation.z,
//				       o.transform.localScale.x+","+o.transform.localScale.y+","+o.transform.localScale.z,
//				       param);
//			}
//			else
//				f.Call( AssetDatabase.GetAssetPath(o), 
//				       o.transform.parent.name,
//				       bLua==null?"":bLua.luaName,
//				       o.transform.position.x-o.transform.localScale.x/2,
//				       o.transform.position.x+","+o.transform.position.y+","+o.transform.position.z,
//				       o.transform.rotation.x+","+o.transform.rotation.y+","+o.transform.rotation.z,
//				       o.transform.localScale.x+","+o.transform.localScale.y+","+o.transform.localScale.z);
			
			
		}
		//f.Release ();

		//sort
		ArrayList sort = new ArrayList ();
		while(datas.Count>0) {
			int length = datas.Count;
			int index =0 ;
			float x = ((ExportBassClass)datas[0]).left_x;
			for(int i =1;i<length;i++){
				//Debug.Log(""+i);
				float temp_x = ((ExportBassClass)datas[i]).left_x;
				if ( temp_x < x){
					x = temp_x;
					index = i;
				}
			}
			
			sort.Add(datas[index]);
			datas.RemoveAt(index);
		}
		datas = sort;
//		arrayDatas = new ExportBassClass[datas.Count];
//		for (int i=0;i<datas.Count;i++){
//			arrayDatas[i] = (ExportBassClass)datas[i];
//		}
//
		StringBuilder sb = new StringBuilder();
		JsonWriter writer = new JsonWriter(sb);
		JsonMapper.ToJson(datas,writer);//data.ToJson();
		string str = sb.ToString ();
		UTF8Encoding utf8 = new UTF8Encoding(true);
		Byte[] encodedBytes = utf8.GetBytes (str);
		File.WriteAllBytes ("Assets/Lua/game/export/" + savingPath + ".json", encodedBytes);
		//File.WriteAllText("Assets/Lua/game/export/" + savingPath + ".json",encodedBytes,Encoding.UTF8);
		Debug.Log ("-------------------------====================--------------------------");
////		if (root == null) {
//			f = l.GetFunction ("save");
//			f.Call (savingPath == null ?
//		        "Assets/Lua/game/export/forest_scene.json" :
//		        "Assets/Lua/game/export/" + savingPath + ".json");
////		} 
////		else {
////			f = l.GetFunction("save_endless_part");
////			f.Call(savingPath);
////		}
//		f.Release();
//		if(luaMgr == null)
//			luaMgr.Destroy ();
		
		
	}
	//get min x bound of the object
	static private int getLeft_X(GameObject obj){
		Bounds bound = new Bounds(Vector3.zero,Vector3.zero);
		//calculate child collider mesh
		MeshFilter[] mfs = obj.transform.GetComponentsInChildren<MeshFilter> ();
		for (int i=0;i<mfs.Length;i++){
							
			Vector3 pos = mfs[i].transform.position;
			Vector3 scale = mfs[i].transform.localScale;
			Bounds child_bounds = mfs[i].sharedMesh.bounds;
			child_bounds.center = child_bounds.center + pos;
			child_bounds.size =  new Vector3(child_bounds.size.x * scale.x,child_bounds.size.y * scale.y,child_bounds.size.z * scale.z);
			if(bound.center == Vector3.zero && bound.size == Vector3.zero)
				bound = child_bounds;
			bound.Encapsulate(child_bounds);
		}

		if (bound.center == Vector3.zero && bound.size == Vector3.zero) {
			MeshFilter this_mf = obj.transform.GetComponent<MeshFilter> ();
			if (this_mf != null){
				bound = this_mf.sharedMesh.bounds;
				//bound.center = this_mf.gameObject.transform.position;
			}else{
				bound.center = obj.transform.position;
				bound.size = new Vector3(1,1,1);
			}
		}
//		Debug.Log("center: x:"+ bound.center.x+" y:"+bound.center.y+" z:"+bound.center.z);
//		Debug.Log("size: x:"+ bound.size.x+" y:"+bound.size.y+" z:"+bound.size.z);
		Debug.Log(obj.name+" " + bound.min.x);
		return (int)bound.min.x;
	}

	//set itweenpath to AnimPath rail
	static private void addAnimPath(ExportBassClass.AnimPath[] export_paths,iTweenPath[] paths){
		if (paths!=null&&paths.Length>0){
			for(int k = 0; k < paths.Length;k++){
				ExportBassClass.AnimPath line = new ExportBassClass.AnimPath();
				export_paths[k] = line;
				iTweenPath p = paths[k];
				line.speed = p.speed;
				line.delay = p.delay;
				line.loopType = p.loopType.ToString();
				line.easeType = p.easeType.ToString();
				line.rotateAngle = p.rotateAngle.x + "," + p.rotateAngle.y + "," + p.rotateAngle.z;
				int length = p.nodes.ToArray().Length;
				line.nodes = new string[length];
				for(int j=0;j < length;j++){
					Vector3 v = p.nodes.ToArray()[j];
					line.nodes[j] = v.x + "," + v.y + "," + v.z;
				}
			}
			
		}
	}
	/**生成场景配置*/
	static public void createSceneLayout(string savingPath){
		createSceneLayout (savingPath,null,null);
	}

	//create building scene config json file
	static public void createBuildingLayout(string savingPath,GameObject root,LuaScriptMgr luaMgr){
		
		ArrayList exports = new ArrayList();
		
		GameObject objs = null;
		objs = GameObject.Find ("Objects");
		if (objs == null) {
			return;
		}

		
		//building配置
		Transform buildings = objs.transform;
		for (int i=0;i<buildings.childCount;i++)
		{
			GameObject o= buildings.GetChild(i).gameObject;
			//if (PrefabUtility.GetPrefabType(o)  == PrefabType.PrefabInstance ){
			//Debug.Log(o.name);
			//exports.Add(o);
			BundleLua [] luaScripts = o.GetComponentsInChildren<BundleLua>();
			BundleLua b = o.GetComponent<BundleLua>();
			if (b==null){
				continue;
			}
			exports.Add(o);
		}

		
		if (luaMgr == null) {
			luaMgr = new LuaScriptMgr ();
		}
		LuaState l = luaMgr.lua;
		
		//l.DoFile ("Assets/Lua/tool/GameObjectExport.lua");
		l.DoString(luaSource);
		//========================================================================================================
		//c# array to lua table
		LuaFunction f = l.GetFunction("addConfig");
		for (int i=0; i<exports.Count; i++) {
			GameObject o= exports[i] as GameObject;
			
			BundleLua bLua = o.GetComponent<BundleLua>();
			
			// calculate param
			if (bLua!=null && bLua.param!=null&&bLua.param.Length>0){
				string param = "";
				//recucively add lua param
				for(int k=0;k<bLua.param.Length;k++){
					param+=bLua.param[k];
					if(k!=bLua.param.Length-1){
						param+=";";
					}
				}

				Debug.Log ("-------------------------====================--------------------------"+param);
				
				//generate config code
				f.Call( AssetDatabase.GetAssetPath(o), 
				       o.transform.parent.name,
				       bLua==null?"":bLua.luaName,
				       o.transform.position.x-o.transform.localScale.x/2,
				       o.transform.position.x+","+o.transform.position.y+","+o.transform.position.z,
				       o.transform.rotation.eulerAngles.x+","+o.transform.rotation.eulerAngles.y+","+o.transform.rotation.eulerAngles.z,
				       o.transform.localScale.x+","+o.transform.localScale.y+","+o.transform.localScale.z,
				       param);
			}
		}
		//f.Release ();
		Debug.Log ("-------------------------====================--------------------------");
		//		if (root == null) {
		f = l.GetFunction ("save");
		f.Call ("Assets/Lua/game/export/" + savingPath + ".json");
		f.Release();
		if(luaMgr == null)
			luaMgr.Destroy ();
		
		
	}


	/**生成场景配置*/
	[MenuItem("Desmond/Export Single Scene Layout", false, 12)]
	static public void exportSceneLayout(){
		string path = EditorApplication.currentScene;
		int start = path.LastIndexOf("/")+1;
		int end = path.LastIndexOf(".");
		path = path.Substring(start,end-start);
		Debug.Log(path);
		createSceneLayout(path);
		Debug.Log ("-------------lua load finish-----------");
	}
	/**生成多个场景配置*/
	[MenuItem("Desmond/export runningScene Layout", false, 13)]
	static public void exportMultiSceneLayout(){
		//遍历所有游戏场景
		foreach(EditorBuildSettingsScene scene in EditorBuildSettings.scenes)
		{
			if(scene.enabled)
			{
				if(!scene.path.Contains("runningScene"))
					continue;
				
				//打开场景
				EditorApplication.OpenScene(scene.path);
				//Debug.Log(scene.path);
				int start = scene.path.LastIndexOf("/")+1;
				int end = scene.path.LastIndexOf(".");
				string path = scene.path.Substring(start,end-start);
				Debug.Log(path);
				createSceneLayout(path);
				
			}
		}
	}

	/**生成多个场景配置*/
	[MenuItem("Desmond/export building Layout", false, 14)]
	static public void exportBuildingSceneLayout(){
		createBuildingLayout("building_export",null,null);
	
	}

	

	/**生成场景配置*/
	[MenuItem("Desmond/test", false, 113)]
	static public void test(){
		//弹跳模块
		GameObject gMan = GameObject.Find ("Objects");
		if (gMan == null) {
			return;
		}
		
		Transform bouncings = gMan.transform.Find ("bouncing");
		for (int i=0;i<bouncings.childCount;i++)
		{
			GameObject o= bouncings.GetChild(i).gameObject;
			BundleLua bLua = o.GetComponent<BundleLua>();
			if (PrefabUtility.GetPrefabType(o)  == PrefabType.PrefabInstance && bLua!=null){
				UnityEngine.Object parentObject = EditorUtility.GetPrefabParent(o); 
				string path = AssetDatabase.GetAssetPath(parentObject);
				string str = AssetDatabase.GetAssetPath(o);
			}
			
		}
	}

	/**动态场景配置导出*/
	[MenuItem("Assets/single endless part export", false,1)]
	static public void singleEndlessLevelExport(){
		UnityEngine.Object[] selection = Selection.objects;
		string name;
		foreach (UnityEngine.Object s in selection)
		{
			if (s is GameObject)
			{
				string path = AssetDatabase.GetAssetPath(s);	
				GameObject obj = GameObject.Instantiate(AssetDatabase.LoadAssetAtPath (path, typeof(GameObject))) as GameObject;
				int start = path.LastIndexOf("/")+1;
				int end = path.LastIndexOf(".");
				path = path.Substring(start,end-start);
//				GameObject obj =  GameObject.Find(path);
				if(obj == null){
					Debug.Log("将关卡prefab拖入场景中");
					return;
				}
				createSceneLayout(path,obj,null);
				GameObject.DestroyImmediate(obj);
			}
		}
	}

	/**动态场景配置导出*/
	[MenuItem("Assets/multiple endless part export", false,2)]
	static public void multiEndlessLevelExport(){
		LuaScriptMgr luaMgr = new LuaScriptMgr();
		UnityEngine.Object[] selection = Selection.objects;
		string name;
		int index = 1;
		foreach (UnityEngine.Object s in selection)
		{
			if (s is GameObject)
			{
				string path = AssetDatabase.GetAssetPath(s);
				GameObject obj = GameObject.Instantiate(AssetDatabase.LoadAssetAtPath (path, typeof(GameObject))) as GameObject;
				int start = path.LastIndexOf("/")+1;
				int end = path.LastIndexOf(".");
				path = path.Substring(start,end-start);
				//GameObject obj =  GameObject.Find(path);
				if(obj == null){
					Debug.Log("将关卡prefab拖入场景中");
					return;
				}
				UpdateProgress(index++,selection.Length,path);

				try{
					Debug.Log("----------------start "+path);
					createSceneLayout(path,obj,luaMgr);
					Debug.Log("----------------finish "+path);
				}catch(System.Exception e){
					EditorUtility.ClearProgressBar ();
					Debug.LogError("parse " + path + " failed");
				}
				GameObject.DestroyImmediate(obj);
			}
		}
		EditorUtility.ClearProgressBar ();
		luaMgr.Destroy ();
	}

	static void UpdateProgress(int progress, int progressMax, string desc) {
		string title = "Processing...[" + progress + " - " + progressMax + "]";
		float value = (float)progress / (float)progressMax;
		EditorUtility.DisplayProgressBar(title, desc, value);
	}

	
	[MenuItem("Assets/sync prefab", false, 3)]
	static public void export(){
		UnityEngine.Object[] selection = Selection.objects;
		int index = 1;
		foreach (UnityEngine.Object s in selection) {
			if (s is GameObject) {
				string path = AssetDatabase.GetAssetPath(s);
				//UpdateProgress(index++,selection.Length,path);
				GameObject o  =GameObject.Instantiate(AssetDatabase.LoadAssetAtPath (path, typeof(GameObject))) as GameObject;
				Transform items = o.transform.Find("Objects/item");//GameObject.Find("item").transform;
				ArrayList lists = new ArrayList ();
				for (int i =0; i<items.childCount; i++) {
					lists.Add (items.GetChild (i).gameObject);
				}

				for (int i =0; i<lists.Count; i++) {
					GameObject obj = lists [i] as GameObject;
					string name = "Assets/Scenes/prefabs/items/" + obj.name + ".prefab";
					Debug.Log (name);
//					if(PrefabUtility.GetPrefabType(obj)  == PrefabType.PrefabInstance)
//					{
//						Debug.Log("is prefab");
//						UnityEngine.Object parentObject = EditorUtility.GetPrefabParent(obj); 
//						name = AssetDatabase.GetAssetPath(parentObject);
					//					}
					GameObject nObj =null;
					try{
						nObj = GameObject.Instantiate (AssetDatabase.LoadAssetAtPath (name, typeof(GameObject))) as GameObject;
					}catch(System.Exception e){
						nObj = identicalName(name);
						if (nObj == null)
							Debug.LogError (obj.name + ": no prefab founded");
					}

					nObj.transform.parent = obj.transform.parent;
					nObj.transform.position = obj.transform.position;
					nObj.transform.rotation = obj.transform.rotation;
					nObj.transform.localScale = obj.transform.localScale;
					nObj.name = obj.name;
				}

				for (int i =0; i<lists.Count; i++) {
					GameObject obj = lists [i] as GameObject;
					GameObject.DestroyImmediate (obj);
				}
//				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				lists = new ArrayList ();
				Transform monsters = o.transform.Find("Objects/monster");//GameObject.Find("monster");
				for (int i =0; i<monsters.childCount; i++) {
					lists.Add (monsters.GetChild (i).gameObject);
				}

				for (int i =0; i<lists.Count; i++) {
					GameObject obj = lists [i] as GameObject;
					string name = "Assets/Scenes/prefabs/monster/" + obj.name + ".prefab";
					Debug.Log (name);
//					if(PrefabUtility.GetPrefabType(obj)  == PrefabType.PrefabInstance)
//					{
//						UnityEngine.Object parentObject = EditorUtility.GetPrefabParent(obj); 
//						name = AssetDatabase.GetAssetPath(parentObject);
//					}
					GameObject nObj =null;
					try{
						nObj = GameObject.Instantiate (AssetDatabase.LoadAssetAtPath (name, typeof(GameObject))) as GameObject;
					}catch(System.Exception e){
						nObj = identicalName(name);
						if (nObj == null)
							Debug.LogError (obj.name + ": no prefab founded");
					}
					nObj.transform.parent = obj.transform.parent;
					nObj.transform.position = obj.transform.position;
					nObj.transform.rotation = obj.transform.rotation;
					nObj.transform.localScale = obj.transform.localScale;
					nObj.name = obj.name;
				}

				for (int i =0; i<lists.Count; i++) {
					GameObject obj = lists [i] as GameObject;
					GameObject.DestroyImmediate (obj);
				}

				PrefabUtility.CreatePrefab(path,o, ReplacePrefabOptions.ReplaceNameBased);
				GameObject.DestroyImmediate(o);
			}
		}

	}

	/**动态场景配置导出*/
	[MenuItem("Assets/game camera export", false,4)]
	static public void gameCameraExport(){
		UnityEngine.Object[] selection = Selection.objects;
		string name;
		foreach (UnityEngine.Object s in selection)
		{
			if (s is GameObject)
			{
				string path = AssetDatabase.GetAssetPath(s);	
				GameObject obj = GameObject.Instantiate(AssetDatabase.LoadAssetAtPath (path, typeof(GameObject))) as GameObject;
				GameCameraSetting setting = obj.GetComponent<GameCameraSetting>();
				if(setting == null){
					break;
				}

				GameCameraClass data = new GameCameraClass();
				data.defaultFixedDistance = setting.defaultFixedDistance.x+","+setting.defaultFixedDistance.y+","+setting.defaultFixedDistance.z;
				data.withinYAxis = setting.withinYAxis;
				data.yAxisMovingTime = setting.yAxisMovingTime;
				data.zAxisCrossStage1 = setting.zAxisCrossStage1;
				data.zAxisCrossStage2 = setting.zAxisCrossStage2;
				data.zAxis16TailingTime = setting.zAxis16TailingTime;
				data.zAxis16BreakingSpeed = setting.zAxis16BreakingSpeed.x+","+setting.zAxis16BreakingSpeed.y+","+setting.zAxis16BreakingSpeed.z;
				data.zAxis16CatchingUpTime = setting.zAxis16CatchingUpTime;  
				
				data.zAxis32TailingTime = setting.zAxis32TailingTime;
				data.zAxis32BreakingSpeed = setting.zAxis32BreakingSpeed.x+","+setting.zAxis32BreakingSpeed.y+","+setting.zAxis32BreakingSpeed.z;
				data.zAxis32CatchingUpTime = setting.zAxis32CatchingUpTime;
				
				data.zAxis_16TailingTime = setting.zAxis_16TailingTime;
				data.zAxis_16BreakingSpeed = setting.zAxis_16BreakingSpeed.x+","+setting.zAxis_16BreakingSpeed.y+","+setting.zAxis_16BreakingSpeed.z;
				data.zAxis_16CatchingUpTime = setting.zAxis_16CatchingUpTime;
				
				data.zAxis_32TailingTime = setting.zAxis_32TailingTime;
				data.zAxis_32BreakingSpeed = setting.zAxis_32BreakingSpeed.x+","+setting.zAxis_32BreakingSpeed.y+","+setting.zAxis_32BreakingSpeed.z;
				data.zAxis_32CatchingUpTime = setting.zAxis_32CatchingUpTime;


				StringBuilder sb = new StringBuilder();
				JsonWriter writer = new JsonWriter(sb);
				JsonMapper.ToJson(data,writer);//data.ToJson();
				string str = sb.ToString ();
				UTF8Encoding utf8 = new UTF8Encoding(true);
				Byte[] encodedBytes = utf8.GetBytes (str);
				File.WriteAllBytes ("Assets/Lua/game/export/camera.json", encodedBytes);

				GameObject.DestroyImmediate(obj);
			}
		}


	}
	/**配置导出*/
	[MenuItem("Assets/coin group export", false,4)]
	static public void coinGroupExport(){
		UnityEngine.Object[] selection = Selection.objects;
		string name;
		foreach (UnityEngine.Object s in selection)
		{
			if (s is GameObject)
			{
				string path = AssetDatabase.GetAssetPath(s);
				GameObject o  =GameObject.Instantiate(AssetDatabase.LoadAssetAtPath (path, typeof(GameObject))) as GameObject;
				BundleLua [] luaScripts = o.GetComponentsInChildren<BundleLua>();
				EliminateGroupClass s_data = new EliminateGroupClass();
				s_data.items = new EliminateGroupClass.EliminateItem[luaScripts.Length];
				int index = 0;
				foreach(BundleLua lua in luaScripts)
				{
					if (lua.luaName != "EliminateItemGroup")
					{
						GameObject obj = lua.gameObject;
						EliminateGroupClass.EliminateItem item = new EliminateGroupClass.EliminateItem();
						s_data.items[index] = item;
						item.localPosition = obj.transform.localPosition.x+","+obj.transform.localPosition.y+","+obj.transform.localPosition.z;
						item.localRotation = obj.transform.localRotation.eulerAngles.x+","+obj.transform.localRotation.eulerAngles.y+","+obj.transform.localRotation.eulerAngles.z;
						item.localScale = obj.transform.localScale.x+","+obj.transform.localScale.y+","+obj.transform.localScale.z;
						item.material_id = lua.param[0];
						index++;
					}
				}
				StringBuilder sb = new StringBuilder();
				JsonWriter writer = new JsonWriter(sb);
				JsonMapper.ToJson(s_data,writer);//data.ToJson();
				string str = sb.ToString ();
				UTF8Encoding utf8 = new UTF8Encoding(true);
				Byte[] encodedBytes = utf8.GetBytes (str);
				File.WriteAllBytes ("Assets/Lua/game/export/coinGroup.json", encodedBytes);
				
				GameObject.DestroyImmediate(o);
			}
		}
		
		
	}

    /** reconstruct prefab name till prefab exists*/
	static private GameObject identicalName(string name){
		try{
			
			string sufix = name.Substring (name.Length -".prefab".Length- 1, 1);
			string prefix = name.Substring(0,name.Length -".prefab".Length- 1);
			int value = int.Parse (sufix);
			while(value>0){
				value -- ;
				try{
					GameObject nObj = GameObject.Instantiate (AssetDatabase.LoadAssetAtPath (prefix+value.ToString()+".prefab", typeof(GameObject))) as GameObject;
					if (nObj!=null)
						return nObj;
				}catch(System.Exception e){
					
				}

			}

			prefix = name.Substring(0,name.Length -".prefab".Length- 2);
			try{
				GameObject nObj = GameObject.Instantiate (AssetDatabase.LoadAssetAtPath (prefix+".prefab", typeof(GameObject))) as GameObject;
				if (nObj!=null)
					return nObj;
			}catch(System.Exception e){
				
			}

			prefix = name.Substring(0,name.Length -".prefab".Length- 3);
			try{
				GameObject nObj = GameObject.Instantiate (AssetDatabase.LoadAssetAtPath (prefix+".prefab", typeof(GameObject))) as GameObject;
				if (nObj!=null)
					return nObj;
			}catch(System.Exception e){
				
			}


		}catch(System.Exception e){

		}
		return null;
	}

	[MenuItem("Assets/set light layer", false, 4)]
	static public void setLightLayer (){
		UnityEngine.Object[] selection = Selection.objects;
		string name;
		foreach (UnityEngine.Object s in selection) {
			if (s is GameObject)
			{
				(s as GameObject).layer = LayerMask.NameToLayer("Landscape_light");
			}
		}

	}
	static public string luaSource = @"--[[
		author:Desmond
		跑酷动态场景配置导出工具
		]]

		require 'cjson'
		luaTable = {}
		--设置布局等参数
		function addConfig( path, parentName,luaName,left_x,position,rotation,scale,param,itweenPath)
		    local item = {}
		    --item['path'] = path
		    item['parentName'] = parentName
		    item['luaName'] = luaName
		    item['left_x'] = left_x
			item['position'] = position
			item['rotation'] = rotation
			item['scale'] = scale
		    if param ~= nil then
				item['param'] = lua_string_split(param,';')
		    else
		        item['param'] = ''
		    end

			if itweenPath ~= nil and itweenPath~= '' then
				if item['param'] == '' then
					item['param'] = {}
				end
                local split = lua_string_split(itweenPath,';')
				if #split == 1 then
					split[1] = itweenPath
				end
				item['param']['itween'] = split
			end
		    table.insert(luaTable,item)
		end

		--保存文件
		function file_save(filename, data)
		    local file
		    if filename == nil then
		        file = io.stdout
		    else
		        local err
		        file, err = io.open(filename, 'wb')
		        if file == nil then
		        end
		    end
		    file:write(data)
		    if filename ~= nil then
		        file:close()
		    end
		end

		--字符串分割
		function lua_string_split(str, split_char)
		    local sub_str_tab = {};
		    while (true) do
		        local pos = string.find(str, split_char);
		        if (not pos) then
		            sub_str_tab[#sub_str_tab + 1] = str;
		            break;
		        end
		        local sub_str = string.sub(str, 1, pos - 1);
		        sub_str_tab[#sub_str_tab + 1] = sub_str;
		        str = string.sub(str, pos + 1, #str);
		    end

		    return sub_str_tab;
		end

		--保存文件
		function save(name)
			file_save(name, cjson.encode(luaTable))
		end

		--保存无尽模式随机地块
		function save_endless_part(name)
			local path = 'Assets/Lua/game/export/endless_set.json'
			local file, err = io.open(path, 'rb')
		    if file == nil then --空文件
                local t = {}
                t[tostring(name)] = luaTable
    	    	local str = cjson.encode(t)
                print(tostring(str))
		    	file_save(path,str)
		    	return
		    end
		    
		    local obj = cjson.decode(file_load(path))
		    obj[tostring(name)] = luaTable
		    file_save(path,cjson.encode(obj))
		end

		--读文件
		function file_load(filename)
		    local file
		    if filename == nil then
		        file = io.stdin
		    else
		        local err
		        file, err = io.open(filename, 'rb')
		        if file == nil then

		        end
		    end
		    local data = file:read('*a')

		    if filename ~= nil then
		        file:close()
		    end

		    if data == nil then
		        error('Failed to read'  .. filename)
		    end

		    return data
		end

     ";
	
}

public class Rectangle {
	// 分别表示最上下左右上的坐标  
	public float left;  
	public float right;  
	public float bottom;  
	public float top;  
	
	public Rectangle(float left, float right, float bottom, float top) {  
		if (left >= right || top <= bottom) {  
			return;  
		}  
		this.left = left;  
		this.right = right;  
		this.top = top;  
		this.bottom = bottom;  
	}  
}  






