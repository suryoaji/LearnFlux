package com.idesolusiasia.learnflux;

import java.util.HashMap;

import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.Multipart;
import retrofit2.http.PUT;
import retrofit2.http.Part;

/**
 * Created by Ide Solusi Asia on 10/24/2016.
 */

public interface Service {
    @Multipart
    @PUT("me/image?key=profile/1")
    Call<ResponseBody>
    putImage(@Header("Authorization")String authorization, @Part MultipartBody.Part image);
}
