using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using SimpleFramework;

/**
 * Desmond
 * http command response
 * */
public class HttpCommand : ControllerCommand {

	public override void Execute(IMessage message) {
		object body = message.Body;
		if (body == null) return;
		
		String msg = (String)body;
		Util.CallMethod("Network", "OnResponse", msg);

	}
}
