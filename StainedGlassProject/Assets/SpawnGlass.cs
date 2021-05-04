using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnGlass : MonoBehaviour
{

    public GameObject glassPrefab;
    public GameObject lightPrefab;
    public List<Material> glassColors;
    public int spawnCount = 100;
    public int numOfLights = 3;
    public float xSpawnRange = 5.0f, ySpawnRange = 1.0f, zSpawnRange = 5.0f;
    public float scaleRange = 3.0f;

    private ShaderUpdate sdrUpd;
    // Start is called before the first frame update
    void Start()
    {
        sdrUpd = GetComponent<ShaderUpdate>();
        for(int i = 0; i<spawnCount; i++)
        {

            GameObject obj = Instantiate(glassPrefab);
            obj.transform.position = new Vector3(Random.Range(-xSpawnRange, xSpawnRange), Random.Range(0.0f, ySpawnRange), Random.Range(-zSpawnRange, zSpawnRange));
            obj.transform.localScale = new Vector3(Random.Range(0.5f, scaleRange), Random.Range(0.5f, scaleRange), Random.Range(0.5f, scaleRange));
            sdrUpd.glass[i] = obj;
            int colorIndex = Random.Range(0, glassColors.Count);
            obj.GetComponent<Renderer>().material = glassColors[colorIndex];
            sdrUpd.glassMat[i] = glassColors[colorIndex];
        }

        for(int i = 0; i<numOfLights; i++)
        {
            GameObject obj = Instantiate(lightPrefab);
            obj.transform.position = new Vector3(Random.Range(-xSpawnRange, xSpawnRange), Random.Range(0.0f, ySpawnRange), Random.Range(-zSpawnRange, zSpawnRange));

        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
