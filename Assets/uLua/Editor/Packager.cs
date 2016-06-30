using UnityEditor;
using UnityEngine;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using SimpleFramework;
using System;


public class Packager {
    public static string platform = string.Empty;
    static List<string> paths = new List<string>();
    static List<string> files = new List<string>();

    ///-----------------------------------------------------------
    static string[] exts = { ".prefab", ".ttf", ".otf", ".controller", ".shader", ".FBX", ".wav", ".mp3", ".ogg", ".renderTexture", ".png" };
    static bool CanCopy(string ext) {   //能不能复制
        foreach (string e in exts) {
            if (ext.Equals(e)) return true;
        }
        return false;
    }

    /// <summary>
    /// 载入素材
    /// </summary>
    static UnityEngine.Object LoadAsset(string file) {
        if (file.EndsWith(".lua")) file += ".txt";
        return AssetDatabase.LoadMainAssetAtPath("Assets/Builds/" + file);
    }

    [MenuItem("Game/Build iPhone Resource", false, 11)]
    public static void BuildiPhoneResource() { 
        BuildTarget target;
#if UNITY_5
        target = BuildTarget.iOS;
#else
        target = BuildTarget.iPhone;
#endif
        BuildAssetResource(target, false);
    }

    [MenuItem("Game/Build Android Resource", false, 12)]
    public static void BuildAndroidResource() {
        BuildAssetResource(BuildTarget.Android, true);
    }

    [MenuItem("Game/Build Windows Resource", false, 13)]
    public static void BuildWindowsResource() {
        BuildAssetResource(BuildTarget.StandaloneWindows, true);
    }

	[MenuItem("Game/Build auto Resource", false, 14)]
	public static void BuildAutoResource() {
		BuildAssetResource(EditorUserBuildSettings.activeBuildTarget, true);
	}

	/// <summary>
    /// 生成绑定素材
    /// </summary>
    public static void BuildAssetResource(BuildTarget target, bool isWin) {
        string dataPath = Util.DataPath;
		BuildAssetBundleOptions op = BuildAssetBundleOptions.None;
		//Desmond delete
//        if (Directory.Exists(dataPath)) {
//            Directory.Delete(dataPath, true);
//        }

		// SetAssetBundleName
		if(AppConst.UseAssetBundle){
			SetAssetBundleName();
		}

        string assetPath = AppDataPath + "/StreamingAssets/";
        if (Directory.Exists(dataPath)) {
            Directory.Delete(assetPath, true);
        }
        if (!Directory.Exists(assetPath)) Directory.CreateDirectory(assetPath);

		//unity5 打包AssetBundle
		string outputPath = Path.Combine(assetPath, AppConst.AssetBundleName);
		if (!Directory.Exists(outputPath)) 
			Directory.CreateDirectory(outputPath);
		if(AppConst.UseAssetBundle) 
			BuildPipeline.BuildAssetBundles(outputPath, op, target);

		//加密并打包lua脚本及配置文件
		HandleLuaFile(isWin);

		//生成版本控制文件
		CreateVersionText();
        
		AssetDatabase.Refresh();
    }

    /// <summary>
    /// 处理Lua文件
    /// </summary>
    static void HandleLuaFile(bool isWin)
	{
        string resPath = AppDataPath + "/StreamingAssets/";
        string luaPath = resPath + "/lua/";

        //----------复制Lua文件----------------
        if (!Directory.Exists(luaPath)) {
            Directory.CreateDirectory(luaPath); 
        }
        paths.Clear(); files.Clear();
        string luaDataPath = AppDataPath + "/lua/".ToLower();
        Recursive(luaDataPath);
        int n = 0;
        foreach (string f in files) {
            //if (f.EndsWith(".meta")) continue;//Desmond delete
			if (!(f.EndsWith(".lua")||f.EndsWith(".json")||f.EndsWith(".txt"))) continue;
            string newfile = f.Replace(luaDataPath, "");
            string newpath = luaPath + newfile;
            string path = Path.GetDirectoryName(newpath);
            if (!Directory.Exists(path)) Directory.CreateDirectory(path);

            if (File.Exists(newpath)) {
                File.Delete(newpath);
            }
			if (AppConst.LuaEncode&&(f.EndsWith(".lua")||f.EndsWith(".txt"))) {
				UpdateProgress(n++, files.Count, newpath);
                //EncodeLuaFile(f, newpath, isWin);
				aesEncryptFile(f,newpath);
            } else {
                File.Copy(f, newpath, true);
            }
			//aesEncryptFile(f,newpath);
        }
        EditorUtility.ClearProgressBar();
	}

