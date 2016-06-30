using UnityEngine;
using System.Collections;

public class bouncingSetting : MonoBehaviour {

	public double m_TargetZ = 0; //落点Z轴
	public bool m_isReplaceAction = true;//是否取代默认动作
	public double m_Direction = 0f; //角色朝向
	public double m_ActionSpeed = 1.0f; //角色动作播放速度
	public double m_ActionDelayTime = 0.0f; //弹簧动画的延迟时间
}
