using UnityEngine;
using System.Collections;
using System.IO;
using System.Collections.Generic;
using System.Net;

namespace SimpleFramework.Manager {
	public class ResourceManager : View {

		public class LoadManager {

			private AssetBundleManifest abmanifest;
			private Dictionary<string, AssetBundle> tempBundle = new Dictionary<string, AssetBundle>();//temperally assetbundle stored when loading from disk
			private Dictionary<string, Object> assetList = new Dictionary<string, Object>();//asset model object in memory

			private ResourceManager resManager;

			private float aggregate = 1;//aggregated loading resource
			private float progress = 0 ;

			public LoadManager(ResourceManager res){
				this.resManager = res;
				//加载AssetBundleManifest
				byte[] stream = null;
				string uri = Util.AssetBundlePath + AppConst.AssetBundleName;
				Debug.Log("LoadBundle:" + uri);
				try{
					stream = File.ReadAllBytes(uri);
					AssetBundle shared = AssetBundle.LoadFromMemory(stream);
					abmanifest = (AssetBundleManifest)(shared.LoadAsset("AssetBundleManifest",typeof(AssetBundleManifest)));
					shared.Unload(false);
				}catch(System.Exception e){
					Debug.LogError("Read " + AppConst.AssetBundleName + " failed");
				}
				assetList.Clear();

			}
			//加载
			private void LoadBundle(string name) {
				name = name.ToLower();
				if (assetList.ContainsKey (name)) {
					return;
				}

				//加载所有依赖项
				string[] dep = abmanifest.GetAllDependencies(name);
				foreach(string value in dep){
					LoadBundle(value);
				}
				//加载自身
				byte[] stream = null;
				AssetBundle bundle = null;
				string uri = Util.AssetBundlePath + name;
				Debug.Log("LoadBundle:" + name);
				stream = File.ReadAllBytes(uri);
				bundle = AssetBundle.LoadFromMemory(stream);
				string asname = name.Substring(name.LastIndexOf("/")+1);
				//extract out asset
				assetList.Add (name, bundle.LoadAsset(asname));
				tempBundle.Add (name,bundle);
				//bundle.Unload (false);
				return;
			}
			private void unloadBundle(string name){

		    }

			//free assetbundle in memory
			private void freeBundle(){
				foreach (KeyValuePair<string, AssetBundle> kv in tempBundle){
					if(kv.Value != null)
						kv.Value.Unload(false);
				}
				tempBundle.Clear ();
			}
			//load prefab sync
			public T LoadObject<T>(string name) where T:UnityEngine.Object{
				//<test>
				//return Resources.Load (name, typeof(T)) as T; 
				//</test>
				name = name.ToLower();
				T obj = null;

				if (assetList.ContainsKey (name)) {
					return assetList[name] as T;
				}

				if (AppConst.UseAssetBundle == false) {//load from packaged resource asset
					//Debug.Log(name);
					obj = Resources.Load (name, typeof(T)) as T;
					assetList.Add(name,obj);
					return obj;
				}

				LoadBundle(name);
				//freeBundle ();

				Object value = assetList [name];
				if (value != null) {
					return value as T;
				} else {
					Debug.LogError("----------------AssetBundle load failed:" + name);
					return null;
				}
			}

			//异步加载
			public void StartLoadBundle(string[] names, System.Action<float> func){
				resManager.StartCoroutine(resManager.AsyncLoadBundles(names));
			}

			//异步加载
			public IEnumerator AsyncLoadBundles(string[] names){
				List<string> abnames = new List<string>();
				foreach(string n in names){
					string path = n.ToLower();
					if(path.EndsWith("/")){
						foreach(string a in abmanifest.GetAllAssetBundles()){
							if(a.StartsWith(path)) abnames.Add(a);
						}
					}
					else{
						abnames.Add(path);
					}
				}

				progress = 0;
				aggregate = abnames.Count;
				foreach(string asname in abnames){
					yield return resManager.AsyncLoadSingleBundle(asname);
					progress ++;
					//freeBundle();
				}
			}

