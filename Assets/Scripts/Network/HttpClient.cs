/**
 * author Desmond
 * */
using UnityEngine;
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Collections;
using System.Collections.Generic;
using SimpleFramework.Manager;
using SimpleFramework;

using System.Text;

public class HttpClient 
{
	public static string NAME = "HttpClient";

	/// <summary>
	/// 发送post消息
	/// </summary>
	public IEnumerator post(String api,String jsonString){
		var encoding = new System.Text.UTF8Encoding();


		String word = jsonString;
		//		String fg = "|" ;
		String []strArray = word.Split ('|');
		String head = "";
		String body = "";
		int i = 1;
		foreach (String a in strArray)
		{
			if (i == 1)
			{
				body = a ; 
			}
			if(i == 2)
			{
				head = a;
			}
			i++;
		}
		//var postHeader = new Hashtable();
		Dictionary<string,string> headers = new Dictionary<string,string> ();
		headers ["Content-Type"] = "text/json";
		byte[] b_body = encoding.GetBytes (body);
		headers ["Content-Length"] = b_body.Length.ToString();//body.Length.ToString();
		Debug.Log ("body: "+body+"head: "+ head+" Content-Length: "+ b_body.Length.ToString());
		//"xy0000020" + ":" + "c4882b09"

		string credentials = Convert.ToBase64String (encoding.GetBytes (head));
		//Convert.ToBase64String(Encoding.ASCII.GetBytes(head));
		headers["Authorization"] = "Basic " + credentials;

		//WWW www = new WWW(AppConst.SocketAddress + ":" + AppConst.SocketPort+api, encoding.GetBytes(body),headers);
		WWW www = new WWW(AppConst.SocketAddress + api, b_body,headers);

		yield return www;
		if (www.error != null) 
		{
			Debug.Log("error is :"+ www.error);
			NetworkManager.AddEvent(www.error);
		} 
		if (www.text != null)
		{
			Debug.Log("request result :" + www.text);
			NetworkManager.AddEvent(www.text);
		}
	}

	/// <summary>
	/// 发送get消息
	/// </summary>
	public IEnumerator get(String api,String param){

		//		var encoding = new System.Text.UTF8Encoding();
		//		//var postHeader = new Hashtable();
		//		Dictionary<string,string> headers = new Dictionary<string,string> ();
		//		headers ["Content-Type"] = "text/json";
		//		headers ["Content-Length"] = param.Length.ToString();

		//WWW www = new WWW(AppConst.SocketAddress+":"+AppConst.SocketPort+api+"?"+param);
		WWW www = new WWW(AppConst.SocketAddress+api+"?"+param);
		//		WWW www = new WWW(AppConst.SocketAddress + ":" + AppConst.SocketPort+api+"?"+param, encoding.GetBytes(param),headers);
		yield return www;

		if (www.error != null) 
		{
			Debug.Log("error is :"+ www.error);
		} 
		else
		{
			Debug.Log("request result :" + www.text);
			NetworkManager.AddEvent(www.text);
		}
	}

	//	IEnumerator ReceiveProc2(){
	//		
	//		String username = Username;
	//		String token = Token;
	//		string credentials = Convert.ToBase64String(Encoding.ASCII.GetBytes(username + ":" + token));
	//
	//		string tmp = null;
	//		var encoding = new System.Text.UTF8Encoding();
	//	
	//				
	//		Dictionary<string,string> headers = new Dictionary<string,string> ();
	//		headers["Content-Type"] = "text/json";
	//		headers["Content-Length"] = tmp.Length.ToString();
	//		headers["Authorization"] = "Basic " + credentials;
	//		
	//		Debug.Log("ReceiveProc2 post begin : " + tmp);
	//		WWW request = new WWW(g_requestUrl, encoding.GetBytes(tmp),headers);
	//		//				while(!request.isDone)
	//		//				{
	//		//					Thread.Sleep(1);
	//		//				}
	//		
	//		yield return request;
	//		if (request.error != null) 
	//		{
	//			Debug.Log ("request error: " + request.error);
	//			yield break ;
	//		}
	//		
	//		Debug.Log("ReceiveProc2 post end : " + request.text);
	//		string content = request.text;
	//
	//	}
}