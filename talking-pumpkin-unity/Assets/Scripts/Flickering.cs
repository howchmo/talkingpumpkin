using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Flickering : MonoBehaviour
{
    public float FlickerSpeed = 0.1f;
    private float timer = 0.0f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Time.time >= timer)
        {
            Light flame = GetComponent<Light>();
            flame.intensity = Random.Range(0.5f, 2.5f);
            timer = Time.time + FlickerSpeed;
        }
    }
}
