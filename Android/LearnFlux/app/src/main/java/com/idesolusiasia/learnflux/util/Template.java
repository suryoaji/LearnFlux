package com.idesolusiasia.learnflux.util;

/**
 * Created by Ide Solusi Asia on 10/21/2016.
 */

public interface Template {
    interface VolleyRetryPolicy{
        //Waktu upload hingga sebelum time out, jika koneksi lambat, perbesar nilai dibawah
        int SOCKET_TIMEOUT = 1000 * 100;
        //Berapa kali perulangan, setelah koneksi gagal
        int RETRIES = 0;
    }

    interface Query{
        //Penggunaan Key dan Value untuk Map<,> dan keperluan difile php
        String KEY_IMAGE = "image";
        String KEY_DIRECTORY = "directory";
        String VALUE_DIRECTORY = "Data";
        String KEY_CODE = "kode";
        String KEY_MESSAGE = "pesan";
        String VALUE_CODE_SUCCESS = "2";
        String VALUE_CODE_FAILED = "1";
        String VALUE_CODE_MISSING = "0";
    }

    interface Code{
        int CAMERA_IMAGE_CODE = 0;
        int CAMERA_VIDEO_CODE = 1;
        int FILE_MANAGER_CODE = 2;
        int AUDIO_CODE = 3;
    }
}
