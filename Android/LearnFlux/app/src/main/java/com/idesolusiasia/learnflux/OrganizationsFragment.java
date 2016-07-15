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
import com.idesolusiasia.learnflux.util.ItemOffsetDecoration;

import java.util.ArrayList;
import java.util.List;

public class OrganizationsFragment extends Fragment {

	private GridLayoutManager lLayout;

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

		List<String> rowListItem = getAllItemList();
		lLayout = new GridLayoutManager(getContext(),2);


		RecyclerView rView = (RecyclerView)v.findViewById(R.id.recycler_view);
		rView.setHasFixedSize(true);
		rView.setLayoutManager(lLayout);
		ItemOffsetDecoration itemDecoration = new ItemOffsetDecoration(getContext(), R.dimen.item_offset);
		rView.addItemDecoration(itemDecoration);

		OrganizationGridRecyclerViewAdapter rcAdapter = new OrganizationGridRecyclerViewAdapter(getContext(), rowListItem);
		rView.setAdapter(rcAdapter);
		return v;
	}

	private List<String> getAllItemList() {
		List<String> allItems = new ArrayList<String>();
		allItems.add("Young Men's Christian Association");
		allItems.add("SGCarer");
		allItems.add("NAFA Alumni");

		return allItems;
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
