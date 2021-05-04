using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PassAnimationData : MonoBehaviour
{

    public Vector4[] keyframes;

    public Vector3 currentPos;

    private float timer;
    private float timePerTransition;
    // Start is called before the first frame update
    void Start()
    {
        GetComponent<Renderer>().sharedMaterial.SetVectorArray("_AnimationKeyframes", keyframes);
        GetComponent<Renderer>().sharedMaterial.SetFloat("_NumOfKeyframes", keyframes.Length);

        timePerTransition = GetComponent<Renderer>().sharedMaterial.GetFloat("_TimePerTransition");
        timer = 0.0f;
    }

    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;
        GetComponent<Renderer>().sharedMaterial.SetFloat("_CurrentTime", timer);

        int currentFrame = (int)(timer / timePerTransition) % keyframes.Length;
        float interp = ((timer / timePerTransition) % keyframes.Length) - currentFrame;


        if (currentFrame + 1 == keyframes.Length)
            currentPos = new Vector4(transform.position.x, transform.position.y, transform.position.z, 0.0f) + keyframes[currentFrame] + ((keyframes[0] - keyframes[currentFrame]) * interp);
        else
            currentPos = new Vector4(transform.position.x, transform.position.y, transform.position.z, 0.0f) + keyframes[currentFrame] + ((keyframes[currentFrame + 1] - keyframes[currentFrame]) * interp);
    }
}
