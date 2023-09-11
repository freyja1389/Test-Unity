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

    #region Unity Messages
    void Start()
    {
        animator = gameObject.GetComponentInChildren<Animator>();
    }
    #endregion

    public void StartPlayingShootingEffects()
    {
        animator.SetTrigger("Shooting");
        explosionEffects.Play();
        barrelDustEffects.Play();
        mountDustEffects.Play();
    }
}
