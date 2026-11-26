/**
* @file     : ISkillCell.cs
* @brief    : 
* @details  : 相机拉升功能
* @author   : 
* @date     : 2014-11-28 9:31
*/

using UnityEngine;
using System.Collections;
using Titan;
using System.Collections.Generic;

public class CameraHeight : MonoBehaviour
{
    protected Transform m_transform;
    private Transform m_target = null;
    private CameraFollow m_cameraFollow;

    //最大拉升距离         
    public float m_OffsetLen = 15f;
    //拉升速度
    public float m_Speed = 0.4f;

    //private float m_fFollowHeight = 5f;
    private float m_MinLen = 7f;

    private float m_fHeight = 7f;
    private float m_MaxLen = 15f;


    private bool m_bActive = false;
    private Vector3 m_LastPos;

    private bool m_bMove = false;

    private EventMgr m_eventMgr;

    ////距离跟随目标的距离        
    //private float m_distance;

    ////和目标的偏移角度
    //private float m_rotationAngle;

    GameObject mainCameraObj = null;

    void Awake()
    {
        m_eventMgr = CoreEntry.gEventMgr;
        RegisterEvent();
    }

    // Use this for initialization
    void Start()
    {
        mainCameraObj = GameObject.FindGameObjectWithTag("MainCamera");
        m_transform = mainCameraObj.transform;
    }


    void ResetCarmeraFollow()
    {
        CameraFollow follow = mainCameraObj.GetComponent<CameraFollow>();
        //m_distance = follow.m_distance;
        //m_rotationAngle = follow.m_rotationAngle;
        m_target = follow.m_target;
        //m_fFollowHeight = follow.m_height;
        m_LastPos = m_target.position;

        m_MinLen = Vector3.Distance(m_transform.position, m_target.position);
        m_fHeight = m_MinLen;

        m_MaxLen = m_fHeight + m_OffsetLen;

    }

    public Transform UpdateCamera()
    {
        float targetHeight = m_target.position.y;
        float fDist = targetHeight - m_LastPos.y;
        float fDir = 1f;
        if (fDist == 0)
        {
            return m_transform;
        }

        if (fDist < 0)
        {
            fDir = -1f;
        }


        float fDistance = fDir * m_Speed * 0.1f;//Time.deltaTime;

        m_fHeight += fDistance;

        if (m_fHeight > m_MaxLen)
        {
            m_fHeight = m_MaxLen;
        }

        if (m_fHeight < m_MinLen)
        {
            m_fHeight = m_MinLen;
        }

        Quaternion currentRotation = Quaternion.Euler(m_transform.rotation.eulerAngles);

        // Set the position of the camera on the x-z plane to:	    
        m_transform.position = m_target.position;
        m_transform.position += currentRotation * Vector3.forward * m_fHeight * -1;
        m_LastPos = m_target.position;

        return m_transform;
    }

    void Update()
    {

        if (m_bActive)
        {
            float fDist = Vector3.Distance(m_LastPos, m_target.position);
            if (fDist > 0.1f)
            {
                m_bMove = true;
            }

        }

        if (!m_bActive || !m_bMove)
        {
            return;
        }

        UpdateCamera();
    }


    // Update is called once per frame
    void LateUpdate()
    {

    }

    void OnDestroy()
    {
        RemoveEvent();
    }

    //注册技能释放事件
    void RegisterEvent()
    {
        m_eventMgr.AddListener(GameEvent.GE_CAMERA_EVENT_HEIGHT_ACTIVE, EventFunction);
        m_eventMgr.AddListener(GameEvent.GE_CAMERA_EVENT_HEIGHT_DISABLE, EventFunction);

        m_eventMgr.AddListener(GameEvent.GE_PLAYER_MOVE_BEGIN, EventFunction);
        m_eventMgr.AddListener(GameEvent.GE_PLAYER_MOVE_STOP, EventFunction);
        m_eventMgr.AddListener(GameEvent.GE_PLAYER_MOVE_END, EventFunction);

    }


    void RemoveEvent()
    {
        m_eventMgr.RemoveListener(GameEvent.GE_CAMERA_EVENT_HEIGHT_ACTIVE, EventFunction);
        m_eventMgr.RemoveListener(GameEvent.GE_CAMERA_EVENT_HEIGHT_DISABLE, EventFunction);

        m_eventMgr.RemoveListener(GameEvent.GE_PLAYER_MOVE_BEGIN, EventFunction);
        m_eventMgr.RemoveListener(GameEvent.GE_PLAYER_MOVE_STOP, EventFunction);
        m_eventMgr.RemoveListener(GameEvent.GE_PLAYER_MOVE_END, EventFunction);

    }

    public void EventFunction(GameEvent ge, EventParameter parameter)
    {
        switch (ge)
        {
            case GameEvent.GE_CAMERA_EVENT_HEIGHT_ACTIVE:
                {
                    if (!m_bActive)
                    {
                        ResetCarmeraFollow();
                    }

                    m_bActive = true;
                }
                break;

            case GameEvent.GE_CAMERA_EVENT_HEIGHT_DISABLE:
                {
                    m_bActive = false;
                }
                break;


            case GameEvent.GE_PLAYER_MOVE_BEGIN:
                {
                    m_bMove = true;

                }
                break;

            case GameEvent.GE_PLAYER_MOVE_STOP:
            case GameEvent.GE_PLAYER_MOVE_END:
                {
                    m_bMove = false;

                }
                break;



            default:
                break;
        }
    }

