package com.idesolusiasia.learnflux;


import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;


/**
 * A simple {@link Fragment} subclass.
 */
public class ChatroomFragment extends Fragment {


	public ChatroomFragment() {
		// Required empty public constructor
	}
	public static ChatroomFragment newInstance() {
		ChatroomFragment fragment = new ChatroomFragment();
		return fragment;
	}


	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
	                         Bundle savedInstanceState) {
		// Inflate the layout for this fragment
		View v = inflater.inflate(R.layout.fragment_chatroom, container, false);
		LinearLayout chatroom1 = (LinearLayout) v.findViewById(R.id.chatroom_1);
		chatroom1.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent i = new Intent(getActivity(), ChattingActivity.class);
				startActivity(i);
			}
		});

		return v;
	}

}
