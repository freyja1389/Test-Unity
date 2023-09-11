using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Explosion : MonoBehaviour
{
    private IEnumerator EffectsDestroing()
    {
        yield return new WaitForSeconds(1);
        Destroy(gameObject);
    }
    public void DestroyEffects()
    {
        StartCoroutine(EffectsDestroing());
    }
}
