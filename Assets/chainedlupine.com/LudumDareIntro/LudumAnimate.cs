using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

public class LudumAnimate : MonoBehaviour {

    public AudioClip LudumClip;

    private AudioSource LudumSrc;

	// Use this for initialization
	void Start () {
        LudumSrc = gameObject.AddComponent<AudioSource>();
        LudumSrc.playOnAwake = false;
        LudumSrc.clip = LudumClip;
        LudumSrc.spatialBlend = 0.0f;
        LudumSrc.volume = 1.0f;

        Cursor.visible = false;

        StartCoroutine(AnimAndAdvance());
	}
	
    IEnumerator AnimAndAdvance()
    {
        yield return new WaitForSeconds(2.0f);

        // play our sound
        LudumSrc.Play();

        yield return new WaitForSeconds(3.0f);

        // now just move to next scene
        Cursor.visible = true;
        int nextSceneIdx = SceneManager.GetActiveScene().buildIndex + 1;

        if (nextSceneIdx > SceneManager.sceneCount - 1)
            nextSceneIdx = SceneManager.sceneCount - 1;

        SceneManager.LoadScene(nextSceneIdx);
    }
}
