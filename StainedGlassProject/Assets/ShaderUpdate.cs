using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ShaderUpdate : MonoBehaviour
{

    public GameObject cube;

    public Material mat;
    public Material glassMat;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        mat.SetVector("_GlassLocation", cube.transform.position);
        mat.SetVector("_GlassScale", cube.transform.localScale);
        mat.SetVector("_GlassTint", glassMat.GetColor("_Color"));
    }
}
