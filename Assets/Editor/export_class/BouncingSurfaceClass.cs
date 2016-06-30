using UnityEngine;
using System.Collections;

public class BouncingSurfaceClass : ExportBassClass {

	public string step_localPosition { get; set; }
	public string step_localScale { get; set; }

	public string bouncing_model_name { get; set; }
	public string bouncing_model_localPosition { get; set; }
	public string bouncing_model_localRotation { get; set;}
	public string bouncing_model_localScale { get; set; }

	public string target_localPosition { get; set; }

	public AnimPath[] bouncing_path { get; set;}

	public double m_TargetZ; //落点Z轴
	public double m_isReplaceAction;//是否取代默认动作 0 true   1 false
	public double m_Direction; //角色朝向
	public double m_ActionSpeed; //角色动作播放速度
	public double m_ActionDelayTime; //弹簧动画的延迟时间
}
