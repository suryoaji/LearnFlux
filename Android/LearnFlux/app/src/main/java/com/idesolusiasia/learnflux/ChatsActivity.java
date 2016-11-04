package com.idesolusiasia.learnflux;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.Toolbar;
import android.text.InputType;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.adapter.AddGroupAdapter;
import com.idesolusiasia.learnflux.entity.FriendReq;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class ChatsActivity extends BaseActivity {


	private SectionsPagerAdapter mSectionsPagerAdapter;
	private ViewPager mViewPager;
	ListView listcontent;
	AddGroupAdapter adap;
	public String name,desc;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_chats);
		super.onCreateDrawer(savedInstanceState);

		String i = getIntent().getStringExtra("chatroom");
		//Engine.createThread(this,new int[]{7},"Hey Tester!");



		Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);
		getSupportActionBar().setDisplayHomeAsUpEnabled(false);
		// Create the adapter that will return a fragment for each of the three
		// primary sections of the activity.
		mSectionsPagerAdapter = new SectionsPagerAdapter(getSupportFragmentManager());

		// Set up the ViewPager with the sections adapter.
		mViewPager = (ViewPager) findViewById(R.id.container);
		mViewPager.setAdapter(mSectionsPagerAdapter);

		if(i.equalsIgnoreCase("org")){
			mViewPager.setCurrentItem(1);
		}
		else if(i.equalsIgnoreCase("chat")){
			mViewPager.setCurrentItem(2);
		}


		TabLayout tabLayout = (TabLayout) findViewById(R.id.tabs);
		tabLayout.setupWithViewPager(mViewPager);

		FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
		fab.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
						.setAction("Action", null).show();
			}
		});
		fab.hide();
		invalidateOptionsMenu();
	}


	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.interest_menu_creategroup, menu);
		return true;
	}

	@Override
	public boolean onPrepareOptionsMenu(Menu menu) {
		menu.clear();
		if (mViewPager.getCurrentItem()==0){
			getMenuInflater().inflate(R.menu.group_chat, menu);
		}else if(mViewPager.getCurrentItem()==2){
			getMenuInflater().inflate(R.menu.interest_menu_creategroup, menu);
		} else{
			getMenuInflater().inflate(R.menu.org_newgroup, menu);
		}
		return super.onPrepareOptionsMenu(menu);
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();

		//noinspection SimplifiableIfStatement
		if (id == R.id.new_Organization) {
			createOrganization("organization");
			return true;
		}else if (id == R.id.new_group){
					createOrganization("group");
					return true;
			}

		return super.onOptionsItemSelected(item);
	}


	public class SectionsPagerAdapter extends FragmentPagerAdapter {

		public SectionsPagerAdapter(FragmentManager fm) {
			super(fm);
		}

		@Override
		public Fragment getItem(int position) {
			// getItem is called to instantiate the fragment for the given page.
			// Return a PlaceholderFragment (defined as a static inner class below).
			if (position==2){
				return ChatroomFragment.newInstance();
			}else if (position==1){
				return OrganizationsFragment.newInstance();
			}else{
				return ConnectionFragment.newInstance();
			}
		}

		@Override
		public int getCount() {
			// Show 3 total pages.
			return 3;
		}

		@Override
		public CharSequence getPageTitle(int position) {
			switch (position) {
				case 0:
					return "Connections";
				case 1:
					return "Organizations";
				case 2:
					return "Chats";
			}
			return null;
		}
	}
	public void createOrganization(final String type){
		final Dialog dialog = new Dialog(ChatsActivity.this);
		dialog.setTitle("Add new Group");
		dialog.setContentView(R.layout.dialog_add_group);
		final EditText groupName = (EditText) dialog.findViewById(R.id.add_group_name);
		final EditText groupDesc = (EditText) dialog.findViewById(R.id.add_group_description);
		groupName.setInputType(InputType.TYPE_TEXT_FLAG_CAP_SENTENCES);
		Button btnNext = (Button)dialog.findViewById(R.id.btnNext);
		Button cancel = (Button)dialog.findViewById(R.id.btnCancel);
		btnNext.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				name = groupName.getText().toString().trim();
				desc = groupDesc.getText().toString().trim();
				OpenDialog2(type);
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
	void OpenDialog2(final String type){
		final Dialog dial = new Dialog(ChatsActivity.this);
		dial.setTitle("Add participant");
		dial.setContentView(R.layout.layout_dialog);
		listcontent = (ListView) dial.findViewById(R.id.alert_list);
		Button next = (Button)dial.findViewById(R.id.btnNext);
		Button cancel = (Button)dial.findViewById(R.id.btnCancel);
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
				Engine.createGroup(getApplicationContext(), ids, name, desc, null,
						type, new RequestTemplate.ServiceCallback() {
							@Override
							public void execute(JSONObject obj) {
								Toast.makeText(getApplicationContext(), "successfull", Toast.LENGTH_SHORT).show();
								dial.dismiss();
								finish();
								Intent i = getIntent();
								i.putExtra("chatroom", "org");
								startActivity(i);
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
		Engine.getMeWithRequest(getApplicationContext(),"friends", new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try {
					JSONArray array = obj.getJSONArray("friends");
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
						Toast.makeText(getApplicationContext(),"You need to have friends", Toast.LENGTH_LONG).show();
						finish();
						Intent i = getIntent();
						startActivity(i);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}

			}
		});
		dial.show();


	}

}
