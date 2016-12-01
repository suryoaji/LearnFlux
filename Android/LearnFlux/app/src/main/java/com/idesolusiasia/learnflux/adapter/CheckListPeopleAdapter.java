package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.PeopleInvite;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 11/15/2016.
 */

public class CheckListPeopleAdapter extends RecyclerView.Adapter<CheckListPeopleAdapter.PeopleTileHolder> {
    private Context context;
    private ArrayList<PeopleInvite>people;

    public CheckListPeopleAdapter(Context mContext, ArrayList<PeopleInvite>participant){
        this.context=mContext;
        this.people=participant;
    }
    @Override
    public CheckListPeopleAdapter.PeopleTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rcv = LayoutInflater.from(parent.getContext()).inflate(R.layout.activity_invite_people,null);
        PeopleTileHolder view = new PeopleTileHolder(rcv);
        return view;
    }

    @Override
    public void onBindViewHolder(CheckListPeopleAdapter.PeopleTileHolder holder, int position) {
            final PeopleInvite p = people.get(position);
            holder.tvName.setText(p.getFirst_name());
            holder.chkSelected.setChecked(p.isSelected());
            holder.chkSelected.setTag(p);
           /* holder.chkSelected.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    CheckBox cb = (CheckBox) v;
                    PeopleInvite pi = (PeopleInvite)cb.getTag();
                    pi.setSelected(cb.isChecked());
                    p.setSelected(cb.isChecked());
                }
            });*/
    }

    @Override
    public int getItemCount() {
        return people.size();
    }

    public class PeopleTileHolder extends RecyclerView.ViewHolder {
        public TextView tvName;
        public CheckBox chkSelected;
        public PeopleInvite invite;

        public PeopleTileHolder(View itemView) {
            super(itemView);
            tvName = (TextView) itemView.findViewById(R.id.tvName);
            chkSelected = (CheckBox) itemView.findViewById(R.id.chkSelected);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    final int pos = getAdapterPosition();
                    PeopleInvite iv = (PeopleInvite)chkSelected.getTag();
                    chkSelected.setChecked(!chkSelected.isChecked());
                    iv.setSelected(!chkSelected.isChecked());
                    people.get(pos).setSelected(chkSelected.isChecked());

                   /* PeopleInvite pi = (PeopleInvite)chkSelected.getTag();
                    pi.setSelected(chkSelected.isChecked());
                    people.get(pos).setSelected(chkSelected.isChecked());*/
                }
            });
        }
    }
    public List<PeopleInvite> getInvitePeople(){
        return people;
    }
}
