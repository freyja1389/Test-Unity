using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shooting : MonoBehaviour
{
    private Animator animator;
    [SerializeField]
    private ParticleSystem explosionEffects;
    [SerializeField]
    private ParticleSystem mountDustEffects;
    [SerializeField]
    private ParticleSystem barrelDustEffects;
    // Start is called before the first frame update
    void Start()
    {
        animator = gameObject.GetComponentInChildren<Animator>();
        StartCoroutine(Shoot());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    IEnumerator  Shoot()
    {
        animator.SetTrigger("Shooting");
        explosionEffects.Play();
        barrelDustEffects.Play(); 
        // yield return new WaitForSeconds(0.05f);
        mountDustEffects.Play();

        yield return new WaitForSeconds(4.5f);
        StartCoroutine(Shoot());
    }
}