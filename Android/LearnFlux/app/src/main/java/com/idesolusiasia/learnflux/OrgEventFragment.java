package com.idesolusiasia.learnflux;

import android.app.Dialog;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.adapter.OrganizationEventAdapter;
import com.idesolusiasia.learnflux.entity.Event;
import com.idesolusiasia.learnflux.entity.EventChatBubble;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.ItemOffsetDecoration;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

public class OrgEventFragment extends Fragment {
	RecyclerView recyclerView;
	OrganizationEventAdapter adap;
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
		lLayout = new GridLayoutManager(getContext(),1);
		recyclerView.setLayoutManager(lLayout);
		ItemOffsetDecoration itemDecoration = new ItemOffsetDecoration(getContext(), R.dimen.item_offset);
		recyclerView.addItemDecoration(itemDecoration);
		id = getActivity().getIntent().getStringExtra("id");
		//initEvent();
		getEventByGroupID();
		/*recyclerView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				//Toast.makeText(getContext(), adap.getItem(position).getTitle(), Toast.LENGTH_SHORT).show();
			}
		});*/
		return v;
	}
	void getEventByGroupID(){
		events = new ArrayList<>();
		Engine.getGroupEventByGroupId(getContext(), id, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					JSONArray data = obj.getJSONArray("data");
					for(int i=0;i<data.length();i++){
						Event event = Converter.convertEvent(data.getJSONObject(i));
						events.add(event);
					}
				}catch (JSONException e){
					e.printStackTrace();
				}
				adap = new OrganizationEventAdapter(getContext(),events);
				recyclerView.setAdapter(adap);
			}
		});
	}
	/*void initEvent(){
		Calendar cal = Calendar.getInstance();
		cal.set(2016,3,15,9,0);

		ArrayList<EventChatBubble> arrEvent = new ArrayList<>();
		for (int i=0; i<5;i++){
			cal.set(2016,i+2,15+i,9,0);
			EventChatBubble e=new EventChatBubble("event","me","","Agatha Cynthia", cal, "Parental Meeting",
					"Diamond Hall" + i, "", cal, cal);
			e.setDescription("Parents can have a talk with the teachers to know " +
					"better about their children activities and improvements in school");
			arrEvent.add(e);
		}
		adap= new OrganizationEventAdapter(getContext(), arrEvent);
		listView.setAdapter(adap);
	}

	void eventDetails(final EventChatBubble e){
		Log.i("event", "eventDetails: clicked");
		Log.i("event", "eventDetails: "+e.getAcceptanceStatus());

		final Dialog dialog = new Dialog(getContext());
		//dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setTitle("Event Detail");

		dialog.setContentView(R.layout.dialog_event_detail);
		final TextView tvTitle = (TextView) dialog.findViewById(R.id.tvTitle);
		final TextView tvDate = (TextView) dialog.findViewById(R.id.tvDate);
		final TextView tvTime = (TextView) dialog.findViewById(R.id.tvTime);
		final TextView tvLocation = (TextView) dialog.findViewById(R.id.tvLocation);
		final SimpleDateFormat dateFormatter = new SimpleDateFormat("EEEE, dd MMM yyyy", Locale.US);
		final SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm", Locale.US);
		RadioGroup rgEvent = (RadioGroup) dialog.findViewById(R.id.rgEvent);
		Button btnOK = (Button) dialog.findViewById(R.id.btnOK);
		Button btnChatRoom = (Button) dialog.findViewById(R.id.btnChatRoom);


		tvTitle.setText(e.getTitle());
		tvDate.setText(dateFormatter.format(e.getTimeStart().getTime()));
		tvTime.setText(timeFormatter.format(e.getTimeStart().getTime()) + " - " + timeFormatter.format(e.getTimeEnd().getTime()));
		tvLocation.setText("at " + e.getLocation());

		if (e.getAcceptanceStatus().equalsIgnoreCase("attend")){
			((RadioButton)dialog.findViewById(R.id.rbGoing)).setChecked(true);
		}else if (e.getAcceptanceStatus().equalsIgnoreCase("notAttend")){
			((RadioButton)dialog.findViewById(R.id.rbNotGoing)).setChecked(true);
		}

		rgEvent.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				if (checkedId==R.id.rbGoing){
					e.setAcceptanceStatus("attend");
				}else{
					e.setAcceptanceStatus("notAttend");
				}

				Toast.makeText(getContext(), "Thanks for your response", Toast.LENGTH_SHORT).show();
			}
		});

		btnOK.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
			}
		});

		btnChatRoom.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Toast.makeText(getContext(), "openChatroom", Toast.LENGTH_SHORT).show();
					*//*Intent i = new Intent(getContext(), EventChat.class);
					getContext().startActivity(i);*//*
			}
		});

		dialog.show();
	}*/
}
