package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.graphics.Color;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Participant;

import java.util.List;

/**
 * Created by Ide Solusi Asia on 8/19/2016.
 */
public class AddGroupAdapter extends ArrayAdapter<Participant> {
    List<Participant> participants;
    private Context context;
    LayoutInflater inflater;
    private SparseBooleanArray mSelectedItemsIds;
    public AddGroupAdapter(Context context, int ResourceId, List<Participant> participants) {
        super(context, ResourceId, participants);
        mSelectedItemsIds = new SparseBooleanArray();
        this.context=context;
        this.participants=participants;
        inflater = LayoutInflater.from(context);
    }
    private class ViewHolder {
        ImageView ivPhoto;
        TextView tvName;
        ImageView ivCheck;
        public Participant mItem;
    }

    public View getView(int position, View view, ViewGroup parent) {
        final ViewHolder holder;
        if (view == null) {
            holder = new ViewHolder();
            view = inflater.inflate(R.layout.row_people, null);
            // Locate the TextViews in listview_item.xml
            holder.ivPhoto = (ImageView) view.findViewById(R.id.ivPhoto);
            holder.tvName = (TextView) view.findViewById(R.id.tvName);
            holder.ivCheck = (ImageView) view.findViewById(R.id.ivCheck);
            view.setTag(holder);
        } else {
            holder = (ViewHolder) view.getTag();
        }
        // Capture position and set to the TextViews
        holder.mItem = participants.get(position);
        holder.tvName.setText(participants.get(position).getFirstName());
        holder.tvName.setTextColor(Color.parseColor("#000000"));
        return view;
    }

    @Override
    public void remove(Participant object) {
        participants.remove(object);
        notifyDataSetChanged();
    }

    public List<Participant> getWorldPopulation() {
        return participants;
    }

    public void toggleSelection(int position) {
        selectView(position, !mSelectedItemsIds.get(position));
    }

    public void removeSelection() {
        mSelectedItemsIds = new SparseBooleanArray();
        notifyDataSetChanged();
    }

    public void selectView(int position, boolean value) {
        if (value)
            mSelectedItemsIds.put(position, value);
        else
            mSelectedItemsIds.delete(position);
        notifyDataSetChanged();
    }

    public int getSelectedCount() {
        return mSelectedItemsIds.size();
    }

    public SparseBooleanArray getSelectedIds() {
        return mSelectedItemsIds;
    }
}
