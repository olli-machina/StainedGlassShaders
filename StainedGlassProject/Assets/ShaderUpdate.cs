using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ShaderUpdate : MonoBehaviour
{

    public GameObject[] glass;

    public Material[] mat;
    public Material[] glassMat;

    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < glass.Length; i++)
        {
            if (glass[i])
            {
                glass[i].GetComponent<Renderer>().sharedMaterial.SetVector("_CurrentLocation", Vector4.zero);
                
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        List<Vector4> locationArray = new List<Vector4>(100);
        List<Vector4> scaleArray = new List<Vector4>(100);
        List<Vector4> colorArray = new List<Vector4>(100);

        


        for (int i = 0; i<glass.Length; i++)
        {
            if (glass[i])
            {
                if(glass[i].GetComponent<PassAnimationData>())
                    locationArray.Add(glass[i].GetComponent<PassAnimationData>().currentPos);
                else
                    locationArray.Add(glass[i].transform.position);
                scaleArray.Add(glass[i].transform.localScale);
                colorArray.Add(glassMat[i].GetColor("_Color"));
            }
        }

        for (int i = locationArray.Count; i < 100; i++)
        {
            locationArray.Add(new Vector4(0, 0, 0, 0));
            scaleArray.Add(new Vector4(0, 0, 0, 0));
            colorArray.Add(new Vector4(0, 0, 0, 0));
        }

        for (int i = 0; i<mat.Length; i++)
        {
            mat[i].SetVectorArray("_GlassLocation", locationArray);
            mat[i].SetVectorArray("_GlassScale", scaleArray);
            mat[i].SetVectorArray("_GlassTint", colorArray);
            mat[i].SetFloat("_NumOfGlass", glass.Length);
        }

        
    }
}
