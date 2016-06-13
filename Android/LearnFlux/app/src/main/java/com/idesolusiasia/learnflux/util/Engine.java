package com.idesolusiasia.learnflux.util;

import android.content.Context;
import android.util.Log;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.User;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by NAIT ADMIN on 07/06/2016.
 */
public class Engine {
	public static void login(Context context, final String username, final String password, final RequestTemplate.serviceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.LOGIN);
		HashMap<String,String> params = new HashMap<>();
		params.put("username",username);
		params.put("password",password);
		params.put("grant_type","password");
		params.put("client_id",context.getString(R.string.client_id));
		params.put("client_secret",context.getString(R.string.client_secret));
		params.put("scope","internal");
		Log.i("map", "getParams: "+params.toString());


		RequestTemplate.OAuth(context, url, params, new RequestTemplate.serviceCallback() {
			@Override
			public void execute(JSONObject obj) {
				Log.i("response",obj.toString());
				try {
					User.getUser().setAccess_token(obj.getString("access_token"));
					User.getUser().setUsername(username);
					User.getUser().setPassword(password);
					if (callback!=null){
						callback.execute(obj);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		});
	}

	public static void getMe(final Context context){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.ME);

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			login(context, User.getUser().getUsername(), User.getUser().getPassword(), new RequestTemplate.serviceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getMe(context);
				}
			});
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.serviceCallback() {
				@Override
				public void execute(JSONObject obj) {
					Log.i("response_ME", obj.toString());
				}
			});
		}

	}

	public static void postMessages(final Context context, final int[] ids){

		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.MESSAGES);
		HashMap<String,int[]> par = new HashMap<>();
		par.put("participants",ids);
		JSONObject params = new JSONObject(par);

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			login(context, User.getUser().getUsername(), User.getUser().getPassword(), new RequestTemplate.serviceCallback() {
				@Override
				public void execute(JSONObject obj) {
					postMessages(context,ids);
				}
			});
		}else {
			RequestTemplate.POSTJsonRequest(context, url, params, new RequestTemplate.serviceCallback() {
				@Override
				public void execute(JSONObject obj) {
					Log.i("response_POST_MSG", obj.toString());
					try {
						Log.i("response_POST_MSG", obj.getJSONObject("data").getString("type"));
						Log.i("response_POST_MSG", obj.getJSONObject("data").getString("id"));
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			});
		}

	}
}