			//异步加载
			public IEnumerator AsyncLoadSingleBundle(string name) {
				name = name.ToLower();
				//如果已经加载过
				if(assetList.ContainsKey(name)){
					yield break;
				}
				//加载所有依赖项
				string[] dep = abmanifest.GetAllDependencies(name);
				foreach(string value in dep){
					//yield return resManager.StartCoroutine(resManager.AsyncLoadSingleBundle(value));
					yield return resManager.AsyncLoadSingleBundle(value);
				}
				//加载自身
				string uri = Util.AssetBundlePath + name;
				Debug.Log("AsyncLoadBundle:" + name);
				string wwwuri = "file://" + uri;
				WWW www = new WWW(wwwuri);
				yield return www;
				if(www.error != null){
					Debug.LogError(www.error);
					yield break;
				}
				if (!www.isDone) {
					Debug.LogError("www load failed:" + name);
					yield break;
				}

				AssetBundleCreateRequest re = AssetBundle.LoadFromMemoryAsync(www.bytes);
				yield return re;
				if (re.assetBundle == null) {
					Debug.LogError("AssetBundle create failed:" + name);
					yield break;
				}
				if(re.isDone){
					AssetBundle bundle = re.assetBundle;
					string asname = name.Substring(name.LastIndexOf("/")+1);
					assetList.Add (name, bundle.LoadAsset(asname));
					tempBundle.Add(name,bundle);
					bundle.Unload (false);
					yield break;
				}
				yield break;
			}

			public float getLoadingProgress(){
				return progress / aggregate;
			}

			//release memory when scene exchanging
			public void releaseMemory(){
				Debug.Log ("-----------------public void releaseMemory() ");
				foreach (KeyValuePair<string, Object> kv in assetList){
					//Resources.UnloadAsset(kv.Value);
					//GameObject.Destroy(kv.Value);
				}
				freeBundle ();
				assetList.Clear ();
				Util.ClearMemory ();
			}

		}

		//------------------------------------------------------------------------------------------------------------------------------------
		private LoadManager loader;

		public void initialize(System.Action func) {
			loader = new LoadManager (this);
		    if (func != null) func();
        }

		//release memory when scene exchanging
		public void releaseMemory(){
			loader.releaseMemory ();
		}

		//析构
		void OnDestroy() {

        }

		public float getLoadingProgress(){
			return loader.getLoadingProgress ();
		}

		public T LoadObject<T>(string name) where T:UnityEngine.Object{
			return loader.LoadObject<T> (name);
		}
		//异步加载
		public void StartLoadBundle(string[] names){
			loader.StartLoadBundle(names,null);
		}

		public IEnumerator AsyncLoadBundles(string[] names){
			return loader.AsyncLoadBundles(names);
		}

		public IEnumerator AsyncLoadSingleBundle(string name) {
			return loader.AsyncLoadSingleBundle (name);
		}
		//--------------------------------------------------version update checking-------------------------------------------------------------
		/**
		 * resource checking enum
		 * */
		public enum ResState{
			UNCHECKED,//rescource has not been checked
			COPY_RES, //copy resource from package
			VERSION_CHECK, //get version config
			UPDATE_CHECKING,//checking if update is needed
			DOWNLOAD,//download rescource
			FINISH,//checking finished
		}

		//所有地址都是测试地址
		//先检查拷贝后检查更新
		private string storagePath = Application.isMobilePlatform?Util.DataPath:"MacTest/";//resource stored on the disk
//		private string urlRoot = "http://172.16.10.200/res/" ;//server root url path
		private string domain = "http://xy-runner.oss.aliyuncs.com/";
		private string urlRoot = "http://xy-runner.oss.aliyuncs.com/" + Util.PlatformName + "/";//server root url path
		private string version_suffix = "version_config.txt";//version config file in oss
		private string urlSuffix = null;//game version
		private string pathAndMD5 = "pathAndMD5.txt";//collections of file path and file md5
		private string fileMd5 = "fileMd5.txt"; // md5 of pathAndMd5 file
		private string fileTemp = "temp";// temp file
		
		private Dictionary<string,string> localFileMap = new Dictionary<string, string> ();//local file&md5 list
		private Dictionary<string,string> remoteFileMap = new Dictionary<string, string> ();//server file&md5 list 
		private Dictionary<string,string> downloadFileMap = new Dictionary<string, string> ();//download file&md5 list
		private byte[] remoteFileMd5 ; //remote md5file content

		private ResState state = ResState.UNCHECKED; //current resource checking state

		public ResState State {
			get {
				return state;
			}
		}

		string msg = "";
		public string message{
			get{ return msg; }
			set{
				msg = value;
				//Debug.Log(value);
			}
		}

		float progress = 0;
		public float Progress{
			get{ return progress; }
			set{
				progress = value;
			}
		}
		float aggregate = 0;
		public float Aggreagate{
			get{ return aggregate; }
			set{
				aggregate = value;
			}
		}

