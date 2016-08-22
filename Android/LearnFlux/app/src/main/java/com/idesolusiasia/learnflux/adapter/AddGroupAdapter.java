package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Activity;
import com.idesolusiasia.learnflux.entity.AndroidVersionName;
import com.idesolusiasia.learnflux.entity.Participant;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 8/19/2016.
 */
public class AddGroupAdapter extends BaseAdapter {
    List<Participant> participants;
    private Context context;
    private static LayoutInflater inflater= null;
    public AddGroupAdapter(Context context,  List<Participant> participants) {
        inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        return participants.size();
    }

    @Override
    public Object getItem(int i) {
        return null;
    }

    @Override
    public long getItemId(int i) {
        return 0;
    }

    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {
        return null;
    }
}
