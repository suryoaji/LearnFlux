package com.idesolusiasia.learnflux.util;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.NoConnectionError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.TimeoutError;
import com.android.volley.VolleyError;
import com.idesolusiasia.learnflux.entity.User;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by NAIT ADMIN on 06/06/2016.
 */
public class RequestTemplate {

	private static final String TAG  = RequestTemplate.class.getSimpleName();
	public interface ServiceCallback {
		void execute(JSONObject obj);
	}
	public interface ErrorCallback {
		void execute(JSONObject error);
	}
	public static void OAuth(final Context context, String url, final Map<String,String> params,
	                         final ServiceCallback callback, final ErrorCallback errorCallback){

		JsonObjectRequestWithNull request = new JsonObjectRequestWithNull(Request.Method.POST, url, new JSONObject(params),
				new Response.Listener<JSONObject>() {
					@Override
					public void onResponse(JSONObject response) {
						callback.execute(response);
					}
				}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {
				/*if (error.networkResponse!=null){
					if (error.networkResponse.statusCode==400) {
						Toast.makeText(context, "400", Toast.LENGTH_SHORT).show();
					}
				}*/
				if(error instanceof TimeoutError || error instanceof NoConnectionError){
					Toast.makeText(context,"Connection Timeout",Toast.LENGTH_SHORT).show();
				}else {
					Log.i(TAG, error.getMessage());
					if (errorCallback!=null){
						try {
							errorCallback.execute(new JSONObject(error.getMessage()));
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}
				}
			}
		});
		VolleySingleton.getInstance(context).addToRequestQueue(request);
	}


