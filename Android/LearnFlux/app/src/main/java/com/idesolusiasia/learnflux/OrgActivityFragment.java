package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.adapter.OrganizationActivityAdapter;
import com.idesolusiasia.learnflux.entity.Activity;

import java.util.ArrayList;
import java.util.Calendar;

public class OrgActivityFragment extends Fragment {
	ListView listView;
	OrganizationActivityAdapter adap;
	String[] value;
	public static OrgActivityFragment newInstance() {
		OrgActivityFragment fragment = new OrgActivityFragment();
		return fragment;
	}

	public OrgActivityFragment() {
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
		View v= inflater.inflate(R.layout.fragment_org_activity, container, false);
		listView=(ListView) v.findViewById(R.id.listView);
		initActivity();
		listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Toast.makeText(getContext(), adap.getItem(position).getTitle(), Toast.LENGTH_SHORT).show();
			}
		});
		return v;
	}

	void initActivity(){
		Calendar cal = Calendar.getInstance();
		cal.set(2016,3,15,9,0);

		ArrayList<Activity> arrActivity = new ArrayList<>();
		for (int i=0; i<5;i++){
			cal.set(2016,i+2,15+i,9,0);
			Activity e=new Activity("activity","me","","Agatha Cynthia", cal, "Parental Meeting",
					"Diamond Hall" + i, cal, cal);
			e.setDescription("Parents can have a talk with the teachers to know " +
					"better about their children activities and improvements in school");
			arrActivity.add(e);
		}
		adap= new OrganizationActivityAdapter(getContext(), arrActivity);
		listView.setAdapter(adap);
	}
}
