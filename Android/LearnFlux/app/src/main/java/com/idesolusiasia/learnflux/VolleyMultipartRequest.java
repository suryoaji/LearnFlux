package com.idesolusiasia.learnflux;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkResponse;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyLog;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.EndpointAPI;
import com.idesolusiasia.learnflux.util.Template;
import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.entity.mime.MultipartEntityBuilder;
import cz.msebera.android.httpclient.entity.mime.content.FileBody;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Ide Solusi Asia on 10/20/2016.
 */
public class VolleyMultipartRequest extends Request<String> {

    private Response.Listener<String> mListener;
    private cz.msebera.android.httpclient.HttpEntity mHttpEntity;

    public VolleyMultipartRequest(Response.ErrorListener errorListener,Response.Listener listener, File file) {
        super(Method.PUT, EndpointAPI.urls, errorListener);
        mListener = listener;
        mHttpEntity = buildMultipartEntity(file);

    }

    private HttpEntity buildMultipartEntity(File file) {
        MultipartEntityBuilder builder = MultipartEntityBuilder.create();
        FileBody fileBody = new FileBody(file);
        builder.addPart(Template.Query.KEY_IMAGE, fileBody);
        builder.addTextBody(Template.Query.KEY_DIRECTORY, Template.Query.VALUE_DIRECTORY);
        return builder.build();
    }

    @Override
    public Map<String,String> getHeaders() throws AuthFailureError {
        Map<String, String> headers = super.getHeaders();
        if(headers == null || headers.equals(Collections.emptyMap())){
            headers = new HashMap<>();
        }
        headers.put("Content-Type", "application/image");
        headers.put("Authorization", "Bearer " + User.getUser().getAccess_token());
        return headers;
    }
    @Override
    public String getBodyContentType() {
        return mHttpEntity.getContentType().getValue();
    }

    @Override
    public byte[] getBody() throws AuthFailureError {

        ByteArrayOutputStream bos = new ByteArrayOutputStream();

        try {
            mHttpEntity.writeTo(bos);
            return bos.toByteArray();
        } catch (IOException e) {
            VolleyLog.e("" + e);
            return null;
        } catch (OutOfMemoryError e){
            VolleyLog.e("" + e);
            return null;
        }

    }

    @Override
    protected Response<String> parseNetworkResponse(NetworkResponse response) {
        try {
            return Response.success(new String(response.data, "UTF-8"),
                    getCacheEntry());
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return Response.success(new String(response.data),
                    getCacheEntry());
        }
    }

    @Override
    protected void deliverResponse(String response) {
        mListener.onResponse(response);
    }

}