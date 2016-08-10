package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.idesolusiasia.learnflux.adapter.GroupsGridRecyclerViewAdapter;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.ItemOffsetDecoration;

import java.util.ArrayList;
import java.util.List;


public class OrgGroupFragment extends Fragment {
	private GridLayoutManager lLayout;

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


		RecyclerView rView = (RecyclerView)v.findViewById(R.id.recycler_view);
		rView.setHasFixedSize(true);
		rView.setLayoutManager(lLayout);
		ItemOffsetDecoration itemDecoration = new ItemOffsetDecoration(getContext(), R.dimen.item_offset);
		rView.addItemDecoration(itemDecoration);

	/*	GroupsGridRecyclerViewAdapter rcAdapter = new GroupsGridRecyclerViewAdapter(getContext(), rowListItem);
		rView.setAdapter(rcAdapter);*/

		return v;
	}

}
