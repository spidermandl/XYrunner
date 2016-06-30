using UnityEngine;
using System.Collections;
using System.Security.Cryptography;
using System.Text;
using System.IO;
using System;

public class AESHelper : MonoBehaviour {

	public static void example()
	{
		try
		{
			
			string original = "Here is some data to encrypt!";
			
			// Create a new instance of the Aes
			// class.  This generates a new key and initialization 
			// vector (IV).
			using (Aes myAes = Aes.Create())
			{
				
				// Encrypt the string to an array of bytes.
				byte[] encrypted = EncryptStringToBytes_Aes(original, 
				                                            myAes.Key, myAes.IV);
				
				// Decrypt the bytes to a string.
				string roundtrip = DecryptStringFromBytes_Aes(encrypted, 
				                                              myAes.Key, myAes.IV);
				
				//Display the original data and the decrypted data.
				Console.WriteLine("Original:   {0}", original);
				Console.WriteLine("Round Trip: {0}", roundtrip);
			}
			
		}
		catch (Exception e)
		{
			Console.WriteLine("Error: {0}", e.Message);
		}
	}

	/// <summary>
	/// 获取密钥
	/// </summary>
	public static string Key
	{
		get
		{
			return "xygame-runnerdes";    ////必须是16位
		}
	}
	//默认密钥向量 
	public static byte[] keyVector = { 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF, 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF };


