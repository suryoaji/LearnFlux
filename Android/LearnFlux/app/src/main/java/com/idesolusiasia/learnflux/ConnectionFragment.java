package com.idesolusiasia.learnflux;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.idesolusiasia.learnflux.db.DatabaseFunction;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class ConnectionFragment extends Fragment {

	// TODO: Customize parameters
	private int mColumnCount = 1;

	RecyclerView recyclerView;

	// TODO: Customize parameter initialization
	@SuppressWarnings("unused")
	public static ConnectionFragment newInstance() {
		ConnectionFragment fragment = new ConnectionFragment();
		return fragment;
	}

	public ConnectionFragment() {
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
	                         Bundle savedInstanceState) {
		View view = inflater.inflate(R.layout.fragment_connection, container, false);

		// Set the adapter
		if (view instanceof RecyclerView) {
			Context context = view.getContext();
			recyclerView = (RecyclerView) view;
			if (mColumnCount <= 1) {
				recyclerView.setLayoutManager(new LinearLayoutManager(context));
			} else {
				recyclerView.setLayoutManager(new GridLayoutManager(context, mColumnCount));
			}
			getFriend();
		}
		return view;
	}

	void getFriend(){
		Engine.getMyFriend(getContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try {
					JSONArray datas = obj.getJSONArray("data");
					ArrayList<Participant> p = new ArrayList<Participant>();
					for (int i=0;i<datas.length();i++){
						p.add(Converter.convertPeople(datas.getJSONObject(i)));
					}

					if (p.size()>=0){
						recyclerView.setAdapter(new PeopleAdapter(p));
						DatabaseFunction.insertParticipant(getContext(),p);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}

			}
		});
	}
}
