package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageView;

import com.idesolusiasia.learnflux.R;

import java.util.List;

/**
 * Created by NAIT ADMIN on 29/04/2016.
 */
public class AddPollAnswerAdapter extends ArrayAdapter<String> {
	List<String> list=null;

	public AddPollAnswerAdapter(Context context, int resource, List<String> list) {
		super(context, resource,list);
		this.list = list;
	}

	@Override
	public String getItem(int position) {
		if (list!=null){
			if (list.size()>0 && position>=0){
				return list.get(position);
			}
		}
		return null;
	}

	public List<String> getList() {
		return list;
	}

	@Override
	public View getView(final int position, View conView, ViewGroup parent) {

		final String s = list.get(position);
		LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);

		conView=inflater.inflate(R.layout.row_poll_answer,null);
		EditText etAnswer = (EditText) conView.findViewById(R.id.editText);
		ImageView deleteAnswer = (ImageView) conView.findViewById(R.id.ivClose);
		etAnswer.setText(list.get(position));

		etAnswer.addTextChangedListener(new TextWatcher() {
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {

			}

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {

			}

			@Override
			public void afterTextChanged(Editable e) {
				changeAnswer(e.toString(),position);
			}
		});

		deleteAnswer.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				list.remove(position);
				notifyDataSetChanged();
			}
		});

		return conView;


	}

	void changeAnswer(String answer, int position){
		list.set(position,answer);
	}
}
