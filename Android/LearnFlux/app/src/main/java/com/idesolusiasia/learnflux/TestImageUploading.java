package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.graphics.BitmapFactory;
import android.media.MediaPlayer;
import android.net.Uri;
import android.net.http.RequestQueue;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.VideoView;

import com.afollestad.materialdialogs.MaterialDialog;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.idesolusiasia.learnflux.util.Template;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import java.io.File;

/**
 * Created by Ide Solusi Asia on 10/21/2016.
 */

public class TestImageUploading extends AppCompatActivity {

    private Button mAdd, mUpload;
    private ImageView mImage, mController;
    private VideoView mVideo;
    private TextView mInfo, mResponse;
    private ProgressBar mProgress;
    private static String[] CHOOSE_FILE = {"Photo", "Video", "File manager"};
    private Uri mOutputUri;
    private File mFile;
    private VolleyMultipartRequest mMultiPartRequest;
    private MediaPlayer mMediaPlayer;
    private boolean mIsLoad = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    mAdd = (Button) findViewById(R.id.add);
    mUpload = (Button) findViewById(R.id.upload);
    mImage = (ImageView) findViewById(R.id.image);
    mController = (ImageView) findViewById(R.id.controller);
    mVideo = (VideoView) findViewById(R.id.video);
    mProgress = (ProgressBar) findViewById(R.id.progress);

