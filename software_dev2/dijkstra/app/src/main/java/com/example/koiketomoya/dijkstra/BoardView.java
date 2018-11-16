package com.example.koiketomoya.dijkstra;

import android.content.Context;
import android.content.Intent;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PointF;
import com.example.koiketomoya.dijkstra.MyPoint;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Toast;

import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.ArrayList;

import static android.content.ContentValues.TAG;
import static android.content.Context.MODE_PRIVATE;

public class BoardView extends View {

    ArrayList<MyPoint> points;
    Paint bluePaint = new Paint();

    public BoardView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        points = new ArrayList<>();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        bluePaint.setColor(Color.BLUE);
        for(MyPoint point: points) {
            canvas.drawCircle(point.x, point.y, 10, bluePaint);
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent e) {
        if (e.getAction() == MotionEvent.ACTION_DOWN) {
            MyPoint point = new MyPoint(e.getX(), e.getY());
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

//        pointsが2つ以上ないとエラーになるので、何もせず返す
        if (points.size() < 2) {
            Toast toast = Toast.makeText(context, "ポイントを2点以上描画してください", Toast.LENGTH_LONG);
            toast.show();
        } else {
            Solver solver = new Solver();
            solver.setupBoard(points);
            Double distance = solver.solve();
            Toast toast = Toast.makeText(context, distance.toString(), Toast.LENGTH_LONG);
            toast.show();
            invalidate();
        }
    }

    public void save(Context context) {
        try {
            FileOutputStream fos = context.openFileOutput("SaveData.txt", MODE_PRIVATE);
            ObjectOutputStream oos = new ObjectOutputStream(fos);
            oos.writeObject(points);
            oos.close();
            Toast toast = Toast.makeText(context, "saveされました", Toast.LENGTH_LONG);
            toast.show();
        } catch (Exception e) {
            Log.d(TAG, "Error");
        }
    }

    public void load(Context context) {
        try {
            FileInputStream fis = context.openFileInput("SaveData.txt");
            ObjectInputStream ois = new ObjectInputStream(fis);
            points = (ArrayList<MyPoint>) ois.readObject();
            ois.close();
            Toast toast = Toast.makeText(context, "loadされました", Toast.LENGTH_LONG);
            toast.show();
            invalidate();
        } catch (Exception e) {
            Log.d(TAG, "Error");
        }
    }


}
