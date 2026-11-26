using System;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode] 
public class CustomWater : MonoBehaviour
{
    public enum WaterMode
    {
        Simple = 0,
        Reflective = 1,
    };

    public WaterMode waterMode = WaterMode.Reflective;
    public int textureSize = 256;
    public float clipPlaneOffset = 0.07f;
    public LayerMask reflectLayers = -1;

    public bool SoftEdge = false;
    [Range(0.1f, 4f)]
    public float SoftFactor = 0.5f;

    public bool Specular = false;

    private Dictionary<Camera, Camera> m_ReflectionCameras = new Dictionary<Camera, Camera>(); // Camera -> Camera table
    private RenderTexture m_ReflectionTexture;
    private WaterMode m_HardwareWaterSupport = WaterMode.Reflective;
    private int m_OldReflectionTextureSize;
    private static bool s_InsideWater;

    // This is called when it's known that the object will be rendered by some
    // camera. We render reflections / refractions and do other updates here.
    // Because the script executes in edit mode, reflections for the scene view
    // camera will just work!
    public void OnWillRenderObject()
    {
        if (!enabled || !GetComponent<Renderer>() || !GetComponent<Renderer>().sharedMaterial ||
            !GetComponent<Renderer>().enabled)
        {
            return;
        }

        Camera cam = Camera.current;
        if (!cam)
        {
            return;
        }

        if (s_InsideWater)
        {
            return;
        }
        s_InsideWater = true;

        Material material = GetComponentInChildren<Renderer>().sharedMaterial;

        if (SoftEdge)
        {
            cam.depthTextureMode = DepthTextureMode.Depth;
            material.EnableKeyword("ENABLE_SOFTEDGE");
            material.SetFloat("_EdgeFactor", SoftFactor);
            material.SetOverrideTag("RenderType", "Transparent");
            material.renderQueue = 3000;
            material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
            material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
            material.SetInt("_ZWrite", 0);
        }
        else
        {
            cam.depthTextureMode = DepthTextureMode.None;
            material.DisableKeyword("ENABLE_SOFTEDGE");
            material.SetOverrideTag("RenderType", "Opaque");
            material.renderQueue = 2000;
            material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
            material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
            material.SetInt("_ZWrite", 1);
        }

        if (Specular) material.EnableKeyword("ENABLE_SPECULAR");
        else material.DisableKeyword("ENABLE_SPECULAR");

        m_HardwareWaterSupport = FindHardwareWaterSupport(material);
        WaterMode mode = GetWaterMode();

        Camera reflectionCamera;
        CreateWaterObjects(cam, out reflectionCamera);

        // find out the reflection plane: position and normal in world space
        Vector3 pos = transform.position;
        Vector3 normal = new Vector3(0f,1f,0f);

        UpdateCameraModes(cam, reflectionCamera);

        if (mode == WaterMode.Simple)
        {
            if (m_ReflectionTexture)
            {
                DestroyImmediate(m_ReflectionTexture);
                m_ReflectionTexture = null;
            }
            foreach (var kvp in m_ReflectionCameras)
            {
                DestroyImmediate((kvp.Value).gameObject);
            }
            m_ReflectionCameras.Clear();
        }
        // Render reflection if needed
        if (mode >= WaterMode.Reflective)
        {
            // Reflect camera around reflection plane
            float d = -Vector3.Dot(normal, pos) - clipPlaneOffset;
            Vector4 reflectionPlane = new Vector4(normal.x, normal.y, normal.z, d);

            Matrix4x4 reflection = Matrix4x4.zero;
            CalculateReflectionMatrix(ref reflection, reflectionPlane);
            Vector3 oldpos = cam.transform.position;
            Vector3 newpos = reflection.MultiplyPoint(oldpos);
            reflectionCamera.worldToCameraMatrix = cam.worldToCameraMatrix * reflection;

            // Setup oblique projection matrix so that near plane is our reflection
            // plane. This way we clip everything below/above it for free.
            Vector4 clipPlane = CameraSpacePlane(reflectionCamera, pos, normal, 1.0f);
            reflectionCamera.projectionMatrix = cam.CalculateObliqueMatrix(clipPlane);

            reflectionCamera.cullingMask = ~(1 << 4) & reflectLayers.value; // never render water layer
            reflectionCamera.targetTexture = m_ReflectionTexture;
            bool oldCulling = GL.invertCulling;
            GL.invertCulling = !oldCulling;
            reflectionCamera.transform.position = newpos;
            Vector3 euler = cam.transform.eulerAngles;
            reflectionCamera.transform.eulerAngles = new Vector3(-euler.x, euler.y, euler.z);
            reflectionCamera.Render();
            reflectionCamera.transform.position = oldpos;
            GL.invertCulling = oldCulling;
            GetComponent<Renderer>().sharedMaterial.SetTexture("_ReflectionTex", m_ReflectionTexture);
        }

        // Setup shader keywords based on water mode
        switch (mode)
        {
            case WaterMode.Simple:
                material.DisableKeyword("ENABLE_REFLECTIVE");
                break;
            case WaterMode.Reflective:
                material.EnableKeyword("ENABLE_REFLECTIVE");
                break;
        }
        s_InsideWater = false;
    }

    // Cleanup all the objects we possibly have created
    void OnDisable()
    {
        if (m_ReflectionTexture)
        {
            DestroyImmediate(m_ReflectionTexture);
            m_ReflectionTexture = null;
        }
        foreach (var kvp in m_ReflectionCameras)
        {
            DestroyImmediate((kvp.Value).gameObject);
        }
        m_ReflectionCameras.Clear();
    }

