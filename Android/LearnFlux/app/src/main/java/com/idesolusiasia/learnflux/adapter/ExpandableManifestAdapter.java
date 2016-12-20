package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.transition.TransitionManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.idesolusiasia.learnflux.JoinInviteStakeHolders;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Group;

import java.util.ArrayList;

/**
 * Created by Kuroko on 12/6/2016.
 */

public class ExpandableManifestAdapter extends RecyclerView.Adapter<ExpandableManifestAdapter.TestHolder>{
    public Context mContext;
    public ArrayList<Group> group;
    public int mExpandedPosition = -1;
    String visible = "none";

    public ExpandableManifestAdapter(Context context, ArrayList<Group>groups){
        this.mContext=context;
        this.group=groups;
    }

    @Override
    public TestHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_manifest,null);
        TestHolder tst = new TestHolder(view);
        return tst;
    }

    @Override
    public void onBindViewHolder(final TestHolder holder, final int position) {
        final Group g = group.get(position);
        holder.name.setText(g.getName());
        holder.checkButton.setTag(position);
        final boolean isExpanded = position ==mExpandedPosition;
        holder.layoutLinear.setVisibility(isExpanded?View.VISIBLE:View.GONE);
        holder.layoutLinear.setActivated(isExpanded);
        holder.checklist.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mExpandedPosition = isExpanded ? -1:position;
                TransitionManager.beginDelayedTransition(holder.layoutLinear);
                holder.remark.setText(g.getAccess());
                notifyDataSetChanged();
                /*holder.layoutLinear.setVisibility(View.VISIBLE);
                holder.remark.setText(g.getName());*/
            }
        });
    }

    @Override
    public int getItemCount() {
        return group.size();
    }

    public class TestHolder extends RecyclerView.ViewHolder {
        ImageView checklist, checkButton;
        LinearLayout layoutLinear;
        TextView remark, name;
        public TestHolder(View itemView) {
            super(itemView);
            checklist = (ImageView)itemView.findViewById(R.id.arrowRemarks);
            layoutLinear = (LinearLayout)itemView.findViewById(R.id.linearRemarks);
            remark = (TextView)itemView.findViewById(R.id.remarksText);
            name = (TextView)itemView.findViewById(R.id.manifestId);
            checkButton =  (ImageView)itemView.findViewById(R.id.checkList);
            checkButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    int pos = getAdapterPosition();
                    if(visible.equalsIgnoreCase("none")){
                        checkButton.getTag();
                       checkButton.setImageResource(R.drawable.ic_check_box_green);
                        visible="true";
                    }else{
                       checkButton.setImageResource(R.drawable.ic_uncheckable);
                        visible="none";
                    }

                }
            });
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                   Intent profile = new Intent(view.getContext(), JoinInviteStakeHolders.class);
                   profile.putExtra("toolbar", "Profile");
                   view.getContext().startActivity(profile);
                }
            });
        }
    }
}
