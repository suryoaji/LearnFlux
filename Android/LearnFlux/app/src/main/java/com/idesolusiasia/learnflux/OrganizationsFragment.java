package com.idesolusiasia.learnflux;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.idesolusiasia.learnflux.adapter.OrganizationGridRecyclerViewAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.ItemOffsetDecoration;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class OrganizationsFragment extends Fragment {

	private GridLayoutManager lLayout;
	OrganizationGridRecyclerViewAdapter rcAdapter;
	ArrayList<Group> arrOrg = new ArrayList<Group>();
	RecyclerView rView;

	public OrganizationsFragment() {
		// Required empty public constructor
	}

	// TODO: Rename and change types and number of parameters
	public static OrganizationsFragment newInstance() {
		OrganizationsFragment fragment = new OrganizationsFragment();
		Bundle args = new Bundle();
		fragment.setArguments(args);
		return fragment;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if (getArguments() != null) {
		}
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
	                         Bundle savedInstanceState) {
		// Inflate the layout for this fragment
		View v = inflater.inflate(R.layout.fragment_organizations, container, false);

		lLayout = new GridLayoutManager(getContext(),2);


		rView = (RecyclerView)v.findViewById(R.id.recycler_view);
		rView.setHasFixedSize(true);
		rView.setLayoutManager(lLayout);
		ItemOffsetDecoration itemDecoration = new ItemOffsetDecoration(getContext(), R.dimen.item_offset);
		rView.addItemDecoration(itemDecoration);

		initOrganizations();
		return v;
	}
	void initOrganizations(){
		arrOrg = new ArrayList<>();
		Engine.getOrganizations(getContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONArray array = obj.getJSONArray("data");

					for(int i=0;i<array.length();i++){
						Group org = Converter.convertOrganizations(array.getJSONObject(i));
						arrOrg.add(org);
					}
					rcAdapter = new OrganizationGridRecyclerViewAdapter(getContext(),arrOrg);
					rView.setAdapter(rcAdapter);
				}catch (JSONException e){
					e.printStackTrace();
				}

			}
		});
	}
	@Override
	public void onAttach(Context context) {
		super.onAttach(context);
	}

	@Override
	public void onDetach() {
		super.onDetach();
	}
}
