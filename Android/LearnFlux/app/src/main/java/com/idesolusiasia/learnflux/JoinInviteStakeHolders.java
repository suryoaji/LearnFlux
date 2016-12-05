package com.idesolusiasia.learnflux;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * Created by Kuroko on 11/28/2016.
 */

public class JoinInviteStakeHolders extends BaseActivity {
        Button join, inviteCollaborator;
        EditText projectStart, projectEnd;
        LinearLayout linear, linearTask;
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
        getSupportActionBar().setDisplayHomeAsUpEnabled(false);

        join = (Button)findViewById(R.id.buttonJoinGroup);
        linearTask = (LinearLayout)findViewById(R.id.layoutInviteandJoin);
        inviteCollaborator = (Button)findViewById(R.id.buttonInviteCollaborator);
        projectStart = (EditText) findViewById(R.id.startJoinProjectTask);
        projectEnd = (EditText) findViewById(R.id.endJoinProjectTask);
        linear =  (LinearLayout)findViewById(R.id.teamMemberLayout);
        projectStart.setFocusable(false); projectStart.setClickable(true);
        projectEnd.setFocusable(false); projectEnd.setClickable(true);
        final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("EEEE, dd MMM yyyy", Locale.US);
        final Calendar calendar = Calendar.getInstance();
        projectStart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog datePickerDialog = new DatePickerDialog(JoinInviteStakeHolders.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker datePicker, int year, int monthOfYear, int dayOfMonth) {
                        calendar.set(year,monthOfYear,dayOfMonth);
                        projectStart.setText(simpleDateFormat.format(calendar.getTime()));
                    }
                }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH));
                datePickerDialog.show();
            }
        });
        projectEnd.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatePickerDialog datePickerDialog = new DatePickerDialog(JoinInviteStakeHolders.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker datePicker, int year, int monthOfYear, int dayOfMonth) {
                        calendar.set(year,monthOfYear,dayOfMonth);
                        projectEnd.setText(simpleDateFormat.format(calendar.getTime()));
                    }
                }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH));
                datePickerDialog.show();
            }
        });
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
