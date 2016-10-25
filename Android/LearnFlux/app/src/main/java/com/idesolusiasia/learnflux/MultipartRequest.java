package com.idesolusiasia.learnflux;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkResponse;
import com.android.volley.ParseError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.HttpHeaderParser;
import com.google.gson.JsonSyntaxException;
import com.idesolusiasia.learnflux.entity.User;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import cz.msebera.android.httpclient.entity.ContentType;
import cz.msebera.android.httpclient.entity.mime.HttpMultipartMode;
import cz.msebera.android.httpclient.entity.mime.MultipartEntityBuilder;

/**
 * Created by Ide Solusi Asia on 10/21/2016.
 */

public class MultipartRequest extends Request<NetworkResponse> {
    private MultipartEntityBuilder mBuilder = MultipartEntityBuilder.create();
    private final Response.Listener<NetworkResponse> mListener;
    private final File yourImageFile;

    public MultipartRequest(String url, Response.ErrorListener errorListener, Response.Listener<NetworkResponse> listener, File imageFile)   {
        super(Method.PUT, url, errorListener);
        mListener = listener;
        yourImageFile = imageFile;
        addImageEntity();
    }

    @Override
    public Map<String, String> getHeaders() throws AuthFailureError {
        Map<String, String> params = new HashMap<>();
        params.put("Content-Type", "application/image");
        params.put("Authorization", "Bearer " + User.getUser().getAccess_token());
        return params;
    }

    private void addImageEntity() {
        mBuilder.addBinaryBody("photo", yourImageFile, ContentType.create("image/jpeg"), yourImageFile.getName());
        mBuilder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);
        mBuilder.setLaxMode().setBoundary("xx").setCharset(Charset.forName("UTF-8"));
    }

    @Override
    public String getBodyContentType()   {
        String content = "Application/image";
        return content;
    }

    @Override
    public byte[] getBody() throws AuthFailureError    {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        try {
            mBuilder.build().writeTo(bos);
        } catch (IOException e){
            VolleyLog.e("IOException writing to ByteArrayOutputStream bos, building the multipart request.");
        }
        return bos.toByteArray();
    }

    @Override
    protected Response<NetworkResponse> parseNetworkResponse(NetworkResponse response){
        NetworkResponse result = null;
        return Response.success(result, HttpHeaderParser.parseCacheHeaders(response));
    }

    @Override
    protected void deliverResponse(NetworkResponse response) {
        mListener.onResponse(response);
    }
}