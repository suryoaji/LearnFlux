package com.idesolusiasia.learnflux;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Point;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.provider.SyncStateContract;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ScrollingView;
import android.support.v4.view.ViewPager;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Base64;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkResponse;
import com.android.volley.NoConnectionError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.TimeoutError;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.adapter.ConnectionFragmentAdapter;
import com.idesolusiasia.learnflux.adapter.MyProfileAdapter;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.AppHelper;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class MyProfileActivity extends BaseActivity implements View.OnClickListener {
	String twoHyphens = "--";
	String lineEnd = "\r\n";
	String boundary = "apiclient-" + System.currentTimeMillis();
	String mimeType = "multipart/form-data;boundary=" + boundary;
	byte[] multipartBody;
	ViewPager mViewPager;
	ConnectionFragmentAdapter rAdapter;
	ImageLoader imageLoader = VolleySingleton.getInstance(MyProfileActivity.this).getImageLoader();
	FragmentAdapter mAdap;
	RecyclerView ConnectionMyProfile;
	TextView interest1,interest2, txtParent, txtParentDesc;
	LinearLayout tabIndividual, tabGroups, tabOrganization, tabContact;
	private static final int PICK_IMAGE_REQUEST = 1;
	View indicatorIndividual, indicatorGroups, indicatorOrganization, indicatorContact;
	MyProfileAdapter rcAdapter; NetworkImageView parent; CircularNetworkImageView child;
	public Contact contact =null;
	public Bitmap bitmap; public String encodedImage;
	private ImageView changeImage;
	TextView affilatedOrganizationButtonMore;
	LinearLayout showAllOrganization;
	RecyclerView affilatedOrganizationRecycler;
	boolean visible;
	boolean visible2;
	ArrayList<Group> arrOrg = new ArrayList<Group>();
	ArrayList<Group> Org = new ArrayList<Group>();
	static final int ITEMS = 4;
	Point p;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_base);
		super.onCreateDrawer(savedInstanceState);

		FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
		final LayoutInflater layoutInflater = LayoutInflater.from(this);
		View childLayout = layoutInflater.inflate(
				R.layout.activity_my_profile, null);
		parentLayout.addView(childLayout);
		visible=true;
		visible2=true;


		//My profile and connection action bar
		final ScrollView scroll1 = (ScrollView) findViewById(R.id.linear1);
		final LinearLayout linear2 = (LinearLayout) findViewById(R.id.linear2);
		final ScrollView scroll3 = (ScrollView) findViewById(R.id.includeMyProfile);
		LinearLayout myProfileTab = (LinearLayout) findViewById(R.id.tabMyProfile);
		LinearLayout connectionTab = (LinearLayout) findViewById(R.id.tabConnection);
		final TextView myProfileTitle = (TextView) findViewById(R.id.myProfileTitle);
		final TextView connectionTitle = (TextView) findViewById(R.id.connectionTitle);
		final View line1 = (View) findViewById(R.id.line1);
		final View line2 = (View) findViewById(R.id.line2);
		ImageButton connectionNotif = (ImageButton)findViewById(R.id.friendsNotif);
		ImageButton userNotif = (ImageButton)findViewById(R.id.menotif);
		ImageButton search = (ImageButton)findViewById(R.id.searchBar);
		final ViewPager viewPager = (ViewPager)findViewById(R.id.pager);
		scroll3.setVisibility(View.GONE);
		myProfileTab.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				viewPager.setVisibility(View.GONE);
				line2.setVisibility(View.GONE);
				scroll3.setVisibility(View.GONE);
				myProfileTitle.setTextColor(Color.parseColor("#8bc34a"));
				line1.setVisibility(View.VISIBLE);
				line1.setBackgroundColor(Color.parseColor("#8bc34a"));
				scroll1.setVisibility(View.VISIBLE);
				connectionTitle.setTextColor(Color.parseColor("#FFFFFF"));
				linear2.setVisibility(View.GONE);
			}
		});
		connectionTab.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				viewPager.setVisibility(View.VISIBLE);
				scroll3.setVisibility(View.GONE);
				connectionTitle.setTextColor(Color.parseColor("#8bc34a"));
				line2.setVisibility(View.VISIBLE);
				line1.setVisibility(View.GONE);
				line2.setBackgroundColor(Color.parseColor("#8bc34a"));
				scroll1.setVisibility(View.GONE);
				myProfileTitle.setTextColor(Color.parseColor("#FFFFFF"));
				linear2.setVisibility(View.VISIBLE);
			}
		});


		//Friend Request Notification and All Notification
		final View includedLayout = findViewById(R.id.mixLayout);
		final View includedLayout2 = findViewById(R.id.mixLayout2);
		final TextView txtNotification1 = (TextView)findViewById(R.id.textNotif1);
		final TextView txtNotification2 = (TextView)findViewById(R.id.textNotif2);
		connectionNotif.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				if(visible || !visible2) {
					includedLayout.setVisibility(View.VISIBLE);
					includedLayout.bringToFront();
					RecyclerView rcViewFriend = (RecyclerView)findViewById(R.id.recyclerFriendNotif);
					LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext(), LinearLayoutManager.VERTICAL, false);
					rcViewFriend.setLayoutManager(linearLayoutManager);
					/*Engine.getMeWithRequest(getApplicationContext(), new RequestTemplate.ServiceCallback() {
						@Override
						public void execute(JSONObject obj) {
							try {
								JSONObject data = obj.getJSONObject("data");
								JSONArray array = data.getJSONArray("friend_request");
								for(int i=0;i<array.length();i++){
									contact = Converter.convertContact(array.getJSONObject(i));
								}
							}catch (JSONException e){
								e.printStackTrace();
							}
						}
					});*/
					txtNotification1.setVisibility(View.GONE);
					visible=false;
					visible2=true;
				}else if(!visible){
					includedLayout.setVisibility(View.GONE);
					visible=true;
				}
			}
		});
		userNotif.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				if(visible2 || !visible){
					includedLayout2.setVisibility(View.VISIBLE);
					includedLayout2.bringToFront();
					includedLayout.setVisibility(View.GONE);
					txtNotification2.setVisibility(View.GONE);
					visible2=false;
					visible=true;
				}else if(!visible2){
					includedLayout2.setVisibility(View.GONE);
					visible2=true;
				}
			}
		});

		//Layout3 search action bar
		final LinearLayout linearTabBar = (LinearLayout)findViewById(R.id.LinearTabBar);
		final View includedLayout3 = (LinearLayout) findViewById(R.id.mixLayout3);
		final ImageView back = (ImageView)findViewById(R.id.imageBack);

		search.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				linearTabBar.setVisibility(View.GONE);
				includedLayout3.setVisibility(View.VISIBLE);
			}
		});
		back.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				linearTabBar.setVisibility(View.VISIBLE);
				includedLayout3.setVisibility(View.GONE);
			}
		});

		//Edit Profile
		TextView editProfile = (TextView)findViewById(R.id.editProfile);
		final TextView save = (TextView)findViewById(R.id.save);
		editProfile.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {

				scroll1.setVisibility(View.GONE);
				scroll3.setVisibility(View.VISIBLE);
				scroll3.bringToFront();
				final EditText editextName = (EditText)findViewById(R.id.editTextName);
				save.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View view) {
						Engine.editProfileName(getApplicationContext(), "", editextName.getText().toString().trim(), "",  new RequestTemplate.ServiceCallback() {
							@Override
							public void execute(JSONObject obj) {
								Toast.makeText(getApplicationContext(), "Successfully change name", Toast.LENGTH_SHORT).show();
								finish();
								startActivity(getIntent());
							}
						});
						saveButton();
					}
				});
			}
		});
		TextView textNotif = (TextView)findViewById(R.id.textView10);
		//Edit Profile
		changeImage = (ImageView)findViewById(R.id.profileImageChange);
		changeImage.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent intent = new Intent();
				intent.setType("image/*");
				intent.setAction(Intent.ACTION_GET_CONTENT);
				startActivityForResult(Intent.createChooser(intent, "Select Picture"),PICK_IMAGE_REQUEST);
			}
		});


		// Set User My Profile details Data inside the box
		initializeUser();
		getUserStatus();
		parent = (NetworkImageView)findViewById(R.id.imageeees);
		child  = (CircularNetworkImageView)findViewById(R.id.imagesChild);
		String prof = User.getUser().getProfile_picture();
		String url = getString(R.string.BASE_URL)+getString(R.string.URL_VERSION)+"image?key=";
		parent.setImageUrl(url+prof,imageLoader);
		child.setImageUrl(url+prof, imageLoader);
		txtParentDesc = (TextView)findViewById(R.id.txtParentDesc);
		txtParent = (TextView)findViewById(R.id.txtParentTitle);
		final TextView tvSeeMore = (TextView)findViewById(R.id.tvSeeMore);
		txtParentDesc.post(new Runnable() {
			@Override
			public void run() {
				int a = txtParentDesc.getLineCount();
				if(a>1){
					tvSeeMore.setVisibility(View.VISIBLE);
					txtParentDesc.setMaxLines(1);
				}
			}
		});
		tvSeeMore.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				txtParentDesc.setMaxLines(Integer.MAX_VALUE);
				tvSeeMore.setVisibility(View.GONE);
			}
		});
		//dialog children
		final ImageView children1 = (ImageView)findViewById(R.id.kid1);
		children1.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
			/*	final Dialog dialog = new Dialog(MyProfileActivity.this);
				dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
				dialog.setContentView(R.layout.dialog_mychildren);
				WindowManager.LayoutParams wlmp = dialog.getWindow()
						.getAttributes();
				wlmp.gravity = Gravity.BOTTOM;
				dialog.show();*/
				if (p != null)
					showPopup(MyProfileActivity.this, p);
			}

		});




		//Affilited Organization
		affilatedOrganizationRecycler = (RecyclerView)findViewById(R.id.organizationRecycler);
		showAllOrganization = (LinearLayout)findViewById(R.id.layoutShowAll);
		showAllOrganization.setVisibility(View.VISIBLE);
		showAllOrganization.bringToFront();
		affilatedOrganizationButtonMore = (TextView)findViewById(R.id.buttonShowMore);
		LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false);
		affilatedOrganizationRecycler.setLayoutManager(linearLayoutManager);
		affilatedOrganizationButtonMore.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				showAllOrganization.setVisibility(View.GONE);
				affilatedOrganizationButtonMore.setVisibility(View.GONE);
			}
		});
		initOrganizations();

		//User Interest
		interest1 = (TextView)findViewById(R.id.interest1);
		interest2 = (TextView)findViewById(R.id.interest2);
		getInterest();


		//ViewPager
		//set the adapter pager indicator of the tab
		mAdap = new FragmentAdapter(getSupportFragmentManager());
		mViewPager = (ViewPager) findViewById(R.id.pager);
		mViewPager.setAdapter(mAdap);
		tabIndividual = (LinearLayout) findViewById(R.id.tabIndividual);
		tabGroups = (LinearLayout) findViewById(R.id.tabGroups);
		tabOrganization = (LinearLayout) findViewById(R.id.tabOrganization);
		tabContact = (LinearLayout) findViewById(R.id.tabContact);
		tabIndividual.setOnClickListener(this);
		tabGroups.setOnClickListener(this);
		tabOrganization.setOnClickListener(this);
		tabContact.setOnClickListener(this);
		indicatorIndividual = (View) findViewById(R.id.indicator_individual);
		indicatorGroups = (View) findViewById(R.id.indicator_groups);
		indicatorOrganization = (View) findViewById(R.id.indicator_organization);
		indicatorContact = (View) findViewById(R.id.indicator_contact);

		mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
			@Override
			public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

			}

			@Override
			public void onPageSelected(int position) {
				selectTab(position);
			}

			@Override
			public void onPageScrollStateChanged(int state) {

			}
		});
		mViewPager.setCurrentItem(0);

		ConnectionMyProfile = (RecyclerView)findViewById(R.id.recyclerMyProfile);
		LinearLayoutManager ConnectionLayout = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
		ConnectionMyProfile.setLayoutManager(ConnectionLayout);
		initConnection();
	}
	@Override
	public void onWindowFocusChanged(boolean hasFocus) {

		int[] location = new int[2];
		ImageView children1 = (ImageView)findViewById(R.id.kid1);

		// Get the x, y location and store it in the location[] array
		// location[0] = x, location[1] = y.
		children1.getLocationOnScreen(location);

		//Initialize the Point with x, and y positions
		p = new Point();
		p.x = location[0];
		p.y = location[1];
	}
	private void showPopup(final Activity context, Point p) {
		int popupWidth = 600;
		int popupHeight = 700;

		// Inflate the popup_layout.xml
		LinearLayout viewGroup = (LinearLayout) context.findViewById(R.id.popup);
		LayoutInflater layoutInflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View layout = layoutInflater.inflate(R.layout.dialog_mychildren, viewGroup);

		// Creating the PopupWindow
		final PopupWindow popup = new PopupWindow(context);
		popup.setContentView(layout);
		popup.setWidth(popupWidth);
		popup.setHeight(popupHeight);
		popup.setFocusable(true);

		// Some offset to align the popup a bit to the right, and a bit down, relative to button's position.
		int OFFSET_X = 30;
		int OFFSET_Y = 30;


		// Displaying the popup at the specified location, + offsets.
		popup.showAtLocation(layout, Gravity.NO_GRAVITY, p.x + OFFSET_X, p.y + OFFSET_Y);

	}
	void initConnection(){
		Org = new ArrayList<>();
		Engine.getOrganizations(getApplicationContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONArray array = obj.getJSONArray("data");
					for(int i=0;i<array.length();i++){
						Group org = Converter.convertOrganizations(array.getJSONObject(i));
						Org.add(org);
					}
						rAdapter = new ConnectionFragmentAdapter(getApplicationContext(), Org);
					    ConnectionMyProfile.setAdapter(rAdapter);
						//emptyView.setVisibility(View.GONE);

				}catch (JSONException e){
					e.printStackTrace();
				}

			}
		});
	}
	@Override
	public void onClick(View view) {
		if (view == tabIndividual) {
			mViewPager.setCurrentItem(0);
		} else if (view == tabGroups) {
			mViewPager.setCurrentItem(1);
		} else if (view == tabOrganization) {
			mViewPager.setCurrentItem(2);
		} else if (view == tabContact) {
			mViewPager.setCurrentItem(3);
		}
	}
	void selectTab(int pos) {
		indicatorIndividual.setVisibility(View.GONE);
		indicatorGroups.setVisibility(View.GONE);
		indicatorOrganization.setVisibility(View.GONE);
		indicatorContact.setVisibility(View.GONE);
		if (pos == 0) {
			indicatorIndividual.setVisibility(View.VISIBLE);
		} else if (pos == 1) {
			indicatorGroups.setVisibility(View.VISIBLE);
		} else if (pos == 2) {
			indicatorOrganization.setVisibility(View.VISIBLE);
		} else if(pos == 3){
			indicatorContact.setVisibility(View.VISIBLE);
		}
	}
	public static class FragmentAdapter extends FragmentPagerAdapter {

		public FragmentAdapter(FragmentManager fm) {
			super(fm);
		}
		@Override
		public Fragment getItem(int position) {
			Fragment fragment =null;
			switch (position) {
				case 0:
					fragment = IndividualFragment.newInstance();
					break;
				case 1:
					fragment =  ConnectionGroupFragment.newInstance();
					break;
				case 2:
					fragment =  ConnectionOrganizationFragment.newInstance();
					break;
				case 3:
					fragment =  ContactFragment.newInstance();
					break;
			}
				return fragment;

		}
		@Override
		public int getCount() {
			return ITEMS;
		}
		@Override
		public int getItemPosition(Object object) {
			return POSITION_NONE;
		}
	}
	void initOrganizations(){
		arrOrg = new ArrayList<>();
		Engine.getOrganizations(getApplicationContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONArray array = obj.getJSONArray("data");
					for(int i=0;i<array.length();i++){
						Group org = Converter.convertOrganizations(array.getJSONObject(i));
						if(array.getJSONObject(i).getString("type").equals("organization")) {
							arrOrg.add(org);
						}
					}
					if(arrOrg.isEmpty()){
						affilatedOrganizationRecycler.setVisibility(View.GONE);
						//emptyView.setVisibility(View.VISIBLE);
					}else {
						rcAdapter = new MyProfileAdapter(getApplicationContext(), arrOrg);
						affilatedOrganizationRecycler.setAdapter(rcAdapter);
						//emptyView.setVisibility(View.GONE);
					}
				}catch (JSONException e){
					e.printStackTrace();
				}

			}
		});
	}
	void getInterest(){
		Engine.getMeWithRequest(getApplicationContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONObject data = obj.getJSONObject("data");
					JSONArray interest = data.getJSONArray("interests");
					for(int j=0;j<interest.length();j++){
						interest1.setText(interest.getString(0));
						interest2.setText(interest.getString(1));
					}
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}
	void getUserStatus(){
		Engine.getOrganizations(getApplicationContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					StringBuilder sb = new StringBuilder();
					JSONArray array = obj.getJSONArray("data");
					for(int i=0;i<array.length();i++){
					if(array.getJSONObject(i).getString("access").equals("Admin")){
						String nameofGroup = array.getJSONObject(i).getString("name");
						sb.append("Admin" + " of " + nameofGroup + ", ");
						txtParentDesc.setText(sb.toString());
					}
					}
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}
	void initializeUser(){
		Engine.getMeWithRequest(getApplicationContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONObject data = obj.getJSONObject("data");
					String firstname = data.getString("first_name");
					String lastname = data.getString("last_name");
					txtParent.setText(firstname+ " " + lastname);
					User.getUser().setUsername(firstname+lastname);
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}
	public static String getPath(final Context context, final Uri uri) {

		final boolean isKitKat = Build.VERSION.SDK_INT >=
				Build.VERSION_CODES.KITKAT;
		Log.i("URI",uri+"");
		String result = uri+"";
		// DocumentProvider
		//  if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
		if (isKitKat && (result.contains("media.documents"))) {

			String[] ary = result.split("/");
			int length = ary.length;
			String imgary = ary[length-1];
			final String[] dat = imgary.split("%3A");

			final String docId = dat[1];
			final String type = dat[0];

			Uri contentUri = null;
			if ("image".equals(type)) {
				contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
			} else if ("video".equals(type)) {

			} else if ("audio".equals(type)) {
			}

			final String selection = "_id=?";
			final String[] selectionArgs = new String[] {
					dat[1]
			};

			return getDataColumn(context, contentUri, selection, selectionArgs);
		}
		else
		if ("content".equalsIgnoreCase(uri.getScheme())) {
			return getDataColumn(context, uri, null, null);
		}
		// File
		else if ("file".equalsIgnoreCase(uri.getScheme())) {
			return uri.getPath();
		}

		return null;
	}

	public static String getDataColumn(Context context, Uri uri, String selection,
									   String[] selectionArgs) {

		Cursor cursor = null;
		final String column = "_data";
		final String[] projection = {
				column
		};

		try {
			cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,
					null);
			if (cursor != null && cursor.moveToFirst()) {
				final int column_index = cursor.getColumnIndexOrThrow(column);
				return cursor.getString(column_index);
			}
		} finally {
			if (cursor != null)
				cursor.close();
		}
		return null;
	}
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == PICK_IMAGE_REQUEST && resultCode == RESULT_OK && data != null && data.getData() != null) {
			Uri filePath = data.getData();
			try {
				//Getting the Bitmap from Gallery
				bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), filePath);

				try {
					String realPath = getPath(this, filePath);
					ExifInterface exif = new ExifInterface(realPath);
					Log.d("EXIF", "Path: " + filePath.getPath());
					int orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, 1);
					Log.d("EXIF", "Exif: " + orientation);
					Matrix matrix = new Matrix();
					if (orientation == 6) {
						matrix.postRotate(90);
					} else if (orientation == 3) {
						matrix.postRotate(180);
					} else if (orientation == 8) {
						matrix.postRotate(270);
					}
					bitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true); // rotating bitmap
				} catch (Exception e) {

				}
			changeImage.setImageBitmap(bitmap);
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			finish();
		}
	}
	public byte[] getStringImage(Bitmap bmp){
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		//bmp.compress(Bitmap.CompressFormat.JPEG, 100, baos);
		changeImage.buildDrawingCache();
		Bitmap bm = changeImage.getDrawingCache();
		bm.compress(Bitmap.CompressFormat.JPEG, 100, baos); //bm is the bitmap object
		byte[] b = baos.toByteArray();
		encodedImage = Base64.encodeToString(b , Base64.DEFAULT);
		return b;
	}
	private void buildPart(DataOutputStream dataOutputStream, byte[] fileData, String fileName) throws IOException {
		dataOutputStream.writeBytes(twoHyphens + boundary + lineEnd);

		dataOutputStream.writeBytes("Content-Disposition: form-data; name=\"photo\"; filename=\""
				+ fileName + "\"" + lineEnd);
		dataOutputStream.writeBytes("Content-Type: image/png" + lineEnd);
		dataOutputStream.writeBytes(lineEnd);


		ByteArrayInputStream fileInputStream = new ByteArrayInputStream(fileData);
		int bytesAvailable = fileInputStream.available();

		int maxBufferSize = 1024 * 1024;
		int bufferSize = Math.min(bytesAvailable, maxBufferSize);
		byte[] buffer = new byte[bufferSize];

		// read file and write it into form...
		int bytesRead = fileInputStream.read(buffer, 0, bufferSize);

		while (bytesRead > 0) {
			dataOutputStream.write(buffer, 0, bufferSize);
			bytesAvailable = fileInputStream.available();
			bufferSize = Math.min(bytesAvailable, maxBufferSize);
			bytesRead = fileInputStream.read(buffer, 0, bufferSize);
		}

		dataOutputStream.writeBytes(lineEnd);

	}
	void saveButton(){
		final byte[] fileData1= getStringImage(bitmap);
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		DataOutputStream dos = new DataOutputStream(bos);
		try {
			// the first file
			buildPart(dos, fileData1,"");
			// the second file
			// send multipart form data necesssary after file data
			dos.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);
			// pass to multipart body
			multipartBody = bos.toByteArray();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String urls = "http://lfapp.learnflux.net/v1/me/image?key=profile/79";
		VolleyMultipartRequest multipartRequest = new VolleyMultipartRequest(Request.Method.PUT, urls, new Response.Listener<NetworkResponse>() {
			@Override
			public void onResponse(NetworkResponse response) {
				Toast.makeText(getApplicationContext(), "Upload successfully!", Toast.LENGTH_SHORT).show();
				Log.i("result", "onResponse: "+ response.toString());
				Intent a = getIntent();
				startActivity(a);
			}
		}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {
				Toast.makeText(getApplicationContext(), "Upload failed!\r\n" + error.toString(), Toast.LENGTH_SHORT).show();
			}
		}){
			@Override
			public Map<String,String> getHeaders() throws AuthFailureError {
				HashMap<String, String> params = new HashMap<String, String>();
				params.put("Content-Type","application/image");
				params.put("Authorization", "Bearer " + User.getUser().getAccess_token());
				return params;
			}
			@Override
			public Map<String, DataPart> getByteData(){
				Map<String, DataPart> params = new HashMap<>();
				params.put("avatar", new DataPart("file_avatar.jpg", fileData1));
				Log.i("file", "getByteData: " + multipartBody);
				return params;
			}


		};
		VolleySingleton.getInstance(getBaseContext()).addToRequestQueue(multipartRequest);
	}
}