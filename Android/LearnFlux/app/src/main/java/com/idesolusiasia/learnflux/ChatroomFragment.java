package com.idesolusiasia.learnflux;


import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.ActionMode;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListView;

import com.idesolusiasia.learnflux.adapter.ThreadAdapter;
import com.idesolusiasia.learnflux.entity.Converter;
import com.idesolusiasia.learnflux.entity.Thread;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;


/**
 * A simple {@link Fragment} subclass.
 */
public class ChatroomFragment extends Fragment {

	ListView listView;
	ThreadAdapter adap;

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
		listView = (ListView) v.findViewById(R.id.listView);
		listView.setEmptyView(v.findViewById(R.id.empty));

		listView.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE_MODAL);
		listView.setMultiChoiceModeListener(new AbsListView.MultiChoiceModeListener() {

			@Override
			public void onItemCheckedStateChanged(ActionMode mode, int position,
			                                      long id, boolean checked) {
				// Here you can do something when items are selected/de-selected,
				// such as update the title in the CAB
				adap.getItem(position).setSelected(checked);
				adap.notifyDataSetChanged();
			}

			@Override
			public boolean onActionItemClicked(ActionMode mode, MenuItem item) {
				// Respond to clicks on the actions in the CAB
				switch (item.getItemId()) {
					case R.id.delete_items:
						//deleteSelectedItems();
						deleteThreads();
						mode.finish(); // Action picked, so close the CAB
						return true;
					default:
						return false;
				}
			}

			@Override
			public boolean onCreateActionMode(ActionMode mode, Menu menu) {
				// Inflate the menu for the CAB
				MenuInflater inflater = getActivity().getMenuInflater();
				inflater.inflate(R.menu.delete, menu);
				return true;
			}

			@Override
			public void onDestroyActionMode(ActionMode mode) {
				// Here you can make any necessary updates to the activity when
				// the CAB is removed. By default, selected items are deselected/unchecked.
				adap.clearSelection();
				adap.notifyDataSetChanged();
			}

			@Override
			public boolean onPrepareActionMode(ActionMode mode, Menu menu) {
				// Here you can perform updates to the CAB due to
				// an invalidate() request
				return false;
			}
		});

		listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Intent i= new Intent(getContext(),ChattingActivity.class);
				i.putExtra("idThread",adap.getItem(position).getId());
				startActivity(i);
				Log.i("Chatroom", adap.getItem(position).getTitle());
			}
		});

		Engine.getThreads(getContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try {
					JSONArray array = obj.getJSONArray("data");
					ArrayList<Thread> arrThread = new ArrayList<Thread>();
					for(int i=0;i<array.length();i++){
						arrThread.add(Converter.convertThread(array.getJSONObject(i)));
					}
					adap = new ThreadAdapter(getContext(),arrThread);
					listView.setAdapter(adap);

				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		});

		return v;
	}

	void deleteThreads(){
		List<Thread> deleted = new ArrayList<Thread>();
		List<Thread> arrAdap = adap.threadList;

		for(Thread t:arrAdap){
			if (t.isSelected()){
				deleted.add(t);
			}
		}
		arrAdap.removeAll(deleted);
		adap.notifyDataSetChanged();
		Engine.deleteThread(getContext(), deleted, null);
	}

}
