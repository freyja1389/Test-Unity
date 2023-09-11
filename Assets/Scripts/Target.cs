using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Target : MonoBehaviour
{
    [SerializeField]
    private Transform plane;
    private NavMeshAgent agent;
    private Vector3 targetPosition;
    private Bounds bounds;

    #region Unity Messages
    void Start()
    {
        agent = GetComponent<NavMeshAgent>();

        bounds = plane.GetComponent<MeshCollider>().bounds;

        targetPosition = GetTargetPosition();
        agent.destination = targetPosition;
        StartCoroutine(Move());
    }
    #endregion

    private IEnumerator Move()
    {
        while (true)
        {
            if (agent.remainingDistance < 1)
            {
                targetPosition = GetTargetPosition();
                agent.destination = targetPosition;
            }
            yield return null;
        }
    }

    private Vector3 GetTargetPosition()
    {
        float randomX = Random.Range(bounds.min.x, bounds.max.x);
        float randomZ = Random.Range(bounds.min.z, bounds.max.z);

        return new Vector3(randomX, transform.position.y, randomZ);
    }
}
