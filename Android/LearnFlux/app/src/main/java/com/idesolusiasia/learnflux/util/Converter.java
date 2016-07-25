package com.idesolusiasia.learnflux.util;

import com.google.gson.Gson;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.entity.Thread;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by NAIT ADMIN on 13/06/2016.
 */
public class Converter {
	static Gson gson=new Gson();
	public static Thread convertThread(JSONObject obj)throws JSONException{
			return gson.fromJson(obj.toString(), Thread.class);
		}

	public static Participant convertPeople(JSONObject obj)throws JSONException{
		return gson.fromJson(obj.toString(),Participant.class);
	}
}
