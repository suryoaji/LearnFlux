package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

public class OrgDetailActivity extends BaseActivity implements View.OnClickListener {
	ViewPager mViewPager;
	FragmentAdapter mAdap;
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
		tvNotifActivities=(TextView) findViewById(R.id.tvNotifActivities);
		tvNotifEvents=(TextView) findViewById(R.id.tvNotifEvents);
		tvNotifGroups=(TextView) findViewById(R.id.tvNotifGroups);

		LinearLayout titleLayout = (LinearLayout) findViewById(R.id.titleLayout);
		titleLayout.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent i = new Intent(OrgDetailActivity.this, OrgProfileActivity.class);
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
		mViewPager.setCurrentItem(1);

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

	public static class PlaceholderFragment extends Fragment {
		/**
		 * The fragment argument representing the section number for this
		 * fragment.
		 */
		private static final String ARG_SECTION_NUMBER = "section_number";

		/**
		 * Returns a new instance of this fragment for the given section
		 * number.
		 */
		public static PlaceholderFragment newInstance(int sectionNumber) {
			PlaceholderFragment fragment = new PlaceholderFragment();
			Bundle args = new Bundle();
			args.putInt(ARG_SECTION_NUMBER, sectionNumber);
			fragment.setArguments(args);
			return fragment;
		}

		public PlaceholderFragment() {
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
		                         Bundle savedInstanceState) {
			View rootView = inflater.inflate(R.layout.fragment_placeholder, container, false);
			TextView textView = (TextView) rootView.findViewById(R.id.section_label);
			textView.setText(getString(R.string.section_format, getArguments().getInt(ARG_SECTION_NUMBER)));
			return rootView;
		}
	}
}
