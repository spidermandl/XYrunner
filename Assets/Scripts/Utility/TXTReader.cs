using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Collections;

namespace SimpleFramework {
	public class TXTReader{

		public static string[][] ReadTxt(string txtName)
		{   
			if (AppConst.LuaEncode == true){
				
				byte[] bs = File.ReadAllBytes(txtName);
				bs = Util.DecryptBytesFromBytes_Aes(bs);
				return Readbytes(bs);
			}
			
			string[] teStrTxt = File.ReadAllLines(txtName);
			return ReadArray (teStrTxt);
		}
		
		public static string[][] Readbytes(byte[] text)
		{
			MemoryStream ms = new MemoryStream (text);
			StreamReader sr = new StreamReader (ms);
			ArrayList array = new ArrayList();
			while(sr.Peek()>0){
				array.Add(sr.ReadLine());
			}
			string[] teStrTxt = new string[array.Count];
			for (int i=0; i<teStrTxt.Length; i++) {
				teStrTxt[i] = (string)array[i];
			}
			return ReadArray (teStrTxt);
		}
		
		
		public static string[][] ReadArray(string[] teStrTxt){
			int line = 0;
			int length = teStrTxt.Length;
			string[][] teTxtArray = new string[length][];
			while (line <length)
			{
				string teStrLine = teStrTxt[line];
				string teStrLine2 = teStrTxt[line];
				teStrLine = teStrLine.Trim();
				if (string.IsNullOrEmpty(teStrLine))
				{
					teTxtArray[line] = new string[]{"\t"};
					break;
				}
				teStrLine2 = teStrLine2.Replace(" ", "");
				String[] teStrs = teStrLine2.Split('\t');
				teTxtArray[line] = teStrs;
				line++;
			}
			//Debug.Log("Length:" + length);
			return teTxtArray;
		}
		
		public static void WriteTxt(string txtName, string value)
		{
			Debug.Log(txtName + ":WriteTxt:" + value);
			FileStream fs = new FileStream(txtName, FileMode.Create);
			StreamWriter sw = new StreamWriter(fs, Encoding.UTF8);
			sw.Write(value);
			sw.Close();
			fs.Close();
		}

	}
}
