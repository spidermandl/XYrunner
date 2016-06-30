//using UnityEngine;
//using UnityEditor;
//using System;
//using System.IO;
//using System.Reflection;
//using System.Collections;
//
//public class SQLiteTool : EditorWindow {
//    static string dbfile;
//    static string command;
//    static string querytext;
//    static string password;
//    static SQLiteDB db;
//    static Vector2 scroll1, scroll2;
//
//    void OnGUI() {
//        dbfile = EditorGUILayout.TextField("SQLite DataFile:", dbfile);
//        password = EditorGUILayout.TextField("SQLite Password:", password);
//
//        EditorGUILayout.LabelField("SQL CommandText:(Input SELECT SQL Text)");
//        scroll1 = EditorGUILayout.BeginScrollView(scroll1);   
//        querytext = EditorGUILayout.TextArea(querytext, GUILayout.Height(position.height - 50));
//        EditorGUILayout.EndScrollView();
//
//        EditorGUILayout.LabelField("SQL CommandText:(Input INSERT/UPDATE/DELETE SQL Text)");
//        scroll2 = EditorGUILayout.BeginScrollView(scroll2);
//        command = EditorGUILayout.TextArea(command, GUILayout.Height(position.height - 50));
//        EditorGUILayout.EndScrollView();
//
//        EditorGUILayout.BeginHorizontal("Button");
//        GUI.backgroundColor = Color.cyan;
//        if (GUILayout.Button("Open Sqlite DataFile")) OpenSqlite();
//        GUI.backgroundColor = Color.green;
//        if (GUILayout.Button("Query SQL Command")) QuerySQL();
//        GUI.backgroundColor = Color.red;
//        if (GUILayout.Button("Execute CommandText")) ExecuteSQL();
//        EditorGUILayout.EndHorizontal();
//		GUI.backgroundColor = Color.white;  
//		if (GUILayout.Button("Close Database")) CloseSqlite();
//    }
//
//    /// <summary>
//    /// 写license文件
//    /// </summary>
//    [MenuItem("Game/Open Sqlite Tool")]
//    public static void OpenSqliteTool() {
//        dbfile = PlayerPrefs.GetString("Tool_SqliteFile");
//        password = PlayerPrefs.GetString("Tool_SqlitePass");
//        command = PlayerPrefs.GetString("Tool_SqliteCommand");
//        querytext = PlayerPrefs.GetString("Tool_SqliteQueryText");
//        EditorWindow.GetWindow(typeof(SQLiteTool)).Show();
//    }
//
//	/// <summary>
//	/// 打开SQLITE数据库
//	/// </summary>
//    static void OpenSqlite() {
//        if (db != null) db.Close();
//        if (string.IsNullOrEmpty(dbfile)) {
//            Debug.LogError("数据库文件路径为空!!!");
//            return;
//        }
//        db = new SQLiteDB();
//        db.Open(@dbfile);
//        if (!string.IsNullOrEmpty(password)) {
//            db.Key(password);   //Set Password
//        }
//        PlayerPrefs.SetString("Tool_SqliteFile", dbfile);
//        PlayerPrefs.SetString("Tool_SqlitePass", password);
//        Debug.Log("数据库链接打开成功，数据文件:>" + dbfile);
//    }
//
//	/// <summary>
//	/// 关闭SQLITE
//	/// </summary>
//	static void CloseSqlite() {
//		if (db == null) return;
//		db.Close();	db = null;
//		Debug.Log("数据库链接已经关闭，数据文件:>" + dbfile);
//	}
//
//	/// <summary>
//	/// 执行一条语句
//	/// </summary>
//    static void ExecuteSQL() {
//        if (db == null) {
//            Debug.LogError("数据库对象为空!!!"); return;
//        }
//        if (string.IsNullOrEmpty(command)) {
//            Debug.LogError("SQL命令语句为空!!!"); return;
//        }
//        PlayerPrefs.SetString("Tool_SqliteCommand", command);
//        SQLiteQuery qr = new SQLiteQuery(db, command);
//        qr.Step();
//        qr.Release();
//    }
//
//	/// <summary>
//	/// 执行一条查询
//	/// </summary>
//    static void QuerySQL() {
//        if (db == null) {
//            Debug.LogError("数据库对象为空!!!"); return;
//        }
//        if (string.IsNullOrEmpty(querytext)) {
//            Debug.LogError("SQL查询语句为空!!!"); return;
//        }
//        PlayerPrefs.SetString("Tool_SqliteQueryText", querytext);
//        SQLiteQuery qr = new SQLiteQuery(db, querytext);
//		int i = 0;
//		string line = string.Empty;
//        while (qr.Step()) {
//			string[] fs = qr.columnNames;
//			if (i == 0) {
//				for(int j = 0; j < fs.Length; j++) {
//					line += "[" + fs[j] + "] ";
//				}
//				Debug.LogError(line);
//			}
//			line = string.Empty;
//			for(int j = 0; j < fs.Length; j++) {
//				string field = qr.GetString(fs[j]);
//				line += field + " ";
//			}
//			Debug.LogWarning(line);
//			i++;
//        }
//        qr.Release();
//    }
//}