	public static void POSTJsonRequest(final Context context, final String url, final JSONObject params,
	                                    final ServiceCallback callback, final ErrorCallback errorCallback){
		Log.i(TAG, "params: "+params.toString());
		final JsonObjectRequestWithNull jsonObjectRequest = new JsonObjectRequestWithNull(Request.Method.POST, url, params, new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject response) {
				callback.execute(response);
			}
		},new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {
				if(error instanceof TimeoutError || error instanceof NoConnectionError){
					Toast.makeText(context,"Connection Timeout",Toast.LENGTH_SHORT).show();
				}else {
					Log.i(TAG, error.getMessage());
					if(error.getMessage().contains("token")){
						Engine.reLogin(context, new ServiceCallback() {
							@Override
							public void execute(JSONObject obj) {
								POSTJsonRequest(context, url, params, callback, errorCallback);
							}
						});
					}else{
						if (error.networkResponse!=null){
							Log.i(TAG, String.valueOf(error.networkResponse.statusCode));
						}
						if (errorCallback!=null){
							try {
								errorCallback.execute(new JSONObject(error.getMessage()));
							} catch (JSONException e) {
								e.printStackTrace();
							}
						}
					}
				}
			}
		}){
			@Override
			public Map<String,String> getHeaders() throws AuthFailureError {
				Map<String,String> params = new HashMap<String,String>();
				params.put("Content-Type","application/json; charset=utf-8");
				params.put("Authorization", "Bearer " + User.getUser().getAccess_token());

				return params;
			}

			@Override
			public String getBodyContentType() {
				return "application/json; charset=utf-8";
			}

		};
		VolleySingleton.getInstance(context).addToRequestQueue(jsonObjectRequest);
	}

	public static void POSTJsonRequestWithoutAuth(final Context context, final String url, final JSONObject params,
	                                   final ServiceCallback callback, final ErrorCallback errorCallback){
		Log.i(TAG, "params: "+params.toString());
		final JsonObjectRequestWithNull jsonObjectRequest = new JsonObjectRequestWithNull(Request.Method.POST, url, params, new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject response) {
				callback.execute(response);
			}
		},new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {
				if(error instanceof TimeoutError || error instanceof NoConnectionError){
					Toast.makeText(context,"Connection Timeout",Toast.LENGTH_SHORT).show();
				}else {
					Log.i(TAG, error.getMessage());
					if (error.networkResponse!=null){
						Log.i(TAG, String.valueOf(error.networkResponse.statusCode));
					}
					if (errorCallback!=null){
						try {
							errorCallback.execute(new JSONObject(error.getMessage()));
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}
				}
			}
		}){
			@Override
			public Map<String,String> getHeaders() throws AuthFailureError {
				Map<String,String> params = new HashMap<String,String>();
				params.put("Content-Type","application/json; charset=utf-8");

				return params;
			}

			@Override
			public String getBodyContentType() {
				return "application/json; charset=utf-8";
			}

		};
		VolleySingleton.getInstance(context).addToRequestQueue(jsonObjectRequest);
	}

	public static void DELETEJsonRequest(final Context context, final String url, final JSONObject params,
	                                     final ServiceCallback callback, final ErrorCallback errorCallback){
		Log.i(TAG, "params: "+params.toString());
		final JsonObjectRequestWithNull jsonObjectRequest = new JsonObjectRequestWithNull(Request.Method.DELETE, url, params, new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject response) {
				callback.execute(response);
			}
		},new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {
				if(error instanceof TimeoutError || error instanceof NoConnectionError){
					Toast.makeText(context,"Connection Timeout",Toast.LENGTH_SHORT).show();
				}else {
					Log.i(TAG, error.getMessage());
					if(error.getMessage().contains("token")){
						Engine.reLogin(context, new ServiceCallback() {
							@Override
							public void execute(JSONObject obj) {
								DELETEJsonRequest(context, url, params, callback, errorCallback);
							}
						});
					}else{
						if (error.networkResponse!=null){
							Log.i(TAG, String.valueOf(error.networkResponse.statusCode));
						}
						if (errorCallback!=null){
							try {
								errorCallback.execute(new JSONObject(error.getMessage()));
							} catch (JSONException e) {
								e.printStackTrace();
							}
						}
					}
				}
			}
		}){
			@Override
			public Map<String,String> getHeaders() throws AuthFailureError {
				Map<String,String> params = new HashMap<String,String>();
				params.put("Content-Type","application/json; charset=utf-8");
				params.put("Authorization", "Bearer " + User.getUser().getAccess_token());

				return params;
			}

			@Override
			public String getBodyContentType() {
				return "application/json; charset=utf-8";
			}

		};

		VolleySingleton.getInstance(context).addToRequestQueue(jsonObjectRequest);
	}


	public static void GETJsonRequest(final Context context, final String url, final JSONObject params,
	                                  final ServiceCallback callback, final ErrorCallback errorCallback){

		final JsonObjectRequestWithNull jsonObjectRequest = new JsonObjectRequestWithNull(Request.Method.GET, url, params, new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject response) {
				callback.execute(response);
			}
		},new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {
				if(error instanceof TimeoutError || error instanceof NoConnectionError){
					Toast.makeText(context,"Connection Timeout",Toast.LENGTH_SHORT).show();
				}else {
					Log.i(TAG, error.getMessage());
					if(error.getMessage().contains("token")){
						Engine.reLogin(context, new ServiceCallback() {
							@Override
							public void execute(JSONObject obj) {
								GETJsonRequest(context, url, params, callback, errorCallback);
							}
						});
					}else{
						if (error.networkResponse!=null){
							Log.i(TAG, String.valueOf(error.networkResponse.statusCode));
						}
						if (errorCallback!=null){
							try {
								errorCallback.execute(new JSONObject(error.getMessage()));
							} catch (JSONException e) {
								e.printStackTrace();
							}
						}
					}
				}

			}
		}){
			@Override
			public Map<String,String> getHeaders() throws AuthFailureError {
				Map<String,String> params = new HashMap<String,String>();
				params.put("Content-Type","application/json");
				params.put("Authorization", "Bearer " + User.getUser().getAccess_token());
				return params;
			}
			@Override
			public String getBodyContentType() {
				return "application/json; charset=utf-8";
			}
		};

		VolleySingleton.getInstance(context).addToRequestQueue(jsonObjectRequest);
	}
}
