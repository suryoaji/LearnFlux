package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.idesolusiasia.learnflux.activity.ProjectActivity;
import com.idesolusiasia.learnflux.R;

import java.util.ArrayList;

/**
 * Created by Ide Solusi Asia on 11/18/2016.
 */

public class ProjectListAdapter extends RecyclerView.Adapter<ProjectListAdapter.ProjectHolder> {
    public Context mContext;
    ArrayList<String>title;
    String visible = "none";
    String visible2 = "none";

    public ProjectListAdapter(Context context, ArrayList<String>name){
        this.title=name;
        this.mContext=context;
    }
    @Override
    public ProjectHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_project_list,null);
        ProjectHolder rcv = new ProjectHolder(view);
        return rcv;
    }

    @Override
    public void onBindViewHolder(final ProjectHolder holder, int position) {
        holder.projectTitle.setText(title.get(position));
        holder.projectRanking.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(visible.equalsIgnoreCase("none")) {
                    holder.projectRanking.setImageResource(R.drawable.ribbon_gold);
                    visible = "ribbon";
                }else{
                    holder.projectRanking.setImageResource(R.drawable.ribbon_grey);
                    visible ="none";
                }
            }
        });
        holder.projectFinish.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(visible2.equalsIgnoreCase("none")){
                    holder.projectFinish.setImageResource(R.drawable.thumbs_pressed);
                    visible2 ="thumbs";
                }else{
                    holder.projectFinish.setImageResource(R.drawable.thumb_grey);
                    visible2="none";
                }
            }
        });

    }

    @Override
    public int getItemCount() {
        return title.size();
    }

    public class
    ProjectHolder extends RecyclerView.ViewHolder {
        ImageView projectRanking, projectFinish;
        TextView projectTitle;
        public ProjectHolder(View itemView) {
            super(itemView);
            projectRanking = (ImageView)itemView.findViewById(R.id.projectRanking);
            projectFinish = (ImageView)itemView.findViewById(R.id.projectFinish);
            projectTitle = (TextView)itemView.findViewById(R.id.projectTitle);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Intent s = new Intent(view.getContext(), ProjectActivity.class);
                    s.putExtra("projectAct", "profiles");
                    view.getContext().startActivity(s);
                }
            });
        }
    }
}
