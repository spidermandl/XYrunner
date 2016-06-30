// Copyright (c) 2010 Bob Berkebile
// Please direct any bugs/comments/suggestions to http://www.pixelplacement.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

using UnityEngine;
using System.Collections.Generic;

//[AddComponentMenu("Pixelplacement/iTweenPath")]
public class iTweenPlayWall : MonoBehaviour
{
	// 可以抓几次 (-1表示可以无限抓)
	public int playWallCount_Right = -1 ;
	public int playWallCount_Left = -1 ;
	// 是否可以弹跳
	public bool isCanPlayWall_Right = false;
	public bool isCanPlayWall_Left = false;
	// 可以停留的时间
	public double stayTime_Right = 0 ;
	public double stayTime_Left = 0 ;
	// 加速度(向下掉落的速度)
	public double acceleration_Right = 0;
	public double acceleration_Left = 0;
}