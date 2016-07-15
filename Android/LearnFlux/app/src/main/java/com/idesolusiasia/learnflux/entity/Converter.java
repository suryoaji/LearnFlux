package com.idesolusiasia.learnflux.entity;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by NAIT ADMIN on 13/06/2016.
 */
public class Converter {
	public static Thread convertThread(JSONObject obj)throws JSONException
		{
			Gson gson = new Gson();
			Thread tr = gson.fromJson(obj.toString(), Thread.class);
			return tr;
		}
}