	/// <summary>
	/// 获取lua文件|md5列表字符串
	/// </summary>
	static string GetPathAndMd5()
	{
		string resPath = AppDataPath + "/StreamingAssets/";

        paths.Clear(); files.Clear();
        Recursive(resPath);

		string luaFileMd5Str = "";
        //FileStream fs = new FileStream(newFilePath, FileMode.CreateNew);
        //StreamWriter sw = new StreamWriter(fs);
        for (int i = 0; i < files.Count; i++) {
            string file = files[i];
            string ext = Path.GetExtension(file);
            //if (file.EndsWith(".meta")) continue;//Desmond delete
//			if (!(file.EndsWith(".lua")||file.EndsWith(".json")||file.EndsWith(".txt"))) continue;

            string md5 = Util.md5file(file);
            string value = file.Replace(resPath, string.Empty); 
			//Desmond
			luaFileMd5Str += value + "|" + md5 + "\n";
            //sw.WriteLine(value);
        }
        //sw.Close(); fs.Close();

		return luaFileMd5Str;
    }

    /// <summary>
    /// 数据目录
    /// </summary>
    static string AppDataPath {
        get { return Application.dataPath.ToLower(); }
    }

    /// <summary>
    /// 遍历目录及其子目录
    /// </summary>
    static void Recursive(string path) {
        string[] names = Directory.GetFiles(path);
        string[] dirs = Directory.GetDirectories(path);
        foreach (string filename in names) {
            string ext = Path.GetExtension(filename);
            if (ext.Equals(".meta")) continue;
            files.Add(filename.Replace('\\', '/'));
        }
        foreach (string dir in dirs) {
            paths.Add(dir.Replace('\\', '/'));
            Recursive(dir);
        }
    }

    static void UpdateProgress(int progress, int progressMax, string desc) {
        string title = "Processing...[" + progress + " - " + progressMax + "]";
        float value = (float)progress / (float)progressMax;
        EditorUtility.DisplayProgressBar(title, desc, value);
    }

	//aes encrypt
	static void aesEncryptFile(string oldpath,string newpath){
		File.WriteAllBytes (newpath,Util.EncryptStringToBytes_Aes (File.ReadAllText (oldpath)));
	}

    static void EncodeLuaFile(string srcFile, string outFile, bool isWin) {
        if (!srcFile.ToLower().EndsWith(".lua")) {
            File.Copy(srcFile, outFile, true);
            return;
        }
        string luaexe = string.Empty;
        string args = string.Empty;
        string exedir = string.Empty;
        string currDir = Directory.GetCurrentDirectory();
        if (Application.platform == RuntimePlatform.WindowsEditor) {
            luaexe = "luajit.exe";
            args = "-b " + srcFile + " " + outFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luajit/";
        } else if (Application.platform == RuntimePlatform.OSXEditor) {
            luaexe = "./luac";
            args = "-o " + outFile + " " + srcFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luavm/";
        }
        Directory.SetCurrentDirectory(exedir);
        ProcessStartInfo info = new ProcessStartInfo();
        info.FileName = luaexe;
        info.Arguments = args;
        info.WindowStyle = ProcessWindowStyle.Hidden;
        info.UseShellExecute = isWin;
        info.ErrorDialog = true;
        Util.Log(info.FileName + " " + info.Arguments);

        Process pro = Process.Start(info);
        pro.WaitForExit();
        Directory.SetCurrentDirectory(currDir);
    }

