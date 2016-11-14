package com.idesolusiasia.learnflux;

import android.content.Context;
import android.support.v7.widget.LinearLayoutManager;

/**
 * Created by Ide Solusi Asia on 11/10/2016.
 */

public class CustomLinearLayoutManager extends LinearLayoutManager {
    private boolean isScrollEnabled = true;
    public CustomLinearLayoutManager(Context context, int orientation, boolean reverseLayout) {
        super(context, orientation, reverseLayout);

    }
    public void setScrollEnabled(boolean flag) {
        this.isScrollEnabled = flag;
    }
    @Override
    public boolean canScrollHorizontally() {
        return isScrollEnabled && canScrollHorizontally();
    }
}