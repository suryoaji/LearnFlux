package com.idesolusiasia.learnflux.util;

import android.app.Dialog;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.EventChatBubble;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

public class OrgEventFragment extends Fragment {
	ListView listView;
	ArrayAdapter<String> adap;
	String[] value;
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
		listView=(ListView) v.findViewById(R.id.listView);
		value=new String[]{"Diamond Hall", "Swan Ballroom","Main Hall"};
		adap= new ArrayAdapter<String>(getContext(),R.layout.row_events,R.id.tvVenue,value);
		listView.setAdapter(adap);
		listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Calendar cal = Calendar.getInstance();
				cal.set(2016,3,15,9,0);
				EventChatBubble e = new EventChatBubble("event","me","","Agatha Cynthia", cal, "Parental Meeting",
						"Diamond Hall", "", cal, cal);
				eventDetails(e);
			}
		});
		return v;
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
			((RadioButton)dialog.findViewById(R.id.rbAttend)).setChecked(true);
		}else if (e.getAcceptanceStatus().equalsIgnoreCase("notAttend")){
			((RadioButton)dialog.findViewById(R.id.rbNotAttend)).setChecked(true);
		}

		rgEvent.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				if (checkedId==R.id.rbAttend){
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
					/*Intent i = new Intent(getContext(), EventChat.class);
					getContext().startActivity(i);*/
			}
		});

		dialog.show();
	}
}
