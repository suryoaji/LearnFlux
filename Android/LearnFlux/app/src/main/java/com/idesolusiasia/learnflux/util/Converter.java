package com.idesolusiasia.learnflux.util;

import com.google.gson.Gson;
import com.idesolusiasia.learnflux.entity.Event;
import com.idesolusiasia.learnflux.entity.MessageEvent;
import com.idesolusiasia.learnflux.entity.Organizations;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.entity.Thread;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by NAIT ADMIN on 13/06/2016.
 */
public class Converter {
	static Gson gson=new Gson();
	public static Thread convertThread(JSONObject obj)throws JSONException{
		Thread t = gson.fromJson(obj.toString(), Thread.class);
		if (obj.has("messages")){
			JSONArray messageArray = obj.getJSONArray("messages");
			for (int i=0;i<messageArray.length();i++) {
				JSONObject msg = messageArray.getJSONObject(i);
				if (msg.has("reference")){
					JSONObject ref = msg.getJSONObject("reference");
					if (ref.getString("type").equalsIgnoreCase("event")){
						t.getMessages().set(i,convertMessageEvent(msg));
					}
				}
			}
		}

		return t;
	}

	public static Participant convertPeople(JSONObject obj)throws JSONException{
		return gson.fromJson(obj.toString(),Participant.class);
	}
	public static Organizations convertOrganizations(JSONObject obj)throws  JSONException{
		return gson.fromJson(obj.toString(), Organizations.class);
	}

	public static MessageEvent convertMessageEvent(JSONObject obj)throws  JSONException{
		return gson.fromJson(obj.toString(), MessageEvent.class);
	}

	public static Event convertEvent(JSONObject obj)throws  JSONException{
		return gson.fromJson(obj.toString(), Event.class);
	}
}
