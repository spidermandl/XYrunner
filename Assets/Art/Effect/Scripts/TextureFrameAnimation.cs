using UnityEngine;
using System.Collections;

public class TextureFrameAnimation : MonoBehaviour {

    public Texture[] textures = null;
    public float interval = 0.05F;
    public bool loop = true;

    float m_timer = 0;
    int index = 0;
	// Use this for initialization
	void Start () {
        index = 0;
        transform.GetComponent<Renderer>().material.mainTexture = textures[index];
        m_timer = interval;
	}
	
	// Update is called once per frame
	void Update () {
        m_timer -= Time.deltaTime;
        //
        if (m_timer < 0)
        {
            if (index < (textures.Length - 1))
            {
                index++;
            }
            else
            {
                if (loop)
                {
                    index = 0;
                }
            }
            transform.GetComponent<Renderer>().material.mainTexture = textures[index];
            m_timer = interval;
        }
	}
}
