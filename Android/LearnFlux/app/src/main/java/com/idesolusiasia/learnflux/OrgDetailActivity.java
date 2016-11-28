package com.idesolusiasia.learnflux;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.shapes.RoundRectShape;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.androidnetworking.AndroidNetworking;
import com.androidnetworking.common.Priority;
import com.androidnetworking.error.ANError;
import com.androidnetworking.interfaces.JSONArrayRequestListener;
import com.androidnetworking.interfaces.JSONObjectRequestListener;
import com.androidnetworking.interfaces.StringRequestListener;
import com.androidnetworking.interfaces.UploadProgressListener;
import com.google.gson.reflect.TypeToken;
import com.idesolusiasia.learnflux.adapter.AddGroupAdapter;
import com.idesolusiasia.learnflux.component.RoundedImageView;
import com.idesolusiasia.learnflux.db.DatabaseFunction;
import com.idesolusiasia.learnflux.entity.FriendReq;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Thread;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;
import com.koushikdutta.ion.Ion;
import com.squareup.picasso.Transformation;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.Executors;

public class OrgDetailActivity extends BaseActivity implements View.OnClickListener {
	ViewPager mViewPager;
	FragmentAdapter mAdap;
	public String id, type, clickOrganization;
	public Group group = null;
	AddGroupAdapter adap;
	public String name,desc,title,image;
	ListView listcontent; ImageView imagesOrg;
	LinearLayout tabGroups, tabEvents, tabActivities;
	View indicatorGroups, indicatorEvents, indicatorAct;
	TextView tvNotifGroups, tvNotifActivities, tvNotifEvents, tvTitle;
	static final int ITEMS = 3;
	public final int PICK_IMAGE=0;
	ImageLoader imageLoader = VolleySingleton.getInstance(OrgDetailActivity.this).getImageLoader();
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_base);
		super.onCreateDrawer(savedInstanceState);

		id = getIntent().getStringExtra("id");
		title = getIntent().getStringExtra("title");
		type = getIntent().getStringExtra("type");
		image = getIntent().getStringExtra("image");
		clickOrganization = getIntent().getStringExtra("clickOrganization");
		String url = "http://lfapp.learnflux.net/v1/image?key=";

		final FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
		final LayoutInflater layoutInflater = LayoutInflater.from(this);
		View childLayout = layoutInflater.inflate(
				R.layout.activity_org_details, null);
		parentLayout.addView(childLayout);

		///////////////////////////finish Base Init///
		tvTitle = (TextView)findViewById(R.id.titleOrgDetails);
		imagesOrg = (ImageView)findViewById(R.id.imageOrgDetail);
		tvTitle.setText(title);
		Animation animation = AnimationUtils.loadAnimation(getApplicationContext(),
				R.anim.popup_enter);

		if(image!=null) {
			Ion.with(getApplicationContext())
					.load(url+image)
					.addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
					.withBitmap().animateLoad(animation).fitCenter()
					.intoImageView(imagesOrg);
		}
		else{
			imagesOrg.setImageResource(R.drawable.company1);
		}
		mAdap = new FragmentAdapter(getSupportFragmentManager());
		mViewPager = (ViewPager) findViewById(R.id.pager);
		mViewPager.setAdapter(mAdap);
		tabGroups=(LinearLayout) findViewById(R.id.tabGroups);
		tabEvents=(LinearLayout) findViewById(R.id.tabEvents);
		tabActivities=(LinearLayout) findViewById(R.id.tabActivities);
		tabGroups.setOnClickListener(this);
		tabEvents.setOnClickListener(this);
		tabActivities.setOnClickListener(this);
		indicatorGroups=(View) findViewById(R.id.indicator_groups);
		indicatorEvents=(View) findViewById(R.id.indicator_events);
		indicatorAct=(View) findViewById(R.id.indicator_act);
		/*tvNotifActivities=(TextView) findViewById(R.id.tvNotifActivities);
		tvNotifEvents=(TextView) findViewById(R.id.tvNotifEvents);
		tvNotifGroups=(TextView) findViewById(R.id.tvNotifGroups);*/

		LinearLayout titleLayout = (LinearLayout) findViewById(R.id.titleLayout);
		titleLayout.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent i = new Intent(OrgDetailActivity.this, OrgProfileActivity.class);
				i.putExtra("id", id);
				startActivity(i);
			}
		});


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
		if(clickOrganization.equalsIgnoreCase("Default")){
			mViewPager.setCurrentItem(0);
		}
		else if(clickOrganization.equalsIgnoreCase("Event")){
			mViewPager.setCurrentItem(1);
		}else if(clickOrganization.equalsIgnoreCase("Activity")){
			mViewPager.setCurrentItem(2);
		}
		checkID();
	}

	@Override
	public void onClick(View v) {
		if (v==tabGroups){
			mViewPager.setCurrentItem(0);
		}else if (v==tabEvents){
			mViewPager.setCurrentItem(1);
		}else if (v==tabActivities){
			mViewPager.setCurrentItem(2);
		}
	}

	void selectTab(int pos){
		indicatorAct.setVisibility(View.GONE);
		indicatorEvents.setVisibility(View.GONE);
		indicatorGroups.setVisibility(View.GONE);
		if (pos==0){
			indicatorGroups.setVisibility(View.VISIBLE);
		}else if(pos==1) {
			indicatorEvents.setVisibility(View.VISIBLE);
		}else{
			indicatorAct.setVisibility(View.VISIBLE);
		}
	}

	public static class FragmentAdapter extends FragmentPagerAdapter{

		public FragmentAdapter(FragmentManager fm) {
			super(fm);
		}
		@Override
		public Fragment getItem(int position) {
			switch (position) {
				case 0:
					return OrgGroupFragment.newInstance();
				case 1:
					return OrgEventFragment.newInstance();
				default:
					return OrgActivityFragment.newInstance();
			}
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
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		//getMenuInflater().inflate(R.menu.menu_group, menu);

		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {

		switch(item.getItemId()){
			case R.id.invite_people:
				Intent a = new Intent(OrgDetailActivity.this, InvitePeople.class);
				a.putExtra("ids", id);
				startActivity(a);
				return true;
			case R.id.new_event:
				addEventProcess();
				return true;
			case R.id.new_group:
				addInterestNewGroup();
				return true;
			case R.id.addImagegroup:
				Intent intent = new Intent();
				intent.setType("image/*");
				intent.setAction(Intent.ACTION_GET_CONTENT);
				startActivityForResult(Intent.createChooser(intent, "Select Image"), PICK_IMAGE);
				return true;
		}

		return super.onOptionsItemSelected(item);
	}
	public void checkID(){
		Engine.getOrganizationProfile(getApplicationContext(), id, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONObject data = obj.getJSONObject("data");
					group = Converter.convertOrganizations(data);
					invalidateOptionsMenu();
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}

	@Override
	public boolean onPrepareOptionsMenu(Menu menu) {
		menu.clear();
		if (group!=null){
			if(group.getAdminID()!= -1){
				if(User.getUser().getID()==group.getAdminID()){
					getMenuInflater().inflate(R.menu.menu_group, menu);
				}else{
					getMenuInflater().inflate(R.menu.menu_event,menu);
				}
			}
		}
		return super.onPrepareOptionsMenu(menu);
	}

	public void addEventProcess() {
		final Dialog dialog = new Dialog(OrgDetailActivity.this);
		dialog.setTitle("Create Event");
		dialog.setContentView(R.layout.dialog_add_event);
		final EditText etDate = (EditText) dialog.findViewById(R.id.add_event_date);
		final EditText etStart = (EditText) dialog.findViewById(R.id.add_event_time);
		final EditText etTitle = (EditText) dialog.findViewById(R.id.add_event_title);
		final EditText etDesc = (EditText) dialog.findViewById(R.id.add_event_description);
		final EditText etLocation = (EditText) dialog.findViewById(R.id.add_event_location);
		final SimpleDateFormat dateFormatter = new SimpleDateFormat("EEEE, dd MMM yyyy", Locale.US);
		final Calendar calStart = Calendar.getInstance();
		etDate.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				DatePickerDialog datePickerDialog = new DatePickerDialog(OrgDetailActivity.this, new DatePickerDialog.OnDateSetListener() {

					public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
						calStart.set(year, monthOfYear, dayOfMonth);
						etDate.setText(dateFormatter.format(calStart.getTime()));
					}

				}, calStart.get(Calendar.YEAR), calStart.get(Calendar.MONTH), calStart.get(Calendar.DAY_OF_MONTH));
				datePickerDialog.show();
			}
		});

		final SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm", Locale.US);
		etStart.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				TimePickerDialog timePickerDialog = new TimePickerDialog(OrgDetailActivity.this, new TimePickerDialog.OnTimeSetListener() {

					@Override
					public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
						calStart.set(Calendar.HOUR_OF_DAY, hourOfDay);
						calStart.set(Calendar.MINUTE, minute);
						etStart.setText(timeFormatter.format(calStart.getTime()));
					}
				}, calStart.get(Calendar.HOUR_OF_DAY), calStart.get(Calendar.MINUTE), true);
				timePickerDialog.show();
			}
		});
		Button btnAdd = (Button) dialog.findViewById(R.id.btnSubmitEvent);
		btnAdd.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View view) {
					boolean pass = true;
					if (etTitle.getText().toString().isEmpty()) {
						pass = false;
						etTitle.requestFocus();
						etTitle.setError("You need to have a title");
					}
					if (etDesc.getText().toString().isEmpty()) {
						pass = false;
						etDesc.requestFocus();
						etDesc.setError("You need to have a description");
					}
					if (etLocation.getText().toString().isEmpty()) {
						pass = false;
						etLocation.requestFocus();
						etLocation.setError("You need to have a location");
					}
					if (etDate.getText().toString().isEmpty()) {
						pass = false;
						etDate.requestFocus();
						etDate.setError("You need to have a date");
					}
					if (etStart.getText().toString().isEmpty()) {
						pass = false;
						etStart.requestFocus();
						etStart.setError("You need to set the time");
					}
					if (pass) {
						Engine.createEvent(getApplicationContext(), true, etTitle.getText().toString(), etDesc.getText().toString(),
								etLocation.getText().toString(), calStart.getTimeInMillis() / 1000, null, id, type, new RequestTemplate.ServiceCallback() {
									@Override
									public void execute(JSONObject obj) {
										Log.i("Data Event", "execute: " + id + ", " + type);
										Toast.makeText(getApplicationContext(), "successfully send the data", Toast.LENGTH_SHORT).show();
										dialog.dismiss();
										/*Intent startActivity = new Intent(OrgDetailActivity.this, ChatsActivity.class);
										startActivity.putExtra("chatroom", "chat");*/
										Engine.getThreads(getApplicationContext(), new RequestTemplate.ServiceCallback() {
											@Override
											public void execute(JSONObject obj) {
												Intent startActivity = getIntent();
												finish();
												startActivity(startActivity);
											}
										});

									}
								});
					}
				}
			});
			dialog.show();
		}
	public void addInterestNewGroup(){
		final Dialog dialog = new Dialog(OrgDetailActivity.this);
		dialog.setTitle("Add new Group");
		dialog.setContentView(R.layout.dialog_add_group);
		final EditText groupName = (EditText) dialog.findViewById(R.id.add_group_name);
		final EditText groupDesc = (EditText) dialog.findViewById(R.id.add_group_description);
		Button btnNext = (Button)dialog.findViewById(R.id.btnNext);
		Button cancel = (Button)dialog.findViewById(R.id.btnCancel);
		btnNext.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				name = groupName.getText().toString().trim();
				desc = groupDesc.getText().toString().trim();
				OpenDialog2();
			}
		});
		cancel.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				dialog.dismiss();
			}
		});
		dialog.show();
	}
	void OpenDialog2(){
		final Dialog dial = new Dialog(OrgDetailActivity.this);
		dial.setTitle("Add participant");
		dial.setContentView(R.layout.layout_dialog);

		listcontent = (ListView) dial.findViewById(R.id.alert_list);
		Button next = (Button)dial.findViewById(R.id.btnNext);
		Button cancel = (Button)dial.findViewById(R.id.btnCancel);
		Engine.getMeWithRequest(getApplicationContext(),"Friends", new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try {
					JSONArray array = obj.getJSONArray("Friends");
					ArrayList<FriendReq>contactReq = new ArrayList<>();
					for(int i=0;i<array.length();i++){
						JSONObject ap = array.getJSONObject(i);
						FriendReq frQ = Converter.convertFriendRequest(ap);
						contactReq.add(frQ);
					}
					if(contactReq.size()>0){
						adap = new AddGroupAdapter(getApplicationContext(),contactReq);
						listcontent.setAdapter(adap);
					}else if(contactReq.size()==0){
						Toast.makeText(getApplicationContext(),"You need to have Friends", Toast.LENGTH_LONG).show();
						finish();
						Intent i = getIntent();
						startActivity(i);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}

			}
		});
		next.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				List<Integer> a = new ArrayList<>();
				for (FriendReq p : adap.getBox()) {
					if (p.box) {

						a.add(p.getId());
					}
				}
				int[]ids = new int[a.size()];
				for(int i=0; i<a.size();i++){
					ids[i]=a.get(i).intValue();
				}
				Engine.createGroup(getApplicationContext(), ids, name, desc, id,
						"group", new RequestTemplate.ServiceCallback() {
							@Override
							public void execute(JSONObject obj) {
								Toast.makeText(getApplicationContext(), "Successfull", Toast.LENGTH_SHORT).show();
								dial.dismiss();
								finish();
								startActivity(getIntent());
							}
						});
			}
		});
		cancel.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				dial.dismiss();
			}
		});
		dial.show();
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == PICK_IMAGE && resultCode == Activity.RESULT_OK) {
			if (ContextCompat.checkSelfPermission(OrgDetailActivity.this, android.Manifest.permission.READ_EXTERNAL_STORAGE)
					== PackageManager.PERMISSION_GRANTED) {

					Uri selectedImage = data.getData();
					//Bitmap bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), selectedImage);
					String path = getRealPathFromUri(selectedImage);
					File file = new File(path);
					final String a = "http://lfapp.learnflux.net/v1/groups/"+id+"/image";
					AndroidNetworking.put(a)
							.addFileBody(file)
							.addHeaders("Authorization", "Bearer " + User.getUser().getAccess_token())
							.setPriority(Priority.HIGH)
							.setExecutor(Executors.newSingleThreadExecutor())
							.build();


			}
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

	@Override
	protected void onResume() {
		super.onResume() ;
	}
}

