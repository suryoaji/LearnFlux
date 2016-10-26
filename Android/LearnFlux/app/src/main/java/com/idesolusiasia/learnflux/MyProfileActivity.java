package com.idesolusiasia.learnflux;

import android.app.Activity;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Point;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.androidnetworking.AndroidNetworking;
import com.androidnetworking.common.Priority;
import com.androidnetworking.error.ANError;
import com.androidnetworking.interfaces.JSONObjectRequestListener;
import com.androidnetworking.interfaces.UploadProgressListener;
import com.idesolusiasia.learnflux.adapter.ConnectionFragmentAdapter;
import com.idesolusiasia.learnflux.adapter.MyProfileAdapter;
import com.idesolusiasia.learnflux.adapter.NotificationAdapter;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Notification;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;

public class MyProfileActivity extends BaseActivity implements View.OnClickListener {
	ViewPager mViewPager;
	ConnectionFragmentAdapter rAdapter;
	ImageLoader imageLoader = VolleySingleton.getInstance(MyProfileActivity.this).getImageLoader();
	FragmentAdapter mAdap;
	RecyclerView ConnectionMyProfile;
	TextView interest1,interest2, txtParent, txtParentDesc;
	LinearLayout tabIndividual, tabGroups, tabOrganization, tabContact;
	View indicatorIndividual, indicatorGroups, indicatorOrganization, indicatorContact;
	MyProfileAdapter rcAdapter; NetworkImageView parent; CircularNetworkImageView child;
	private ImageView changeImage;
	TextView affilatedOrganizationButtonMore , from, work;
	LinearLayout showAllOrganization;
	RecyclerView affilatedOrganizationRecycler;
	boolean visible;
	boolean visible2;
	ArrayList<Group> arrOrg = new ArrayList<Group>();
	ArrayList<Group> Org = new ArrayList<Group>();
	ArrayList<Notification> notif= new ArrayList<>();
	static final int ITEMS = 4;
	Point p;
	File file;
	public int PICK_IMAGE =100;
	NotificationAdapter notifAdapter;
	RecyclerView notifRecycler;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_base);
		super.onCreateDrawer(savedInstanceState);

		AndroidNetworking.initialize(getApplicationContext()); // initialize library

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
					notifRecycler = (RecyclerView)findViewById(R.id.recycleNotification);
					notif = new ArrayList<Notification>();
					Engine.getNotification(getApplicationContext(), new RequestTemplate.ServiceCallback() {
						@Override
						public void execute(JSONObject obj) {
							try{
								JSONArray data = obj.getJSONArray("data");
								for(int it=0;it<data.length();it++){
									Notification notifications = Converter.convertNotification(data.getJSONObject(it));
									notif.add(notifications);
								}
								notifAdapter = new NotificationAdapter(getApplicationContext(),notif);
								notifRecycler.setAdapter(notifAdapter);
							}catch (JSONException e){
								e.printStackTrace();
							}
						}
					});
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
				final EditText From = (EditText)findViewById(R.id.edittextFrom);
				final EditText Work = (EditText)findViewById(R.id.editTextWork);
				save.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View view) {
						Engine.editProfileName(getApplicationContext(), "", editextName.getText().toString().trim(),
								From.getText().toString().trim(),Work.getText().toString().trim(),"",  new RequestTemplate.ServiceCallback() {
							@Override
							public void execute(JSONObject obj) {
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



		//Edit Profile UPLOADING AN IMAGE
		changeImage = (ImageView)findViewById(R.id.profileImageChange);
		changeImage.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent intent = new Intent();
				intent.setType("image/*");
				intent.setAction(Intent.ACTION_GET_CONTENT);
				startActivityForResult(Intent.createChooser(intent, "Select Image"), PICK_IMAGE);
			}
		});


		// Set User My Profile details Data inside the box
		initializeUser();
		getUserStatus();
		work = (TextView)findViewById(R.id.work);
		from = (TextView)findViewById(R.id.fromText);
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
					String works = data.getString("work");
					String location = data.getString("location");
					txtParent.setText(firstname+ " " + lastname);
					work.setText("From: " + location);
					from.setText("Work: " + works);
					User.getUser().setUsername(firstname+lastname);
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		if (requestCode == PICK_IMAGE && resultCode == Activity.RESULT_OK) {

			Uri selectedImage = data.getData();
			String path = getRealPathFromUri(selectedImage);
			changeImage.setImageBitmap(BitmapFactory.decodeFile(path));
			file = new File(path);
		}
	}
	public String getRealPathFromUri(final Uri uri) {
		// DocumentProvider
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT && DocumentsContract.isDocumentUri(getApplicationContext(), uri)) {
			// ExternalStorageProvider
			if (isExternalStorageDocument(uri)) {
				final String docId = DocumentsContract.getDocumentId(uri);
				final String[] split = docId.split(":");
				final String type = split[0];

				if ("primary".equalsIgnoreCase(type)) {
					return Environment.getExternalStorageDirectory() + "/" + split[1];
				}
			}
			// DownloadsProvider
			else if (isDownloadsDocument(uri)) {

				final String id = DocumentsContract.getDocumentId(uri);
				final Uri contentUri = ContentUris.withAppendedId(
						Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));

				return getDataColumn(getApplicationContext(), contentUri, null, null);
			}
			// MediaProvider
			else if (isMediaDocument(uri)) {
				final String docId = DocumentsContract.getDocumentId(uri);
				final String[] split = docId.split(":");
				final String type = split[0];

				Uri contentUri = null;
				if ("image".equals(type)) {
					contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
				} else if ("video".equals(type)) {
					contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
				} else if ("audio".equals(type)) {
					contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
				}

				final String selection = "_id=?";
				final String[] selectionArgs = new String[]{
						split[1]
				};

				return getDataColumn(getApplicationContext(), contentUri, selection, selectionArgs);
			}
		}
		// MediaStore (and general)
		else if ("content".equalsIgnoreCase(uri.getScheme())) {

			// Return the remote address
			if (isGooglePhotosUri(uri))
				return uri.getLastPathSegment();

			return getDataColumn(getApplicationContext(), uri, null, null);
		}
		// File
		else if ("file".equalsIgnoreCase(uri.getScheme())) {
			return uri.getPath();
		}

		return null;
	}

	private String getDataColumn(Context context, Uri uri, String selection,
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
				final int index = cursor.getColumnIndexOrThrow(column);
				return cursor.getString(index);
			}
		} finally {
			if (cursor != null)
				cursor.close();
		}
		return null;
	}

	private boolean isExternalStorageDocument(Uri uri) {
		return "com.android.externalstorage.documents".equals(uri.getAuthority());
	}

	private boolean isDownloadsDocument(Uri uri) {
		return "com.android.providers.downloads.documents".equals(uri.getAuthority());
	}

	private boolean isMediaDocument(Uri uri) {
		return "com.android.providers.media.documents".equals(uri.getAuthority());
	}

	private boolean isGooglePhotosUri(Uri uri) {
		return "com.google.android.apps.photos.content".equals(uri.getAuthority());
	}
	void saveButton(){
		String a = "http://lfapp.learnflux.net/v1/me/image?key=profile/47";
		AndroidNetworking.put(a)
				.addHeaders("Authorization", "Bearer " + User.getUser().getAccess_token())
				.addFileBody(file)
				.setTag("uploadTest")
				.setPriority(Priority.HIGH)
				.build()
				.setUploadProgressListener(new UploadProgressListener() {
					@Override
					public void onProgress(long bytesUploaded, long totalBytes) {
						// do anything with progress
					}
				})
				.getAsJSONObject(new JSONObjectRequestListener() {
					@Override
					public void onResponse(JSONObject response) {
						// do anything with response
						Toast.makeText(getApplicationContext(), "Success", Toast.LENGTH_SHORT).show();
					}

					@Override
					public void onError(ANError error) {
						// handle error
						//Toast.makeText(getApplicationContext(), "Failed", Toast.LENGTH_SHORT).show();
					}
				});
	}

}