using UnityEngine;

public sealed class TangentSpaceVisualizer : MonoBehaviour
{
	public float offset = 0.01f;
	public float scale = 0.1f;

	private void OnDrawGizmos()
    {
		MeshFilter filter = GetComponent<MeshFilter>();
		if (filter) {
			Mesh mesh = filter.sharedMesh;
			if (mesh) {
				ShowTangentSpace(mesh);
			}
		}
	}

	private void ShowTangentSpace(Mesh mesh)
	{
		Vector3[] vertices = mesh.vertices;
		Vector3[] normals = mesh.normals;
		Vector4[] tangents = mesh.tangents;
		for (int i = 0; i < vertices.Length; i++) {
			ShowTangentSpace(
				this.transform.TransformPoint(vertices[i]),
				this.transform.TransformDirection(normals[i]),
				this.transform.TransformDirection(tangents[i]),
				Vector3.Cross(normals[i], tangents[i]) * tangents[i].w);
		}
	}

	private void ShowTangentSpace(
		Vector3 vertex, Vector3 normal, Vector3 tangent, Vector3 binormal)
	{
		vertex += normal * this.offset;
		Gizmos.color = Color.green;
		Gizmos.DrawLine(vertex, vertex + normal * this.scale);
		Gizmos.color = Color.red;
		Gizmos.DrawLine(vertex, vertex + tangent * this.scale);
		Gizmos.color = Color.blue;
		Gizmos.DrawLine(vertex, vertex + binormal * this.scale);
	}
}