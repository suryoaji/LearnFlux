package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;

/**
 * Created by Ide Solusi Asia on 10/4/2016.
 */

public class NewInterestGroup extends BaseActivity{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_base);
        super.onCreateDrawer(savedInstanceState);

        FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
        final LayoutInflater layoutInflater = LayoutInflater.from(this);
        View childLayout = layoutInflater.inflate(
                R.layout.new_interestgroups, null);
        parentLayout.addView(childLayout);
    }
}
