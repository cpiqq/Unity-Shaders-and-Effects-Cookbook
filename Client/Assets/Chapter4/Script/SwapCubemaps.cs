using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SwapCubemaps : MonoBehaviour
{
    public Cubemap cubea;
    public Cubemap cubeb;

    public Transform posa;
    public Transform posb;

    private Material _curMat;

    private Cubemap _curCube;

    void Awake()
    {
        _curMat = GetComponent<Renderer>().material;
    }
    void OnDrawGizmos()
    {
        Gizmos.color = Color.green;
        if (posa)
        {
            Gizmos.DrawWireSphere(posa.position, 0.5f);
        }
        if (posb)
        {
            Gizmos.DrawWireSphere(posb.position, 0.5f);
        }
    }

    private Cubemap CheckProbeDistance()
    {
        float dista = Vector3.Distance(transform.position, posa.position);
        float distb = Vector3.Distance(transform.position, posb.position);
        if (dista < distb)
        {
            return cubea;
        }else if (distb < dista)
        {
            return cubeb;
        }
        return cubea;
    }

    void Update()
    {
        if (_curMat)
        {
            _curCube = CheckProbeDistance();
            _curMat.SetTexture("_CubeMap",_curCube);
        }
    }
}
