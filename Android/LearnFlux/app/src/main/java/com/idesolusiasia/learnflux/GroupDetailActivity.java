package com.idesolusiasia.learnflux;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.RecyclerView;
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
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.adapter.CheckListPeopleAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Member;
import com.idesolusiasia.learnflux.entity.PeopleInvite;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;
import com.koushikdutta.ion.Ion;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

public class GroupDetailActivity extends BaseActivity implements View.OnClickListener {
	ViewPager mViewPager;
	FragmentAdapter mAdap;
	public int color;
	TextView title;
	public Group group=null;
	LinearLayout tabGroups, tabEvents, tabActivities;
	View indicatorGroups, indicatorEvents, indicatorAct;
	public String name, id, reTitle, details, type, location,img;
	TextView tvNotifActivities, tvNotifEvents;
	static final int ITEMS = 3;
	ImageView imageGroup;
	ImageView ivAdd;
	ImageLoader imageLoader = VolleySingleton.getInstance(GroupDetailActivity.this).getImageLoader();
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_base);
		super.onCreateDrawer(savedInstanceState);

		final FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
		final LayoutInflater layoutInflater = LayoutInflater.from(this);
		View childLayout = layoutInflater.inflate(
				R.layout.activity_group_details, null);
		parentLayout.addView(childLayout);


		String url="http://lfapp.learnflux.net/v1/image?key=";
		id = getIntent().getStringExtra("id");
		type = getIntent().getStringExtra("type");
		name = getIntent().getStringExtra("title");
		color = getIntent().getIntExtra("color",1);
		img = getIntent().getStringExtra("img");

		///////////////////////////finish Base Init///
		imageGroup = (ImageView)findViewById(R.id.imageOfGroupDetail);
		Animation animation = AnimationUtils.loadAnimation(getApplicationContext(),
				R.anim.popup_enter);
		if(img!=null) {
			Ion.with(getApplicationContext())
					.load(url+img)
					.addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
					.withBitmap().animateLoad(animation)
					.intoImageView(imageGroup);
		}
		else{
			imageGroup.setImageResource(R.drawable.company1);
		}
		ivAdd = (ImageView)findViewById(R.id.ivAdd);
		final String name = getIntent().getStringExtra("title");
		String joinButton = getIntent().getStringExtra("plusButton");
		if(joinButton.equalsIgnoreCase("hide")){
			ivAdd.setVisibility(View.GONE);
		}else if(joinButton.equalsIgnoreCase("show")) {
			ivAdd.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(final View view) {
					Engine.getMeWithRequest(view.getContext(), "details", new RequestTemplate.ServiceCallback() {
						@Override
						public void execute(JSONObject obj) {
							try {
								JSONObject embedded = obj.getJSONObject("_embedded");
								if(embedded.has("groups")) {
									JSONArray group = embedded.getJSONArray("groups");
									ArrayList<String> arrayId = new ArrayList<String>();
									for(int i=0;i<group.length();i++){
									JSONObject data = group.getJSONObject(i);
									String ids = data.getString("id");
										arrayId.add(ids);
									}
									if(arrayId.contains(id)){
										Functions.showAlert(view.getContext(), "Message", "You already member on this group");
									}else{
										Engine.joinGroup(view.getContext(), id, "join", new RequestTemplate.ServiceCallback() {
											@Override
											public void execute(JSONObject obj) {
											Toast.makeText(view.getContext(),"Request to connect to "+ name +" sent", Toast.LENGTH_LONG).show();
												Intent i= new Intent(getApplicationContext(), InterestGroup.class);
												startActivity(i);

											}
										});
									}

								}


							}catch (JSONException e){
								e.printStackTrace();
							}
						}
					});
				}
			});
		}
		title = (TextView)findViewById(R.id.tvGroupTitle);
		title.setText(name);
		title.setBackgroundColor(Integer.valueOf(color));
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
	/*	tvNotifActivities=(TextView) findViewById(R.id.tvNotifActivities);
		tvNotifEvents=(TextView) findViewById(R.id.tvNotifEvents);*/

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
	}

	@Override
	public void onClick(View v) {
		if (v==tabEvents){
			mViewPager.setCurrentItem(1);
		}else if (v==tabActivities){
			mViewPager.setCurrentItem(2);
		}else if (v==tabGroups){
			mViewPager.setCurrentItem(0);
		}
	}

	void selectTab(int pos){
		indicatorGroups.setVisibility(View.GONE);
		indicatorAct.setVisibility(View.GONE);
		indicatorEvents.setVisibility(View.GONE);
		if(pos==1) {
			indicatorEvents.setVisibility(View.VISIBLE);
		}else if(pos==2) {
			indicatorAct.setVisibility(View.VISIBLE);
		}else if(pos==0) {
			indicatorGroups.setVisibility(View.VISIBLE);
		}
	}

	public static class FragmentAdapter extends FragmentPagerAdapter{

		public FragmentAdapter(FragmentManager fm) {
			super(fm);
		}

		@Override
		public Fragment getItem(int position) {
			switch (position) {
				case 1:
					return OrgEventFragment.newInstance();
				case 2:
					return OrgActivityFragment.newInstance();
				default:
					return GroupProfileFragment.newInstance();
			}
		}

		@Override
		public int getCount() {
			return ITEMS;
		}
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.interest_menu, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		switch(item.getItemId()){
			case R.id.interest_invite_people:
				Engine.getOrganizationProfile(getApplicationContext(), id, new RequestTemplate.ServiceCallback() {
					@Override
					public void execute(JSONObject obj) {
						try{
							JSONObject data = obj.getJSONObject("data");
							Group group = Converter.convertOrganizations(data);
							if(group!=null){
								if(group.getAdminID()!=-1){
									if(User.getUser().getID()==group.getAdminID()){
										Intent people = new Intent(GroupDetailActivity.this, InvitePeople.class);
										people.putExtra("ids", id);
										startActivity(people);
									}else{
										Functions.showAlert(GroupDetailActivity.this,"Notification", "You do not have this access");
									}
								}
							}


						}catch (JSONException e){
							e.printStackTrace();
						}
					}
				});

				return true;
			case R.id.interest_new_event:
				addEventProcess();
				return true;
		}

		return super.onOptionsItemSelected(item);
	}
	public void addEventProcess(){
		final Dialog dialog = new Dialog(GroupDetailActivity.this);
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
				DatePickerDialog datePickerDialog = new DatePickerDialog(GroupDetailActivity.this, new DatePickerDialog.OnDateSetListener() {

					public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
						calStart.set(year,monthOfYear,dayOfMonth);
						etDate.setText(dateFormatter.format(calStart.getTime()));
					}

				},calStart.get(Calendar.YEAR), calStart.get(Calendar.MONTH), calStart.get(Calendar.DAY_OF_MONTH));
				datePickerDialog.show();
			}
		});

		final SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm", Locale.US);
		etStart.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				TimePickerDialog timePickerDialog = new TimePickerDialog(GroupDetailActivity.this, new TimePickerDialog.OnTimeSetListener() {

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
		Button btnAdd = (Button)dialog.findViewById(R.id.btnSubmitEvent);
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
									Log.i("Data Event", "execute: " + title + ", " + location + ", " + id + ", " + type);
									Toast.makeText(getApplicationContext(), "successfully send the data", Toast.LENGTH_SHORT).show();
									dialog.dismiss();
									finish();
									startActivity(getIntent());
								}
							});
				}
			}
		});
		dialog.show();
	}

}
