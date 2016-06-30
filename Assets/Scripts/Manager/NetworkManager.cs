using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

namespace SimpleFramework.Manager {
    public class NetworkManager : View {
        private SocketClient socket;
		private HttpClient http;
        static Queue<KeyValuePair<int, ByteBuffer>> sEvents = new Queue<KeyValuePair<int, ByteBuffer>>();
		static Queue<String> hEvents = new Queue<string>();

        SocketClient SocketClient {
            get {
                if (socket == null)
                    socket = new SocketClient();
                return socket;                    
            }
        }

		HttpClient httpClient{
			get { 
				if (http == null)
					http = new HttpClient();
				return http;
			}
		}

        void Awake() {
            Init();
        }

        void Init() {
            SocketClient.OnRegister();
        }

        public void OnInit() {
            CallMethod("Start");
        }

        public void Unload() {
            CallMethod("Unload");
        }

        /// <summary>
        /// 执行Lua方法
        /// </summary>
        public object[] CallMethod(string func, params object[] args) {
            return Util.CallMethod("Network", func, args);
        }

        ///------------------------------------------------------------------------------------
        public static void AddEvent(int _event, ByteBuffer data) {
            sEvents.Enqueue(new KeyValuePair<int, ByteBuffer>(_event, data));
        }

		public static void AddEvent(String data) {
			hEvents.Enqueue (data);
		}

        /// <summary>
        /// 交给Command，这里不想关心发给谁。
        /// </summary>
        void Update() {
            if (sEvents.Count > 0) {
                while (sEvents.Count > 0) {
                    KeyValuePair<int, ByteBuffer> _event = sEvents.Dequeue();
                    facade.SendMessageCommand(NotiConst.DISPATCH_MESSAGE, _event);
                }
            }

			if (hEvents.Count > 0) {
				while (hEvents.Count > 0) {
					String _event = hEvents.Dequeue();
					facade.SendMessageCommand(NotiConst.DISPATCH_H_MESSAGE, _event);
				}
			}
        }

        /// <summary>
        /// 发送链接请求
        /// </summary>
        public void SendConnect() {
            SocketClient.SendConnect();
        }

        /// <summary>
        /// 发送SOCKET消息
        /// </summary>
        public void SendMessage(ByteBuffer buffer) {
            SocketClient.SendMessage(buffer);
        }

		/**
		 * Desmond
		 * send post message
		 * */
		public void SendPost(String api,String jsonString){
			StartCoroutine (httpClient.post (api,jsonString));
		}

		/**
		 * Desmond
		 * send get message
		 * */
		public void SendGet(String api,String param){
			StartCoroutine (httpClient.get (api,param));
		}

        /// <summary>
        /// 析构函数
        /// </summary>
        new void OnDestroy() {
            SocketClient.OnRemove();
            Debug.Log("~NetworkManager was destroy");
        }
    }
}