using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Artillery : MonoBehaviour
{
    public Bullet Bullet;
    public float speed;
    public GameObject Target;
    public GameObject Gun;
    public float FireRate;
    public GameObject Firepoint;
    public GameObject Mount;
    // Start is called before the first frame update
    void Start()
    {
        AimAtTarget();
        Fire();
    }

    // Update is called once per frame
    void Update()
    {
       // Fire();
    }

    void AimAtTarget()
    {
        if (Target == null) return;

        var directionVector = Target.transform.position - Mount.transform.position;
        var rotation = Quaternion.LookRotation(directionVector);
        Mount.transform.rotation = rotation;
    }

    void Fire()
    {
        if (Target == null) return;

        var rotationSpeed = 5.0f;
        var distance = Vector3.Distance(Target.transform.position, Firepoint.transform.position);
        var directionVector = Target.transform.position - transform.position;

        var currentAngle = transform.rotation.eulerAngles.y;
      
        var gravity = Physics.gravity.magnitude;
        var angle = Mathf.Atan(Mathf.Sqrt(speed) + Mathf.Sqrt(Mathf.Pow(speed, 4) - gravity * (gravity * distance * distance)) / (gravity * distance));
        var fireAngle = angle * Mathf.Rad2Deg;

        var newAngle = Mathf.LerpAngle(currentAngle, fireAngle, Time.deltaTime * rotationSpeed);
        Gun.transform.localRotation = Quaternion.Euler(Gun.transform.rotation.x + newAngle , Gun.transform.rotation.y, Gun.transform.rotation.z);

        var bullet = Instantiate(Bullet.gameObject, Firepoint.transform.position, Quaternion.identity);
        var rigidbody = bullet.GetComponent<Rigidbody>();
        rigidbody.velocity = directionVector.normalized * speed;
    }
}
