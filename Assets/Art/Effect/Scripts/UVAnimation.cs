using UnityEngine;
using System.Collections;

public class UVAnimation : MonoBehaviour {

    public float USpeed = 0;
    public float VSpeed = 0;
    public float WSpeed = 0;
	public float visibleDistance = 1000;

    MeshFilter meshFilter = null;
    Mesh mesh = null;
    Vector2 centerUV = new Vector2(0.5F, 0.5F);
	Vector2[] uvs = null;
	float sqrVisibleDistance;

	// Use this for initialization
	void Start () {
		sqrVisibleDistance = visibleDistance * visibleDistance;
        if (WSpeed != 0)
        {
            meshFilter = GetComponent<MeshFilter>();
            mesh = meshFilter.mesh;
            uvs = mesh.uv;
        }
        //
        TextureTileAnimation texAnim = GetComponent<TextureTileAnimation>();
        if (texAnim != null)
        {
            centerUV.x /= texAnim.XTile;
            centerUV.y /= texAnim.YTile;
        }
	}

    Vector2 m_offset = new Vector2();

	// Update is called once per frame
	void Update () {
        /*
		if(( Camera.mainCamera.transform.position-transform.position).sqrMagnitude > sqrVisibleDistance)
		{
			return;
		}
        */
		//
        if (USpeed != 0 || VSpeed != 0)
        {
            m_offset.x += USpeed * Time.deltaTime;
            if (m_offset.x > 1)
            {
                m_offset.x -= 1;
            }
            else if (m_offset.x < -1)
            {
                m_offset.x += 1;
            }
            m_offset.y += VSpeed * Time.deltaTime;
            if (m_offset.y > 1)
            {
                m_offset.y -= 1;
            }
            else if (m_offset.y < -1)
            {
                m_offset.y += 1;
            }
            transform.GetComponent<Renderer>().material.mainTextureOffset = m_offset;
        }
        //
		
        if (WSpeed != 0)
        {
            float angle = WSpeed * Mathf.Deg2Rad * Time.deltaTime;
			float angleSin = Mathf.Sin(angle);
			float angleCos = Mathf.Cos(angle);
			//
            for (int i = 0; i < uvs.Length; i++)
            {
                Vector2 diff = uvs[i] - centerUV;
                uvs[i].x = diff.x * angleCos - diff.y * angleSin;
                uvs[i].y = diff.x * angleSin + diff.y * angleCos;
                uvs[i] += centerUV;
            }
            meshFilter.mesh.uv = uvs;
			
        }
		
	}
}
