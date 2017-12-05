using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SpriteSheet : MonoBehaviour
{
    public float speed;
    private Material _material;
	// Use this for initialization
	void Start () {
        _material = transform.GetComponent<Image>().material;

	    _material.SetFloat("_xScaleCoefficient", (float)1/9);


    }

    // Update is called once per frame
    void Update () {
		
	}


    private float _stage;
    private float a;
	void FixedUpdate()
	{

        _stage = (Time.time * speed) % 9;
	    _stage = Mathf.Floor(_stage);

        _material.SetFloat("_Stage", _stage);

    }
}
