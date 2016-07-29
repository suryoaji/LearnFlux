package com.idesolusiasia.learnflux.util;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import com.idesolusiasia.learnflux.LoginActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.db.DatabaseFunction;
import com.idesolusiasia.learnflux.entity.Organizations;
import com.idesolusiasia.learnflux.entity.Thread;
import com.idesolusiasia.learnflux.entity.User;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by NAIT ADMIN on 07/06/2016.
 */
public class Engine {
	public static void login(final Context context, final String username, final String password,
	                         final RequestTemplate.ServiceCallback callback, final RequestTemplate.ErrorCallback errorCallback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_LOGIN);
		HashMap<String,String> params = new HashMap<>();
		params.put("username",username);
		params.put("password",password);
		params.put("grant_type","password");
		params.put("client_id",context.getString(R.string.client_id));
		params.put("client_secret",context.getString(R.string.client_secret));
		params.put("scope","internal");
		Log.i("map", "getParams: "+params.toString());


		RequestTemplate.OAuth(context, url, params, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				Log.i("response",obj.toString());
				try {
					User.getUser().setAccess_token(obj.getString("access_token"));
					User.getUser().setUsername(username);
					User.getUser().setPassword(password);
					Functions.saveLastSync(context,"0");
					if (callback!=null){
						callback.execute(obj);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}

			}
		}, new RequestTemplate.ErrorCallback() {
			@Override
			public void execute(JSONObject error) {
				if (error!=null){
					try {
						String message = error.getString("error_description");
						Functions.showAlert(context,"Error", message);
						if (errorCallback!=null){
							errorCallback.execute(error);
						}


					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			}

		});
	}

