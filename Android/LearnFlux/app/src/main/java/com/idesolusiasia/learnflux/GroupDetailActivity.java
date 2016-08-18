package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

public class GroupDetailActivity extends BaseActivity implements View.OnClickListener {
	ViewPager mViewPager;
	FragmentAdapter mAdap;
	public String name,id;
	public int color;
	TextView title;
	LinearLayout tabGroups, tabEvents, tabActivities;
	View indicatorGroups, indicatorEvents, indicatorAct;
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
		id= getIntent().getStringExtra("id");
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
}
