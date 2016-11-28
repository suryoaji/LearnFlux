package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;

/**
 * Created by Kuroko on 11/28/2016.
 */

public class JoinInviteStakeHolders extends BaseActivity {
        Button join, inviteCollaborator;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_base);
        super.onCreateDrawer(savedInstanceState);

        final FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
        final LayoutInflater layoutInflater = LayoutInflater.from(this);
        View childLayout = layoutInflater.inflate(
                R.layout.activity_join_invite_project, null);
        parentLayout.addView(childLayout);

        join = (Button)findViewById(R.id.buttonJoinGroup);
        inviteCollaborator = (Button)findViewById(R.id.buttonInviteCollaborator);
        String a = getIntent().getStringExtra("toolbar");

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        if(a.contains("firstTool")){
            toolbar.setTitle("Join Group");
            join.setVisibility(View.VISIBLE);
        }else if(a.contains("secondTool")){
            toolbar.setTitle("Invite Collaborators for project");
            inviteCollaborator.setVisibility(View.VISIBLE);
        }


    }
}
