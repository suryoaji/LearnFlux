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
import com.idesolusiasia.learnflux.adapter.OrganizationEventAdapter;
import com.idesolusiasia.learnflux.entity.Event;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.ItemOffsetDecoration;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class OrgEventFragment extends Fragment {
	RecyclerView recyclerView;
	OrganizationEventAdapter adap;
	TextView emptyView;
	public Event event=null;
	private GridLayoutManager lLayout;
	ArrayList<Event> events= new ArrayList<>();
	String[] value;
	public String id;
	public static OrgEventFragment newInstance() {
		OrgEventFragment fragment = new OrgEventFragment();
		return fragment;
	}

	public OrgEventFragment() {
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
		View v= inflater.inflate(R.layout.fragment_org_event, container, false);
		recyclerView=(RecyclerView) v.findViewById(R.id.recyclerView);
		recyclerView.setHasFixedSize(true);
		emptyView = (TextView) v.findViewById(R.id.empty_view);
		lLayout = new GridLayoutManager(getContext(),1);
		recyclerView.setLayoutManager(lLayout);
		ItemOffsetDecoration itemDecoration = new ItemOffsetDecoration(getContext(), R.dimen.item_offset);
		recyclerView.addItemDecoration(itemDecoration);
		id = getActivity().getIntent().getStringExtra("id");
		//initEvent();
		getEventByGroupID();
		return v;
	}
	void getEventByGroupID() {
		events = new ArrayList<>();
		Engine.getGroupEventByGroupId(getContext(), id, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try {
					JSONArray data = obj.getJSONArray("data");
					for (int i = 0; i < data.length(); i++) {
						event = Converter.convertEvent(data.getJSONObject(i));
						events.add(event);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
				if(events.isEmpty()){
					recyclerView.setVisibility(View.GONE);
					emptyView.setVisibility(View.VISIBLE);
				}else {
					adap = new OrganizationEventAdapter(getContext(), events);
					recyclerView.setAdapter(adap);
					adap.setFirstSelection=true;
					emptyView.setVisibility(View.GONE);
				}
			}
		});
	}

}
