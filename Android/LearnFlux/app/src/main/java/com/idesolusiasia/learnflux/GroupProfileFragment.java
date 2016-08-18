package com.idesolusiasia.learnflux;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

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
		id= getActivity().getIntent().getStringExtra("id");
		getProfile();
		description = (TextView)v.findViewById(R.id.textView39);
		return v;
	}
	private void getProfile()
	{
		Engine.getOrganizationProfile(getActivity(), id, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONObject data = obj.getJSONObject("data");
					group = Converter.convertOrganizations(data);
				}catch (JSONException e){
					e.printStackTrace();
				}
				description.setText(group.getDescription());
			}
		});
	}
}