    //Set video view untuk looping video
    mVideo.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
        @Override
        public void onPrepared(MediaPlayer mediaPlayer) {
            mediaPlayer.setLooping(true);
        }
    });

    mInfo = (TextView) findViewById(R.id.file_info);
    mResponse = (TextView) findViewById(R.id.response);
    resetView();

    //Set add button listener
    mAdd.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            if (((TextView) view).getText().equals("Delete")) {
                resetView();
                if (mIsLoad) {
                    mIsLoad = false;
                }

            } else {
                showDialog();
            }

        }
    });

    //Set upload button listener
    mUpload.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            uploadFile();
            mUpload.setVisibility(Button.INVISIBLE);
            mProgress.setVisibility(ProgressBar.VISIBLE);
            mIsLoad = true;

        }
    });
}

    //Respon dari add button ketika diklik, untuk memunculkan dialog
    void showDialog() {
        new MaterialDialog.Builder(TestImageUploading.this).title("Choose file")
                .items(CHOOSE_FILE)
                .itemsCallback(new MaterialDialog.ListCallback() {
                    @Override
                    public void onSelection(MaterialDialog materialDialog, View view, int i, CharSequence charSequence) {


                        if (i == 0) {
                            //Mengambil foto dengan camera
                            Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

                            mOutputUri = FileManager.getOutputMediaFileUri(Template.Code.CAMERA_IMAGE_CODE);

                            intent.putExtra(MediaStore.EXTRA_OUTPUT, mOutputUri);


                            startActivityForResult(intent, Template.Code.CAMERA_IMAGE_CODE);
                        } else if (i == 1) {
                            //Mengambil video dengan camera
                            Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);

                            mOutputUri = FileManager.getOutputMediaFileUri(Template.Code.CAMERA_VIDEO_CODE);


                            intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 1);

                            intent.putExtra(MediaStore.EXTRA_OUTPUT, mOutputUri);
                            startActivityForResult(intent, Template.Code.CAMERA_VIDEO_CODE);
                        } else {
                            //Mendapatkan file dari storage
                            Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
                            intent.setType("image/* video/*");
                            startActivityForResult(intent, Template.Code.FILE_MANAGER_CODE);
                        }
                    }
                }).show();
    }

    //Respon dari upload button ketika diklik, untuk melakukan upload file ke server
    void uploadFile() {

        mMultiPartRequest = new VolleyMultipartRequest(new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                mUpload.setVisibility(Button.VISIBLE);
                mProgress.setVisibility(ProgressBar.GONE);
                mIsLoad = false;
                setResponse(null, error);
            }
        }, new Response.Listener() {
            @Override
            public void onResponse(Object response) {
                mUpload.setVisibility(Button.VISIBLE);
                mProgress.setVisibility(ProgressBar.GONE);
                mIsLoad = false;
                setResponse(response, null);

            }
        }, mFile);
        //Set tag, diperlukan ketika akan menggagalkan request/cancenl request
        mMultiPartRequest.setTag("MultiRequest");
        //Set retry policy, untuk mengatur socket time out, retries. Bisa disetting lewat template
        mMultiPartRequest.setRetryPolicy(new DefaultRetryPolicy(Template.VolleyRetryPolicy.SOCKET_TIMEOUT,
                Template.VolleyRetryPolicy.RETRIES, DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));

        //Menambahkan ke request queue untuk diproses
        VolleySingleton.getInstance(getBaseContext()).addToRequestQueue(mMultiPartRequest);
    }

    //Mengisi variable File dari path yang didapat dari storage
    void setFile(int type, Uri uri) {
        mFile = new File(FileManager.getPath(getApplicationContext(), type, uri));
    }

    //Respon ketika path file dari storage didapatkan, untuk menampilkan view untuk upload
    void setView(int type, Uri uri) {
        mUpload.setVisibility(Button.VISIBLE);
        mAdd.setText("Delete");
        mInfo.setVisibility(TextView.VISIBLE);
        mInfo.setText("File info\n" + "Name : " + mFile.getName() + "\nSize : " +
                FileManager.getSize(mFile.length(), true));
        if (type == Template.Code.CAMERA_IMAGE_CODE) {
            mImage.setVisibility(ImageView.VISIBLE);
            mImage.setImageBitmap(BitmapFactory.decodeFile(FileManager.getPath(getApplicationContext(), type, uri)));
        } else if (type == Template.Code.CAMERA_VIDEO_CODE) {
            mVideo.setVisibility(VideoView.VISIBLE);
            mVideo.setVideoPath(FileManager.getPath(getApplicationContext(), type, uri));
            mController.setVisibility(ImageView.VISIBLE);
            mController.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {

                    if (mVideo.isPlaying()) {
                        mController.setImageResource(R.drawable.ic_account_box);
                        mVideo.pause();
                    } else {

                        mController.setImageResource(R.drawable.ic_add_black_24dp);
                        mVideo.start();
                    }
                }
            });
            mVideo.start();
        } else {

            File file = new File(FileManager.getPath(getApplicationContext(), type, uri));
            int fileType = FileManager.fileType(file);
            if (fileType == Template.Code.CAMERA_IMAGE_CODE) {
                mImage.setVisibility(ImageView.VISIBLE);
                mImage.setImageBitmap(BitmapFactory.decodeFile(FileManager.getPath(getApplicationContext(), type, uri)));
            } else if (fileType == Template.Code.CAMERA_VIDEO_CODE) {
                mVideo.setVisibility(VideoView.VISIBLE);
                mVideo.setVideoPath(FileManager.getPath(getApplicationContext(), type, uri));
                mController.setVisibility(ImageView.VISIBLE);
                mController.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {

                        if (mVideo.isPlaying()) {
                            mController.setImageResource(R.drawable.ic_add_circle_outline_black_24dp);
                            mVideo.pause();
                        } else {

                            mController.setImageResource(R.drawable.notification);
                            mVideo.start();
                        }
                    }
                });
                mVideo.start();
            } else if (fileType == Template.Code.AUDIO_CODE) {
                mMediaPlayer = MediaPlayer.create(getApplicationContext(), uri);
                mMediaPlayer.setLooping(true);
                mController.setVisibility(ImageView.VISIBLE);
                mController.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {

                        if (mMediaPlayer.isPlaying()) {
                            mController.setImageResource(R.drawable.mosaic_settings);
                            mMediaPlayer.pause();
                        } else {

                            mController.setImageResource(R.drawable.mosaic_favourite);
                            mMediaPlayer.start();
                        }
                    }
                });
                mMediaPlayer.start();
            } else {
                mImage.setVisibility(ImageView.VISIBLE);
                mImage.setImageResource(R.drawable.mosaic_gallery);
            }

        }
    }

    //Mereset tampilan ke semula
    void resetView() {
        mUpload.setVisibility(Button.GONE);
        mImage.setVisibility(ImageView.GONE);
        mVideo.setVisibility(VideoView.GONE);
        mInfo.setVisibility(TextView.GONE);
        mInfo.setText("");
        mResponse.setText("");
        mAdd.setText("Add");
        mProgress.setVisibility(ProgressBar.GONE);
        mController.setVisibility(ImageView.GONE);
        mController.setImageResource(R.drawable.ic_account_box);
        if (mVideo.isPlaying())
            mVideo.pause();
        if (mMediaPlayer!=null&&mMediaPlayer.isPlaying())
            mMediaPlayer.pause();
    }

    //Respon dari volley, untuk menampilkan keterengan upload, seperti error, message dari server
    void setResponse(Object response, VolleyError error) {
        if (response == null) {
            mResponse.setText("Error\n" + error);
        } else {
            if (StringParser.getCode(response.toString()).equals(Template.Query.VALUE_CODE_SUCCESS))
                mResponse.setText("Success\n" + StringParser.getMessage(response.toString()));
            else
                mResponse.setText("Error\n" + StringParser.getMessage(response.toString()));
        }
    }

    //Respon dari pengambilan data dari storage
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == RESULT_OK) {
            if (requestCode == Template.Code.FILE_MANAGER_CODE) {
                setFile(requestCode, data.getData());
                setView(requestCode, data.getData());
            } else {
                setFile(requestCode, mOutputUri);
                setView(requestCode, mOutputUri);
            }

        } else {
            resetView();
        }
    }


}

