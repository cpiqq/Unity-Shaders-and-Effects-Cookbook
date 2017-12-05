using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProcedureTexture : MonoBehaviour
{
    private Material curMaterial;
    private Texture2D genTexture2D;
    private int widthHeight = 512;
	void Start ()
	{
	    curMaterial = GetComponent<MeshRenderer>().material;
	    genTexture2D = Procedure();
        curMaterial.SetTexture("_MainTex",genTexture2D);
	}

    private Texture2D Procedure()
    {
        genTexture2D = new Texture2D(widthHeight, widthHeight);
        Vector2 pixelCenter = new Vector2(widthHeight,widthHeight) * 0.5f;
        for (int i = 0; i < genTexture2D.width; i++)
        {
            for (int j = 0; j < genTexture2D.height; j++)
            {
                Vector2 curPixel = new Vector2(i,j);
                float pixelDistance = Vector2.Distance(curPixel, pixelCenter);
                float distanceRatio = pixelDistance / (widthHeight * 0.5f);
                //离中心越远越白
                distanceRatio = Mathf.Clamp(distanceRatio, 0, 1);
                //离中心越远越黑
                distanceRatio = 1 - distanceRatio;
                Color curColor = new Color(distanceRatio,distanceRatio,distanceRatio,1);
                genTexture2D.SetPixel(i,j,curColor);
            }
        }
        genTexture2D.Apply();
        return genTexture2D;
    }
	
}
