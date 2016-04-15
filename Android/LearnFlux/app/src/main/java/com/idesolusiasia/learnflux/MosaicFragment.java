package com.idesolusiasia.learnflux;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.idesolusiasia.learnflux.adapter.TileRecyclerViewAdapter;

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

		RecyclerView mosaicRecycler = (RecyclerView) v.findViewById(R.id.mosaic_recycler_view);
		mosaicRecycler.setHasFixedSize(true);

		gaggeredGridLayoutManager = new StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL);
		mosaicRecycler.setLayoutManager(gaggeredGridLayoutManager);

		TileRecyclerViewAdapter adapter = new TileRecyclerViewAdapter(getContext());
		mosaicRecycler.setAdapter(adapter);
		return v;
	}

}
