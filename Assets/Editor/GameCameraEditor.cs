using UnityEngine;
using System.Collections;
using UnityEditor;

[CustomEditor(typeof(GameCameraSetting))]
[CanEditMultipleObjects]
public class GameCameraEditor : Editor {

	public GameCameraSetting _target;

	void OnEnable(){
		_target = (GameCameraSetting)target;
		//Debug.LogError(_target == null?"null":"full");

		if(!_target.initialized){
			_target.initialized = true;
		}
	}

	public override void OnInspectorGUI(){

		EditorGUILayout.BeginHorizontal();
		_target.defaultFixedDistance = EditorGUILayout.Vector3Field("fixed_dis_aganist_player ", _target.defaultFixedDistance);
		EditorGUILayout.EndHorizontal();

		EditorGUILayout.BeginHorizontal();
		_target.withinYAxis = EditorGUILayout.DoubleField("switch_Y_dis",_target.withinYAxis);
		_target.yAxisMovingTime = EditorGUILayout.DoubleField("Y_Moving_Time",_target.yAxisMovingTime);
		EditorGUILayout.EndHorizontal();

		EditorGUILayout.BeginHorizontal();
		EditorGUILayout.Separator ();
		EditorGUILayout.EndHorizontal();

		EditorGUILayout.BeginHorizontal();
		_target.zAxisCrossStage1 = EditorGUILayout.DoubleField("z_stage1",_target.zAxisCrossStage1);
		_target.zAxisCrossStage2 = EditorGUILayout.DoubleField("z_stage2",_target.zAxisCrossStage2);
		EditorGUILayout.EndHorizontal();
        
		EditorGUILayout.BeginHorizontal();
		EditorGUILayout.Separator ();
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis16TailingTime = EditorGUILayout.DoubleField("z16_tailing_time",_target.zAxis16TailingTime);
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis16BreakingSpeed = EditorGUILayout.Vector3Field("z16_breaking_speed",_target.zAxis16BreakingSpeed);
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis16CatchingUpTime = EditorGUILayout.DoubleField("z16_catchup_time",_target.zAxis16CatchingUpTime);
		EditorGUILayout.EndHorizontal(); 

		EditorGUILayout.BeginHorizontal();
		EditorGUILayout.Separator ();
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis32TailingTime = EditorGUILayout.DoubleField("z32_tailing_time",_target.zAxis32TailingTime);
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis32BreakingSpeed = EditorGUILayout.Vector3Field("z32_breaking_speed",_target.zAxis32BreakingSpeed);
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis32CatchingUpTime = EditorGUILayout.DoubleField("z32_catchup_time",_target.zAxis32CatchingUpTime);
		EditorGUILayout.EndHorizontal(); 

		EditorGUILayout.BeginHorizontal();
		EditorGUILayout.Separator ();
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis_16TailingTime = EditorGUILayout.DoubleField("z_16_tailing_time",_target.zAxis_16TailingTime);
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis_16BreakingSpeed = EditorGUILayout.Vector3Field("z_16_breaking_speed",_target.zAxis_16BreakingSpeed);
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis_16CatchingUpTime = EditorGUILayout.DoubleField("z_16_catchup_time",_target.zAxis_16CatchingUpTime);
		EditorGUILayout.EndHorizontal(); 

		EditorGUILayout.BeginHorizontal();
		EditorGUILayout.Separator ();
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis_32TailingTime = EditorGUILayout.DoubleField("z_32_tailing_time",_target.zAxis_32TailingTime);
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis_32BreakingSpeed = EditorGUILayout.Vector3Field("z_32_breaking_speed",_target.zAxis_32BreakingSpeed);
		EditorGUILayout.EndHorizontal();
		EditorGUILayout.BeginHorizontal();
		_target.zAxis_32CatchingUpTime = EditorGUILayout.DoubleField("z_32_catchup_time",_target.zAxis_32CatchingUpTime);
		EditorGUILayout.EndHorizontal(); 


	}
	void OnSceneGUI(){
	}

}
