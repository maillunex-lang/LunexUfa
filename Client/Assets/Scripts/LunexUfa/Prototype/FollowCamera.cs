using UnityEngine;

namespace LunexUfa.Prototype
{
    /// <summary>
    /// Simplified third-person follow from Darklord CameraFollow defaults
    /// (distance 5, height 10, pitch 50) without Titan/DOTween deps.
    /// </summary>
    public class FollowCamera : MonoBehaviour
    {
        public Transform target;
        public float distance = 5f;
        public float height = 10f;
        public float rotationAngle = 50f;

        void LateUpdate()
        {
            if (target == null)
                return;

            Vector3 look = target.position + Vector3.up;
            Quaternion yaw = Quaternion.Euler(0f, rotationAngle, 0f);
            Vector3 offset = yaw * new Vector3(0f, height, -distance);
            transform.position = look + offset;
            transform.LookAt(look);
        }
    }
}
