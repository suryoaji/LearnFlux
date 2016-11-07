package com.idesolusiasia.learnflux;


import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.adapter.GroupsGridRecyclerViewAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONException;
import org.json.JSONObject;

public class GroupProfileFragment extends Fragment {

	public String id;
	public Group group = null;
	TextView description;
	ImageView ivAdd;
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
		ivAdd = (ImageView)v.findViewById(R.id.ivAdd);
		description = (TextView)v.findViewById(R.id.textView39);
		id= getActivity().getIntent().getStringExtra("id");
		final String name = getActivity().getIntent().getStringExtra("title");
		String joinButton = getActivity().getIntent().getStringExtra("plusButton");
		if(joinButton.equalsIgnoreCase("hide")){
			ivAdd.setVisibility(View.GONE);
		}else if(joinButton.equalsIgnoreCase("show")) {
			ivAdd.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View view) {
					Engine.joinGroup(getContext(), id, "join", new RequestTemplate.ServiceCallback() {
						@Override
						public void execute(JSONObject obj) {
							Toast.makeText(getContext(),"Request to connect to "+ name +" sent" ,Toast.LENGTH_SHORT).show();
							Intent i= new Intent(getContext(), InterestGroup.class);
							startActivity(i);
						}
					});
				}
			});
		}
		getProfile();
		return v;
	}
	public void getProfile()
	{
		Engine.getOrganizationProfile(getActivity(), id, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONObject data = obj.getJSONObject("data");
					group = Converter.convertOrganizations(data);
					description.setText(group.getDescription());
				}catch (JSONException e){
					e.printStackTrace();
				}

			}
		});
	}
}