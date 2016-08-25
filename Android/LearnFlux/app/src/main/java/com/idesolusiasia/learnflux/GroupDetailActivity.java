package com.idesolusiasia.learnflux;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.ActionMode;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AbsListView;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.idesolusiasia.learnflux.adapter.PeopleAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

public class GroupDetailActivity extends BaseActivity implements View.OnClickListener {
	ViewPager mViewPager;
	FragmentAdapter mAdap;
	public int color;
	TextView title;
	public Group group=null;
	LinearLayout tabGroups, tabEvents, tabActivities;
	View indicatorGroups, indicatorEvents, indicatorAct;
	public String name, id, reTitle, details, type, location;
	TextView tvNotifActivities, tvNotifEvents;
	static final int ITEMS = 3;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_base);
		super.onCreateDrawer(savedInstanceState);

		FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
		final LayoutInflater layoutInflater = LayoutInflater.from(this);
		View childLayout = layoutInflater.inflate(
				R.layout.activity_group_detail, null);
		parentLayout.addView(childLayout);
		Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);
		FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
		fab.hide();
		id = getIntent().getStringExtra("id");
		type = getIntent().getStringExtra("type");
		Log.i("IDS", "onCreate: " +id);
		name = getIntent().getStringExtra("title");
		color = getIntent().getIntExtra("color",1);
		///////////////////////////finish Base Init///
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
		checkID();
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
//		getMenuInflater().inflate(R.menu.interest_menu, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		switch(item.getItemId()){
			case R.id.interest_invite_people:
				return true;
			case R.id.interest_new_event:
				addEventProcess();
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
					getMenuInflater().inflate(R.menu.interest_menu, menu);
				}
			}
		}
		return super.onPrepareOptionsMenu(menu);
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
				Engine.createEvent(getApplicationContext(), true, etTitle.getText().toString(), etDesc.getText().toString(),
						etLocation.getText().toString(), calStart.getTimeInMillis() / 1000, null, id, type, new RequestTemplate.ServiceCallback() {
					@Override
					public void execute(JSONObject obj) {
						Log.i("Data Event", "execute: "+ title+", "+location+", "+id+", "+type);
						Toast.makeText(getApplicationContext(),"successfully send the data", Toast.LENGTH_SHORT).show();
						dialog.dismiss();
					}
				});
			}
		});
		dialog.show();
	}
	public void addInterestNewGroup(){
		final Dialog dialog = new Dialog(GroupDetailActivity.this);
		dialog.setTitle("Add new Group");
		dialog.setContentView(R.layout.dialog_add_group);
		final EditText groupName = (EditText) dialog.findViewById(R.id.add_group_name);
		final EditText groupDesc = (EditText) dialog.findViewById(R.id.add_group_description);
		Button btnNext = (Button)dialog.findViewById(R.id.btnNext);
		Button cancel = (Button)dialog.findViewById(R.id.btnCancel);
		btnNext.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				String name = groupName.getText().toString().trim();
				String desc = groupDesc.getText().toString().trim();
				//OpenDialog2();
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

	@Override
	protected void onResume() {
		super.onResume();
	}

}
