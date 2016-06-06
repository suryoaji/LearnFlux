package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class OrgDetailFragment extends Fragment {

	public static OrgDetailFragment newInstance(String param1, String param2) {
		OrgDetailFragment fragment = new OrgDetailFragment();
		Bundle args = new Bundle();

		fragment.setArguments(args);
		return fragment;
	}	public OrgDetailFragment() {
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
		return inflater.inflate(R.layout.fragment_org_detail, container, false);
	}

}
