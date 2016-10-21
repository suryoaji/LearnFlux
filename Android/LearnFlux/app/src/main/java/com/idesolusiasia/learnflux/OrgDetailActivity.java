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
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.idesolusiasia.learnflux.adapter.AddGroupAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.Member;
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
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class OrgDetailActivity extends BaseActivity implements View.OnClickListener {
	ViewPager mViewPager;
	FragmentAdapter mAdap;
	public String id, type, clickOrganization;
	public Group group = null;
	public Member member;
	AddGroupAdapter adap;
	public String name,desc,title;
	ListView listcontent;
	LinearLayout tabGroups, tabEvents, tabActivities;
	View indicatorGroups, indicatorEvents, indicatorAct;
	TextView tvNotifGroups, tvNotifActivities, tvNotifEvents, tvTitle;
	static final int ITEMS = 3;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_base);
		super.onCreateDrawer(savedInstanceState);



		FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
		id = getIntent().getStringExtra("id");
		title = getIntent().getStringExtra("title");
		type = getIntent().getStringExtra("type");
		clickOrganization = getIntent().getStringExtra("clickOrganization");
		Log.i("TEST", "onCreate: " + id);
		final LayoutInflater layoutInflater = LayoutInflater.from(this);
		View childLayout = layoutInflater.inflate(
				R.layout.activity_org_detail, null);

		parentLayout.addView(childLayout);
		Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);
		tvTitle= (TextView)findViewById(R.id.textView14);
		tvTitle.setText(title);
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
				return true;
			case R.id.new_event:
				addEventProcess();
				return true;
			case R.id.new_group:
				addInterestNewGroup();
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
				Engine.createEvent(getApplicationContext(), true, etTitle.getText().toString(), etDesc.getText().toString(),
						etLocation.getText().toString(), calStart.getTimeInMillis() / 1000, null, id, type, new RequestTemplate.ServiceCallback() {
					@Override
					public void execute(JSONObject obj) {
						Log.i("Data Event", "execute: "+id+", "+type);
						Toast.makeText(getApplicationContext(),"successfully send the data", Toast.LENGTH_SHORT).show();
						dialog.dismiss();
						Intent startActivity = getIntent();
						finish();
						startActivity(startActivity);
					}
				});
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
		Engine.getMyFriend(getApplicationContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try {
					JSONArray datas = obj.getJSONArray("data");
					ArrayList<Participant> p = new ArrayList<Participant>();
					for (int i=0;i<datas.length();i++){
						Participant participant = Converter.convertPeople(datas.getJSONObject(i));
						if (participant.getId()!= User.getUser().getID()){
							p.add(participant);
						}
					}

					if (p.size()>=0){
						adap = new AddGroupAdapter(getApplicationContext(), p);
						listcontent.setAdapter(adap);
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
				for (Participant p : adap.getBox()) {
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
	protected void onResume() {
		super.onResume();
	}
}

