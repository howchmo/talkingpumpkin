using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioReactiveFlickering : MonoBehaviour
{
    public string[] AudioInputs;
    private AudioSource AudioSource;
    public float Average;
    public float[] Samples = new float[64];
    public float FlickerSpeed = 0.1f;
    private float timer = 0.0f;
    public int MinimumFrequency;
    public int MaximumFrequency;

    // Start is called before the first frame update
    void Start()
    {
        AudioSource = GetComponent<AudioSource>();
        SetAudioClipToMicrophone();
        AudioSource.Play();
    }

    private void SetAudioClipToMicrophone()
    {
        AudioInputs = Microphone.devices;
        Microphone.GetDeviceCaps(AudioInputs[0], out MinimumFrequency, out MaximumFrequency);
        AudioSource.clip = Microphone.Start(AudioInputs[0], true, 1, MinimumFrequency);
        AudioSource.loop = true;
        while (!(Microphone.GetPosition(null) > 0) ){ }
    }

    // Update is called once per frame
    void Update()
    {
        GetSpectrumAudioSource();
        ComputeAverage();
    }

    void ComputeAverage()
    {
        float sum = 0.0f;
        for( int i=0; i<64; i++)
        {
            sum += Samples[i];
        }
        Average = (sum/64.0f)*1000.0f;
        if (Time.time >= timer)
        {
            Light flame = GetComponent<Light>();
            flame.intensity = Average;
            timer = Time.time + FlickerSpeed;
        }
    }

    void GetSpectrumAudioSource()
    {
        AudioSource.GetSpectrumData(Samples, 0, FFTWindow.Blackman);
    }
}
