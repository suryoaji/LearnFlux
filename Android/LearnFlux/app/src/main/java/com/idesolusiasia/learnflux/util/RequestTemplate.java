package com.idesolusiasia.learnflux.util;

import android.content.Context;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkError;
import com.android.volley.NoConnectionError;
import com.android.volley.ParseError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.ServerError;
import com.android.volley.TimeoutError;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.idesolusiasia.learnflux.entity.User;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by NAIT ADMIN on 06/06/2016.
 */
public class RequestTemplate {
	public interface serviceCallback{
		void execute(JSONObject obj);
	}
	public static void OAuth(final Context context, String url, final Map<String,String> params, final serviceCallback callback){
		final StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
				new Response.Listener<String>() {
					@Override
					public void onResponse(String response) {
						try {
							JSONObject obj = new JSONObject(response);
							callback.execute(obj);
						}catch(JSONException e){
							e.printStackTrace();
						}
					}
				},
				new Response.ErrorListener() {
					@Override
					public void onErrorResponse(VolleyError error) {
						if(error instanceof TimeoutError || error instanceof NoConnectionError){
							Toast.makeText(context,"Connection Timeout",Toast.LENGTH_SHORT).show();
						}else if(error instanceof AuthFailureError){
							Toast.makeText(context,"Authentic Error",Toast.LENGTH_SHORT).show();
						}else if(error instanceof ServerError){
							Toast.makeText(context,"Server Error",Toast.LENGTH_SHORT).show();
						}else if(error instanceof NetworkError){
							Toast.makeText(context,"Network Error",Toast.LENGTH_SHORT).show();
						}else if(error instanceof ParseError){
							Toast.makeText(context,"Parse Error",Toast.LENGTH_SHORT).show();
						}else
							Toast.makeText(context,error.toString(),Toast.LENGTH_LONG ).show();
					}
				}){
			@Override
			protected Map<String, String> getParams() throws AuthFailureError {
				return params;
			}
		};

		VolleySingleton.getInstance(context).addToRequestQueue(stringRequest);

	}



	public static void POSTStringRequest(final Context context, String url, final JSONObject params, final serviceCallback callback){
		final String requestBody = params.toString();

		final StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
				new Response.Listener<String>() {
					@Override
					public void onResponse(String response) {
						try {
							JSONObject obj = new JSONObject(response);
							callback.execute(obj);
						}catch(JSONException e){
							e.printStackTrace();
						}
					}
				},
				new Response.ErrorListener() {
					@Override
					public void onErrorResponse(VolleyError error) {
						if(error instanceof TimeoutError || error instanceof NoConnectionError){
							Toast.makeText(context,"Connection Timeout",Toast.LENGTH_SHORT).show();
						}else if(error instanceof AuthFailureError){
							Toast.makeText(context,"Authentic Error",Toast.LENGTH_SHORT).show();
						}else if(error instanceof ServerError){
							Toast.makeText(context,"Server Error",Toast.LENGTH_SHORT).show();
						}else if(error instanceof NetworkError){
							Toast.makeText(context,"Network Error",Toast.LENGTH_SHORT).show();
						}else if(error instanceof ParseError){
							Toast.makeText(context,"Parse Error",Toast.LENGTH_SHORT).show();
						}else
							Toast.makeText(context,error.toString(),Toast.LENGTH_LONG ).show();
					}
				}
		){
			/*@Override
			protected Map<String, String> getParams() throws AuthFailureError {
				Log.i("params", params.toString());
				return params;
			}*/

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

			@Override
			public byte[] getBody() throws AuthFailureError {
				try {
					return requestBody == null ? null : requestBody.getBytes("utf-8");
				} catch (UnsupportedEncodingException uee) {
					VolleyLog.wtf("Unsupported Encoding while trying to get the bytes of %s using %s",
							requestBody, "utf-8");
					return null;
				}
			}
		};

		VolleySingleton.getInstance(context).addToRequestQueue(stringRequest);
	}

	public static void POSTJsonRequest(final Context context, String url, final JSONObject params, final serviceCallback callback){

		final JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.POST, url, params, new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject response) {
				callback.execute(response);
			}
		},new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {
				if(error instanceof TimeoutError || error instanceof NoConnectionError){
					Toast.makeText(context,"Connection Timeout",Toast.LENGTH_SHORT).show();
				}else if(error instanceof AuthFailureError){
					Toast.makeText(context,"Authentic Error",Toast.LENGTH_SHORT).show();
				}else if(error instanceof ServerError){
					Toast.makeText(context,"Server Error",Toast.LENGTH_SHORT).show();
				}else if(error instanceof NetworkError){
					Toast.makeText(context,"Network Error",Toast.LENGTH_SHORT).show();
				}else if(error instanceof ParseError){
					Toast.makeText(context,"Parse Error",Toast.LENGTH_SHORT).show();
				}else
					Toast.makeText(context,error.toString(),Toast.LENGTH_LONG ).show();
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

	public static void GETJsonRequest(final Context context,String url, final Map<String,String> params, final serviceCallback callback){
		JSONObject par;
		if (params==null){
			par=null;
		}else {
			par=new JSONObject(params);
		}

		final JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, url, par, new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject response) {
				callback.execute(response);
			}
		},new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {
				if(error instanceof TimeoutError || error instanceof NoConnectionError){
					Toast.makeText(context,"Connection Timeout",Toast.LENGTH_SHORT).show();
				}else if(error instanceof AuthFailureError){
					Toast.makeText(context,"Authentic Error",Toast.LENGTH_SHORT).show();
				}else if(error instanceof ServerError){
					Toast.makeText(context,"Server Error",Toast.LENGTH_SHORT).show();
				}else if(error instanceof NetworkError){
					Toast.makeText(context,"Network Error",Toast.LENGTH_SHORT).show();
				}else if(error instanceof ParseError){
					Toast.makeText(context,"Parse Error",Toast.LENGTH_SHORT).show();
				}else
					Toast.makeText(context,error.toString(),Toast.LENGTH_LONG ).show();
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
