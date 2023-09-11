using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Artillery : MonoBehaviour
{
    [SerializeField]
    private Bullet BulletPrefab;
    [SerializeField]
    private float speed;
    [SerializeField]
    private GameObject Target;
    [SerializeField]
    private GameObject Gun;
    [SerializeField]
    private float FireRate;
    [SerializeField]
    private Transform Firepoint;
    [SerializeField]
    private GameObject Mount;
    [SerializeField]
    private float MaxfireDistance;
    [SerializeField]
    private float MinFireDistance;
    [SerializeField]
    private Shooting ShootEffectsController;

    #region Unity Messages
    void Start()
    {
        StartCoroutine(ShootPeriodic());
    }

    void Update()
    {
        if (FireDistanceCheck())
        {
            AimAtTarget();
        }
    }
    #endregion

    private void Shoot()
    {
        if (FireDistanceCheck())
        {
            Fire();
        }
    }

    private IEnumerator ShootPeriodic()
    {
        yield return new WaitForSeconds(1);
        Shoot();
        StartCoroutine(ShootPeriodic());
    }


    private bool FireDistanceCheck()
    {
        var distance = Vector3.Distance(Target.transform.position, Firepoint.transform.position);
        if (distance <= MaxfireDistance & distance >= MinFireDistance)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    private void AimAtTarget()
    {
        if (Target == null) return;

        var targetPredictedPosition = GetPredictedPosition();
        var directionVector = targetPredictedPosition - Mount.transform.position;
        var rotation = Quaternion.LookRotation(directionVector).eulerAngles;
        Mount.transform.rotation = Quaternion.Euler(Mount.transform.rotation.x, rotation.y, Mount.transform.rotation.z);
    }

    private Vector3 GetPredictedPosition()
    {
        var distance = Vector3.Distance(Target.transform.position, Firepoint.position);
        return Target.transform.position + (Target.GetComponent<NavMeshAgent>().velocity * distance / speed);

    }

    private void Fire()
    {
        if (Target == null) return;

        var targetPredictedPosition = GetPredictedPosition();
        var relativePosition = targetPredictedPosition - Firepoint.position;

        float distance = relativePosition.magnitude;
        float heightDifference = relativePosition.y;

        float gravity = Physics.gravity.magnitude;

        float speedSquared = Mathf.Pow(speed, 2);

        float underSquareRoot = Mathf.Pow(speedSquared, 2) - Mathf.Pow(gravity, 2) * Mathf.Pow(distance, 2);

        if (underSquareRoot < 0)
        {
            return; //too far (cant be return square root)
        }

        float angle = Mathf.Atan(((speedSquared) - Mathf.Sqrt(underSquareRoot)) / (gravity * distance));
        float fireAngle = angle * Mathf.Rad2Deg;
        fireAngle += Mathf.Atan2(heightDifference, distance) * Mathf.Rad2Deg;

        Gun.transform.localRotation = Quaternion.Euler(-fireAngle, Gun.transform.rotation.y, Gun.transform.rotation.z);

        ShootEffectsController.StartPlayingShootingEffects();
        var bullet = Instantiate(BulletPrefab.gameObject, Firepoint.transform.position, Quaternion.identity);
        var rigidbody = bullet.GetComponent<Rigidbody>();
        rigidbody.velocity = Firepoint.forward * speed;
    }
}
