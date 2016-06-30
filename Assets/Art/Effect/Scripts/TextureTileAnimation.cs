using UnityEngine;
using System.Collections;

public class TextureTileAnimation : MonoBehaviour
{

    public int XTile = 1;
    public int YTile = 1;
    public float interval = 0.05F;
    public bool loop = true;
    public KeyCode key = KeyCode.F;

    float m_timer = 0;
    int index = 0;
    int tileCount = 1;
    Material material;
    // Use this for initialization
    void Start()
    {
        tileCount = XTile * YTile;
        //
        Mesh mesh = GetComponent<MeshFilter>().mesh;
        Vector2[] uvs = mesh.uv;
        for (int i = 0; i < uvs.Length; i++)
        {
            uvs[i].x /= XTile;
            uvs[i].y /= YTile;
        }
        mesh.uv = uvs;
    }

    void OnEnable()
    {
        index = 0;
        m_timer = interval;
    }

    // Update is called once per frame
    Vector2 tileOffset = new Vector2();
    void Update()
    {
        if (GetComponent<Renderer>().enabled == false)
        {
            if (Input.GetKeyDown(key))
            {
                index = 0;
                GetComponent<Renderer>().enabled = true;
            }
        }
        else
        {
            m_timer -= Time.deltaTime;
            //
            if (m_timer < 0)
            {
                while (m_timer < 0)
                {
                    if (index < (tileCount - 1))
                    {
                        index++;
                    }
                    else
                    {
                        if (loop)
                        {
                            index = 0;
                        }
                        else
                        {
                            GetComponent<Renderer>().enabled = false;
                        }
                    }
                    m_timer += interval;
                }
                int x = index % XTile;
                int y = (YTile - 1 - (index / XTile));
                tileOffset.x = x / (float)XTile;
                tileOffset.y = y / (float)YTile;
                transform.GetComponent<Renderer>().material.mainTextureOffset = tileOffset;
                //m_timer = interval;
            }
        }
    }
}