    void UpdateCameraModes(Camera src, Camera dest)
    {
        if (dest == null)
        {
            return;
        }
        // set water camera to clear the same way as current camera
        dest.clearFlags = src.clearFlags;
        dest.backgroundColor = src.backgroundColor;
        if (src.clearFlags == CameraClearFlags.Skybox)
        {
            Skybox sky = src.GetComponent<Skybox>();
            Skybox mysky = dest.GetComponent<Skybox>();
            if (!sky || !sky.material)
            {
                mysky.enabled = false;
            }
            else
            {
                mysky.enabled = true;
                mysky.material = sky.material;
            }
        }
        // update other values to match current camera.
        // even if we are supplying custom camera&projection matrices,
        // some of values are used elsewhere (e.g. skybox uses far plane)
        dest.farClipPlane = src.farClipPlane;
        dest.nearClipPlane = src.nearClipPlane;
        dest.orthographic = src.orthographic;
        dest.fieldOfView = src.fieldOfView;
        dest.aspect = src.aspect;
        dest.orthographicSize = src.orthographicSize;
    }

    // On-demand create any objects we need for water
    void CreateWaterObjects(Camera currentCamera, out Camera reflectionCamera)
    {
        WaterMode mode = GetWaterMode();

        reflectionCamera = null;

        if (mode >= WaterMode.Reflective)
        {
            // Reflection render texture
            if (!m_ReflectionTexture || m_OldReflectionTextureSize != textureSize)
            {
                if (m_ReflectionTexture)
                {
                    DestroyImmediate(m_ReflectionTexture);
                }
                m_ReflectionTexture = new RenderTexture(textureSize, textureSize, 16);
                m_ReflectionTexture.name = "__WaterReflection" + GetInstanceID();
                m_ReflectionTexture.isPowerOfTwo = true;
                m_ReflectionTexture.hideFlags = HideFlags.DontSave;
                m_OldReflectionTextureSize = textureSize;
            }

            // Camera for reflection
            m_ReflectionCameras.TryGetValue(currentCamera, out reflectionCamera);
            if (!reflectionCamera) // catch both not-in-dictionary and in-dictionary-but-deleted-GO
            {
                GameObject go = new GameObject("Water Refl Camera id" + GetInstanceID() + " for " + currentCamera.GetInstanceID(), typeof(Camera), typeof(Skybox));
                reflectionCamera = go.GetComponent<Camera>();
                reflectionCamera.enabled = false;
                reflectionCamera.transform.position = transform.position;
                reflectionCamera.transform.rotation = transform.rotation;
                reflectionCamera.gameObject.AddComponent<FlareLayer>();
                go.hideFlags = HideFlags.HideAndDontSave;
                m_ReflectionCameras[currentCamera] = reflectionCamera;
            }
        }
    }

    WaterMode GetWaterMode()
    {
        if (m_HardwareWaterSupport < waterMode)
        {
            return m_HardwareWaterSupport;
        }
        return waterMode;
    }

    WaterMode FindHardwareWaterSupport(Material mat)
    {
        if (!SystemInfo.supportsRenderTextures || !GetComponent<Renderer>())
        {
            return WaterMode.Simple;
        }

        if (!mat)
        {
            return WaterMode.Simple;
        }

        if (waterMode == WaterMode.Reflective)
        {
            return WaterMode.Reflective;
        }

        return WaterMode.Simple;
    }

    // Given position/normal of the plane, calculates plane in camera space.
    Vector4 CameraSpacePlane(Camera cam, Vector3 pos, Vector3 normal, float sideSign)
    {
        Vector3 offsetPos = pos + normal * clipPlaneOffset;
        Matrix4x4 m = cam.worldToCameraMatrix;
        Vector3 cpos = m.MultiplyPoint(offsetPos);
        Vector3 cnormal = m.MultiplyVector(normal).normalized * sideSign;
        return new Vector4(cnormal.x, cnormal.y, cnormal.z, -Vector3.Dot(cpos, cnormal));
    }

    // Calculates reflection matrix around the given plane
    static void CalculateReflectionMatrix(ref Matrix4x4 reflectionMat, Vector4 plane)
    {
        reflectionMat.m00 = (1F - 2F * plane[0] * plane[0]);
        reflectionMat.m01 = (-2F * plane[0] * plane[1]);
        reflectionMat.m02 = (-2F * plane[0] * plane[2]);
        reflectionMat.m03 = (-2F * plane[3] * plane[0]);

        reflectionMat.m10 = (-2F * plane[1] * plane[0]);
        reflectionMat.m11 = (1F - 2F * plane[1] * plane[1]);
        reflectionMat.m12 = (-2F * plane[1] * plane[2]);
        reflectionMat.m13 = (-2F * plane[3] * plane[1]);

        reflectionMat.m20 = (-2F * plane[2] * plane[0]);
        reflectionMat.m21 = (-2F * plane[2] * plane[1]);
        reflectionMat.m22 = (1F - 2F * plane[2] * plane[2]);
        reflectionMat.m23 = (-2F * plane[3] * plane[2]);

        reflectionMat.m30 = 0F;
        reflectionMat.m31 = 0F;
        reflectionMat.m32 = 0F;
        reflectionMat.m33 = 1F;
    }
}