    [MenuItem("Game/Build Protobuf-lua-gen File")]
    public static void BuildProtobufFile() {
        string dir = AppDataPath + "/Lua/bin";
        paths.Clear(); files.Clear(); Recursive(dir);

        string protoc = "d:/protobuf-2.4.1/src/protoc.exe";
        string protoc_gen_dir = "\"d:/protoc-gen-lua/plugin/protoc-gen-lua.bat\"";

        foreach (string f in files) {
            string name = Path.GetFileName(f);
            string ext = Path.GetExtension(f);
            if (!ext.Equals(".proto")) continue;

            ProcessStartInfo info = new ProcessStartInfo();
            info.FileName = protoc;
            info.Arguments = " --lua_out=./ --plugin=protoc-gen-lua=" + protoc_gen_dir + " " + name;
            info.WindowStyle = ProcessWindowStyle.Hidden;
            info.UseShellExecute = true;
            info.WorkingDirectory = dir;
            info.ErrorDialog = true;
            Util.Log(info.FileName + " " + info.Arguments);

            Process pro = Process.Start(info);
            pro.WaitForExit();
        }
        AssetDatabase.Refresh();
    }

	[MenuItem("Game/Set AssetBundleName(Resource)")]
	public static void SetAssetBundleName()
	{
		CommonSetABName("/Resources/", "");
		AssetDatabase.Refresh();
	}

	//path:要设置assetbundle名的目录
	public static void CommonSetABName(string path, string abName = "")
	{
		var fullPath = Application.dataPath + path;
		var relativeLen = Application.dataPath.Length - "Assets".Length; // Assets 长度
		if (Directory.Exists(fullPath))
		{
			int cutLen = "Assets/Resources/".Length;
			EditorUtility.DisplayProgressBar("设置AssetName", "正在设置AssetName...", 0f);
			var dir = new DirectoryInfo(fullPath);
			var files = dir.GetFiles("*", SearchOption.AllDirectories);
			for (var i = 0; i < files.Length; ++i)
			{
				var fileInfo = files[i];
				EditorUtility.DisplayProgressBar("设置AssetName", "正在设置AssetName...", 1f * i / files.Length);
				if (CanCopy(fileInfo.Extension))
				{
					var basePath = fileInfo.FullName.Substring(relativeLen).Replace('\\', '/');
					if(path == "/Resources/"){
						abName = basePath.Substring(cutLen);
						abName = abName.Substring(0, abName.LastIndexOf("."));
						UnityEngine.Debug.Log("abName:" + abName);
					}
					var importer = AssetImporter.GetAtPath(basePath);
					if (importer /*&& importer.assetBundleName == ""*/)
					{
						importer.assetBundleName = abName;//filter building for assetsbundle
					}
				}
			}
			EditorUtility.ClearProgressBar();
			AssetDatabase.RemoveUnusedAssetBundleNames();
		}
//		AssetDatabase.Refresh();
	}

	/// <summary>
	/// 生成file名|file_md5码列表文件 -- by hanli_xiong
	/// </summary>
	static void CreateVersionText ()
	{
		string pathAndMd5 = GetPathAndMd5();
		string path = Application.dataPath + "/StreamingAssets/"+ "pathAndMD5.txt";
		FileStream fs = new FileStream(path, FileMode.Create, FileAccess.Write); 
		StreamWriter sw = new StreamWriter(fs);
		sw.WriteLine(pathAndMd5);
		sw.Flush();
		sw.Close();
		fs.Close();
		
		string filePath = Application.dataPath + "/StreamingAssets/"+ "fileMd5.txt";
		FileStream fsm = new FileStream(filePath, FileMode.Create, FileAccess.Write); 
		StreamWriter swr = new StreamWriter(fsm);
		string content = Util.md5file(path);
		swr.WriteLine(content);
		swr.Flush();
		swr.Close();
		fsm.Close();
	}

}