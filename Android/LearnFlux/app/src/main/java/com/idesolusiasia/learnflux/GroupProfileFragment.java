package com.idesolusiasia.learnflux;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class GroupProfileFragment extends Fragment {

	public static GroupProfileFragment newInstance() {
		GroupProfileFragment fragment = new GroupProfileFragment();
		return fragment;
	}

	public GroupProfileFragment() {
		// Required empty public constructor
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
	                         Bundle savedInstanceState) {
		// Inflate the layout for this fragment
		View v= inflater.inflate(R.layout.fragment_group_profile, container, false);

		return v;
	}
}