package com.idesolusiasia.learnflux.util;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.http.AndroidHttpClient;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.HttpStack;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.Volley;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpEntityEnclosingRequestBase;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpHead;
import org.apache.http.client.methods.HttpOptions;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpTrace;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;

import java.io.IOException;
import java.net.URI;
import java.util.Map;


/**
 * Created by NAIT ADMIN on 22/12/2015.
 */
public class VolleySingleton {

    private static VolleySingleton mInstance;
    private RequestQueue mRequestQueue;
    private ImageLoader mImageLoader;
    private static Context mCtx;

    private VolleySingleton(Context context) {
        mCtx = context.getApplicationContext();
	    mRequestQueue = getRequestQueue();

        /*mImageLoader = new ImageLoader(mRequestQueue,
                new ImageLoader.ImageCache() {
                    private final LruCache<String, Bitmap>
                            cache = new LruCache<String, Bitmap>(20);

                    @Override
                    public Bitmap getBitmap(String url) {
                        return cache.get(url);
                    }

                    @Override
                    public void putBitmap(String url, Bitmap bitmap) {
                        cache.put(url, bitmap);
                    }
                });*/

        mImageLoader = new ImageLoader(mRequestQueue, new LruBitmapCache(
                LruBitmapCache.getCacheSize(context)));
    }

    public static synchronized VolleySingleton getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new VolleySingleton(context.getApplicationContext());
        }
        return mInstance;
    }

    public RequestQueue getRequestQueue() {
        if (mRequestQueue == null) {
            // getApplicationContext() is key, it keeps you from leaking the
            // Activity or BroadcastReceiver if someone passes one in.
            mRequestQueue = Volley.newRequestQueue(mCtx.getApplicationContext());
	        String userAgent = "volley/0";
	        try {
		        String packageName = mCtx.getApplicationContext().getPackageName();
		        PackageInfo info = mCtx.getApplicationContext().getPackageManager().getPackageInfo(packageName, 0);
		        userAgent = packageName + "/" + info.versionCode;
	        } catch (PackageManager.NameNotFoundException e) {}
	        HttpStack httpStack = new OwnHttpClientStack( AndroidHttpClient.newInstance(userAgent));
	        mRequestQueue = Volley.newRequestQueue(mCtx.getApplicationContext(), httpStack);
        }
        return mRequestQueue;
    }

    public <T> void addToRequestQueue(Request<T> req) {
        getRequestQueue().add(req);
    }

    public ImageLoader getImageLoader() {
        return mImageLoader;
    }

    public void deleteImageCache(String url){
        mRequestQueue.getCache().remove(url);
        mRequestQueue.getCache().invalidate(url, true);
    }

}

class OwnHttpClientStack extends com.android.volley.toolbox.HttpClientStack {
	private final static String HEADER_CONTENT_TYPE = "Content-Type";

	public OwnHttpClientStack(HttpClient client) {
		super(client);


	}

	@Override
	public HttpResponse performRequest(Request<?> request, Map<String, String> additionalHeaders)
			throws IOException, AuthFailureError {
		HttpUriRequest httpRequest = createHttpRequest(request, additionalHeaders);
		addHeaders(httpRequest, additionalHeaders);
		addHeaders(httpRequest, request.getHeaders());
		onPrepareRequest(httpRequest);
		HttpParams httpParams = httpRequest.getParams();
		int timeoutMs = request.getTimeoutMs();
		// TODO: Reevaluate this connection timeout based on more wide-scale
		// data collection and possibly different for wifi vs. 3G.
		HttpConnectionParams.setConnectionTimeout(httpParams, 5000);
		HttpConnectionParams.setSoTimeout(httpParams, timeoutMs);
		return mClient.execute(httpRequest);
	}

	private static void addHeaders(HttpUriRequest httpRequest, Map<String, String> headers) {
		for (String key : headers.keySet()) {
			httpRequest.setHeader(key, headers.get(key));
		}
	}

	static HttpUriRequest createHttpRequest(Request<?> request, Map<String, String> additionalHeaders) throws AuthFailureError {
		switch (request.getMethod()) {
			case Request.Method.DEPRECATED_GET_OR_POST: {
				byte[] postBody = request.getPostBody();
				if (postBody != null) {
					HttpPost postRequest = new HttpPost(request.getUrl());
					postRequest.addHeader(HEADER_CONTENT_TYPE, request.getPostBodyContentType());
					HttpEntity entity;
					entity = new ByteArrayEntity(postBody);
					postRequest.setEntity(entity);
					return postRequest;
				} else {
					return new HttpGet(request.getUrl());
				}
			}
			case Request.Method.GET:
				return new HttpGet(request.getUrl());
			case Request.Method.DELETE:
				OwnHttpDelete deleteRequest =  new OwnHttpDelete(request.getUrl());
				deleteRequest.addHeader(HEADER_CONTENT_TYPE, request.getBodyContentType());
				setEntityIfNonEmptyBody(deleteRequest, request);
				return deleteRequest;
			case Request.Method.POST: {
				HttpPost postRequest = new HttpPost(request.getUrl());
				postRequest.addHeader(HEADER_CONTENT_TYPE, request.getBodyContentType());
				setEntityIfNonEmptyBody(postRequest, request);
				return postRequest;
			}
			case Request.Method.PUT: {
				HttpPut putRequest = new HttpPut(request.getUrl());
				putRequest.addHeader(HEADER_CONTENT_TYPE, request.getBodyContentType());
				setEntityIfNonEmptyBody(putRequest, request);
				return putRequest;
			}
			case Request.Method.HEAD:
				return new HttpHead(request.getUrl());
			case Request.Method.OPTIONS:
				return new HttpOptions(request.getUrl());
			case Request.Method.TRACE:
				return new HttpTrace(request.getUrl());
			case Request.Method.PATCH: {
				HttpPatch patchRequest = new HttpPatch(request.getUrl());
				patchRequest.addHeader(HEADER_CONTENT_TYPE, request.getBodyContentType());
				setEntityIfNonEmptyBody(patchRequest, request);
				return patchRequest;
			}
			default:
				throw new IllegalStateException("Unknown request method.");
		}
	}

	private static void setEntityIfNonEmptyBody(HttpEntityEnclosingRequestBase httpRequest,
	                                            Request<?> request) throws AuthFailureError {
		byte[] body = request.getBody();
		if (body != null) {
			HttpEntity entity = new ByteArrayEntity(body);
			httpRequest.setEntity(entity);
		}
	}

	private static class OwnHttpDelete extends HttpPost {
		public static final String METHOD_NAME = "DELETE";

		public OwnHttpDelete() {
			super();
		}

		public OwnHttpDelete(URI uri) {
			super(uri);
		}

		public OwnHttpDelete(String uri) {
			super(uri);
		}

		public String getMethod() {
			return METHOD_NAME;
		}
	}
}
