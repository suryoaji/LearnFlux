package com.idesolusiasia.learnflux.fragment;


import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.idesolusiasia.learnflux.activity.ChatsActivity;
import com.idesolusiasia.learnflux.InterestGroup;
import com.idesolusiasia.learnflux.R;

public class MosaicFragment extends Fragment {


	private StaggeredGridLayoutManager gaggeredGridLayoutManager;

	public MosaicFragment() {
		// Required empty public constructor
	}

	public static MosaicFragment newInstance() {
		MosaicFragment fragment = new MosaicFragment();
		return fragment;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
	                         Bundle savedInstanceState) {
		// Inflate the layout for this fragment
		View v = inflater.inflate(R.layout.activity_home, container, false);

		ImageView ivChat= (ImageView) v.findViewById(R.id.ivChat);
		ImageView ivInterest  = (ImageView)v.findViewById(R.id.ivInterest);
		ivInterest.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent a = new Intent(getActivity(), InterestGroup.class);
				startActivity(a);
			}
		});
		ivChat.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent i = new Intent(getActivity(),ChatsActivity.class);
				startActivity(i);
			}
		});
		return v;
	}

}
