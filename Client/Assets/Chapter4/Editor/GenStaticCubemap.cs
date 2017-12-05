using UnityEngine;
using System.Collections;
using UnityEditor;

public class GenStaticCubemap : ScriptableWizard
{
    public Transform renderPositon;
    public Cubemap cubemap;


    private string helpstring;

    [MenuItem("CookBook/Render Cubemap")]
    static void RenderCubemap()
    {
        ScriptableWizard.DisplayWizard("Render Cubemap", typeof(GenStaticCubemap), "Render!");
    }
    void OnWizardUpdate()
    {
        helpstring = "select transform to render from and cubemap to render into";
        if (renderPositon != null && cubemap != null)
        {
            isValid = true;//当isvalid == true 就回调用OnWizardCreate
        }
        else
        {
            isValid = false;
        }
    }

    void OnWizardCreate()
    {
         //create a temp camera for rendering
        GameObject go = new GameObject("CubeCam",typeof(Camera));

        //place it onto our render position
        go.transform.position = renderPositon.position;
        go.transform.rotation = Quaternion.identity;

        //render the cubemap
        go.GetComponent<Camera>().RenderToCubemap(cubemap);

        //destroy the temp camers
        DestroyImmediate(go);
    }
}
