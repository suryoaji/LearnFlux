package com.idesolusiasia.learnflux.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.adapter.GroupsGridRecyclerViewAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.ItemOffsetDecoration;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONException;
import org.json.JSONObject;


public class OrgGroupFragment extends Fragment {
	private GridLayoutManager lLayout;
	public Group group =null;
	public String id;
	RecyclerView rView;
	TextView emptyView;

	public static OrgGroupFragment newInstance() {
		OrgGroupFragment fragment = new OrgGroupFragment();
		return fragment;
	}	public OrgGroupFragment() {
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
		View v= inflater.inflate(R.layout.fragment_org_group, container, false);
		lLayout = new GridLayoutManager(getContext(),2);
		id= getActivity().getIntent().getStringExtra("id");
		getProfile();

		emptyView = (TextView) v.findViewById(R.id.empty_view);
		rView = (RecyclerView)v.findViewById(R.id.recycler_view);
		rView.setHasFixedSize(true);
		rView.setLayoutManager(lLayout);
		ItemOffsetDecoration itemDecoration = new ItemOffsetDecoration(getContext(), R.dimen.item_offset);
		rView.addItemDecoration(itemDecoration);
		return v;
	}
	private void getProfile(){
		Engine.getOrganizationProfile(getContext(), id, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONObject data = obj.getJSONObject("data");
					group = Converter.convertOrganizations(data);
					if(group.getChild().isEmpty()) {
						rView.setVisibility(View.GONE);
						emptyView.setVisibility(View.VISIBLE);
					}else{
						GroupsGridRecyclerViewAdapter rcAdapter = new GroupsGridRecyclerViewAdapter(getContext(), group.getChild());
						rView.setAdapter(rcAdapter);
						emptyView.setVisibility(View.GONE);
					}

				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}

}
