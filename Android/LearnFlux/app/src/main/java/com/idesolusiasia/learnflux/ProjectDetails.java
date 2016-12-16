package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.icu.text.SimpleDateFormat;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * Created by Ide Solusi Asia on 11/21/2016.
 */

public class ProjectDetails extends BaseActivity {
TextView projectStart,projectEnd, projectDuration;
    ImageView editDetails;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_base);
        super.onCreateDrawer(savedInstanceState);

        final FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
        final LayoutInflater layoutInflater = LayoutInflater.from(this);
        View childLayout = layoutInflater.inflate(
                R.layout.activity_project_details, null);
        parentLayout.addView(childLayout);

        projectStart = (TextView)findViewById(R.id.startProject);
        projectEnd = (TextView)findViewById(R.id.endProject);
        projectDuration = (TextView)findViewById(R.id.durationProject);
        editDetails = (ImageView)findViewById(R.id.projectEdit);

        String currentDateTimeString = DateFormat.getDateInstance().format(new Date());
        projectStart.setText(currentDateTimeString);
        projectEnd.setText(currentDateTimeString);
        projectDuration.setText("48 weeks");

        editDetails.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(ProjectDetails.this, ProjectEdit.class);
                startActivity(i);
            }
        });

    }
}
