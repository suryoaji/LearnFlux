package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.graphics.Color;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.FriendReq;
import com.idesolusiasia.learnflux.entity.Participant;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 8/19/2016.
 */
public class AddGroupAdapter extends BaseAdapter{
    List<FriendReq> participants;
    private Context ctx;
    LayoutInflater inflater;

    public AddGroupAdapter(Context context, ArrayList<FriendReq> participant){
        ctx = context;
        participants = participant;
        inflater = (LayoutInflater) ctx
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        return participants.size();
    }
    @Override
    public Object getItem(int position) {
        return participants.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View view = convertView;
        if(view==null){
            view = inflater.inflate(R.layout.row_layout,parent,false);
        }
        FriendReq p = getParticipant(position);
        ((TextView) view.findViewById(R.id.tvVersionName)).setText(p.getFirst_name());
        CheckBox cbBuy = (CheckBox) view.findViewById(R.id.checkBox1);
        cbBuy.setOnCheckedChangeListener(myCheckChangList);
        cbBuy.setTag(position);
        cbBuy.setChecked(p.box);
        return view;
    }
    FriendReq getParticipant(int position) {
        return ((FriendReq) getItem(position));
    }
    public ArrayList<FriendReq> getBox() {
        ArrayList<FriendReq> box = new ArrayList<FriendReq>();
        for (FriendReq p : participants) {
            if (p.box)
                box.add(p);
        }
        return box;
    }
    CompoundButton.OnCheckedChangeListener myCheckChangList = new CompoundButton.OnCheckedChangeListener() {
        public void onCheckedChanged(CompoundButton buttonView,
                                     boolean isChecked) {
            getParticipant((Integer) buttonView.getTag()).box = isChecked;
        }
    };
}
