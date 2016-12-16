package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.idesolusiasia.learnflux.Comments;
import com.idesolusiasia.learnflux.R;

import java.util.ArrayList;

/**
 * Created by Ide Solusi Asia on 11/25/2016.
 */

public class ProjectProfileCommentAdapter extends RecyclerView.Adapter<ProjectProfileCommentAdapter.ProfileHolder> {

    public Context mContext;
    public ArrayList<String>com = new ArrayList<>();
    public ProjectProfileCommentAdapter(Context context, ArrayList<String>comm){
        this.com= comm;
        this.mContext=context;
    }


    @Override
    public ProjectProfileCommentAdapter.ProfileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_profile_comment,null);
        ProfileHolder rcv =  new ProfileHolder(view);
        return rcv;
    }

    @Override
    public void onBindViewHolder(ProjectProfileCommentAdapter.ProfileHolder holder, int position) {
            holder.comments.setText(com.get(position));
            holder.cPage.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Intent i = new Intent(view.getContext(), Comments.class);
                    view.getContext().startActivity(i);
                }
            });
    }

    @Override
    public int getItemCount() {
        if(com!=null){
        return com.size();}
        return -1;
    }

    public class ProfileHolder extends RecyclerView.ViewHolder {
        TextView comments, cPage;

        public ProfileHolder(View itemView) {
            super(itemView);
            comments = (TextView)itemView.findViewById(R.id.rowComment);
            cPage = (TextView)itemView.findViewById(R.id.commentPage);
        }
    }
}
