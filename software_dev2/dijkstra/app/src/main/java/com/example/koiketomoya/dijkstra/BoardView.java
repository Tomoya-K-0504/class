package com.example.koiketomoya.dijkstra;

import android.content.Context;
import android.content.Intent;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PointF;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Toast;

import java.util.List;
import java.util.ArrayList;

public class BoardView extends View {

    ArrayList<PointF> points;
    Paint bluePaint = new Paint();
    Context context;

    public BoardView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        points = new ArrayList<>();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        bluePaint.setColor(Color.BLUE);
        for(PointF point: points) {
            canvas.drawCircle(point.x, point.y, 10, bluePaint);
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent e) {
        if (e.getAction() == MotionEvent.ACTION_DOWN) {
            PointF point = new PointF(e.getX(), e.getY());
            points.add(point);
            invalidate();
        }
        return true;
    }

    public void reset() {
        points.clear();
        invalidate();
    }

    public void solve(Context context) {
        Solver solver = new Solver();
        solver.setupBoard(points);
        Double distance = solver.solve();
        Toast toast = Toast.makeText(context, distance.toString(), Toast.LENGTH_LONG);
        toast.show();
        invalidate();
    }
}