		void Awake() {
			CheckFile ();
		}

		void Start(){
			//processListener = UILoadAssets.Instance;

			//add lua script for presenting checking progress in UI
//			GameObject scene = GameObject.Find ("sceneUI");
//			if (scene != null) {
//				scene.SetActive(false);
//				BundleLua lua = scene.AddComponent<BundleLua>();
//				lua.luaName = "AssetCheckScene";
//				scene.SetActive(true);
//			}
		}
		/// <summary>
		/// Checks the file
		/// </summary>
		public void CheckFile()
		{

			if(!Directory.Exists(storagePath)||!File.Exists(storagePath + fileMd5))
			{
				StartCoroutine(OnExtractResource());
				return;
			}

			if (urlSuffix == null) {
				StartCoroutine(OnGameVersion());
				return;
			}

			StartCoroutine (isNeedUpdate ());
			
		}
		
		/// <summary>
		/// 释放资源
		/// </summary>
		IEnumerator OnExtractResource() {
			state = ResState.COPY_RES;
			message = "正在解包...";

			string dataPath = storagePath;  //数据目录
			string resPath = Util.AppContentPath(); //游戏包资源目录
			
			if (Directory.Exists (dataPath)) {
				DirectoryInfo dir = new DirectoryInfo(dataPath);
				dir.Delete(true);
				//Directory.Delete (dataPath);
			}
			Directory.CreateDirectory(dataPath);

			string infile = null;
			string outfile = null;
			//---------------------------------------------------------
			//copy file and path file
			infile = resPath + pathAndMD5;
			outfile = dataPath + pathAndMD5;
			if (File.Exists(outfile)) File.Delete(outfile);
			
			message = "正在解析配置文件:";
			if (Application.platform == RuntimePlatform.Android) { 
				WWW www = new WWW(infile);
				yield return www;
				
				if (www.isDone) {
					File.WriteAllBytes(outfile, www.bytes);
				}
				yield return 0;
			} else 
				File.Copy(infile, outfile, true);
			yield return new WaitForEndOfFrame();
			//---------------------------------------------------------
			//释放所有文件到数据目录
			string[] files = File.ReadAllLines(outfile);
			Aggreagate = files.Length;

			foreach (var file in files) {
				string[] fs = file.Split('|');
				if(fs.Length != 2)
					continue;
				infile = resPath + fs[0];  //
				outfile = dataPath + fs[0];
				message = "正在解包文件:请稍候";
				Debug.Log(fs[0]);// + fs[0];
				Progress = Progress + 1;

				string dir = Path.GetDirectoryName(outfile);
				if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
				
				if (Application.platform == RuntimePlatform.Android) {
					WWW www = new WWW(infile);
					yield return www;
					
					if (www.isDone) {
						File.WriteAllBytes(outfile, www.bytes);
					}
					yield return 0;
				} else File.Copy(infile, outfile, true);
				
				yield return new WaitForEndOfFrame();
			}
			//-----------------------------------------------------------------
			//copy filemd5 file
			infile = resPath + fileMd5;
			outfile = dataPath + fileMd5;
			if (File.Exists(outfile)) File.Delete(outfile);
			
			//message = "正在解包文件:>fileMd5.txt";
			if (Application.platform == RuntimePlatform.Android) {
				WWW www = new WWW(infile);
				yield return www;
				
				if (www.isDone) {
					File.WriteAllBytes(outfile, www.bytes);
				}
				yield return 0;
			} else 
				File.Copy(infile, outfile, true);
			yield return new WaitForEndOfFrame();
			//-------------------------------------------------------------------
			message = "解包完成!!!";
			yield return new WaitForSeconds(0.1f);
			message = string.Empty;
			
			//释放完成，check version
			StartCoroutine(OnGameVersion());
		}

		//get game version
		IEnumerator OnGameVersion() {
			state = ResState.VERSION_CHECK;
			WWW www = new WWW(domain+version_suffix);
			yield return www;

			if (www.error == null) {
				string[][] versionArray = TXTReader.Readbytes (www.bytes);
				string versionSuffix = versionArray [1] [1] + "/" + versionArray [1] [2] + "/";
				urlRoot = urlRoot + versionSuffix;
			} else {
				message = "error:version file fetching failed";
			}

			//version checked，开始启动更新资源
			StartCoroutine(isNeedUpdate());
			yield break;
		}


