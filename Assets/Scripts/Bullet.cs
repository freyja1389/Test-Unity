using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    [SerializeField]
    private Explosion explosion;

    private void OnCollisionEnter(Collision collision)
    {
        Debug.Log("Collide!");
        explosion.transform.SetParent(null);
        explosion.GetComponent<ParticleSystem>().Play();
        explosion.DestroyEffects(); 
        Destroy(gameObject);
    }

}
