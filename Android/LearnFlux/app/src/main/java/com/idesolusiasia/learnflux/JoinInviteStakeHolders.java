package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.text.DateFormat;
import java.util.Date;

/**
 * Created by Kuroko on 11/28/2016.
 */

public class JoinInviteStakeHolders extends BaseActivity {
        Button join, inviteCollaborator;
        TextView projectStart, projectEnd;
        LinearLayout linear;
        Toolbar toolbar;
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

        String a = getIntent().getStringExtra("toolbar");
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        join = (Button)findViewById(R.id.buttonJoinGroup);
        inviteCollaborator = (Button)findViewById(R.id.buttonInviteCollaborator);
        projectStart = (TextView)findViewById(R.id.startJoinProjectTask);
        projectEnd = (TextView)findViewById(R.id.endJoinProjectTask);
        linear =  (LinearLayout)findViewById(R.id.teamMemberLayout);

        String currentDateString = DateFormat.getDateInstance().format(new Date());
        projectStart.setText(currentDateString);
        projectEnd.setText(currentDateString);

        if(a.contains("join")){
            toolbar.setTitle("Join Group");
            join.setVisibility(View.VISIBLE);

        }else if(a.contains("invite")){
            toolbar.setTitle("Invite Collaborators for project");
            inviteCollaborator.setVisibility(View.VISIBLE);
            inviteCollaborator.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Intent i = new Intent(JoinInviteStakeHolders.this, InvitePeople.class);
                    startActivity(i);
                }
            });
        }


    }

}
