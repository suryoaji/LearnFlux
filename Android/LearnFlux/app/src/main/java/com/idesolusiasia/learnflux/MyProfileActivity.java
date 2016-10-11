package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.idesolusiasia.learnflux.adapter.MyProfileAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class MyProfileActivity extends BaseActivity implements View.OnClickListener {
	ViewPager mViewPager;
	FragmentAdapter mAdap;
	LinearLayout tabIndividual, tabGroups, tabOrganization, tabContact;
	View indicatorIndividual, indicatorGroups, indicatorOrganization, indicatorContact;
	MyProfileAdapter rcAdapter;
	int totalItem = 3;
	RecyclerView recyclerView;
	boolean visible;
	boolean visible2;
	ArrayList<Group> arrOrg = new ArrayList<Group>();
	static final int ITEMS = 4;

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

		// set recyclerView horizontal for affiliated organization
		recyclerView = (RecyclerView)findViewById(R.id.myProfileRecycler);
		LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false);
		recyclerView.setLayoutManager(linearLayoutManager);
		initOrganizations();


		//set tab hide/visiible for tab and the content
		final TextView myProfileTitle = (TextView) findViewById(R.id.myProfileTitle);
		final TextView connectionTitle = (TextView) findViewById(R.id.connectionTitle);
		final TextView textParentdesc = (TextView)findViewById(R.id.txtParentDesc);
		final TextView tvSeeMore = (TextView)findViewById(R.id.tvSeeMore);
		LinearLayout myProfileTab = (LinearLayout) findViewById(R.id.tabMyProfile);
		LinearLayout connectionTab = (LinearLayout) findViewById(R.id.tabConnection);
		final LinearLayout linear1 = (LinearLayout) findViewById(R.id.linear1);
		final LinearLayout linear2 = (LinearLayout) findViewById(R.id.linear2);
		final View line1 = (View) findViewById(R.id.line1);
		final View line2 = (View) findViewById(R.id.line2);


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



		//included layout with notification
		final View includedLayout = findViewById(R.id.mixLayout);
		final View includedLayout2 = findViewById(R.id.mixLayout2);
		ImageButton connectionNotif = (ImageButton)findViewById(R.id.imageButton2);
		ImageButton userNotif = (ImageButton)findViewById(R.id.menotif);
		final TextView txtNotification1 = (TextView)findViewById(R.id.textNotif1);
		final TextView txtNotification2 = (TextView)findViewById(R.id.textNotif2);
		visible=true;
		visible2=true;

		connectionNotif.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				if(visible || !visible2) {
					includedLayout.setVisibility(View.VISIBLE);
					includedLayout.bringToFront();
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
		textParentdesc.post(new Runnable() {
			@Override
			public void run() {
				int a = textParentdesc.getLineCount();
				if(a>1){
					tvSeeMore.setVisibility(View.VISIBLE);
					textParentdesc.setMaxLines(1);
				}
			}
		});
		tvSeeMore.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				textParentdesc.setMaxLines(Integer.MAX_VALUE);
				tvSeeMore.setVisibility(View.GONE);
			}
		});


		//include layout meNotif
		TextView textNotif = (TextView)findViewById(R.id.textView10);




		//Edit Profile
		TextView editProfile = (TextView)findViewById(R.id.editProfile);
		editProfile.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent edit = new Intent(MyProfileActivity.this, EditActivity.class);
				startActivity(edit);
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

		connectionTab.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				connectionTitle.setTextColor(Color.parseColor("#8bc34a"));
				line2.setVisibility(View.VISIBLE);
				line2.setBackgroundColor(Color.parseColor("#8bc34a"));
				linear1.setVisibility(View.GONE);
				myProfileTitle.setTextColor(Color.parseColor("#FFFFFF"));
				linear2.setVisibility(View.VISIBLE);
			}
		});
		myProfileTab.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				line2.setVisibility(View.GONE);
				myProfileTitle.setTextColor(Color.parseColor("#8bc34a"));
				line1.setVisibility(View.VISIBLE);
				line1.setBackgroundColor(Color.parseColor("#8bc34a"));
				linear1.setVisibility(View.VISIBLE);
				connectionTitle.setTextColor(Color.parseColor("#FFFFFF"));
				linear2.setVisibility(View.GONE);
			}
		});
		mViewPager.setCurrentItem(0);
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
			switch (position) {
				case 0:
					return IndividualFragment.newInstance();
				case 1:
					return ConnectionGroupFragment.newInstance();
				case 2:
					return ConnectionOrganizationFragment.newInstance();
				default:
					return OrgEventFragment.newInstance();
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
						recyclerView.setVisibility(View.GONE);
						//emptyView.setVisibility(View.VISIBLE);
					}else {
						rcAdapter = new MyProfileAdapter(getApplicationContext(), arrOrg);
						recyclerView.setAdapter(rcAdapter);
						//emptyView.setVisibility(View.GONE);
					}
				}catch (JSONException e){
					e.printStackTrace();
				}

			}
		});
	}
}