	public static byte[] EncryptStringToBytes_Aes(string plainText, byte[] Key, 
	                                       byte[] IV)
	{
		// Check arguments.
		if (plainText == null || plainText.Length <= 0)
			throw new ArgumentNullException("plainText");
		if (Key == null || Key.Length <= 0)
			throw new ArgumentNullException("Key");
		if (IV == null || IV.Length <= 0)
			throw new ArgumentNullException("Key");
		byte[] encrypted;
		// Create an Aes object
		// with the specified key and IV.
		using (Aes aesAlg = Aes.Create())
		{
			aesAlg.Key = Key;
			aesAlg.IV = IV;
			
			// Create a decrytor to perform the stream transform.
			ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key
			                                                    , aesAlg.IV);
			
			// Create the streams used for encryption.
			using (MemoryStream msEncrypt = new MemoryStream())
			{
				using (CryptoStream csEncrypt = new CryptoStream(msEncrypt
				                                                 , encryptor, CryptoStreamMode.Write))
				{
					using (StreamWriter swEncrypt = new StreamWriter(
						csEncrypt))
					{
						
						//Write all data to the stream.
						swEncrypt.Write(plainText);
					}
					encrypted = msEncrypt.ToArray();
				}
			}
		}
		
		
		// Return the encrypted bytes from the memory stream.
		return encrypted;

	}
	
	public static string DecryptStringFromBytes_Aes(byte[] cipherText, byte[] Key
	                                         , byte[] IV)
	{
		// Check arguments.
		if (cipherText == null || cipherText.Length <= 0)
			throw new ArgumentNullException("cipherText");
		if (Key == null || Key.Length <= 0)
			throw new ArgumentNullException("Key");
		if (IV == null || IV.Length <= 0)
			throw new ArgumentNullException("Key");
		
		// Declare the string used to hold
		// the decrypted text.
		string plaintext = null;
		
		// Create an Aes object
		// with the specified key and IV.
		using (Aes aesAlg = Aes.Create())
		{
			aesAlg.Key = Key;
			aesAlg.IV = IV;
			
			// Create a decrytor to perform the stream transform.
			ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key
			                                                    , aesAlg.IV);
			
			// Create the streams used for decryption.
			using (MemoryStream msDecrypt = new MemoryStream(cipherText))
			{
				using (CryptoStream csDecrypt = new CryptoStream(msDecrypt
				                                                 , decryptor, CryptoStreamMode.Read))
				{
					using (StreamReader srDecrypt = new StreamReader(
						csDecrypt))
					{
						
						// Read the decrypted bytes from the decrypting 
						// and place them in a string.
						plaintext = srDecrypt.ReadToEnd();
					}
				}
			}
			
		}


		return plaintext;
		
	}

	public static byte[] DecryptBytesFromBytes_Aes(byte[] cipherText, byte[] Key
	                                                , byte[] IV)
	{
		// Check arguments.
		if (cipherText == null || cipherText.Length <= 0)
			throw new ArgumentNullException("cipherText");
		if (Key == null || Key.Length <= 0)
			throw new ArgumentNullException("Key");
		if (IV == null || IV.Length <= 0)
			throw new ArgumentNullException("Key");
		
		// Declare the string used to hold
		// the decrypted text.
		byte[] bts = null;
		
		// Create an Aes object
		// with the specified key and IV.
		using (Aes aesAlg = Aes.Create())
		{
			aesAlg.Key = Key;
			aesAlg.IV = IV;
			
			// Create a decrytor to perform the stream transform.
			ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key
			                                                    , aesAlg.IV);
			
			// Create the streams used for decryption.
			using (MemoryStream msDecrypt = new MemoryStream(cipherText))
			{
				using (CryptoStream csDecrypt = new CryptoStream(msDecrypt
				                                                 , decryptor, CryptoStreamMode.Read))
				{
					using (StreamReader srDecrypt = new StreamReader(
						csDecrypt))
					{
						
						// Read the decrypted bytes from the decrypting 
						// and place them in a string.

						using (var memstream = new MemoryStream())
						{
							var buffer = new byte[512];
							var bytesRead = default(int);
							while ((bytesRead = srDecrypt.BaseStream.Read(buffer, 0, buffer.Length)) > 0)
								memstream.Write(buffer, 0, bytesRead);
							bts = memstream.ToArray();
						}

					}
				}
			}
			
		}
		
		
		return bts;
		
	}

	/// <summary>  
	/// AES加密  
	/// </summary>  
	/// <param name="Data">明文</param>  
	/// <param name="Key">密钥</param>  
	/// <param name="Vector">向量</param>  
	public static Byte[] AESEncrypt(Byte[] Data, String Key, Byte[] Vector)  
	{  
		SymmetricAlgorithm des = Rijndael.Create();
		des.Key = Encoding.UTF8.GetBytes(Key);
		des.IV = Vector;
		byte[] cipherBytes = null; 
		try  
		{  
			using (MemoryStream Memory = new MemoryStream())  
			{  
				using (CryptoStream Encryptor = new CryptoStream(Memory,des.CreateEncryptor(),CryptoStreamMode.Write))  
				{
					Encryptor.Write(Data, 0, Data.Length);  
					Encryptor.FlushFinalBlock();  
					
					cipherBytes = Memory.ToArray();  
				}  
			}  
		}
		catch  
		{
			cipherBytes = null;  
			Debug.Log("加密失败");
		}  
		return cipherBytes;  
	}  

	
	/// <summary>  
	/// AES解密  
	/// </summary>  
	/// <param name="Data">被解密的密文</param>  
	/// <param name="Key">密钥</param>  
	/// <param name="Vector">向量</param>   
	public static Byte[] AESDecrypt(Byte[] Data, String Key, Byte[] Vector)  
	{  
		SymmetricAlgorithm des = Rijndael.Create();
		des.Key = Encoding.UTF8.GetBytes(Key);
		des.IV = Vector;  
		
		Byte[] original = null; 
		try  
		{   
			using (MemoryStream Memory = new MemoryStream(Data))  
			{  
				using (CryptoStream Decryptor = new CryptoStream(Memory,des.CreateDecryptor(),CryptoStreamMode.Read))  
				{  
					using (MemoryStream originalMemory = new MemoryStream())  
					{  
						Byte[] Buffer = new Byte[1024];  
						Int32 readBytes = 0;  
						while ((readBytes = Decryptor.Read(Buffer, 0, Buffer.Length)) > 0)  
						{  
							originalMemory.Write(Buffer, 0, readBytes);  
						}  
						original = originalMemory.ToArray();  
					}  
				}  
			}  
		}  
		catch  
		{  
			original = null;  
			Debug.Log("解密失败"); 
		}  
		return original;  
	}  

	public static void EncryptGameObject(string name)
	{
		byte[] stream = null;
		string dataPath = Application.dataPath + "/StreamingAssets/"+ name + ".assetbundle";
		stream = File.ReadAllBytes(dataPath);

		byte[] encrypt = null;
		encrypt = AESEncrypt(stream,Key,keyVector);
		File.WriteAllBytes(dataPath, encrypt);
	}
	public static void DecryptGameObject(string name)
	{
		byte[] stream = null;
		string dataPath = Application.dataPath + "/StreamingAssets/"+ name + ".assetbundle";
		stream = File.ReadAllBytes(dataPath);
		
		byte[] decrypt = null;
		decrypt = AESDecrypt(stream,Key,keyVector);
		File.WriteAllBytes(dataPath, decrypt);
	}
}
