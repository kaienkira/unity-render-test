using UnityEngine;

public sealed class PlanarReflection : MonoBehaviour
{
    public Camera mainCamera = null;
    public Camera reflectCamera = null;
    public RenderTexture rt = null;

    public void Awake()
    {
        this.mainCamera = Camera.main;
        GameObject reflectCameraNode = new GameObject("ReflectCamera");
        this.reflectCamera = reflectCameraNode.AddComponent<Camera>();
        this.reflectCamera.enabled = false;
        this.rt = new RenderTexture(Screen.width, Screen.height, 24);
    }

    public void OnWillRenderObject()
    {
        RenderReflection();
    }

    private void RenderReflection()
    {
        this.reflectCamera.CopyFrom(this.mainCamera);

        Vector3 forward = this.transform.InverseTransformDirection(
            this.mainCamera.transform.forward);
        Vector3 up = this.transform.InverseTransformDirection(
            this.mainCamera.transform.up);
        Vector3 pos = this.transform.InverseTransformPoint(
            this.mainCamera.transform.position);

        forward.y *= -1f;
        up.y *= -1f;
        pos.y *= -1f;

        forward = this.transform.TransformDirection(forward);
        up = this.transform.TransformDirection(up);
        pos = this.transform.TransformPoint(pos);

        this.reflectCamera.transform.position = pos;
        this.reflectCamera.transform.LookAt(pos + forward, up);

        this.reflectCamera.targetTexture = this.rt;
        this.gameObject.GetComponent<MeshRenderer>().material.mainTexture = this.rt;
        this.reflectCamera.Render();
    }
}
