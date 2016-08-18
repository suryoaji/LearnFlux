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
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class OrgDetailActivity extends BaseActivity implements View.OnClickListener {
	ViewPager mViewPager;
	FragmentAdapter mAdap;
	public String id, title, details, type, location;
	LinearLayout tabGroups, tabEvents, tabActivities;
	View indicatorGroups, indicatorEvents, indicatorAct;
	TextView tvNotifGroups, tvNotifActivities, tvNotifEvents;
	static final int ITEMS = 3;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_base);
		super.onCreateDrawer(savedInstanceState);

		FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
		id = getIntent().getStringExtra("id");
		type = getIntent().getStringExtra("type");
		Log.i("TEST", "onCreate: " + id);
		final LayoutInflater layoutInflater = LayoutInflater.from(this);
		View childLayout = layoutInflater.inflate(
				R.layout.activity_org_detail, null);
		parentLayout.addView(childLayout);
		Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);
		FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
		fab.hide();

		///////////////////////////finish Base Init///

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
				Log.i("Detail Activity", "onClick: " + id);
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
		mViewPager.setCurrentItem(0);

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
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.menu_group, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {

		switch(item.getItemId()){
			case R.id.invite_people:
				return true;
			case R.id.new_event:
				addEventProcess();
				return true;
			case R.id.new_group:
				addNewGroup();
				return true;
		}

		return super.onOptionsItemSelected(item);
	}
	public void addEventProcess(){
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
		Button btnAdd = (Button)dialog.findViewById(R.id.btnSubmitEvent);
		btnAdd.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				details = etDesc.getText().toString().trim();
				title = etTitle.getText().toString().trim();
				location = etLocation.getText().toString().trim();
				Date date = calStart.getTime();
				Long miliseconds= date.getTime();
				Engine.createEvent(getApplicationContext(), true, title, details, location, miliseconds, null, id, type, new RequestTemplate.ServiceCallback() {
					@Override
					public void execute(JSONObject obj) {
						Log.i("Data Event", "execute: "+ title+", "+location+", "+id+", "+type);
						Toast.makeText(getApplicationContext(),"successfully send the data", Toast.LENGTH_SHORT).show();
						Intent event = new Intent(OrgDetailActivity.this, OrgEventFragment.class);
						event.putExtra("id",id);
						startActivity(event);
						dialog.dismiss();
					}
				});
			}
		});
		dialog.show();
	}
	public void addNewGroup(){
		final Dialog dialog = new Dialog(OrgDetailActivity.this);
		dialog.setTitle("add group");
		dialog.setContentView(R.layout.dialog_add_group);
		Button btnSubmit = (Button)dialog.findViewById(R.id.btnNext);
		Button cancel = (Button)dialog.findViewById(R.id.btnCancel);
		btnSubmit.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				//Engine.createGroup(getApplicationContext(),);
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
}