    //计算时间
    private bool StartMove_test_ex(float time, float distance, CActorObject attacker)
    {
        float mDuration = time;
        Vector3 mStartPos = Vector3.zero;
        Vector3 dir;

        if (null != attacker)
        {
            dir = (attacker.transform.position - mStartPos).normalized;
        }
        else
        {
            dir = Vector3.forward;
        }

        if (attacker == null)
            return false;


        int TempValue = 0;
        int RandomValue = 0;

        int num = 0;
        if (TempValue != 0 || RandomValue != 0)
        {
            bool isCount = TempValue % 2 == 0;
            num = TempValue * (isCount ? -1 : 1);
            num -= RandomValue;
        }

        AnimationCurveData m_animationCurveData = null;
        string strClipName = "";
        CurveData curveData = m_animationCurveData.GetCurveData(strClipName);
        if (curveData == null)
        {
            LogMgr.LogError("can't find {0} curve data", strClipName);
            return false;
        }

        List<float> listValueX = new List<float>();
        List<float> listValueY = new List<float>();
        List<float> listValueZ = new List<float>();
        List<float> listTime = new List<float>();

        List<Keyframe> listKeyFrameX = new List<Keyframe>();
        List<Keyframe> listKeyFrameY = new List<Keyframe>();
        List<Keyframe> listKeyFrameZ = new List<Keyframe>();


        Vector3 pos1 = new Vector3(listValueX[0], listValueY[0], listValueZ[0]);
        Vector3 pos2 = new Vector3(listValueX[listValueX.Count - 1],
            listValueY[listValueX.Count - 1], listValueZ[listValueX.Count - 1]);

        //缩放系数        
        float distanceA = Vector3.Distance(pos1, pos2);
        float distanceB = Vector3.Distance(pos1, pos2);


        //是否有卡帧系数
        if (curveData.keyIndex > 0 & curveData.keyIndex < listValueX.Count - 1)
        {
            //卡帧前面的位移
            Vector3 pos3 = new Vector3(listValueX[curveData.keyIndex], listValueY[0], listValueZ[curveData.keyIndex]);
            float distanceC = Vector3.Distance(pos1, pos3);

            //LogMgr.UnityLog("distanceC=" + distanceC);

            if (distanceA > distanceC)
            {
                distanceA -= distanceC;
                distanceB -= distanceC;

            }
        }

        float fscale = distanceA / distanceB;
        if (Mathf.Approximately(distanceB, 0) || fscale <= 0)
        {
            fscale = 1f;
        }

        //LogMgr.UnityLog("distanceA=" + distanceA + ", distanceB=" + distanceB + ", fscale=" + fscale);

        //使用点的旋转            
        List<Vector3> listCurvePos = new List<Vector3>();
        for (int i = 0; i < 1; ++i)
        {
            Vector3 pos = new Vector3(listValueX[i], listValueY[i], listValueZ[i]);

            //缩放
            if (curveData.keyIndex > 0 && curveData.keyIndex < listValueX.Count - 1)
            {
                //后面的缩放
                if (i > curveData.keyIndex)
                {
                    pos.Scale(new Vector3(fscale, 1, fscale));
                    pos += new Vector3(listValueX[curveData.keyIndex], pos.y, listValueZ[curveData.keyIndex]);
                }
            }
            else
            {
                pos.Scale(new Vector3(fscale, 1f, fscale));
            }

            //自身旋转

            listCurvePos.Add(pos);
        }

        //计算玩家方向
        Vector3 maxPos = mStartPos - dir * distance;
        Vector3 mTargetPos = CoreEntry.gBaseTool.GetLineReachablePos(mStartPos, maxPos);
        Vector3 mDeltaPos = (mTargetPos - mStartPos) / mDuration;
        float mStartTime = Time.time;

        if (mStartTime > 0)
            return false;

        EndMove_test_ex(0, 0, null);

        return true;
    }

    private bool EndMove_test_ex(float time, float distance, CActorObject attacker)
    {
        //临时计算时间
        float mDuration1 = time;
        Vector3 mStartPos1 = Vector3.zero;
        Vector3 dir;

        if (null != attacker)
        {
            dir = (attacker.transform.position - mStartPos1).normalized;
        }
        else
        {
            dir = Vector3.forward;
        }

        //计算玩家方向
        Vector3 maxPos = mStartPos1 - dir * distance;
        Vector3 mTargetPos = CoreEntry.gBaseTool.GetLineReachablePos(mStartPos1, maxPos);
        Vector3 mDeltaPos = (mTargetPos - mStartPos1) / mDuration1;
        float mStartTime = Time.time;

        if (mStartTime > 0)
            return false;

        return true;
    }















}
