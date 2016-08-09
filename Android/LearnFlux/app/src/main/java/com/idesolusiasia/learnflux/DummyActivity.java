package com.idesolusiasia.learnflux;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Base64;
import android.util.Log;
import android.widget.EditText;
import android.widget.ImageView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;

public class DummyActivity extends AppCompatActivity {
	ImageView imageView;
	String access_token="";
	private static final String TAG = "Dummy";
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_dummy);
		final EditText et = (EditText) findViewById(R.id.editText);
		//Button btnLoad=(Button) findViewById(R.id.btnLoad);
		imageView = (ImageView) findViewById(R.id.imageView);
		imageView.setImageResource(R.drawable.lasalle_logo);
		/*String url ="http://img2.10bestmedia.com/Images/Photos/96123/captiva-beach-captiva_54_990x660_201404211817.jpg";
		imageView.setImageUrl(url, VolleySingleton.getInstance(getApplicationContext()).getImageLoader());

		btnLoad.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				imageView.setImageUrl(et.getText().toString(), VolleySingleton.getInstance(getApplicationContext()).getImageLoader());

			}
		});*/
		login(imageView);

	}

	void login(ImageView iv){
		String url="https://ap2.salesforce.com/services/oauth2/token";
		HashMap<String,String> params = new HashMap<>();
		params.put("username","gianrishandy@naitconsulting.com");
		params.put("password","Anj1ng99q8SnkE9RPcqmscJOeyrZNTuJ");
		params.put("grant_type","password");
		params.put("client_id","3MVG9ZL0ppGP5UrBYr_My.W638A.uAa7roi3EBb_8_ARA3XKzbqufDV_k8GqvdbA9ANa4xLPnh_5pMHxnXPs2");
		params.put("client_secret","8212684703388023528");
		Log.i("map", "getParams: "+params.toString());


		OAuth(this, url, params, null,null, iv);
	}

	void getPhoto(ImageView iv){
		String url= "https://ap2.salesforce.com/services/apexrest/RestAPI";
		GETStringRequest(this, url,iv);
	}

	public static String encodeToBase64(Bitmap image, Bitmap.CompressFormat compressFormat, int quality)
	{
		ByteArrayOutputStream byteArrayOS = new ByteArrayOutputStream();
		image.compress(compressFormat, quality, byteArrayOS);
		return Base64.encodeToString(byteArrayOS.toByteArray(), Base64.DEFAULT);
	}

	public static Bitmap decodeBase64(String input)
	{
		byte[] decodedBytes = Base64.decode(input.getBytes(), Base64.DEFAULT);
		return BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.length);
	}

	private void GETStringRequest(final Context context, final String url, final ImageView iv){

		StringRequest req = new StringRequest(Request.Method.GET, url, new Response.Listener<String>() {
			@Override
			public void onResponse(String response) {
				try {
					JSONArray arrData = new JSONArray(response);

					JSONObject data1 = arrData.getJSONObject(0);
					String body = data1.getString("Body");
					Bitmap bmp = decodeBase64(body);

					iv.setImageBitmap(bmp);

				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {

			}
		})
		{
			@Override
			public Map<String,String> getHeaders() throws AuthFailureError {
				Map<String,String> params = new HashMap<String,String>();
				params.put("Content-Type","application/json");
				params.put("Authorization", "OAuth " + access_token);
				return params;
			}
			@Override
			public String getBodyContentType() {
				return "application/json; charset=utf-8";
			}
		};

		VolleySingleton.getInstance(context).addToRequestQueue(req);
	}

	void OAuth(final Context context, String url, final Map<String,String> params,
	           final RequestTemplate.ServiceCallback callback, final RequestTemplate.ErrorCallback errorCallback, final ImageView iv){

		StringRequest req = new StringRequest(Request.Method.POST, url, new Response.Listener<String>() {
			@Override
			public void onResponse(String response) {
				try {
					JSONObject obj = new JSONObject(response);
					Log.i("response",obj.toString());
					access_token= obj.getString("access_token");
					getPhoto(iv);

				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {

			}
		})
		{
			@Override
			protected Map<String, String> getParams() throws AuthFailureError {
				return params;
			}

			@Override
			public Map<String, String> getHeaders() throws AuthFailureError {

				//This appears in the log
				Log.d(TAG,"Does it assign headers?") ;

				HashMap<String, String> headers = new HashMap<String, String>();
				headers.put("Content-Type","application/x-www-form-urlencoded");
				return headers;
			}
		};

		/*StringRequest request = new StringRequest(Request.Method.POST, url, new JSONObject(params),
				new Response.Listener<JSONObject>() {
					@Override
					public void onResponse(JSONObject response) {
						callback.execute(response);
					}
				}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {
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
		});*/
		VolleySingleton.getInstance(context).addToRequestQueue(req);
	}
}