	public static void reLogin(final Context context, final RequestTemplate.ServiceCallback reDo){
		login(context, User.getUser().getUsername(), User.getUser().getPassword(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				getMe(context);
				if (reDo!=null){
					reDo.execute(obj);
				}

			}
		}, new RequestTemplate.ErrorCallback() {
			@Override
			public void execute(JSONObject error) {
				Intent i = new Intent(context, LoginActivity.class);
				i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_CLEAR_TASK);
				context.startActivity(i);

			}
		});
	}

	public static void getMe(final Context context){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_ME);

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, null);
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					Log.i("response_ME", obj.toString());
					try {
						User.getUser().setID(obj.getJSONObject("data").getInt("id"));
						User.getUser().setEmail(obj.getJSONObject("data").getString("email"));

					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			},null);
		}

	}

	public static void getMyFriend(final Context context, final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_FRIEND);

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, null);
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					Log.i("GET_FRIEND", obj.toString());
					if (callback!=null){
						callback.execute(obj);
					}
				}
			},null);
		}

	}

	public static void createThread(final Context context, final int[] ids, final String title, final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_MESSAGES);
		HashMap<String,int[]> par = new HashMap<>();
		par.put("participants",ids);
		JSONObject params = new JSONObject(par);
		try {
			params.put("title", title);
		} catch (JSONException e) {
			e.printStackTrace();
		}

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					createThread(context, ids, title, callback);
				}
			});
		}else {
			RequestTemplate.POSTJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					if (obj!=null){
						Log.i("response_POST_MSG", obj.toString());
						//Engine.getThreads(context,callback,0);
						/*try {
							Log.i("response_POST_MSG", obj.getJSONObject("data").getString("type"));
							Log.i("response_POST_MSG", obj.getJSONObject("data").getString("id"));
						} catch (JSONException e) {
							e.printStackTrace();
						}*/if (callback!=null){
							callback.execute(obj);
						}

					}

				}
			},null);
		}
	}

	public static void getThreads(final Context context, final RequestTemplate.ServiceCallback callback){
		String lastSync = Functions.getLastSync(context);
		Log.i("lastSync", lastSync);
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_MESSAGES)+"?lastSync="+lastSync;
		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getThreads(context,callback);
				}
			});
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {

					Log.i("response_GET_Threads", obj.toString());
					try {
						Log.i("lastSync", "save "+obj.getString("lastSync"));
						Functions.saveLastSync(context,obj.getString("lastSync"));

						JSONArray array = obj.getJSONArray("data");
						ArrayList<Thread> arrThread = new ArrayList<Thread>();
						for(int i=0;i<array.length();i++){
							Thread t = Converter.convertThread(array.getJSONObject(i));
							arrThread.add(t);
						}
						DatabaseFunction.insertThread(context,arrThread);
						if (callback!=null){
							callback.execute(obj);
						}
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			},null);


		}
	}


	public static void deleteThread(final Context context, final List<Thread> deleted,
	                                final RequestTemplate.ServiceCallback callback) {
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_MESSAGES);
		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					deleteThread(context,deleted,callback);
				}
			});
		}else {
			String[] ids = new String[deleted.size()];
			for (int i = 0; i < deleted.size(); i++) {
				ids[i]=deleted.get(i).getId();
			}
			HashMap<String,String[]> hashMap = new HashMap<>();
			hashMap.put("ids",ids);
			JSONObject params = new JSONObject(hashMap);
			Log.i("params_delete", params.toString());
			RequestTemplate.DELETEJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					DatabaseFunction.deleteThread(context,deleted);
					if (obj!=null && callback!=null){
						callback.execute(obj);
					}

				}
			}, new RequestTemplate.ErrorCallback() {
				@Override
				public void execute(JSONObject error) {
					if (error!=null){
						try {
							JSONArray messages = error.getJSONObject("errors").getJSONArray("messages");
							Toast.makeText(context, messages.toString(), Toast.LENGTH_SHORT).show();
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}
				}
			});
		}
	}
	public static void registerUser(final Context context, final HashMap<String,String> par){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_REGISTER);
		JSONObject params = new JSONObject(par);

		RequestTemplate.POSTJsonRequestWithoutAuth(context, url, params, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				if (obj != null) {
					Log.i("response_POST_MSG", obj.toString());
					Intent i = new Intent(context,LoginActivity.class);
					i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_NEW_TASK);
					context.startActivity(i);
				}
				Functions.showAlert(context, context.getString(R.string.URL_REGISTER), context.getString(R.string.success_registration));
			}
		}, new RequestTemplate.ErrorCallback() {
			@Override
			public void execute(JSONObject error) {
				if (error!=null){
					try {
						JSONArray messages = error.getJSONObject("errors").getJSONArray("messages");
						if (messages.toString().contains("have successfully registered")){
							Intent i = new Intent(context,LoginActivity.class);
							i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_NEW_TASK);
							context.startActivity(i);
						}else{
							Functions.showAlert(context,"Errors",messages.toString());
						}

					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			}
		});
	}

	public static void getThreadMessages(final Context context, final RequestTemplate.ServiceCallback callback,
	                                     final String idThread){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_THREAD_MESSAGES,idThread);
		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					getThreadMessages(context, callback, idThread);
				}
			});
		}else {
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					Log.i("response_GET_Messages", obj.toString());
					try {
						JSONArray array = obj.getJSONArray("data");
						ArrayList<Thread> arrThread = new ArrayList<Thread>();
						for(int i=0;i<array.length();i++){
							Thread t = Converter.convertThread(array.getJSONObject(i));
							arrThread.add(t);
						}
						DatabaseFunction.insertThread(context,arrThread);
						if (callback!=null){
							callback.execute(obj);
						}

					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			},null);
		}
	}

	public static void sendMessage(final Context context, final String idThread, final String message, final RequestTemplate.ServiceCallback callback){
		String url=context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+
				context.getString(R.string.URL_THREAD_MESSAGES,idThread);

		JSONObject params = new JSONObject();
		try {
			params.put("body", message);
		} catch (JSONException e) {
			e.printStackTrace();
		}

		if (User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					sendMessage(context, idThread, message, callback);
				}
			});
		}else {
			RequestTemplate.POSTJsonRequest(context, url, params, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {

					if (obj!=null){
						Log.i("send_message", obj.toString());
					}
					callback.execute(obj);
				}
			},null);
		}
	}
	public static void getOrganizations(final Context context,final RequestTemplate.ServiceCallback callback){
		String url = context.getString(R.string.BASE_URL)+context.getString(R.string.URL_VERSION)+context.getString(R.string.URL_ORGANIZATIONS);
		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context, null);
		}else{
			RequestTemplate.GETJsonRequest(context, url, null, new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					Log.i("Organization_Response", "execute: " + obj.toString());
					if(callback!=null){
						callback.execute(obj);
					}

				}
			},null);
		}
	}
	public static void getOrganizationProfile(final Context context, final String idGroup, final RequestTemplate.ServiceCallback callback){
		String url= context.getString(R.string.BASE_URL)+ context.getString(R.string.URL_VERSION)+ context.getString(R.string.URL_ORGANIZATIONS_PROFILE, idGroup);
		if(User.getUser().getAccess_token().isEmpty() || User.getUser().getAccess_token().equals("")){
			reLogin(context,null);
		}else{
			RequestTemplate.GETJsonRequest(context,url,null,new RequestTemplate.ServiceCallback() {
				@Override
				public void execute(JSONObject obj) {
					Log.i("Org_profile", "execute: " + obj.toString());

						if(callback!=null){
							callback.execute(obj);
						}
				}
			},null);
		}
	}




}