		/**
		 * check filemd5 if resource needs be updated
		 * */
		IEnumerator isNeedUpdate(){
			state = ResState.UPDATE_CHECKING;
			message = "正在检查更新...";

			if (AppConst.UpdateMode == false) {
				yield return new WaitForSeconds(1f);
				state = ResState.FINISH;
				yield break;
			}

			//download md5file
			WWW w1 = new WWW(urlRoot + fileMd5);
			yield return w1;
			
			if (w1.error != null) {
				yield return new WaitForSeconds(0.5f);
				message = "error:fileMd5 fetching failed";
				//enter game
				state = ResState.FINISH;
			} else {
				//compare content
				string localMd5 = File.ReadAllText (storagePath + fileMd5);
				
				if(w1.text.Equals(localMd5)){
					//enter game
					state = ResState.FINISH;
					message = "已经是最新版本";
				}else{//nead update
					remoteFileMd5 = w1.bytes;
					//update resource
					StartCoroutine(updateFiles());
				}
			}
		}
		/**
	     * download file list
	     * compare file content
	     * download files
	     * **/
		IEnumerator updateFiles(){
			state = ResState.DOWNLOAD;
			message = "正在下载更新...";
			//download file list
			WWW w2 = new WWW(urlRoot+pathAndMD5);
			yield return w2;
			
			if(w2.error != null)
			{
				yield return new WaitForSeconds(0.5f);
				message = "error:filelist fetching failed";
				yield break;
			}
			
			//read local file list
			string[] files = File.ReadAllLines(storagePath + pathAndMD5);
			foreach (var file in files) 
			{
				string[] pair = file.Split('|');
				if(pair.Length != 2)
					continue;
				localFileMap.Add(pair[0],pair[1]);
			}
			
			//read remote file list
			File.WriteAllBytes (storagePath + fileTemp, w2.bytes);
			files = File.ReadAllLines (storagePath + fileTemp);
			foreach (var file in files) 
			{
				string[] pair = file.Split('|');
				if(pair.Length != 2)
					continue;
				remoteFileMap.Add(pair[0],pair[1]);
			}
			
			//compare file
			foreach (var item in remoteFileMap) {
				if (!localFileMap.ContainsKey(item.Key) || !localFileMap[item.Key].Equals(item.Value)){// unequil when file downloading needed
					downloadFileMap.Add(item.Key,item.Value);
				}
			}
			
			//start download file
			Progress = 0;
			Aggreagate = downloadFileMap.Count;

			List<string> keys = new List<string> (downloadFileMap.Keys);
			for(int i = 0; i<keys.Count;i++){
				WWW file = new WWW(urlRoot + keys[i]);
				yield return file;
				
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(urlRoot+keys[i]);
				WebResponse response = request.GetResponse();
				yield return response;

				if (response.ContentLength == 0) {
					yield return new WaitForSeconds(0.5f);
					message = keys[i] + " fetching failed";
					break;
				}else{
					if (File.Exists(storagePath + keys[i])) 
						File.Delete(storagePath + keys[i]);//delete file
					//File.WriteAllBytes (storagePath + item.Key, file.bytes);
					//write file
					string dir = Path.GetDirectoryName(storagePath + keys[i]);
					if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
					Stream st = response.GetResponseStream();  
					Stream so = new System.IO.FileStream(storagePath + keys[i], FileMode.Create,FileAccess.Write);  
					long totalDownloadedByte = 0;  
					byte[] by = new byte[1024];  
					int osize = st.Read(by, 0, (int)by.Length);  
					while (osize > 0)  
					{
						totalDownloadedByte = osize + totalDownloadedByte;  
						so.Write(by, 0, osize);  
						osize = st.Read(by, 0, (int)by.Length);  
					}  
					so.Close();  
					st.Close();  
//					
//					localFileMap.Remove(item.Key);
//					localFileMap.Add(item.Key,item.Value);
				}

                message = "提示：加载资源不消耗任何流量（更新中……）";// + item.Key;
				Progress = Progress + 1 ;

			}
			
			//write file index & md5 file
			string[] lines = new string[localFileMap.Count];
			int index = 0;
			foreach(var item in localFileMap){
				lines[index] = item.Key+"|"+item.Value;
				index ++;
			}
			
			File.WriteAllLines (storagePath + pathAndMD5, lines);
			File.WriteAllBytes (storagePath + fileMd5, remoteFileMd5);
			
			
			//enter game
			state = ResState.FINISH;
			message = "更新完成!!!";
		}


    }
}