using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CustomLight : MonoBehaviour
{
    public Light mainLight;
    public Light characterLight;

    void Update()
    {
        if (mainLight != null)
        {
            SetMainLight();
        }
        if (characterLight != null)
        {
            SetCharacterLight();
        }
    }

    void SetCharacterLight()
    {
        Shader.SetGlobalColor("_SLightColor", characterLight.color);

        Vector3 forward = Vector3.back;
        Vector3 direction = characterLight.transform.rotation * forward;

        Shader.SetGlobalVector("_SLightDir", direction);

        Shader.SetGlobalFloat("_SLightIntensity", characterLight.intensity);
    }

    void SetMainLight()
    {
        Shader.SetGlobalColor("_MLightColor", mainLight.color);

        Vector3 forward = Vector3.back;
        Vector3 direction = mainLight.transform.rotation * forward;

        Shader.SetGlobalVector("_MLightDir", direction);

        Shader.SetGlobalFloat("_MLightIntensity", mainLight.intensity);

    }
}
