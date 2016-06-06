package com.idesolusiasia.learnflux;

import android.graphics.Color;
import android.os.Build;
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
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.idesolusiasia.learnflux.util.OrgEventFragment;

public class OrgDetailActivity extends BaseActivity implements View.OnClickListener {
	ViewPager mViewPager;
	FragmentAdapter mAdap;
	RelativeLayout tabGroups, tabEvents, tabActivities;
	TextView tvGroups, tvEvents, tvActivities, tvNotifGroups, tvNotifActivities, tvNotifEvents;
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
		tabGroups=(RelativeLayout) findViewById(R.id.tabGroups);
		tabEvents=(RelativeLayout) findViewById(R.id.tabEvents);
		tabActivities=(RelativeLayout) findViewById(R.id.tabActivities);
		tabGroups.setOnClickListener(this);
		tabEvents.setOnClickListener(this);
		tabActivities.setOnClickListener(this);
		tvGroups=(TextView) findViewById(R.id.tvGroups);
		tvEvents=(TextView) findViewById(R.id.tvEvents);
		tvActivities=(TextView) findViewById(R.id.tvActivities);
		tvNotifActivities=(TextView) findViewById(R.id.tvNotifActivities);
		tvNotifEvents=(TextView) findViewById(R.id.tvNotifEvents);
		tvNotifGroups=(TextView) findViewById(R.id.tvNotifGroups);


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
		if (pos==0){
			tabGroups.setBackgroundColor(Color.parseColor(getString(R.string.color_primary)));
			tvGroups.setTextColor(Color.parseColor("#FFFFFF"));

			tabEvents.setBackgroundResource(R.drawable.border);
			tvEvents.setTextColor(Color.parseColor(getString(R.string.color_primary)));
			tabActivities.setBackgroundResource(R.drawable.border);
			tvActivities.setTextColor(Color.parseColor(getString(R.string.color_primary)));
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
				tvNotifGroups.setBackground(getDrawable(R.drawable.round_background_white));
				tvNotifGroups.setTextColor(Color.parseColor(getString(R.string.color_primary)));

				tvNotifEvents.setBackground(getDrawable(R.drawable.round_background_green));
				tvNotifEvents.setTextColor(Color.parseColor("#FFFFFF"));
				tvNotifActivities.setBackground(getDrawable(R.drawable.round_background_green));
				tvNotifActivities.setTextColor(Color.parseColor("#FFFFFF"));
			}
		}else if(pos==1) {
			tabEvents.setBackgroundColor(Color.parseColor(getString(R.string.color_primary)));
			tvEvents.setTextColor(Color.parseColor("#FFFFFF"));

			tabGroups.setBackgroundResource(R.drawable.border);
			tvGroups.setTextColor(Color.parseColor(getString(R.string.color_primary)));
			tabActivities.setBackgroundResource(R.drawable.border);
			tvActivities.setTextColor(Color.parseColor(getString(R.string.color_primary)));
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
				tvNotifEvents.setBackground(getDrawable(R.drawable.round_background_white));
				tvNotifEvents.setTextColor(Color.parseColor(getString(R.string.color_primary)));

				tvNotifGroups.setBackground(getDrawable(R.drawable.round_background_green));
				tvNotifGroups.setTextColor(Color.parseColor("#FFFFFF"));
				tvNotifActivities.setBackground(getDrawable(R.drawable.round_background_green));
				tvNotifActivities.setTextColor(Color.parseColor("#FFFFFF"));
			}
		}else{
			tabActivities.setBackgroundColor(Color.parseColor(getString(R.string.color_primary)));
			tvActivities.setTextColor(Color.parseColor("#FFFFFF"));

			tabGroups.setBackgroundResource(R.drawable.border);
			tvGroups.setTextColor(Color.parseColor(getString(R.string.color_primary)));
			tabEvents.setBackgroundResource(R.drawable.border);
			tvEvents.setTextColor(Color.parseColor(getString(R.string.color_primary)));
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
				tvNotifActivities.setBackground(getDrawable(R.drawable.round_background_white));
				tvNotifActivities.setTextColor(Color.parseColor(getString(R.string.color_primary)));

				tvNotifGroups.setBackground(getDrawable(R.drawable.round_background_green));
				tvNotifGroups.setTextColor(Color.parseColor("#FFFFFF"));
				tvNotifEvents.setBackground(getDrawable(R.drawable.round_background_green));
				tvNotifEvents.setTextColor(Color.parseColor("#FFFFFF"));
			}
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
					return PlaceholderFragment.newInstance(0);
				case 1:
					return OrgEventFragment.newInstance();
				default:
					return PlaceholderFragment.newInstance(2);
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
